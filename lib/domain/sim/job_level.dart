import '../economy/money.dart';

/// spec-35 phase D + spec-45 C1/C2: career level tied to in-game age
/// with auto-promotion and per-year salary raises.
///
/// C2 fügt zwei Stufen hinzu: senior (24+, 5 J Vollzeit) und lead
/// (29+, 5 J Senior). C1 liefert pro Jahr im selben Level +2 % Brutto,
/// Cap 10 Jahre Steigerung (~+22 %).
enum JobLevel {
  none,
  ferienjob,
  ausbildung,
  vollzeit,
  senior,
  lead,
}

abstract final class JobConfig {
  /// Promotion-Schwellen anhand des Lebensalters (Jahre).
  static const int ferienjobAge = 14;
  static const int ausbildungAge = 16;
  static const int vollzeitAge = 19;
  static const int seniorAge = 24; // 5 Jahre Vollzeit
  static const int leadAge = 29;   // 5 Jahre Senior

  /// Spec-45 C1: jährliche Gehaltssteigerung (Anteil pro Jahr).
  static const double yearlyRaisePerYear = 0.02;
  /// Steigerung gedeckelt nach so vielen Jahren im Level.
  static const int yearlyRaiseCapYears = 10;

  /// Job-Level anhand des Alters (in Jahren). Respektiert startAgeYears.
  static JobLevel forAge(int ageYears) {
    if (ageYears >= leadAge) return JobLevel.lead;
    if (ageYears >= seniorAge) return JobLevel.senior;
    if (ageYears >= vollzeitAge) return JobLevel.vollzeit;
    if (ageYears >= ausbildungAge) return JobLevel.ausbildung;
    if (ageYears >= ferienjobAge) return JobLevel.ferienjob;
    return JobLevel.none;
  }

  /// Backward-compat: dayIndex + startAge → JobLevel.
  static JobLevel forDay(int dayIndex, {int startAgeYears = 13}) =>
      forAge(startAgeYears + dayIndex ~/ 365);

  /// Spec-45 C1: wie viele volle Jahre der Spieler bereits im aktuellen
  /// Level ist. 0 direkt nach Beförderung.
  static int yearsInLevel(int ageYears) {
    final l = forAge(ageYears);
    final base = switch (l) {
      JobLevel.none => ferienjobAge,
      JobLevel.ferienjob => ferienjobAge,
      JobLevel.ausbildung => ausbildungAge,
      JobLevel.vollzeit => vollzeitAge,
      JobLevel.senior => seniorAge,
      JobLevel.lead => leadAge,
    };
    final years = ageYears - base;
    return years < 0 ? 0 : years;
  }

  /// Basis-Brutto-Monatslohn (Jahre-0, vor Steuer + Sozialabgaben).
  static Money _baseMonthlyGross(JobLevel l) => switch (l) {
        JobLevel.none => Money.zero,
        JobLevel.ferienjob => const Money.cents(4000), // 40 € Mini
        JobLevel.ausbildung => const Money.cents(85000), // 850 € brutto
        JobLevel.vollzeit => const Money.cents(250000), // 2500 € brutto
        JobLevel.senior => const Money.cents(350000),   // 3500 € brutto
        JobLevel.lead => const Money.cents(500000),     // 5000 € brutto
      };

  /// Brutto-Monatslohn mit C1-Steigerung (yearsInLevel × 2 %, Cap 10 J).
  static Money monthlyGrossSalary(JobLevel l, {int yearsInLevel = 0}) {
    final base = _baseMonthlyGross(l);
    if (base.cents == 0) return Money.zero;
    final clamped = yearsInLevel.clamp(0, yearlyRaiseCapYears);
    final factor = 1.0 + yearlyRaisePerYear * clamped;
    return Money.cents((base.cents * factor).round());
  }

