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

  /// Obergrenze für die Punktzahl einer Geisterlinie.
  ///
  /// Vorher lieferten diese Pfade **einen Punkt pro Spieltag**. Bei Tag 6575
  /// waren das ~26.000 Records über vier Linien, neu gerechnet und neu
  /// gezeichnet bei JEDEM Rebuild der Zeitreise-Seite — also bei jedem Tipp
  /// auf einen Anlage-Chip. Und es wuchs linear mit dem Spielalter.
  ///
  /// Das Chart ist ein paar hundert Pixel breit; mehr Punkte als Pixel sind
  /// unsichtbar. 400 liegt über jeder realistischen Chart-Breite.
  static const int maxPoints = 400;

  /// [startCents] = Vermögen am ersten Tag des Charts.
  /// [days] = Anzahl Tage, für die der Pfad berechnet werden soll
  /// (inklusive Tag 0).
  /// Liefert `[(dayIndex, valueCents), …]` mit `dayIndex` ab
  /// [startDayIndex]. Über [maxPoints] Tagen wird gleichmäßig ausgedünnt;
  /// der erste und der letzte Tag sind IMMER enthalten, und jeder Wert wird
  /// direkt aus seinem Tagesindex gerechnet — Ausdünnen verändert also
  /// keinen einzigen Wert, nur ihre Anzahl.
  static List<(int, int)> compoundDailyFromYearly({
    required int startCents,
    required int days,
    required double yearlyPct,
    int startDayIndex = 0,
  }) {
    if (days <= 0) return const [];
    final dailyFactor = math.pow(1.0 + yearlyPct, 1.0 / 365.0).toDouble();
    final start = startCents.toDouble();
    int valueAt(int i) => (start * math.pow(dailyFactor, i)).round();

    if (days <= maxPoints) {
      return [
        for (var i = 0; i < days; i++) (startDayIndex + i, valueAt(i)),
      ];
    }
    final step = (days - 1) / (maxPoints - 1);
    final out = <(int, int)>[
      for (var k = 0; k < maxPoints - 1; k++)
        if ((k * step).round() case final i)
          (startDayIndex + i, valueAt(i)),
    ];
    // Letzter Tag exakt, damit das Ende der Linie stimmt.
    out.add((startDayIndex + days - 1, valueAt(days - 1)));
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
