import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/history/consumption_log.dart';
import 'package:finanzgame/features/history/opportunity_costs.dart';

void main() {
  group('OpportunityCosts.totalIfInvestedAsEtf', () {
    test('empty log → 0', () {
      expect(
        OpportunityCosts.totalIfInvestedAsEtf(
          log: const [],
          currentDayIndex: 100,
        ),
        0,
      );
    });

    test('single entry on same day = principal', () {
      final log = <ConsumptionEntry>[
        (dayIndex: 50, cents: 15000, label: 'Sneaker'),
      ];
      expect(
        OpportunityCosts.totalIfInvestedAsEtf(
          log: log,
          currentDayIndex: 50,
        ),
        15000,
      );
    });

    test('entry after 365 days compounds ≈ +8%', () {
      final log = <ConsumptionEntry>[
        (dayIndex: 0, cents: 15000, label: 'Sneaker'),
      ];
      final v = OpportunityCosts.totalIfInvestedAsEtf(
        log: log,
        currentDayIndex: 365,
      );
      expect(v, closeTo((15000 * 1.08).round(), 3));
    });

    test('entries after currentDay are ignored', () {
      final log = <ConsumptionEntry>[
        (dayIndex: 10, cents: 1000, label: 'a'),
        (dayIndex: 999, cents: 1000, label: 'future'),
      ];
      final v = OpportunityCosts.totalIfInvestedAsEtf(
        log: log,
        currentDayIndex: 10,
      );
      expect(v, 1000);
    });

    test('multiple entries sum correctly', () {
      final log = <ConsumptionEntry>[
        (dayIndex: 0, cents: 10000, label: 'a'),
        (dayIndex: 365, cents: 10000, label: 'b'),
      ];
      final v = OpportunityCosts.totalIfInvestedAsEtf(
        log: log,
        currentDayIndex: 365,
      );
      // a grew 1 year, b is fresh.
      expect(v, closeTo((10000 * 1.08).round() + 10000, 3));
    });
  });

  group('OpportunityCosts.shadowSeries', () {
    test('zero before first purchase, grows after', () {
      final log = <ConsumptionEntry>[
        (dayIndex: 5, cents: 10000, label: 'x'),
      ];
      final s = OpportunityCosts.shadowSeries(
        log: log,
        startDayIndex: 0,
        endDayIndex: 10,
      );
      expect(s.length, 11);
      // Days 0..4 = 0 (no purchase yet).
      for (var i = 0; i < 5; i++) {
        expect(s[i].$1, i);
        expect(s[i].$2, 0);
      }
      // Day 5 = principal.
      expect(s[5].$2, 10000);
      // Day 10 = slightly above principal.
      expect(s[10].$2, greaterThan(10000));
    });

    test('end < start → empty', () {
      expect(
        OpportunityCosts.shadowSeries(
          log: const [],
          startDayIndex: 10,
          endDayIndex: 5,
        ),
        isEmpty,
      );
    });
  });
}
