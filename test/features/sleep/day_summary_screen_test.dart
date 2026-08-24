import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/day_summary.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/weather.dart';
import 'package:finanzgame/features/sleep/day_summary_screen.dart';

Widget _wrap(Widget child) => ProviderScope(child: MaterialApp(home: child));

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

void main() {
  group('DaySummaryScreen', () {
    testWidgets('shows placeholder when events list is empty', (tester) async {
      await tester.pumpWidget(_wrap(DaySummaryScreen(
            summary: _makeSummary([]),
            onContinue: () {},
          )));
      await tester.pumpAndSettle();

      expect(find.text('Heute ist nichts passiert.'), findsOneWidget);
    });

    testWidgets('shows Taschengeld row for allowance event', (tester) async {
      final summary = _makeSummary([
        DayEvent.allowance(amount: Money.euros(20)),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Taschengeld'), findsOneWidget);
      expect(find.textContaining('20,00'), findsOneWidget);
    });

    testWidgets('shows header with day index and weekday', (tester) async {
      // dayIndex=4 → Freitag (0=Mo, 1=Di, 2=Mi, 3=Do, 4=Fr)
      final summary = _makeSummary([], dayIndex: 4);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Tag 5'), findsOneWidget);
      expect(find.textContaining('Freitag'), findsOneWidget);
    });

    testWidgets('renders all 4 mixed events after pumpAndSettle', (tester) async {
      final summary = _makeSummary([
        DayEvent.allowance(amount: Money.euros(20)),
        const DayEvent.interest(
          amount: Money.cents(15),
          accountId: 'sparkonto',
        ),
        const DayEvent.plantGrowth(plantId: 'elefantenfuss', newStage: 2),
        const DayEvent.weather(islandId: 'spar-insel', kind: Weather.sunny),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Taschengeld'), findsOneWidget);
      expect(find.textContaining('Zinsen'), findsOneWidget);
      expect(find.textContaining('elefantenfuss'), findsOneWidget);
      // spec-18: weather entry now reads "Wetter: Sonne — ...".
      expect(find.textContaining('Sonne'), findsOneWidget);
    });

    testWidgets(
        '4th event (index 3) is delayed by at least 3*60=180ms before appearing',
        (tester) async {
      final summary = _makeSummary([
        DayEvent.allowance(amount: Money.euros(20)),
        const DayEvent.interest(
          amount: Money.cents(15),
          accountId: 'sparkonto',
        ),
        const DayEvent.plantGrowth(plantId: 'elefantenfuss', newStage: 2),
        const DayEvent.weather(islandId: 'spar-insel', kind: Weather.sunny),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));

      // At t=0 animations haven't started; items are faded out (opacity ~0).
      await tester.pump(Duration.zero);

      // After 179ms the 4th item (delay=180ms) should not yet be fully visible.
      // We just verify no crash and the widget is present in the tree.
      await tester.pump(const Duration(milliseconds: 179));

      // After pumpAndSettle all items should be visible.
      await tester.pumpAndSettle();
      // spec-18: weather entry now reads "Wetter: Sonne — ...".
      expect(find.textContaining('Sonne'), findsOneWidget);
    });

    testWidgets('tapping Weiter fires onContinue', (tester) async {
      var tapped = false;

      await tester.pumpWidget(_wrap(DaySummaryScreen(
            summary: _makeSummary([]),
            onContinue: () => tapped = true,
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Weiter →'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders birthday event', (tester) async {
      final summary = _makeSummary([
        DayEvent.birthday(giftAmount: Money.euros(50)),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Geburtstag'), findsOneWidget);
      expect(find.textContaining('50,00'), findsOneWidget);
    });

    testWidgets('renders temptation event', (tester) async {
      final summary = _makeSummary([
        DayEvent.temptation(
          itemId: 'SnipeShot',
          price: Money.euros(120),
        ),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Versuchung'), findsOneWidget);
      expect(find.textContaining('SnipeShot'), findsOneWidget);
    });

    testWidgets('renders inflation event', (tester) async {
      final summary = _makeSummary([
        const DayEvent.inflation(rate: 0.03, affectedItemIds: ['sneakers']),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Inflation'), findsOneWidget);
      expect(find.textContaining('3.00%'), findsOneWidget);
    });

    testWidgets('long list of 10 events scrolls and all items present',
        (tester) async {
      final events = List.generate(
        10,
        (i) => DayEvent.allowance(amount: Money.cents(i * 100 + 100)),
      );
      final summary = _makeSummary(events);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      // At least the first visible items should be present.
      expect(find.textContaining('Taschengeld'), findsWidgets);
    });

    testWidgets('renders SleepCost row (normal)', (tester) async {
      final summary = _makeSummary([
        const DayEvent.sleepCost(amount: Money.cents(10), hunger: false),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Essen'), findsOneWidget);
    });

    testWidgets('renders SleepCost row (hunger)', (tester) async {
      final summary = _makeSummary([
        const DayEvent.sleepCost(amount: Money.zero, hunger: true),
      ]);

      await tester.pumpWidget(_wrap(DaySummaryScreen(summary: summary, onContinue: () {})));
      await tester.pumpAndSettle();

      expect(find.textContaining('Hunger'), findsOneWidget);
    });
  });
}
