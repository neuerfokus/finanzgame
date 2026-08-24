import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'real_estate.freezed.dart';
part 'real_estate.g.dart';

/// Wofür eine gekaufte Immobilie genutzt wird.
///
/// **Warum es das gibt (2026-08, User-Fund):** vorher hatte nur das
/// Mehrfamilienhaus eine Miete, alle anderen Objekte brachten null Einnahmen —
/// während die Lebenskosten (Miete + Essen + Versicherung) unverändert
/// weiterliefen. Ein Eigenheim kostete also Anzahlung, 11 % Kaufnebenkosten,
/// 30 Jahre Hypothek und Instandhaltung, **und man zahlte weiter Miete**.
/// Dagegen standen 3,5 % Wertsteigerung, weniger als der ETF bringt. Kaufen
/// war damit garantiert die schlechteste Entscheidung im Spiel — und das ist
/// nicht didaktische Zurückhaltung, sondern schlicht falsch gerechnet: der
/// wirtschaftliche Kern des Eigenheims ist die **eingesparte Miete**.
enum RealEstateUsage {
  /// Man wohnt selbst drin: keine Mieteinnahme, dafür entfällt der
  /// Miet-Anteil der Lebenskosten. Nur EINE Immobilie gleichzeitig.
  selfOccupied,

  /// Vermietet: Mieteinnahme (abzüglich Leerstand und Steuer), die eigenen
  /// Lebenskosten laufen voll weiter — man wohnt ja woanders zur Miete.
  rented,
}

/// spec-44 sprint D (F2): Immobilien-Leiter mit Hebel (Hypothek),
/// Kaufnebenkosten, Instandhaltung, Mieteinnahmen und
/// Spekulationssteuer-Frist.
///
/// Wertaenderung ~3,5 %/J liegt bewusst unter der ETF-CAGR — der Reiz
/// bei Investment-Objekten kommt aus dem Hebel + Cashflow, nicht aus der
/// reinen Wertsteigerung.
class RealEstateSpec {
  const RealEstateSpec({
    required this.id,
    required this.name,
    required this.emoji,
    required this.basePrice,
    required this.appreciationPerYear,
    required this.maintenanceBpsPerYear,
    this.monthlyRent,
    this.isInvestment = false,
    this.mortgageEnabled = true,
    this.downPaymentBps = 2000, // 20 %
    this.kaufnebenkostenBps = 1100, // 11 %
    this.mortgageTermYears = 30,
    this.mortgageRateBpsPerYear = 400, // 4 %/J Zins
    this.vacancyChancePerMonth = 0.05,
  });

  final String id;
  final String name;
  final String emoji;
  final Money basePrice;
  final double appreciationPerYear;
  final int maintenanceBpsPerYear;
  final Money? monthlyRent;
  final bool isInvestment;
  final bool mortgageEnabled;
  final int downPaymentBps;
  final int kaufnebenkostenBps;
  final int mortgageTermYears;
  final int mortgageRateBpsPerYear;
  final double vacancyChancePerMonth;

  Money get downPayment =>
      Money.cents((basePrice.cents * downPaymentBps) ~/ 10000);

  Money get kaufnebenkosten =>
      Money.cents((basePrice.cents * kaufnebenkostenBps) ~/ 10000);

  Money get cashAtPurchase => Money.cents(
        downPayment.cents + kaufnebenkosten.cents,
      );

  Money get initialMortgage =>
      Money.cents(basePrice.cents - downPayment.cents);

  Money get monthlyPrincipal {
    if (!mortgageEnabled) return Money.zero;
    final months = mortgageTermYears * 12;
    return Money.cents(initialMortgage.cents ~/ months);
  }

  int get totalMortgageMonths => mortgageTermYears * 12;

  Money get monthlyMaintenance => Money.cents(
        (basePrice.cents * maintenanceBpsPerYear) ~/ 10000 ~/ 12,
      );

  /// Legacy-Kompat: Wert war bis spec-44 fester Bestandteil aller Specs.
  /// Wer das noch braucht, bekommt monthlyRent oder Money.zero.
  Money get baseRentPerMonth => monthlyRent ?? Money.zero;

  /// Kann man hier selbst einziehen? Das Mehrfamilienhaus ist ein reines
  /// Anlageobjekt — es bleibt immer vermietet.
  bool get canBeSelfOccupied => !isInvestment;
}

/// Steuer auf Mieteinnahmen, vereinfacht auf 25 %.
///
/// **Fachlich ungenau, bewusst:** echte Mieteinnahmen laufen über den
/// persönlichen Einkommensteuersatz, nicht über die 25 % der
/// Kapitalertragssteuer. Für einen 14-Jährigen ist „von der Miete bleibt
/// nicht alles übrig" die Lektion; der genaue Satz ist zweitrangig. Die
/// Vereinfachung steht als Hinweis in der Immobilien-Seite.
const int rentTaxBps = 2500;

/// Netto-Miete nach Steuer.
Money rentAfterTax(Money gross) =>
    Money.cents(gross.cents - (gross.cents * rentTaxBps) ~/ 10000);

