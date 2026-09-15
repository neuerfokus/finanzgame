import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../economy/cash_state.dart';
import 'furniture_catalog.dart';

part 'furniture_repository.g.dart';

/// Spec-29 + spec-38 P2-19: tracks owned furniture items (multiple per slot
/// allowed) + which item is currently "active" in each slot for the Zimmer
/// diorama layout.
///
/// Welle-8: jetzt persistent (FurnitureTable, Drift v22). Vorher
/// in-memory-only → Möbel gingen bei jedem App-Neustart verloren
/// (Test-Bug "Stuhl weg nach Spiel verlassen").
@Riverpod(keepAlive: true)
class FurnitureRepository extends _$FurnitureRepository {
  @override
  Map<FurnitureSlot, String> build() {
    // state = aktuell angezeigtes Item pro Slot. _owned trägt die volle
    // Sammlung. Beides + Position/Sichtbarkeit aus dem DB-Snapshot
    // rekonstruiert.
    final rows = ref.watch(dbSnapshotProvider).furniture;
    final active = <FurnitureSlot, String>{};
    for (final r in rows) {
      _owned.add(r.itemId);
      if (r.hidden) _hidden.add(r.itemId);
      if (r.posX != null && r.posY != null) {
        _itemPositions[r.itemId] = (r.posX!, r.posY!);
      }
      if (r.active) {
        final slot = _slotFromName(r.slot);
        if (slot != null) active[slot] = r.itemId;
      }
    }
    return active;
  }

  final Set<String> _owned = <String>{};

  // v28→v29: User-Positionen pro ITEM-ID (nicht pro Slot), damit
  // mehrere Items derselben Kategorie gleichzeitig im Zimmer
  // platzierbar sind. null = Default aus Slot-Anchor + Jitter.
  final Map<String, (double, double)> _itemPositions = {};

  // v29: Sichtbarkeit pro Item-ID. Default: alle owned sichtbar.
  final Set<String> _hidden = <String>{};

  static FurnitureSlot? _slotFromName(String name) {
    for (final s in FurnitureSlot.values) {
      if (s.name == name) return s;
    }
    return null;
  }

  static FurnitureItem? _itemById(String id) {
    for (final i in FurnitureCatalog.items) {
      if (i.id == id) return i;
    }
    return null;
  }

  (double, double)? positionForItem(String itemId) => _itemPositions[itemId];

  void setItemPosition(String itemId, double x, double y) {
    _itemPositions[itemId] = (x, y);
    state = {...state};
    _persistItem(itemId);
  }

  bool isItemVisible(String itemId) => !_hidden.contains(itemId);

  void toggleItemVisible(String itemId) {
    if (_hidden.contains(itemId)) {
      _hidden.remove(itemId);
    } else {
      _hidden.add(itemId);
    }
    state = {...state};
    _persistItem(itemId);
  }

  /// True when [item] has been purchased (regardless of slot-active state).
  bool isOwned(FurnitureItem item) => _owned.contains(item.id);

  /// True when [item] is currently displayed in its slot.
  bool isActive(FurnitureItem item) => state[item.slot] == item.id;

  /// All purchased item-ids (read-only view).
  Set<String> get ownedIds => Set.unmodifiable(_owned);

  /// Buys [item]. Spec-38: same item can NOT be bought twice but different
  /// items in the same slot can all be owned. The newly-bought item becomes
  /// the slot-active display so the room reflects the recent purchase.
  bool buy(FurnitureItem item) {
    if (_owned.contains(item.id)) return false;
    final cash = ref.read(cashStateProvider.notifier);
    if (!cash.canAfford(item.price)) return false;
    cash.spend(item.price);
    _owned.add(item.id);
    state = {...state, item.slot: item.id};
    // Das neu gekaufte Item ist aktiv → vorher aktives Item im selben Slot
    // verliert active. Beide persistieren.
    _persistSlot(item.slot);
    return true;
  }

  /// Spec-38 P2-19: swap which owned item is displayed in [slot].
  void setActive(FurnitureSlot slot, String itemId) {
    if (!_owned.contains(itemId)) return;
    state = {...state, slot: itemId};
    _persistSlot(slot);
  }

  /// Spec-38 follow-up: verkauft [item] für 50 % des Preises. Wenn das
  /// Möbel gerade im Slot aktiv ist, wird der Slot geleert.
  bool sell(FurnitureItem item) {
    if (!_owned.contains(item.id)) return false;
    _owned.remove(item.id);
    // Welle-8: Position + Hidden-Flag aufräumen damit nach Re-Buy nicht
    // alte Position wieder verwendet wird.
    _itemPositions.remove(item.id);
    _hidden.remove(item.id);
    final cash = ref.read(cashStateProvider.notifier);
    cash.earn(Money.cents(item.price.cents ~/ 2));
    if (state[item.slot] == item.id) {
      final next = {...state};
      next.remove(item.slot);
      state = next;
    } else {
      // Trigger rebuild so shop reflects new owned-state.
      state = {...state};
    }
    _deleteItem(item.id);
    return true;
  }

  /// Persistiert ein einzelnes Item (Besitz/aktiv/Position/sichtbar).
  void _persistItem(String itemId) {
    final item = _itemById(itemId);
    if (item == null || !_owned.contains(itemId)) return;
    final db = ref.read(appDatabaseProvider);
    final pos = _itemPositions[itemId];
    unawaited(
      db.furnitureDao
          .upsert(
            itemId: itemId,
            slot: item.slot.name,
            active: state[item.slot] == itemId,
            hidden: _hidden.contains(itemId),
            posX: pos?.$1,
            posY: pos?.$2,
          )
          .catchError((Object _) {}),
    );
  }

  /// Persistiert alle besessenen Items eines Slots — nötig nach
  /// setActive/buy weil sich das active-Flag mehrerer Items ändert.
  void _persistSlot(FurnitureSlot slot) {
    for (final id in _owned) {
      final item = _itemById(id);
      if (item != null && item.slot == slot) _persistItem(id);
    }
  }

  void _deleteItem(String itemId) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.furnitureDao.deleteItem(itemId).catchError((Object _) {}));
  }
}
