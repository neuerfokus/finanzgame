# Spec 20 — Schlafen kostet + Endgültiger Zeitsprung

## Goal

1. Schlafen ist nicht umsonst — kleine Kosten (Energie / Geld).
2. Neuer „Zeitsprung"-Button: skipped 7 oder 30 Tage am Stück mit
   batched Day-Summary.

## Why

Sohn-Feedback: „Wenn man den Button Schlafen nimmt sollte das nicht
umsonst sein und es wäre noch ein endgültiger Zeitsprung cool."

## Non-Goals

- Echtes Energie-System mit Stat-Bar (overkill)
- Beliebige N-Tage-Eingabe (festgelegte Schritte 7/30/365)

## Mechanik

### Schlafen-Kosten

Per Schlafen werden **10 ct** vom Cash abgezogen („Snack vor dem
Schlafengehen"). Wenn Cash < 10 ct: kostenlos, aber Day-Summary zeigt
„Hunger — keine Erträge heute" (Spaß-Variante: ein Listener wird
geskipped, z.B. Allowance bleibt aber Plant-Wachstum 0). Konfigurierbar
über `GameBalance.sleepCostCents`.

Day-Summary listet Kosten als eigenen Event-Type `SleepCostEvent`.

### Endgültiger Zeitsprung

Neuer Button neben „Schlafen": „Vorspulen ⏩". Tap öffnet Modal mit 3
Optionen:
- **7 Tage** (eine Woche, Allowance + Wetter-Effekte aggregiert)
- **30 Tage** (ein Monat, sichtbare Inflation)
- **1 Jahr** (365 Tage, Crash-Wahrscheinlichkeit greift, große Zinses-
  Wirkung)

Implementation: `GameClock.fastForward(int days)`:
- Schleife `advanceDay()` × N, sammelt alle `DaySummary`s.
- UI zeigt animierten Loading-Screen mit Tag-Counter („Tag 14 / 30").
- Am Ende: Zusammenfassungs-Screen mit Aggregaten:
  - Allowance total: X €
  - Ernten total: Y €
  - ETF/Aktien-Delta: Z €
  - Crash-Events: N
  - Größtes Tages-Event

Schlafen-Kosten gelten pro Tag im Sprung — bei großem Cash kein Problem,
sonst werden N Tage gehungert.

## UI

`SpringboardPage`:
- Aktueller „Schlafen 😴" Button bleibt.
- Daneben: kleiner „⏩"-Button → öffnet Modal.

Neuer Screen `lib/features/sleep/fast_forward_flow.dart`:
- Animierter Skip mit Progress-Bar.
- Zusammenfassungs-Screen mit Aggregaten.

## Files

- `lib/core/game_clock.dart` — `fastForward(int days)` Methode
- `lib/core/game_balance.dart` — `sleepCostCents = 10`
- `lib/features/sleep/fast_forward_flow.dart` NEU
- `lib/features/phone_ui/springboard_page.dart` — Button
- `lib/domain/sim/day_event.dart` — `SleepCostEvent` Variante

## Tests

- Pure: `advanceDay` zieht 10ct ab
- Pure: `fastForward(7)` ruft 7× advance, sammelt Summaries
- Hunger-Pfad: cash=0 → DaySummary listet Hunger
- Widget: FastForwardFlow zeigt Aggregat-Screen am Ende

## Acceptance

- [ ] SleepCostEvent (+ Konstante in GameBalance)
- [ ] DaySummary listet SleepCost
- [ ] Hunger-Pfad funktioniert
- [ ] FastForward-Modal mit 7/30/365-Optionen
- [ ] Animierter Skip + Aggregat-Screen
- [ ] Bestehende Tests grün
- [ ] Neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(time): sleep cost + fast-forward jump`

## Done When

Sohn drückt Schlafen → 10ct weniger, sichtbar in Day-Summary. Drückt
⏩ → wählt 30 Tage → kurzer Loader → Monatsbericht.
