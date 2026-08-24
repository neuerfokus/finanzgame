import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/quest/quest.dart';
import 'package:finanzgame/features/quest_runner/quest_failure_repository.dart';
import 'package:finanzgame/features/quest_runner/quest_progress_repository.dart';
import 'package:finanzgame/features/quest_runner/quest_runner_controller.dart';

/// Quiz-Quest mit Dialog → Quiz → Choice, damit der 2×-falsch-Abbruch
/// (Quest-Fail-Cooldown) ausgelöst werden kann.
const _quizQuest = Quest(
  id: 'q_fail_test',
  title: 'Fehl-Quest',
  location: 'test',
  reward: QuestReward(cash: Money.cents(100), xp: 10),
  steps: [
    QuestStep.dialog(id: 'd1', speaker: 'NPC', lines: ['A', 'B']),
    QuestStep.quiz(
      id: 'q1',
      question: 'Pick',
      options: [
        QuestOption(id: 'x', label: 'Falsch'),
        QuestOption(id: 'y', label: 'Richtig'),
      ],
      correctId: 'y',
    ),
    QuestStep.choice(
      id: 'c1',
      prompt: 'Choose',
      options: [
        QuestOption(id: '1', label: 'Eins'),
        QuestOption(id: '2', label: 'Zwei'),
      ],
    ),
  ],
);

Future<void> _flush() async {
  for (var i = 0; i < 8; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('Quest-Fail-Cooldown Grenzen (isOnCooldown)', () {
    test('2-Tage-Fenster: gesperrt an Tag D und D+1, frei ab D+2', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final repo = c.read(questFailureRepositoryProvider.notifier);
      repo.recordFailure('q', 10); // gescheitert an Tag 10

      expect(repo.isOnCooldown('q', 10), isTrue, reason: 'Tag des Fails');
      expect(repo.daysUntilRetry('q', 10), 2);
      expect(repo.isOnCooldown('q', 11), isTrue, reason: '+1 Tag');
      expect(repo.daysUntilRetry('q', 11), 1);
      // +2 Tage (zwei Mal Schlafen) → Quest wieder spielbar.
      expect(repo.isOnCooldown('q', 12), isFalse, reason: '+2 Tage');
      expect(repo.daysUntilRetry('q', 12), 0);
      // Zeitsprung weit darüber hinaus → ebenfalls frei.
      expect(repo.isOnCooldown('q', 1000), isFalse);
    });
  });

  group('Abgebrochene Quest startet frisch (keepAlive-Stale-Bug)', () {
    test(
      'nach 2× falsch + Invalidate (Re-Entry) ist der Runner wieder am Anfang',
      () async {
        final db = AppDatabase.memory();
        addTearDown(db.close);
        final c = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            dbSnapshotProvider.overrideWithValue(const DbSnapshot()),
          ],
        );
        addTearDown(c.dispose);

        // Quest spielen, im Quiz-Step 2× falsch → Abbruch + Cooldown.
        c.read(questRunnerControllerProvider(_quizQuest).notifier)
          ..advance() // Zeile A
          ..advance() // Zeile B + Quiz-Step betreten
          ..answerQuiz('x') // 1. falsch
          ..answerQuiz('x'); // 2. falsch → Abbruch
        await _flush();

        // Abbruch sichtbar, Progress gelöscht, Cooldown 2 Tage ab Tag 0.
        expect(
          c.read(questRunnerControllerProvider(_quizQuest)).questAborted,
          isTrue,
        );
        expect(
          c.read(questProgressRepositoryProvider)[_quizQuest.id],
          isNull,
          reason: 'Progress wurde gelöscht',
        );
        final fail = c.read(questFailureRepositoryProvider.notifier);
        expect(fail.isOnCooldown(_quizQuest.id, 0), isTrue);
        expect(fail.isOnCooldown(_quizQuest.id, 2), isFalse);

        // ROOT CAUSE: der keepAlive-Controller bleibt ohne Invalidate im
        // Abbruch-Zustand hängen — auch nach abgelaufenem Cooldown. Genau
        // das sah der Spieler als „Quest nicht zurückgesetzt".
        expect(
          c.read(questRunnerControllerProvider(_quizQuest)).questAborted,
          isTrue,
          reason: 'ohne Invalidate weiterhin stale',
        );

        // FIX: Re-Entry (QuestListPage.onTap bei progress==null) invalidiert
        // den Controller → build() läuft erneut, findet keinen Progress →
        // frischer Start ab Schritt 0.
        c.invalidate(questRunnerControllerProvider(_quizQuest));
        await _flush();

        final fresh = c.read(questRunnerControllerProvider(_quizQuest));
        expect(fresh.questAborted, isFalse, reason: 'frischer Start');
        expect(fresh.finished, isFalse);
        expect(fresh.stepIndex, 0, reason: 'wieder bei Schritt 0');
        expect(
          fresh.chat.where((e) => e.toString().contains('zurückgesetzt')),
          isEmpty,
          reason: 'kein alter Abbruch-Text mehr',
        );
      },
    );
  });
}
