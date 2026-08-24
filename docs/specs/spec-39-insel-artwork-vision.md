# Spec 39 — Insel-Artwork-Vision

## Goal

Inseln als detaillierte 3D-Isometrie-Szenen wie im Referenzbild des Users
(2026-05-20). Pro Insel ein wiedererkennbares Mini-Diorama mit thematischen
Gebäuden, Vegetation, Charakteren.

## Why

Aktuell: einzelne Kenney-Iso-Sprites (`grass_small.png`, `house.png`,
`rock.png`, `water.png`, `tree.png`, `sand.png`) + Schatten. Reicht für
Orientierung, aber wirkt für 13-Jährige langweilig.

User-Vision (Referenzbild im Chat): jede Insel = mehrere komponierte
Sprites zu einer kleinen Szene:

| Insel | Soll-Komposition |
|-------|------------------|
| ETF-Insel | Glas-Hochhaus mit ETF-Logo + kleines Hafenboot + Bäume |
| Spar-Insel | Sparkassen-Gebäude + Sparschwein + Münzhaufen + Pflanzen-Beete |
| Vulkan-Insel | Vulkan mit Rauch + Lava + kleine Hütten am Fuß + Bitcoin-Münzen |
| Goldminen-Insel | Berg mit Förderturm + Loren + Goldhaufen |
| Heimathafen | Hafen mit Stegen + Frachtcontainer + Schiffe + Fachwerk-Häuser |
| Mischwald-Insel | Wald mit unterschiedlichen Baumarten + Pfad + Hütte |
| Aktien-Archipel | Börsen-Tempel + Säulen + DAX-Display + Bonsai |
| Immobilien-Insel | Häuser-Block + Mietshäuser + Strand |
| Inflations-Atoll | Brennende Stadt + Strudel + Inflations-Pfeil + Trümmer |

## Strategy

### Phase A — Composite Sprites (no AI)

Aus dem bestehenden `Zusätze/`-Ordner (50 Kenney-CC0-Packs) sprite-
Komponenten extrahieren:
- `kenney_isometric-buildings`: Hochhäuser, Wohnhäuser, Fabriken
- `kenney_fantasy-town-kit_2.0`: Fachwerk, Türme
- `kenney_castle-kit`: Säulen, Tempel-Strukturen
- `kenney_holiday-kit`: Boote, Container, Hafen-Elemente
- `kenney_nature-kit`: Bäume verschiedener Arten, Felsen, Pflanzen
- `kenney_vehicle-kit`, `kenney_emote-pack`, etc.

Pro Insel: 4–10 Komponenten in PNG-Komposition mergen (z. B. via Aseprite
oder GIMP), als ein einzelnes Insel-PNG ablegen unter
`assets/images/islands_composite/{islandId}.png`.

Größe: 256×256 oder 320×320 px, transparenter Hintergrund, isometrische
Perspektive 2:1.

### Phase B — Wiring in Flame

`IslandMarker._formSprite` → neue Map `IslandId → Composite-PNG`. Bei
fehlendem Composite-PNG fällt der Code auf Phase-A-Einzel-Sprites zurück
(graceful degradation für In-Progress-Inseln).

Diameter erhöhen von 96 → 160 px für die größeren Sprites.

### Phase C — Optional AI/Hand-Gen

Falls Composite-Workflow zu langsam: prompt-basierte Bild-Gen mit klarem
Kenney-Style-Prompt für jede Insel. Lizenz dann selbst-erzeugt
(CC0-äquivalent dokumentieren in `ASSETS.md`).

## Constraints

- Hardregel: keine echten Marken (kein „Apple", „Nike" auf Werbetafeln)
- CC0-only Sprites — keine kommerziellen Asset-Stores
- Insel-Komposit-PNGs MÜSSEN in `ASSETS.md` mit Quelle + Lizenz
- Max 320×320 px pro Insel (Flame-Render-Performance)

## Files

- `docs/specs/spec-39-insel-artwork-vision.md` (dieses Dokument)
- `assets/images/islands_composite/*.png` (neu, leer bei Spec-Anlage)
- `lib/game/monetaria/components/island_marker.dart` — Map erweitern
- `ASSETS.md` — Quellen + Lizenzen pro Composite

## Acceptance

- [ ] Mindestens 3 Inseln mit Composite-PNG (Heimathafen, Spar, ETF)
- [ ] IslandMarker rendert Composite wenn vorhanden, sonst Fallback
- [ ] Diameter auf 160 px hochgezogen ohne Map-Layout-Bruch
- [ ] ASSETS.md lückenlos pro Composite

## Stretch

- Alle 9 Inseln mit eigenem Composite
- Subtle parallax/animation pro Insel (Rauchsäule am Vulkan etc.)
- Boat-Sprite-Upgrade auf 3D-Iso-Schiff aus Kenney Pirate-Pack

## Schiff-Vision (User-Ref 2026-05-20)

Galeone „AURORA" — detaillierte 3D-Iso-Holz-Galeone mit 3 Masten, weißen
Segeln, Bug-Schriftzug, 3 Pirat-Charakteren an Bord (Steuermann, Kanonier,
Crew), Anker, Heck-Laterne, Kielwasser.

Realisierungs-Optionen:
1. Composite aus Kenney Pirate-Pack (Schiff-Hull, Masten, Segel, Crew-
   Sprites) — am Realistsichsten ohne externe Künstler.
2. Single-Sprite-PNG ca. 320×240 px, transparenter Hintergrund.
3. Animation: leichtes Up-Down-Bob via Flame `MoveByEffect` (kein neuer
   Sprite nötig, nur Position-Tween).

Datei: `assets/images/iso/boat_aurora.png`. Fallback bleibt aktuelles
`boat.png` falls Composite fehlt.
