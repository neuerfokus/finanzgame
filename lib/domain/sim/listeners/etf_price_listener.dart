import 'dart:math' as math;

import '../../economy/money.dart';
import '../../etf/etf.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../market_phase.dart';
import '../rng.dart';
import '../weather.dart';
import 'market_phase_listener.dart';

/// Adapter: feature side provides current quotes + the day's weather and
/// receives the new quotes. Keeps the listener pure-domain.
abstract class EtfPriceSource {
  EtfQuote quoteFor(String etfId);
  Weather weatherForDay(int dayIndex);
  void updateQuote(EtfQuote quote);
}

/// Daily ETF price tick: applies `baseDriftPerDay + weatherAdj + noise`
/// (where noise ~ N(0, volatility)) to each ETF in [EtfCatalog].
///
/// Weather multipliers (additive to the daily return):
///   sunny  : +0.005
///   cloudy :  0.0
///   rain   : -0.003
///   storm  : -0.015
///
/// Emits one [DayEvent.etfPriceUpdate] per ETF. Floors the resulting price
/// at 1¢ to keep math sane.
class EtfPriceListener implements DayEventListener {
  EtfPriceListener({
    required this.source,
    required this.seed,
    this.marketPhase = const MarketPhase.normal(),
    this.volatilityFactor = 1.0,
  });

  final EtfPriceSource source;
  final int seed;

  /// Spec-44 E2: Vol-Dämpfung wenn Spieler über mehrere Klassen
  /// streut. 1.0 = volle Vola, 0.5 = halbe Vola (5+ Klassen).
  final double volatilityFactor;

  /// Sprint B: aktuelle Markt-Phase (resolved durch
  /// `MarketPhaseListener` davor in der Pipeline). Bestimmt zusätzlich
  /// zum normalen Drift einen Tages-Modifier (drawdown negativ,
  /// recovery positiv).
  final MarketPhase marketPhase;

  /// ETF-Jahres-Regime (User-Vorschlag v26):
  /// - 6/10: gutes Jahr +10 %
  /// - 3/10: ruhiges Jahr +3 %
  /// - 1/10: Crash-Jahr −25 %
  ///
  /// EW arithmetisch +4,4 %/Jahr — realistischer als der reine
  /// baseDriftPerDay weil Crashes mit eingerechnet sind. Wird pro
  /// Jahres-Index gewuerfelt und glatt ueber 365 Tage ausgegeben
  /// (drift/Tag = ln(factor)/365). Ersetzt zusaetzlich-additiv den
  /// baseDriftPerDay, der weiterhin als Spec-Wert in EtfSpec
  /// definiert ist (fuer Tests + Reference).
  /// Balance-Analyse 2026-08: die Jahre werden nicht mehr einzeln gewürfelt,
  /// sondern als Jahrzehnt-Deck ausgeteilt (6 gute · 3 ruhige · 1 Crash-Jahr).
  /// Unabhängige Würfe treffen die geplanten 60/30/10 erst nach Hunderten von
  /// Jahren; über die ~40 Spieljahre eines Durchlaufs lag die gezogene
  /// Mischung deutlich daneben — und wegen des festen Seeds bei jedem Spieler
  /// gleich daneben. Welches Jahr welches wird, bleibt überraschend.
  /// Angehoben von ×1,10 / ×1,03 / ×0,75 (geometrisch +3,8 %/Jahr, nach
  /// Crash-Kosten gemessene +2,8 %). Bei 2 % Inflation blieben real +0,8 %
  /// übrig — zu wenig, damit sich der Unterschied zu Sparkonto und Bargeld
  /// über ein Spieljahrzehnt anfühlt, und deutlich unter dem realen Vorbild
  /// (MSCI World real ~5 %/Jahr). Jetzt geometrisch +5,4 %/Jahr, nach
  /// Crash-Kosten rund +5 %.
  static const List<double> yearRegimeDeck = [
    1.12, 1.12, 1.12, 1.12, 1.12, 1.12, // 6 gute Jahre
    1.05, 1.05, 1.05, // 3 ruhige Jahre
    0.78, // 1 Crash-Jahr
  ];

  static double etfDailyDrift(int seed, int dayIndex) {
    final yearIndex = dayIndex ~/ 365;
    final factor = dealCard(seed ^ 0xE7F1ED, yearIndex, yearRegimeDeck);
    return math.log(factor) / 365.0;
  }

  static double weatherDelta(Weather w) => switch (w) {
        Weather.sunny => 0.005,
        Weather.cloudy => 0.0,
        Weather.rain => -0.003,
        Weather.storm => -0.015,
      };

