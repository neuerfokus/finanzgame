import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/features/sleep/day_counter.dart';

void main() {
  group('DayCounter', () {
    testWidgets('shows "Tag 1" on day index 0 (default)', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: DayCounter())),
        ),
      );

      expect(find.text('Tag 1'), findsOneWidget);
    });

    testWidgets('shows "Tag 6" when GameClock is at dayIndex 5', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameClockProvider.overrideWith(() => _FixedDayGameClock()),
          ],
          child: const MaterialApp(home: Scaffold(body: DayCounter())),
        ),
      );

      expect(find.text('Tag 6'), findsOneWidget);
    });

    testWidgets('updates when day advances', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: DayCounter())),
        ),
      );

      // Start at Tag 1.
      expect(find.text('Tag 1'), findsOneWidget);
    });
  });
}

/// A [GameClock] notifier that starts at dayIndex 5 for testing.
class _FixedDayGameClock extends GameClock {
  @override
  GameDay build() => GameDay.fromIndex(5);
}
