import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Adapter — concrete impl in features/forest forwards to TreeRepository.
/// Keeps Listener in pure domain.
abstract class TreeIncomeSource {
  /// Bucht Holz-Income aller reifen Bäume + liefert Summe.
  Money collectDailyYield(int dayIndex);
}

/// Spec-45 H3: pro Tag Holz/Harz-Einnahmen aus reifen Bäumen.
/// Emittiert ein InterestEvent mit accountId='forest' damit der
/// DaySummary Empfang sichtbar macht.
class ForestListener implements DayEventListener {
  const ForestListener(this._source);

  final TreeIncomeSource _source;

  static const String accountId = 'forest';

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final amount = _source.collectDailyYield(newDay.dayIndex);
    if (amount.cents <= 0) return const [];
    return [DayEvent.interest(amount: amount, accountId: accountId)];
  }
}