  /// Erwartungswert von [weatherDelta] über das Wetter-Jahresdeck aus
  /// `rollWeather` (128 sonnig · 128 bewölkt · 80 Regen · 29 Sturm):
  ///
  ///   (128·0,005 + 80·(−0,003) + 29·(−0,015)) / 365 = −0,0000959
  ///
  /// Balance-Analyse 2026-08: das ist **kein** Rauschen, sondern ein
  /// permanenter Abwärtsdrift von rund 4 % pro Jahr auf jeden Kurs. Gedacht
  /// war Wetter als Würze („heute war ein guter Börsentag"), nicht als
  /// Renditebremse. Ein Weltmarkt-ETF, der wegen Regenwahrscheinlichkeit
  /// langfristig fällt, lehrt außerdem genau das Falsche.
  static const double weatherDeltaMean = -0.035 / 365;

  /// Zentrierte Variante für die Kursberechnung: gute und schlechte Tage
  /// wiegen sich über die Zeit auf, der Erwartungswert ist 0. Die rohe
  /// [weatherDelta] bleibt für Anzeige/Tests unverändert.
  static double weatherMarketDelta(Weather w) =>
      weatherDelta(w) - weatherDeltaMean;


  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final events = <DayEvent>[];
    final weather = source.weatherForDay(newDay.dayIndex);
    final wDelta = weatherMarketDelta(weather);

    for (final spec in EtfCatalog.all) {
      final prev = source.quoteFor(spec.id);
      // Deterministic per (seed, etfId, dayIndex) so tests are stable.
      // Der Seed läuft durch `mixSeed`, weil die alte Variante
      // (`seed ^ hash ^ dayIndex * K`, direkt in math.Random) über benachbarte
      // Tage korrelierte Erstausgaben lieferte — siehe domain/sim/rng.dart.
      final z = centeredNormal(seed ^ spec.id.hashCode, newDay.dayIndex);

      final phaseMod = MarketPhaseListener.dailyModifierFor(marketPhase);
      // v26: baseDriftPerDay durch Jahres-Regime ersetzt (siehe
      // etfDailyDrift). Realistische Mischung aus guten Jahren,
      // ruhigen Jahren und Crash-Jahren statt konstanter Drift.
      final yearDrift = etfDailyDrift(seed, newDay.dayIndex);
      final sigma = spec.volatility * volatilityFactor;
      final dailyReturn = yearDrift +
          varianceDragCorrection(sigma) +
          wDelta +
          z * sigma +
          phaseMod;
      // 2026-06-04 (Test-Bug „Cent-ETF → Zeitsprung → Millionär"): ETF-Kurse
      // dürfen NIEMALS auf Cent/einstellige € fallen. Der alte 1¢-Floor ließ
      // einen langen Bären-/Crash-Lauf den Kurs Richtung Cent drücken — dann
      // kaufte man riesige Stückzahlen für Centbeträge und der nächste
      // Zeitsprung machte daraus Millionen. Floor = 40 % des Startpreises
      // (deckt sich mit dem Reseed-Band [0.4×,2.5×]); max realistischer
      // Drawdown ~60 %, aber nie absurd billig. Aktien haben analog 100¢-Floor.
      final floorCents = (spec.initialPrice.cents * 0.4).round();
      final newCents = (prev.pricePerShare.cents * (1 + dailyReturn))
          .round()
          .clamp(floorCents, 1 << 30);

      final newPrice = Money.cents(newCents);
      final newQuote = EtfQuote(
        etfId: spec.id,
        pricePerShare: newPrice,
        onDayIndex: newDay.dayIndex,
      );
      source.updateQuote(newQuote);
      events.add(
        DayEvent.etfPriceUpdate(
          etfId: spec.id,
          newPrice: newPrice,
          deltaPct: dailyReturn,
        ),
      );
    }
    return events;
  }
}

class _EmptyEtfPriceSource implements EtfPriceSource {
  const _EmptyEtfPriceSource();
  @override
  EtfQuote quoteFor(String etfId) => EtfQuote(
        etfId: etfId,
        pricePerShare: EtfCatalog.byId(etfId).initialPrice,
        onDayIndex: 0,
      );
  @override
  Weather weatherForDay(int dayIndex) => Weather.cloudy;
  @override
  void updateQuote(EtfQuote quote) {}
}

const EtfPriceSource emptyEtfPriceSource = _EmptyEtfPriceSource();
