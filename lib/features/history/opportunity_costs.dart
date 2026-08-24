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
    final out = <(int, int)>[];
    for (var d = startDayIndex; d <= endDayIndex; d++) {
      final v = totalIfInvestedAsEtf(
        log: log,
        currentDayIndex: d,
        etfYearlyPct: etfYearlyPct,
      );
      out.add((d, v));
    }
    return out;
  }
}
