import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';
import '../wishlist/wish_item.dart' show InflationConfig;

part 'metal.freezed.dart';
part 'metal.g.dart';

/// Static config for one precious metal. Spec-22: metals are the "safe
/// haven" — low daily volatility, prices nudged by daily inflation factor.
/// Crashes do NOT hit metals (documented as safe-haven by design).
class MetalSpec {
  const MetalSpec({
    required this.id,
    required this.name,
    required this.glyph,
    required this.basePrice,
    required this.inflationFactor,
    required this.dailyVolatility,
  });

  final String id;
  final String name;
  final String glyph;
  final Money basePrice;

  /// Multiplier on the day's inflation rate. Gold=1.2 (full hedge plus),
  /// Silber=0.8, Platin=1.0.
  final double inflationFactor;

  /// Per-day uniform `[-v, +v]` swing on top of the inflation nudge.
  final double dailyVolatility;
}

abstract final class MetalCatalog {
  // Welle-8 Round 22 v3: Real-Stand 2026-05-31 (User-Korrektur "Gold,
  // Silber, Palladium nicht aktuell"). Quellen ~goldpreis.de:
  // Gold ≈ 78 €/g (2.418 €/oz), Silber ≈ 0,85 €/g (26,40 €/oz),
  // Platin ≈ 32 €/g (993 €/oz), Palladium ≈ 28 €/g (870 €/oz).
  // 0,1 g Gold = 7,80 €.
  static const gold = MetalSpec(
    id: 'metal_gold',
    name: 'Gold (0,1 g)',
    glyph: '🥇',
    basePrice: Money.cents(780),
    // Round 27 v4: inflationFactor multipliziert die Tages-Inflation
    // (~2 %/J). Vorher ~0,05 → Metalle quasi flach. 1.8 ≈ +3,6 %/J Gold
    // (Inflationsschutz, langsamer Aufwärtstrend).
    inflationFactor: 1.8,
    dailyVolatility: 0.002,
  );

  static const silver = MetalSpec(
    id: 'metal_silver',
    name: 'Silber (1 g)',
    glyph: '🥈',
    basePrice: Money.cents(85),
    inflationFactor: 2.5, // Round 27 v4: ≈ +5 %/J (Silber wächst stärker)
    dailyVolatility: 0.005,
  );

  static const platinum = MetalSpec(
    id: 'metal_platinum',
    name: 'Platin (0,1 g)',
    glyph: '🔘',
    basePrice: Money.cents(320),
    inflationFactor: 2.0, // Round 27 v4: ≈ +4 %/J
    dailyVolatility: 0.003,
  );

  static const goldGramm = MetalSpec(
    id: 'metal_gold_1g',
    name: 'Gold (1 g)',
    glyph: '🥇',
    basePrice: Money.cents(7800), // 78 €
    inflationFactor: 1.8, // Round 27 v4: Gold konsistent
    dailyVolatility: 0.002,
  );
  static const goldUnze = MetalSpec(
    id: 'metal_gold_oz',
    name: 'Gold (1 oz, 31 g)',
    glyph: '🪙',
    basePrice: Money.cents(241800), // 2.418 €
    inflationFactor: 1.8, // Round 27 v4: Gold konsistent
    dailyVolatility: 0.002,
  );
  static const goldBarren = MetalSpec(
    id: 'metal_gold_100g',
    name: 'Goldbarren (100 g)',
    glyph: '🟨',
    basePrice: Money.cents(780000), // 7.800 €
    inflationFactor: 1.8, // Round 27 v4: Gold konsistent
    dailyVolatility: 0.002,
  );
  static const silberUnze = MetalSpec(
    id: 'metal_silver_oz',
    name: 'Silber (1 oz, 31 g)',
    glyph: '🥈',
    basePrice: Money.cents(2640),
    inflationFactor: 2.5, // Round 27 v4: Silber konsistent
    dailyVolatility: 0.005,
  );
  static const platinumGramm = MetalSpec(
    id: 'metal_platinum_1g',
    name: 'Platin (1 g)',
    glyph: '🔘',
    basePrice: Money.cents(3200),
    inflationFactor: 2.0, // Round 27 v4: Platin konsistent
    dailyVolatility: 0.003,
  );