  /// Netto-Monatslohn nach progressiver Lohnsteuer + Sozialabgaben.
  /// Ferienjob steuerfrei (Minijob). Sonst: Brutto − Lohnsteuer −
  /// Sozialabgaben (~20 %).
  static Money monthlySalary(
    JobLevel l, {
    int yearsInLevel = 0,
    int steuerklasse = 1,
  }) {
    final gross = monthlyGrossSalary(l, yearsInLevel: yearsInLevel);
    if (gross.cents == 0) return Money.zero;
    final breakdown =
        SalaryBreakdown.forGross(gross, steuerklasse: steuerklasse);
    return breakdown.net;
  }

  /// Bug-fix v26: monatliche Lebenskosten pro Job-Phase (Miete +
  /// Essen + Versicherung). Skaliert mit Lebenssituation:
  /// - Schüler/Ferienjob: 0 (Eltern zahlen)
  /// - Ausbildung:        200 € (eigenes Zimmer, Essensgeld)
  /// - Vollzeit:          800 € (eigene Wohnung, Vollkosten)
  /// - Senior:           1000 € (größere Wohnung, mehr Lebensstil)
  /// - Lead:             1200 € (Komfort, höhere Fixkosten)
  static Money monthlyLivingCost(JobLevel l) => switch (l) {
        JobLevel.none => Money.zero,
        JobLevel.ferienjob => Money.zero,
        JobLevel.ausbildung => const Money.cents(20000),
        JobLevel.vollzeit => const Money.cents(80000),
        JobLevel.senior => const Money.cents(100000),
        JobLevel.lead => const Money.cents(120000),
      };

  /// Anteil der Lebenskosten, der auf die Miete entfällt (60 %).
  ///
  /// Der Rest — Essen, Strom, Versicherung — läuft im Eigenheim weiter. Wer
  /// selbst in seiner Immobilie wohnt, spart genau diesen Anteil und zahlt
  /// stattdessen Hypothek und Instandhaltung. Das ist der wirtschaftliche
  /// Kern des Eigenheims und war vor 2026-08 gar nicht abgebildet: die
  /// Lebenskosten liefen unverändert weiter, ein Eigenheim war damit reine
  /// Zusatzbelastung.
  static const int rentShareOfLivingCostBps = 6000;

  /// Lebenskosten ohne Miet-Anteil — die Untergrenze, wenn die eigene
  /// Immobilie mindestens so viel wert ist wie die bisherige Mietwohnung.
  static Money monthlyLivingCostWithoutRent(JobLevel l) {
    final full = monthlyLivingCost(l).cents;
    return Money.cents(full - (full * rentShareOfLivingCostBps) ~/ 10000);
  }

  /// Der Miet-Anteil der Lebenskosten — die Obergrenze dessen, was ein
  /// Eigenheim sparen kann.
  static Money monthlyRentShare(JobLevel l) => Money.cents(
        (monthlyLivingCost(l).cents * rentShareOfLivingCostBps) ~/ 10000,
      );

  /// Was man durch Selbstbewohnen tatsächlich spart: das Kleinere aus der
  /// Marktmiete der eigenen Immobilie und dem Miet-Anteil der Lebenskosten.
  ///
  /// Beim Test am Gerät aufgefallen: nimmt man immer den vollen Miet-Anteil,
  /// spart eine 120.000-€-Wohnung (Marktmiete 350 €) genauso viel wie ein
  /// 480.000-€-Haus — nämlich 720 €. Die billigste Immobilie wäre damit die
  /// beste, und das ist verkehrt herum. Wer in einer kleinen Wohnung wohnt,
  /// spart nur, was diese Wohnung an Miete kosten würde; wer sich ein großes
  /// Haus kauft, spart höchstens das, was er vorher an Miete gezahlt hat.
  static Money savedRentFor(JobLevel l, Money? ownHomeMarketRent) {
    if (ownHomeMarketRent == null) return Money.zero;
    final share = monthlyRentShare(l).cents;
    final rent = ownHomeMarketRent.cents;
    return Money.cents(rent < share ? rent : share);
  }

