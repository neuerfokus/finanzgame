import 'dart:math' as math;

import 'consumption_log.dart';
import 'ghost_paths.dart';

/// Spec-44 E1 — Opportunitätskosten.
///
/// Pure-Function-Layer: rechnet aus dem [ConsumptionLog] die hypothetische
/// "wäre-ETF-gewesen"-Schattenlinie. Keine Volatilität, konstante
/// annualisierte Rendite (default = `GhostPaths.etfYearlyPct`), damit die
/// Lehrlinie ohne Markt-Rauschen lesbar bleibt.
///
/// Die Zahl spricht, nicht der Text (CLAUDE.md: Anti-Konsum ohne
/// Moralkeule).
abstract final class OpportunityCosts {
  /// Aktueller hypothetischer Gesamtwert, wenn jeder Konsum-Eintrag am
  /// Kauftag zum konstanten ETF-Tages-Compound investiert worden wäre.
  /// `currentDayIndex` = heute (inklusive); Einträge mit `dayIndex >`
  /// currentDayIndex werden ignoriert.
  static int totalIfInvestedAsEtf({
    required List<ConsumptionEntry> log,
    required int currentDayIndex,
    double etfYearlyPct = GhostPaths.etfYearlyPct,
  }) {
    if (log.isEmpty) return 0;
    final dailyFactor =
        math.pow(1.0 + etfYearlyPct, 1.0 / 365.0).toDouble();
    var total = 0.0;
    for (final e in log) {
      if (e.dayIndex > currentDayIndex) continue;
      final daysHeld = currentDayIndex - e.dayIndex;
      total += e.cents * math.pow(dailyFactor, daysHeld);
    }
    return total.round();
  }

  /// Kumulative Schattenlinie über die Zeit. Jedem `(dayIndex, valueCents)`
  /// liegt zugrunde: alle bis dahin (inklusive) getätigten Konsum-Käufe,
  /// jeweils ab ihrem Kauftag täglich aufgezinst.
  ///
  /// [startDayIndex] / [endDayIndex] = Chart-Fenster (beide inklusive).
  /// Liefert pro Tag im Fenster einen Punkt; Tage vor dem ersten Konsum-
  /// Eintrag liefern 0 (keine Schattenlinie).
  static List<(int, int)> shadowSeries({
    required List<ConsumptionEntry> log,
    required int startDayIndex,
    required int endDayIndex,
    double etfYearlyPct = GhostPaths.etfYearlyPct,
  }) {
    if (endDayIndex < startDayIndex) return const [];
    final days = endDayIndex - startDayIndex + 1;

    // Gleiche Deckelung wie bei den Geisterlinien (`GhostPaths.maxPoints`).
    // Ohne sie lief hier eine verschachtelte Schleife ueber JEDEN Spieltag
    // mal JEDEN gekauften Wunsch, jeweils mit einem `pow()` — bei Spieltag
    // 6579 und ein paar Dutzend Kaeufen also sechsstellig viele Aufrufe,
    // und zwar bei JEDEM Rebuild der Seite. Das Diagramm normalisiert pro
    // Linie und ist wenige hundert Pixel breit; mehr Punkte als Pixel sieht
    // ohnehin niemand.
    if (days <= GhostPaths.maxPoints) {
      return [
        for (var d = startDayIndex; d <= endDayIndex; d++)
          (
            d,
            totalIfInvestedAsEtf(
              log: log,
              currentDayIndex: d,
              etfYearlyPct: etfYearlyPct,
            )
          ),
      ];
    }
    final step = (days - 1) / (GhostPaths.maxPoints - 1);
    final out = <(int, int)>[
      for (var k = 0; k < GhostPaths.maxPoints - 1; k++)
        if ((startDayIndex + (k * step).round()) case final d)
          (
            d,
            totalIfInvestedAsEtf(
              log: log,
              currentDayIndex: d,
              etfYearlyPct: etfYearlyPct,
            )
          ),
    ];
    // Letzter Tag exakt, damit das Ende der Linie stimmt.
    out.add((
      endDayIndex,
      totalIfInvestedAsEtf(
        log: log,
        currentDayIndex: endDayIndex,
        etfYearlyPct: etfYearlyPct,
      )
    ));
    return out;
  }
}
