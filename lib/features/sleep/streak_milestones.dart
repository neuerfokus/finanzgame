/// Optionen-Backlog #2: Streak-Meilensteine.
///
/// Eskalierende EINMALIGE Belohnungen für echte Kalender-Tage-Streaks
/// (registerSleep misst reale Tage, nicht Spieltage → ein 100-Tage-Streak
/// ist ~3 Monate täglich dranbleiben). Anti-Farm: jede Schwelle zahlt nur
/// EINMAL pro Leben — Streak brechen + neu aufbauen bringt nichts mehr.
/// Persistiert via `claimedStreakMilestone` (höchste ausgezahlte Schwelle).
///
/// Reine Funktion + Callbacks (Muster wie applyWeeklyChallenge /
/// applyLifeGoals) → ohne Riverpod testbar.
library;

class StreakMilestone {
  const StreakMilestone({
    required this.days,
    required this.badgeId,
    required this.emoji,
    required this.xp,
    required this.cashCents,
  });

  final int days;
  final String badgeId;
  final String emoji;
  final int xp;
  final int cashCents;
}

/// Schwellen aufsteigend. Beträge an die Ökonomie angelehnt (Taschengeld
/// max 80 €/Monat; life_goals 50-250 €; Quiz 5-20 €) — eskalierend, aber
/// lifetime-einmalig, also kein Dauerstrom.
const List<StreakMilestone> kStreakMilestones = [
  StreakMilestone(days: 7, badgeId: 'streak_7', emoji: '🔥', xp: 30, cashCents: 500),
  StreakMilestone(days: 14, badgeId: 'streak_14', emoji: '🔥', xp: 60, cashCents: 1000),
  StreakMilestone(days: 30, badgeId: 'streak_30', emoji: '🏆', xp: 150, cashCents: 2500),
  StreakMilestone(days: 100, badgeId: 'streak_100', emoji: '💯', xp: 500, cashCents: 8000),
];

class StreakMilestoneResult {
  const StreakMilestoneResult({
    required this.granted,
    required this.totalXp,
    required this.totalCents,
    required this.newClaimed,
  });

  /// Die in diesem Aufruf frisch ausgezahlten Meilensteine (kann leer sein).
  final List<StreakMilestone> granted;
  final int totalXp;
  final int totalCents;

  /// Neue höchste ausgezahlte Schwelle (== alreadyClaimed wenn nichts neu).
  final int newClaimed;

  bool get hasReward => granted.isNotEmpty;
}

/// Zahlt alle Schwellen aus, die mit [streakCount] erreicht sind und über
/// [alreadyClaimed] liegen — jede genau einmal. Ein großer Sprung (z.B.
/// 0 → 100) zahlt 7+14+30+100 auf einmal, aber nie doppelt.
///
/// [unlock] schaltet den Badge frei (idempotent), [addXp]/[earnCents] zahlen
/// die Belohnung, [persistClaimed] speichert die neue höchste Schwelle (nur
/// wenn sich etwas geändert hat).
StreakMilestoneResult applyStreakMilestones({
  required int streakCount,
  required int alreadyClaimed,
  required int dayIndex,
  required bool Function(String id, int dayIndex) unlock,
  required void Function(int xp) addXp,
  required void Function(int cents) earnCents,
  required void Function(int claimed) persistClaimed,
}) {
  final granted = <StreakMilestone>[];
  var highest = alreadyClaimed;
  var xp = 0;
  var cents = 0;
  for (final m in kStreakMilestones) {
    if (streakCount >= m.days && m.days > alreadyClaimed) {
      unlock(m.badgeId, dayIndex);
      addXp(m.xp);
      earnCents(m.cashCents);
      granted.add(m);
      xp += m.xp;
      cents += m.cashCents;
      if (m.days > highest) highest = m.days;
    }
  }
  if (highest > alreadyClaimed) {
    persistClaimed(highest);
  }
  return StreakMilestoneResult(
    granted: granted,
    totalXp: xp,
    totalCents: cents,
    newClaimed: highest,
  );
}
