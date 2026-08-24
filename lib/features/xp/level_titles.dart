import 'dart:math' as math;

/// Spec-29 + v29: XP curve, level → title mapping, rendite-boost.
///
/// User-Wunsch v29: 60 Level, nur 10er-Stufen tragen einen Namen.
/// Zwischen-Stufen behalten den letzten 10er-Namen. Schwierigkeits-
/// kurve etwas steiler (exponent 1,6 statt 1,5) — späte Level
/// brauchen merklich mehr XP.
abstract final class LevelSystem {
  static const int maxLevel = 60;

  /// XP threshold to reach [level]. Level 0 = 0 XP.
  /// Round 27 v6: Exponent 1.6 → 1.4, damit Level 60 realistisch
  /// erreichbar wird (vorher ~73.000 XP ≈ unmöglich). Jetzt:
  /// `xpForLevel(n) = 100 * n^1.4` — Level 1 = 100, 10 = 2 512,
  /// 20 = 6 628, 40 = 17 487, 60 = 30 792.
  static int xpForLevel(int level) {
    if (level <= 0) return 0;
    if (level > maxLevel) return xpForLevel(maxLevel);
    return (100 * math.pow(level, 1.4)).round();
  }

  /// Current level for [xp]. Inverse via linear scan.
  static int levelFor(int xp) {
    if (xp <= 0) return 0;
    for (var l = 1; l <= maxLevel; l++) {
      if (xp < xpForLevel(l)) return l - 1;
    }
    return maxLevel;
  }

  /// XP needed to reach the next level. Returns 0 when at [maxLevel].
  static int xpToNext(int xp) {
    final lvl = levelFor(xp);
    if (lvl >= maxLevel) return 0;
    return xpForLevel(lvl + 1) - xp;
  }

  /// v29: Titel nur an 10er-Grenzen. Zwischen-Stufen behalten den
  /// letzten 10er-Titel.
  ///
  /// **Geschlechtsneutral formuliert (2026-08).** Vorher standen hier
  /// generische Maskulina — „Cleverer Investor", „Markt-Stratege",
  /// „Vermögens-Architekt", „Börsen-Profi". Der Trick ist jeweils, von der
  /// Person auf die Sache umzustellen (Architekt → Architektur, Stratege →
  /// Strategie): das bleibt nah am Original und klingt nicht nach Umschreibung.
  /// Sprachlich üblich waren die alten Formen, aber wer die
  /// App spielt, bekommt den Titel direkt zugesprochen („Du bist jetzt …"),
  /// und dann sagt er einem Mädchen jedes zehnte Level, dass eigentlich
  /// jemand anderes gemeint ist. Die neuen Titel benennen die Fähigkeit statt
  /// die Person und funktionieren für alle gleich gut.
  static String titleFor(int level) {
    if (level >= 60) return 'Finanz-Legende';
    if (level >= 50) return 'Vermögens-Architektur';
    if (level >= 40) return 'Geld-Meisterschaft';
    if (level >= 30) return 'Börsen-Erfahrung';
    if (level >= 20) return 'Markt-Strategie';
    if (level >= 10) return 'Cleveres Investieren';
    if (level >= 1) return 'Erste Schritte';
    return 'Neuling';
  }

  /// Rendite-multiplikator auf ETF-Erträge. +0,3 % pro Level, cap +18 %.
  /// (v29: pro Level kleiner weil 60 Stufen, Cap leicht hoeher.)
  /// Hinweis: nutzt `levelFor` (max 60) → Meister-Level geben KEINEN
  /// weiteren Boost (kein endloser Markt-Vorteil).
  static double renditeMultiplier(int level) {
    final boost = math.min(0.003 * level, 0.18);
    return 1 + boost;
  }

  /// Round 28 v4: Prestige-/Meister-Level OHNE Obergrenze — Langzeit-
  /// Motivation, „immer eine Zahl, die hochgeht". Ab Level 60 zählt jedes
  /// weitere [meisterXpPerLevel] XP ein Meister-Level ★. Reine Anzeige-
  /// Progression (kein Rendite-Boost, kein Markt-Cheat — [renditeMultiplier]
  /// bleibt bei Level 60 gedeckelt).
  static const int meisterXpPerLevel = 4000;

  static int meisterLevelFor(int xp) {
    final base = xpForLevel(maxLevel);
    if (xp <= base) return 0;
    return (xp - base) ~/ meisterXpPerLevel;
  }

  /// XP bis zum nächsten Meister-Stern (immer > 0, da unbegrenzt).
  static int xpToNextMeister(int xp) {
    final base = xpForLevel(maxLevel);
    final into = xp <= base ? 0 : (xp - base) % meisterXpPerLevel;
    return meisterXpPerLevel - into;
  }
}
