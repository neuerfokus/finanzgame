# Spec 28 — Iso-Inselkarte

## Goal

Monetaria-Karte ansehnlich + lesbar. Iso-Tiles statt flacher Polygone. Großes sichtbares Boot. Klare Labels. Zoomable.

## Why

Test-Feedback: Karte zu klein, Boot kaum erkennbar, Namen schlecht lesbar.

## Non-Goals

- Tiled-Editor-Pipeline (kommt später)
- Animierte Wellen mit Shader

## Tasks

### 1. Asset-Import

Aus `Zusätze/kenney_isometric-landscape.zip`:
- Wasser-Tile (grundfläche)
- Insel-Tiles unterschiedlicher Form (grass-small, grass-large, sand, rocky, snow, lava)
- Bäume, Häuser

Aus `Zusätze/kenney_isometric-roads-water.zip`:
- Wellen-Tiles, Pier
- Boot-Sprite (Top-Down Iso)

Aus `Zusätze/kenney_isometric-blocks.zip`:
- Volcano-Block
- Mine-Block

Extract relevante PNGs → `assets/images/iso/*.png`. ASSETS.md updaten.

Tilesize Standard 128×64 (Iso-Diamond). Pro Insel-Cluster 3-5 Tiles + 1 Landmark.

### 2. World-Layout

`MonetariaWorld` neu:
- `IsoMap`-Component zeichnet Wasser-Tile-Grid 16×16 als Background
- Pro Insel: `IslandCluster` — gruppiert Insel-Tiles + Landmark + Label
- Welt-Größe `2048×1280` (4× alte). Camera zoomable 0.5x..2.0x mit Pinch.

Insel-Positionen neu, größer auseinander:
- Heimathafen (Mitte-unten): grass-large + Haus
- Spar-Insel (Mitte-links): grass-small + Tresor-Sprite
- ETF-Insel (oben-rechts): water + Wellen + ETF-Flagge
- Inflation-Atoll (rechts): sand + Palme
- Aktien-Archipel (oben): mehrere kleine grass-Inseln
- Vulkan (oben-links): volcano-block
- Goldmine (unten-links): rocky + mine
- Krypto-Casino (unten-rechts): leuchtende Insel mit Würfel-Glyph

### 3. Boot

`Boat`-Component (`PositionComponent`, Sprite 64×32).
- Sichtbar permanent, parkt am Heimathafen
- Bei Tap auf Insel: animierte Fahrt (TweenAnimation Bezier-Pfad), kommt an, dann Insel-Page öffnen
- Trail-Foam-Effect optional

### 4. Insel-Labels

`IslandLabel`-Component:
- PixelPanel-Hintergrund schwarz 70 % alpha + 2 px goldener Rand
- Text KenneyFutureNarrow 20 px weiß
- Center oberhalb Insel-Cluster
- Drop-Shadow 2 px

Falls Insel locked → grau + Schloss-Icon vor Label.

### 5. Kamera + Pan

Camera follow disabled. User pant frei (Drag) + Pinch-Zoom.
Auto-Center auf Heimathafen beim Open.
Min-Zoom 0.4 (Übersicht), Max 1.5 (Detail).

### 6. Performance

Iso-Tiles statisch → `SpriteBatchComponent` oder `PictureRecorder` für Background-Layer. Repaint nur bei Zoom/Pan.

## Files

- `assets/images/iso/*.png` (~20 Sprites)
- `ASSETS.md` Quellen-Liste
- `lib/game/monetaria/iso_map.dart` (neu)
- `lib/game/monetaria/island_cluster.dart` (neu)
- `lib/game/monetaria/components/boat.dart` (neu)
- `lib/game/monetaria/components/island_label.dart` (neu)
- `lib/game/monetaria/monetaria_world.dart` — refactor
- `lib/game/monetaria/components/island_marker.dart` — entfernen oder als Polygon-Fallback behalten?
- `pubspec.yaml` — assets/images/iso/

## Tests

- IsoMap-Component lädt Sprites
- IslandLabel rendert mit Schloss bei locked
- Tap-Hitbox Insel triggert Boat-Animation
- Golden: World-Snapshot zoom 1.0

## Acceptance

- [ ] Iso-Tile-Karte sichtbar
- [ ] 8 Insel-Cluster
- [ ] Boot sichtbar, fährt zu getappter Insel
- [ ] Labels lesbar mit Hintergrund-Box
- [ ] Pinch-Zoom + Drag-Pan
- [ ] Performance ≥ 50 FPS auf Pixel-6-Emulator
- [ ] Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(map): iso landscape + boat animation + readable labels`
