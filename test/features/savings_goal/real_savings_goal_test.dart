import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/savings_goal/real_savings_goal_repository.dart';
import 'package:finanzgame/features/xp/xp_repository.dart';
import 'package:finanzgame/features/zimmer/achievements_repository.dart';

Future<void> _flush() async {
  for (var i = 0; i < 6; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('Sparziel-Belohnungsformel (Welle C)', () {
    test('skaliert mild mit Zielbetrag, gedeckelt 100..600', () {
      expect(savingsGoalRewardXp(0), 100); // Floor
      expect(savingsGoalRewardXp(5000), 150); // 50 € → 100 + 50
      expect(savingsGoalRewardXp(20000), 300); // 200 € → 300
      expect(savingsGoalRewardXp(100000), 600); // 1000 € → Cap
    });
  });

  group('RealSavingsGoalRepository (Welle C)', () {
    ProviderContainer makeContainer(AppDatabase db) => ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
        );

    test('create → addProgress markiert reached bei Zielerreichung',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = makeContainer(db);
      addTearDown(c.dispose);
      final repo = c.read(realSavingsGoalRepositoryProvider.notifier);

      await repo.createGoal(
          emoji: '🎮', title: 'Spiel', targetCents: 5000, createdIso: '01.06.2026');
      var goal = repo.activeGoal!;
      expect(goal.status, SavingsGoalStatus.active);

      await repo.addProgress(goal.rowId, 3000);
      goal = repo.activeGoal!;
      expect(goal.savedCents, 3000);
      expect(goal.status, SavingsGoalStatus.active);

      await repo.addProgress(goal.rowId, 2500); // überschießt Ziel
      goal = repo.activeGoal!;
      expect(goal.savedCents, 5500);
      expect(goal.status, SavingsGoalStatus.reached);
      expect(goal.isReached, isTrue);
    });

    test('confirmReached vergibt XP + Trophäe, nur einmal', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = makeContainer(db);
      addTearDown(c.dispose);
      final repo = c.read(realSavingsGoalRepositoryProvider.notifier);
      final xpBefore = c.read(xpRepositoryProvider);

      await repo.createGoal(
          emoji: '🚲', title: 'Rad', targetCents: 20000, createdIso: 'x');
      final id = repo.activeGoal!.rowId;
      await repo.addProgress(id, 20000); // reached

      final xp = await repo.confirmReached(
          rowId: id, confirmedIso: 'y', dayIndex: 5);
      expect(xp, 300); // 200 € → 300 XP
      expect(c.read(xpRepositoryProvider), xpBefore + 300);
      expect(
        c.read(achievementsRepositoryProvider).containsKey('real_saver'),
        isTrue,
      );
      // Kein offenes Ziel mehr (confirmed).
      expect(repo.activeGoal, isNull);

      // Zweiter Confirm → 0 XP (schon bestätigt).
      final again = await repo.confirmReached(
          rowId: id, confirmedIso: 'z', dayIndex: 6);
      expect(again, 0);
    });

    test('confirmReached ohne Zielerreichung gibt 0', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = makeContainer(db);
      addTearDown(c.dispose);
      final repo = c.read(realSavingsGoalRepositoryProvider.notifier);
      await repo.createGoal(
          emoji: '🐷', title: 'Test', targetCents: 10000, createdIso: 'x');
      final id = repo.activeGoal!.rowId;
      await repo.addProgress(id, 5000); // nicht erreicht
      final xp = await repo.confirmReached(
          rowId: id, confirmedIso: 'y', dayIndex: 1);
      expect(xp, 0);
      expect(repo.activeGoal!.status, SavingsGoalStatus.active);
    });

    test('withdraw entnimmt Geld, nie unter 0, reached fällt zurück',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = makeContainer(db);
      addTearDown(c.dispose);
      final repo = c.read(realSavingsGoalRepositoryProvider.notifier);

      await repo.createGoal(
          emoji: '🎮', title: 'Spiel', targetCents: 5000, createdIso: 'x');
      final id = repo.activeGoal!.rowId;
      await repo.addProgress(id, 5000); // reached
      expect(repo.activeGoal!.status, SavingsGoalStatus.reached);

      // Notlage: 2000 entnehmen → unter Ziel → status zurück auf active.
      await repo.withdraw(id, 2000);
      var g = repo.activeGoal!;
      expect(g.savedCents, 3000);
      expect(g.status, SavingsGoalStatus.active);

      // Mehr entnehmen als da ist → clamped auf 0, kein Negativwert.
      await repo.withdraw(id, 9999);
      g = repo.activeGoal!;
      expect(g.savedCents, 0);
      expect(g.status, SavingsGoalStatus.active);
    });

    test('round-trip: Sparziele überleben DB-Reopen', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = makeContainer(db);
      final r1 = c1.read(realSavingsGoalRepositoryProvider.notifier);
      await r1.createGoal(
          emoji: '👟', title: 'Schuhe', targetCents: 8000, createdIso: 'x');
      await r1.addProgress(r1.activeGoal!.rowId, 4000);
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(snap),
      ]);
      addTearDown(c2.dispose);
      final goals = c2.read(realSavingsGoalRepositoryProvider);
      expect(goals, hasLength(1));
      expect(goals.first.title, 'Schuhe');
      expect(goals.first.savedCents, 4000);
    });
  });
}
