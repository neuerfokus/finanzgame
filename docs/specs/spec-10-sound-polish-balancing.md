# Spec 10 — Sound + Game-Feel-Polish + Balancing

## Goal

Drei Polish-Achsen in einem Sprint:

1. **Sound** — SFX an Schlüssel-Interaktionen + Hintergrundmusik (loopbar,
   leise, pausierbar).
2. **Game-Feel** — Eruption-Cutscene auf Vulkan-Crash, Coin-Pop-Visual
   bei jeder Cash-Earn, Confetti bei Quest-Abschluss.
3. **Balancing** — Konstanten an einer Stelle (`GameBalance` static
   class) versammeln + Default-Werte nach erstem Spieltest mit Sohn
   anpassen (Allowance-Höhe, Plant-Yield, ETF-Drift, Crash-Prob).

## Why

App spielt funktional, fühlt sich aber zu still + zu generisch an.
Sound + Cutscene + visuelle Feedbacks heben Game-Feel auf "produktiv-
spielbar". Balancing-Sammelort macht spätere Tuning-Sessions
schnell.

## Non-Goals

- Voice-Acting (Hardregel, permanent out-of-scope)
- Eigene Komposition — Kevin MacLeod / BeepBox CC-BY only
- Adaptive Musik (Mood-Wechsel je Insel) — Sprint 11+
- Audio-Settings-UI (kommt mit Settings-Sprint)

## Sound-Architektur

```
lib/features/audio/
  sound_service.dart       # AudioPlayer wrapper + cache
  audio_keys.dart          # const SFX/music identifiers
assets/sfx/
  coin.wav                 # cash-earn pop
  harvest.wav              # plant harvest
  sleep_chime.wav          # sleep button
  crash_rumble.wav         # vulkan eruption
  ui_tap.wav               # generic tap
assets/music/
  monetaria_loop.ogg       # background loop
```

`SoundService` (Riverpod, keepAlive):
```dart
Future<void> playSfx(AudioKey key);
Future<void> startMusic();
Future<void> stopMusic();
bool muted;   // global toggle, default false
```

Uses `audioplayers ^6.x` package (add to pubspec).

Hook-Points:
- `CashState.earn` → `coin.wav`
- `PlantPlot.playHarvestJuice` → `harvest.wav`
- `SchlafenButton` press → `sleep_chime.wav`
- `CrashListener` returns event → cutscene + `crash_rumble.wav`
- `PixelButton` onTap → `ui_tap.wav` (subtle, 0.3 volume)

## Game-Feel additions

**Eruption-Cutscene:** when `DaySummary.events` contains `CrashEvent`,
DaySummary opens with 800ms red-flash + screen-shake before showing
event list. Reuse `flutter_animate`. Existing fadeBlack/fadeIn cutscene
sequencing in `sleep_flow.dart`.

**CoinPop:** `MoneyHeader` already animates +N. Generalise into a tiny
`CoinPopOverlay` widget so it fires anywhere — wishlist refund (none for
now), quest reward.

**Confetti:** at quest finish, push 24 particle dots from center of
`QuestRunnerPage` chat. New `lib/ui/widgets/confetti.dart` with
`flutter_animate` (no extra dep).

## GameBalance

```dart
abstract final class GameBalance {
  // Allowance
  static const Money weeklyAllowance = Money.cents(2000);

  // Plants
  static const Money plantElephantsfootCost = Money.cents(50);
  static const Money plantElephantsfootYield = Money.cents(52);
  static const int plantElephantsfootGrowDays = 3;

  // ETF
  static const double etfWeltKorbDrift = 0.0015;
  static const double etfTechKorbDrift = 0.0020;

  // Crash
  static const double crashProbabilityPerDay = 0.02;

  // Inflation
  static const double inflationDailyRate = 0.0008;
}
```

Sprint-10 Aufgabe: vorhandene Konstanten (heute in `PlantKinds`,
`EtfCatalog`, `InflationConfig`, `CrashListener.crashProbability`) auf
`GameBalance` umstellen oder von dort ableiten. **Behutsam** — keine
Werte-Änderungen ohne Begründung.

## Tests

- `SoundService.playSfx` mit FakeAudioPlayer → registers key
- `CoinPopOverlay` widget pump + animation completes
- Eruption-Cutscene widget test: rebuild with CrashEvent triggers red overlay
- Balance values match existing constants (no regression)

## Acceptance

- [ ] `audioplayers` in pubspec
- [ ] `SoundService` + AudioKey enum
- [ ] 5 SFX files in `assets/sfx/` (user beschafft oder generiert via Bfxr)
- [ ] 1 music loop in `assets/music/` (Kevin MacLeod oder BeepBox)
- [ ] `ASSETS.md` rows pro File
- [ ] SFX hooks an 5 Stellen verkabelt
- [ ] Eruption-Cutscene auf Crash-Day
- [ ] Confetti bei Quest-Finish
- [ ] `GameBalance` zentralisiert
- [ ] Tests grün, analyze clean
- [ ] Commit: `feat(polish): sound + cutscenes + balance constants`

## Done When

Schlafen-Tap macht Geräusch, Pflanzen-Ernte poppt mit Sound, Crash-Tag
beginnt mit rotem Flash + Rumble, Quest-Ende explodiert Confetti.
Alle Balancing-Konstanten an einer Stelle.

## Pending User-Action (vor Implementierung)

Audio-Files können nicht automatisiert beschafft werden. User lädt:
- 5 SFX (https://kenney.nl/assets/ui-audio oder selbst gebaut via Bfxr)
- 1 Loop-Music (https://incompetech.com Kevin MacLeod CC-BY)
- In `assets/sfx/` und `assets/music/` ablegen
- Pubspec-Glob existiert schon

Falls noch nicht da: `SoundService` läuft ohne Crash (no-op fallback),
Sprint trotzdem implementierbar.
