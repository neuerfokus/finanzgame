# Spec 26 — Sim-Balancing realistic

## Goal

Realistische Werte + 80-Jahr-Horizont. Crypto auf 2 Klassen reduzieren. Asset-Namen firmenähnlich-fiktiv. Platinum-Icon eigen. Chart-Farben fix.

## Why

Sohn-Feedback: 0,1%/Tag = absurd. Crypto-Liste zu lang. Tickers nichtssagend. Platinum sieht aus wie Gold. Rot/Blau auf Charts = unintuitiv.

## Non-Goals

- Steuern, Inflation neu modellieren
- Echte Marken (Hardregel)

## Tasks

### 1. Zinsen realistisch + %/Monat

`bank/economy_constants.dart` (oder wo `savingsDailyRate`):
- Sparkonto: 0,15 %/Monat (~1,8 %/Jahr brutto)
- Festgeld 12M: 0,25 %/Monat (~3 %/Jahr)
- Girokonto: 0 %

Speicherung: `monthlyRateMillis` (Promille×10, int). Beispiel: 15 = 0,15 %.

Day-Tick rechnet `dailyRate = monthlyRate / 30` mit Money-Cent-Präzision. Round-Half-Even.

UI-Label: „0,15 % / Monat" statt „0,1 % / Tag". Tooltip „≈ 1,8 % / Jahr".

Migration `app_database`: alte `dailyRateBp` Spalten droppen oder umrechnen — pragmatisch `onUpgrade` Werte überschreiben mit Defaults.

### 2. 80-Jahr-Horizont

`GameClock.maxAgeYears = 80`. Default Start-Alter = 13. Tage bis Cap = (80−13)×365 = 24455. Sleep-Page: bei Erreichen Endscreen „Lebenslauf-Resümee". Statt blockieren.

Zeitsprung-Optionen (siehe spec-30) gekoppelt: Cap respektieren.

### 3. Crypto: 2-Klassen-Refactor

`crypto/crypto_assets.dart`: bestehende Liste reduzieren auf:
- `BTC` „Bitcoin" — Volatilität σ ≈ 4 %/Tag, langfristig leicht positiv-trend
- `KRYPTO` „Krypto-Casino" — Sammeltoken, σ ≈ 12 %/Tag, Pump+Dump-Events, Crash-Risiko (Black-Swan 1 % pro Tag → −60 %)

UI: zwei Karten, „Krypto-Casino" mit Warn-Banner: „⚠ Sehr riskant. Hier kann man alles verlieren."

Migration: alte Crypto-Holdings konsolidieren → konvertiere alle Nicht-BTC zu KRYPTO zum letzten Kurs.

### 4. Asset-Namen firmenähnlich

Bestehende fiktive Tickers ergänzen mit Realwelt-Anspielung (legal: keine 1:1 Marken):
- Tech-ETF: „WeltTec ETF" (statt 'TECH-X')
- Energy: „NordOel & Gas"
- Auto: „MotoBawer" (Anlehnung BMW, generisch)
- Pharma: „PharmaVerde"
- Konsum: „GroßMarkt AG"
- Index: „DAXION 40" (DAX-artig, fiktiv)
- US-Index: „Amerika 500"
- World-ETF: „GlobalWelt ETF"

Liste in `stock/stock_assets.dart` + `etf/etf_assets.dart`. Logos optional, sonst Initiale + Farbe.

### 5. Platinum-Icon

Aktuell wahrscheinlich gleiches Gold-Glyph. Sprite/Icon austauschen:
- Gold: gold-bar (gelb #FFD700)
- Silber: silver-bar (grau #C0C0C0)
- Platin: weiß-bläulich Diamant-Stil (#E5E4E2) + Stern-Glyph oder andere Form (Triangel)

Falls Kenney `generic-items` Bar-Sprites vorhanden — nutzen. Sonst CustomPainter mit unterschiedlicher Form (Gold=Bar, Platin=Coin oder Crystal).

### 6. Chart-Farben Konvention

Wo Schlaf-Dialog-Vorschau-Charts gezeichnet werden (`sleep/sleep_preview.dart` o.ä.):
- Aufwärts: `FgColors.success` (Grün)
- Abwärts: `FgColors.danger` (Rot)
- Flat: neutral

Suchen: alle `LineChart`/`CustomPainter` + farben `red`/`blue`/`Color(0xFF...)`. Konstanten `kChartUp`/`kChartDown` in `design_tokens.dart`. Replace überall.

## Files

- `lib/features/bank/economy_constants.dart`
- `lib/features/bank/*` — UI-Labels, Tooltip
- `lib/data/db/tables.dart` — Spalten umbenennen ggf
- `lib/core/game_clock.dart` — maxAge
- `lib/features/crypto/crypto_assets.dart` — auf 2 reduzieren
- `lib/features/crypto/*` UI — Warn-Banner
- `lib/features/stock/stock_assets.dart`, `lib/features/etf/etf_assets.dart` — Namen
- `lib/features/metal/*` — Platin-Icon
- `lib/core/design_tokens.dart` — kChartUp/kChartDown
- `lib/features/sleep/*` — Chart-Farben
- Migration in `app_database.dart`

## Tests

- Bank: 100 € × 0,15 %/M × 30 Tage ≈ 100,15 €
- Crypto: nur 2 Tickers im Provider
- Chart-Farb-Konstanten Smoke-Test (Widget-Test prüft Color)
- 80-Jahr-Cap: GameClock.advanceDay über Cap blockiert oder triggert End-Event

## Acceptance

- [ ] Zinsen %/Monat, realistisch
- [ ] 80J-Cap implementiert
- [ ] Crypto reduziert auf BTC + KRYPTO mit Warn-Banner
- [ ] Asset-Namen firmenähnlich
- [ ] Platinum visuell unterscheidbar
- [ ] Chart up=grün down=rot überall
- [ ] Tests grün + neue
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(sim): realistic rates + crypto reduce + naming + chart colors`
