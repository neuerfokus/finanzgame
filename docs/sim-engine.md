# Sim-Engine — FINANZGAME

## Architecture

```
                ┌─────────────────────────┐
                │   GameClock (Riverpod)   │
                │   - dayIndex: int        │
                │   - advanceDay()         │
                └────────────┬─────────────┘
                             │ triggers
                             ▼
        ┌────────────────────────────────────────┐
        │  DayEventPipeline (fixed order)         │
        │  1. AllowanceListener                   │
        │  2. InterestListener                    │
        │  3. PlantGrowthListener                 │
        │  4. InflationListener                   │
        │  5. WeatherListener                     │
        │  6. BirthdayListener                    │
        │  7. TemptationListener                  │
        └────────────────────────────────────────┘
                             │
                             ▼
                  DaySummary(events: [...])
                             │
                             ▼
            UI: SleepCutscene → DaySummaryScreen
```

## Invariants

- **Deterministic**: given same input state + fixed seed, `advanceDay()` produces same events. Test-critical.
- **Pure**: listeners are pure functions of `(currentState, day) → events`. No Timer, no DateTime.now, no IO except injected repos.
- **Idempotent within a day**: calling `advanceDay()` twice never partially commits.
- **Order matters**: allowance comes before interest because allowance can affect savings balance same-day if user transferred. Lock the order.

## DayEventListener Contract

```dart
abstract interface class DayEventListener {
  /// Called by GameClock during advanceDay(). MUST be pure with respect to its
  /// injected dependencies. MAY read repos for state but MUST NOT mutate
  /// anything outside the returned events list.
  Future<List<DayEvent>> onDayAdvance(GameDay newDay);
}
```

State mutation happens after pipeline completion in `GameClock` itself:
```dart
final events = await _runPipeline(nextDay);
await _commitEvents(events);  // single atomic commit
state = nextDay;
return DaySummary(events: events, ...);
```

## Pipeline Stages

### 1. Allowance

Triggers: `weekday == Monday`.
Output: 1 `AllowanceEvent` with player-configured amount (default 10€).
Reads: `PlayerRepository.getAllowanceConfig()`.

### 2. Interest

Triggers: `dayIndex % 30 == 0` (every 30 days; or first-of-month if real calendar later).
Output: 1 `InterestEvent` per interest-bearing account. Amount = `balance * rate / 12`.
Reads: `AccountRepository.getInterestBearing()`.

### 3. PlantGrowth

Triggers: every day.
Output: 0..N `PlantGrowthEvent` for each plant that advances a stage, optional `HarvestEvent` if plant reaches maturity and auto-harvest is on.
Reads: `PlantRepository.getActive()`.

### 4. Inflation

Triggers: every day.
Output: 1 `InflationEvent` with `rate = 0.02 / 365` per day and list of affected item IDs whose price rises.
Reads: `WishlistRepository.getItems()`.

### 5. Weather

Triggers: every day, for each unlocked island.
Output: 1 `WeatherEvent` per island, sampling from per-island distribution.
Distributions:
  - Spar-Insel: 90% sunny, 10% rain, 0% storm
  - ETF-Insel (Mischwald): 60% sunny, 35% rain, 5% storm
  - Vulkan-Insel: 30% sunny, 40% rain, 30% storm

Random source: `Random(seed)` where seed derived from `(dayIndex, islandId)` for replayability.

### 6. Birthday

Triggers: `dayIndex == player.birthdayDayIndex` (configured once at onboarding).
Output: 1 `BirthdayEvent` with 50€ gift, once per year.

### 7. Temptation

Triggers: every day, 8% chance.
Output: 0..1 `TemptationEvent` surfacing a fictional consumer item (SnipeShot Sneaker, DropTok Premium, etc.).
Random source: `Random(seed)` from `(dayIndex, "temptation")`.

## Money in Cents

`Money` is `final class implements Comparable<Money>` storing `int cents`. Only place `double` is allowed:
- `Money.euros(double)` factory
- `interestRate` config (double)
- `Money.percent(double rate)` operator

All arithmetic in cents. Division rounds toward zero with explicit rounding mode.

JSON: `{ "cents": 1250 }` round-trips.

## Persistence

`DayEventLog` Drift table records all committed events for audit + retroactive Day-Summary if user skips.

Schema:
```dart
class DayEventLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dayIndex => integer()();
  TextColumn get kind => text()();          // 'allowance', 'interest', ...
  TextColumn get payloadJson => text()();   // serialized DayEvent
  DateTimeColumn get committedAt => dateTime()();
}
```

`PlayerState`:
```dart
class PlayerState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();  // singleton
  IntColumn get currentDayIndex => integer().withDefault(const Constant(0))();
  IntColumn get birthdayDayIndex => integer()();
  TextColumn get allowanceCents => text()();  // Money JSON
}
```

## Testing

Unit-Test pyramid:

- `GameDay.fromIndex` — boundary cases (year transition, leap, etc.)
- Each listener in isolation with mocked repos
- `GameClock.advanceDay` integration with fake listeners
- Determinism: same seed → same events
- Order: allowance always emits before interest (verify list index)
- Idempotency: failure mid-pipeline does NOT persist state change

Coverage target: ≥95% for `GameClock` + all listeners.

## Anti-Patterns (do NOT)

- `Timer.periodic` anywhere in `lib/core/` or `lib/domain/`
- `DateTime.now()` inside listener — always pass `GameDay`
- Mutate state inside listener — only emit events
- Side-effects (DB write, UI update) inside listener — pipeline commits atomically

## Migration from old project

Old `SimEngine.tick()` had similar shape but ran on a Timer. Salvage:
- `SimEvent` sealed union → port to `DayEvent`
- Allowance / Interest / Temptation logic → split into individual listeners
- Pure-Dart deterministic guarantee preserved
- Tests adapt: replace Timer-driven test setup with direct `advanceDay()` calls
