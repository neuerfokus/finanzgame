import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/stock/stock.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/stock/stock_repository.dart';

ProviderContainer _container({Money cash = const Money.cents(200000)}) {
  final c = ProviderContainer();
  c.read(cashStateProvider.notifier).state = cash;
  return c;
}

void main() {
  group('StockRepository', () {
    test('initial quotes seeded from catalog', () {
      final c = _container();
      addTearDown(c.dispose);
      final p = c.read(stockRepositoryProvider);
      expect(p.quotes.length, StockCatalog.all.length);
      for (final spec in StockCatalog.all) {
        expect(p.quotes[spec.id]!.pricePerShare, spec.initialPrice);
      }
    });

    test('buy + sell round-trip', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(stockRepositoryProvider.notifier);
      repo.buy(stockId: 'aktie_fluxon', shares: 2);
      expect(repo.holdingFor('aktie_fluxon')!.shares, 2);
      repo.sell(stockId: 'aktie_fluxon', shares: 2);
      expect(repo.holdingFor('aktie_fluxon'), isNull);
      expect(c.read(cashStateProvider), const Money.cents(200000));
    });

    test('applyCrash multiplies every quote', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(stockRepositoryProvider.notifier);
      final beforeFluxon = repo.quoteFor('aktie_fluxon').pricePerShare;
      final affected = repo.applyCrash(0.30);
      expect(affected.length, StockCatalog.all.length);
      expect(
        repo.quoteFor('aktie_fluxon').pricePerShare.cents,
        (beforeFluxon.cents * 0.70).round(),
      );
    });
  });
}
