import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/game_clock.dart';
import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/listeners/inflation_listener.dart';
import '../../domain/wishlist/wish_item.dart';
import '../economy/cash_state.dart';
import '../history/consumption_log.dart';

part 'wishlist_repository.g.dart';

class WishlistError implements Exception {
  const WishlistError(this.message);
  final String message;
  @override
  String toString() => 'WishlistError: $message';
}

/// Persisted wishlist. Static fields (name/category/basePrice/emoji) come
/// from [kWishCatalog]; only the mutable bits (currentPrice + ownedOnDayIndex)
/// live in the DB.
@Riverpod(keepAlive: true)
class WishlistRepository extends _$WishlistRepository
    implements WishlistInflationSource {
  @override
  List<WishItem> build() {
    final snap = ref.watch(dbSnapshotProvider);
    final overrides = <String, WishItemRow>{
      for (final r in snap.wishItems) r.id: r,
    };
    return [
      for (final base in kWishCatalog)
        if (overrides[base.id] case final row?)
          base.copyWith(
            currentPrice: Money.cents(row.currentPriceCents),
            ownedOnDayIndex: row.ownedOnDayIndex,
            photoPath: row.photoPath,
          )
        else
          base,
    ];
  }

  /// Welle-8 Round 16: Foto-Pfad pro Item setzen (null = entfernen).
  void setPhotoPath(String itemId, String? path) {
    final item = byId(itemId);
    if (item == null) return;
    state = [
      for (final i in state)
        if (i.id == itemId) i.copyWith(photoPath: path) else i,
    ];
    _persistOne(byId(itemId)!);
  }

  @override
  List<WishItem> active() =>
      state.where((i) => i.ownedOnDayIndex == null).toList();

  List<WishItem> owned() =>
      state.where((i) => i.ownedOnDayIndex != null).toList();

  WishItem? byId(String id) {
    for (final i in state) {
      if (i.id == id) return i;
    }
    return null;
  }

  @override
  void inflate() {
    state = [
      for (final i in state)
        if (i.ownedOnDayIndex != null)
          i
        else
          i.copyWith(
            currentPrice: Money.cents(
              (i.currentPrice.cents *
                      (1 + InflationConfig.dailyDriftFor(i.category)))
                  .round(),
            ),
          ),
    ];
    _persistAll();
  }

  void buy(String itemId) {
    final item = byId(itemId);
    if (item == null) throw WishlistError('unknown item $itemId');
    if (item.ownedOnDayIndex != null) {
      throw const WishlistError('already owned');
    }
    final cashNotifier = ref.read(cashStateProvider.notifier);
    if (!cashNotifier.spend(item.currentPrice)) {
      throw const WishlistError('insufficient cash');
    }
    final today = ref.read(gameClockProvider).dayIndex;
    state = [
      for (final i in state)
        if (i.id == itemId) i.copyWith(ownedOnDayIndex: today) else i,
    ];
    final updated = byId(itemId)!;
    _persistOne(updated);
    // Spec-44 E1: Konsum-Log für Opportunitätskosten-Schattenlinie.
    ref.read(consumptionLogProvider.notifier).add(
          dayIndex: today,
          cents: item.currentPrice.cents,
          label: item.name,
        );
  }

  void _persistOne(WishItem item) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.wishItemsDao
          .upsert(WishItemRow(
            id: item.id,
            currentPriceCents: item.currentPrice.cents,
            ownedOnDayIndex: item.ownedOnDayIndex,
            photoPath: item.photoPath,
          ))
          .catchError((Object _) {}),
    );
  }

  void _persistAll() {
    final db = ref.read(appDatabaseProvider);
    final rows = [
      for (final i in state)
        WishItemRow(
          id: i.id,
          currentPriceCents: i.currentPrice.cents,
          ownedOnDayIndex: i.ownedOnDayIndex,
          // Round 27 v4 BUGFIX: photoPath MUSS mit — sonst nullte der
          // tägliche inflate()→_persistAll-Aufruf alle Foto-Pfade in der
          // DB (gekaufte/gewünschte Items verloren ihr Bild nach 1 Tag).
          photoPath: i.photoPath,
        ),
    ];
    unawaited(db.wishItemsDao.upsertAll(rows).catchError((Object _) {}));
  }
}
