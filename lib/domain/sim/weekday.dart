/// Day of the week in game time.
///
/// Day 0 of the game is always [mon].
enum Weekday { mon, tue, wed, thu, fri, sat, sun }

/// German display names for [Weekday].
extension WeekdayDe on Weekday {
  /// Abbreviated German name, e.g. `'Mo'`.
  String get shortNameDe => switch (this) {
    .mon => 'Mo',
    .tue => 'Di',
    .wed => 'Mi',
    .thu => 'Do',
    .fri => 'Fr',
    .sat => 'Sa',
    .sun => 'So',
  };

  /// Full German name, e.g. `'Montag'`.
  String get fullNameDe => switch (this) {
    .mon => 'Montag',
    .tue => 'Dienstag',
    .wed => 'Mittwoch',
    .thu => 'Donnerstag',
    .fri => 'Freitag',
    .sat => 'Samstag',
    .sun => 'Sonntag',
  };
}
