import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/etf/etf.dart';
import 'package:finanzgame/domain/stock/stock.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/history/asset_labels.dart';
import 'package:finanzgame/features/history/history_repository.dart';

void main() {
  test('history seeds with initial prices for ETFs + Stocks', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final repo = c.read(historyRepositoryProvider.notifier);
    for (final s in EtfCatalog.all) {
      expect(repo.seriesFor(s.id), [s.initialPrice]);
    }
    for (final s in StockCatalog.all) {
      expect(repo.seriesFor(s.id), [s.initialPrice]);
    }
  });

  test('advanceDay appends one snapshot per asset', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);

    final repo = c.read(historyRepositoryProvider.notifier);
    final lengthBefore = repo.seriesFor('welt_korb').length;

    for (var i = 0; i < 5; i++) {
      await c.read(gameClockProvider.notifier).advanceDay();
    }

    final lengthAfter = repo.seriesFor('welt_korb').length;
    expect(lengthAfter - lengthBefore, 5);
  });

  test('seriesPoints returns (dayIndex, cents) tuples for an aggregate id',
      () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);

    for (var i = 0; i < 3; i++) {
      await c.read(gameClockProvider.notifier).advanceDay();
    }
    final repo = c.read(historyRepositoryProvider.notifier);
    final points = repo.seriesPoints(HistoryAssetIds.cash);
    expect(points.length, 3);
    expect(points.map((p) => p.$1).toList(), [1, 2, 3]);
  });

  test('assetIdsAvailable surfaces aggregate ids after first advance',
      () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);
    await c.read(gameClockProvider.notifier).advanceDay();

    final repo = c.read(historyRepositoryProvider.notifier);
    final ids = repo.assetIdsAvailable;
    expect(ids, contains(HistoryAssetIds.cash));
    expect(ids, contains(HistoryAssetIds.etfIndex));
    expect(ids, contains(HistoryAssetIds.stockIndex));
    expect(ids, contains(HistoryAssetIds.wishlistCpi));
    expect(ids, contains(HistoryAssetIds.sparYield));
    expect(ids, isNot(contains(HistoryAssetIds.crashMarker)),
        reason: 'crashMarker is internal, must not be selectable');
  });

  test('wishlist_cpi reads 100 on first record (baseline anchored)',
      () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);
    await c.read(gameClockProvider.notifier).advanceDay();

    final repo = c.read(historyRepositoryProvider.notifier);
    final points = repo.seriesPoints(HistoryAssetIds.wishlistCpi);
    expect(points, hasLength(1));
    // After exactly one day the inflation listener has nudged prices
    // slightly upward, so the index sits at 100 or 101 — never lower.
    expect(points.first.$2, inInclusiveRange(100, 102));
  });

  test('wishlist_cpi rises (or stays) as inflation accumulates', () async {
    // v29: 2 %/J Basis-Inflation → über 30 Tage nur +~0,16 %.
    // Index in Ganzzahl-Cents kann 100→100 bleiben. Längeres Run +
    // monotonic via >=.
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(cashStateProvider.notifier).state = const Money.cents(50000);
    for (var i = 0; i < 365; i++) {
      await c.read(gameClockProvider.notifier).advanceDay();
    }
    final repo = c.read(historyRepositoryProvider.notifier);
    final points = repo.seriesPoints(HistoryAssetIds.wishlistCpi);
    expect(points, hasLength(365));
    expect(points.last.$2, greaterThan(points.first.$2));
  });
}
