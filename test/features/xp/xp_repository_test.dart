import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/data/quest/quest_asset_repository.dart';
import 'package:finanzgame/features/audio/sound_service.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/xp/level_titles.dart';
import 'package:finanzgame/features/xp/xp_repository.dart';

ProviderContainer _container(AppDatabase db, {DbSnapshot? snap}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
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
  tearDown(SoundService.reset);

  group('Level-Up-Cash (Round 28)', () {
    test('Level-Übergang schreibt Cash gut (Σ Level × 5 €)', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final cashBefore = c.read(cashStateProvider).cents;
      // xpForLevel(2) = 264 → Level 2. Belohnung Level 1 + 2 = 500 + 1000.
      c.read(xpRepositoryProvider.notifier).add(264);
      expect(LevelSystem.levelFor(c.read(xpRepositoryProvider)), 2);
      expect(c.read(cashStateProvider).cents, cashBefore + 1500);
      final lvlUp = c.read(lastLevelUpProvider);
      expect(lvlUp.level, 2);
      expect(lvlUp.rewardCents, 1500);
    });

    test('kein Level-Up → kein Cash', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final cashBefore = c.read(cashStateProvider).cents;
      c.read(xpRepositoryProvider.notifier).add(50); // bleibt Level 0
      expect(c.read(cashStateProvider).cents, cashBefore);
      expect(c.read(lastLevelUpProvider).level, isNull);
    });
  });

  group('XpRepository master-bonus (Round 27 v7)', () {
    test('×2 XP wenn ≥90 % der Quests gelöst', () {
      final total = kQuestAssetPaths.length;
      final need = (total * 0.9).floor();
      final progress = {
        for (var i = 0; i < need; i++)
          'q$i': QuestProgressRow(
            questId: 'q$i',
            currentStepIndex: 0,
            status: 'completed',
            startedOnDayIndex: 0,
            completedOnDayIndex: 0,
          ),
      };
      final c = ProviderContainer(
        overrides: [
          dbSnapshotProvider
              .overrideWithValue(DbSnapshot(questProgress: progress)),
        ],
      );
      addTearDown(c.dispose);
      final n = c.read(xpRepositoryProvider.notifier);
      expect(n.masterBonusActive, isTrue);
      n.add(10);
      expect(c.read(xpRepositoryProvider), 20);
    });

    test('×1 XP wenn wenige Quests gelöst', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(xpRepositoryProvider.notifier);
      expect(n.masterBonusActive, isFalse);
      n.add(10);
      expect(c.read(xpRepositoryProvider), 10);
    });
  });

  group('XpRepository', () {
    test('starts at 0 when DB empty', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(xpRepositoryProvider), 0);
    });

    test('add accumulates and ignores non-positive deltas', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final notifier = c.read(xpRepositoryProvider.notifier);
      notifier.add(XpRewards.questCompleted);
      notifier.add(XpRewards.plantHarvested);
      notifier.add(0);
      notifier.add(-5);
      // Round 27 v6: aus Konstanten berechnet (nicht hardcoded), da
      // Reward-Werte sich ändern können.
      expect(c.read(xpRepositoryProvider),
          XpRewards.questCompleted + XpRewards.plantHarvested);
    });

    test('round-trip: persisted total survives container restart', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _container(db);
      c1.read(xpRepositoryProvider.notifier).add(42);
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _container(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(xpRepositoryProvider), 42);
    });
  });
}
