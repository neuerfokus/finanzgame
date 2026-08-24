import 'dart:math' as math;

import '../economy/money.dart';

/// Spec-38 follow-up (Welle 5): Mischwald-Insel = Sachwerte/Sammlerobjekte.
/// Oldtimer, Diamanten, Gemälde, Briefmarken — Real-Assets mit langsamem,
/// inflationsentkoppeltem Wertzuwachs.
///
/// Vereinfachte Preis-Mechanik: `value = basePrice × (1 + annualGrowthPct/100)^yearsHeld`.
/// Keine Tages-Volatilität — Sammler-Markt ist illiquide, Kurs ändert sich
/// nur jährlich. Bei Verkauf gibt es 10 % Händler-Spread Abzug.
class CollectibleSpec {
  const CollectibleSpec({
    required this.id,
    required this.name,
    required this.glyph,
    required this.basePrice,
    required this.annualGrowthPct,
    required this.description,
    this.spreadPct = 10.0,
    this.carryCostPctPerYear = 0.0,
    this.sellDelayDays = 3,
  });

  final String id;
  final String name;
  final String glyph;
  final Money basePrice;

  /// Jährlicher Wertzuwachs in Prozent. Realistische Werte:
  /// Oldtimer 5–8 %, Diamanten 3–4 %, Gemälde 4–6 %, Briefmarken 2–3 %.
  final double annualGrowthPct;

  final String description;

  /// Spec-44 F1: Händler-Spread beim Verkauf (% Abzug vom Marktwert).
  /// Diamant 30 (extrem), Oldtimer 15, Gemälde 20-25, Briefmarken 20.
  /// Lektion "Du verlierst Geld in der Sekunde, in der du kaufst".
  final double spreadPct;

  /// Spec-44 F1: jährliche Tragekosten (Versicherung/Garage/Wartung)
  /// als % vom Anschaffungspreis. Oldtimer 8, Gemälde 2, Diamant/
  /// Briefmarken 0.
  final double carryCostPctPerYear;

  /// Spec-44 F1: Verkaufs-Verzögerung — Verkauf "zum Markt anbieten",
  /// Geld erst nach N Tagen. Sofortverkauf möglich mit Extra-Abschlag.
  final int sellDelayDays;

  /// Wert nach [yearsHeld] Jahren (kann fractional sein).
  Money valueAfter(double yearsHeld) {
    final factor = math.pow(1 + annualGrowthPct / 100, yearsHeld);
    return Money.cents((basePrice.cents * factor).round());
  }

  /// Spec-44 F1: Verkaufspreis = Marktwert × (1 - spread) - kumulierte
  /// Tragekosten. Tragekosten linear über Zeit.
  Money sellValue(double yearsHeld) {
    final market = valueAfter(yearsHeld).cents.toDouble();
    final afterSpread = market * (1 - spreadPct / 100);
    final carry = basePrice.cents *
        (carryCostPctPerYear / 100) *
        yearsHeld;
    final net = (afterSpread - carry).round();
    return Money.cents(net < 0 ? 0 : net);
  }
}

abstract final class CollectibleCatalog {
  static const oldtimerKaefer = CollectibleSpec(
    id: 'col_oldtimer_kaefer',
    name: 'Oldtimer (Käfer-Klassik)',
    glyph: '🚗',
    basePrice: Money.cents(1500000), // 15 000 €
    annualGrowthPct: 6.0,
    spreadPct: 15.0,
    carryCostPctPerYear: 8.0,
    sellDelayDays: 5,
    description:
        'Klassiker. 15 % Spread + 8 %/J Garage/Versicherung fressen '
        'Steigerung.',
  );
  static const oldtimerSport = CollectibleSpec(
    id: 'col_oldtimer_sport',
    name: 'Oldtimer (Sportwagen)',
    glyph: '🏎',
    basePrice: Money.cents(8000000), // 80 000 €
    annualGrowthPct: 8.0,
    spreadPct: 15.0,
    carryCostPctPerYear: 8.0,
    sellDelayDays: 5,
    description:
        'Limitierter Sportwagen. 15 % Spread + hohe Tragekosten.',
  );
  static const diamant = CollectibleSpec(
    id: 'col_diamant',
    name: 'Diamant (1 Karat)',
    glyph: '💎',
    basePrice: Money.cents(800000), // 8 000 €
    annualGrowthPct: 3.5,
    spreadPct: 30.0,
    carryCostPctPerYear: 0.0,
    sellDelayDays: 3,
    description:
        'Klar, zertifiziert. ACHTUNG: 30 % Spread — du verlierst Geld '
        'in der Sekunde, in der du kaufst.',
  );
  static const gemaeldeKlassik = CollectibleSpec(
    id: 'col_gemaelde_klassik',
    name: 'Gemälde (Klassik)',
    glyph: '🖼',
    basePrice: Money.cents(2500000), // 25 000 €
    annualGrowthPct: 5.0,
    spreadPct: 20.0,
    carryCostPctPerYear: 2.0,
    sellDelayDays: 7,
    description:
        'Anerkannte Künstler. 20 % Spread + Versicherung. Geduld nötig.',
  );
  static const gemaeldeModern = CollectibleSpec(
    id: 'col_gemaelde_modern',
    name: 'Gemälde (Modern)',
    glyph: '🎨',
    basePrice: Money.cents(1200000), // 12 000 €
    annualGrowthPct: 7.0,
    spreadPct: 25.0,
    carryCostPctPerYear: 2.0,
    sellDelayDays: 7,
    description:
        'Zeitgenössisch. 25 % Spread, hohe Bandbreite. Moderisiko.',
  );
  static const briefmarken = CollectibleSpec(
    id: 'col_briefmarken',
    name: 'Briefmarken-Sammlung',
    glyph: '✉️',
    basePrice: Money.cents(300000), // 3 000 €
    annualGrowthPct: 2.5,
    spreadPct: 20.0,
    carryCostPctPerYear: 0.0,
    sellDelayDays: 7,
    description:
        'Klassische Wertanlage. 20 % Spread. Schrumpfender Sammlermarkt.',
  );

  static const all = <CollectibleSpec>[
    oldtimerKaefer,
    oldtimerSport,
    diamant,
    gemaeldeKlassik,
    gemaeldeModern,
    briefmarken,
  ];

  static CollectibleSpec byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => briefmarken);
}

class CollectibleHolding {
  const CollectibleHolding({
    required this.rowId,
    required this.specId,
    required this.boughtAtDayIndex,
    required this.boughtPrice,
    this.listedOnDay,
  });

  /// Drift auto-increment row-id. -1 = in-memory only (used in tests).
  final int rowId;
  final String specId;
  final int boughtAtDayIndex;
  final Money boughtPrice;

  /// Spec-44 F1 sprint F: wenn nicht null → zum Verkauf angeboten am Tag X.
  /// Verkauf wird in `settleListings` nach `spec.sellDelayDays` abgewickelt.
  /// NICHT persistiert (Spec H wird Drift-Migration nachziehen) — Restart
  /// = Listing-State verloren.
  final int? listedOnDay;

  bool get isListed => listedOnDay != null;

  CollectibleHolding copyWith({int? listedOnDay, bool clearListing = false}) {
    return CollectibleHolding(
      rowId: rowId,
      specId: specId,
      boughtAtDayIndex: boughtAtDayIndex,
      boughtPrice: boughtPrice,
      listedOnDay: clearListing ? null : (listedOnDay ?? this.listedOnDay),
    );
  }
}
