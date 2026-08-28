import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/confetti.dart';
import '../../ui/widgets/glossar_text.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../settings/settings_repository.dart';
import '../xp/xp_repository.dart';
import 'daily_quiz_state.dart';
import 'quiz_question.dart';

/// Spec-17: full-screen daily quiz overlay.
///
/// Shown once per [GameClock.dayIndex] from the Springboard. The player
/// picks an option → answer reveals (correct/wrong + explanation + reward).
/// "Weiter" closes. Skip button (top-right X) also closes; both paths call
/// [DailyQuizState.markShown] so it never re-opens today.
///
/// Reward (only awarded once, on pick):
/// - Correct: +50¢ cash + 5 XP
/// - Wrong:   +5 XP (consolation — playing matters more than scoring)
class DailyQuizPage extends ConsumerStatefulWidget {
  const DailyQuizPage({super.key});

  // Welle-8 Round 17 v2: nochmal hoch — Sohn-Feedback "immer noch wenig".
  // Easy 5€ · Mid 10€ · Hard 20€. Tagesziel + Allowance bleiben dominant,
  // aber Quiz wird spürbar belohnt für Schwierigkeitsstufen.
  static const Money correctCashReward = Money.cents(500);

  static Money rewardForTier(int tier) {
    return switch (tier) {
      2 => const Money.cents(2000),
      1 => const Money.cents(1000),
      _ => const Money.cents(500),
    };
  }

  @override
  ConsumerState<DailyQuizPage> createState() => _DailyQuizPageState();
}

class _DailyQuizPageState extends ConsumerState<DailyQuizPage> {
  int? _picked;
  bool _showConfetti = false;

  /// Spec-43 follow-up: Spieler darf 1× nachbessern wenn 1. Versuch falsch.
  /// Wrongs[0] = erste falsche Antwort, dann re-pick erlaubt.
  /// Nach 2. Versuch ist die Frage final beantwortet.
  final Set<int> _wrongPicks = <int>{};
  bool _finalised = false;

  void _pick(int index, MultipleChoiceQuestion q) {
    if (_finalised) return;
    if (_wrongPicks.contains(index)) return;
    final isCorrect = index == q.correctIndex;
    HapticFeedback.mediumImpact();

    if (isCorrect) {
      // Belohnung nur bei 1. Versuch — sonst nur XP, kein Cash.
      final firstTry = _wrongPicks.isEmpty;
      setState(() {
        _picked = index;
        _showConfetti = firstTry;
        _finalised = true;
      });
      if (firstTry) {
        // Welle-8 Round 17: Reward skaliert mit Tier (easy/mid/hard).
        ref.read(cashStateProvider.notifier).earn(
              DailyQuizPage.rewardForTier(q.tier),
            );
        // Welle-8 Round 14: Topic als gelernt markieren (nur 1. Versuch).
        if (q.topic.isNotEmpty) {
          ref
              .read(settingsRepositoryProvider.notifier)
              .addQuizLearnedTopic(q.topic);
        }
      }
      ref.read(xpRepositoryProvider.notifier).add(XpRewards.dailyQuizCorrect);
      return;
    }

    // Falsch.
    if (_wrongPicks.isEmpty) {
      // 1. falsch — nochmal probieren erlaubt.
      setState(() {
        _wrongPicks.add(index);
      });
    } else {
      // 2. falsch — final, Lösung enthüllen.
      setState(() {
        _wrongPicks.add(index);
        _picked = index;
        _finalised = true;
      });
      ref.read(xpRepositoryProvider.notifier).add(XpRewards.dailyQuizCorrect);
    }
  }

  void _close() {
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    ref.read(dailyQuizStateProvider.notifier).markShown(dayIndex);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    // spec-32: deterministic per-day option shuffle so correct answer
    // doesn't always sit in the middle.
    final question = ref
        .read(dailyQuizStateProvider.notifier)
        .questionFor(dayIndex)
        .shuffled(dayIndex * 977 + 13);

    return Scaffold(
      backgroundColor: FgColors.backgroundPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            switch (question) {
              MultipleChoiceQuestion() => _QuizBody(
                  question: question,
                  picked: _picked,
                  wrongPicks: _wrongPicks,
                  finalised: _finalised,
                  onPick: _pick,
                  onClose: _close,
                ),
            },
            // spec-35 phase K: confetti overlay on correct answer.
            if (_showConfetti)
              const IgnorePointer(child: ConfettiBurst()),
          ],
        ),
      ),
    );
  }
}

class _QuizBody extends StatelessWidget {
  const _QuizBody({
    required this.question,
    required this.picked,
    required this.wrongPicks,
    required this.finalised,
    required this.onPick,
    required this.onClose,
  });

  final MultipleChoiceQuestion question;
  final int? picked;
  final Set<int> wrongPicks;
  final bool finalised;
  final void Function(int index, MultipleChoiceQuestion q) onPick;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final answered = finalised;
    final isCorrect = picked == question.correctIndex;

    return Padding(
      padding: const EdgeInsets.all(FgSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row: title + skip
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Frage des Tages',
                  style: FgTypography.display,
                ),
              ),
              IconButton(
                key: const Key('daily_quiz_skip'),
                icon: const Icon(Icons.close, color: FgColors.onSurface),
                tooltip: 'Überspringen',
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.l),

