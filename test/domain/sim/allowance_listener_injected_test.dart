import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/allowance_listener.dart';
import 'package:finanzgame/domain/sim/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AllowanceListener (injected settings, spec-32 monthly)', () {
    test('respects the configured monthly amount on payday', () async {
      const listener = AllowanceListener(
        amount: Money.cents(3000),
        weekday: Weekday.mon,
      );
      // Day 0 = guard, no event.
      expect(await listener.onDayAdvance(GameDay.fromIndex(0)), isEmpty);
      // Day 30 = next payday (weekday=mon → offset 0).
      final events = await listener.onDayAdvance(GameDay.fromIndex(30));
      expect(events, hasLength(1));
      final e = events.first as AllowanceEvent;
      expect(e.amount.cents, 3000);
    });

    test('weekday offset shifts the monthly payday', () async {
      const listener = AllowanceListener(
        amount: Money.cents(500),
        weekday: Weekday.fri,
      );
      // weekday.index = 4 → fires when dayIndex % 30 == 4 (first hit
      // on day 4 since dayIndex>0 guard passes).
      expect(await listener.onDayAdvance(GameDay.fromIndex(4)), hasLength(1));
      expect(await listener.onDayAdvance(GameDay.fromIndex(34)), hasLength(1));
      expect(await listener.onDayAdvance(GameDay.fromIndex(64)), hasLength(1));
      // Other days within the cycle do not fire.
      expect(await listener.onDayAdvance(GameDay.fromIndex(5)), isEmpty);
    });
  });
}
