import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/job_level.dart';

/// Spec-45 C4: Steuerklassen modifizieren Lohnsteuer per Multiplikator.
void main() {
  group('Steuerklasse-Faktor', () {
    test('I + IV = Standard 1.0', () {
      expect(SalaryBreakdown.steuerklasseFactor(1), 1.0);
      expect(SalaryBreakdown.steuerklasseFactor(4), 1.0);
    });
    test('II = 0.85 (Entlastungsbetrag)', () {
      expect(SalaryBreakdown.steuerklasseFactor(2), 0.85);
    });
    test('III = 0.65 (Splitting)', () {
      expect(SalaryBreakdown.steuerklasseFactor(3), 0.65);
    });
    test('V = 1.35', () {
      expect(SalaryBreakdown.steuerklasseFactor(5), 1.35);
    });
    test('VI = 1.55 (Zweitjob)', () {
      expect(SalaryBreakdown.steuerklasseFactor(6), 1.55);
    });
    test('Out-of-range fällt auf 1.0 zurück', () {
      expect(SalaryBreakdown.steuerklasseFactor(0), 1.0);
      expect(SalaryBreakdown.steuerklasseFactor(7), 1.0);
    });
  });

  test('Klasse III hat weniger Lohnsteuer als Klasse I bei selbem Brutto', () {
    const gross = Money.cents(250000); // 2500 €
    final b1 = SalaryBreakdown.forGross(gross, steuerklasse: 1);
    final b3 = SalaryBreakdown.forGross(gross, steuerklasse: 3);
    expect(b3.tax.cents, lessThan(b1.tax.cents));
    expect(b3.net.cents, greaterThan(b1.net.cents));
  });

  test('Klasse V hat mehr Lohnsteuer als Klasse I', () {
    const gross = Money.cents(250000);
    final b1 = SalaryBreakdown.forGross(gross, steuerklasse: 1);
    final b5 = SalaryBreakdown.forGross(gross, steuerklasse: 5);
    expect(b5.tax.cents, greaterThan(b1.tax.cents));
    expect(b5.net.cents, lessThan(b1.net.cents));
  });

  test('Minijob bleibt steuerfrei auch in Klasse VI', () {
    const gross = Money.cents(4000); // 40 € Ferienjob
    final b = SalaryBreakdown.forGross(gross, steuerklasse: 6);
    expect(b.tax, Money.zero);
    expect(b.net, gross);
  });
}
