import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';
import 'day_event.dart';
import 'game_day.dart';
import 'game_day_json_converter.dart';

part 'day_summary.freezed.dart';
part 'day_summary.g.dart';

/// [JsonConverter] for `List<DayEvent>` to/from JSON.
class _DayEventListConverter
    implements JsonConverter<List<DayEvent>, List<dynamic>> {
  const _DayEventListConverter();

  @override
  List<DayEvent> fromJson(List<dynamic> json) =>
      json.map((e) => DayEvent.fromJson(e as Map<String, dynamic>)).toList();

  @override
  List<dynamic> toJson(List<DayEvent> events) =>
      events.map((e) => e.toJson()).toList();
}

/// Aggregate result of one [GameClock.advanceDay] call.
///
/// Contains the new game day, all events emitted by the pipeline, and balance
/// snapshots taken before and after event processing.
///
/// Note: In Sprint 1 all balance fields are [Money.zero] because account
/// repositories are not yet wired. Sprint 5 will populate them from Drift.
@freezed
abstract class DaySummary with _$DaySummary {
  const factory DaySummary({
    /// The day that was advanced to.
    @GameDayConverter() required GameDay day,

    /// All events emitted by the pipeline, in pipeline order.
    @_DayEventListConverter() required List<DayEvent> events,

    /// Cash balance before the day's events were applied.
    @MoneyConverter() required Money cashBefore,

    /// Cash balance after the day's events were applied.
    @MoneyConverter() required Money cashAfter,

    /// Savings balance before the day's events were applied.
    @MoneyConverter() required Money savingsBefore,

    /// Savings balance after the day's events were applied.
    @MoneyConverter() required Money savingsAfter,
  }) = _DaySummary;

  factory DaySummary.fromJson(Map<String, dynamic> json) =>
      _$DaySummaryFromJson(json);
}
