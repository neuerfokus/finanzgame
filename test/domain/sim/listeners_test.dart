import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/day_summary.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/weather.dart';
import 'package:finanzgame/domain/sim/listeners/allowance_listener.dart';
import 'package:finanzgame/domain/sim/listeners/birthday_listener.dart';
import 'package:finanzgame/domain/sim/listeners/inflation_listener.dart';
import 'package:finanzgame/domain/sim/listeners/interest_listener.dart';
import 'package:finanzgame/domain/sim/listeners/plant_listener.dart';
import 'package:finanzgame/domain/sim/listeners/temptation_listener.dart';
import 'package:finanzgame/domain/sim/listeners/weather_listener.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── AllowanceListener ─────────────────────────────────────────────────────

  group('AllowanceListener', () {
    const listener = AllowanceListener();

    // spec-32: monthly cadence — fires every 30 days, skipping day 0.
    test('emits allowance on first monthly payday (day 30)', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(30));
      expect(events, hasLength(1));
      expect(events.first, isA<AllowanceEvent>());
      final e = events.first as AllowanceEvent;
      expect(e.amount.cents, AllowanceListener.defaultAmount.cents);
    });

    test('emits allowance on second monthly payday (day 60)', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(60));
      expect(events, hasLength(1));
      expect(events.first, isA<AllowanceEvent>());
    });

    test('no event on day 0 (game-start guard)', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(0));
      expect(events, isEmpty);
    });

    test('no event on day 7 (weekly cadence is gone)', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(7));
      expect(events, isEmpty);
    });

    test('fires every 30 days', () async {
      for (var d = 0; d < 91; d++) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        if (d > 0 && d % 30 == 0) {
          expect(events, hasLength(1),
              reason: 'day $d should emit allowance');
        } else {
          expect(events, isEmpty,
              reason: 'day $d should not emit allowance');
        }
      }
    });
  });

  // ── InterestListener ──────────────────────────────────────────────────────

  group('InterestListener', () {
    const listener = InterestListener();

    test('no event on day 0', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(0));
      expect(events, isEmpty);
    });

    test('emits interest on day 30', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(30));
      expect(events, hasLength(1));
      expect(events.first, isA<InterestEvent>());
      final e = events.first as InterestEvent;
      expect(e.amount.cents, InterestListener.stubAmount.cents);
      expect(e.accountId, InterestListener.savingsAccountId);
    });

    test('emits interest on day 60', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(60));
      expect(events, hasLength(1));
    });

    test('emits interest on day 360', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(360));
      expect(events, hasLength(1));
    });

    test('no event on day 29', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(29));
      expect(events, isEmpty);
    });

    test('no event on day 31', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(31));
      expect(events, isEmpty);
    });

    test('fires every 30 days, skipping day 0', () async {
      for (var d = 0; d <= 90; d++) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        final expected = d > 0 && d % 30 == 0;
        expect(events.length, expected ? 1 : 0,
            reason: 'day $d: expected=$expected');
      }
    });
  });

  // ── BirthdayListener ──────────────────────────────────────────────────────

  group('BirthdayListener', () {
    const birthdayDay = 100;
    const listener = BirthdayListener(birthdayDayIndex: birthdayDay);

    test('no event on day 0 (birthday skipped on game start)', () async {
      // birthdayDayIndex=100, so day 0 is not birthday
      final events = await listener.onDayAdvance(GameDay.fromIndex(0));
      expect(events, isEmpty);
    });

    test('emits birthday on configured day', () async {
      final events =
          await listener.onDayAdvance(GameDay.fromIndex(birthdayDay));
      expect(events, hasLength(1));
      expect(events.first, isA<BirthdayEvent>());
      final e = events.first as BirthdayEvent;
      expect(e.giftAmount.cents, BirthdayListener.giftAmount.cents);
    });

    test('emits birthday again one year later (day 465 = 100 + 365)', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(465));
      expect(events, hasLength(1));
    });

    test('no event on day 99', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(99));
      expect(events, isEmpty);
    });

    test('no event on day 101', () async {
      final events = await listener.onDayAdvance(GameDay.fromIndex(101));
      expect(events, isEmpty);
    });

    test('birthday on day 0 does not fire (guard)', () async {
      // birthdayDayIndex=0 would match day 0 but the dayIndex > 0 guard
      // prevents double-firing on the very first day.
      const listenerDay0 = BirthdayListener(birthdayDayIndex: 0);
      final events = await listenerDay0.onDayAdvance(GameDay.fromIndex(0));
      expect(events, isEmpty);
    });

    test('birthday on day 0 fires on year anniversary (day 365)', () async {
      const listenerDay0 = BirthdayListener(birthdayDayIndex: 0);
      final events = await listenerDay0.onDayAdvance(GameDay.fromIndex(365));
      expect(events, hasLength(1));
    });
  });

  // ── TemptationListener ────────────────────────────────────────────────────

  group('TemptationListener', () {
    const listener = TemptationListener();

    test('is deterministic — same day always yields same result', () async {
      for (var d = 0; d < 50; d++) {
        final day = GameDay.fromIndex(d);
        final first = await listener.onDayAdvance(day);
        final second = await listener.onDayAdvance(day);
        expect(first.length, second.length,
            reason: 'day $d should be deterministic');
      }
    });

    test('emitted event is TemptationEvent with expected shape', () async {
      // Find a day that fires (scan forward since probability is 8%)
      List<DayEvent> events = [];
      int d = 0;
      while (events.isEmpty && d < 200) {
        events = await listener.onDayAdvance(GameDay.fromIndex(d));
        d++;
      }
      expect(events, hasLength(1));
      expect(events.first, isA<TemptationEvent>());
      final e = events.first as TemptationEvent;
      expect(e.itemId, 'snipeshot-sneaker');
      expect(e.price.cents, 8000);
    });

    test('approximately 8% fire rate over 1000 days', () async {
      var fired = 0;
      for (var d = 0; d < 1000; d++) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        fired += events.length;
      }
      // Expect roughly 80 ± 40 (generous range for deterministic seed)
      expect(fired, greaterThan(40));
      expect(fired, lessThan(160));
    });

    test('different days can yield different results', () async {
      var firing = <bool>[];
      // Use 50 days to ensure at least one fires (first fire on day 23 for
      // the deterministic 'temptation' seed) and at least one doesn't.
      for (var d = 0; d < 50; d++) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        firing.add(events.isNotEmpty);
      }
      expect(firing.any((f) => f), isTrue,
          reason: 'at least one day should fire over 50 days');
      expect(firing.any((f) => !f), isTrue,
          reason: 'at least one day should NOT fire');
    });
  });

  // ── Stub listeners emit nothing ───────────────────────────────────────────

  group('PlantListener (empty source)', () {
    test('emits nothing without plants', () async {
      const listener = PlantListener(
        emptyPlantGrowthSource,
        weatherFor: defaultWeatherFor,
      );
      for (var d in [0, 1, 7, 30, 100]) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        expect(events, isEmpty, reason: 'day $d');
      }
    });
  });

  group('InflationListener (empty source)', () {
    test('emits nothing without items', () async {
      const listener = InflationListener(emptyWishlistInflationSource);
      for (var d in [0, 1, 7, 30, 100]) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        expect(events, isEmpty, reason: 'day $d');
      }
    });
  });

  group('WeatherListener (deterministic)', () {
    test('emits one weather event per day, deterministic by dayIndex',
        () async {
      const listener = WeatherListener(emptyWeatherSource);
      for (var d in [0, 1, 7, 30, 100]) {
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        expect(events.length, 1, reason: 'day $d');
        expect(events.first, isA<WeatherEvent>());
      }
    });
  });

  // ── DayEvent JSON ─────────────────────────────────────────────────────────

  group('DayEvent JSON round-trip', () {
    test('AllowanceEvent', () {
      const event = DayEvent.allowance(amount: Money.cents(2000));
      final json = event.toJson();
      expect(json['type'], 'allowance');
      final restored = DayEvent.fromJson(json);
      expect(restored, event);
    });

    test('InterestEvent', () {
      const event = DayEvent.interest(
        amount: Money.cents(15),
        accountId: 'savings',
      );
      final json = event.toJson();
      expect(json['type'], 'interest');
      expect(DayEvent.fromJson(json), event);
    });

    test('BirthdayEvent', () {
      const event = DayEvent.birthday(giftAmount: Money.cents(5000));
      final json = event.toJson();
      expect(json['type'], 'birthday');
      expect(DayEvent.fromJson(json), event);
    });

    test('TemptationEvent', () {
      const event = DayEvent.temptation(
        itemId: 'snipeshot-sneaker',
        price: Money.cents(8000),
      );
      final json = event.toJson();
      expect(json['type'], 'temptation');
      expect(DayEvent.fromJson(json), event);
    });

    test('PlantGrowthEvent', () {
      const event = DayEvent.plantGrowth(plantId: 'plant-1', newStage: 2);
      final json = event.toJson();
      expect(json['type'], 'plantGrowth');
      expect(DayEvent.fromJson(json), event);
    });

    test('WeatherEvent', () {
      const event = DayEvent.weather(islandId: 'spar-insel', kind: Weather.sunny);
      final json = event.toJson();
      expect(json['type'], 'weather');
      expect(DayEvent.fromJson(json), event);
    });
  });

  // ── DaySummary JSON ───────────────────────────────────────────────────────

  group('DaySummary JSON round-trip', () {
    test('serializes and deserializes with events', () {
      final summary = DaySummary(
        day: GameDay.fromIndex(7),
        events: const [
          DayEvent.allowance(amount: Money.cents(2000)),
          DayEvent.interest(amount: Money.cents(15), accountId: 'savings'),
        ],
        cashBefore: Money.zero,
        cashAfter: const Money.cents(2000),
        savingsBefore: Money.zero,
        savingsAfter: const Money.cents(15),
      );

      final json = summary.toJson();
      final restored = DaySummary.fromJson(json);

      expect(restored.day.dayIndex, 7);
      expect(restored.events, hasLength(2));
      expect(restored.cashAfter.cents, 2000);
      expect(restored.savingsAfter.cents, 15);
    });

    test('empty events list round-trips', () {
      final summary = DaySummary(
        day: GameDay.fromIndex(0),
        events: const [],
        cashBefore: Money.zero,
        cashAfter: Money.zero,
        savingsBefore: Money.zero,
        savingsAfter: Money.zero,
      );

      expect(DaySummary.fromJson(summary.toJson()), summary);
    });
  });
}
