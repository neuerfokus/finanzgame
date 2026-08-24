import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/data/quest/quest_asset_repository.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/quest/quest.dart';
import 'package:finanzgame/features/quest_runner/quest_availability.dart';
import 'package:finanzgame/features/quest_runner/quest_list_page.dart';

const _q1 = Quest(
  id: 'q1',
  title: 'Erste Quest',
  location: 'test',
  reward: QuestReward(cash: Money.cents(100)),
);

const _q2 = Quest(
  id: 'q2',
  title: 'Zweite Quest',
  location: 'test',
  reward: QuestReward(cash: Money.cents(100)),
  prerequisites: ['q1'],
);

Widget _wrap({
  required List<Quest> quests,
  required Map<String, QuestProgressRow> progress,
}) {
  return ProviderScope(
    overrides: [
      // Use the default in-memory DB; we never write through here.
      dbSnapshotProvider.overrideWithValue(DbSnapshot(questProgress: progress)),
      questsProvider.overrideWith((ref) async => quests),
    ],
    child: const MaterialApp(home: QuestListPage()),
  );
}

void main() {
  testWidgets(
    'locked quest renders lock icon, no nav, prereq hint visible',
    (tester) async {
      // q1 hasn't been started → q2 (depends on q1) is locked.
      await tester.pumpWidget(_wrap(
        quests: const [_q1, _q2],
        progress: const {},
      ));
      await tester.pumpAndSettle();

      // Both quests show up.
      expect(find.text('Erste Quest'), findsOneWidget);
      expect(find.text('Zweite Quest'), findsOneWidget);

      // Locked entry shows the lock + the prereq hint.
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.textContaining('Erst q1 abschließen'), findsOneWidget);

      // Tapping the locked tile does NOT push a new route.
      await tester.tap(find.text('Zweite Quest'));
      await tester.pumpAndSettle();
      // QuestListPage still on screen — no QuestRunnerPage pushed.
      expect(find.text('Zweite Quest'), findsOneWidget);
    },
  );

  testWidgets(
    'completed prereq unlocks dependent quest (no lock icon)',
    (tester) async {
      const progress = <String, QuestProgressRow>{
        'q1': QuestProgressRow(
          questId: 'q1',
          currentStepIndex: 0,
          status: questStatusCompleted,
          startedOnDayIndex: 0,
          completedOnDayIndex: 1,
        ),
      };
      await tester.pumpWidget(_wrap(
        quests: const [_q1, _q2],
        progress: progress,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Zweite Quest'), findsOneWidget);
      // No lock icon — q2 is now in the 'Verfügbar' bucket.
      expect(find.byIcon(Icons.lock), findsNothing);
    },
  );

  testWidgets(
    'three bucket headers appear when each bucket has entries',
    (tester) async {
      // q1 running, q2 locked.
      const progress = <String, QuestProgressRow>{
        'q1': QuestProgressRow(
          questId: 'q1',
          currentStepIndex: 0,
          status: questStatusRunning,
          startedOnDayIndex: 0,
        ),
      };
      const q3 = Quest(
        id: 'q3',
        title: 'Dritte Quest',
        location: 'test',
        reward: QuestReward(cash: Money.cents(100)),
      );
      // Größere Fläche: seit dem Home-Cleanup sitzt der Tagesziel-Banner
      // oben in der Quests-Seite — im 800×600-Default rutscht sonst das
      // letzte Bucket ("Gesperrt") aus dem lazy ListView-Viewport.
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(
        quests: const [_q1, _q2, q3],
        progress: progress,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Aktiv'), findsOneWidget);
      expect(find.text('Neu — noch nicht gestartet'), findsOneWidget);
      expect(find.text('Gesperrt'), findsOneWidget);
    },
  );
}
