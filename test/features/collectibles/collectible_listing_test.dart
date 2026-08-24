import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/collectibles/collectible.dart';
import 'package:finanzgame/features/collectibles/collectible_repository.dart';
import 'package:finanzgame/features/economy/cash_state.dart';

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
  group('Spec-44 F1 sprint F — Collectible listing workflow', () {
    test('listForSale markiert holding als listed', () async {
      final db = AppDatabase.memory();
      final c = _container(db);
      addTearDown(() {
        c.dispose();
        db.close();
      });

      // Cash auf Kauf-Niveau bringen — Briefmarken = 3 000 €.
      final cash = c.read(cashStateProvider.notifier);
      cash.earn(CollectibleCatalog.briefmarken.basePrice);
      final repo = c.read(collectibleRepositoryProvider.notifier);
      final ok = await repo.buy(CollectibleCatalog.briefmarken);
      expect(ok, isTrue);
      await _flush();

      final h = c.read(collectibleRepositoryProvider).single;
      expect(h.isListed, isFalse);

      final listed = repo.listForSale(h);
      expect(listed, isTrue);

      final h2 = c.read(collectibleRepositoryProvider).single;
      expect(h2.isListed, isTrue);
      expect(h2.listedOnDay, 0);

      // Doppel-Listing schlägt fehl.
      expect(repo.listForSale(h2), isFalse);
    });

    test('cancelListing revert listing-state', () async {
      final db = AppDatabase.memory();
      final c = _container(db);
      addTearDown(() {
        c.dispose();
        db.close();
      });

      c.read(cashStateProvider.notifier)
          .earn(CollectibleCatalog.briefmarken.basePrice);
      final repo = c.read(collectibleRepositoryProvider.notifier);
      await repo.buy(CollectibleCatalog.briefmarken);
      await _flush();
      final h = c.read(collectibleRepositoryProvider).single;
      repo.listForSale(h);
      final listed = c.read(collectibleRepositoryProvider).single;

      final ok = repo.cancelListing(listed);
      expect(ok, isTrue);
      expect(c.read(collectibleRepositoryProvider).single.isListed, isFalse);
    });

    test('instantSell zahlt 5% weniger als normaler Verkauf', () async {
      final db = AppDatabase.memory();
      final c = _container(db);
      addTearDown(() {
        c.dispose();
        db.close();
      });

      // Briefmarken sellValue(0) = 3000€ * (1 - 0.20) = 2400€ = 240_000¢
      // instantSell → 240_000 * 0.95 = 228_000¢
      c.read(cashStateProvider.notifier)
          .earn(CollectibleCatalog.briefmarken.basePrice);
      final repo = c.read(collectibleRepositoryProvider.notifier);
      await repo.buy(CollectibleCatalog.briefmarken);
      await _flush();

      final cashBefore = c.read(cashStateProvider).cents;
      final h = c.read(collectibleRepositoryProvider).single;
      final ok = await repo.instantSell(h);
      expect(ok, isTrue);
      await _flush();

      final cashAfter = c.read(cashStateProvider).cents;
      final payout = cashAfter - cashBefore;
      // Briefmarken: spread 20% → normal payout = 240_000.
      // instantSell extra −5% → 228_000.
      expect(payout, 228000);
      expect(c.read(collectibleRepositoryProvider), isEmpty);
    });

    test('settleListings entfernt fällige Listings nach sellDelayDays',
        () async {
      final db = AppDatabase.memory();
      final c = _container(db);
      addTearDown(() {
        c.dispose();
        db.close();
      });

      c.read(cashStateProvider.notifier)
          .earn(CollectibleCatalog.briefmarken.basePrice);
      final repo = c.read(collectibleRepositoryProvider.notifier);
      await repo.buy(CollectibleCatalog.briefmarken);
      await _flush();
      final h = c.read(collectibleRepositoryProvider).single;
      repo.listForSale(h); // listedOnDay = 0
      const spec = CollectibleCatalog.briefmarken;
      expect(spec.sellDelayDays, 7);

      // Vor Fälligkeit: nichts passiert.
      await repo.settleListings(6);
      expect(c.read(collectibleRepositoryProvider), hasLength(1));

      // Genau am Fälligkeitstag: settle.
      final cashBefore = c.read(cashStateProvider).cents;
      await repo.settleListings(7);
      await _flush();
      expect(c.read(collectibleRepositoryProvider), isEmpty);
      final cashAfter = c.read(cashStateProvider).cents;
      // Normaler Verkaufspreis (kein 5 % Extra-Abschlag).
      expect(cashAfter - cashBefore, 240000);
    });

    test('settleListings ignoriert nicht-gelistete Holdings', () async {
      final db = AppDatabase.memory();
      final c = _container(db);
      addTearDown(() {
        c.dispose();
        db.close();
      });

      c.read(cashStateProvider.notifier)
          .earn(CollectibleCatalog.briefmarken.basePrice);
      final repo = c.read(collectibleRepositoryProvider.notifier);
      await repo.buy(CollectibleCatalog.briefmarken);
      await _flush();

      // Kein Listing → settle ändert nichts.
      await repo.settleListings(999);
      expect(c.read(collectibleRepositoryProvider), hasLength(1));
    });
  });
}
