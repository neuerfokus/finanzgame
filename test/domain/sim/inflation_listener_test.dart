import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/inflation_listener.dart';
import 'package:finanzgame/domain/wishlist/wish_item.dart';

class _FakeSource implements WishlistInflationSource {
  _FakeSource(this.items);
  List<WishItem> items;
  int inflateCalls = 0;

  @override
  List<WishItem> active() => items;

  @override
  void inflate() {
    inflateCalls++;
    items = [
      for (final i in items)
        i.copyWith(
          currentPrice: Money.cents(
            (i.currentPrice.cents *
                    (1 + InflationConfig.dailyDriftFor(i.category)))
                .round(),
          ),
        ),
    ];
  }
}

WishItem _item(String id, WishCategory c, int cents) => WishItem(
      id: id,
      name: id,
      category: c,
      basePrice: Money.cents(cents),
      currentPrice: Money.cents(cents),
      emoji: '★',
    );

void main() {
  group('InflationListener', () {
    test('emits one InflationEvent with affected ids', () async {
      final src = _FakeSource([
        _item('a', WishCategory.sneaker, 1000),
        _item('b', WishCategory.snack, 500),
      ]);
      final listener = InflationListener(src);
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events.length, 1);
      final e = events.first as InflationEvent;
      expect(e.affectedItemIds, ['a', 'b']);
      expect(src.inflateCalls, 1);
    });

    test('skips inflate when no active items', () async {
      final src = _FakeSource([]);
      final listener = InflationListener(src);
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events, isEmpty);
      expect(src.inflateCalls, 0);
    });

    test('30 days lifts sneaker price (v29: realistic 2-3 %/J)', () async {
      final src = _FakeSource([
        _item('s', WishCategory.sneaker, 10000),
      ]);
      final listener = InflationListener(src);
      for (var d = 1; d <= 30; d++) {
        await listener.onDayAdvance(GameDay.fromIndex(d));
      }
      final price = src.items.first.currentPrice.cents;
      // v29: 2 %/J base + 1 %/J sneaker → +~0,25 % über 30 Tage
      // bei 10000 c = +~25 c. Lift muss messbar, aber nicht +3 %.
      expect(price, greaterThan(10000));
    });
  });
}
