# Spec 03 — Pixel-UI-Pass für Phone-Springboard

## Goal

Ersetze generische Material-Default-UI im Phone-Springboard durch Pixel-Art-Look mit m6x11-Font, Kenney-Tile-UI-Pack und flutter_animate-Tweens auf Buttons.

## Why

Aktuelle UI sieht generisch aus. Spec-02 löst Game-Feel via Cutscene, aber Springboard-Chrome bleibt unattraktiv. Pixel-Konsistenz von Anfang an wichtig — sonst Bruch zwischen Phone-UI und Flame-Monetaria-Hub.

## Non-Goals

- Eigene Pixel-Art-Assets (nur Kenney + Font)
- Sound (Sprint 9)
- Echte Insel-Visuals (Sprint 4 = Flame-Hub)

## Inputs

- **Font:** `m6x11.ttf` von Daniel Linssen → `assets/fonts/m6x11.ttf`
- **UI-Pack:** Kenney UI-Pack auf kenney.nl → unzip Tiles relevant für Buttons, Panels, Icons → `assets/images/ui/`
- Eintrag in `ASSETS.md` für beide

## Components zu refactorn

1. **PixelButton** — Container mit Border + Shadow, m6x11-Label, easeOutBack-Press-Animation (100ms scale 1.0→0.95→1.0)
2. **PixelPanel** — Hintergrund-Panel mit gepixelter Border
3. **AppIcon** — bereits 56x56 Tile mit Border + Shadow, Pixel-Style — Polish nur Font + Tap-Animation
4. **MoneyHeader** — m6x11 für Beträge, fontSize-Token (display 28, label 14)
5. **StatusBar** — 8-bit-Time-Display
6. **HomeBar** — Pixel-Glyphs ◀ ● ▣ schon vorhanden, jetzt mit m6x11-Style

## Design-Tokens-Update

```dart
abstract final class FgTypography {
  static const String pixelFamily = 'm6x11';

  static const display = TextStyle(fontFamily: pixelFamily, fontSize: 24, color: FgColors.primary, height: 1.1);
  static const displayLarge = TextStyle(fontFamily: pixelFamily, fontSize: 40, color: FgColors.primary, height: 1.0);
  static const pixelLabel = TextStyle(fontFamily: pixelFamily, fontSize: 12, color: FgColors.onSurface, height: 1.2);
  static const bodyL = TextStyle(fontFamily: pixelFamily, fontSize: 16, color: FgColors.onSurface, height: 1.35);
  static const bodyM = TextStyle(fontFamily: pixelFamily, fontSize: 14, color: FgColors.onSurface, height: 1.35);
  static const bodyS = TextStyle(fontFamily: pixelFamily, fontSize: 12, color: FgColors.neutral, height: 1.3);
}
```

## flutter_animate-Patterns

```dart
PixelButton(
  label: 'Schlafen',
  onPressed: ...,
).animate(target: _pressed ? 1.0 : 0.0)
  .scale(begin: const Offset(1.0, 1.0), end: const Offset(0.95, 0.95), duration: 100.ms, curve: Curves.easeOutBack);
```

Auf jeden Tap: 100ms-Scale + leichtes ColorTween (primary → primary.darken(10%)).

## Golden Tests

```dart
testGoldens('PixelButton renders with pixel font', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: PixelButton(label: 'Test', onPressed: () {}))));
  await screenMatchesGolden(tester, 'pixel_button');
});
```

Für PixelButton, AppIcon, MoneyHeader, StatusBar, HomeBar.

## pubspec.yaml-Block

```yaml
dependencies:
  flutter_animate: ^4.5.0
  # ... existing deps
dev_dependencies:
  golden_toolkit: ^0.15.0
  # ... existing deps
flutter:
  fonts:
    - family: m6x11
      fonts:
        - asset: assets/fonts/m6x11.ttf
  assets:
    - assets/images/ui/
```

## Acceptance

- [x] m6x11-Font global verwendet (alle FgTypography Styles)
- [x] PixelButton mit Tap-Animation
- [x] AppIcon mit Tap-Animation
- [x] flutter_animate als Dep
- [x] Mindestens 5 Golden-Tests (button, app_icon, money_header, status_bar, home_bar)
- [x] ASSETS.md aktualisiert mit Font + Kenney-UI-Pack-Einträgen
- [x] `flutter analyze --fatal-infos` clean
- [x] Commit: `feat(ui): pixel-ui pass with m6x11 font + Kenney UI + tap animations`

## Done When

Phone-Springboard sieht konsistent Pixel-Art aus, Buttons reagieren mit „pop", Font ist überall einheitlich m6x11.
