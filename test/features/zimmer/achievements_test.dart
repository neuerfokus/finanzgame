import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/zimmer/achievements.dart';
import 'package:finanzgame/features/zimmer/achievements_repository.dart';

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
  group('evaluateAchievements', () {
    test('empty snapshot → no unlocks', () {
      final result = evaluateAchievements(
        plantHarvestCount: 0,
        savingsCents: 0,
        etfHoldingsCount: 0,
        questsCompleted: 0,
        inflationAtollUnlocked: false,
        crashSurvived: false,
        daysPlayed: 0,
      );
      expect(result, isEmpty);
    });

    test('individual rule thresholds', () {
      expect(
        evaluateAchievements(
          plantHarvestCount: 1,
          savingsCents: 0,
          etfHoldingsCount: 0,
          questsCompleted: 0,
          inflationAtollUnlocked: false,
          crashSurvived: false,
          daysPlayed: 0,
        ),
        contains('first_harvest'),
      );

      expect(
        evaluateAchievements(
          plantHarvestCount: 0,
          savingsCents: 10000,
          etfHoldingsCount: 0,
          questsCompleted: 0,
          inflationAtollUnlocked: false,
          crashSurvived: false,
          daysPlayed: 0,
        ),
        contains('savings_100'),
      );

      expect(
        evaluateAchievements(
          plantHarvestCount: 0,
          savingsCents: 0,
          etfHoldingsCount: 1,
          questsCompleted: 5,
          inflationAtollUnlocked: true,
          crashSurvived: true,
          daysPlayed: 30,
        ),
        containsAll([
          'first_etf',
          'quest_1',
          'quest_5',
          'inflation_unlocked',
          'crash_survivor',
          'days_30',
        ]),
      );
    });

    test('savings_100 needs at least 10 000¢ (= 100 €)', () {
      final result = evaluateAchievements(
        plantHarvestCount: 0,
        savingsCents: 9999,
        etfHoldingsCount: 0,
        questsCompleted: 0,
        inflationAtollUnlocked: false,
        crashSurvived: false,
        daysPlayed: 0,
      );
      expect(result.contains('savings_100'), isFalse);
    });

    test('Round 27 v5: vormals nie unlockbare Trophäen feuern jetzt', () {
      final r = evaluateAchievements(
        plantHarvestCount: 0,
        savingsCents: 0,
        etfHoldingsCount: 0,
        questsCompleted: 0,
        inflationAtollUnlocked: false,
        crashSurvived: false,
        daysPlayed: 0,
        bitcoinShares: 1,
        metalShares: 1,
        stockShares: 1,
        wishlistOwnedCount: 2,
        wishlistTotalCount: 2,
        level: 60,
        vorsorgeContractsCount: 1,
        sparplanCount: 1,
        assetClassCount: 5,
        streakDays: 30,
        netWorthCents: 100000000,
      );
      expect(
        r.containsAll([
          'bitcoin_first', 'gold_first', 'stock_first', 'wishlist_first',
          'wishlist_all', 'level_60', 'vorsorge_first', 'sparplan_first',
          'diversified_5', 'streak_30', 'millionaire',
        ]),
        isTrue,
      );
    });

    test('Round 27 v5: netWorthCents triggert Millionär (volles Vermögen)', () {
      // Vorher: nur cash+savings → Millionär kaum erreichbar. Jetzt zählt
      // das volle Netto-Vermögen.
      final r = evaluateAchievements(
        plantHarvestCount: 0,
        savingsCents: 0,
        etfHoldingsCount: 0,
        questsCompleted: 0,
        inflationAtollUnlocked: false,
        crashSurvived: false,
        daysPlayed: 0,
        netWorthCents: 100000000,
      );
      expect(r.contains('millionaire'), isTrue);
    });

    // Round 27 v8: Audit — hätte die ~15 toten Trophäen vorher gefangen.
    // Jede definierte Trophäe MUSS eine Unlock-Regel haben (entweder in
    // evaluateAchievements bei max. Inputs, oder extern freigeschaltet).
    test('Audit: jede Trophäe hat eine Unlock-Regel', () {
      const externallyUnlocked = {
        'wissensquiz_done',
        'wissensquiz_perfect',
        'quiz_professor', // Round 28 v4: Meisterprüfung ≥9/10
        'quiz_streak_7', // ≥7/10 im Wissens-Quiz (wissens_quiz_page)
        // Round 28 v2: Skill-Baum-Abschluss (SkillTreePage._grantCompletionRewards).
        'skilltree_spar',
        'skilltree_invest',
        'skilltree_schutz',
        'skilltree_master',
        // Round 28 v4: Prestige-Knoten alle gemeistert.
        'skilltree_prestige',
        // Welle C: echtes Sparziel von Eltern bestätigt (RealSavingsGoalPage).
        'real_saver',
      };
      final produced = evaluateAchievements(
        plantHarvestCount: 1,
        savingsCents: 100000000,
        etfHoldingsCount: 1,
        questsCompleted: 100,
        inflationAtollUnlocked: true,
        crashSurvived: true,
        daysPlayed: 100000,
        monthlyAllowanceCents: 1,
        realEstateCount: 10,
        streakDays: 100,
        bitcoinShares: 1,
        metalShares: 1,
        stockShares: 1,
        wishlistOwnedCount: 5,
        wishlistTotalCount: 5,
        level: 60,
        vorsorgeContractsCount: 1,
        sparplanCount: 1,
        assetClassCount: 9,
        netWorthCents: 100000000,
      );
      for (final a in kAchievements) {
        expect(
          produced.contains(a.id) || externallyUnlocked.contains(a.id),
          isTrue,
          reason: 'Trophäe "${a.id}" hat keine Unlock-Regel (toter Code)',
        );
      }
    });
  });

  group('AchievementsRepository', () {
    test('unlock is idempotent', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final repo = c.read(achievementsRepositoryProvider.notifier);
      expect(repo.unlock('first_harvest', 3), isTrue);
      expect(repo.unlock('first_harvest', 5), isFalse);
      expect(c.read(achievementsRepositoryProvider)['first_harvest'], 3);
    });

    test('round-trip: unlocked id survives container restart', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _container(db);
      c1
          .read(achievementsRepositoryProvider.notifier)
          .unlock('quest_1', 4);
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _container(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(achievementsRepositoryProvider), {'quest_1': 4});
    });
  });
}
