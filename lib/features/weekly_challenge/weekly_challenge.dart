import '../life_goals/life_goals.dart';

/// Round 28 v4: Wochen-Herausforderung — sich erneuernde Motivations-
/// Schleife (statt endlicher Leiter). Pro Spielwoche (`dayIndex ~/ 7`)
/// rotiert eine Challenge aus einem kuratierten Pool. Erfüllt + eingelöst →
/// XP + Cash + Streak. Verpasst → Streak fällt auf 1 beim nächsten Einlösen.
///
/// Bewusst über die `LifeGoalSnapshot`-Felder definiert (kein neuer State).
/// Mix aus „diese Woche aktiv sein" (Tages-Streak) und „gute Aufstellung
/// halten" (Diversifikation) — kein triviales Gratis-Geld, modeste Belohnung.
const int kWeekDays = 7;

class WeeklyChallenge {
  const WeeklyChallenge({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.cashCents,
    required this.met,
    required this.progressLabel,
  });

  final String id;
  final String emoji;
  final String title;
  final String description;
  final int xpReward;
  final int cashCents;
  final bool Function(LifeGoalSnapshot) met;
  final String Function(LifeGoalSnapshot) progressLabel;
}

final List<WeeklyChallenge> kWeeklyChallenges = <WeeklyChallenge>[
  WeeklyChallenge(
    id: 'wc_streak5',
    emoji: '🔥',
    title: 'Dranbleiber',
    description: 'Sei diese Woche fleißig: halte einen Tages-Streak von '
        'mindestens 5 Tagen.',
    xpReward: 120,
    cashCents: 500,
    met: (s) => s.streakDays >= 5,
    progressLabel: (s) => '${s.streakDays.clamp(0, 5)}/5 Tage Streak',
  ),
  WeeklyChallenge(
    id: 'wc_streak7',
    emoji: '📅',
    title: 'Perfekte Woche',
    description: 'Spiele 7 Tage am Stück — ein lückenloser Tages-Streak.',
    xpReward: 180,
    cashCents: 800,
    met: (s) => s.streakDays >= 7,
    progressLabel: (s) => '${s.streakDays.clamp(0, 7)}/7 Tage Streak',
  ),
  WeeklyChallenge(
    id: 'wc_diverse3',
    emoji: '🧺',
    title: 'Nicht alle Eier in einen Korb',
    description: 'Halte diese Woche mindestens 3 verschiedene Anlage-'
        'Klassen gleichzeitig.',
    xpReward: 130,
    cashCents: 600,
    met: (s) => s.assetClassCount >= 3,
    progressLabel: (s) => '${s.assetClassCount.clamp(0, 3)}/3 Anlage-Klassen',
  ),
  WeeklyChallenge(
    id: 'wc_diverse5',
    emoji: '🌈',
    title: 'Breit gestreut',
    description: 'Halte 5 verschiedene Anlage-Klassen gleichzeitig — gut '
        'gegen Risiko.',
    xpReward: 170,
    cashCents: 900,
    met: (s) => s.assetClassCount >= 5,
    progressLabel: (s) => '${s.assetClassCount.clamp(0, 5)}/5 Anlage-Klassen',
  ),
  WeeklyChallenge(
    id: 'wc_diverse6',
    emoji: '🌍',
    title: 'Welt-Portfolio',
    description: 'Zeig, dass du es kannst: 6 Anlage-Klassen gleichzeitig.',
    xpReward: 220,
    cashCents: 1200,
    met: (s) => s.assetClassCount >= 6,
    progressLabel: (s) => '${s.assetClassCount.clamp(0, 6)}/6 Anlage-Klassen',
  ),
  WeeklyChallenge(
    id: 'wc_streak3',
    emoji: '🌱',
    title: 'Guter Start',
    description: 'Komm in die Routine: ein Tages-Streak von 3 Tagen diese '
        'Woche.',
    xpReward: 90,
    cashCents: 400,
    met: (s) => s.streakDays >= 3,
    progressLabel: (s) => '${s.streakDays.clamp(0, 3)}/3 Tage Streak',
  ),
];

int weekIndexFor(int dayIndex) => dayIndex ~/ kWeekDays;

WeeklyChallenge challengeForWeek(int weekIndex) =>
    kWeeklyChallenges[weekIndex % kWeeklyChallenges.length];

/// Tage bis zur nächsten Spielwoche (1..7).
int daysUntilNextWeek(int dayIndex) => kWeekDays - (dayIndex % kWeekDays);

/// Bonus-Cash je Streak-Woche (zusätzlich zur Challenge-Belohnung).
const int kWeeklyStreakBonusCents = 100; // 1 € pro Streak-Woche

class WeeklyClaimResult {
  const WeeklyClaimResult({
    required this.claimed,
    required this.challenge,
    required this.weekIndex,
    required this.streak,
    required this.xp,
    required this.cents,
  });

  final bool claimed;
  final WeeklyChallenge challenge;
  final int weekIndex;
  final int streak;
  final int xp;
  final int cents;
}

/// Prüft die aktuelle Wochen-Challenge und löst sie ein, wenn erfüllt und
/// diese Woche noch nicht eingelöst. Idempotent pro Woche (über
/// [claimedWeek]). Schreibt XP + Cash über die Callbacks + persistiert den
/// neuen Stand via [persist]. Eine Quelle der Wahrheit für game_clock + Seite.
WeeklyClaimResult applyWeeklyChallenge({
  required LifeGoalSnapshot snap,
  required int dayIndex,
  required int claimedWeek,
  required int streak,
  required void Function(int xp) addXp,
  required void Function(int cents) earnCents,
  required void Function({required int claimedWeek, required int streak})
      persist,
}) {
  final week = weekIndexFor(dayIndex);
  final ch = challengeForWeek(week);
  if (week == claimedWeek || !ch.met(snap)) {
    return WeeklyClaimResult(
      claimed: false,
      challenge: ch,
      weekIndex: week,
      streak: streak,
      xp: 0,
      cents: 0,
    );
  }
  // Streak: +1 wenn direkt die Vorwoche eingelöst war, sonst Neustart auf 1.
  final newStreak = claimedWeek == week - 1 ? streak + 1 : 1;
  final bonus = newStreak * kWeeklyStreakBonusCents;
  final cents = ch.cashCents + bonus;
  addXp(ch.xpReward);
  earnCents(cents);
  persist(claimedWeek: week, streak: newStreak);
  return WeeklyClaimResult(
    claimed: true,
    challenge: ch,
    weekIndex: week,
    streak: newStreak,
    xp: ch.xpReward,
    cents: cents,
  );
}
