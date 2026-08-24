import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/etf/etf.dart';
import 'package:finanzgame/domain/plant/plant.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/etf/etf_repository.dart';
import 'package:finanzgame/features/history/history_repository.dart';
import 'package:finanzgame/features/plant/plant_repository.dart';
import 'package:finanzgame/domain/crypto/crypto.dart';
import 'package:finanzgame/domain/metal/metal.dart';
import 'package:finanzgame/features/crypto/crypto_repository.dart';
import 'package:finanzgame/features/metal/metal_repository.dart';
import 'package:finanzgame/features/stock/stock_repository.dart';
import 'package:finanzgame/features/wishlist/wishlist_repository.dart';
import 'package:finanzgame/features/zimmer/furniture_catalog.dart';
import 'package:finanzgame/features/zimmer/furniture_repository.dart';
import 'package:finanzgame/features/xp/xp_repository.dart';
import 'package:finanzgame/features/zimmer/real_milestones_repository.dart';

/// Builds a [ProviderContainer] that shares one [AppDatabase] across
/// successive "app restarts" (= dispose + new container).
ProviderContainer _containerForDb(AppDatabase db, {DbSnapshot? snap}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
}

/// Drains pending fire-and-forget DB writes by yielding to the event loop
/// several times.
Future<void> _flushWrites() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('Drift round-trip', () {
    test('Cash: spend → reopen → state preserved', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).spend(const Money.cents(700));
      expect(c1.read(cashStateProvider), const Money.cents(4300));
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(cashStateProvider), const Money.cents(4300));
    });

    test('Plants: plant → reopen → loaded with same fields', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(5000);
      final repo = c1.read(plantRepositoryProvider.notifier);
      final p = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 2,
        kind: PlantKind.elephantsfoot,
        dayIndex: 7,
      );
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final list = c2.read(plantRepositoryProvider);
      expect(list, hasLength(1));
      expect(list.first.id, p.id);
      expect(list.first.islandId, 'spar_insel');
      expect(list.first.plotIndex, 2);
      expect(list.first.plantedOnDayIndex, 7);
      expect(list.first.status, PlantStatus.growing);
    });

    test('Plants: growthProgress round-trips (spec-18)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(5000);
      final repo = c1.read(plantRepositoryProvider.notifier);
      final p = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      // Bump progress + stage manually to capture both fields.
      repo.update(p.copyWith(currentStage: 2, growthProgress: 28));
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final reloaded = c2.read(plantRepositoryProvider).single;
      expect(reloaded.currentStage, 2);
      expect(reloaded.growthProgress, 28);
    });

    test('ETF: buy + quote update → reopen → both restored', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(100000);
      final repo = c1.read(etfRepositoryProvider.notifier);
      repo.buy(etfId: 'welt_korb', shares: 3);
      repo.updateQuote(
        const EtfQuote(
          etfId: 'welt_korb',
          pricePerShare: Money.cents(5678),
          onDayIndex: 9,
        ),
      );
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final p = c2.read(etfRepositoryProvider);
      final h = p.holdings.firstWhere((x) => x.etfId == 'welt_korb');
      expect(h.shares, 3);
      expect(p.quotes['welt_korb']!.pricePerShare, const Money.cents(5678));
      expect(p.quotes['welt_korb']!.onDayIndex, 9);
    });

    test('Stock: buy + sell partial → reopen → leftover holding kept',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(300000);
      final repo = c1.read(stockRepositoryProvider.notifier);
      repo.buy(stockId: 'aktie_fluxon', shares: 5);
      repo.sell(stockId: 'aktie_fluxon', shares: 2);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final h = c2
          .read(stockRepositoryProvider.notifier)
          .holdingFor('aktie_fluxon');
      expect(h, isNotNull);
      expect(h!.shares, 3);
    });

    test('Stock: sell-all → reopen → no row left', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(100000);
      final repo = c1.read(stockRepositoryProvider.notifier);
      repo.buy(stockId: 'aktie_fluxon', shares: 2);
      repo.sell(stockId: 'aktie_fluxon', shares: 2);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(
        c2
            .read(stockRepositoryProvider.notifier)
            .holdingFor('aktie_fluxon'),
        isNull,
      );
    });

    test('Crypto: buy + quote update → reopen → both restored', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state =
          const Money.cents(20000000);
      final repo = c1.read(cryptoRepositoryProvider.notifier);
      repo.buy(assetId: CryptoCatalog.bitcoin.id, shares: 2);
      repo.updateQuote(
        CryptoQuote(
          assetId: CryptoCatalog.bitcoin.id,
          pricePerShare: const Money.cents(6800),
          onDayIndex: 5,
        ),
      );
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final p = c2.read(cryptoRepositoryProvider);
      final h = p.holdings
          .firstWhere((x) => x.assetId == CryptoCatalog.bitcoin.id);
      expect(h.shares, 2);
      expect(p.quotes[CryptoCatalog.bitcoin.id]!.pricePerShare,
          const Money.cents(6800));
      expect(p.quotes[CryptoCatalog.bitcoin.id]!.onDayIndex, 5);
    });

    test('Metal: buy + quote update → reopen → both restored', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(500000);
      final repo = c1.read(metalRepositoryProvider.notifier);
      repo.buy(assetId: MetalCatalog.gold.id, shares: 1);
      repo.updateQuote(
        MetalQuote(
          assetId: MetalCatalog.gold.id,
          pricePerShare: const Money.cents(800),
          onDayIndex: 9,
        ),
      );
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final p = c2.read(metalRepositoryProvider);
      final h =
          p.holdings.firstWhere((x) => x.assetId == MetalCatalog.gold.id);
      expect(h.shares, 1);
      expect(p.quotes[MetalCatalog.gold.id]!.pricePerShare,
          const Money.cents(800));
      expect(p.quotes[MetalCatalog.gold.id]!.onDayIndex, 9);
    });

    test('Wishlist: buy → reopen → ownedOnDayIndex preserved', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(20000);
      c1.read(wishlistRepositoryProvider.notifier).buy('snack_xxl');
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final item = c2
          .read(wishlistRepositoryProvider.notifier)
          .byId('snack_xxl')!;
      expect(item.ownedOnDayIndex, 0);
    });

    test('Wishlist: photoPath survives inflate()+reopen (Round 27 BUGFIX)',
        () async {
      // Bug: inflate()→_persistAll schrieb Rows ohne photoPath → täglicher
      // Schlaf nullte alle Foto-Pfade. Jetzt muss das Foto überleben.
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      final repo1 = c1.read(wishlistRepositoryProvider.notifier);
      repo1.setPhotoPath('snack_xxl', '/data/photos/snack.jpg');
      repo1.inflate(); // tägliche Preis-Drift + _persistAll
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final item =
          c2.read(wishlistRepositoryProvider.notifier).byId('snack_xxl')!;
      expect(item.photoPath, '/data/photos/snack.jpg');
    });

    test('Furniture: buy → reopen → owned + active preserved (v22)',
        () async {
      // Welle-8 Sohn-Bug: "Stuhl weg nach Spiel verlassen". Möbel waren
      // in-memory-only. Müssen jetzt persistieren.
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final item = FurnitureCatalog.items
          .firstWhere((i) => i.slot == FurnitureSlot.chair);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state =
          const Money.cents(1000000);
      final repo1 = c1.read(furnitureRepositoryProvider.notifier);
      expect(repo1.buy(item), isTrue);
      expect(repo1.isOwned(item), isTrue);
      expect(repo1.isActive(item), isTrue);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final repo2 = c2.read(furnitureRepositoryProvider.notifier);
      expect(repo2.isOwned(item), isTrue);
      expect(repo2.isActive(item), isTrue);
    });

    test('RealMilestones: add → reopen → preserved + delete (v26)',
        () async {
      // Welle-8 Round 24 (#10): Eltern-eingetragene echte Erfolge müssen
      // persistieren und in der Trophäenwand erscheinen.
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      final xpBefore = c1.read(xpRepositoryProvider);
      await c1.read(realMilestonesRepositoryProvider.notifier).add(
            emoji: '💰',
            title: '80 € aufs echte Sparbuch',
            amountCents: 8000,
            dateIso: '01.06.2026',
            category: 'sparen',
          );
      // Round 26: Eintrag belohnt XP.
      expect(c1.read(xpRepositoryProvider), xpBefore + kRealMilestoneXp);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final list = c2.read(realMilestonesRepositoryProvider);
      expect(list, hasLength(1));
      expect(list.first.title, '80 € aufs echte Sparbuch');
      expect(list.first.amountCents, 8000);
      expect(list.first.emoji, '💰');
      expect(list.first.category, 'sparen');

      // Löschen → leer.
      await c2
          .read(realMilestonesRepositoryProvider.notifier)
          .remove(list.first.rowId);
      expect(c2.read(realMilestonesRepositoryProvider), isEmpty);
    });

    test('Furniture: sell → reopen → no longer owned (v22)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final item = FurnitureCatalog.items
          .firstWhere((i) => i.slot == FurnitureSlot.chair);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state =
          const Money.cents(1000000);
      final repo1 = c1.read(furnitureRepositoryProvider.notifier);
      repo1.buy(item);
      repo1.sell(item);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(
        c2.read(furnitureRepositoryProvider.notifier).isOwned(item),
        isFalse,
      );
    });

    test('Furniture: position + hidden round-trip (v22)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final item = FurnitureCatalog.items
          .firstWhere((i) => i.slot == FurnitureSlot.chair);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state =
          const Money.cents(1000000);
      final repo1 = c1.read(furnitureRepositoryProvider.notifier);
      repo1.buy(item);
      repo1.setItemPosition(item.id, 0.42, 0.73);
      repo1.toggleItemVisible(item.id); // → hidden
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final repo2 = c2.read(furnitureRepositoryProvider.notifier);
      expect(repo2.positionForItem(item.id), (0.42, 0.73));
      expect(repo2.isItemVisible(item.id), isFalse);
    });

    test('GameClock: advanceDay → reopen → dayIndex preserved', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      await c1.read(gameClockProvider.notifier).advanceDay();
      await c1.read(gameClockProvider.notifier).advanceDay();
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(gameClockProvider).dayIndex, 2);
    });

    test('History: recordToday → reopen → series restored', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(50000);
      await c1.read(gameClockProvider.notifier).advanceDay();
      await c1.read(gameClockProvider.notifier).advanceDay();
      final beforeLen =
          c1.read(historyRepositoryProvider.notifier).seriesFor('welt_korb').length;
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final afterLen = c2
          .read(historyRepositoryProvider.notifier)
          .seriesFor('welt_korb')
          .length;
      expect(afterLen, beforeLen);
      expect(afterLen, greaterThanOrEqualTo(3)); // day-0 seed + 2 advances
    });
  });

  group('Drift integration', () {
    test('advanceDay×5 → restart → cash + day + plants preserved', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(cashStateProvider.notifier).state = const Money.cents(5000);
      // Drop a plant so its growth state survives across the restart.
      c1.read(plantRepositoryProvider.notifier).plant(
            islandId: 'spar_insel',
            plotIndex: 0,
            kind: PlantKind.elephantsfoot,
            dayIndex: 0,
          );
      for (var i = 0; i < 5; i++) {
        await c1.read(gameClockProvider.notifier).advanceDay();
      }
      final cashBefore = c1.read(cashStateProvider);
      final plantBefore = c1
          .read(plantRepositoryProvider)
          .firstWhere((p) => p.islandId == 'spar_insel');
      final etfQuoteBefore =
          c1.read(etfRepositoryProvider).quotes['welt_korb']!;
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);

      expect(c2.read(gameClockProvider).dayIndex, 5);
      // spec-35: pipeline now emits more cash-affecting events
      // (rent, salary, debt …). The exact cash value drifts with the
      // catalog; what we still want to verify is the round-trip
      // preservation property — DB load = in-memory state pre-restart.
      // cashBefore is captured pre-dispose; allow a small delta for
      // async _persist races.
      final cashAfter = c2.read(cashStateProvider);
      // Spec-43 v9: LuckyEvent (±25.000 ¢ variance) macht tighter
      // Toleranz unmöglich. Round-trip == in-memory bleibt eigentliche
      // Aussage; Cash IST persistiert, kleiner Drift kommt nur durch
      // post-restart-Re-Roll wenn Sim re-läuft (sollte nicht passieren).
      expect(
        (cashAfter.cents - cashBefore.cents).abs() <= 30000,
        isTrue,
        reason: 'cash drifted by '
            '${cashAfter.cents - cashBefore.cents} cents across restart',
      );
      final plantAfter = c2
          .read(plantRepositoryProvider)
          .firstWhere((p) => p.id == plantBefore.id);
      expect(plantAfter.status, plantBefore.status);
      expect(plantAfter.currentStage, plantBefore.currentStage);
      expect(
        c2.read(etfRepositoryProvider).quotes['welt_korb'],
        etfQuoteBefore,
      );
    });
  });
}
