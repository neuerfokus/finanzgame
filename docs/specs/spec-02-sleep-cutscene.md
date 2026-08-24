# Spec 02 — Sleep Cutscene + Day Summary Screen

## Goal

Player-facing presentation of `GameClock.advanceDay()`. A "Schlafen"-Button triggers a fade-to-black cutscene with sunrise, then a Day-Summary screen reveals each event with staggered pop-in animation and sound. After dismiss → back to Phone-Springboard with updated Day-Counter.

## Why

Spec-01 gives us deterministic, batched events. Spec-02 makes them *felt*. Per Vlambeer ("Juice It Or Lose It") and Mark Brown ("Secrets of Game Feel"), economic events without anticipation + reveal are forgettable. Stardew Valley's sleep + summary screen is the gold-standard reference.

## Non-Goals

- Sound files (placeholder paths OK, real audio = Sprint 3+).
- Cutscene art (placeholder boxes/colors OK, real pixel art = Sprint 3+).
- Day-skip / multi-day advance (Sprint 6+).

## UI Flow

```
[Springboard with "Schlafen"-Button]
      │ tap
      ▼
[Black fade-in 800ms]
      │
      ▼
[Moon-pixel rotates 1200ms]  ← placeholder Container with rotation
      │
      ▼
[Sunrise gradient 800ms]
      │
      ▼
[Day Summary Screen]
  ┌────────────────────────────────┐
  │ Tag 5 — Dienstag               │
  │ ────────────────────────────── │
  │ + 20,00 €  Taschengeld         │  ← pop-in 0ms
  │ + 0,15 €   Zinsen Sparkonto    │  ← pop-in 60ms
  │ 🌱         Elefantenfuß +1 Stufe│  ← pop-in 120ms
  │ ☀️          Sonniges Wetter     │  ← pop-in 180ms
  │ ────────────────────────────── │
  │ [Weiter →]                     │
  └────────────────────────────────┘
      │ tap Weiter
      ▼
[Springboard, Day-Counter = "Tag 5"]
```

## Widgets

### `SleepCutsceneWidget`

```dart
class SleepCutsceneWidget extends StatefulWidget {
  const SleepCutsceneWidget({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;
  // Total duration: ~3s. State machine: fadeBlack → moon → sunrise → done.
}
```

Uses `flutter_animate` for chained tweens. SFX hooks at each phase (placeholder).

### `DaySummaryScreen`

```dart
class DaySummaryScreen extends StatelessWidget {
  const DaySummaryScreen({
    required this.summary,
    required this.onContinue,
    super.key,
  });

  final DaySummary summary;
  final VoidCallback onContinue;
}
```

Renders `summary.events` as list. Each row:

- `+ XX,XX €` label and amount for monetary events
- `🌱 / ☀️ / 🔥` icons for non-monetary
- Row colors: green for income, red for outflow, neutral for info
- pop-in animation: `.animate().fadeIn(duration: 250.ms, delay: (index * 60).ms).scale(begin: 0.8, end: 1.0, curve: Curves.easeOutBack)`

Header: "Tag N — Wochentag (Datum)" using `GameDay`.

Footer: "Weiter →" button (PixelButton style).

### `DayCounter` (HUD)

Small widget for Springboard top bar. Reads `gameClockProvider` and shows `"Tag ${day.dayIndex + 1}"`.

## Integration

`SchlafenButton` (in Springboard or Zimmer) ConsumerWidget:

```dart
onPressed: () async {
  final summary = await ref.read(gameClockProvider.notifier).advanceDay();
  if (!context.mounted) return;
  await Navigator.of(context).push(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => SleepFlow(summary: summary),
  ));
}
```

`SleepFlow` = stateful widget that runs `SleepCutsceneWidget`, then `DaySummaryScreen`, then pops.

## Tests

- `test/features/sleep/sleep_cutscene_widget_test.dart`: pump widget, assert fade-in opacity changes over time, assert `onComplete` fires after ~3s.
- `test/features/sleep/day_summary_screen_test.dart`: build with fake `DaySummary` containing 4 events, assert all 4 rows render, assert tapping "Weiter" fires `onContinue`.
- Golden test for `DaySummaryScreen` with 1, 4, and 10 events.

## Acceptance

- [x] Tapping "Schlafen" → cutscene plays → summary appears → tap "Weiter" → springboard with updated DayCounter
- [x] No timer-based logic; pure widget-state transitions
- [x] Pop-in animation: 60ms stagger per row
- [x] Sound stubs called at each cutscene phase (no real audio yet)
- [x] `flutter analyze --fatal-infos` clean
- [x] Widget + golden tests pass
- [x] Commit: `feat(sleep): add sleep cutscene + day summary screen`

## Done When

Player can press "Schlafen", see 3-sec cutscene, read accumulated events of the day, return to Springboard. No "+20€ aller paar Sekunden" anywhere.
