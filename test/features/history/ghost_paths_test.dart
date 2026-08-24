import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/history/ghost_paths.dart';

void main() {
  group('GhostPaths.compoundDailyFromYearly', () {
    test('first point equals startCents', () {
      final p = GhostPaths.compoundDailyFromYearly(
        startCents: 10000,
        days: 5,
        yearlyPct: 0.08,
      );
      expect(p.first.$2, 10000);
      expect(p.first.$1, 0);
      expect(p.length, 5);
    });

    test('after 365 days ≈ start × (1+r)', () {
      const start = 10000;
      const yearly = 0.08;
      final p = GhostPaths.compoundDailyFromYearly(
        startCents: start,
        days: 366,
        yearlyPct: yearly,
      );
      final last = p.last.$2;
      // Allow tiny rounding drift from daily compounding.
      expect(last, closeTo((start * (1 + yearly)).round(), 2));
    });

    test('startDayIndex offsets the x-coordinate', () {
      final p = GhostPaths.compoundDailyFromYearly(
        startCents: 100,
        days: 3,
        yearlyPct: 0.0,
        startDayIndex: 42,
      );
      expect(p.map((e) => e.$1).toList(), [42, 43, 44]);
      // 0% rate → value stays flat.
      expect(p.last.$2, 100);
    });
  });

  group('GhostPaths.diversified', () {
    test('beats Gold-only and lags ETF-only after many years', () {
      const start = 100000; // 1000 €
      const days = 365 * 10;
      final etfOnly = GhostPaths.compoundDailyFromYearly(
        startCents: start,
        days: days,
        yearlyPct: GhostPaths.etfYearlyPct,
      ).last.$2;
      final goldOnly = GhostPaths.compoundDailyFromYearly(
        startCents: start,
        days: days,
        yearlyPct: GhostPaths.goldYearlyPct,
      ).last.$2;
      final mix = GhostPaths.diversified(
        startCents: start,
        days: days,
      ).last.$2;
      expect(mix, greaterThan(goldOnly));
      expect(mix, lessThan(etfOnly));
    });
  });
}
