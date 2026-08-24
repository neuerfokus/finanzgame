import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';

part 'lifetime_harvest_state.g.dart';

/// Lifetime cents earned from plant harvests.
///
/// Seeded from [DbSnapshot.lifetimeHarvestCents]; incremented by
/// [PlantRepository.harvest]. Used by [MonetariaUnlocker] to gate the
/// ETF-island unlock (≥ 20 €). Only ever grows.
@Riverpod(keepAlive: true)
class LifetimeHarvestState extends _$LifetimeHarvestState {
  @override
  int build() {
    final snap = ref.watch(dbSnapshotProvider);
    return snap.lifetimeHarvestCents ?? 0;
  }

  /// Adds [cents] to the lifetime total and persists fire-and-forget.
  void addCents(int cents) {
    if (cents <= 0) return;
    state = state + cents;
    final db = ref.read(appDatabaseProvider);
    unawaited(db.cashDao.addHarvest(cents).catchError((Object _) {}));
  }
}
