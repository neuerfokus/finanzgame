import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/quest/quest.dart';
import 'package:finanzgame/features/quest_runner/quest_availability.dart';
import 'package:finanzgame/features/quest_runner/quest_progress_repository.dart';
import 'package:finanzgame/features/quest_runner/quest_runner_controller.dart';

const _quest = Quest(
  id: 'q_roundtrip',
  title: 'Round Trip',
  location: 'test',
  reward: QuestReward(cash: Money.cents(50), xp: 5),
  steps: [
    QuestStep.dialog(
      id: 'd1',
      speaker: 'NPC',
      lines: ['Hallo', 'Welt'],
    ),
    QuestStep.dialog(
      id: 'd2',
      speaker: 'NPC',
      lines: ['Noch was', 'Ende'],
    ),
    QuestStep.choice(
      id: 'c1',
      prompt: 'Wähle',
      options: [
        QuestOption(id: 'a', label: 'A'),
        QuestOption(id: 'b', label: 'B'),
      ],
    ),
  ],
);

ProviderContainer _containerForDb(AppDatabase db, {DbSnapshot? snap}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
}

Future<void> _flushWrites() async {
  for (var i = 0; i < 8; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('Quest progress round-trip', () {
    test('advance 2 steps + chat → reopen → currentStep + chat preserved',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      // Trigger controller build → fires `markStarted` (microtasked).
      final ctrl1 =
          c1.read(questRunnerControllerProvider(_quest).notifier);
      await _flushWrites();
      // Burn through dialog 1 (2 lines) → auto enters dialog 2.
      ctrl1
        ..advance()
        ..advance();
      // Burn through dialog 2 (2 lines) → auto enters choice step (idx 2).
      ctrl1
        ..advance()
        ..advance();
      final s1 = c1.read(questRunnerControllerProvider(_quest));
      expect(s1.stepIndex, 2);
      expect(s1.awaitingInput, isTrue);
      // Chat contains all four dialog lines so far.
      expect(s1.chat.length, greaterThanOrEqualTo(4));
      await _flushWrites();
      c1.dispose();

      // "Reopen" the app.
      final snap = await loadDbSnapshot(db);
      expect(snap.questProgress.containsKey('q_roundtrip'), isTrue);
      expect(snap.questProgress['q_roundtrip']!.currentStepIndex, 2);
      expect(
        snap.questProgress['q_roundtrip']!.status,
        questStatusRunning,
      );

      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final s2 = c2.read(questRunnerControllerProvider(_quest));
      expect(s2.stepIndex, 2);
      expect(s2.awaitingInput, isTrue);

      // Initial state has empty chat — hydrate it asynchronously.
      await c2
          .read(questRunnerControllerProvider(_quest).notifier)
          .hydrateChatHistory();
      final s3 = c2.read(questRunnerControllerProvider(_quest));
      expect(s3.chat, isNotEmpty);
      // The 4 dialog lines from the first session are restored.
      expect(s3.chat.length, greaterThanOrEqualTo(4));
    });

    test('finish quest → reopen → marked completed', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      final ctrl =
          c1.read(questRunnerControllerProvider(_quest).notifier);
      await _flushWrites();
      ctrl
        ..advance() // line 1
        ..advance() // line 2 + enter dialog 2
        ..advance() // line 1
        ..advance() // line 2 + enter choice
        ..pickChoice('a'); // → finish
      await _flushWrites();
      expect(
        c1.read(questRunnerControllerProvider(_quest)).finished,
        isTrue,
      );
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      expect(
        snap.questProgress['q_roundtrip']!.status,
        questStatusCompleted,
      );
    });

    test('repository markStarted/markCompleted survives reopen', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1
          .read(questProgressRepositoryProvider.notifier)
          .markStarted('q_alpha', 3);
      c1
          .read(questProgressRepositoryProvider.notifier)
          .markCompleted('q_alpha', 5);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final row = snap.questProgress['q_alpha']!;
      expect(row.status, questStatusCompleted);
      expect(row.startedOnDayIndex, 3);
      expect(row.completedOnDayIndex, 5);
    });
  });
}
