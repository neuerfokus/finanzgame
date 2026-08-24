import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/sim/weather.dart';
import 'package:finanzgame/features/weather/weather_state.dart';

void main() {
  group('rollWeather', () {
    test('deterministic per dayIndex', () {
      for (var d in [0, 1, 7, 30, 100, 365]) {
        expect(rollWeather(d), rollWeather(d), reason: 'day $d');
      }
    });

    test('covers all four kinds across many days', () {
      final seen = <Weather>{};
      for (var d = 0; d < 100; d++) {
        seen.add(rollWeather(d));
      }
      expect(seen, containsAll(Weather.values));
    });

    test('roughly matches target distribution over 1000 days', () {
      final counts = {for (final w in Weather.values) w: 0};
      for (var d = 0; d < 1000; d++) {
        counts[rollWeather(d)] = counts[rollWeather(d)]! + 1;
      }
      // Tolerant bounds — not asserting exact stats, just sanity.
      expect(counts[Weather.sunny]!, greaterThan(200));
      expect(counts[Weather.storm]!, lessThan(200));
    });
  });
}