  static String displayName(JobLevel l) => switch (l) {
        JobLevel.none => 'Schüler',
        JobLevel.ferienjob => 'Mini-Job',
        JobLevel.ausbildung => 'Ausbildung',
        JobLevel.vollzeit => 'Vollzeit',
        JobLevel.senior => 'Senior',
        JobLevel.lead => 'Teamlead',
      };

  /// v35: fiktive Berufsbezeichnungen pro Level. Index 0 = Basis
  /// (Erst-Job, == displayName), jeder Job-Wechsel rotiert eine Stelle
  /// weiter. NUR fiktive Firmen — Hardregel: keine echten Marken.
  static const Map<JobLevel, List<String>> _titlePool = {
    JobLevel.ausbildung: [
      'Ausbildung',
      'Azubi @ NordTech',
      'Azubi @ SnipeShot',
      'Azubi @ BeckerBau',
    ],
    JobLevel.vollzeit: [
      'Vollzeit',
      'Sachbearbeiter @ NordTech',
      'Berater @ FinkBank',
      'Disponent @ SnipeShot',
      'Allrounder @ DropTok',
    ],
    JobLevel.senior: [
      'Senior',
      'Senior @ NordTech',
      'Koordinator @ FinkBank',
      'Spezialist @ SnipeShot',
    ],
    JobLevel.lead: [
      'Teamlead',
      'Abteilungsleiter @ NordTech',
      'Bereichsleiter @ FinkBank',
      'Head @ DropTok',
    ],
  };

  /// Berufsbezeichnung inkl. Job-Wechsel-Variante. variant 0 == Basis
  /// (displayName). Höhere Varianten rotieren durch den fiktiven Pool.
  static String jobTitle(JobLevel l, {int variant = 0}) {
    final pool = _titlePool[l];
    if (pool == null || pool.isEmpty || variant <= 0) return displayName(l);
    return pool[variant % pool.length];
  }
}

/// Brutto-Netto-Aufschlüsselung mit vereinfachter progressiver Lohnsteuer
/// + Sozialabgaben. Didaktisch — kein echtes deutsches Steuerrecht.
///
/// Stufen (Jahres-Brutto):
/// - bis  12.000 €:  0 % Lohnsteuer (Grundfreibetrag)
/// - bis  18.000 €: 14 %
/// - bis  32.000 €: 24 %
/// - bis  60.000 €: 32 %
/// - darüber:       42 %
/// Sozialabgaben pauschal 20 % (KV + RV + AV + PV).
/// Ferienjob (Minijob bis 538 €/Mo): steuer- und sozialfrei.
class SalaryBreakdown {
  const SalaryBreakdown({
    required this.gross,
    required this.tax,
    required this.soli,
    required this.kirche,
    required this.social,
    required this.net,
  });

  /// Monatliches Brutto.
  final Money gross;
  /// Monatliche Lohnsteuer (progressiv).
  final Money tax;
  /// Solidaritätszuschlag (5,5 % auf Lohnsteuer, nur ab Schwelle).
  final Money soli;
  /// Kirchensteuer (8 % auf Lohnsteuer in BY/BW, 9 % sonst — wir nutzen 9 %).
  final Money kirche;
  /// Monatliche Sozialabgaben (KV/RV/AV/PV).
  final Money social;
  /// Monatlicher Netto-Auszahlungsbetrag.
  final Money net;

  static const int minijobMonthlyThresholdCents = 53800; // 538 €

