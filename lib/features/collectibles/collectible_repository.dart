import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/game_clock.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/collectibles/collectible.dart';
import '../../domain/economy/money.dart';
import '../economy/cash_state.dart';
import '../xp/xp_repository.dart';

part 'collectible_repository.g.dart';

/// Spec-38 Welle 5: persistente Sammlerobjekt-Holdings.
/// Mehrere Exemplare pro specId möglich — jede Holding hat eigene
/// Drift-row-id und boughtAtDayIndex (für Wertberechnung).
@Riverpod(keepAlive: true)
class CollectibleRepository extends _$CollectibleRepository {
  @override
  List<CollectibleHolding> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return [
      for (final row in snap.collectibleHoldings)
        CollectibleHolding(
          rowId: row.rowId,
          specId: row.specId,
          boughtAtDayIndex: row.boughtAtDayIndex,
          boughtPrice: Money.cents(row.boughtPriceCents),
        ),
    ];
  }

  Money currentValueOf(CollectibleHolding h, int currentDayIndex) {
    final yearsHeld = (currentDayIndex - h.boughtAtDayIndex) / 365.0;
    return CollectibleCatalog.byId(h.specId).valueAfter(yearsHeld);
  }

  Money totalCurrentValue(int currentDayIndex) {
    var total = 0;
    for (final h in state) {
      total += currentValueOf(h, currentDayIndex).cents;
    }
    return Money.cents(total);
  }

  Future<bool> buy(CollectibleSpec spec) async {
    final cash = ref.read(cashStateProvider.notifier);
    if (!cash.canAfford(spec.basePrice)) return false;
    cash.spend(spec.basePrice);
    final day = ref.read(gameClockProvider).dayIndex;
    final db = ref.read(appDatabaseProvider);
    final rowId = await db.collectibleDao.insertHolding(
      specId: spec.id,
      boughtAtDayIndex: day,
      boughtPriceCents: spec.basePrice.cents,
    );
    state = [
      ...state,
      CollectibleHolding(
        rowId: rowId,
        specId: spec.id,
        boughtAtDayIndex: day,
        boughtPrice: spec.basePrice,
      ),
    ];
    ref.read(xpRepositoryProvider.notifier).add(10);
    return true;
  }

  Future<bool> sell(CollectibleHolding holding) async {
    if (!state.any((h) => h.rowId == holding.rowId)) return false;
    final day = ref.read(gameClockProvider).dayIndex;
    final yearsHeld = (day - holding.boughtAtDayIndex) / 365.0;
    final spec = CollectibleCatalog.byId(holding.specId);
    final payout = spec.sellValue(yearsHeld);
    ref.read(cashStateProvider.notifier).earn(payout);
    final db = ref.read(appDatabaseProvider);
    unawaited(db.collectibleDao.deleteRow(holding.rowId)
        .catchError((Object _) {}));
    state = state.where((h) => h.rowId != holding.rowId).toList();
    return true;
  }

  // ── Spec-44 F1 sprint F: Listing-Workflow ─────────────────────────────────

  /// Markiert ein Holding als "zum Verkauf angeboten". Geld kommt erst nach
  /// `spec.sellDelayDays` über [settleListings].
  bool listForSale(CollectibleHolding holding) {
    final idx = state.indexWhere((h) => h.rowId == holding.rowId);
    if (idx < 0) return false;
    if (state[idx].isListed) return false;
    final day = ref.read(gameClockProvider).dayIndex;
    final next = [...state];
    next[idx] = state[idx].copyWith(listedOnDay: day);
    state = next;
    return true;
  }

  /// Nimmt ein Listing wieder vom Markt — Holding bleibt im Bestand.
  bool cancelListing(CollectibleHolding holding) {
    final idx = state.indexWhere((h) => h.rowId == holding.rowId);
    if (idx < 0) return false;
    if (!state[idx].isListed) return false;
    final next = [...state];
    next[idx] = state[idx].copyWith(clearListing: true);
    state = next;
    return true;
  }

  /// Sofortverkauf mit Extra-Abschlag von 5 % auf den bestehenden Spread.
  /// Spec F1: "Sofortverkauf nur mit Extra-Abschlag".
  Future<bool> instantSell(CollectibleHolding holding) async {
    if (!state.any((h) => h.rowId == holding.rowId)) return false;
    final day = ref.read(gameClockProvider).dayIndex;
    final yearsHeld = (day - holding.boughtAtDayIndex) / 365.0;
    final spec = CollectibleCatalog.byId(holding.specId);
    final basePayout = spec.sellValue(yearsHeld);
    // Zusätzlicher 5 %-Abschlag.
    final payout = Money.cents((basePayout.cents * 0.95).round());
    ref.read(cashStateProvider.notifier).earn(payout);
    final db = ref.read(appDatabaseProvider);
    unawaited(db.collectibleDao.deleteRow(holding.rowId)
        .catchError((Object _) {}));
    state = state.where((h) => h.rowId != holding.rowId).toList();
    return true;
  }

  /// Pipeline-Hook: in [GameClock.advanceDay] aufgerufen. Wickelt alle
  /// Listings ab, deren `sellDelayDays` erreicht ist — entfernt das Holding
  /// und schreibt den Erlös auf Cash.
  Future<void> settleListings(int currentDayIndex) async {
    final due = <CollectibleHolding>[];
    for (final h in state) {
      final listedOn = h.listedOnDay;
      if (listedOn == null) continue;
      final spec = CollectibleCatalog.byId(h.specId);
      if (currentDayIndex - listedOn >= spec.sellDelayDays) {
        due.add(h);
      }
    }
    for (final h in due) {
      await sell(h);
    }
  }
}
