import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/metal/metal.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/metal/metal_repository.dart';

ProviderContainer _container({Money cash = const Money.cents(500000)}) {
  final c = ProviderContainer();
  c.read(cashStateProvider.notifier).state = cash;
  return c;
}

void main() {
  group('MetalRepository', () {
    test('initial quotes seeded from catalog', () {
      final c = _container();
      addTearDown(c.dispose);
      final p = c.read(metalRepositoryProvider);
      expect(p.quotes.length, MetalCatalog.all.length);
      for (final spec in MetalCatalog.all) {
        expect(p.quotes[spec.id]!.pricePerShare, spec.basePrice);
      }
    });

    test('buy + partial sell keeps leftover', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(metalRepositoryProvider.notifier);
      repo.buy(assetId: MetalCatalog.gold.id, shares: 3);
      repo.sell(assetId: MetalCatalog.gold.id, shares: 1);
      expect(repo.holdingFor(MetalCatalog.gold.id)!.shares, 2);
    });

    test('insufficient cash throws', () {
      final c = _container(cash: const Money.cents(10));
      addTearDown(c.dispose);
      final repo = c.read(metalRepositoryProvider.notifier);
      expect(
        () => repo.buy(assetId: MetalCatalog.platinum.id, shares: 1),
        throwsA(isA<MetalError>()),
      );
    });
  });
}
