/// Trophy/Achievement catalog + pure evaluator (spec-21).
///
/// Achievements are content-only (id + emoji + label). Unlock state lives
/// in `AchievementsTable` via [AchievementsRepository]; the rule logic is
/// the pure [evaluateAchievements] function below so it's trivially unit-
/// testable without Riverpod or Drift.
class Achievement {
  const Achievement({
    required this.id,
    required this.emoji,
    required this.label,
  });

  final String id;
  final String emoji;
  final String label;
}

/// Canonical pool (spec-21). Order = display order on the Zimmer grid.
const List<Achievement> kAchievements = [
  Achievement(id: 'first_harvest', emoji: '🌾', label: 'Erste Ernte'),
  Achievement(id: 'savings_100', emoji: '💰', label: '100 € im Sparbuch'),
  Achievement(id: 'first_etf', emoji: '📈', label: 'Erster ETF-Anteil'),
  Achievement(id: 'quest_1', emoji: '✅', label: 'Erste Quest'),
  Achievement(id: 'quest_5', emoji: '✅', label: '5 Quests'),
  Achievement(
    id: 'inflation_unlocked',
    emoji: '🏝',
    label: 'Inflations-Atoll offen',
  ),
  Achievement(id: 'crash_survivor', emoji: '🌋', label: 'Crash überlebt'),
  Achievement(id: 'days_30', emoji: '📅', label: '30 Tage gespielt'),
  // spec-35 phase B + I — neue Achievements.
  Achievement(id: 'notgroschen_3m', emoji: '🛟', label: 'Notgroschen (3 Monate)'),
  Achievement(id: 'realestate_1', emoji: '🏠', label: 'Erste Immobilie'),
  Achievement(id: 'realestate_4', emoji: '🏘', label: 'Immobilien-Mogul (4)'),
  Achievement(id: 'streak_7', emoji: '🔥', label: '7-Tage-Streak'),
  // Optionen-Backlog #2: zusätzliche Streak-Meilenstein-Badges.
  Achievement(id: 'streak_14', emoji: '🔆', label: '14-Tage-Streak'),
  Achievement(id: 'streak_30', emoji: '🏆', label: '30-Tage-Streak'),
  Achievement(id: 'streak_100', emoji: '💯', label: '100-Tage-Streak'),
  // Spec-38 follow-up: weitere Achievements für mehr Sammel-Anreiz.
  Achievement(id: 'quest_10', emoji: '🎖', label: '10 Quests gelöst'),
  Achievement(id: 'quest_20', emoji: '🥇', label: '20 Quests gelöst'),
  Achievement(id: 'bitcoin_first', emoji: '₿', label: 'Erster Bitcoin'),
  Achievement(id: 'gold_first', emoji: '🥇', label: 'Erstes Gold'),
  Achievement(id: 'stock_first', emoji: '📊', label: 'Erste Aktie'),
  Achievement(id: 'diversified_5', emoji: '🌈', label: '5 Asset-Klassen'),
  Achievement(id: 'millionaire', emoji: '💎', label: 'Millionen-Marke'),
  Achievement(id: 'wishlist_first', emoji: '🎁', label: 'Erster Wunsch erfüllt'),
  Achievement(id: 'wishlist_all', emoji: '🛍', label: 'Alle Wünsche erfüllt'),
  Achievement(id: 'level_10', emoji: '⭐', label: 'Level 10'),
  Achievement(id: 'level_20', emoji: '🌟', label: 'Level 20'),
  Achievement(id: 'level_30', emoji: '✨', label: 'Level 30'),
  Achievement(id: 'level_40', emoji: '💫', label: 'Level 40'),
  Achievement(id: 'level_50', emoji: '🏵', label: 'Level 50'),
  Achievement(id: 'level_60', emoji: '👑', label: 'Level 60 (Max)'),
  Achievement(id: 'quiz_streak_7', emoji: '🧠', label: '7 Quizze richtig'),
  Achievement(id: 'savings_1000', emoji: '💰', label: '1000 € im Sparbuch'),
  Achievement(id: 'vorsorge_first', emoji: '🛡', label: 'Erste Vorsorge'),
  Achievement(id: 'sparplan_first', emoji: '🔁', label: 'Erster Sparplan'),
  // Round 27 v5: Wissens-Quiz-Trophäen (User-Wunsch „cooler Badge").
  Achievement(id: 'wissensquiz_done', emoji: '🎓', label: 'Wissens-Quiz gemeistert'),
  Achievement(id: 'wissensquiz_perfect', emoji: '💯', label: 'Quiz-Ass: 10/10'),
  // Round 28 v4: Wissens-Meisterprüfung (nur schwere Fragen) ≥ 9/10.
  Achievement(id: 'quiz_professor', emoji: '🎓', label: 'Finanz-Professor'),
  // Round 27 v7: Portfolio-Vermögens-Stufen (geben XP beim Unlock).
  Achievement(id: 'networth_10k', emoji: '💶', label: '10.000 € Vermögen'),
  Achievement(id: 'networth_50k', emoji: '💷', label: '50.000 € Vermögen'),
  Achievement(id: 'networth_100k', emoji: '🏦', label: '100.000 € Vermögen'),
  Achievement(id: 'networth_500k', emoji: '💰', label: '500.000 € Vermögen'),
  // Round 28 v2: Skill-Baum-Abschluss (extern freigeschaltet via
  // SkillTreePage, nicht über evaluateAchievements).
  Achievement(id: 'skilltree_spar', emoji: '🌱', label: 'Spar-Zweig gemeistert'),
  Achievement(
      id: 'skilltree_invest', emoji: '📈', label: 'Investier-Zweig gemeistert'),
  Achievement(
      id: 'skilltree_schutz', emoji: '🛡️', label: 'Schutz-Zweig gemeistert'),
  Achievement(
      id: 'skilltree_master', emoji: '👑', label: 'Großmeister des Skill-Baums'),
  // Round 28 v4: Prestige-Knoten alle gemeistert (extern via SkillTreePage).
  Achievement(
      id: 'skilltree_prestige', emoji: '🏆', label: 'Prestige-Krone'),
  // Welle C: echtes Sparziel erreicht + von Eltern bestätigt (extern via
  // RealSavingsGoalPage).
  Achievement(
      id: 'real_saver', emoji: '🐷', label: 'Echtes Sparen'),
];

