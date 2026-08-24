import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/weekday.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameDay.fromIndex', () {
    group('weekday derivation', () {
      test('day 0 is Monday', () {
        expect(GameDay.fromIndex(0).weekday, Weekday.mon);
      });

      test('day 1 is Tuesday', () {
        expect(GameDay.fromIndex(1).weekday, Weekday.tue);
      });

      test('day 6 is Sunday', () {
        expect(GameDay.fromIndex(6).weekday, Weekday.sun);
      });

      test('day 7 is Monday again', () {
        expect(GameDay.fromIndex(7).weekday, Weekday.mon);
      });

      test('day 13 is Sunday', () {
        expect(GameDay.fromIndex(13).weekday, Weekday.sun);
      });

      test('day 14 is Monday', () {
        expect(GameDay.fromIndex(14).weekday, Weekday.mon);
      });

      test('all seven days in order', () {
        final expected = [
          Weekday.mon,
          Weekday.tue,
          Weekday.wed,
          Weekday.thu,
          Weekday.fri,
          Weekday.sat,
          Weekday.sun,
        ];
        for (var i = 0; i < 7; i++) {
          expect(GameDay.fromIndex(i).weekday, expected[i]);
        }
      });
    });

    group('weekIndex', () {
      test('days 0-6 are week 0', () {
        for (var i = 0; i < 7; i++) {
          expect(GameDay.fromIndex(i).weekIndex, 0,
              reason: 'day $i should be week 0');
        }
      });

      test('days 7-13 are week 1', () {
        for (var i = 7; i < 14; i++) {
          expect(GameDay.fromIndex(i).weekIndex, 1,
              reason: 'day $i should be week 1');
        }
      });

      test('day 365 is week 52', () {
        expect(GameDay.fromIndex(365).weekIndex, 52);
      });
    });

    group('monthIndex', () {
      test('days 0-29 are month 0', () {
        for (var i = 0; i < 30; i++) {
          expect(GameDay.fromIndex(i).monthIndex, 0,
              reason: 'day $i should be month 0');
        }
      });

      test('day 30 is month 1', () {
        expect(GameDay.fromIndex(30).monthIndex, 1);
      });

      test('day 29 is still month 0', () {
        expect(GameDay.fromIndex(29).monthIndex, 0);
      });

      test('day 59 is month 1', () {
        expect(GameDay.fromIndex(59).monthIndex, 1);
      });

      test('day 60 is month 2', () {
        expect(GameDay.fromIndex(60).monthIndex, 2);
      });
    });

    group('yearIndex', () {
      test('days 0-364 are year 0', () {
        expect(GameDay.fromIndex(0).yearIndex, 0);
        expect(GameDay.fromIndex(364).yearIndex, 0);
      });

      test('day 365 is year 1', () {
        expect(GameDay.fromIndex(365).yearIndex, 1);
      });

      test('day 729 is year 1', () {
        expect(GameDay.fromIndex(729).yearIndex, 1);
      });

      test('day 730 is year 2', () {
        expect(GameDay.fromIndex(730).yearIndex, 2);
      });
    });

    group('dayIndex preserved', () {
      test('dayIndex matches input', () {
        for (final d in [0, 1, 7, 29, 30, 99, 100, 364, 365, 366]) {
          expect(GameDay.fromIndex(d).dayIndex, d,
              reason: 'dayIndex should be $d');
        }
      });
    });

    group('boundary cases', () {
      test('day 0 — all zeros', () {
        final day = GameDay.fromIndex(0);
        expect(day.dayIndex, 0);
        expect(day.weekday, Weekday.mon);
        expect(day.weekIndex, 0);
        expect(day.monthIndex, 0);
        expect(day.yearIndex, 0);
      });

      test('day 6 — end of first week', () {
        final day = GameDay.fromIndex(6);
        expect(day.weekday, Weekday.sun);
        expect(day.weekIndex, 0);
        expect(day.monthIndex, 0);
        expect(day.yearIndex, 0);
      });

      test('day 7 — start of second week', () {
        final day = GameDay.fromIndex(7);
        expect(day.weekday, Weekday.mon);
        expect(day.weekIndex, 1);
      });

      test('day 29 — last day of first month', () {
        final day = GameDay.fromIndex(29);
        expect(day.monthIndex, 0);
      });

      test('day 30 — first day of second month', () {
        final day = GameDay.fromIndex(30);
        expect(day.monthIndex, 1);
      });

      test('day 364 — last day of first year', () {
        final day = GameDay.fromIndex(364);
        expect(day.yearIndex, 0);
      });

      test('day 365 — first day of second year', () {
        final day = GameDay.fromIndex(365);
        expect(day.yearIndex, 1);
        expect(day.monthIndex, 12);
      });
    });

    group('JSON round-trip', () {
      test('serializes and deserializes', () {
        final day = GameDay.fromIndex(42);
        final json = day.toJson();
        final restored = GameDay.fromJson(json);
        expect(restored, day);
      });

      test('day 0 JSON round-trip', () {
        final day = GameDay.fromIndex(0);
        expect(GameDay.fromJson(day.toJson()), day);
      });
    });
  });
}
