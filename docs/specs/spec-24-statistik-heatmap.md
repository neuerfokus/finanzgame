# Spec 24 — Statistik-Seite mit Heatmap (Fixed Header)

## Goal

Eigene Statistik-Page mit Heatmap-Visualisierung über die Spielzeit.
Insel-/Asset-Namen bleiben beim Wischen am Bildschirmrand fixiert
(sticky).

## Why

Sohn-Wunsch: „Bei der Heatmap in Statistik sollte die Namen fixiert
sein, dass wenn man durch den Zeitplan wischt die App direkt sieht."

Aktuell: keine Statistik-Seite, keine Heatmap. Zeitreise zeigt Lines.

## Non-Goals

- Echte Datenbank-Heatmap (Pivot über N Wochen mit M Assets reicht)
- Export
- Per-Day-Tooltips

## Mechanik

`StatistikPage` — neue Seite, zugänglich über:
- Eigenes AppIcon „📊 Statistik" auf Springboard (vorhandenes Grid
  erweitern oder Bank-Icon-Untermenü)
- ODER Tab in Bank-/Zimmer-Page

Vorschlag: eigenes Springboard-Icon (Grid wird 7→8 oder Settings-Slot
verschieben).

### Layout

```
┌─ Statistik ─────────────┐
│ [Asset-Filter-Chips]    │  <- floating, immer sichtbar
├─────────────────────────┤
│ Asset \   Tag 1 2 3 4 ..│  <- sticky header
│ Cash       █ █ ▓ ▓ ░ ░ ▓│
│ ETF-Idx    ░ ░ ▓ █ █ █ ▓│  <- sticky row labels
│ Aktien     ▓ █ ░ ░ ▓ █ █│
│ Krypto     █ █ █ ░ ░ ▓ ▓│
│ Inflation  ░ ░ ▓ ▓ █ █ █│
│ Sparbuch   ▓ ▓ █ █ █ ▓ ▓│
└─────────────────────────┘
        ←  scrollable →
```

- **Sticky-Achsen**: Row-Labels (Asset-Namen) bleiben links beim
  horizontalen Scroll. Column-Header (Tag-Nummern) bleiben oben beim
  vertikalen Scroll.
- **Heatmap-Zellen**: Farbe nach Tagesveränderung (rot=Verlust,
  grün=Gewinn, intensität = Größe der Veränderung)
- Tap auf Zelle: Tooltip mit Wert + Δ%

### Datenquelle

Reuse `HistoryRepository` aus spec-19. Pro Asset-ID + dayIndex
gibt's einen Wert. Heatmap rendert max letzte 60 Tage horizontal.

Δ% pro Zelle = (heute - gestern) / gestern. Mapping zu Farbe:
- > +5% → dunkelgrün
- +1..+5% → mittelgrün
- -1..+1% → grau (neutral)
- -5..-1% → mittelrot
- < -5% → dunkelrot

### Implementierung Sticky-Layout

Flutter hat `SliverPersistentHeader` für sticky. Aber zweidimensional
ist tricky. Einfacher: `Stack`+`SingleChildScrollView` für Hauptbereich
+ separate `Row` für Header + separate `Column` für Row-Labels, alle
synchronisiert über `ScrollController`-Listener.

Bibliothek `sticky_headers` oder `flutter_sticky_header` könnte helfen,
aber pure Implementation reicht: zwei `ScrollController`, einer für
horizontal, einer für vertikal, beide schreiben den Offset auch in
Header/Row-Label-Layer.

## Files

- `lib/features/statistik/statistik_page.dart` NEU
- `lib/features/statistik/heatmap_painter.dart` NEU
- `lib/features/statistik/heatmap_color.dart` NEU (pure Δ% → Color)
- `lib/features/phone_ui/springboard_page.dart` — 📊-Icon

## Tests

- Pure: `heatmapColor(delta)` Tabellen-Test (5 Buckets)
- Widget: StatistikPage rendert Header + Row-Labels
- Widget: horizontal scroll bewegt nur Daten, Row-Labels bleiben
- Widget: vertical scroll bewegt nur Daten, Header bleibt

## Acceptance

- [ ] StatistikPage erreichbar via Springboard
- [ ] Sticky Header (Tag-Nummern) + sticky Row-Labels (Asset-Namen)
- [ ] Heatmap-Zellen färben nach Δ%
- [ ] Letzte 60 Tage × 6 Assets sichtbar (oder all wenn weniger)
- [ ] Tap auf Zelle zeigt Wert + Δ% Tooltip
- [ ] Bestehende Tests grün
- [ ] Neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(stats): statistik page with heatmap + sticky labels`

## Done When

Sohn tippt 📊 → sieht Heatmap aller Assets über letzte 60 Tage. Wischt
horizontal durch die Tage → Asset-Namen bleiben links sichtbar. Wischt
vertikal → Tag-Header bleibt oben. Farben zeigen sofort, wo's gut/
schlecht lief.
