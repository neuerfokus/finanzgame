import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/game_clock.dart';
import '../../domain/quest/chat_entry.dart';
import '../../domain/quest/quest.dart';
import '../../domain/economy/money.dart';
import '../daily_quiz/quiz_queue_repository.dart';
import '../economy/cash_state.dart';
import '../xp/xp_repository.dart';
import 'quest_availability.dart';
import 'quest_failure_repository.dart';
import 'quest_passive_income.dart';
import 'quest_progress_repository.dart';
import 'quest_runner_state.dart';

part 'quest_runner_controller.g.dart';

/// State machine for a single quest playthrough.
///
/// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
/// [pickChoice] (free choice). The reward is paid out automatically when
/// the last step is consumed.
///
/// `keepAlive: true` + hydration from [QuestProgressRepository] means that
/// popping/pushing the runner page preserves chat + step, and a hard app
/// restart restores them from Drift (spec-14).
///
/// The family key is the full [Quest] (Freezed value-equal), not just the
/// id, so the notifier always has the parsed steps without an async lookup.
@Riverpod(keepAlive: true)
class QuestRunnerController extends _$QuestRunnerController {
  @override
  QuestRunnerState build(Quest quest) {
    final progress = ref.read(questProgressRepositoryProvider)[quest.id];
    final initial = QuestRunnerState(quest: quest, stepIndex: 0);

    if (progress == null) {
      // First time playing — defer the 'running' marker write so we don't
      // mutate `questProgressRepositoryProvider` during our own build (Riverpod
      // forbids it). The repo's in-memory state is what gates `QuestListPage`
      // bucketing; the marker shows up on the next frame.
      final today = ref.read(gameClockProvider).dayIndex;
      Future.microtask(() {
        if (!ref.mounted) return;
        ref
            .read(questProgressRepositoryProvider.notifier)
            .markStarted(quest.id, today);
      });
      return _enterStep(initial, 0);
    }

    if (progress.status == questStatusCompleted) {
      // Already finished — replay terminal state, but skip the reward
      // payout (no double-credit on revisit).
      return _hydrateFinished(quest, progress);
    }

    return _hydrateRunning(quest, progress);
  }

  /// Async kick-off that fetches persisted chat lines and appends them to
  /// the in-memory state once available. Called from the runner page after
  /// the first frame so the chat surface is repopulated without blocking
  /// the synchronous `build()`.
  Future<void> hydrateChatHistory() async {
    final s = state;
    if (s.chat.isNotEmpty) return; // already hydrated this session
    final history = await ref
        .read(questProgressRepositoryProvider.notifier)
        .chatHistory(s.quest.id);
    if (history.isEmpty) return;
    state = s.copyWith(chat: [...history, ...s.chat]);
  }

  void advance() {
    var s = state;
    if (s.finished) return;
    final dialog = s.dialog;
    if (dialog == null) return;

    final step = s.quest.steps[dialog.stepIndex] as DialogStep;
    final nextLine = step.lines[dialog.linesShown];
    final newShown = dialog.linesShown + 1;
    final entry = ChatEntry.npc(speaker: step.speaker, text: nextLine);
    _persistChat(s.quest.id, entry);

    s = s.copyWith(
      chat: [...s.chat, entry],
      dialog: dialog.copyWith(linesShown: newShown),
    );

    if (newShown >= step.lines.length) {
      // Dialog exhausted — advance to next step.
      state = _enterStep(s.copyWith(dialog: null), s.stepIndex + 1);
      return;
    }
    state = s;
  }

  /// Spec-43 follow-up: max 2 Versuche pro Quiz-Step. Key = stepIndex.
  final Map<int, int> _quizAttempts = <int, int>{};

