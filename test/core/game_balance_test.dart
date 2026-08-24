import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_balance.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/etf/etf.dart';
import 'package:finanzgame/domain/plant/plant.dart';
import 'package:finanzgame/domain/stock/stock.dart';
import 'package:finanzgame/domain/wishlist/wish_item.dart';

void main() {
  group('GameBalance matches existing feature constants', () {
    test('plant elephantsfoot values', () {
      expect(GameBalance.plantElephantsfootCost,
          PlantKinds.elephantsfoot.cost);
      expect(GameBalance.plantElephantsfootYield,
          PlantKinds.elephantsfoot.yield_);
      expect(GameBalance.plantElephantsfootGrowDays,
          PlantKinds.elephantsfoot.growDays);
    });

    // Round 27 v8: Balance-CI-Guard. Hätte den Stock-Drift-Bug (+149 %/J)
    // vorher gefangen. Prüft, dass annualisierte Drifts + Volatilitäten
    // im realistischen Korridor bleiben.
    test('Balance-Guard: Aktien-Jahres-Drift realistisch (<25 %/J)', () {
      for (final s in StockCatalog.all) {
        final annual = math.exp(s.baseDriftPerDay * 365) - 1;
        expect(annual, lessThan(0.25),
            reason: '${s.name} driftet ${(annual * 100).toStringAsFixed(0)} %/J');
        expect(annual, greaterThan(-0.05), reason: s.name);
        // Tages-Vola im Rahmen (annualisiert < ~60 %).
        expect(s.volatility * math.sqrt(365), lessThan(0.65), reason: s.name);
      }
    });

    test('Balance-Guard: ETF-Volatilität realistisch (annual <50 %)', () {
      for (final e in EtfCatalog.all) {
        expect(e.volatility * math.sqrt(365), lessThan(0.50),
            reason: '${e.name} Vola annualisiert zu hoch');
      }
    });

    test('stock drifts', () {
      expect(GameBalance.stockFluxonDrift,
          StockCatalog.fluxon.baseDriftPerDay);
      expect(GameBalance.stockSkyrailDrift,
          StockCatalog.skyrail.baseDriftPerDay);
      expect(GameBalance.stockNovabankDrift,
          StockCatalog.novabank.baseDriftPerDay);
    });

    test('inflation', () {
      expect(GameBalance.inflationDailyRate, InflationConfig.dailyRate);
    });

    test('weekly allowance is positive money', () {
      expect(GameBalance.weeklyAllowance, isA<Money>());
      expect(GameBalance.weeklyAllowance.isPositive, isTrue);
    });

    test('Round 28 v4: Snack-Kosten steigen mit Level', () {
      // Level 0 = Basis (unverändert → fresh-game-Tests bleiben grün).
      expect(GameBalance.sleepCostCentsFor(0), GameBalance.sleepCostCents);
      expect(GameBalance.sleepCostCentsFor(10),
          GameBalance.sleepCostCents + 10 * GameBalance.sleepCostPerLevelCents);
      expect(GameBalance.sleepCostCentsFor(60),
          greaterThan(GameBalance.sleepCostCentsFor(10)));
      // Negatives Level abgefangen.
      expect(GameBalance.sleepCostCentsFor(-5), GameBalance.sleepCostCents);
    });
  });
}
