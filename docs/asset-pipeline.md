# Asset-Pipeline — FINANZGAME

## Lizenz-Disziplin

**Jedes Asset wird in `ASSETS.md` (Repo-Root) gelistet mit: Pfad + Quelle + Lizenz + Datum.** Claude Code pflegt das beim Adden mit (via CLAUDE.md-Verweis).

## Quellen-Hierarchie

1. **Kenney.nl** — CC0 / Public Domain. Selbst kommerziell ohne Attribution erlaubt. **Erste Wahl.**
   - Asset-Packs auf kenney.nl/assets
   - Relevant: 1-bit-pack, Tiny-Town, Tiny-Dungeon, UI-Pack, Audio-Pack
2. **OpenGameArt.org** — gemischt (CC0, CC-BY, CC-BY-SA, GPL). **Pro Asset prüfen.** CC-BY-SA = Copyleft, im Privatprojekt OK, bei Veröffentlichung beachten.
3. **itch.io Asset-Packs** — Lizenz pro Pack lesen, meist „commercial OK, no redistribution".
4. **Eigenes Pixeln** in Aseprite/Pixelorama — für Schlüssel-Assets (Avatare, NPC-Portraits, Insel-Highlights).
5. **Retro Diffusion** — nur als **Inspiration**, nicht als End-Asset. EULA-ambig.

## Tooling

| Zweck | Tool | Lizenz/Preis |
|---|---|---|
| Pixel-Art-Editor | **Aseprite** | $19,99 Steam einmalig |
| Alternative gratis | **Pixelorama** | OSS, MIT |
| Alternative gratis | **LibreSprite** | OSS, GPL |
| Tilemaps | **Tiled** | OSS, GPL |
| Flutter-Tiled-Integration | `flame_tiled` | OSS |
| SFX-Generator | **Bfxr / jsfxr** | Free, Output CC0 |
| Musik | **BeepBox** (free), **LMMS** (GPL) | OSS |
| Musik fertig | Kevin MacLeod, OpenGameArt | CC-BY meist |

## Fonts

- **m6x11** (Daniel Linssen) — frei für kommerzielle Nutzung, Pixel-Look
- **PixelOperator** (Jayvee Enaguas) — CC0

Beide aus dem Web als `.ttf` holen, in `assets/fonts/` ablegen, in `pubspec.yaml` registrieren.

## Auflösung & Stil

- **Tiles:** 32×32
- **Charaktere:** 48×64 oder 32×48
- **Palette:** max. 32 Farben, Lospec.com als Referenz
- **Stil-Referenzen:** Sea of Stars, Eastward, Owlboy, Stardew, CrossCode

## Pipeline-Workflow

1. Asset in Aseprite/Pixelorama erstellen ODER von Kenney/OpenGameArt importieren
2. Export als PNG (Sprite-Sheet wenn animiert)
3. Ablegen in `assets/images/<feature>/<name>.png`
4. In `pubspec.yaml` unter `flutter:` registrieren (Folder reicht meist)
5. In `ASSETS.md` Eintrag hinzufügen: Pfad, Quelle, Lizenz, Datum
6. Bei Sprites: `Sprite` / `SpriteSheet` aus Flame oder `Image.asset` aus Flutter

## ASSETS.md Format

```markdown
# Asset-Inventar

## images/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| images/phone/icon_bank.png | Eigenes (Aseprite) | © User | 2026-05-17 |
| images/tiles/grass_01.png | Kenney 1-bit-pack | CC0 | 2026-05-17 |
| images/npc/opa_walter.png | Eigenes (Aseprite) | © User | 2026-05-20 |

## fonts/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| fonts/m6x11.ttf | Daniel Linssen | Free commercial | 2026-05-17 |

## sfx/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| sfx/coin.wav | Bfxr generated | CC0 | 2026-05-17 |

## music/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| music/daytime_loop.ogg | Kevin MacLeod „Carefree" | CC-BY 4.0 | 2026-05-17 |
```

## Faustregel für Hobby-Phase

- **Phase 1 + 2 (Sprint 1-7):** Kenney-Assets + ein paar eigene Hero-Sprites (Avatar, Hauptcharaktere)
- **Phase 3+:** Eigene Insel-Maps in Tiled, eigene NPC-Portraits, eigene Custom-Tiles
- **Bei Store-Release:** ASSETS.md komplett review, Retro-Diffusion-EULA mit Astropulse klären falls verwendet

## Anti-Patterns

- Asset ohne ASSETS.md-Eintrag committen ❌
- CC-BY-SA-Asset ohne Awareness mischen ❌
- Generic AI-Art ohne klare Lizenz ❌
- YouTube-Music-Library-Tracks (NICHT für App-Embedding lizenziert) ❌