  // Welle-8 Round 22 v3: Palladium ergänzt (User-Wunsch).
  static const palladiumGramm = MetalSpec(
    id: 'metal_palladium_1g',
    name: 'Palladium (1 g)',
    glyph: '⚪',
    basePrice: Money.cents(2800),
    inflationFactor: 2.3, // Round 27 v4: ≈ +4,6 %/J
    dailyVolatility: 0.004,
  );

  static const all = <MetalSpec>[
    gold,
    goldGramm,
    goldUnze,
    goldBarren,
    silver,
    silberUnze,
    platinum,
    platinumGramm,
    palladiumGramm,
  ];

  static MetalSpec byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => gold);

  /// Erwarteter Kurs an [dayIndex]: Basis, um den eingebauten
  /// Inflationsschutz-Drift fortgeschrieben (`inflationFactor` × Tages-
  /// Inflation, kumuliert).
  ///
  /// Analyse-Runde 2026-08: Der Reseed beim App-Start prüfte gegen die
  /// STARRE Basis mit dem engsten Band aller Anlageklassen ([0,4× ; 1,4×]).
  /// Gold wächst mit ~3,6 %/Jahr — nach ~9,5 Spieljahren (also schon nach
  /// zwei 5-Jahres-Sprüngen) lag es über 1,4× und der nächste App-Start
  /// setzte den Kurs auf die Basis zurück: alle Gewinne der langsamsten
  /// Anlage weg, und ausgerechnet die Lehre „Metall schützt vor Inflation"
  /// wurde damit widerlegt. Gegen die mitwachsende Erwartung geprüft, darf
  /// der Kurs beliebig lange legitim steigen — der Reseed fängt weiter
  /// Katalog-Änderungen und absurde Ausreißer ab.
  static int expectedPriceCents(MetalSpec spec, int dayIndex) {
    if (dayIndex <= 0) return spec.basePrice.cents;
    final growth = math.pow(
      1 + InflationConfig.dailyRate * spec.inflationFactor,
      dayIndex,
    );
    return (spec.basePrice.cents * growth).round();
  }

  /// Untere/obere Reseed-Schranke relativ zum Erwartungswert.
  static const double priceBandLo = 0.4;
  static const double priceBandHi = 2.5;

  static int priceFloorCentsFor(MetalSpec spec, int dayIndex) {
    final floor = (expectedPriceCents(spec, dayIndex) * priceBandLo).round();
    return floor < 1 ? 1 : floor;
  }

  /// Schwelle, unter der ein Ø-Kaufpreis nicht legitim zustande gekommen sein
  /// kann (L13, Analyse 2026-08). 20 % der Basis liegt deutlich unter dem
  /// Kurs-Floor von 40 % — ein ehrlicher Kauf kann dort nie landen, ein
  /// Cent-Exploit schon. Gleiche Konstruktion wie bei Aktien/ETF/Krypto.
  static int exploitAvgPriceThresholdCentsFor(MetalSpec spec) {
    final t = (spec.basePrice.cents * 0.2).round();
    return t < 1 ? 1 : t;
  }
}

@freezed
abstract class MetalHolding with _$MetalHolding {
  const factory MetalHolding({
    required String assetId,
    required int shares,
    @MoneyConverter() required Money averageBuyPrice,
  }) = _MetalHolding;

  factory MetalHolding.fromJson(Map<String, dynamic> json) =>
      _$MetalHoldingFromJson(json);
}

@freezed
abstract class MetalQuote with _$MetalQuote {
  const factory MetalQuote({
    required String assetId,
    @MoneyConverter() required Money pricePerShare,
    required int onDayIndex,
  }) = _MetalQuote;

  factory MetalQuote.fromJson(Map<String, dynamic> json) =>
      _$MetalQuoteFromJson(json);
}