  /// Spec-45 C4: Steuerklassen-Multiplikator auf Lohnsteuer.
  /// Vereinfachte didaktische Werte — kein präzises Steuerrecht:
  /// - I  (Single, Standard):                  1.00
  /// - II (Alleinerziehend, Entlastungsbetrag): 0.85
  /// - III (Ehe, Hauptverdiener mit Splitting): 0.65
  /// - IV (Ehe, gleiche Einkommen):             1.00
  /// - V  (Ehe, Geringverdiener):               1.35
  /// - VI (Zweitjob, ohne Grundfreibetrag):     1.55
  static double steuerklasseFactor(int klasse) => switch (klasse) {
        2 => 0.85,
        3 => 0.65,
        5 => 1.35,
        6 => 1.55,
        _ => 1.00, // 1 + 4 + Fallback
      };

  static String steuerklasseLabel(int klasse) => switch (klasse) {
        1 => 'I — Single',
        2 => 'II — Alleinerziehend',
        3 => 'III — Ehe (Hauptverdiener)',
        4 => 'IV — Ehe (gleich)',
        5 => 'V — Ehe (Geringverdiener)',
        6 => 'VI — Zweitjob',
        _ => 'I — Single',
      };

  static SalaryBreakdown forGross(Money grossMonthly, {int steuerklasse = 1}) {
    final cents = grossMonthly.cents;
    if (cents <= 0) {
      return SalaryBreakdown(
        gross: grossMonthly,
        tax: Money.zero,
        soli: Money.zero,
        kirche: Money.zero,
        social: Money.zero,
        net: Money.zero,
      );
    }
    // Minijob steuer- und sozialfrei.
    if (cents <= minijobMonthlyThresholdCents) {
      return SalaryBreakdown(
        gross: grossMonthly,
        tax: Money.zero,
        soli: Money.zero,
        kirche: Money.zero,
        social: Money.zero,
        net: grossMonthly,
      );
    }
    final annualGross = cents * 12;
    final factor = steuerklasseFactor(steuerklasse);
    final annualTax = (_progressiveTax(annualGross) * factor).round();
    final monthlyTax = annualTax ~/ 12;
    // Soli 5,5 % auf Lohnsteuer (vereinfachte Freigrenze ignoriert).
    final monthlySoli = (monthlyTax * 55) ~/ 1000;
    // Kirchensteuer 9 % auf Lohnsteuer (Mehrheit DE).
    final monthlyKirche = (monthlyTax * 9) ~/ 100;
    final monthlySocial = (cents * 20) ~/ 100;
    final monthlyNet =
        cents - monthlyTax - monthlySoli - monthlyKirche - monthlySocial;
    return SalaryBreakdown(
      gross: grossMonthly,
      tax: Money.cents(monthlyTax),
      soli: Money.cents(monthlySoli),
      kirche: Money.cents(monthlyKirche),
      social: Money.cents(monthlySocial),
      net: Money.cents(monthlyNet),
    );
  }

  static int _progressiveTax(int annualCents) {
    // Stufen in Jahres-Cents.
    const t1 = 1200000;  // 12k
    const t2 = 1800000;  // 18k
    const t3 = 3200000;  // 32k
    const t4 = 6000000;  // 60k
    var remaining = annualCents;
    var tax = 0;
    // Bracket 1: 0 % bis 12k
    final b1 = remaining.clamp(0, t1);
    remaining -= b1;
    if (remaining <= 0) return tax;
    // Bracket 2: 14 % bis 18k
    final b2 = remaining.clamp(0, t2 - t1);
    tax += (b2 * 14) ~/ 100;
    remaining -= b2;
    if (remaining <= 0) return tax;
    // Bracket 3: 24 % bis 32k
    final b3 = remaining.clamp(0, t3 - t2);
    tax += (b3 * 24) ~/ 100;
    remaining -= b3;
    if (remaining <= 0) return tax;
    // Bracket 4: 32 % bis 60k
    final b4 = remaining.clamp(0, t4 - t3);
    tax += (b4 * 32) ~/ 100;
    remaining -= b4;
    if (remaining <= 0) return tax;
    // Bracket 5: 42 % darüber
    tax += (remaining * 42) ~/ 100;
    return tax;
  }
}
