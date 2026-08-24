import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/job_level.dart';

/// Spec-45 C1 (yearly raise) + C2 (Senior/Lead promotions).
void main() {
  group('C2 — promotions Senior/Lead', () {
    test('forAge thresholds: 14/16/19/24/29', () {
      expect(JobConfig.forAge(13), JobLevel.none);
      expect(JobConfig.forAge(14), JobLevel.ferienjob);
      expect(JobConfig.forAge(15), JobLevel.ferienjob);
      expect(JobConfig.forAge(16), JobLevel.ausbildung);
      expect(JobConfig.forAge(18), JobLevel.ausbildung);
      expect(JobConfig.forAge(19), JobLevel.vollzeit);
      expect(JobConfig.forAge(23), JobLevel.vollzeit);
      expect(JobConfig.forAge(24), JobLevel.senior);
      expect(JobConfig.forAge(28), JobLevel.senior);
      expect(JobConfig.forAge(29), JobLevel.lead);
      expect(JobConfig.forAge(60), JobLevel.lead);
    });

    test('senior + lead base salaries', () {
      expect(
        JobConfig.monthlyGrossSalary(JobLevel.senior),
        const Money.cents(350000),
      );
      expect(
        JobConfig.monthlyGrossSalary(JobLevel.lead),
        const Money.cents(500000),
      );
    });

    test('living cost scales with level', () {
      expect(JobConfig.monthlyLivingCost(JobLevel.senior),
          const Money.cents(100000));
      expect(JobConfig.monthlyLivingCost(JobLevel.lead),
          const Money.cents(120000));
    });

    test('displayName for senior/lead', () {
      expect(JobConfig.displayName(JobLevel.senior), 'Senior');
      expect(JobConfig.displayName(JobLevel.lead), 'Teamlead');
    });

    test('jobTitle: variant 0 == displayName, höhere rotieren', () {
      // Basis-Variante == bisheriger Name (Erst-Job).
      expect(JobConfig.jobTitle(JobLevel.vollzeit), 'Vollzeit');
      expect(JobConfig.jobTitle(JobLevel.vollzeit, variant: 0), 'Vollzeit');
      // Wechsel → andere fiktive Bezeichnung.
      final v1 = JobConfig.jobTitle(JobLevel.vollzeit, variant: 1);
      expect(v1, isNot('Vollzeit'));
      expect(v1, contains('@')); // fiktive Firma
      // Rotation wickelt sauber um (kein RangeError).
      expect(
        JobConfig.jobTitle(JobLevel.vollzeit, variant: 99),
        isNotEmpty,
      );
      // Levels ohne Pool fallen auf displayName zurück.
      expect(JobConfig.jobTitle(JobLevel.none, variant: 3), 'Schüler');
    });
  });

  group('C1 — yearsInLevel + yearly raise', () {
    test('yearsInLevel resets on promotion', () {
      expect(JobConfig.yearsInLevel(14), 0);
      expect(JobConfig.yearsInLevel(15), 1);
      expect(JobConfig.yearsInLevel(16), 0);
      expect(JobConfig.yearsInLevel(18), 2);
      expect(JobConfig.yearsInLevel(19), 0);
      expect(JobConfig.yearsInLevel(23), 4);
      expect(JobConfig.yearsInLevel(24), 0);
      expect(JobConfig.yearsInLevel(29), 0);
    });

    test('raise: +2% per year, capped at 10 years', () {
      // Vollzeit base 2500 €.
      final base = JobConfig.monthlyGrossSalary(JobLevel.vollzeit);
      expect(base, const Money.cents(250000));

      final after3 = JobConfig.monthlyGrossSalary(
        JobLevel.vollzeit,
        yearsInLevel: 3,
      );
      // 250000 * 1.06 = 265000
      expect(after3, const Money.cents(265000));

      final after10 = JobConfig.monthlyGrossSalary(
        JobLevel.vollzeit,
        yearsInLevel: 10,
      );
      // 250000 * 1.20 = 300000
      expect(after10, const Money.cents(300000));

      final after20 = JobConfig.monthlyGrossSalary(
        JobLevel.vollzeit,
        yearsInLevel: 20,
      );
      // Capped at +20% (10 J).
      expect(after20, const Money.cents(300000));
    });

    test('raise applies to ferienjob too', () {
      final after2 = JobConfig.monthlyGrossSalary(
        JobLevel.ferienjob,
        yearsInLevel: 2,
      );
      // 4000 * 1.04 = 4160
      expect(after2, const Money.cents(4160));
    });

    test('none level not affected by yearsInLevel', () {
      expect(
        JobConfig.monthlyGrossSalary(JobLevel.none, yearsInLevel: 5),
        Money.zero,
      );
    });
  });
}
