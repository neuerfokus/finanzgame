# Spec 29 — Zimmer-Shop + EXP-Level-System

## Goal

Zimmer einrichten mit Geld. EXP-System mit Stufen, Titeln, Rendite-Boost.

## Why

Sohn-Feedback: Zimmer langweilig, Trophäen ohne EXP-Nutzen, will Levelsystem.

## Non-Goals

- 3D-Zimmer
- Multiplayer-Show-off

## Tasks

### 1. Möbel-Shop

`zimmer/shop_page.dart` neu: vom Zimmer aus erreichbar via „Möbel kaufen"-Button.

Katalog `furniture_catalog.dart`:
```dart
sealed class FurnitureItem {
  String id; String name; Money price; FurnitureSlot slot;
  String spritePath;  // aus kenney_furniture-kit
  int expReward;
}
```

Slots: `bed`, `desk`, `chair`, `tech` (PC/TV), `decor`, `floor`.

Items aus `Zusätze/kenney_furniture-kit.zip`:
- Bett-Basic 50 €, Bett-Premium 200 €
- Schreibtisch 80 €, Schreibtisch-Premium 250 €
- Stuhl 30 €, Gaming-Stuhl 180 €
- PC 400 €, Laptop 600 €, TV 300 €
- Pflanze 15 €, Bild 25 €, Lampe 40 €

Pro Slot nur ein Item aktiv. Tausch verkauft alte zu 50 %.

### 2. Zimmer-Rendering

`zimmer_page.dart`: 2D-Top-Down oder Iso-Mini-Szene. Pragmatisch erstmal:
- PixelPanel mit Grid 3×3 Slots
- Pro Slot Sprite des gekauften Items oder „leer"
- Tap auf Slot → Shop scrollt zur Kategorie

Trophy-Wall bleibt separat.

### 3. EXP-System

`xp/xp_service.dart`:
- Quellen: Quest-Complete (50), Trophy-Unlock (100), Sleep-Day (10), gute Entscheidung (Buy ETF + halten 30 Tage = 80), Möbel-Kauf (item.expReward)
- DB-Spalte `currentXp IntColumn`, `currentLevel IntColumn` in Player-Table
- Level-Kurve: `xpForLevel(n) = 100 * n^1.5` (Level 1=100, 5=1118, 10=3162)
- Max Level 30

### 4. Level-Titel

Titel-Liste in `xp/level_titles.dart`:
| Lvl | Titel |
|-----|-------|
| 1 | Sparfuchs-Lehrling |
| 3 | Münzensammler |
| 5 | Taschengeld-Profi |
| 8 | Junior-Investor |
| 12 | ETF-Kenner |
| 16 | Diversifikations-Adept |
| 20 | Vermögens-Stratege |
| 25 | Marktkenner |
| 30 | Finanz-Großmeister |

UI: Statusbar zeigt aktuelles Level + Titel. Tap → Level-Detail-Page mit Progress-Bar + nächster Schwelle.

### 5. Rendite-Boost

Pro Level kleine Bonus:
- +0,5 % auf ETF-Erträge pro Level (cap 15 %)
- +1 € Taschengeld pro 5 Level
- Krypto-Boost nicht (zu broken)

Implementiert in `etf_engine.dart` als `multiplier = 1 + min(0.005 * level, 0.15)`.

### 6. Level-Up-Cutscene

Bei Level-Up: Confetti-Particle + Sound + neuer Titel-Card 2 sec. Riverpod-Event `levelUpStreamProvider`.

## Files

- `lib/data/db/tables.dart` — playerXp, playerLevel, furnitureOwned (m:n table)
- `lib/features/xp/xp_service.dart`, `xp/level_titles.dart`, `xp/xp_repository.dart`
- `lib/features/zimmer/shop_page.dart`, `zimmer/furniture_catalog.dart`, `zimmer/furniture_repository.dart`
- `lib/features/zimmer/zimmer_page.dart` — Slot-Grid
- `lib/ui/widgets/level_badge.dart`
- `lib/features/etf/etf_engine.dart` — multiplier
- `assets/images/furniture/*.png`
- Migration

## Tests

- xpForLevel(5) korrekt
- Level-Up triggert bei Cross-Schwelle
- Furniture-Slot replace verkauft alt
- ETF-Multiplier abhängig vom Level

## Acceptance

- [ ] Möbel-Shop mit Katalog
- [ ] Zimmer zeigt gekaufte Items
- [ ] EXP aus mehreren Quellen
- [ ] Level + Titel sichtbar
- [ ] Level-Up-Cutscene
- [ ] Rendite-Boost auf ETF
- [ ] Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(progression): furniture-shop + xp-levels + titles + rendite-boost`
