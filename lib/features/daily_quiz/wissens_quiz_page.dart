import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../ui/widgets/confetti.dart';
import '../zimmer/achievements_repository.dart';
import '../../ui/widgets/glossar_text.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../settings/settings_repository.dart';
import '../xp/xp_repository.dart';
import 'quiz_pool.dart';
import 'quiz_question.dart';
import 'quiz_topics.dart';
import 'wissens_quiz_stats.dart';

/// Spec-43 v4: Wissens-Quiz-Modus.
///
/// Spieler bekommt 10 zufällige Fragen aus [kQuizPool]. Bei jeder
/// Frage 2 Versuche. Am Ende: Win-Rate + XP-Reward.
///
/// Round 28 v4: [expertMode] = Meisterprüfung — nur schwere Fragen, höhere
/// XP, „Professor"-Trophäe ab 9/10.
class WissensQuizPage extends ConsumerStatefulWidget {
  const WissensQuizPage({super.key, this.expertMode = false});

  final bool expertMode;

  @override
  ConsumerState<WissensQuizPage> createState() => _WissensQuizPageState();
}

class _WissensQuizPageState extends ConsumerState<WissensQuizPage> {
  static const int _questionCount = 10;
  late final List<MultipleChoiceQuestion> _questions;
  int _qIdx = 0;
  int _correct = 0;
  int? _picked;
  final Set<int> _wrongPicks = <int>{};
  bool _finalised = false;
  bool _firstTry = true;
  bool _showConfetti = false;

  final Set<String> _sessionMastered = <String>{};
  final Set<String> _sessionWrong = <String>{};

  @override
  void initState() {
    super.initState();
    final all = kQuizPool.whereType<MultipleChoiceQuestion>().toList();

    // Round 28 v4: Meisterprüfung — nur schwere Fragen, einfach gemischt.
    if (widget.expertMode) {
      final hard = all.where((q) => q.tier == QuizTier.hard).toList()
        ..shuffle(math.Random());
      // L9 (Analyse 2026-08): `take(_questionCount)` liefert stillschweigend
      // weniger, wenn der Hard-Pool schrumpft — und dann rechnet die
      // Auswertung „≥ 9 von 10" gegen eine kürzere Runde, der Professor-Titel
      // wäre unerreichbar. Bei 0 Hard-Fragen käme sogar ein leeres Quiz
      // heraus (RangeError beim ersten Zugriff, Division durch 0 in der
      // Auswertung). Heute sind es 12 Fragen, das ist also latent — aber der
      // Pool wird laufend umgebaut. Fehlende Fragen werden mit den nächst-
      // schweren aufgefüllt.
      final picked = hard.take(_questionCount).toList();
      if (picked.length < _questionCount) {
        final filler = all
            .where((q) => q.tier != QuizTier.hard && !picked.contains(q))
            .toList()
          ..shuffle(math.Random());
        picked.addAll(filler.take(_questionCount - picked.length));
      }
      _questions = picked;
      return;
    }

    final stats = ref.read(wissensQuizStatsRepoProvider);

    // Round 27 v6: Anti-Repeat. Wenn fast der ganze Pool schon „gesehen"
    // ist (kein Platz mehr für _questionCount frische), Set zurücksetzen.
    var seen = stats.seenTexts;
    if (all.length - seen.length < _questionCount) {
      ref.read(wissensQuizStatsRepoProvider.notifier).resetSeen();
      seen = const {};
    }
    // Auch die zuletzt im Tages-Quiz gezeigten Fragen meiden (gegen
    // „Frage des Tages + Wissens-Quiz doppeln sich"). Pipe-separiert.
    final dailyRecent = {
      for (final t in ref
          .read(settingsRepositoryProvider)
          .recentQuizTextsCsv
          .split('|'))
        if (t.trim().isNotEmpty) t,
    };

    // Reihenfolge: zuerst früher falsch beantwortete (Lerneffekt), dann
    // ungesehene/frische, dann der Rest.
    final wrongPool = stats.wrongTexts;
    final priority = all.where((q) => wrongPool.contains(q.text)).toList()
      ..shuffle(math.Random());
    final fresh = all
        .where((q) =>
            !wrongPool.contains(q.text) &&
            !seen.contains(q.text) &&
            !dailyRecent.contains(q.text))
        .toList()
      ..shuffle(math.Random());
    final stale = all
        .where((q) =>
            !wrongPool.contains(q.text) &&
            (seen.contains(q.text) || dailyRecent.contains(q.text)))
        .toList()
      ..shuffle(math.Random());
    final ordered = [...priority, ...fresh, ...stale];
    _questions = ordered.take(_questionCount).toList();
  }

