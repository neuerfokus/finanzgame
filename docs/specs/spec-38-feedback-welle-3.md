# Spec 38 — Feedback-Welle 3

## Goal

Bugs aus Welle 3 fixen, UX-Polish-Lücken schließen, Content-Erweiterungen vorbereiten. Bucket-Triage: P0=Bugs, P1=UX, P2=Content.

## Why

Sideload-Feedback 2026-05-20. Specs 25–37 geshippt, aber konkrete Bugs + Wording-Probleme + Lücken bleiben. Keine echten Marken, kein Glücksspiel-Drift, Hardregeln aus CLAUDE.md.

## Non-Goals

- Cloud-Sync / Online-Features
- Echte Aktien-Daten / echte Marken
- 80-Jahre-Lebenssim als Echtzeit-Engine (nur Frame + Anzeige)

## P0 — Bugs (must-fix)

### 1. Sparinsel-Ernte kaputt
Repro: Pflanze reif, Tap Ernten → kein Ertrag. Vermutlich Listener-Order nach spec-34 Plant-Catalog-Migration. Fix: `PlantListener` + `SparIslandWorld.onTapPlant` + Repository-Write neu verifizieren. Test: golden-path harvest.

### 2. Wunschartikel: erspielte verschwunden
`WishlistPage` zeigt keine gekauften Items mehr (nach spec-37 Portfolio). Owned-Filter prüfen, Zimmer-Trophy-Wall-Hook reparieren.

### 3. Zeitsprung-Tage-Anzeige falsch
„5 Jahre = 1835 Tage" — sollte 1825. Off-by-N. Quelle finden: `time_travel_page.dart` Label-Formatter oder GameClock-Konstante.

### 4. Platin-Icon = Gold-Icon
`MetalCatalog`/`metal_trade_page.dart`: Platin nutzt gleiches Glyph. Eigenes Glyph (💍 oder Pt-Symbol).

### 5. Schlafdialog Farben rot/grün vertauscht
DaySummary-Sparklines: Aufwärts = rot, Abwärts = blau. Sollte: ↑ grün, ↓ rot. `DaySummaryPage` Spark-Renderer.

### 6. „Schlafen-Snack -0,10€"-Wording
Aus spec-20 SleepCostEvent. „Snack" passt nicht. Umlabel: „Schlafenskosten" oder „Verpflegung". DaySummary-Eventlabel.

### 7. Zeitsprung-Mehrjahres-Gewinne
spec-33b sollte gefixt haben — nochmal verifizieren: Halten 1 Jahr ETF während fastForward berechnet Compound korrekt? Test: `fastForward(365)` mit ETF-Holding → erwarteter Wert.

## P1 — UX-Polish

### 8. Musik hart-default-off + Mute-Toggle prominent
`SettingsTable.musicVolume` default = 0. Settings-Page: Mute-Toggle vor Slider. SFX bleiben default an.

### 9. Schriftart-Lesbarkeit
KenneyPixel weiter unleserlich auf hochauflösenden Geräten. Switch zu KenneyMini oder System-Sans für Body, KenneyPixel nur für Titel/Buttons. `FgTypography.body*` → System-Font.

### 10. Level-Up-Toast
Bei Level-Aufstieg: Dialog/Snack mit neuem Level + Titel + nächstem Ziel. `XpRepository.onLevelUp` Stream → Listener auf Springboard.

### 11. Datum/Alter-Header
Springboard-StatusBar: „Tag 142 · 2026-09-12 · Alter 13 J 7 M". Alter = StartAlter + (Tag-Index/365). StartAlter aus Onboarding (default 13). PlayerProfile-Feld nötig.

### 12. Zurück → Hauptmenü statt Handy
HomeBar-Mitte-Button: Navi zu Springboard. „Zurück zum Hauptmenü"-Label. Aktuell springt manche Page zurück zu Phone-Wrapper.

### 13. Lila-Linien-Erklärung im Zeitreise-Chart
spec-30 hat Frage gestellt aber nicht beantwortet. Code prüfen: vertikale lila gestrichelt = vermutlich „heute"-Marker. Falls ja: Label „Heute" + Legende. Falls Crash-Marker: schon dashed-red. Lila weg oder annotiert.

### 14. Wochentag-Setting killen oder erklären
`SettingsTable.taschengeldWochentag` — wofür? Wenn nur kosmetisch: weg. Wenn Allowance-Trigger: Tooltip „An welchem Tag pro Woche bekommst du Taschengeld".

### 15. Krypto reduzieren auf 2
RugCoin/PixelBit/ChainKraken → reduzieren: „Bitcoin" (stabilster Krypto) + „AltCoin Casino" (sehr volatil, -90% möglich). `CryptoCatalog` umbauen. Migrations-Stub für bestehende Holdings.

### 16. Gespeichert-Snack Kontrast
spec-25 hatte fix, weiter unlesbar. Hintergrund: opaque dunkel + weiße Schrift + größere Font.

