import 'package:finanzgame/domain/economy/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    // ── Constructors ─────────────────────────────────────────────────────────

    group('constructors', () {
      test('Money.zero has 0 cents', () {
        expect(Money.zero.cents, 0);
      });

      test('Money.cents stores exact value', () {
        expect(const Money.cents(1250).cents, 1250);
      });

      test('Money.euros rounds to nearest cent', () {
        expect(Money.euros(12.50).cents, 1250);
        expect(Money.euros(0.01).cents, 1);
        // 0.005 rounds to 1 cent (round-half-up)
        expect(Money.euros(0.005).cents, 1);
      });

      test('Money.euros with negative value', () {
        expect(Money.euros(-5.0).cents, -500);
      });

      test('Money.fromJson round-trips', () {
        const m = Money.cents(999);
        final json = m.toJson();
        expect(json, {'cents': 999});
        expect(Money.fromJson(json).cents, 999);
      });
    });

    // ── Arithmetic ───────────────────────────────────────────────────────────

    group('operator +', () {
      test('adds cents', () {
        final result =
            const Money.cents(100) + const Money.cents(50);
        expect(result.cents, 150);
      });

      test('adding zero returns same value', () {
        expect((const Money.cents(500) + Money.zero).cents, 500);
      });
    });

    group('operator -', () {
      test('subtracts cents', () {
        final result =
            const Money.cents(200) - const Money.cents(75);
        expect(result.cents, 125);
      });

      test('can go negative', () {
        final result =
            const Money.cents(10) - const Money.cents(20);
        expect(result.cents, -10);
      });
    });

    group('operator *', () {
      test('multiplies by integer', () {
        expect((const Money.cents(100) * 3).cents, 300);
      });

      test('multiply by zero yields zero', () {
        expect((const Money.cents(500) * 0).cents, 0);
      });

      test('multiply by 1 unchanged', () {
        expect((const Money.cents(500) * 1).cents, 500);
      });
    });

    group('percent', () {
      test('5% of 1000 cents = 50 cents', () {
        expect(const Money.cents(1000).percent(0.05).cents, 50);
      });

      test('result rounds to nearest cent', () {
        // 1 cent * 33.3% = 0.333 → rounds to 0
        expect(const Money.cents(1).percent(0.333).cents, 0);
        // 3 cents * 33.3% = 0.999 → rounds to 1
        expect(const Money.cents(3).percent(0.333).cents, 1);
      });

      test('100% returns same value', () {
        expect(const Money.cents(750).percent(1.0).cents, 750);
      });

      test('0% returns zero', () {
        expect(const Money.cents(750).percent(0.0).cents, 0);
      });
    });

    // ── Properties ───────────────────────────────────────────────────────────

    group('isZero / isPositive / isNegative', () {
      test('zero', () {
        expect(Money.zero.isZero, isTrue);
        expect(Money.zero.isPositive, isFalse);
        expect(Money.zero.isNegative, isFalse);
      });

      test('positive', () {
        expect(const Money.cents(1).isZero, isFalse);
        expect(const Money.cents(1).isPositive, isTrue);
        expect(const Money.cents(1).isNegative, isFalse);
      });

      test('negative', () {
        expect(const Money.cents(-1).isZero, isFalse);
        expect(const Money.cents(-1).isPositive, isFalse);
        expect(const Money.cents(-1).isNegative, isTrue);
      });
    });

    // ── Comparison ───────────────────────────────────────────────────────────

    group('comparison operators', () {
      const low = Money.cents(100);
      const high = Money.cents(200);

      test('< operator', () {
        expect(low < high, isTrue);
        expect(high < low, isFalse);
        expect(low < low, isFalse);
      });

      test('<= operator', () {
        expect(low <= high, isTrue);
        expect(low <= low, isTrue);
        expect(high <= low, isFalse);
      });

      test('> operator', () {
        expect(high > low, isTrue);
        expect(low > high, isFalse);
        expect(low > low, isFalse);
      });

      test('>= operator', () {
        expect(high >= low, isTrue);
        expect(low >= low, isTrue);
        expect(low >= high, isFalse);
      });

      test('compareTo', () {
        expect(low.compareTo(high), isNegative);
        expect(high.compareTo(low), isPositive);
        expect(low.compareTo(low), 0);
      });

      test('sort via Comparable', () {
        final list = [high, Money.zero, low];
        list.sort();
        expect(list.map((m) => m.cents).toList(), [0, 100, 200]);
      });
    });

    // ── Equality ─────────────────────────────────────────────────────────────

    group('equality and hashCode', () {
      test('equal values are equal', () {
        expect(const Money.cents(500), const Money.cents(500));
      });

      test('different values are not equal', () {
        expect(const Money.cents(500), isNot(const Money.cents(501)));
      });

      test('identical is equal', () {
        const m = Money.cents(100);
        // ignore: unrelated_type_equality_checks
        expect(m == m, isTrue);
      });

      test('hashCode consistent with equality', () {
        expect(
          const Money.cents(100).hashCode,
          const Money.cents(100).hashCode,
        );
      });
    });

    // ── Formatting ───────────────────────────────────────────────────────────

    group('formatEur', () {
      test('formats 1250 cents — contains "12,50" and "€"', () {
        final formatted = const Money.cents(1250).formatEur();
        expect(formatted, contains('12,50'));
        expect(formatted, contains('€'));
      });

      test('formats 0 cents — contains "0,00" and "€"', () {
        final formatted = Money.zero.formatEur();
        expect(formatted, contains('0,00'));
        expect(formatted, contains('€'));
      });

      test('toString delegates to formatEur — contains "1,00" and "€"', () {
        final str = const Money.cents(100).toString();
        expect(str, contains('1,00'));
        expect(str, contains('€'));
      });

      test('formatEur output consistent with itself', () {
        // Same Money always produces same string.
        const m = Money.cents(500);
        expect(m.formatEur(), m.formatEur());
      });
    });

    // ── JSON round-trip ──────────────────────────────────────────────────────

    group('JSON', () {
      test('toJson produces correct map', () {
        expect(const Money.cents(0).toJson(), {'cents': 0});
        expect(const Money.cents(-500).toJson(), {'cents': -500});
      });

      test('fromJson produces correct Money', () {
        expect(Money.fromJson({'cents': 2000}).cents, 2000);
        expect(Money.fromJson({'cents': 0}).cents, 0);
      });

      test('round-trip is identity', () {
        for (final cents in [0, 1, 100, 9999, -100]) {
          final m = Money.cents(cents);
          expect(Money.fromJson(m.toJson()), m);
        }
      });
    });
  });
}
