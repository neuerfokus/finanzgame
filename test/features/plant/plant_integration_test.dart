import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/plant/plant.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/plant/plant_repository.dart';
import 'package:finanzgame/features/xp/level_titles.dart';
import 'package:finanzgame/features/xp/xp_repository.dart';

/// Round 28: XP-Aktionen können Level-Ups auslösen, die Cash gutschreiben
/// (Level × 5 €). Aus der Formel berechnet, damit der Test robust gegen
/// XP-/Reward-Tuning bleibt.
int _levelUpCashBonus(int fromXp, int toXp) {
  var bonus = 0;
  for (var l = LevelSystem.levelFor(fromXp) + 1;
      l <= LevelSystem.levelFor(toXp);
      l++) {
    bonus += l * XpRepository.levelUpRewardCentsPerLevel;
  }
  return bonus;
}

void main() {
  test(
      'plant → 3x advanceDay → harvest credits 52¢, plant marked harvested',
      () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);

    final repo = c.read(plantRepositoryProvider.notifier);
    final clock = c.read(gameClockProvider.notifier);

    final cashBefore = c.read(cashStateProvider);
    final p = repo.plant(
      islandId: 'spar_insel',
      plotIndex: 0,
      kind: PlantKind.elephantsfoot,
      dayIndex: 0,
    );
    expect(c.read(cashStateProvider), cashBefore - const Money.cents(50));

    // 3 sleeps → stage 4, status ready.
    for (var i = 0; i < 3; i++) {
      await clock.advanceDay();
    }
    final ready = repo
        .getActive()
        .firstWhere((q) => q.id == p.id);
    expect(ready.status, PlantStatus.ready);
    expect(ready.currentStage, 4);

    final cashBeforeHarvest = c.read(cashStateProvider);
    final xpBeforeHarvest = c.read(xpRepositoryProvider);
    final result = repo.harvest(p.id);
    // Der Ertrag hängt am Wetter der Wachstumstage. Balance-Analyse 2026-08:
    // `rollWeather` teilt ein Jahresdeck aus, statt pro Tag unabhängig zu
    // würfeln (die alte Ziehung traf die geplanten 35/35/22/8 nicht) — auf
    // diesen Tagen liegt dadurch anderes Wetter, aus 52 ¢ werden 57 ¢.
    expect(result.yield_, const Money.cents(57));
    // harvest() vergibt XP + schaltet first_harvest frei → ggf. Level-Up
    // mit Cash-Bonus. Bonus aus der Formel, nicht hartcodiert.
    final bonus =
        _levelUpCashBonus(xpBeforeHarvest, c.read(xpRepositoryProvider));
    expect(
      c.read(cashStateProvider),
      cashBeforeHarvest + Money.cents(57 + bonus),
    );
  });
}
