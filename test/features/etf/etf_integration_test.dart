import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/etf/etf_repository.dart';

void main() {
  test('30 days of advanceDay shifts welt_korb price', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);

    final repo = c.read(etfRepositoryProvider.notifier);
    repo.buy(etfId: 'welt_korb', shares: 3);
    final priceBefore = repo.quoteFor('welt_korb').pricePerShare;

    for (var i = 0; i < 30; i++) {
      await c.read(gameClockProvider.notifier).advanceDay();
    }

    final priceAfter = repo.quoteFor('welt_korb').pricePerShare;
    // Volatility allows movement in either direction — assert that the
    // pipeline actually ran by checking the price changed.
    expect(priceAfter, isNot(priceBefore));
    expect(repo.quoteFor('welt_korb').onDayIndex, 30);
  });

  test('sell after 30 days returns liquidity to cash', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);

    final repo = c.read(etfRepositoryProvider.notifier);
    repo.buy(etfId: 'welt_korb', shares: 2);
    final cashAfterBuy = c.read(cashStateProvider);

    for (var i = 0; i < 30; i++) {
      await c.read(gameClockProvider.notifier).advanceDay();
    }
    repo.sell(etfId: 'welt_korb', shares: 2);
    expect(repo.holdingFor('welt_korb'), isNull);
    // Some cash returned — exact amount depends on price drift.
    expect(c.read(cashStateProvider), greaterThan(cashAfterBuy));
  });
}
