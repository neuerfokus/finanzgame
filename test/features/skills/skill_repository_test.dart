import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/audio/sound_service.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';
import 'package:finanzgame/features/skills/skill_tree_data.dart';

Future<void> _flush() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  tearDown(SoundService.reset);

  // xpTotal steuert das Level → die verfügbaren Skill-Punkte.
  ProviderContainer atXp(int xp) => ProviderContainer(
        overrides: [
          dbSnapshotProvider.overrideWithValue(DbSnapshot(xpTotal: xp)),
        ],
      );

  group('Skill-Punkte + Unlock (Round 28)', () {
    test('availableSkillPoints = Level − freigeschaltet', () {
      final c = atXp(500); // Level 3
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      expect(repo.availableSkillPoints(), 3);
      expect(repo.unlockSkill('a'), isTrue);
      expect(repo.availableSkillPoints(), 2);
      expect(repo.unlockedSkills(), {'a'});
    });

    test('unlock schlägt fehl wenn keine Punkte frei', () {
      final c = atXp(120); // Level 1
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      expect(repo.availableSkillPoints(), 1);
      expect(repo.unlockSkill('a'), isTrue);
      expect(repo.availableSkillPoints(), 0);
      expect(repo.unlockSkill('b'), isFalse);
      expect(repo.unlockedSkills(), {'a'});
    });

    test('unlockSkill idempotent (gleiche ID kostet keinen Punkt)', () {
      final c = atXp(500);
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      expect(repo.unlockSkill('a'), isTrue);
      expect(repo.unlockSkill('a'), isTrue); // schon da
      expect(repo.availableSkillPoints(), 2); // nur 1 verbraucht
    });

    test('redeemSkillPoint verbraucht je 1 Punkt bis erschöpft (v2)', () {
      final c = atXp(500); // Level 3
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      expect(repo.availableSkillPoints(), 3);
      expect(repo.redeemSkillPoint(), isTrue);
      expect(repo.availableSkillPoints(), 2);
      expect(redeemedCount(repo.unlockedSkills()), 1);
      expect(repo.redeemSkillPoint(), isTrue);
      expect(repo.redeemSkillPoint(), isTrue);
      expect(repo.redeemSkillPoint(), isFalse); // keine Punkte mehr
      expect(repo.availableSkillPoints(), 0);
      expect(redeemedCount(repo.unlockedSkills()), 3);
    });

    test('Prestige-Knoten verbraucht mehrere Punkte (Round 28 v4)', () {
      final c = atXp(2000); // hohes Level → genug Punkte
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      final before = repo.availableSkillPoints();
      expect(before, greaterThanOrEqualTo(prestigeCost));
      expect(repo.unlockSkill(SkillEffects.bonusPlot2), isTrue);
      expect(repo.availableSkillPoints(), before - prestigeCost);
    });

    test('Prestige scheitert bei zu wenig Punkten', () {
      final c = atXp(120); // Level 1 → 1 Punkt < prestigeCost
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      expect(repo.availableSkillPoints(), lessThan(prestigeCost));
      expect(repo.unlockSkill(SkillEffects.bonusPlot2), isFalse);
      expect(repo.unlockedSkills(), isEmpty);
    });

    test('hasSkill spiegelt freigeschaltete Knoten', () {
      final c = atXp(500);
      addTearDown(c.dispose);
      final repo = c.read(settingsRepositoryProvider.notifier);
      expect(repo.hasSkill('x'), isFalse);
      repo.unlockSkill('x');
      expect(repo.hasSkill('x'), isTrue);
    });

    test('round-trip: freigeschaltete Skills überleben DB-Reopen', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(const DbSnapshot(xpTotal: 500)),
      ]);
      c1.read(settingsRepositoryProvider.notifier).unlockSkill('z');
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(snap),
      ]);
      addTearDown(c2.dispose);
      expect(
        c2.read(settingsRepositoryProvider.notifier).unlockedSkills(),
        {'z'},
      );
    });

    test('round-trip: Wochen-Challenge-Stand überlebt DB-Reopen (v31)',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(const DbSnapshot()),
      ]);
      c1
          .read(settingsRepositoryProvider.notifier)
          .setWeeklyChallenge(claimedWeek: 4, streak: 3);
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(snap),
      ]);
      addTearDown(c2.dispose);
      final repo = c2.read(settingsRepositoryProvider.notifier);
      expect(repo.weeklyChallengeClaimedWeek(), 4);
      expect(repo.weeklyChallengeStreak(), 3);
    });

    test('round-trip: claimedStreakMilestone überlebt DB-Reopen (v34)',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(const DbSnapshot()),
      ]);
      c1
          .read(settingsRepositoryProvider.notifier)
          .setClaimedStreakMilestone(30);
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(snap),
      ]);
      addTearDown(c2.dispose);
      expect(
        c2.read(settingsRepositoryProvider.notifier).claimedStreakMilestone(),
        30,
      );
    });
  });
}