/// Pure rule evaluator — returns the set of unlocked achievement IDs given
/// the supplied snapshot of player progress. Implementations MUST stay
/// monotonic: once an id qualifies, future calls with weakly-stronger
/// stats still return it (`crash_survivor` is the only conditional flag,
/// passed in by the caller after observing a CrashEvent).
Set<String> evaluateAchievements({
  required int plantHarvestCount,
  required int savingsCents,
  required int etfHoldingsCount,
  required int questsCompleted,
  required bool inflationAtollUnlocked,
  required bool crashSurvived,
  required int daysPlayed,
  // spec-35.
  int monthlyAllowanceCents = 0,
  int realEstateCount = 0,
  int streakDays = 0,
  // Spec-38 follow-up.
  int bitcoinShares = 0,
  int metalShares = 0,
  int stockShares = 0,
  int wishlistOwnedCount = 0,
  int wishlistTotalCount = 0,
  int level = 0,
  int cashCents = 0,
  int vorsorgeContractsCount = 0,
  int sparplanCount = 0,
  int assetClassCount = 0,
  // Round 27 v5: volles Netto-Vermögen (alle Asset-Klassen). 0 = nutze
  // Fallback cash+savings (für Alt-Tests).
  int netWorthCents = 0,
}) {
  final unlocked = <String>{};
  if (plantHarvestCount >= 1) unlocked.add('first_harvest');
  if (savingsCents >= 10000) unlocked.add('savings_100');
  if (etfHoldingsCount >= 1) unlocked.add('first_etf');
  if (questsCompleted >= 1) unlocked.add('quest_1');
  if (questsCompleted >= 5) unlocked.add('quest_5');
  if (inflationAtollUnlocked) unlocked.add('inflation_unlocked');
  if (crashSurvived) unlocked.add('crash_survivor');
  if (daysPlayed >= 30) unlocked.add('days_30');
  // spec-35: Notgroschen = ≥ 3 × monatliches Taschengeld auf Spar.
  if (monthlyAllowanceCents > 0 &&
      savingsCents >= 3 * monthlyAllowanceCents) {
    unlocked.add('notgroschen_3m');
  }
  if (realEstateCount >= 1) unlocked.add('realestate_1');
  if (realEstateCount >= 4) unlocked.add('realestate_4');
  if (streakDays >= 7) unlocked.add('streak_7');
  if (streakDays >= 14) unlocked.add('streak_14');
  if (streakDays >= 30) unlocked.add('streak_30');
  if (streakDays >= 100) unlocked.add('streak_100');
  // Spec-38 follow-up
  if (questsCompleted >= 10) unlocked.add('quest_10');
  if (questsCompleted >= 20) unlocked.add('quest_20');
  if (bitcoinShares >= 1) unlocked.add('bitcoin_first');
  if (metalShares >= 1) unlocked.add('gold_first');
  if (stockShares >= 1) unlocked.add('stock_first');
  if (assetClassCount >= 5) unlocked.add('diversified_5');
  final effectiveNetWorth =
      netWorthCents > 0 ? netWorthCents : cashCents + savingsCents;
  // Round 27 v7: Portfolio-Vermögens-Stufen (jede gibt XP beim Unlock).
  if (effectiveNetWorth >= 1000000) unlocked.add('networth_10k');
  if (effectiveNetWorth >= 5000000) unlocked.add('networth_50k');
  if (effectiveNetWorth >= 10000000) unlocked.add('networth_100k');
  if (effectiveNetWorth >= 50000000) unlocked.add('networth_500k');
  if (effectiveNetWorth >= 100000000) unlocked.add('millionaire');
  if (wishlistOwnedCount >= 1) unlocked.add('wishlist_first');
  if (wishlistTotalCount > 0 && wishlistOwnedCount >= wishlistTotalCount) {
    unlocked.add('wishlist_all');
  }
  if (level >= 10) unlocked.add('level_10');
  if (level >= 20) unlocked.add('level_20');
  if (level >= 30) unlocked.add('level_30');
  if (level >= 40) unlocked.add('level_40');
  if (level >= 50) unlocked.add('level_50');
  if (level >= 60) unlocked.add('level_60');
  if (savingsCents >= 100000) unlocked.add('savings_1000');
  if (vorsorgeContractsCount >= 1) unlocked.add('vorsorge_first');
  if (sparplanCount >= 1) unlocked.add('sparplan_first');
  return unlocked;
}
