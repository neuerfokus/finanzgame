import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/forest/tree.dart';
import '../../domain/sim/listeners/forest_listener.dart';
import '../economy/cash_state.dart';

part 'tree_repository.g.dart';

class TreeError implements Exception {
  const TreeError(this.message);
  final String message;
  @override
  String toString() => 'TreeError: $message';
}

/// Spec-45 H3: Mischwald-Wald-Wirtschaft.
///
/// In-Memory KeepAlive (bis Drift-Sammelmigration). Bäume verlieren
/// sich bei App-Restart — akzeptabel für Beta. Day-Listener bucht
/// Holz-Income für reife Bäume pro Tag.
@Riverpod(keepAlive: true)
class TreeRepository extends _$TreeRepository
    implements TreeIncomeSource {
  @override
  List<PlantedTree> build() {
    // Welle-8 Round 9: Drift v15 — Persistent via TreeHoldingsDao.
    Future<void>.microtask(_hydrate);
    return const [];
  }

  /// Analyse-Runde 2026-08: Dieses Repo ist der einzige Ausreißer, der seinen
  /// Bestand ASYNC direkt aus der DB zieht — alle anderen lesen den
  /// synchronen `dbSnapshotProvider`. Seit die Bäume im Netto-Vermögen
  /// mitzählen (M1/M2), mountet `netWorthProvider` es überall mit, auch in
  /// Test-Containern ohne offene DB. Die Microtask lief dann nach Testende in
  /// „QueryExecutor.ensureOpen()" und riss den bereits bestandenen Test mit.
  /// Ein fehlgeschlagener Ladevorgang darf nie mehr sein als eine leere
  /// Liste — schlägt er zu, ist der Zustand derselbe wie vorher.
  Future<void> _hydrate() async {
    if (!ref.mounted) return;
    try {
      final db = ref.read(appDatabaseProvider);
      final rows = await db.treeHoldingsDao.loadAll();
      if (!ref.mounted) return;
      state = [
        for (final r in rows)
          PlantedTree(
            id: r.id,
            kind: _parseKind(r.kind),
            plantedOnDayIndex: r.plantedOnDayIndex,
          ),
      ];
    } on Object {
      // Kein Bestand geladen — Zustand bleibt die leere Liste aus `build`.
    }
  }

  static TreeKind _parseKind(String s) {
    for (final k in TreeKind.values) {
      if (k.name == s) return k;
    }
    return TreeKind.birke;
  }

  void plant(TreeKind kind, int dayIndex) {
    final spec = TreeCatalog.spec(kind);
    final cash = ref.read(cashStateProvider.notifier);
    if (!cash.spend(spec.cost)) {
      throw const TreeError('insufficient cash');
    }
    // Analyse-Runde 2026-08: Der Suffix war `state.length` — fällt man an
    // einem Tag einen Baum und pflanzt danach einen neuen, schrumpft die
    // Liste erst und der neue Baum bekommt eine bereits vergebene ID. Fällen
    // filtert über `id != treeId` und hätte dann BEIDE Bäume entfernt (einer
    // davon bezahlt und weg). Jetzt: kleinster freier Suffix für den Tag.
    final taken = state.map((t) => t.id).toSet();
    var suffix = 0;
    var id = 'tree_${kind.name}_${dayIndex}_$suffix';
    while (taken.contains(id)) {
      suffix += 1;
      id = 'tree_${kind.name}_${dayIndex}_$suffix';
    }
    state = [...state, PlantedTree(id: id, kind: kind, plantedOnDayIndex: dayIndex)];
    // Welle-8 Round 9: persist
    final db = ref.read(appDatabaseProvider);
    unawaited(db.treeHoldingsDao
        .insertTree(id: id, kind: kind.name, plantedOnDayIndex: dayIndex)
        .catchError((Object _) {}));
  }

  /// Spec-45 H3: täglicher Income-Tick. Wird vom ForestListener aufgerufen.
  /// Gibt Gesamt-Income aus.
  @override
  Money collectDailyYield(int dayIndex) {
    var total = 0;
    for (final t in state) {
      if (!t.isMature(dayIndex)) continue;
      total += TreeCatalog.spec(t.kind).dailyYield.cents;
    }
    if (total <= 0) return Money.zero;
    final amount = Money.cents(total);
    ref.read(cashStateProvider.notifier).earn(amount);
    return amount;
  }

  int matureCount(int dayIndex) =>
      state.where((t) => t.isMature(dayIndex)).length;

  int growingCount(int dayIndex) =>
      state.where((t) => !t.isMature(dayIndex)).length;

  /// Holzschlag — Baum fällen. Nur reife Bäume.
  ///
  /// Der Erlös ist seit 2026-08 der Verkehrswert (`fellingValue`): der
  /// Anschaffungswert anteilig zum Reifegrad plus ein Monatsertrag Holz.
  /// Vorher gab es NUR `30 × Tagesertrag` — eine Eiche für 500 € brachte
  /// 2,40 €. Da Bäume im Vermögen zum Anschaffungswert zählen, vernichtete
  /// jedes Fällen fast den vollen Kaufpreis.
  Money fellTree(String treeId, int dayIndex) {
    final tree = state.firstWhere(
      (t) => t.id == treeId,
      orElse: () => throw const TreeError('tree not found'),
    );
    if (!tree.isMature(dayIndex)) {
      throw const TreeError('tree not yet mature');
    }
    final payout = tree.fellingValue(dayIndex);
    ref.read(cashStateProvider.notifier).earn(payout);
    state = state.where((t) => t.id != treeId).toList();
    // Welle-8 Round 9: persist
    final db = ref.read(appDatabaseProvider);
    unawaited(db.treeHoldingsDao
        .deleteById(treeId)
        .catchError((Object _) {}));
    return payout;
  }
}
