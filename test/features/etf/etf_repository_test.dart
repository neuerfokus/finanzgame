import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/etf/etf.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/etf/etf_repository.dart';

ProviderContainer _container({Money cash = const Money.cents(200000)}) {
  final c = ProviderContainer();
  c.read(cashStateProvider.notifier).state = cash;
  return c;
}

void main() {
  group('EtfRepository', () {
    test('initial quotes seeded from catalog', () {
      final c = _container();
      addTearDown(c.dispose);
      final p = c.read(etfRepositoryProvider);
      expect(p.quotes.length, EtfCatalog.all.length);
      for (final spec in EtfCatalog.all) {
        expect(p.quotes[spec.id]!.pricePerShare, spec.initialPrice);
      }
    });

    test('buy creates holding + deducts cash', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(etfRepositoryProvider.notifier);
      repo.buy(etfId: 'welt_korb', shares: 2);
      final h = repo.holdingFor('welt_korb')!;
      expect(h.shares, 2);
      expect(h.averageBuyPrice, EtfCatalog.weltKorb.initialPrice);
      // Round 27: weltKorb 110 €. 2 shares = 220 €. Initial cash 2000 € → 1780 € rest.
      expect(c.read(cashStateProvider), const Money.cents(178000));
    });

    test('buy averages cost basis across two buys', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(etfRepositoryProvider.notifier);
      repo.buy(etfId: 'welt_korb', shares: 2);
      // Pretend price moved before second buy.
      repo.updateQuote(
        const EtfQuote(
          etfId: 'welt_korb',
          pricePerShare: Money.cents(12000),
          onDayIndex: 1,
        ),
      );
      repo.buy(etfId: 'welt_korb', shares: 2);
      final h = repo.holdingFor('welt_korb')!;
      expect(h.shares, 4);
      // Round 27: Avg = (11000*2 + 12000*2) / 4 = 11500
      expect(h.averageBuyPrice, const Money.cents(11500));
    });

    test('sell credits cash + drops holding when shares hit 0', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(etfRepositoryProvider.notifier);
      repo.buy(etfId: 'welt_korb', shares: 2);
      repo.sell(etfId: 'welt_korb', shares: 2);
      expect(repo.holdingFor('welt_korb'), isNull);
      expect(c.read(cashStateProvider), const Money.cents(200000));
    });

    test('throws on insufficient cash / shares', () {
      final c = _container(cash: const Money.cents(50));
      addTearDown(c.dispose);
      final repo = c.read(etfRepositoryProvider.notifier);
      expect(
        () => repo.buy(etfId: 'welt_korb', shares: 1),
        throwsA(isA<EtfError>()),
      );
      expect(
        () => repo.sell(etfId: 'welt_korb', shares: 1),
        throwsA(isA<EtfError>()),
      );
    });
  });
}
