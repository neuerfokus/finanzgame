import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

ProviderContainer _containerForDb(AppDatabase db, {DbSnapshot? snap}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
}

Future<void> _flushWrites() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('Unlocked-island round-trip', () {
    test('unlock(etf_insel) → reopen DB → still unlocked', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(monetariaStateProvider.notifier).unlock(IslandId.etfInsel);
      expect(
        c1.read(monetariaStateProvider),
        containsAll(<String>[IslandId.etfInsel, IslandId.sparInsel]),
      );
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      expect(snap.unlockedIslands, contains(IslandId.etfInsel));

      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final unlocked = c2.read(monetariaStateProvider);
      expect(unlocked, contains(IslandId.etfInsel));
      expect(unlocked, contains(IslandId.heimathafen));
      expect(unlocked, contains(IslandId.sparInsel));
      // Defaults aren't extended past spec without an explicit unlock.
      expect(unlocked, isNot(contains(IslandId.vulkan)));
    });

    test('fresh DB → only default seed (heimathafen + spar_insel)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final snap = await loadDbSnapshot(db);
      final c = _containerForDb(db, snap: snap);
      addTearDown(c.dispose);

      final unlocked = c.read(monetariaStateProvider);
      expect(unlocked, {IslandId.heimathafen, IslandId.sparInsel});
    });

    test('idempotent unlock does not duplicate persisted row', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(monetariaStateProvider.notifier).unlock(IslandId.vulkan);
      c1.read(monetariaStateProvider.notifier).unlock(IslandId.vulkan);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      expect(
        snap.unlockedIslands.where((id) => id == IslandId.vulkan).length,
        1,
      );
    });

    test('lifetimeHarvestCents column survives reopen', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      await db.cashDao.addHarvest(1234);
      await db.cashDao.addHarvest(800);

      final snap = await loadDbSnapshot(db);
      expect(snap.lifetimeHarvestCents, 2034);
    });
  });
}
