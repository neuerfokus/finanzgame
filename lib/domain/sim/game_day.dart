import 'package:freezed_annotation/freezed_annotation.dart';

import 'weekday.dart';

part 'game_day.freezed.dart';
part 'game_day.g.dart';

/// Immutable value object representing a single game day.
///
/// All derived fields (weekday, weekIndex, monthIndex, yearIndex) are computed
/// from [dayIndex] via [GameDay.fromIndex]. Phase-1 calendar:
/// - Week  = 7 days
/// - Month = 30 days  (no real calendar; normalises in Phase 4+)
/// - Year  = 365 days
///
/// Day 0 is always a Monday.
@freezed
abstract class GameDay with _$GameDay {
  const factory GameDay({
    /// 0-based day counter. 0 = first game day after onboarding.
    required int dayIndex,

    /// Day of the week derived from [dayIndex].
    required Weekday weekday,

    /// `dayIndex ~/ 7` — 0-based week counter.
    required int weekIndex,

    /// `dayIndex ~/ 30` — 0-based month counter.
    required int monthIndex,

    /// `dayIndex ~/ 365` — 0-based year counter.
    required int yearIndex,
  }) = _GameDay;

  factory GameDay.fromJson(Map<String, dynamic> json) =>
      _$GameDayFromJson(json);

  /// Derives all fields from [dayIndex].
  ///
  /// Invariant: `GameDay.fromIndex(0).weekday == Weekday.mon`.
  factory GameDay.fromIndex(int dayIndex) {
    final weekdayIndex = dayIndex % 7;
    return GameDay(
      dayIndex: dayIndex,
      weekday: Weekday.values[weekdayIndex],
      weekIndex: dayIndex ~/ 7,
      monthIndex: dayIndex ~/ 30,
      yearIndex: dayIndex ~/ 365,
    );
  }
}
