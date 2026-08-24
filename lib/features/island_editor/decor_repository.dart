import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../economy/cash_state.dart';
import 'decor_catalog.dart';

part 'decor_repository.g.dart';

/// In-memory representation einer platzierten Decor-Instanz.
class DecorPlacement {
  const DecorPlacement({
    required this.rowId,
    required this.islandId,
    required this.decorId,
    required this.x,
    required this.y,
    required this.rotation,
  });

  /// Persisted PK (auto-increment).
  final int rowId;
  final String islandId;
  final String decorId;

  /// 0..1 normalisierte Position.
  final double x;
  final double y;

  /// 0..3 (×90°).
  final int rotation;

  DecorPlacement copyWith({double? x, double? y, int? rotation}) {
    return DecorPlacement(
      rowId: rowId,
      islandId: islandId,
      decorId: decorId,
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
    );
  }
}

/// Spec-43 Stage 1: persistente Decor-Platzierungen pro Insel.
///
/// Hält den Vollzustand im Speicher (klein, max ~9 × 8 = 72 Einträge),
/// schreibt Mutationen sofort in Drift via [IslandDecorDao].
@Riverpod(keepAlive: true)
class DecorRepository extends _$DecorRepository {
  @override
  List<DecorPlacement> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return [
      for (final row in snap.islandDecor)
        DecorPlacement(
          rowId: row.rowId,
          islandId: row.islandId,
          decorId: row.decorId,
          x: row.x,
          y: row.y,
          rotation: row.rotation,
        ),
    ];
  }

  /// Platzierungen einer einzelnen Insel.
  List<DecorPlacement> forIsland(String islandId) =>
      state.where((p) => p.islandId == islandId).toList();

  /// Neues Decor platzieren. Cap: [kMaxDecorPerIsland] pro Insel.
  /// Liefert die neue Platzierung mit gesetzter rowId, oder null wenn
  /// Cap erreicht / Item nicht freigeschaltet.
  Future<DecorPlacement?> place({
    required String islandId,
    required String decorId,
    required double x,
    required double y,
    int rotation = 0,
  }) async {
    if (decorSpecById(decorId) == null) return null;
    if (forIsland(islandId).length >= kMaxDecorPerIsland) return null;
    final db = ref.read(appDatabaseProvider);
    final rowId = await db.islandDecorDao.insertPlacement(
      islandId: islandId,
      decorId: decorId,
      x: x.clamp(0.0, 1.0),
      y: y.clamp(0.0, 1.0),
      rotation: rotation & 3,
    );
    final placement = DecorPlacement(
      rowId: rowId,
      islandId: islandId,
      decorId: decorId,
      x: x.clamp(0.0, 1.0),
      y: y.clamp(0.0, 1.0),
      rotation: rotation & 3,
    );
    state = [...state, placement];
    return placement;
  }

  /// Verschieben + Rotieren in-place. Schreibt asynchron in DB.
  Future<void> update(DecorPlacement placement) async {
    state = [
      for (final p in state)
        if (p.rowId == placement.rowId) placement else p,
    ];
    final db = ref.read(appDatabaseProvider);
    unawaited(db.islandDecorDao
        .updatePlacement(
          rowId: placement.rowId,
          x: placement.x.clamp(0.0, 1.0),
          y: placement.y.clamp(0.0, 1.0),
          rotation: placement.rotation & 3,
        )
        .catchError((Object _) {}));
  }

  /// Entfernen.
  Future<void> remove(int rowId) async {
    state = state.where((p) => p.rowId != rowId).toList();
    final db = ref.read(appDatabaseProvider);
    unawaited(
        db.islandDecorDao.deleteRow(rowId).catchError((Object _) {}));
  }

  /// Spec-43 v2: Kauf via Cash für Zimmer (auto-Platzierung mittig).
  /// Liefert true bei Erfolg.
  Future<bool> buyForZimmer(DecorSpec spec) async {
    final cash = ref.read(cashStateProvider.notifier);
    final price = Money.cents(spec.priceCents);
    if (!cash.canAfford(price)) return false;
    if (forIsland('zimmer').length >= kMaxDecorPerIsland) return false;
    cash.spend(price);
    await place(islandId: 'zimmer', decorId: spec.id, x: 0.5, y: 0.5);
    return true;
  }

  /// Spec-43 v2: Verkauf einer Zimmer-Decor-Instanz für 50 % des
  /// Original-Einkaufspreises. Greift die jüngste Platzierung des
  /// `decorId` ab. Liefert true bei Erfolg.
  Future<bool> sellOneFromZimmer(String decorId) async {
    final spec = decorSpecById(decorId);
    if (spec == null) return false;
    final candidates =
        state.where((p) => p.islandId == 'zimmer' && p.decorId == decorId);
    if (candidates.isEmpty) return false;
    final target = candidates.last;
    await remove(target.rowId);
    final refund = Money.cents(spec.priceCents ~/ 2);
    ref.read(cashStateProvider.notifier).earn(refund);
    return true;
  }

  /// Zählt Anzahl gekaufter Instanzen pro Decor-Id im Zimmer.
  int zimmerCountOf(String decorId) =>
      state.where((p) => p.islandId == 'zimmer' && p.decorId == decorId).length;
}
