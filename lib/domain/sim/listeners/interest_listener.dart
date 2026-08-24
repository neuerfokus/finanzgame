import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Emits an [InterestEvent] on the first day of each 30-day month.
///
/// NICHT MEHR IN DER PIPELINE (Analyse-Runde 2026-08): Der Sprint-1-Stub
/// zahlte nichts aus — der Settlement-Loop im `GameClock` kennt keinen
/// `InterestEvent`-Fall — erzeugte in der Tageszusammenfassung aber eine
/// zweite, falsche „Zinsen +0,15 €"-Zeile neben dem echten Sparzins.
/// Produktiv zuständig ist allein der `SavingsInterestListener`.
///
/// Bleibt als schlanker Test-Double für die Interest-Stage bestehen.
///
/// Trigger: `dayIndex > 0 && dayIndex % 30 == 0`.
/// Skips day 0 to avoid crediting interest before the first full month.
///
/// NO repository dependency in Sprint 1.
class InterestListener implements DayEventListener {
  const InterestListener();

  /// Hard-coded interest credit for Sprint 1 testing (15 cents).
  static const Money stubAmount = Money.cents(15);

  /// Account to credit in Sprint 1.
  static const String savingsAccountId = 'savings';

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final isFirstOfMonth =
        newDay.dayIndex > 0 && newDay.dayIndex % 30 == 0;
    if (isFirstOfMonth) {
      return [
        const DayEvent.interest(
          amount: stubAmount,
          accountId: savingsAccountId,
        ),
      ];
    }
    return const [];
  }
}