  MultipleChoiceQuestion get _current => _questions[_qIdx];

  void _pick(int index) {
    if (_finalised) return;
    if (_wrongPicks.contains(index)) return;
    final isCorrect = index == _current.correctIndex;
    if (isCorrect) {
      setState(() {
        _picked = index;
        _finalised = true;
        _showConfetti = _firstTry;
      });
      if (_firstTry) {
        _correct++;
        _sessionMastered.add(_current.text);
        // Welle-8 Round 14: Topic als gelernt markieren bei 1. Versuch.
        if (_current.topic.isNotEmpty) {
          ref
              .read(settingsRepositoryProvider.notifier)
              .addQuizLearnedTopic(_current.topic);
        }
      } else {
        // 2. Versuch richtig — bleibt als "noch nicht solide" markiert
        // bis 1. Versuch klappt.
        _sessionWrong.add(_current.text);
      }
      return;
    }
    if (_wrongPicks.isEmpty) {
      setState(() {
        _wrongPicks.add(index);
        _firstTry = false;
      });
    } else {
      setState(() {
        _wrongPicks.add(index);
        _picked = index;
        _finalised = true;
      });
      _sessionWrong.add(_current.text);
    }
  }

  void _next() {
    if (_qIdx + 1 >= _questions.length) {
      // Reward + Ende. Round 28 v4: Meisterprüfung gibt mehr XP pro richtige
      // Antwort (schwerere Fragen).
      final xp = _correct * (widget.expertMode ? 12 : 5);
      ref.read(xpRepositoryProvider.notifier).add(xp);
      ref.read(wissensQuizStatsRepoProvider.notifier).recordSession(
            correct: _correct,
            total: _questions.length,
            newlyMastered: _sessionMastered,
            newlyWrong: _sessionWrong,
            shownTexts: {for (final q in _questions) q.text},
          );
      // Round 27 v5: Zimmer-Trophäen fürs Wissens-Quiz. `unlock()` feuert
      // den Toast/Confetti-Emitter selbst (achievements_repository) → KEIN
      // manuelles fire() mehr (Round 28 v4: behob doppelten Popup/SFX).
      final dayIdx = ref.read(gameClockProvider).dayIndex;
      final ach = ref.read(achievementsRepositoryProvider.notifier);
      ach.unlock('wissensquiz_done', dayIdx);
      if (_correct == _questions.length) {
        ach.unlock('wissensquiz_perfect', dayIdx);
      }
      // Round 27 v8: quiz_streak_7 = ≥7 von 10 in einer Runde.
      // L9: an der tatsächlichen Rundenlänge gemessen, nicht an einer
      // angenommenen 10 — sonst wäre die Trophäe bei einer kürzeren Runde
      // unerreichbar.
      final total = _questions.length;
      if (_correct >= (total * 0.7).ceil()) {
        ach.unlock('quiz_streak_7', dayIdx);
      }
      // Round 28 v4: „Professor"-Trophäe — Meisterprüfung mit ≥90 %.
      if (widget.expertMode && _correct >= (total * 0.9).ceil()) {
        ach.unlock('quiz_professor', dayIdx);
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => _WissensQuizResultPage(
            correct: _correct,
            total: _questions.length,
            expertMode: widget.expertMode,
          ),
        ),
      );
      return;
    }
    setState(() {
      _qIdx++;
      _picked = null;
      _wrongPicks.clear();
      _finalised = false;
      _firstTry = true;
      _showConfetti = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // L9: leerer Fragen-Pool darf keinen RangeError werfen. Kann nur
    // passieren, wenn der Katalog leergeräumt wird — dann lieber ein Satz
    // Text als ein Absturz.
    if (_questions.isEmpty) {
      return PhoneFrame(
        appName: 'Wissens-Quiz',
        onBack: () => Navigator.of(context).pop(),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(FgSpacing.xl),
            child: Text(
              'Gerade sind keine Fragen verfügbar. Schau später nochmal '
              'rein.',
              style: FgTypography.bodyM,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    final q = _current;
    return PhoneFrame(
      appName: '${widget.expertMode ? 'Meisterprüfung' : 'Wissens-Quiz'} · '
          '${_qIdx + 1}/${_questions.length}',
      onBack: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(FgSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(FgSpacing.m),
                  decoration: BoxDecoration(
                    color: FgColors.backgroundDeep,
                    border: Border.all(color: FgColors.primary, width: 3),
                  ),
                  child: Text(
                    '❓ ${q.text}',
                    style: FgTypography.bodyL.copyWith(
                      color: FgColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: FgSpacing.m),
                Expanded(
                  child: ListView(
                    children: [
                      for (var i = 0; i < q.options.length; i++)
                        _OptionTile(
                          label: q.options[i],
                          index: i,
                          correctIndex: q.correctIndex,
                          picked: _picked,
                          wrongPicks: _wrongPicks,
                          finalised: _finalised,
                          onTap: (_finalised || _wrongPicks.contains(i))
                              ? null
                              : () => _pick(i),
                        ),
                      if (!_finalised && _wrongPicks.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: FgSpacing.s),
                          child: PixelPanel(
                            background:
                                FgColors.alert.withValues(alpha: 0.2),
                            padding: const EdgeInsets.all(FgSpacing.m),
                            child: const Text(
                              '❌ Falsch — du hast noch einen Versuch!',
                              style: FgTypography.bodyL,
                            ),
                          ),
                        ),
                      if (_finalised) ...[
                        const SizedBox(height: FgSpacing.s),
                        PixelPanel(
                          background: _picked == q.correctIndex
                              ? FgColors.success.withValues(alpha: 0.2)
                              : FgColors.alert.withValues(alpha: 0.2),
                          padding: const EdgeInsets.all(FgSpacing.m),
                          child: GlossarText(q.explanation,
                              style: FgTypography.bodyM),
                        ),
                      ],
                    ],
                  ),
                ),
                if (_finalised)
                  PixelButton(
                    label: _qIdx + 1 < _questions.length
                        ? 'Nächste Frage →'
                        : 'Auswertung',
                    background: FgColors.primary,
                    foreground: FgColors.onPrimary,
                    onPressed: _next,
                  ),
              ],
            ),
          ),
          if (_showConfetti) const IgnorePointer(child: ConfettiBurst()),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.index,
    required this.correctIndex,
    required this.picked,
    required this.wrongPicks,
    required this.finalised,
    required this.onTap,
  });

  final String label;
  final int index;
  final int correctIndex;
  final int? picked;
  final Set<int> wrongPicks;
  final bool finalised;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCorrect = index == correctIndex;
    final wasWrong = wrongPicks.contains(index);
    Color bg = FgColors.backgroundElevated;
    if (finalised) {
      if (isCorrect) {
        bg = FgColors.success;
      } else if (wasWrong || index == picked) {
        bg = FgColors.alert;
      }
    } else if (wasWrong) {
      bg = FgColors.alert.withValues(alpha: 0.6);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.s),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(FgSpacing.m),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: FgColors.outline, width: 2),
          ),
          child: Text(label, style: FgTypography.bodyM, softWrap: true),
        ),
      ),
    );
  }
}

