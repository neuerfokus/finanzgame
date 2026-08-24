import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/daily_quiz/daily_quiz_state.dart';
import 'package:finanzgame/features/daily_quiz/quiz_queue_repository.dart';
import 'package:finanzgame/features/daily_quiz/quiz_question.dart';
import 'package:finanzgame/features/daily_quiz/quiz_topics.dart';

ProviderContainer _container({DbSnapshot? snap, AppDatabase? db}) {
  return ProviderContainer(
    overrides: [
      if (db != null) appDatabaseProvider.overrideWithValue(db),
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
}

Future<void> _flush() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('DailyQuizState.shouldShow (spec-17)', () {
    test('default lastQuizDayIndex = -1 → shouldShow(0) true', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(dailyQuizStateProvider.notifier);
      expect(n.shouldShow(0), isTrue);
      expect(n.shouldShow(5), isTrue);
    });

    test('table: lastQuizDayIndex vs currentDay', () {
      // table-test: (last, current, expected shouldShow)
      const cases = [
        (-1, 0, true),
        (0, 0, false),
        (0, 1, true),
        (5, 5, false),
        (5, 6, true),
        (10, 3, false), // never roll backwards
      ];
      for (final (last, current, expected) in cases) {
        final c = _container(
          snap: DbSnapshot(settings: SettingsSnapshot(lastQuizDayIndex: last)),
        );
        addTearDown(c.dispose);
        final n = c.read(dailyQuizStateProvider.notifier);
        expect(
          n.shouldShow(current),
          expected,
          reason: 'last=$last current=$current expected=$expected',
        );
      }
    });

    test('markShown persists across DB reopen (round-trip)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _container(db: db);
      c1.read(dailyQuizStateProvider.notifier).markShown(7);
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _container(db: db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(dailyQuizStateProvider), 7);
      expect(c2.read(dailyQuizStateProvider.notifier).shouldShow(7), isFalse);
      expect(c2.read(dailyQuizStateProvider.notifier).shouldShow(8), isTrue);
    });

    test('questionFor is deterministic via dayIndex % poolSize', () {
      final c = _container();
      addTearDown(c.dispose);
      final n = c.read(dailyQuizStateProvider.notifier);
      // Same input → same output, different inputs → may differ across pool
      final q0a = n.questionFor(0);
      final q0b = n.questionFor(0);
      expect(q0a, equals(q0b));
    });
  });

  // Welle-8 Round 24 (Fix C): bei mehreren überfälligen Reviews desselben
  // Topics (typisch nach Zeitsprung) lieferte der alte _firstByTopic immer
  // exakt dieselbe Frage. Jetzt unseen+random → zwei aufeinanderfolgende
  // Picks für dasselbe Topic unterscheiden sich, solange der Pool > 1 hat.
  test('due-review picks differ for same topic across consecutive days', () async {
    // psychologie hat mehrere easy-Fragen im Pool.
    const topic = QuizTopic.psychologie;
    final c = _container();
    addTearDown(c.dispose);
    final queue = c.read(quizQueueRepositoryProvider.notifier);

    // Zwei fällige Reviews desselben Topics in die Queue (Zeitsprung-Szenario).
    queue
      ..enqueueForQuest('q20_geld_vs_glueck', 0) // topic psychologie, due 1/3/7
      ..enqueueForQuest('q34_panik_vermeiden', 0);

    // Tag 100/101: alle Tiers offen → psychologie hat 5 Fragen im Pool,
    // genug Spielraum damit der unseen-Filter eine andere wählen kann.
    // Notifier jedes Mal frisch lesen — _rememberSeen mutiert Settings →
    // Provider-Rebuild verwirft die alte Instanz (so wie es die UI auch tut).
    final q1 = c.read(dailyQuizStateProvider.notifier).questionFor(100)
        as MultipleChoiceQuestion;
    await _flush(); // _rememberSeen-microtask durchlassen
    // Folgetag: zweiter fälliger Review, sollte ungesehene Frage wählen.
    final q2 = c.read(dailyQuizStateProvider.notifier).questionFor(101)
        as MultipleChoiceQuestion;

    expect(q1.topic, topic);
    expect(q2.topic, topic);
    expect(q2.text, isNot(equals(q1.text)),
        reason: 'unseen-Filter soll Wiederholung verhindern');
  });
}