          // Question + options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // spec-31: question visually distinct from answer tiles —
                  // gold border + ❓ glyph + bold larger text.
                  Container(
                    padding: const EdgeInsets.all(FgSpacing.l),
                    decoration: BoxDecoration(
                      color: FgColors.backgroundDeep,
                      border: Border.all(
                        color: FgColors.primary,
                        width: 3,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(FgRadius.card),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('❓',
                            style: TextStyle(fontSize: 28)),
                        const SizedBox(width: FgSpacing.s),
                        Expanded(
                          child: Text(
                            question.text,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: FgTypography.bodyL.copyWith(
                              fontWeight: FontWeight.bold,
                              color: FgColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: FgSpacing.l),
                  for (var i = 0; i < question.options.length; i++) ...[
                    _OptionTile(
                      label: question.options[i],
                      index: i,
                      picked: picked,
                      wrongPicks: wrongPicks,
                      finalised: finalised,
                      correctIndex: question.correctIndex,
                      onTap: (finalised || wrongPicks.contains(i))
                          ? null
                          : () => onPick(i, question),
                    ),
                    const SizedBox(height: FgSpacing.s),
                  ],
                  if (!finalised && wrongPicks.isNotEmpty) ...[
                    const SizedBox(height: FgSpacing.m),
                    PixelPanel(
                      background: FgColors.alert.withValues(alpha: 0.2),
                      padding: const EdgeInsets.all(FgSpacing.m),
                      child: const Text(
                        '❌ Falsch — du hast noch einen Versuch!',
                        style: FgTypography.bodyL,
                      ),
                    ),
                  ],
                  if (answered) ...[
                    const SizedBox(height: FgSpacing.m),
                    PixelPanel(
                      background: isCorrect
                          ? FgColors.success.withValues(alpha: 0.2)
                          : FgColors.alert.withValues(alpha: 0.2),
                      padding: const EdgeInsets.all(FgSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCorrect
                                ? (wrongPicks.isEmpty
                                    ? '✅ Richtig! Du bekommst '
                                        '${DailyQuizPage.rewardForTier(question.tier).formatEur()}'
                                        ' + 5 XP'
                                    : '✅ Richtig im 2. Versuch! '
                                        'Nur 5 XP — kein Geld.')
                                : '❌ Falsch — Lösung war markiert. +5 XP',
                            style: FgTypography.bodyL,
                          ),
                          const SizedBox(height: FgSpacing.s),
                          GlossarText(question.explanation,
                              style: FgTypography.bodyM),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (answered)
            Padding(
              padding: const EdgeInsets.only(top: FgSpacing.m),
              child: PixelButton(
                key: const Key('daily_quiz_continue'),
                label: 'Weiter',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: onClose,
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.index,
    required this.picked,
    required this.wrongPicks,
    required this.finalised,
    required this.correctIndex,
    required this.onTap,
  });

  final String label;
  final int index;
  final int? picked;
  final Set<int> wrongPicks;
  final bool finalised;
  final int correctIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCorrect = index == correctIndex;
    final isPicked = picked == index;
    final wasWrong = wrongPicks.contains(index);

    Color bg = FgColors.backgroundElevated;
    if (finalised) {
      if (isCorrect) {
        bg = FgColors.success;
      } else if (wasWrong || isPicked) {
        bg = FgColors.alert;
      }
    } else if (wasWrong) {
      // Falsch-Markierung bleibt sichtbar nach 1. Versuch.
      bg = FgColors.alert.withValues(alpha: 0.6);
    }

    // Auf den eingefärbten Kacheln braucht der Text eine dunkle Farbe:
    // `onSurface` #E8E8E8 kam auf `success` #4ED96A auf 1,50:1 und auf
    // `alert` #FF6B9D auf 2,19:1 — die richtige Antwort war ausgerechnet im
    // Moment des Auflösens am schlechtesten lesbar. Schwarz ergibt 11,46:1
    // bzw. 7,84:1. Diese Kacheln sind rohe Container, laufen also nicht durch
    // die Kontrast-Selbstheilung von PixelButton.
    final eingefaerbt = bg != FgColors.backgroundElevated;
    final textColor = eingefaerbt ? Colors.black : FgColors.onSurface;

    // Das Ergebnis stand vorher NUR in der Hintergrundfarbe — kein Zeichen,
    // kein Text, kein Semantics. Wer farbenblind ist, erfuhr es nicht; wer
    // blind ist, überhaupt nicht. Das Präfix trägt es sichtbar UND vorlesbar.
    final praefix = finalised
        ? (isCorrect ? '✓ Richtig: ' : (wasWrong || isPicked ? '✗ Falsch: ' : ''))
        : (wasWrong ? '✗ ' : '');

    final tile = Semantics(
      button: onTap != null,
      selected: isPicked,
      label: '$praefix$label',
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FgSpacing.m,
              vertical: FgSpacing.m,
            ),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: FgColors.outline, width: 2),
            ),
            child: Text(
              '$praefix$label',
              softWrap: true,
              overflow: TextOverflow.visible,
              style: FgTypography.bodyM.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );

    // Juice: die richtige Antwort ploppt beim Auflösen kurz auf.
    if (finalised && isCorrect) {
      return tile
          .animate()
          .scaleXY(begin: 0.92, end: 1.06, duration: 160.ms, curve: Curves.easeOut)
          .then()
          .scaleXY(begin: 1.06, end: 1.0, duration: 140.ms, curve: Curves.easeIn);
    }
    return tile;
  }
}
