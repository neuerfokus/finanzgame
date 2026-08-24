import 'dart:math';

import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Emits a [BirthdayEvent] once per year on the player's configured birthday.
///
/// Trigger: `dayIndex % 365 == birthdayDayIndex % 365`.
/// This means the event fires once every 365 days on the anniversary of the
/// configured birthday day, regardless of year.
///
/// Sprint 1 stub: [birthdayDayIndex] is injected via constructor.
/// Sprint 5 will read this from [PlayerRepository].
///
/// NO repository dependency in Sprint 1.
class BirthdayListener implements DayEventListener {
  const BirthdayListener({required this.birthdayDayIndex});

  /// The day-of-year on which the birthday gift fires (0-based, mod 365).
  final int birthdayDayIndex;

  /// Annual birthday gift (5000 cents = 50 €).
  static const Money giftAmount = Money.cents(5000);

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    // Use modular arithmetic so the event repeats every year.
    // birthdayDayIndex itself is never guaranteed to be < 365 in tests,
    // so we normalise both sides.
    final isBirthday =
        newDay.dayIndex % 365 == birthdayDayIndex % 365 &&
        newDay.dayIndex > 0;
    if (isBirthday) {
      return [const DayEvent.birthday(giftAmount: giftAmount)];
    }
    return const [];
  }
}

/// Marker so callers can opt into Random-seeding for testing.
///
/// Not used by [BirthdayListener] itself (deterministic trigger), but included
/// here as a shared utility for [TemptationListener].
Random seededRandom(int dayIndex, String salt) {
  // Mix dayIndex + salt hash into a single int seed.
  final saltHash = salt.codeUnits.fold(0, (prev, cu) => prev * 31 + cu);
  return Random(dayIndex ^ saltHash);
}
