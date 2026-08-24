import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/highscore/realworld_benchmark.dart';

/// Spec-45 G2: Realwelt-Benchmark gegen DE-Vermögensverteilung.
void main() {
  test('Schulden = niedrigstes Perzentil', () {
    expect(RealworldBenchmark.percentileFor(-100000), 0);
    expect(RealworldBenchmark.labelFor(-100000),
        contains('roten Zahlen'));
  });

  test('0 € = schuldenfrei (10. Perzentil)', () {
    expect(RealworldBenchmark.percentileFor(0), 10);
  });

  test('Median DE bei 70.800 €', () {
    expect(RealworldBenchmark.percentileFor(7080000), 50);
    expect(RealworldBenchmark.percentileFor(7079999), 40);
  });

  test('Top 10 % bei 725.000 €', () {
    expect(RealworldBenchmark.percentileFor(72500000), 90);
  });

  test('Top 1 % bei 3,3 Mio €', () {
    expect(RealworldBenchmark.percentileFor(330000000), 99);
  });

  test('Über 10 Mio € = Top 0,1 % Marker', () {
    expect(RealworldBenchmark.percentileFor(1000000000), 999);
    expect(RealworldBenchmark.labelFor(1000000000),
        contains('0,1 %'));
  });

  test('Labels matchen Perzentile', () {
    expect(RealworldBenchmark.labelFor(7080000), contains('Median'));
    expect(RealworldBenchmark.labelFor(72500000), contains('Top 10'));
  });
}
