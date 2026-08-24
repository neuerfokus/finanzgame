import 'dart:math' as math;

import '../../domain/economy/money.dart';
import '../../domain/plant/plant.dart';
import '../../domain/wishlist/wish_item.dart';

/// spec-34: seed prices follow general inflation so investing early in
/// plants pays off vs. waiting. Compound the base [InflationConfig.dailyRate]
/// against the current day index.
class PlantPricing {
  const PlantPricing(this.dayIndex);

  final int dayIndex;

  /// Inflation-adjusted seed cost on the current day.
  Money costFor(PlantKindSpec spec) {
    final factor = math.pow(1 + InflationConfig.dailyRate, dayIndex);
    final cents = (spec.cost.cents * factor).round();
    return Money.cents(cents);
  }

  /// Inflation-adjusted yield. Same factor so the relative margin stays
  /// constant — early planting still doubles down on compounding cash.
  Money yieldFor(PlantKindSpec spec) {
    final factor = math.pow(1 + InflationConfig.dailyRate, dayIndex);
    final cents = (spec.yield_.cents * factor).round();
    return Money.cents(cents);
  }
}
