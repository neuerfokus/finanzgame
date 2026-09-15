# Spec 19 — Zeitreise UX + Multi-Asset-Vergleich

## Goal

Zeitreise wird intuitiv und vergleicht mehrere Assets in einem Chart.

## Why

Test-Feedback: „Die Zeitreise ist schon ganz cool aber auch wenig
intuitiv, außerdem fehlt der Asset-Vergleich."

## Non-Goals

- Zoom/Pan-Gesten (überkomplex für Pixel-UI)
- Export / Share

## Tasks

### 1. Asset-Auswahl (Multi-Select)

Aktuell zeigt `ZeitreisePage` eine Line pro Asset oder ein Asset auf
einmal. Refactor:

- Oben: horizontale Chip-Liste aller verfügbaren Assets, jeweils mit
  Farb-Bullet. Tap toggled „in Chart anzeigen".
- Default-Auswahl: Cash + bis zu 2 weitere (z.B. spar-insel-yield
  totals, ETF-Wertindex).
- Max 4 Lines parallel (UI-Klarheit).

### 2. Chart-Klarheit

- Y-Achse: € statt rohe Cents. Format mit `intl.NumberFormat.currency`.
- X-Achse: Tagesnummer + Wochentag (jeder 7. Tag dick).
- Legende unter Chart: Farbe + Asset-Name + aktueller Wert + Δ vs.
  Start.
- Bei Crash-Tag: roter Vertikalstrich.

### 3. Tutorial-Tooltip (one-shot)

Beim ersten Öffnen (persistiert in `SettingsTable.zeitreiseTutorialSeen`):
Overlay mit kurzem Text „Tippe Asset-Chips um sie ein/auszublenden. Du
siehst, wie sich dein Geld über Zeit entwickelt." Tap dismissed +
persistiert.

### 4. Asset-Liste

- Cash (immer)
- Spar-Insel (Pflanzen + Ernten kumuliert)
- ETFs (alle aggregiert oder pro Ticker — start: aggregiert)
- Aktien (alle aggregiert)
- Wunschartikel-Inflation (Index)

Aggregations-Werte werden täglich in `HistoryRepository.recordToday()`
geschrieben — Tabelle `PriceHistoryTable` schon vorhanden (spec-12).
Erweitere `assetId`-Konvention: `cash`, `spar_yield`, `etf_index`,
`stock_index`, `wishlist_cpi`.

## Files

- `lib/features/history/zeitreise_page.dart` Refactor
- `lib/features/history/history_repository.dart` — record neue
  Aggregat-IDs
- `lib/data/db/tables.dart` — `zeitreiseTutorialSeen` in SettingsTable
- `lib/features/settings/settings_repository.dart` — Flag

## Tests

- Pure: Asset-Auswahl-Toggle State
- Widget: Chips togglen Line-Sichtbarkeit
- Widget: Tutorial erscheint nur 1×

## Acceptance

- [ ] Multi-Select via Chips
- [ ] Y-Achse in €
- [ ] Crash-Marker
- [ ] Tutorial-Overlay 1×
- [ ] 5 Asset-Linien-Quellen
- [ ] Bestehende Tests grün
- [ ] Neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(zeitreise): multi-asset compare + tutorial`

## Done When

Testspieler öffnet Zeitreise, sieht Tutorial-Overlay, dismisst es. Tippt 3
Chips, sieht 3 Linien. Y-Achse in €. Crash-Tag rot.
