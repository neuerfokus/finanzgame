import 'dart:math' as math;

import '../../economy/money.dart';
import '../../stock/stock.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../market_phase.dart';
import '../rng.dart';
import '../weather.dart';
import 'etf_price_listener.dart' show EtfPriceListener;
import 'market_phase_listener.dart';

abstract class StockPriceSource {
  StockQuote quoteFor(String stockId);
  Weather weatherForDay(int dayIndex);
  void updateQuote(StockQuote quote);

  /// Spec-44 A.1: ist diese Aktie bereits pleite? Pleite-Aktien
  /// erholen sich nicht mehr — der Listener überspringt das normale
  /// Preis-Roll und hält den Kurs bei ~1¢.
  bool isBankrupt(String stockId);

  /// Spec-44 A.1: markiert diese Aktie als pleite. Repo persistiert
  /// das Flag auf allen Holdings und setzt die Quote auf 1¢.
  void markBankrupt(String stockId);
}

/// Daily stock price tick. Same Box-Muller logic as ETF, but weather impact
/// is halved (stocks less weather-sensitive than baskets).
class StockPriceListener implements DayEventListener {
  StockPriceListener({
    required this.source,
    required this.seed,
    this.marketPhase = const MarketPhase.normal(),
    this.volatilityFactor = 1.0,
  });

  final StockPriceSource source;
  final int seed;

  /// Sprint B: aktuelle Markt-Phase (`stock`-Klasse) als Tages-Modifier.
  final MarketPhase marketPhase;

  /// Spec-44 E2: Vol-Dämpfung über Diversifikations-Faktor.
  final double volatilityFactor;

  static double weatherDelta(Weather w) =>
      EtfPriceListener.weatherDelta(w) * 0.5;

  /// Zentriert wie beim ETF (Balance-Analyse 2026-08) — der rohe Delta hatte
  /// einen negativen Erwartungswert und kostete auch Aktien rund 2 %/Jahr.
  static double weatherMarketDelta(Weather w) =>
      EtfPriceListener.weatherMarketDelta(w) * 0.5;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final events = <DayEvent>[];
    final weather = source.weatherForDay(newDay.dayIndex);
    final wDelta = weatherMarketDelta(weather);

    for (final spec in StockCatalog.all) {
      final prev = source.quoteFor(spec.id);

      // Spec-44 A.1: pleite-gegangene Aktie bleibt dauerhaft bei 1¢.
      // Kein Preis-Roll, keine Erholung — der Kontrast zum ETF.
      if (source.isBankrupt(spec.id)) {
        if (prev.pricePerShare.cents != 1) {
          final flatQuote = StockQuote(
            stockId: spec.id,
            pricePerShare: const Money.cents(1),
            onDayIndex: newDay.dayIndex,
          );
          source.updateQuote(flatQuote);
        }
        continue;
      }

      // Spec-44 A.1: einmal pro Jahr (am Jahresanfang, dayIndex % 365 == 0)
      // gegen `bankruptcyChancePerYear` würfeln. Bei Treffer Aktie
      // permanent auf 1¢ + Event emittieren. Eigener RNG-Stream über
      // separates Salt, damit das Preis-Roll deterministisch bleibt.
      if (newDay.dayIndex > 0 && newDay.dayIndex % 365 == 0) {
        // Der Jahres-Index MUSS in den Seed (wie bei ETF + BTC): ohne ihn
        // würfelt jedes Jahres-Boundary denselben Wert → die Pleite feuerte
        // pro Aktie entweder immer an Tag 365 oder (real beobachtet) NIE,
        // das Lern-Feature „Einzelaktien-Risiko" war damit tot.
        final yearIndex = newDay.dayIndex ~/ 365;
        final bRng = math.Random(
            seed ^ spec.id.hashCode ^ 0xBA17C0DE ^ (yearIndex * 7919));
        if (bRng.nextDouble() < spec.bankruptcyChancePerYear) {
          source.markBankrupt(spec.id);
          final flatQuote = StockQuote(
            stockId: spec.id,
            pricePerShare: const Money.cents(1),
            onDayIndex: newDay.dayIndex,
          );
          source.updateQuote(flatQuote);
          events.add(DayEvent.stockBankrupt(stockId: spec.id, name: spec.name));
          continue;
        }
      }

      // Seed gemischt (siehe domain/sim/rng.dart) — die alte Variante zog die
      // ersten Ausgaben aus benachbarten Seeds und hatte dadurch ein
      // Rausch-Mittel ≠ 0, das als versteckter Renditeabzug wirkte.
      final z = centeredNormal(seed ^ spec.id.hashCode, newDay.dayIndex);

      final phaseMod = MarketPhaseListener.dailyModifierFor(marketPhase);
      final sigma = spec.volatility * volatilityFactor;
      // `baseDriftPerDay` ist als tatsächlich erzielte Rendite gemeint
      // (Kommentare dort rechnen in %/Jahr) → Varianz-Drag zurückgeben,
      // sonst frisst σ²/2 bei einer Vola von 0,022/Tag rund 8 %/Jahr davon.
      final dailyReturn = spec.baseDriftPerDay +
          varianceDragCorrection(sigma) +
          wDelta +
          z * sigma +
          phaseMod;
      // Floor = 40 % des Startpreises (war pauschal 100 ¢). Siehe
      // StockCatalog.priceFloorCentsFor: der 1-€-Floor machte den
      // Cent-Exploit möglich, weil ein langer Crash-Lauf im Zeitsprung den
      // Kurs beliebig tief drücken konnte und der Reseed ihn beim nächsten
      // App-Start auf die Katalog-Basis zurückhob.
      final newCents = (prev.pricePerShare.cents * (1 + dailyReturn))
          .round()
          .clamp(StockCatalog.priceFloorCentsFor(spec), 1 << 30);

      final newPrice = Money.cents(newCents);
      final newQuote = StockQuote(
        stockId: spec.id,
        pricePerShare: newPrice,
        onDayIndex: newDay.dayIndex,
      );
      source.updateQuote(newQuote);
      events.add(
        DayEvent.stockPriceUpdate(
          stockId: spec.id,
          newPrice: newPrice,
          deltaPct: dailyReturn,
        ),
      );
    }
    return events;
  }
}

class _EmptyStockPriceSource implements StockPriceSource {
  const _EmptyStockPriceSource();
  @override
  StockQuote quoteFor(String stockId) => StockQuote(
        stockId: stockId,
        pricePerShare: StockCatalog.byId(stockId).initialPrice,
        onDayIndex: 0,
      );
  @override
  Weather weatherForDay(int dayIndex) => Weather.cloudy;
  @override
  void updateQuote(StockQuote quote) {}
  @override
  bool isBankrupt(String stockId) => false;
  @override
  void markBankrupt(String stockId) {}
}

const StockPriceSource emptyStockPriceSource = _EmptyStockPriceSource();
