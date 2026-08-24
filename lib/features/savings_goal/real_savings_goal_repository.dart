import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../xp/xp_repository.dart';
import '../zimmer/achievements_repository.dart';

part 'real_savings_goal_repository.g.dart';

/// Welle C: Status eines echten Sparziels.
enum SavingsGoalStatus { active, reached, confirmed }

SavingsGoalStatus _statusFromString(String s) {
  switch (s) {
    case 'reached':
      return SavingsGoalStatus.reached;
    case 'confirmed':
      return SavingsGoalStatus.confirmed;
    default:
      return SavingsGoalStatus.active;
  }
}

/// Plain-Model (kein Drift-Row) — riverpod_generator kann generierte
/// Drift-Rows nicht als Notifier-State-Generic verarbeiten.
class RealSavingsGoal {
  const RealSavingsGoal({
    required this.rowId,
    required this.emoji,
    required this.title,
    required this.targetCents,
    required this.savedCents,
    required this.status,
    required this.createdIso,
    required this.confirmedIso,
  });

  final int rowId;
  final String emoji;
  final String title;
  final int targetCents;
  final int savedCents;
  final SavingsGoalStatus status;
  final String createdIso;
  final String confirmedIso;

  /// Fortschritt 0..1 (gedeckelt).
  double get progress =>
      targetCents <= 0 ? 1 : (savedCents / targetCents).clamp(0.0, 1.0);

  bool get isReached => savedCents >= targetCents;

  static RealSavingsGoal fromRow(RealSavingsGoalRow r) => RealSavingsGoal(
        rowId: r.rowId,
        emoji: r.emoji,
        title: r.title,
        targetCents: r.targetCents,
        savedCents: r.savedCents,
        status: _statusFromString(r.status),
        createdIso: r.createdIso,
        confirmedIso: r.confirmedIso,
      );
}

/// In-Game-XP-Belohnung wenn ein echtes Sparziel von den Eltern bestätigt
/// wird. Skaliert mild mit dem Zielbetrag (in €), gedeckelt — das echte
/// Sparverhalten soll spürbar ins Spiel wirken, ohne es zu sprengen.
int savingsGoalRewardXp(int targetCents) {
  final eur = targetCents ~/ 100;
  final xp = 100 + eur; // 50 € → 150 XP, 200 € → 300 XP
  if (xp < 100) return 100;
  if (xp > 600) return 600;
  return xp;
}

/// Welle C: echte Sparziele des Kindes. Erstellen + Fortschritt eintragen
/// sind kind-zugänglich; das Bestätigen (Belohnung) ist Eltern-PIN-gated
/// (in der UI). Persistent via [RealSavingsGoalsTable] (Drift v33).
@Riverpod(keepAlive: true)
class RealSavingsGoalRepository extends _$RealSavingsGoalRepository {
  @override
  List<RealSavingsGoal> build() {
    return [
      for (final r in ref.watch(dbSnapshotProvider).realSavingsGoals)
        RealSavingsGoal.fromRow(r),
    ];
  }

  AppDatabase get _db => ref.read(appDatabaseProvider);

  /// Das aktuell offene Ziel (active oder reached), neuestes zuerst. Null
  /// wenn keins offen ist.
  RealSavingsGoal? get activeGoal {
    for (final g in state) {
      if (g.status != SavingsGoalStatus.confirmed) return g;
    }
    return null;
  }

  Future<void> createGoal({
    required String emoji,
    required String title,
    required int targetCents,
    required String createdIso,
  }) async {
    await _db.realSavingsGoalsDao.add(
      emoji: emoji,
      title: title,
      targetCents: targetCents,
      createdIso: createdIso,
    );
    await _reload();
  }

  /// Trägt gespartes Geld ein. Setzt status auf `reached`, sobald das Ziel
  /// erreicht ist (nie zurück auf active).
  Future<void> addProgress(int rowId, int cents) async {
    final goal = _byId(rowId);
    if (goal == null || cents <= 0) return;
    final saved = goal.savedCents + cents;
    final status = saved >= goal.targetCents ? 'reached' : 'active';
    await _db.realSavingsGoalsDao
        .updateProgress(rowId: rowId, savedCents: saved, status: status);
    await _reload();
  }

  /// Entnimmt Geld aus dem Spar-Topf (echte Notlage — man muss mal ran).
  /// Nie unter 0. Fällt das Ziel dadurch unter den Zielbetrag, geht der
  /// Status zurück auf `active` (gilt wieder als nicht erreicht). Bereits
  /// bestätigte Ziele bleiben unberührt.
  Future<void> withdraw(int rowId, int cents) async {
    final goal = _byId(rowId);
    if (goal == null || cents <= 0) return;
    if (goal.status == SavingsGoalStatus.confirmed) return;
    final saved = goal.savedCents - cents < 0 ? 0 : goal.savedCents - cents;
    final status = saved >= goal.targetCents ? 'reached' : 'active';
    await _db.realSavingsGoalsDao
        .updateProgress(rowId: rowId, savedCents: saved, status: status);
    await _reload();
  }

  /// Eltern bestätigen das erreichte Ziel → In-Game-Belohnung (XP + Trophäe).
  /// Returns die vergebenen XP (0 wenn nichts zu bestätigen war).
  Future<int> confirmReached({
    required int rowId,
    required String confirmedIso,
    required int dayIndex,
  }) async {
    final goal = _byId(rowId);
    if (goal == null || goal.status == SavingsGoalStatus.confirmed) return 0;
    if (!goal.isReached) return 0;
    await _db.realSavingsGoalsDao
        .confirm(rowId: rowId, confirmedIso: confirmedIso);
    final xp = savingsGoalRewardXp(goal.targetCents);
    ref.read(xpRepositoryProvider.notifier).add(xp);
    ref.read(achievementsRepositoryProvider.notifier).unlock('real_saver', dayIndex);
    await _reload();
    return xp;
  }

  Future<void> remove(int rowId) async {
    await _db.realSavingsGoalsDao.deleteRow(rowId);
    await _reload();
  }

  RealSavingsGoal? _byId(int rowId) {
    for (final g in state) {
      if (g.rowId == rowId) return g;
    }
    return null;
  }

  Future<void> _reload() async {
    final rows = await _db.realSavingsGoalsDao.loadAll();
    state = [for (final r in rows) RealSavingsGoal.fromRow(r)];
  }
}
