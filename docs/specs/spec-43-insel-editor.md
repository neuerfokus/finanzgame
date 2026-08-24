# Spec-43 — Insel-Editor (Möbel/Deko platzieren)

**Status:** Draft 2026-05-22
**Voraussetzung:** spec-29 furniture-shop, spec-37 iso-tiles, spec-41 avatar-shop

## Ziel

Spieler kann pro Insel Deko-Objekte platzieren. Persistenter Customisation-Layer
über Composite-PNG-Inseln. Belohnt Sammeln + Erfolg, kein Sim-Effekt.

## Scope

**In:**
- Tap auf Insel-Marker (Long-Press oder zweiter Tap) öffnet `IslandEditorPage`.
- Eigener Decor-Katalog: 12 CC0-Items (Palme, Bank, Lampe, Brunnen, Statue,
  Zaun, Fass, Truhe, Blumentopf, Steinhaufen, Fackel, Wegweiser). XP-Kauf wie
  Avatar-Shop (50–500 XP), ein Kauf = unbegrenzt platzierbar.
- Free-Placement auf Insel-Bounds (kein Grid). Drag-to-move, Tap-to-rotate
  (4× 90°), Long-Press → Entfernen-Dialog.
- Max 8 Decor-Slots pro Insel (Performance + Komposition).
- Render-Layer auf Karten-Marker (klein, gestapelt) + voll auf `IslandEditorPage`.
- Drift-Tabelle `island_decor` (schemaVersion 11): islandId, decorId, x (0..1), y (0..1), rotation, slot.

**Out:**
- Möbel aus Zimmer-Shop (das ist Indoor-Wall, bleibt getrennt).
- Animationen (statische Sprites).
- Multi-Layer/Z-Ordering jenseits y-Sort.
- Teilen/Export.

## Architektur

```
lib/features/island_editor/
  decor_catalog.dart        const list IslandDecorCatalogEntry
  decor_repository.dart     riverpod, lädt + persistiert
  island_editor_page.dart   Editor-UI (FullscreenDialog)
  decor_layer.dart          Wiederverwendbar in Karte (mini) + Editor (full)
lib/data/db/tables/
  island_decor_table.dart   Drift table
```

## Datenmodell

```dart
@freezed
abstract class IslandDecorPlacement with _$IslandDecorPlacement {
  const factory IslandDecorPlacement({
    required IslandId islandId,
    required String decorId,
    required double x,         // 0..1 normalisiert
    required double y,         // 0..1 normalisiert
    required int rotation,     // 0..3 (×90°)
  }) = _IslandDecorPlacement;
}
```

XP-Käufe in `SettingsTable.unlockedDecor` als CSV (wie unlockedAvatars).
Platzierungen in `island_decor` Tabelle.

## Migration

DB schemaVersion 10 → 11, neue Tabelle, `unlockedDecor` Spalte in settings.

## UI-Flow

1. Karten-Page: Long-Press auf entsperrte Insel → IslandEditorPage.
2. Editor: Vollbild-Insel-Sprite groß, Bottom-Sheet mit gekauften Decor-Items
   als horizontale Carousel.
3. Tap auf Decor-Item → drop in Mitte, Drag zum Verschieben.
4. Tap auf platziertes Item → Rotate 90°. Long-Press → Entfernen.
5. "Speichern"-Button persistiert; Back ohne Speichern verwirft.
6. Karten-Marker zeigt erste 3 Decor-Items als Mini-Icons unten am Marker.

## Tests

- Unit `decor_repository_test.dart`: add/remove/list, max-8-cap, XP-Kauf.
- Widget `island_editor_page_test.dart`: drag+rotate+remove.
- Drift-Migration v10→v11.

## Open Questions

1. Decor-Sprites: Kenney Nature-Kit reicht? Oder Aseprite-Pixel?
2. Karten-Mini-Render: über Marker oder darunter?
3. Reset-Button für Insel?

## Pragmatic-Cuts wenn knapp

- Stage 1: nur Sparinsel (1 Insel) + 4 Decor-Items + Drift-Persist.
- Stage 2: alle 9 Inseln + 12 Items + Rotation.
- Stage 3: Karten-Mini-Render.
