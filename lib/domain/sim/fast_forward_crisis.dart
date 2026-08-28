import 'dart:math' as math;

import 'rng.dart';

/// Ergebnis des Krisenwurfs vor einem Zeitsprung.
class FastForwardCrisis {
  const FastForwardCrisis({required this.hit, required this.severity});

  const FastForwardCrisis.none() : hit = false, severity = 0.0;

  /// Trifft die Krise diesen Sprung?
  final bool hit;

  /// Anteil, um den die Kurse einbrechen (0..1). Nur gültig wenn [hit].
  final double severity;

  /// Für Anzeige und `FastForwardSummary`: 0,0 wenn keine Krise.
  double get dropPct => hit ? severity : 0.0;
}

/// Der Krisenwurf, den `GameClock.fastForward` vor dem Vorspulen macht.
///
/// **Warum das Modell 2026-08-24 ausgetauscht wurde.** Die alte Fassung
/// (Welle-8 Round 22 v2) würfelte pro SPRUNG, nicht pro Tag:
///
/// ```dart
/// final maxFail = 0.05 + 0.55 * lenFactor;
/// final failChance = 0.02 + rand.nextDouble() * (maxFail - 0.02);   // Sockel 2 %
/// final severity  = 0.05 + rand.nextDouble() * (maxSev - 0.05);     // Sockel 5 %
/// ```
///
/// Der Sockel „2 % Risiko auch bei 7 Tagen" war als Spannung gedacht, wirkte
/// aber als **feste Gebühr pro Antippen**. Der Kursgewinn wächst streng
/// proportional zu den Tagen, die Gebühr nicht — also war der Erwartungswert
/// kurzer Sprünge negativ:
///
/// | Sprung | Wachstum | Krisenkosten | netto/Spieljahr |
/// |---|---|---|---|
/// | 7 Tage | ×1,0010 | ×0,9964 | **−13,1 %** |
/// | 30 Tage | ×1,0041 | ×0,9959 | ±0,0 % |
/// | 1 Jahr | ×1,0513 | ×0,9860 | +3,7 % |
///
/// Gemessen im Spielstand eines Testers (Tag 6574): **alle fünf ETFs, alle
/// drei Aktien und Bitcoin standen auf exakt ihrem Bandboden** (0,4× bzw.
/// 0,25× der Basis). Der ⏩-Knopf liegt ungegatet neben „Schlafen", und wer
/// ihn mit der 7-Tage-Voreinstellung benutzt, verbrennt Vermögen, ohne dass
/// es irgendwo sichtbar wird.
///
/// **Neu:** eine konstante Gefahr pro Spieltag ([hazardPerDay]), aus der die
/// Sprungwahrscheinlichkeit als `1 − (1 − h)^Tage` folgt. Die erwarteten
/// Kosten wachsen damit ungefähr linear mit den Tagen — wie der Gewinn. Über
/// 1825 Tage kommt fast genau die alte Trefferquote heraus (~30 %), der lange
/// Sprung fühlt sich also unverändert riskant an; der kurze kostet nichts
/// mehr.
///
/// **Unvorhersehbar bleibt es**, weil die Gefahr pro Sprung um
/// [hazardSpread] streut und die Schwere in einer Spanne gezogen wird.
///
/// **Deterministisch** über `(seed, dayIndex, days)`: derselbe Spielstand und
/// dieselbe Voreinstellung liefern dasselbe Ergebnis. Vorher stand hier ein
/// ungeseedetes `math.Random()` — in einer Simulation, die das Projekt sonst
/// streng deterministisch hält, und es lud zum Neustarten ein, bis der Wurf
/// günstig ausfiel.
abstract final class FastForwardCrisisModel {
  /// Eigener Seed-Raum, damit der Wurf nicht mit den Preis-Listenern
  /// korreliert (die benutzen `0xE7F00D`, `0x57AC0`, `0xB0BCAFE`).
  static const int defaultSeed = 0xC5151A;

  /// Krisengefahr pro Spieltag. `1 − (1 − h)^1825 ≈ 30,6 %` — der 5-Jahres-
  /// Sprung behält damit die Trefferquote des alten Modells.
  static const double hazardPerDay = 0.0002;

  /// Streuung der Gefahr pro Sprung (±40 %), damit sie nicht ausrechenbar ist.
  static const double hazardSpread = 0.4;

  /// Untergrenze der Schwere. Greift nur noch, WENN die Krise trifft — bei
  /// kurzen Sprüngen ist das jetzt selten statt garantiert teuer.
  static const double minSeverity = 0.05;

  /// Obergrenze der Schwere bei einem Sprung von null Tagen …
  static const double maxSeverityBase = 0.15;

  /// … plus dieser Zuschlag bei [severityFullScaleDays] Tagen. Lange Sprünge
  /// bleiben absichtlich gefährlicher als kurze.
  static const double maxSeveritySpan = 0.55;

  /// Sprungweite, ab der die Schwere ihre volle Spanne erreicht (5 Spieljahre).
  static const int severityFullScaleDays = 1825;

  /// Wahrscheinlichkeit, dass ein Sprung über [days] Tage mit Tagesgefahr
  /// [hazard] mindestens eine Krise enthält.
  static double failChanceFor(int days, double hazard) {
    if (days <= 0) return 0.0;
    return 1.0 - math.pow(1.0 - hazard, days).toDouble();
  }

  /// Obergrenze der Schwere für einen Sprung über [days] Tage.
  static double maxSeverityFor(int days) {
    final lenFactor = (days / severityFullScaleDays).clamp(0.0, 1.0);
    return maxSeverityBase + maxSeveritySpan * lenFactor;
  }

  /// Der Wurf. [days] ist die BEREITS auf die Restlebenszeit getrimmte
  /// Sprungweite — vergehen keine Tage mehr, gibt es auch keine Krise.
  ///
  /// Das war der zweite Fehler der alten Fassung: sie würfelte VOR dem Trim.
  /// Am Lebensende wurde auf `days = 1` gekürzt, der Wurf lief trotzdem, und
  /// `advanceDay` brach sofort mit `LifetimeEndEvent` ab — null Tage vergangen,
  /// bis zu 15 % auf alle Anlagen weg, über den ungegateten ⏩-Knopf beliebig
  /// oft wiederholbar.
  static FastForwardCrisis roll({
    required int days,
    required int dayIndex,
    int seed = defaultSeed,
  }) {
    if (days <= 0) return const FastForwardCrisis.none();

    // mixSeed statt roher XOR-Verkettung: benachbarte dayIndex sollen weit
    // auseinanderliegende Seeds ergeben (siehe rng.dart).
    final rng = math.Random(mixSeed(seed, dayIndex * 1000003 + days));

    final hazard = hazardPerDay *
        (1.0 - hazardSpread + 2.0 * hazardSpread * rng.nextDouble());
    if (rng.nextDouble() >= failChanceFor(days, hazard)) {
      return const FastForwardCrisis.none();
    }

    final maxSev = maxSeverityFor(days);
    final severity = minSeverity + rng.nextDouble() * (maxSev - minSeverity);
    return FastForwardCrisis(hit: true, severity: severity);
  }
}
