import '../../../features/daily_quiz/quiz_topics.dart';
import 'monetaria_state.dart';

/// Pure function that decides which islands have unlocked given a
/// snapshot of the player's progress.
///
/// Returns the **complete** set of island IDs that should be unlocked
/// — caller diffs against the currently-unlocked set to fire the
/// "newly unlocked" signal.
///
/// Welle-8 (User-Wunsch): einheitliche XP-Schwellen statt gemischter
/// Cash/Aktien/Tage-Bedingungen. XP wird durch Quizzes (5 XP),
/// Quest-Abschlüsse (~50 XP) und Day-Streaks aufgebaut.
abstract final class MonetariaUnlocker {
  // Welle-8 v2 XP-Schwellen — User: "1500 ging zu schnell". x2-x3 angehoben.
  // Mit ~50 XP/Quest + 5 XP/Quiz spielt sich der Spieler bewusst durch
  // die Insel-Pyramide statt nach 1 Stunde alles offen zu haben.
  static const int etfInselXp = 200;
  static const int inflationAtollXp = 500;
  static const int goldmineXp = 800;
  static const int aktienArchipelXp = 1200;
  static const int vulkanXp = 2000;
  static const int wohnviertelXp = 3500;
  static const int mischwaldXp = 5000;

  /// Welle-8 Hybrid C: jede Insel braucht XP-Minimum UND mindestens
  /// eine abgeschlossene Quest mit passendem Topic (außer Mischwald —
  /// rein XP als Belohnung für Allrounder).
  /// Topic-Mapping aus [kQuestTopics] über learnedTopics.
  static Set<String> compute({
    required int cashCents,
    required int harvestTotalCents,
    required int dayIndex,
    required int etfMarketValueCents,
    required int stockShares,
    int xp = 0,
    Set<String> learnedTopics = const {},
  }) {
    final unlocked = <String>{
      IslandId.heimathafen,
      IslandId.sparInsel,
    };
    if (xp >= etfInselXp && learnedTopics.contains(QuizTopic.etf)) {
      unlocked.add(IslandId.etfInsel);
    }
    if (xp >= inflationAtollXp &&
        learnedTopics.contains(QuizTopic.inflation)) {
      unlocked.add(IslandId.inflationAtoll);
    }
    if (xp >= goldmineXp && learnedTopics.contains(QuizTopic.edelmetalle)) {
      unlocked.add(IslandId.goldmine);
    }
    if (xp >= aktienArchipelXp && learnedTopics.contains(QuizTopic.aktien)) {
      unlocked.add(IslandId.aktienArchipel);
    }
    if (xp >= vulkanXp &&
        (learnedTopics.contains(QuizTopic.krypto) ||
            learnedTopics.contains(QuizTopic.bitcoin))) {
      unlocked.add(IslandId.vulkan);
    }
    if (xp >= wohnviertelXp &&
        learnedTopics.contains(QuizTopic.immobilie)) {
      unlocked.add(IslandId.wohnviertel);
    }
    // Mischwald: Belohnung für Allrounder — reine XP-Schwelle.
    if (xp >= mischwaldXp) unlocked.add(IslandId.mischwald);
    return unlocked;
  }

  /// spec-33 + Welle-8 Hybrid C: human-readable Lock-Kriterium.
  /// XP-Schwelle + erforderliche Quest-Topic.
  static String? criterionFor(String islandId) => switch (islandId) {
        IslandId.etfInsel =>
          'Öffnet ab $etfInselXp XP + Quest zum Thema "ETF" '
          'abgeschlossen (z.B. q25/q28/q33).',
        IslandId.inflationAtoll =>
          'Öffnet ab $inflationAtollXp XP + Quest zum Thema "Inflation" '
          'abgeschlossen (z.B. q06/q14/q26).',
        IslandId.goldmine =>
          'Öffnet ab $goldmineXp XP + Quest zum Thema "Edelmetalle" '
          'abgeschlossen (z.B. q12/q18).',
        IslandId.aktienArchipel =>
          'Öffnet ab $aktienArchipelXp XP + Quest zum Thema "Aktien" '
          'abgeschlossen (z.B. q11/q19/q23).',
        IslandId.vulkan =>
          'Öffnet ab $vulkanXp XP + Quest zum Thema "Krypto/Bitcoin" '
          'abgeschlossen (z.B. q41/q43).',
        IslandId.wohnviertel =>
          'Öffnet ab $wohnviertelXp XP + Quest zum Thema "Immobilien" '
          'abgeschlossen (z.B. q17/q22).',
        IslandId.mischwald =>
          'Öffnet ab $mischwaldXp XP — Belohnung für aktive Spieler.',
        _ => null,
      };
}
