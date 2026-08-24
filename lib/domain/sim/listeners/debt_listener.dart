import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Source the debt listener pulls the current cash balance from.
abstract class CashBalanceSource {
  int currentCashCents();
}

/// spec-35 phase E: daily dispo interest on negative cash. 0.03 %/day
/// (~10 %/Jahr) — fühlt sich teuer an, soll Schulden-Konsequenz lehren.
class DebtListener implements DayEventListener {
  const DebtListener(this._source);

  final CashBalanceSource _source;

  /// 3 / 10 000 = 0.03 % per day.
  static const int _rateNum = 3;
  static const int _rateDen = 10000;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final cents = _source.currentCashCents();
    if (cents >= 0) return const [];
    // cents is negative — interest amount we OWE.
    final owedCents = (cents.abs() * _rateNum) ~/ _rateDen;
    if (owedCents <= 0) return const [];
    return [DayEvent.debtInterest(amount: Money.cents(owedCents))];
  }
}
