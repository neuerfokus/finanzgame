import 'dart:math' as math;

import '../../economy/money.dart';
import '../../metal/metal.dart';
import '../../wishlist/wish_item.dart' show InflationConfig;
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../market_phase.dart';
import '../rng.dart';
import 'market_phase_listener.dart';

/// Adapter the listener uses to read + write metal quotes. Implemented by
/// `MetalRepository`.
abstract class MetalPriceSource {
  MetalQuote quoteFor(String assetId);
  void updateQuote(MetalQuote quote);
}

/// Daily metal price roll. Spec-22:
///
/// `nextPrice = prev * (1 + inflationFactor * inflationRate) *
///              (1 + uniform(-dailyVola, +dailyVola))`
///
/// - Inflation pulls metals up by [MetalSpec.inflationFactor] times the
///   day's inflation rate (Gold>1.0, Silber<1.0, Platin=1.0).
/// - Then a small uniform swing simulates day-to-day noise.
///
/// Metals are crash-immune by design: they're the "safe haven" asset
/// class in the game. No crash multiplier is applied here even if a
/// [CrashEvent] fired earlier in the same day. This is the
/// pedagogical lesson — crashes wipe out crypto + stocks, while metals
/// hold their ground.
class MetalPriceListener implements DayEventListener {
  MetalPriceListener({
    required this.source,
    required this.seed,
    required this.inflationEventsToday,
    this.marketPhase = const MarketPhase.normal(),
    this.baseInflationRate = InflationConfig.dailyRate,
  });

  final MetalPriceSource source;
  final int seed;

  /// Same-day [InflationEvent]s emitted by the inflation stage. The mean
  /// of their `rate` fields is used to drive metal price growth.
  final List<InflationEvent> inflationEventsToday;

  /// Sprint B (Spec-44): aktuelle Markt-Phase, geteilt von allen
  /// Metallen (Gold/Silber/Platin laufen bewusst zusammen — Spec-44
  /// Vereinfachung: ein gemeinsamer Phase-State statt drei separater
  /// State-Maschinen). Praktisch wird hier `phaseFor('gold')`
  /// reingereicht und auf alle Metalle appliziert.
  final MarketPhase marketPhase;

  /// Basis-Inflation, wenn heute KEIN [InflationEvent] kam.
  ///
  /// Der `InflationListener` emittiert nur, solange es noch ungekaufte
  /// Wunschlisten-Items gibt. Vorher fiel damit der komplette
  /// Aufwärtstrend der Metalle weg, sobald der Spieler seine Wunschliste
  /// abgearbeitet hatte — zwei völlig unabhängige Dinge, und es widerspricht
  /// der Lehre „Metall = Inflationsschutz". Jetzt ist die Wunschliste nur
  /// noch die Quelle für die TAGES-Abweichung, nicht für die Existenz der
  /// Inflation.
  final double baseInflationRate;

  double _averageInflationRate() {
    if (inflationEventsToday.isEmpty) return baseInflationRate;
    var total = 0.0;
    for (final e in inflationEventsToday) {
      total += e.rate;
    }
    return total / inflationEventsToday.length;
  }

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final events = <DayEvent>[];
    final inflationRate = _averageInflationRate();
    final phaseMod = MarketPhaseListener.dailyModifierFor(marketPhase);

    for (final spec in MetalCatalog.all) {
      final prev = source.quoteFor(spec.id);
      // Seed gemischt (domain/sim/rng.dart) — benachbarte Tage lieferten
      // sonst korrelierte Erstausgaben und damit eine schiefe Ziehung.
      final rng = math.Random(mixSeed(seed ^ spec.id.hashCode, newDay.dayIndex));
      // Uniform daily swing.
      final swing = (rng.nextDouble() * 2 - 1) * spec.dailyVolatility;
      final inflationPull = inflationRate * spec.inflationFactor;
      // Balance-Analyse 2026-08: `(1+i)(1+s)` wächst langfristig nicht mit i,
      // sondern mit i − σ²/6 (Varianz-Drag der Gleichverteilung). Bei Gold ist
      // der geplante Inflationsschutz gerade mal 3,6 %/Jahr — der Drag frisst
      // davon einen spürbaren Teil, also zurückgeben.
      final drag = spec.dailyVolatility * spec.dailyVolatility / 6.0;
      final dailyReturn =
          (1 + inflationPull + drag) * (1 + swing) - 1 + phaseMod;

      final newCents = (prev.pricePerShare.cents * (1 + dailyReturn))
          .round()
          .clamp(1, 1 << 30);
      final newPrice = Money.cents(newCents);
      final newQuote = MetalQuote(
        assetId: spec.id,
        pricePerShare: newPrice,
        onDayIndex: newDay.dayIndex,
      );
      source.updateQuote(newQuote);
      events.add(
        DayEvent.metalPriceUpdate(
          assetId: spec.id,
          newPrice: newPrice,
          deltaPct: dailyReturn,
        ),
      );
    }
    return events;
  }
}
