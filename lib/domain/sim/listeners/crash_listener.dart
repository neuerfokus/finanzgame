/// Crash-Zielobjekt: eine Asset-Klasse, deren Kurse sich in einem Rutsch
/// drücken lassen.
///
/// Historie: hier saß bis zur Analyse-Runde 2026-08 zusätzlich ein
/// `CrashListener` (2 %/Tag ≈ 7 Crash-Tage pro Jahr, −20..50 % ohne
/// Erholung). Er lief parallel zum [MarketPhaseListener] auf denselben
/// Kursen und drückte ETF/Aktien dauerhaft an ihren Boden. Die Stage ist
/// entfallen; Crashes kommen ausschließlich aus dem Phasen-System.
///
/// Das Interface bleibt: der Zeitsprung-Krisenwurf (`fastForward`) schockt
/// darüber weiterhin alle Anlageklassen auf einmal.
library;

abstract class CrashTarget {
  /// Reduziert jeden gehaltenen Kurs um `dropPct` und liefert die
  /// betroffenen Asset-IDs.
  List<String> applyCrash(double dropPct);
}
