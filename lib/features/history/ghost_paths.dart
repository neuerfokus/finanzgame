import 'dart:math' as math;

/// Sprint C3: hypothetische "Geisterlinien" für die Zeitreise.
///
/// Pure Funktion — rechnet drei alternative Pfade aus, wie sich das
/// Start-Vermögen entwickelt hätte, wenn der Spieler von Tag 0 an
/// 1) alles in ETF, 2) alles in Gold, 3) 60/40 gestreut investiert
/// hätte. Keine Persistenz, kein Realtime-Tick — wird im Build des
/// Charts einmal pro Render gerechnet.
///
/// Die Pfade basieren auf konstanter, annualisierter Rendite aus den
/// Spec-44-A.1-Tabellen (ETF ~8 %, Gold ~4 %). Volatilität wird bewusst
/// nicht abgebildet — die Lehrlinie ist „Streuung schneidet ähnlich
/// gut ab wie All-ETF, aber ruhiger", nicht „simuliere mir den Markt".
abstract final class GhostPaths {
  /// Annualisierte ETF-Rendite gemäß spec-44 A.1 (Welt-ETF, 8 %/J).
  static const double etfYearlyPct = 0.08;

  /// Annualisierte Gold-Rendite gemäß spec-44 A.2 (4 %/J, bewusst
  /// unter ETF).
  static const double goldYearlyPct = 0.04;

  /// Spec-45 F1: Spar-Zins-Linie. Aus `SavingsInterestListener` =
  /// 0,15 %/Monat ≈ 1,8 %/Jahr. Lehrlinie "Sparen schlägt Inflation
  /// nicht" — Pfad bleibt deutlich unter ETF und Gold.
  static const double sparYearlyPct = 0.018;

  /// Fallback-Startvermögen wenn keine History/Spielerdaten verfügbar
  /// sind. 25 € = Onboarding-Startkapital.
  static const int fallbackStartCents = 2500;

  /// [startCents] = Vermögen am ersten Tag des Charts.
  /// [days] = Anzahl Tage, für die der Pfad berechnet werden soll
  /// (inklusive Tag 0).
  /// Liefert `[(dayIndex, valueCents), …]` mit `dayIndex` ab
  /// [startDayIndex].
  static List<(int, int)> compoundDailyFromYearly({
    required int startCents,
    required int days,
    required double yearlyPct,
    int startDayIndex = 0,
  }) {
    if (days <= 0) return const [];
    final dailyFactor = math.pow(1.0 + yearlyPct, 1.0 / 365.0).toDouble();
    final out = <(int, int)>[];
    var value = startCents.toDouble();
    for (var i = 0; i < days; i++) {
      out.add((startDayIndex + i, value.round()));
      value *= dailyFactor;
    }
    return out;
  }

  /// 60/40 ETF + Gold — gewichteter Jahresreturn.
  static List<(int, int)> diversified({
    required int startCents,
    required int days,
    int startDayIndex = 0,
  }) {
    const weighted = etfYearlyPct * 0.6 + goldYearlyPct * 0.4;
    return compoundDailyFromYearly(
      startCents: startCents,
      days: days,
      yearlyPct: weighted,
      startDayIndex: startDayIndex,
    );
  }
}
