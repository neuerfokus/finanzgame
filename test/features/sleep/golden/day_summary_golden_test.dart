import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/day_summary.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/weather.dart';
import 'package:finanzgame/features/sleep/day_summary_screen.dart';

DaySummary _makeSummary(List<DayEvent> events, {int dayIndex = 4}) {
  return DaySummary(
    day: GameDay.fromIndex(dayIndex),
    events: events,
    cashBefore: Money.zero,
    cashAfter: Money.zero,
    savingsBefore: Money.zero,
    savingsAfter: Money.zero,
  );
}

Widget _wrap(DaySummary summary) => ProviderScope(
      child: MaterialApp(
        home: DaySummaryScreen(summary: summary, onContinue: () {}),
      ),
    );

void main() {
  setUpAll(() async => loadAppFonts());

  group('DaySummaryScreen goldens', () {
    testGoldens('day_summary_1_event', (tester) async {
      final summary = _makeSummary([
        DayEvent.allowance(amount: Money.euros(20)),
      ]);

      await tester.pumpWidgetBuilder(
        _wrap(summary),
        surfaceSize: const Size(390, 844),
      );
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'day_summary_1_event');
    });

    testGoldens('day_summary_4_events', (tester) async {
      final summary = _makeSummary([
        DayEvent.allowance(amount: Money.euros(20)),
        const DayEvent.interest(
          amount: Money.cents(15),
          accountId: 'sparkonto',
        ),
        const DayEvent.plantGrowth(plantId: 'Elefantenfuß', newStage: 2),
        const DayEvent.weather(islandId: 'Spar-Insel', kind: Weather.sunny),
      ]);

      await tester.pumpWidgetBuilder(
        _wrap(summary),
        surfaceSize: const Size(390, 844),
      );
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'day_summary_4_events');
    });

    testGoldens('day_summary_10_events', (tester) async {
      final events = [
        DayEvent.allowance(amount: Money.euros(20)),
        const DayEvent.interest(
          amount: Money.cents(15),
          accountId: 'sparkonto',
        ),
        const DayEvent.plantGrowth(plantId: 'Elefantenfuß', newStage: 2),
        const DayEvent.weather(islandId: 'Spar-Insel', kind: Weather.sunny),
        DayEvent.birthday(giftAmount: Money.euros(50)),
        DayEvent.temptation(itemId: 'SnipeShot', price: Money.euros(120)),
        const DayEvent.plantReady(plantId: 'Karnickel-Pflanze'),
        DayEvent.harvest(
          plantId: 'Karnickel-Pflanze',
          harvestYield: Money.euros(8),
        ),
        const DayEvent.inflation(
          rate: 0.025,
          affectedItemIds: ['SnipeShot'],
        ),
        const DayEvent.weather(islandId: 'Vulkan-Insel', kind: Weather.storm),
      ];
      final summary = _makeSummary(events);

      await tester.pumpWidgetBuilder(
        _wrap(summary),
        surfaceSize: const Size(390, 844),
      );
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'day_summary_10_events');
    });
  });
}
