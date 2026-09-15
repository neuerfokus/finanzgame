import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../xp/xp_repository.dart';

part 'real_milestones_repository.g.dart';

/// Welle-8 Round 24 (#10): ein von einem Elternteil eingetragener echter Erfolg.
/// Plain-Model (kein Drift-Row) — riverpod_generator kann generierte
/// Drift-Rows nicht als Notifier-State-Generic verarbeiten.
class RealMilestone {
  const RealMilestone({
    required this.rowId,
    required this.emoji,
    required this.title,
    required this.amountCents,
    required this.dateIso,
    required this.category,
  });

  final int rowId;
  final String emoji;
  final String title;
  final int? amountCents;
  final String dateIso;

  /// sparen/lernen/verzicht/sonstiges — leer bei Alt-Einträgen.
  final String category;

  static RealMilestone fromRow(RealMilestoneRow r) => RealMilestone(
        rowId: r.rowId,
        emoji: r.emoji,
        title: r.title,
        amountCents: r.amountCents,
        dateIso: r.dateIso,
        category: r.category,
      );
}

/// Welle-8 Round 26: XP-Belohnung pro eingetragenem echten Erfolg.
/// Echtes Spar-/Lern-Verhalten fließt so ins Spiel (Level/Fortschritt).
const int kRealMilestoneXp = 150;

/// Echte Erfolge des Kindes, die ein Elternteil im Eltern-Modus (PIN-geschützt)
/// einträgt. Reine Eltern-kuratierte Liste — keine Spiel-Mechanik, nur
/// Anzeige in der Zimmer-Trophäenwand. Persistent via [RealMilestonesTable]
/// (Drift v26). Neueste zuerst.
@Riverpod(keepAlive: true)
class RealMilestonesRepository extends _$RealMilestonesRepository {
  @override
  List<RealMilestone> build() {
    return [
      for (final r in ref.watch(dbSnapshotProvider).realMilestones)
        RealMilestone.fromRow(r),
    ];
  }

  AppDatabase get _db => ref.read(appDatabaseProvider);

  /// Fügt einen Erfolg hinzu. [amountCents] optional (null = ohne Betrag).
  /// Belohnt mit [kRealMilestoneXp] — echtes Verhalten wirkt ins Spiel.
  Future<void> add({
    required String emoji,
    required String title,
    int? amountCents,
    required String dateIso,
    String category = '',
  }) async {
    await _db.realMilestonesDao.add(
      emoji: emoji,
      title: title,
      amountCents: amountCents,
      dateIso: dateIso,
      category: category,
    );
    ref.read(xpRepositoryProvider.notifier).add(kRealMilestoneXp);
    await _reload();
  }

  Future<void> remove(int rowId) async {
    await _db.realMilestonesDao.deleteRow(rowId);
    await _reload();
  }

  Future<void> _reload() async {
    final rows = await _db.realMilestonesDao.loadAll();
    state = [for (final r in rows) RealMilestone.fromRow(r)];
  }
}