  void answerQuiz(String optionId) {
    final s = state;
    final step = s.quest.steps[s.stepIndex];
    if (step is! QuizStep) return;
    final option = step.options.firstWhere(
      (o) => o.id == optionId,
      orElse: () => throw ArgumentError('unknown option $optionId'),
    );

    if (optionId != step.correctId) {
      final attempts = (_quizAttempts[s.stepIndex] ?? 0) + 1;
      _quizAttempts[s.stepIndex] = attempts;

      if (attempts < 2) {
        // 1. falsch — nochmal probieren.
        final own = ChatEntry.own(text: option.label);
        const note = ChatEntry.system(
            text: 'Nicht ganz — probier nochmal! Du hast einen Versuch übrig.');
        _persistChat(s.quest.id, own);
        _persistChat(s.quest.id, note);
        state = s.copyWith(chat: [...s.chat, own, note]);
        return;
      }

      // 2. falsch — Quest wird abgebrochen + zum Anfang resettet.
      // Spec-43 v3: cleverer als auto-advance — Spieler darf Quest
      // nicht durch 2× Raten abschließen.
      final correctOpt = step.options.firstWhere(
        (o) => o.id == step.correctId,
        orElse: () => option,
      );
      final entries = <ChatEntry>[
        ChatEntry.own(text: option.label),
        ChatEntry.system(
            text:
                'Leider falsch. Richtig wäre: „${correctOpt.label}".'),
        const ChatEntry.system(
            text:
                'Quest wird zurückgesetzt — in 2 Tagen kannst du sie '
                'nochmal versuchen. Schau in der Zwischenzeit ins '
                '"Wissen"-Menü.'),
      ];
      for (final e in entries) {
        _persistChat(s.quest.id, e);
      }
      _quizAttempts.clear();
      // Quest-Progress zurücksetzen.
      ref
          .read(questProgressRepositoryProvider.notifier)
          .deleteQuestProgress(s.quest.id);
      // Welle-8 Round 3: Cooldown setzen (2 Tage Sperre).
      final today = ref.read(gameClockProvider).dayIndex;
      ref
          .read(questFailureRepositoryProvider.notifier)
          .recordFailure(s.quest.id, today);
      state = s.copyWith(
        chat: [...s.chat, ...entries],
        stepIndex: 0,
        awaitingInput: false,
        questAborted: true,
      );
      return;
    }

    final attempts = _quizAttempts[s.stepIndex] ?? 0;
    final entries = <ChatEntry>[
      ChatEntry.own(text: option.label),
      ChatEntry.system(
          text: attempts == 0 ? 'Richtig!' : 'Richtig im 2. Versuch!'),
      if (step.explanation != null)
        ChatEntry.system(text: step.explanation!),
    ];
    for (final e in entries) {
      _persistChat(s.quest.id, e);
    }
    state = _enterStep(
      s.copyWith(chat: [...s.chat, ...entries], awaitingInput: false),
      s.stepIndex + 1,
    );
  }

  void pickChoice(String optionId) {
    final s = state;
    final step = s.quest.steps[s.stepIndex];
    if (step is! ChoiceStep) return;
    final option = step.options.firstWhere(
      (o) => o.id == optionId,
      orElse: () => throw ArgumentError('unknown option $optionId'),
    );
    final entry = ChatEntry.own(text: option.label);
    _persistChat(s.quest.id, entry);
    state = _enterStep(
      s.copyWith(chat: [...s.chat, entry], awaitingInput: false),
      s.stepIndex + 1,
    );
  }

  QuestRunnerState _enterStep(QuestRunnerState s, int newIndex) {
    if (newIndex >= s.quest.steps.length) {
      return _finish(s);
    }
    final step = s.quest.steps[newIndex];
    // Persist the new step pointer so a cold restart resumes here.
    // Microtasked so we can safely call from `build()` paths too.
    final questId = s.quest.id;
    Future.microtask(() {
      if (!ref.mounted) return;
      ref
          .read(questProgressRepositoryProvider.notifier)
          .setStepIndex(questId, newIndex);
    });

    return switch (step) {
      DialogStep() => s.copyWith(
          stepIndex: newIndex,
          dialog: DialogProgress(stepIndex: newIndex, linesShown: 0),
          awaitingInput: false,
        ),
      QuizStep(:final question) => () {
          // spec-31: prefix marker so the chat-bubble renderer can paint
          // the question visually distinct from regular NPC lines.
          final entry = ChatEntry.npc(
            speaker: _lastSpeaker(s) ?? 'Magister Aureus',
            text: '❓ Frage: $question',
          );
          _persistChat(s.quest.id, entry);
          return s.copyWith(
            stepIndex: newIndex,
            chat: [...s.chat, entry],
            dialog: null,
            awaitingInput: true,
          );
        }(),
      ChoiceStep(:final prompt) => () {
          final entry = ChatEntry.npc(
            speaker: _lastSpeaker(s) ?? 'Magister Aureus',
            text: '❓ $prompt',
          );
          _persistChat(s.quest.id, entry);
          return s.copyWith(
            stepIndex: newIndex,
            chat: [...s.chat, entry],
            dialog: null,
            awaitingInput: true,
          );
        }(),
    };
  }

