/// Spec-45 G2: Realwelt-Vergleich für Lebens-Resümee.
///
/// Vergleicht das Spiel-Netto-Vermögen am Lebensende mit echten
/// deutschen Nettovermögens-Verteilungen (Bundesbank PHF-Studie 2023
/// + DIW SOEP). Didaktisch — kein präzises Reichtums-Ranking, sondern
/// Anker: "Du stehst über X % der Deutschen".
///
/// Quellen (Stand 2026-05, ohne PII-Pflicht):
/// - Bundesbank PHF Welle 5 (2023): Median Nettovermögen Erwachsene
///   ~70.800 €, Top 10 % ab ~725.000 €, Top 1 % ab ~3,3 Mio €.
/// - DIW SOEP: untere 50 % halten ~3 % des Gesamtvermögens.
///
/// Werte gerundet auf didaktisch greifbare Schwellen. Bei späterem
/// Update einfach Tabelle ersetzen.
abstract final class RealworldBenchmark {
  /// Schwellen (Cents, aufsteigend) → Bevölkerungs-Anteil drunter (%).
  /// Wer netWorth ≥ Schwelle hat, schlägt mindestens dieses Perzentil.
  static const List<(int, int)> _percentileTable = [
    (0, 10),            // 0 € = Schulden-frei, schlägt 10 %
    (500000, 25),       // 5 000 €   = Top 75 %
    (2500000, 40),      // 25 000 €  = Top 60 %
    (7080000, 50),      // 70 800 €  = Median DE
    (15000000, 65),     // 150 000 € = Top 35 %
    (30000000, 75),     // 300 000 € = Top 25 %
    (72500000, 90),     // 725 000 € = Top 10 %
    (150000000, 95),    // 1,5 Mio € = Top 5 %
    (330000000, 99),    // 3,3 Mio € = Top 1 %
    (1000000000, 999),  // 10 Mio €  = Top 0,1 % (Marker)
  ];

  /// Liefert das Perzentil, das der Spieler mit [netWorthCents]
  /// erreicht. Zahl als ganzzahliger Prozentwert (0..100), Spezial-999
  /// für Top 0,1 %.
  static int percentileFor(int netWorthCents) {
    var best = 0;
    for (final (threshold, percentile) in _percentileTable) {
      if (netWorthCents >= threshold) best = percentile;
    }
    return best;
  }

  /// Menschen-lesbare Einordnung. Beispiele:
  /// - "Top 10 % der Deutschen im Ruhestand"
  /// - "Median — typischer Lebensweg"
  /// - "Schuldenfrei, aber unter dem Durchschnitt"
  static String labelFor(int netWorthCents) {
    final p = percentileFor(netWorthCents);
    if (p >= 999) return 'Top 0,1 % — extrem vermögend';
    if (p >= 99) return 'Top 1 % — vermögende Elite';
    if (p >= 95) return 'Top 5 % — sehr wohlhabend';
    if (p >= 90) return 'Top 10 % — wohlhabend';
    if (p >= 75) return 'Top 25 % — überdurchschnittlich';
    if (p >= 65) return 'Top 35 % — gut aufgestellt';
    if (p >= 50) return 'Über dem deutschen Median (70.800 €)';
    if (p >= 40) return 'Knapp unter dem Median';
    if (p >= 25) return 'Untere Mittelschicht';
    if (p >= 10) return 'Schuldenfrei, aber unter dem Durchschnitt';
    return 'In den roten Zahlen — Schulden überwiegen';
  }

  /// Referenz-Vergleichswerte für Visualisierung (Cents).
  static const int medianCents = 7080000;       // 70 800 €
  static const int top10Cents = 72500000;       // 725 000 €
  static const int top1Cents = 330000000;       // 3,3 Mio €
}
