import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/sim/weather.dart';

void main() {
  group('growthMultiplier (spec-18)', () {
    test('rain is best, storm worst', () {
      expect(growthMultiplier(Weather.rain), 1.3);
      expect(growthMultiplier(Weather.sunny), 1.2);
      expect(growthMultiplier(Weather.cloudy), 1.0);
      expect(growthMultiplier(Weather.storm), 0.5);
    });

    test('strict ordering storm < cloudy < sunny < rain', () {
      expect(growthMultiplier(Weather.storm),
          lessThan(growthMultiplier(Weather.cloudy)));
      expect(growthMultiplier(Weather.cloudy),
          lessThan(growthMultiplier(Weather.sunny)));
      expect(growthMultiplier(Weather.sunny),
          lessThan(growthMultiplier(Weather.rain)));
    });
  });

  group('yieldMultiplier (spec-18)', () {
    test('sunny is best, storm worst', () {
      expect(yieldMultiplier(Weather.sunny), 1.1);
      expect(yieldMultiplier(Weather.rain), 1.05);
      expect(yieldMultiplier(Weather.cloudy), 1.0);
      expect(yieldMultiplier(Weather.storm), 0.7);
    });
  });

  group('describePlantImpact + describeEtfImpact', () {
    test('sunny mentions +20%', () {
      expect(describePlantImpact(Weather.sunny), contains('+20%'));
    });
    test('rain mentions +30%', () {
      expect(describePlantImpact(Weather.rain), contains('+30%'));
    });
    test('storm warns plant impact', () {
      expect(describePlantImpact(Weather.storm).toLowerCase(),
          contains('sturm'));
    });
    test('every weather has a non-empty etf impact', () {
      for (final w in Weather.values) {
        expect(describeEtfImpact(w), isNotEmpty);
      }
    });
  });

  group('weatherLabel + weatherEmoji', () {
    test('all four kinds have distinct labels', () {
      final labels = Weather.values.map(weatherLabel).toSet();
      expect(labels.length, 4);
    });
    test('all four kinds have distinct emoji', () {
      final emoji = Weather.values.map(weatherEmoji).toSet();
      expect(emoji.length, 4);
    });
  });
}
