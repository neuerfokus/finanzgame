# Spec 30 — Quest-Pipeline + Zeitsprung-UX

## Goal

Mehr Quests mit klaren Lock-Triggern. Abgeschlossene Quests gesperrt. Zeitsprung mit Optionen + Warnung „kein Zurück". Asset-Vergleich-Chart: Achsen-Labels + lila Linien erklären/entfernen.

## Why

Test-Feedback: zu wenig Quests, Freischalt-Logik unklar, abgehackte Quests neu öffenbar, Zeitsprung-UX dünn, Chart-Linien rätselhaft.

## Non-Goals

- Voice-Acting für Quest-NPCs
- Quest-Editor-UI

## Tasks

### 1. Quest-Bestand erweitern

`assets/quests/`: 8 neue YAML-Quests + Bestand prüfen. Ziel ~20 Quests gesamt. Themen:
- „Erstes Sparziel" (unlock Tag 1)
- „Was ist Inflation?" (Tag 7)
- „ETF vs Aktie" (Bank-Besuch ≥ 3)
- „Crypto-Casino Warnung" (Krypto-Insel unlock)
- „Diversifikation" (Level 5)
- „Notgroschen" (Sparkonto > 100 €)
- „Wunschliste planen" (Tag 14)
- „Steuer-Basics" (Level 10)
- „Goldrausch" (Goldmine unlock)
- „Volatilität verstehen" (Krypto-Verlust > 30 %)
- „Compound-Magic" (Sparkonto 1 Jahr halten)
- „Inflation Atoll" (Inflation > 5 %)

Pro YAML: `unlock` Bedingung deklarativ:
```yaml
id: notgroschen
title: Notgroschen aufbauen
unlock:
  type: balance
  account: sparkonto
  min_cents: 10000
steps: [...]
```

### 2. Unlock-Engine

`quest_runner/quest_unlocker.dart`:
- Listenert auf `gameStateProvider` (Tag, Level, Holdings, Balances)
- Bei jedem `advanceDay`: scanne alle locked-Quests, prüfe Bedingung
- Erfüllt → state = `available`, Notification

Bedingungs-Typen: `day_min`, `level_min`, `balance_min`, `holding_min`, `event_count`.

### 3. Completed-Quests sperren

Aktuell: completed quest kann neu angetappt werden. Fix:
- `QuestState.completed` UI: keine Action-Buttons mehr, nur Read-Only-Verlauf
- Quest-List grayed out + Häkchen-Badge
- Filter-Tab „Aktiv | Erledigt | Verfügbar"

### 4. Zeitsprung-Optionen

`time_travel/time_travel_page.dart` (oder Sleep-Page Zeitsprung-Modus):
- Optionen: +1 Woche, +1 Monat, +3 Monate, +1 Jahr, +5 Jahre
- Bei Jahr+: Warn-Dialog mit großer Warnung „ACHTUNG: Du kannst nicht zurück! Alle Tage werden simuliert. Bist du sicher?"
- Confirm-Button braucht 2-Tap-Bestätigung
- Während Sprung: Loading-Animation mit Stichprobe-Events („Tag 142: ETF +2,1 %, ...")
- Endsummary

Kein „Time-Reverse" — Hardregel.

### 5. Asset-Vergleich-Chart

`time_travel/asset_compare_chart.dart` (oder wo gezeichnet):
- Achsen-Labels: X = „Jahr seit Start", Y = „Wert in €"
- Tick-Labels alle 5 Jahre
- Legende: pro Asset Farbe + Name + finaler Wert
- Aktuelle lila gestrichelte Linien: prüfen Code-Zweck. Wahrscheinlich Marker für „Ereignis" oder „Heute". Falls Ereignis → mit Label „Crash 2030" o.ä. annotieren. Falls keine semantische Bedeutung → entfernen.
- Tooltip on Tap: Wert bei Jahr X
- Realdaten ergänzen: Inflation-bereinigte Linie (gestrichelt) zusätzlich, Label „real, inflationsbereinigt"

### 6. Quest-Hub-Page

Neue `quests_hub_page.dart`: Übersicht aller Quests in Kategorien. Filter, Sortierung. Tab in Phone-UI.

## Files

- `assets/quests/*.yaml` (8 neu)
- `lib/features/quest_runner/quest_unlocker.dart` (neu)
- `lib/features/quest_runner/quest_state.dart` — completed-lock
- `lib/features/quest_runner/quests_hub_page.dart` (neu)
- `lib/features/quest_runner/quest_runner_page.dart` — completed UI lock
- `lib/features/time_travel/*` — Optionen, Warnung
- `lib/features/time_travel/asset_compare_chart.dart` — Achsen/Linien
- `lib/features/sleep/sleep_page.dart` — Zeitsprung-Entry

## Tests

- Unlocker: balance_min trigger
- Completed-Quest: Action-Button disabled
- TimeJump 1 Jahr: Tages-Anzahl korrekt simuliert
- Chart: X-Labels alle 5 Jahre
- YAML-Parser: 8 neue Quests laden

## Acceptance

- [ ] 8 neue Quests + Unlock-Trigger deklarativ
- [ ] Completed-Quests gesperrt
- [ ] Zeitsprung: 5 Optionen + Warn-Dialog mit 2-Tap
- [ ] Asset-Chart: Achsen-Labels, Legende, lila Linien erklärt/entfernt
- [ ] Quest-Hub mit Filter
- [ ] Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(quests): unlocker + completed-lock + time-jump-options + chart-labels`
