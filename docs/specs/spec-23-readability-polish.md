# Spec 23 — Lesbarkeit + Karte-Polish + Musik-Lautstärke

## Goal

Sohn-Tag-2-Feedback abarbeiten:
1. Musik mit echtem Lautstärke-Slider, nicht nur on/off
2. Schrift gut lesbar (Font + Größe)
3. Karte ansehnlich (Sprites + Wasser)
4. Insel-Namen klar lesbar (Label-Box mit Kontrast)

## Why

„die Musik ist sehr nervig, die Schrift schlecht lesbar und die Karte
noch nicht schön und man kann auch keine Namen mehr sauber lesen."

## Non-Goals

- Komplette Pixel-Art-Stil-Überarbeitung
- Tiled-Map (kommt später, Mapping per Hand reicht jetzt)
- Animierte Wellen

## Tasks

### 1. Musik-Lautstärke-Slider

`SettingsTable`: Spalte `musicVolume IntColumn default 25` (0–100,
gespeichert als Integer-Prozent).

`SettingsRepository.setMusicVolume(int)` — schreibt durch +
`SoundService.instance.setMusicVolume(value / 100.0)`.

`SoundService` neues API:
```dart
void setMusicVolume(double v); // 0.0–1.0
```
Wirkt auf `_musicPlayer.setVolume()`. `muted` bleibt bestehen für SFX.

`SettingsPage`: Slider 0–100 mit Live-Preview. Standardwert 25%
(weniger nervig).

`AudioplayersSoundService` init lädt initialVolume aus Settings via
Provider — oder einfach: SoundService liest Settings beim ersten
`startMusic` einmal.

### 2. Schrift

Problem: `KenneyPixel.ttf` ist sehr schmal/dünn auf hochauflösenden
Phones. Alternativen aus dem bereits gedownloadeten Pack:
- `KenneyMini` — kleiner aber krisper
- `KenneyFutureNarrow` — sans-serif Pixel
- `KenneyHigh` — fett

Switch primary `pixelFamily` auf `'KenneyFuture'` (sans-serif, klarer
auf Phone). MoneyHeader bleibt KenneyPixel-Stil (für Pixel-Feel der
Zahlen). Body-Text wird `KenneyFuture`.

Erweitere `FgTypography`:
- `pixelFamily` für Zahlen/Header (KenneyPixel)
- `bodyFamily` für Fließtext + Buttons (KenneyFuture)

Größere Default-Größen:
- bodyM 14 → 16
- bodyL 16 → 18
- pixelLabel 12 → 14

Pubspec: `KenneyFuture.ttf` zu fonts hinzufügen.

### 3. Karte-Sprites

`MonetariaWorld`:
- Hintergrund: gekachelte `assets/images/islands/tile_water.png`
  (aus Pirate-Pack Wasser-Tile, neu kopieren)
- Pro Insel: `SpriteComponent` mit Pirate-Pack-Insel-Tile statt
  Polygon. Mapping je IslandForm:
  - heimathafen → grass-island-large.png + Haus-Sprite
  - spar_insel → small grass + tree
  - etf_insel → water + wave
  - inflation_atoll → sand-island + palm
  - aktien_archipel → rocky-island
  - vulkan → volcano-island
  - goldmine → rock-island
  - mischwald → forest-island

Da Pirate-Pack viele PNGs hat: copy ~10 relevante in
`assets/images/islands/` mit klaren Namen (`island_grass.png` etc),
referenzieren via `Sprite.load`.

### 4. Insel-Label-Lesbarkeit

`IslandMarker`: aktueller `TextComponent` mit Glyph + Label. Probleme:
- Label-Hintergrund fehlt
- Schrift verschwimmt mit Insel-Farbe

Fix:
- Label rendern als `TextComponent` mit `BoxBackground`: schwarz-50%
  hinter weißem Text, padding 4px, rounded corner.
- Glyph oben drauf, Label unten drunter
- Größere Schrift (18px Pixel)
- Drop-Shadow / Outline-Stil

In Flame: TextPaint mit `backgroundColor` + `border` via custom render.
Pragmatisch: 2 Components — Hintergrund-Rect + Text.

## Files

- `lib/data/db/tables.dart` — musicVolume column
- `lib/data/db/daos.dart`, `app_database_provider.dart` — wire
- `lib/features/settings/settings_repository.dart` — getter/setter
- `lib/features/settings/settings_page.dart` — Slider-Widget
- `lib/features/audio/sound_service.dart` — setMusicVolume API
- `lib/main.dart` — load volume from settings on boot
- `lib/core/design_tokens.dart` — bodyFamily, größere Sizes
- `pubspec.yaml` — KenneyFuture font asset
- `assets/fonts/KenneyFuture.ttf` (drop from kenney-fonts pack)
- `assets/images/islands/island_*.png` (copy from pirate-pack)
- `lib/game/monetaria/monetaria_world.dart` — water-tile background
- `lib/game/monetaria/components/island_marker.dart` — Sprite + Label-Box

## Tests

- Round-trip: musicVolume = 50 → reopen → 50
- Widget: Slider in SettingsPage ändert state
- Pure: SoundService.setMusicVolume clamping 0..1
- Goldens regen für IslandMarker + StatusBar

## Acceptance

- [ ] musicVolume in DB + UI-Slider, Default 25%
- [ ] SoundService respektiert Volume + Mute
- [ ] KenneyFuture als bodyFamily
- [ ] Sizes hochgesetzt
- [ ] Wasser-Tile als Karten-Background
- [ ] Insel-Sprites statt Polygone
- [ ] Label-Box mit Kontrast über Glyph
- [ ] 394 Tests + neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(polish): music volume + readable fonts + map sprites + island labels`

## Done When

Spieler startet App → Musik leise (25%) im Hintergrund. Slider in
Settings funktioniert. Schrift überall klar lesbar. Karte zeigt
Wasser + Insel-Sprites. Insel-Namen mit dunklem Hintergrund + heller
Schrift gut lesbar.
