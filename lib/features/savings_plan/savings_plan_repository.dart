import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/day_event.dart';
import '../../domain/sim/day_event_listener.dart';
import '../../domain/sim/game_day.dart';
import '../economy/cash_state.dart';
import '../etf/etf_repository.dart';
import 'savings_plan.dart';

part 'savings_plan_repository.g.dart';

@Riverpod(keepAlive: true)
class SavingsPlanRepository extends _$SavingsPlanRepository {
  @override
  List<SavingsPlan> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return [
      for (final r in snap.savingsPlans)
        SavingsPlan(
          id: r.id,
          assetClass: r.assetClass,
          assetId: r.assetId,
          monthly: Money.cents(r.monthlyCents),
          startedOnDayIndex: r.startedOnDayIndex,
        ),
    ];
  }

  void add(SavingsPlan plan) {
    state = [...state, plan];
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.savingsPlansDao
          .upsert(SavingsPlanRow(
            id: plan.id,
            assetClass: plan.assetClass,
            assetId: plan.assetId,
            monthlyCents: plan.monthly.cents,
            startedOnDayIndex: plan.startedOnDayIndex,
          ))
          .catchError((Object _) {}),
    );
  }

  void remove(String id) {
    state = state.where((p) => p.id != id).toList();
    final db = ref.read(appDatabaseProvider);
    unawaited(db.savingsPlansDao.deletePlan(id).catchError((Object _) {}));
  }
}

/// spec-36 phase C: monthly DCA execution. Pro Sparplan kauft das Asset
/// im konfigurierten Betrag. Pragma-cut: nur ETF-Sparplan implementiert.
class SavingsPlanListener implements DayEventListener {
  const SavingsPlanListener(this.ref);
  final Ref ref;

  static const int cadence = 30;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex == 0 || newDay.dayIndex % cadence != 0) {
      return const [];
    }
    final plans = ref.read(savingsPlanRepositoryProvider);
    if (plans.isEmpty) return const [];
    final events = <DayEvent>[];
    final cash = ref.read(cashStateProvider.notifier);
    for (final p in plans) {
      if (!cash.canAfford(p.monthly)) continue;
      if (p.assetClass != 'etf') continue;
      final etf = ref.read(etfRepositoryProvider.notifier);
      final quote = ref.read(etfRepositoryProvider).quotes[p.assetId];
      if (quote == null) continue;
      final shares = p.monthly.cents ~/ quote.pricePerShare.cents;
      if (shares <= 0) continue;
      try {
        etf.buy(etfId: p.assetId, shares: shares);
        events.add(DayEvent.savingsPlanExecuted(
          amount: quote.pricePerShare * shares,
          targetAssetId: p.assetId,
        ));
      } on Object {
        // skip on failure (e.g. insufficient cash after rounding)
      }
    }
    return events;
  }
}