### 17. Zurück-Button Edge-Cases
Restliche Routes ohne Pop-Handler. Audit aller Pages, GoRouter-Back-Button überall verfügbar.

## P2 — Content + Logik

### 18. 80-Jahre-Lebensspanne-Frame
PlayerProfile.geburtstagTag = Tag 0. Anzeige in StatusBar. Bei Alter ≥ 80: „Ruhestand"-Screen mit Lebens-Summary. Kein Game-Over, nur Reflexion.

### 19. Zimmer Mehrfach-Kauf + Anordnung
Furniture-Shop: pro Kategorie nur 1 Item kaufbar. Erlauben: pro Slot 1 Item, Slots = Grid (4×4). Drag-Drop oder Tap-To-Place. Wenn zu viel: zumindest „1 Item pro Sub-Typ" statt „pro Kategorie".

### 20. Quest-Antwort-Position randomisieren
Quiz/Quest-Multiple-Choice: richtige Antwort immer Mittelpos. Random-Shuffle pro Frage. `DailyQuiz._renderOptions` + Quest-Step-Renderer.

### 21. Quest + Quiz Dedup
Themen-Overlap: Inflation in Quest UND Quiz. Tagging: `topic: inflation` in YAML/Quiz-Pool. Wenn Quest active → Quiz-Topic skippen.

### 22. Mehr Quests + Unlock-Text
spec-30 Liste komplettieren (20 total). Quest-Hub: bei locked-Quest Tooltip „Erreiche Level 5 um freizuschalten".

### 23. Iso-Tiles + Schiff-Polish
spec-37 iso-tiles erst Anfang. Pirate-Kit-3D-Sprites einbauen: Inseln + Schiff + Wasser-Animation. Boot-Sprite tauschen.

### 24. Inflations-Atoll Prozent-Erklärung
spec-33b hatte Versuch, weiter unklar. Inline-Tooltip pro %-Zahl: „+5,2 % seit Start" + Sparkline.

### 25. Mischwald Unlock-Hinweis
Wann frei? Was drauf? Im Heimathafen Käpt'n-Dialog erwähnen + Tooltip auf locked-Insel zeigen Bedingung.

### 26. Statistik/Portfolio Werte-Bugs
spec-37 Portfolio: nicht alle Werte sauber. Audit: Crypto + Metalle + Vorsorge alle in `PortfolioRepository.totalValue` enthalten? Tests pro Asset-Klasse.

### 27. Sparplan-Menü vs ETF-Insel Redundanz
spec-36 ETF-Sparplan-Page existiert. Menü-Eintrag „Sparplan" entfernen oder direkt zu ETF-Insel-Sparplan-Tab navigieren.

## Files (skizzenhaft)

- `lib/features/spar_island/*` — harvest-fix
- `lib/features/wishlist/*` — owned-filter
- `lib/features/time_travel/*` — Tage-Berechnung, Lila-Linien, Datum-Header
- `lib/features/metals/*` — Platin-Glyph
- `lib/features/day_summary/*` — Spark-Farben, Snack-Wording
- `lib/features/sleep/sleep_listener.dart` — Event-Label
- `lib/features/settings/*` — Musik-default-0, Wochentag-Klärung
- `lib/features/xp/level_up_toast.dart` (neu)
- `lib/domain/avatar/player_profile.dart` — geburtstagTag
- `lib/features/phone_ui/status_bar.dart` — Datum+Alter
- `lib/features/crypto/*` — Catalog auf 2 reduzieren
- `lib/features/zimmer/furniture_layout.dart` (neu) — Slot-Grid
- `lib/features/daily_quiz/*` + `quest_runner/*` — Antwort-Shuffle + Topic-Dedup
- `lib/features/quest_runner/quests_hub_page.dart` — Unlock-Tooltip
- `lib/features/inflation/*` — Prozent-Tooltip
- `assets/quests/*.yaml` — neue Quests bis 20

## Tests

- Spar-Harvest Roundtrip
- Wishlist owned-render
- FastForward 5 Jahre = 1825 Tage exakt
- FastForward + ETF Compound korrekt
- DaySummary Spark-Color-Mapping
- LevelUp Toast emit
- StatusBar Datum+Alter Format
- Crypto-Catalog hat 2 Einträge
- Quest-Quiz Topic-Dedup
- Portfolio-Wert = Σ aller Asset-Klassen

## Acceptance

- [ ] Alle P0-Bugs gefixt + Regression-Tests
- [ ] P1 1-8 geshippt
- [ ] P2 mindestens 19/20/21/26/27 geshippt
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Tests grün (`flutter test --concurrency=1`)
- [ ] Commit-Bundle: `feat(p0)`, `feat(ux)`, `feat(content)` je eigener Commit oder ein großer `feat: feedback-welle-3 (spec-38)`

## Stretch (P3, optional)

- Ruhestand-Screen bei Alter 80
- Pirate-3D-Sprites voll integriert
- Mischwald-Insel-Inhalt (eigene Sub-Mechanik)