abstract final class RealEstateCatalog {
  static const wgZimmer = RealEstateSpec(
    id: 're_wg_zimmer',
    name: 'WG-Zimmer',
    emoji: '\u{1F6CF}',
    basePrice: Money.cents(1500000),
    appreciationPerYear: 0.0,
    maintenanceBpsPerYear: 0,
    mortgageEnabled: false,
  );

  static const eigentumswohnung = RealEstateSpec(
    id: 're_etw',
    name: 'Eigentumswohnung',
    emoji: '\u{1F3E2}',
    basePrice: Money.cents(12000000),
    appreciationPerYear: 0.035,
    maintenanceBpsPerYear: 120,
    // Bruttomietrendite ~3,5 %/Jahr auf den Kaufpreis — 120.000 € × 3,5 %
    // / 12 ≈ 350 €/Monat. Gilt nur, wenn die Wohnung vermietet wird.
    monthlyRent: Money.cents(35000),
  );

  static const reihenhaus = RealEstateSpec(
    id: 're_reihenhaus',
    name: 'Reihenhaus',
    emoji: '\u{1F3D8}',
    basePrice: Money.cents(28000000),
    appreciationPerYear: 0.035,
    maintenanceBpsPerYear: 120,
    monthlyRent: Money.cents(81000), // 280.000 € × 3,5 % / 12
  );

  static const doppelhaushaelfte = RealEstateSpec(
    id: 're_dhh',
    name: 'Doppelhaushaelfte',
    emoji: '\u{1F3E1}',
    basePrice: Money.cents(34000000),
    appreciationPerYear: 0.035,
    maintenanceBpsPerYear: 120,
    monthlyRent: Money.cents(99000), // 340.000 € × 3,5 % / 12
  );

  static const freistehendesHaus = RealEstateSpec(
    id: 're_haus',
    name: 'Freistehendes Haus',
    emoji: '\u{1F3E0}',
    basePrice: Money.cents(48000000),
    appreciationPerYear: 0.035,
    maintenanceBpsPerYear: 150,
    monthlyRent: Money.cents(140000), // 480.000 € × 3,5 % / 12
  );

  static const mehrfamilienhaus = RealEstateSpec(
    id: 're_mfh',
    name: 'Mehrfamilienhaus',
    emoji: '\u{1F3EC}',
    basePrice: Money.cents(75000000),
    appreciationPerYear: 0.035,
    maintenanceBpsPerYear: 150,
    monthlyRent: Money.cents(250000),
    isInvestment: true,
  );

  static const all = <RealEstateSpec>[
    wgZimmer,
    eigentumswohnung,
    reihenhaus,
    doppelhaushaelfte,
    freistehendesHaus,
    mehrfamilienhaus,
  ];

  static const buyable = <RealEstateSpec>[
    eigentumswohnung,
    reihenhaus,
    doppelhaushaelfte,
    freistehendesHaus,
    mehrfamilienhaus,
  ];

  static RealEstateSpec byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => wgZimmer);
}

@freezed
abstract class RealEstateHolding with _$RealEstateHolding {
  const factory RealEstateHolding({
    required String specId,
    required int ownedSinceDayIndex,
    @MoneyConverter() required Money purchasePrice,

    /// Drift v39. Default `rented`, damit Bestände aus älteren Spielständen
    /// nicht plötzlich Lebenskosten sparen, ohne dass der Spieler das je
    /// gewählt hat — er kann jederzeit umschalten.
    @Default(RealEstateUsage.rented) RealEstateUsage usage,
  }) = _RealEstateHolding;

  factory RealEstateHolding.fromJson(Map<String, dynamic> json) =>
      _$RealEstateHoldingFromJson(json);
}

class MortgageMath {
  const MortgageMath._();

  static int monthsPaid({
    required int currentDayIndex,
    required int ownedSinceDayIndex,
  }) {
    final daysOwned = currentDayIndex - ownedSinceDayIndex;
    if (daysOwned <= 0) return 0;
    return daysOwned ~/ 30;
  }

  static Money remainingPrincipal({
    required RealEstateSpec spec,
    required int monthsPaid,
  }) {
    if (!spec.mortgageEnabled) return Money.zero;
    final paid = monthsPaid.clamp(0, spec.totalMortgageMonths);
    // Zum Laufzeitende ist die Hypothek vollstaendig getilgt — Rundungs-
    // reste aus integer-Division werden hier auf 0 geclamped.
    if (paid >= spec.totalMortgageMonths) return Money.zero;
    final principalPaid = spec.monthlyPrincipal.cents * paid;
    final remaining = spec.initialMortgage.cents - principalPaid;
    return Money.cents(remaining < 0 ? 0 : remaining);
  }

  static Money monthlyPayment({
    required RealEstateSpec spec,
    required int monthsPaid,
  }) {
    if (!spec.mortgageEnabled) return Money.zero;
    if (monthsPaid >= spec.totalMortgageMonths) return Money.zero;
    final principal = spec.monthlyPrincipal;
    final remaining = remainingPrincipal(spec: spec, monthsPaid: monthsPaid);
    final monthlyInterest =
        (remaining.cents * spec.mortgageRateBpsPerYear) ~/ 10000 ~/ 12;
    return Money.cents(principal.cents + monthlyInterest);
  }
}