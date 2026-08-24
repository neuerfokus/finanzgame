import 'day_event.dart';
import 'game_day.dart';

/// Contract for objects that emit [DayEvent]s during a day advance.
///
/// Invariants:
/// - Implementations MUST be pure: given the same [GameDay], they return the
///   same events (modulo any injected repository state).
/// - Implementations MUST NOT mutate external state. Only [GameClock] commits
///   events after the full pipeline completes.
/// - Implementations MUST NOT call `DateTime.now()` or `Timer`. Time comes
///   exclusively from the [GameDay] parameter.
abstract interface class DayEventListener {
  /// Called by [GameClock] once per [GameClock.advanceDay] call.
  ///
  /// Returns the list of [DayEvent]s this listener wants to emit for [newDay].
  /// An empty list is valid (the listener may be a no-op for a given day).
  Future<List<DayEvent>> onDayAdvance(GameDay newDay);
}

/// Fixed ordering of listener stages in the day-advance pipeline.
///
/// DO NOT reorder without updating `spec-01-day-cycle.md`.
enum PipelineStage {
  allowance,
  interest,
  plant,
  inflation,
  weather,
  birthday,
  temptation,
}