  String? _lastSpeaker(QuestRunnerState s) {
    for (final e in s.chat.reversed) {
      if (e is NpcEntry) return e.speaker;
    }
    return null;
  }

  QuestRunnerState _finish(QuestRunnerState s) {
    final reward = s.quest.reward;
    final monthlyPreview =
        Money.cents((reward.cash.cents * 0.20).round());
    final note =
        '+${reward.cash.formatEur()}  ·  +${reward.xp} XP  ·  '
        '12× ${monthlyPreview.formatEur()}/Monat aufs Spar';
    final entry = ChatEntry.system(text: 'Quest abgeschlossen! $note');
    _persistChat(s.quest.id, entry);

    final today = ref.read(gameClockProvider).dayIndex;
    final questId = s.quest.id;
    // L6 (Analyse 2026-08): die Belohnung wurde SOFORT gebucht, das
    // „erledigt"-Kennzeichen aber erst eine Microtask später. Ein
    // Prozess-Kill genau dazwischen ließ die Quest beim nächsten Start am
    // letzten Schritt wieder aufsetzen — und noch einmal auszahlen.
    // Praktisch kaum zu treffen, aber die Reihenfolge ist trotzdem falsch
    // herum: erst die Abschluss-Markierung setzen, dann auszahlen. Trifft
    // der Kill jetzt die Lücke, fehlt schlimmstenfalls eine Belohnung —
    // besser, als sie doppelt zu vergeben.
    Future.microtask(() {
      if (!ref.mounted) return;
      ref
          .read(questProgressRepositoryProvider.notifier)
          .markCompleted(questId, today);

      ref.read(cashStateProvider.notifier).earn(reward.cash);
      // Spec-21: XP for quest completion (10 XP — quest-defined reward.xp is
      // a separate field we keep for backwards compat; the XP-system uses
      // the canonical [XpRewards.questCompleted] amount).
      ref.read(xpRepositoryProvider.notifier).add(XpRewards.questCompleted);
      // Spec-42 Welle-6: 12 Monats-Auszahlungen auf Spar (10% pro Monat).
      unawaited(ref.read(questPassiveIncomeProvider.notifier).register(
            questId: questId,
            cashReward: reward.cash,
            currentDayIndex: today,
          ));

      // Spec-45 E4: Spaced-Repetition Reviews bei Quest-Complete enqueuen.
      ref
          .read(quizQueueRepositoryProvider.notifier)
          .enqueueForQuest(questId, today);
      // Welle-8: Achievements real-time prüfen (Quest-Complete kann
      // quest_5/quest_10/etc triggern).
      ref.read(gameClockProvider.notifier).evaluateAchievementsNow();
    });

    return s.copyWith(
      chat: [...s.chat, entry],
      dialog: null,
      awaitingInput: false,
      finished: true,
    );
  }

  QuestRunnerState _hydrateRunning(Quest quest, QuestProgress progress) {
    final stepIndex = progress.currentStepIndex.clamp(0, quest.steps.length - 1);
    final base = QuestRunnerState(quest: quest, stepIndex: stepIndex);
    final step = quest.steps[stepIndex];
    return switch (step) {
      DialogStep() => base.copyWith(
          dialog: DialogProgress(stepIndex: stepIndex, linesShown: 0),
        ),
      QuizStep() || ChoiceStep() => base.copyWith(awaitingInput: true),
    };
  }

  QuestRunnerState _hydrateFinished(Quest quest, QuestProgress _) {
    return QuestRunnerState(
      quest: quest,
      stepIndex: quest.steps.length - 1,
      finished: true,
    );
  }

  void _persistChat(String questId, ChatEntry entry) {
    ref
        .read(questProgressRepositoryProvider.notifier)
        .appendChat(questId, entry);
  }
}
