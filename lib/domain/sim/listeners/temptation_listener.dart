import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import 'birthday_listener.dart' show seededRandom;

/// Emits a [TemptationEvent] with an 8 % daily probability.
///
/// Determinism: the [Random] source is seeded from `(dayIndex, "temptation")`
/// using [seededRandom], so results are fully reproducible for a given day
/// without any global mutable state.
///
/// Sprint 1 stub: hard-coded item id and price. Sprint 5 will pull the item
/// catalogue from a repository and rotate items.
///
/// NO repository dependency in Sprint 1.
class TemptationListener implements DayEventListener {
  const TemptationListener();

  /// 8 % chance per day.
  static const double _probability = 0.08;

  /// Fictional item id — never a real brand.
  static const String _itemId = 'snipeshot-sneaker';

  /// Price in cents (8000 = 80 €).
  static const Money _price = Money.cents(8000);

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final rng = seededRandom(newDay.dayIndex, 'temptation');
    if (rng.nextDouble() < _probability) {
      return [const DayEvent.temptation(itemId: _itemId, price: _price)];
    }
    return const [];
  }
}
