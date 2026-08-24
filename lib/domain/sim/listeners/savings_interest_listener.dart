import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Source the listener pulls the current savings balance from. Implemented
/// by `SavingsRepository` in the feature layer so the listener stays in
/// pure `domain/` (spec-21).
abstract class SavingsBalanceSource {
  /// Current savings balance in cents. 0 = empty (no interest accrues).
  int currentCents();

  /// Credit [amount] back to the savings balance.
  void creditInterest(Money amount);
}

/// Realistic savings interest (spec-26): 0.15 %/month ≈ 1.8 %/year.
///
/// Daily accrual = monthly / 30 = 0.005 %/day = 1/20000. Emits a single
/// [DayEvent.interest] when the rounded-down integer interest is at least
/// 1 cent. Smaller balances accrue 0 (avoids micro-cent spam); larger
/// balances see visible daily growth (1 000 € → ~5 ¢/day).
class SavingsInterestListener implements DayEventListener {
  const SavingsInterestListener(this._source);

  final SavingsBalanceSource _source;

  /// Account id for the emitted [DayEvent.interest].
  static const String accountId = 'savings';

  /// 0.005 % per day (= 0.15 % / month). Stored as numerator/denominator so
  /// the integer math is exact and we never touch doubles.
  static const int _rateNumerator = 1;
  static const int _rateDenominator = 20000;

  /// Display constants used by the bank UI (spec-26).
  static const double monthlyRatePct = 0.15;
  static const double yearlyRatePct = 1.8;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final balance = _source.currentCents();
    if (balance <= 0) return const [];
    final interestCents = (balance * _rateNumerator) ~/ _rateDenominator;
    if (interestCents <= 0) return const [];
    final amount = Money.cents(interestCents);
    _source.creditInterest(amount);
    return [DayEvent.interest(amount: amount, accountId: accountId)];
  }
}
