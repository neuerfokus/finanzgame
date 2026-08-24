import '../../wishlist/wish_item.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Adapter so the listener stays in `domain/`. The feature side provides
/// the current active items and applies the per-item price bump.
abstract class WishlistInflationSource {
  /// Items still purchasable.
  List<WishItem> active();

  /// Apply per-category daily drift. Implementations must NOT touch owned
  /// items.
  void inflate();
}

/// Bumps each unowned wishlist item's price by its category drift and
/// emits exactly one [DayEvent.inflation] per day summarising the bump.
class InflationListener implements DayEventListener {
  const InflationListener(this._source);

  final WishlistInflationSource _source;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final affected = _source.active();
    if (affected.isEmpty) return const [];

    _source.inflate();

    final avg = affected
            .map((i) => InflationConfig.dailyDriftFor(i.category))
            .reduce((a, b) => a + b) /
        affected.length;

    return [
      DayEvent.inflation(
        rate: avg,
        affectedItemIds: affected.map((i) => i.id).toList(),
      ),
    ];
  }
}

class _EmptyWishlistInflationSource implements WishlistInflationSource {
  const _EmptyWishlistInflationSource();
  @override
  List<WishItem> active() => const [];
  @override
  void inflate() {}
}

const WishlistInflationSource emptyWishlistInflationSource =
    _EmptyWishlistInflationSource();
