import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/island_editor/decor_catalog.dart';
import 'package:finanzgame/features/island_editor/decor_repository.dart';

ProviderContainer _container(AppDatabase db) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
    ],
  );
}

Future<void> _flush() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('DecorRepository', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = AppDatabase.memory();
      container = _container(db);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('place inserts row + appears in state', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      final placement = await repo.place(
        islandId: 'spar_insel',
        decorId: 'palme',
        x: 0.4,
        y: 0.6,
      );
      expect(placement, isNotNull);
      expect(repo.forIsland('spar_insel'), hasLength(1));
      expect(repo.forIsland('spar_insel').first.decorId, 'palme');
    });

    test('place enforces max 8 per island', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      for (var i = 0; i < kMaxDecorPerIsland; i++) {
        await repo.place(
          islandId: 'spar_insel',
          decorId: 'palme',
          x: 0.5,
          y: 0.5,
        );
      }
      final overflow = await repo.place(
        islandId: 'spar_insel',
        decorId: 'bank',
        x: 0.5,
        y: 0.5,
      );
      expect(overflow, isNull);
      expect(repo.forIsland('spar_insel'), hasLength(kMaxDecorPerIsland));
    });

    test('place rejects unknown decorId', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      final res = await repo.place(
        islandId: 'spar_insel',
        decorId: 'nonsense',
        x: 0.5,
        y: 0.5,
      );
      expect(res, isNull);
    });

    test('remove deletes placement', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      final p = await repo.place(
        islandId: 'spar_insel',
        decorId: 'palme',
        x: 0.5,
        y: 0.5,
      );
      await repo.remove(p!.rowId);
      expect(repo.forIsland('spar_insel'), isEmpty);
    });

    test('update changes x/y/rotation', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      final p = await repo.place(
        islandId: 'spar_insel',
        decorId: 'palme',
        x: 0.2,
        y: 0.2,
      );
      await repo.update(p!.copyWith(x: 0.7, y: 0.8, rotation: 2));
      final updated = repo.forIsland('spar_insel').first;
      expect(updated.x, closeTo(0.7, 1e-6));
      expect(updated.y, closeTo(0.8, 1e-6));
      expect(updated.rotation, 2);
    });

    test('persists across DAO read', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      await repo.place(
        islandId: 'spar_insel',
        decorId: 'bank',
        x: 0.3,
        y: 0.4,
      );
      await _flush();
      final rows = await db.islandDecorDao.loadForIsland('spar_insel');
      expect(rows, hasLength(1));
      expect(rows.first.decorId, 'bank');
    });

    test('forIsland filters by islandId', () async {
      final repo = container.read(decorRepositoryProvider.notifier);
      await repo.place(
        islandId: 'spar_insel',
        decorId: 'palme',
        x: 0.5,
        y: 0.5,
      );
      await repo.place(
        islandId: 'etf_insel',
        decorId: 'palme',
        x: 0.5,
        y: 0.5,
      );
      expect(repo.forIsland('spar_insel'), hasLength(1));
      expect(repo.forIsland('etf_insel'), hasLength(1));
      expect(repo.forIsland('unknown'), isEmpty);
    });
  });
}
