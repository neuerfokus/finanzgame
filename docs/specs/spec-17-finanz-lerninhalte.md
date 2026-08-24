# Spec 17 — Finanz-Lerninhalte stärker

## Goal

Erhöhe Finanzbildungs-Anteil. Inline-Erklärungen pro Insel + Quest-Pool
ausgebaut + Daily-Quiz-Overlay endlich gebaut.

## Why

Sohn-Feedback: „Der Bezug zu den aktuellen Finanzthemen ist zu gering."
Das Spiel hat Mechaniken (sparen, ETF, Aktie, Inflation, Crash) aber
zu wenig erklärenden Text und zu wenig Quest-Pool, um sie zu
verankern.

## Non-Goals

- Externe Lern-Videos / Audio
- Realwelt-Aktien (Hardregel)

## Tasks

### 1. Insel-Lerntexte (Long-Form)

Erweitere `IslandIdentity` aus spec-16 um Feld `lesson` (Markdown-light
String, 3–5 Sätze). Neuer Button im Insel-Header: **„Was ist das?"** →
zeigt Bottom-Sheet mit `lesson`.

Beispiel ETF-Insel `lesson`:
> Ein ETF ist ein Korb aus vielen Aktien. Statt eine einzelne Firma zu
> wählen, kaufst du einen Anteil an vielen auf einmal. Vorteil: weniger
> Risiko, weil ein Verlust einer Firma durch andere ausgeglichen wird.
> Der Preis schwankt mit dem Wetter — gutes Wetter = Aufschwung,
> Sturm = Kursrutsch.

Pro Insel: heimathafen (Intro), spar_insel (Sparen+Zins), etf_insel
(Diversifikation), inflation_atoll (Inflation+Kaufkraft),
aktien_archipel (Einzelaktien-Risiko), vulkan (Crash-Lehre).

### 2. Daily-Quiz-Overlay

Neuer Feature-Ordner `lib/features/daily_quiz/`:
- `quiz_question.dart` — Freezed-sealed: `multipleChoice` (text, options,
  correctIndex, explanation)
- `quiz_pool.dart` — const-Liste 20+ Finanzfragen
- `daily_quiz_page.dart` — Full-Screen-Overlay nach jedem ersten
  Springboard-Open pro Tag. Eine Frage; richtig = +50 ct Bonus, falsch
  = +0 ct, immer Erklärung anzeigen, dann „Weiter".
- Trigger: `dailyQuizStateProvider` merkt sich `lastShownDayIndex`,
  persistiert in `SettingsTable` (zusätzliche Spalte `lastQuizDayIndex`).

Quiz erscheint nur einmal pro `gameClockProvider.dayIndex`. Skip-Button
falls Sohn keinen Bock — kein Zwang.

### 3. Quest-Pool ausbauen

Neue YAMLs unter `assets/quests/`:
- `q03_zinseszins.yaml` — Käpt'n erklärt Zinseszins; Step-Frage: „Was
  passiert mit deinem Geld nach 10 Jahren bei 5% Zinsen?" Antwort wählen
  → Reward 100ct
- `q04_etf_basket.yaml` — Was ist ein ETF? Multi-Choice
- `q05_inflation_brot.yaml` — Inflation-Beispiel mit Brotpreis
- `q06_crash_was_tun.yaml` — Crash-Verhalten: panisch verkaufen vs.
  durchhalten
- `q07_einzelaktie_risiko.yaml` — Konzentrationsrisiko
- `q08_diversifikation.yaml` — Eier-im-Korb-Analogie

Jeder Quest hat `prerequisites` so dass sich eine Lern-Reihenfolge ergibt:
q01 → q03 → q04 → q06 → (q07, q08 parallel) → q05.

YAML-Loader unterstützt bereits Multi-Choice + Reward — siehe Sprint 6.
Bei Bedarf erweitern.

### 4. Springboard-Indikator

Falls heute noch ungespieltes Daily-Quiz: roter Punkt am Settings-Glyph
oder „Frage des Tages"-AppIcon im Grid (Zeile 2 Spalte 1: ❓).
Tap öffnet Quiz direkt.

## Files

- `lib/features/monetaria/island_identity.dart` — Feld `lesson`
- `lib/features/monetaria/island_header.dart` (aus spec-16) — Button
- `lib/features/daily_quiz/*.dart` NEU
- `assets/quests/q03_..q08_*.yaml` NEU
- `lib/data/db/tables.dart` — `lastQuizDayIndex` in SettingsTable
- `lib/features/phone_ui/springboard_page.dart` — Quiz-Indikator/Icon

## Tests

- Pure: jeder Insel-`lesson` ≥ 50 Zeichen, kein leerer String
- Widget: Lesson-Bottom-Sheet öffnet bei Button-Tap
- Unit: `DailyQuizState.shouldShow(dayIndex)` Tabellen-Test
- YAML: alle q03–q08 laden + parsen + valide Steps

## Acceptance

- [ ] 6 Insel-Lessons (lange Form)
- [ ] DailyQuiz mit ≥20 Fragen-Pool
- [ ] Quiz erscheint max 1×/Tag, persistiert
- [ ] 6 neue Quests in YAML, kettengezogen via prerequisites
- [ ] Bestehende Tests grün
- [ ] Neue Lesson+Quiz+Quest-Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(content): finance lessons, daily quiz, expanded quest pool`

## Done When

Sohn öffnet Spar-Insel → Header zeigt 1-Satz-Erklärung + „Was ist das?"-
Button mit Bottom-Sheet. Erster App-Start des Tages: Quiz-Frage. Quest-
Liste hat 8 Quests in lernlogischer Reihenfolge.
