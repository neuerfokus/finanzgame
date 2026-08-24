import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import 'legacy.dart';

part 'new_game_state.g.dart';

/// Spec-45 G3: NewGame+ Boni über Spiel-Runs.
///
/// Konzept: nach Lebens-Ende (Alter 80) startet Spieler neuen Run mit
/// "Erbschaft" — Cash + XP Boni basierend auf vorigem Erfolg.
/// Highscore-Liste bleibt erhalten, alles andere wird zurückgesetzt.
///
/// Boni:
/// - Erbschaft: 1 % vom vorigen Netto-Vermögen, Cap 1.000 €
/// - Bonus-XP: 10 % vom vorigen XP, Cap 500
///
/// In-memory KeepAlive — überlebt DB-Wipe (Reset-Flow ohne App-Kill).
/// Verliert sich bei vollem App-Restart — User-Hinweis: direkt nach
/// Reset weiterspielen.
@Riverpod(keepAlive: true)
class NewGameState extends _$NewGameState {
  @override
  NewGameData build() {
    // Welle-8 Round 9: Drift v15 — Persistent via NewGameDao.
    // Initial empty; async hydrate aus DB.
    Future<void>.microtask(_hydrate);
    return const NewGameData();
  }

  Future<void> _hydrate() async {
    if (!ref.mounted) return;
    final db = ref.read(appDatabaseProvider);
    final row = await db.newGameDao.load();
    if (!ref.mounted || row == null) return;
    state = NewGameData(
      runCount: row.runCount,
      pendingInheritanceCents: row.pendingInheritanceCents,
      pendingBonusXp: row.pendingBonusXp,
      lastRunNetWorthCents: row.lastRunNetWorthCents,
      legacyPoints: row.legacyPoints,
      legacyUpgrades: _parseCsv(row.legacyUpgrades),
    );
  }

  void _persist() {
    final db = ref.read(appDatabaseProvider);
    final s = state;
    unawaited(db.newGameDao
        .upsert(
          runCount: s.runCount,
          pendingInheritanceCents: s.pendingInheritanceCents,
          pendingBonusXp: s.pendingBonusXp,
          lastRunNetWorthCents: s.lastRunNetWorthCents,
          legacyPoints: s.legacyPoints,
          legacyUpgrades: s.legacyUpgrades.join(','),
        )
        .catchError((Object _) {}));
  }

  /// Nach Lebens-Ende: bevor wipe, snapshot speichern für nächsten Run.
  /// Welle B: vergibt zusätzlich permanente Legacy-Punkte + nutzt den
  /// (ggf. durch „Großes Erbe" erhöhten) Erbschafts-Cap.
  void recordEndOfRun({
    required int netWorthCents,
    required int finalXp,
  }) {
    final cap = legacyInheritanceCapCents(state.legacyUpgrades);
    final inheritance = _capCents((netWorthCents * 0.01).round(), cap);
    final bonusXp = _capInt((finalXp * 0.10).round(), 500);
    final lpEarned =
        legacyPointsForRun(netWorthCents: netWorthCents, finalXp: finalXp);
    state = state.copyWith(
      runCount: state.runCount + 1,
      pendingInheritanceCents: inheritance,
      pendingBonusXp: bonusXp,
      lastRunNetWorthCents: netWorthCents,
      legacyPoints: state.legacyPoints + lpEarned,
    );
    _persist();
  }

  /// Vorschau der LP, die ein Run-Ende mit diesem Stand bringen würde.
  int previewLegacyPoints({required int netWorthCents, required int finalXp}) =>
      legacyPointsForRun(netWorthCents: netWorthCents, finalXp: finalXp);

  /// Noch nicht ausgegebene Legacy-Punkte.
  int availableLegacyPoints() =>
      state.legacyPoints - legacySpentPoints(state.legacyUpgrades);

  /// Kauft ein Vermächtnis-Upgrade. Idempotent; false wenn schon besessen,
  /// unbekannt oder zu wenig Punkte.
  bool buyLegacyUpgrade(String id) {
    if (state.legacyUpgrades.contains(id)) return false;
    final up = legacyUpgradeById(id);
    if (up == null) return false;
    if (availableLegacyPoints() < up.cost) return false;
    state = state.copyWith(
      legacyUpgrades: {...state.legacyUpgrades, id},
    );
    _persist();
    return true;
  }

  static Set<String> _parseCsv(String csv) => csv
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet();

  /// Onboarding ruft das ab + leert pending. Returns (cash, xp).
  ({int inheritanceCents, int bonusXp}) consumePending() {
    final r = (
      inheritanceCents: state.pendingInheritanceCents,
      bonusXp: state.pendingBonusXp,
    );
    state = state.copyWith(
      pendingInheritanceCents: 0,
      pendingBonusXp: 0,
    );
    _persist();
    return r;
  }

  static int _capCents(int v, int max) => v < 0 ? 0 : (v > max ? max : v);
  static int _capInt(int v, int max) => v < 0 ? 0 : (v > max ? max : v);
}

class NewGameData {
  const NewGameData({
    this.runCount = 0,
    this.pendingInheritanceCents = 0,
    this.pendingBonusXp = 0,
    this.lastRunNetWorthCents = 0,
    this.legacyPoints = 0,
    this.legacyUpgrades = const {},
  });

  /// Anzahl abgeschlossener Spiel-Leben (0 = Erstspieler).
  final int runCount;

  /// Erbschaft die beim nächsten Onboarding aufs Cash kommt. 0 = nichts.
  final int pendingInheritanceCents;

  /// Bonus-XP für den nächsten Run.
  final int pendingBonusXp;

  /// Netto-Vermögen am Ende des letzten Runs (für Anzeige).
  final int lastRunNetWorthCents;

  /// Welle B: über alle Runs gesammelte Vermächtnis-Punkte (permanent).
  final int legacyPoints;

  /// Welle B: gekaufte Vermächtnis-Upgrade-IDs.
  final Set<String> legacyUpgrades;

  /// Generation = abgeschlossene Runs + 1 (1 = erster Lauf).
  int get generation => runCount + 1;

  /// Flat Start-Cash aus Vermächtnis (jeder Run).
  int get legacyStartCashAmount => legacyStartCashCents(legacyUpgrades);

  /// Flat Start-XP aus Vermächtnis (jeder Run).
  int get legacyStartXpAmount => legacyStartXp(legacyUpgrades);

  /// Dauerhafte Bonus-Beete aus Vermächtnis.
  int get legacyStartPlotCount => legacyStartPlots(legacyUpgrades);

  NewGameData copyWith({
    int? runCount,
    int? pendingInheritanceCents,
    int? pendingBonusXp,
    int? lastRunNetWorthCents,
    int? legacyPoints,
    Set<String>? legacyUpgrades,
  }) =>
      NewGameData(
        runCount: runCount ?? this.runCount,
        pendingInheritanceCents:
            pendingInheritanceCents ?? this.pendingInheritanceCents,
        pendingBonusXp: pendingBonusXp ?? this.pendingBonusXp,
        lastRunNetWorthCents:
            lastRunNetWorthCents ?? this.lastRunNetWorthCents,
        legacyPoints: legacyPoints ?? this.legacyPoints,
        legacyUpgrades: legacyUpgrades ?? this.legacyUpgrades,
      );
}
