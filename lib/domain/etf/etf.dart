import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'etf.freezed.dart';
part 'etf.g.dart';

/// Static configuration for one fictive ETF basket.
///
/// **Hardregel:** Phase 1-2 hat keine echten Tickers. Alle Specs hier sind
/// erfunden.
class EtfSpec {
  const EtfSpec({
    required this.id,
    required this.name,
    required this.volatility,
    required this.initialPrice,
    this.description = '',
    this.composition = const [],
  });

  final String id;
  final String name;

  // Round 27 v8: `baseDriftPerDay` entfernt — der EtfPriceListener nutzt
  // es NICHT (Drift kommt aus dem Year-Regime `etfDailyDrift`). Das Feld
  // war toter Code + verursachte irreführende Kommentare/Werte.

  /// Daily return stddev.
  final double volatility;

  final Money initialPrice;

  /// Welle-8: kindgerechte Kurz-Erklärung (1-2 Sätze).
  final String description;

  /// Welle-8: prozentuale Zusammensetzung. Reihenfolge wird wie
  /// gegeben in der UI gerendert. Summe sollte ~100 % sein.
  final List<EtfComposition> composition;
}

class EtfComposition {
  const EtfComposition(this.label, this.percent);
  final String label;
  final int percent;
}

abstract final class EtfCatalog {
  // Welle-8: realistische Preise + kindgerechte Erklärung + Composition.
  static const weltKorb = EtfSpec(
    id: 'welt_korb',
    name: 'GlobalWelt ETF',
    // Round 27 v4: Vola realistisch (war 0.012 → annualisiert ~23 %).
    // 0.009/Tag ≈ 17 %/J — passt zu breitem World-ETF. Drift kommt aus
    // dem Year-Regime (EtfPriceListener).
    volatility: 0.009,
    initialPrice: Money.cents(11000), // 110 € — real: MSCI World/All-World ~100-125 €
    description:
        'Ein Riesenkorb mit über 1.500 großen Firmen aus der ganzen Welt. '
        'Wenn die Weltwirtschaft wächst, wächst auch dein Anteil. '
        'Breit gestreut = ruhiger.',
    composition: [
      EtfComposition('🇺🇸 USA', 60),
      EtfComposition('🇪🇺 Europa', 15),
      EtfComposition('🇯🇵 Japan', 7),
      EtfComposition('🇨🇳 China', 5),
      EtfComposition('🌏 Rest Welt', 13),
    ],
  );

  static const techKorb = EtfSpec(
    id: 'tech_korb',
    name: 'WeltTec ETF',
    // Round 27 v4: 0.025 → 0.016 (war ~48 %/J annualisiert, jetzt ~31 %).
    // Tech schwankt mehr als World, aber 48 % war über 5 J unrealistisch.
    volatility: 0.016,
    initialPrice: Money.cents(40000), // 400 € — real: Invesco EQQQ Nasdaq ~400 €
    description:
        'Nur Technologie-Riesen: Software, Chips, KI, soziale Netzwerke. '
        'Wächst stärker als der Welt-ETF, schwankt aber auch heftiger. '
        'Hohe Rendite + hohes Risiko.',
    composition: [
      EtfComposition('💻 Software/KI', 35),
      EtfComposition('🔌 Chips/Halbleiter', 25),
      EtfComposition('📱 Internet/Apps', 20),
      EtfComposition('🛒 Online-Handel', 10),
      EtfComposition('🎮 Gaming/Cloud', 10),
    ],
  );

  // Welle-8: neue ETFs für mehr Auswahl.
  static const dax = EtfSpec(
    id: 'dax_korb',
    name: 'DeutschlandDAX ETF',
    volatility: 0.011, // Round 27 v4: 0.014 → 0.011 (~21 %/J)
    initialPrice: Money.cents(19000), // 190 € — real: iShares Core DAX ~180-200 €
    description:
        '40 große deutsche Firmen (Auto, Chemie, Versicherung, …). '
        'Wer an Deutschland glaubt, holt sich hier rein. Weniger '
        'Risiko-Streuung als Welt-ETF — alles in einem Land.',
    composition: [
      EtfComposition('🚗 Auto/Industrie', 30),
      EtfComposition('⚗ Chemie/Pharma', 22),
      EtfComposition('🏦 Banken/Versicherung', 18),
      EtfComposition('💡 Energie/Versorger', 12),
      EtfComposition('🛒 Handel/Konsum', 10),
      EtfComposition('💻 Software', 8),
    ],
  );

  static const schwellen = EtfSpec(
    id: 'emerging_korb',
    name: 'Schwellenländer ETF',
    volatility: 0.013, // Round 27 v4: 0.020 → 0.013 (~25 %/J, EM volatiler)
    initialPrice: Money.cents(5500), // 55 € — real: MSCI Emerging Markets ~40-55 €
    description:
        'Firmen aus aufstrebenden Ländern wie Indien, Brasilien, China. '
        'Schnelleres Wachstum möglich — aber auch mehr Schwankungen '
        'durch Politik und Währung.',
    composition: [
      EtfComposition('🇨🇳 China', 30),
      EtfComposition('🇮🇳 Indien', 20),
      EtfComposition('🇰🇷 Korea', 15),
      EtfComposition('🇧🇷 Brasilien', 10),
      EtfComposition('🇹🇼 Taiwan', 10),
      EtfComposition('🌍 Rest', 15),
    ],
  );

  static const nachhaltig = EtfSpec(
    id: 'esg_korb',
    name: 'GrünPlanet ETF',
    volatility: 0.010, // Round 27 v4: 0.013 → 0.010 (~19 %/J)
    initialPrice: Money.cents(9000), // 90 € — real: breite ESG/Nachhaltig-ETFs ~30-90 €
    description:
        'Nur Firmen, die nachhaltig wirtschaften: Solar, Wind, '
        'E-Mobilität, Recycling, faire Arbeit. Trend für die Zukunft, '
        'aber kleinerer Korb = etwas mehr Schwankung als Welt-ETF.',
    composition: [
      EtfComposition('☀ Solar/Wind', 28),
      EtfComposition('🔋 E-Mobilität/Akku', 22),
      EtfComposition('♻ Recycling/Kreislauf', 18),
      EtfComposition('🌱 Bio/Pflanzenkost', 12),
      EtfComposition('🏗 Grüne Bau-Tech', 12),
      EtfComposition('💧 Wasser/Umwelt', 8),
    ],
  );

  static const all = <EtfSpec>[
    weltKorb,
    techKorb,
    dax,
    schwellen,
    nachhaltig,
  ];

  static EtfSpec byId(String id) =>
      all.firstWhere((e) => e.id == id, orElse: () => weltKorb);
}

/// One row per ETF that the player owns. Average-cost basis for P&L display.
@freezed
abstract class EtfHolding with _$EtfHolding {
  const factory EtfHolding({
    required String etfId,
    required int shares,
    @MoneyConverter() required Money averageBuyPrice,
  }) = _EtfHolding;

  factory EtfHolding.fromJson(Map<String, dynamic> json) =>
      _$EtfHoldingFromJson(json);
}

/// Current price per share, updated each `advanceDay()` by [EtfPriceListener].
@freezed
abstract class EtfQuote with _$EtfQuote {
  const factory EtfQuote({
    required String etfId,
    @MoneyConverter() required Money pricePerShare,
    required int onDayIndex,
  }) = _EtfQuote;

  factory EtfQuote.fromJson(Map<String, dynamic> json) =>
      _$EtfQuoteFromJson(json);
}
