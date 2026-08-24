# Spec 01 — Player-Initiated Day Cycle

## Goal

Replace any realtime tick with a deterministic, player-initiated `GameClock.advanceDay()` mechanism. Every economic event (allowance, interest, plant growth, inflation, weather roll) runs in a fixed, ordered pipeline triggered by `advanceDay()` — never by a timer.

## Why

The old project (`C:\Claude_Code_projects\Finanzgame`) had `SimController.startAutoTick()` running every second. Allowance + Temptation + birthday events fired continuously, causing the "+20€ aller paar Sekunden"-bug and zero perceived causality between player action and reward. Stardew Valley's loop solves this: player chooses when the day ends, all events batch into a Day-Summary reveal.

## Non-Goals

- No UI in this spec. Sleep cutscene + Day Summary screen = Spec 02.
- No Flame integration. Pure Dart + Riverpod.
- No persistence yet (Drift integration = later sprint).

## Domain Model

### `GameDay` value object

```dart
@freezed
abstract class GameDay with _$GameDay {
  const factory GameDay({
    required int dayIndex,        // 0-based: 0 = first day after onboarding
    required Weekday weekday,     // Mon..Sun
    required int weekIndex,       // dayIndex ~/ 7
    required int monthIndex,      // dayIndex ~/ 30
    required int yearIndex,       // dayIndex ~/ 365
  }) = _GameDay;
}

enum Weekday { mon, tue, wed, thu, fri, sat, sun }
```

`GameDay.fromIndex(int dayIndex)` factory derives all fields.

### `DayEvent` sealed union

```dart
@freezed
sealed class DayEvent with _$DayEvent {
  const factory DayEvent.allowance({required Money amount}) = AllowanceEvent;
  const factory DayEvent.interest({required Money amount, required String accountId}) = InterestEvent;
  const factory DayEvent.plantGrowth({required String plantId, required int newStage}) = PlantGrowthEvent;
  const factory DayEvent.harvest({required String plantId, required Money yield}) = HarvestEvent;
  const factory DayEvent.inflation({required double rate, required List<String> affectedItemIds}) = InflationEvent;
  const factory DayEvent.weather({required String islandId, required Weather kind}) = WeatherEvent;
  const factory DayEvent.birthday({required Money giftAmount}) = BirthdayEvent;
  const factory DayEvent.temptation({required String itemId, required Money price}) = TemptationEvent;
}

enum Weather { sunny, rain, storm }
```

### `DaySummary` aggregate

```dart
@freezed
abstract class DaySummary with _$DaySummary {
  const factory DaySummary({
    required GameDay day,
    required List<DayEvent> events,
    required Money cashBefore,
    required Money cashAfter,
    required Money savingsBefore,
    required Money savingsAfter,
  }) = _DaySummary;
}
```

## `GameClock` Riverpod Service

```dart
@Riverpod(keepAlive: true)
class GameClock extends _$GameClock {
  @override
  GameDay build() => const GameDay(dayIndex: 0, weekday: Weekday.mon, weekIndex: 0, monthIndex: 0, yearIndex: 0);

  Future<DaySummary> advanceDay() async {
    final currentDay = state;
    final nextDay = GameDay.fromIndex(currentDay.dayIndex + 1);
    final events = <DayEvent>[];

    // Fixed pipeline order — DO NOT change without spec update
    events.addAll(await _runListeners(_allowanceListeners, nextDay));
    events.addAll(await _runListeners(_interestListeners, nextDay));
    events.addAll(await _runListeners(_plantListeners, nextDay));
    events.addAll(await _runListeners(_inflationListeners, nextDay));
    events.addAll(await _runListeners(_weatherListeners, nextDay));
    events.addAll(await _runListeners(_birthdayListeners, nextDay));
    events.addAll(await _runListeners(_temptationListeners, nextDay));

    state = nextDay;
    return DaySummary(day: nextDay, events: events, /* balances */);
  }
}
```

`DayEventListener` interface:

```dart
abstract interface class DayEventListener {
  Future<List<DayEvent>> onDayAdvance(GameDay newDay);
}
```

Listeners registered via Riverpod (typed providers per stage). Each stage runs all its listeners in registration order.

## Pipeline Order (canonical)

1. **Allowance** — Monday only, configured per player
2. **Interest** — first of month, savings accounts: balance * rate/12
3. **Plant growth** — every day: each Plant.grow()
4. **Inflation** — every day: items += rate / 365
5. **Weather roll** — every day: per island, sample from weather distribution
6. **Birthday** — once per year on configured date: +50€
7. **Temptation** — 8% chance per day to surface a fictional consumer item

## Tests

`test/core/game_clock_test.dart`:

```dart
group('GameClock.advanceDay', () {
  test('advances dayIndex by 1', () async { ... });
  test('weekday rolls over Sunday → Monday', () async { ... });
  test('allowance fires on Monday only', () async { ... });
  test('interest fires only on first of month', () async { ... });
  test('deterministic with fixed seed: same listeners produce same events', () async { ... });
  test('listener order: allowance always before interest', () async { ... });
  test('birthday fires on configured date once per year', () async { ... });
  test('cash before vs after equals sum of monetary events', () async { ... });
});
```

Coverage target: 100% for `GameClock` + `GameDay.fromIndex`.

## Acceptance

- [x] `GameClock` provider exists with `advanceDay()` returning `DaySummary`
- [x] `GameDay`, `DayEvent`, `DaySummary` freezed types generated
- [x] At least 1 listener per pipeline stage as stub (allowance + interest implemented, rest interfaces only)
- [x] `flutter analyze --fatal-infos` clean
- [x] All `test/core/game_clock_test.dart` cases pass
- [x] **No `Timer.periodic` anywhere in `lib/core/`**
- [x] Commit: `feat(core): add GameClock with player-initiated day cycle`

## Done When

A second sprint can call `await ref.read(gameClockProvider.notifier).advanceDay()` and receive a `DaySummary` with deterministic events.