class _WissensQuizResultPage extends StatelessWidget {
  const _WissensQuizResultPage({
    required this.correct,
    required this.total,
    this.expertMode = false,
  });
  final int correct;
  final int total;
  final bool expertMode;

  @override
  Widget build(BuildContext context) {
    // L9: Medaillen an der Quote statt an festen Trefferzahlen — sonst
    // stimmen sie nicht mehr, sobald eine Runde kürzer ausfällt. `total <= 0`
    // ist nur ein Selbstschutz gegen die Division.
    final pct = total <= 0 ? 0 : (correct * 100 / total).round();
    final passedProfessor = expertMode && pct >= 90;
    final medal = passedProfessor
        ? '🎓'
        : pct >= 90
            ? '🏆'
            : pct >= 70
                ? '🥇'
                : pct >= 50
                    ? '🥈'
                    : pct >= 30
                        ? '🥉'
                        : '📚';
    return PhoneFrame(
      appName: 'Auswertung',
      onBack: () => Navigator.of(context).pop(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(FgSpacing.xl),
          child: PixelPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(medal, style: const TextStyle(fontSize: 80)),
                const SizedBox(height: FgSpacing.l),
                Text('$correct / $total',
                    style: FgTypography.displayLarge),
                const SizedBox(height: FgSpacing.s),
                Text('$pct % richtig im 1. Versuch',
                    style: FgTypography.bodyL),
                if (expertMode) ...[
                  const SizedBox(height: FgSpacing.s),
                  Text(
                    passedProfessor
                        ? '🎓 Bestanden — Professor-Titel verdient!'
                        : 'Meisterprüfung: ab 9/10 gibt es den Professor-Titel.',
                    style: FgTypography.bodyM.copyWith(
                      color: passedProfessor
                          ? FgColors.success
                          : FgColors.info,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: FgSpacing.s),
                Text('+${correct * (expertMode ? 12 : 5)} XP',
                    style: FgTypography.bodyM
                        .copyWith(color: FgColors.success)),
                const SizedBox(height: FgSpacing.xl),
                PixelButton(
                  label: 'Weiter',
                  background: FgColors.primary,
                  foreground: FgColors.onPrimary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
