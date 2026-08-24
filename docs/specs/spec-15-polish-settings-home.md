# Spec 15 — Polish: HomeBar + StatusBar + Settings + Heimathafen-Basis

## Goal

Sohn-Feedback aus erstem Sideload abarbeiten. Quick-Fixes + Settings-Page
+ Heimathafen mit Inhalt.

## Why

Erster echter Sohn-Test deckte tote UI auf: Settings-Stub statt Page,
HomeBar-Mitte/Rechts ohne Funktion, Statusbar mit sinnlosem „100%",
Heimathafen leer.

## Non-Goals

- Asset-Files (Fonts, Sprites, SFX) — separater Track
- Onboarding (Name/Avatar/SavingsGoal) — spec-16
- Daily-Quiz + Quest-Pool-Ausbau — spec-16

## Tasks

### 1. StatusBar entrümpeln

`lib/ui/widgets/status_bar.dart`:
- Entfernen: `batteryPercent` Parameter + 100%-Text rechts.
- Stattdessen rechts: aktueller Tag-Counter („Tag 3"). Tag kommt aus
  `gameClockProvider` — StatusBar wird `ConsumerWidget`.
- Tests anpassen (golden/widget falls vorhanden).

### 2. HomeBar reparieren

`lib/ui/widgets/home_bar.dart` + `phone_frame.dart`:
- **Mittlere Taste `●`**: Home = pop bis Springboard. `PhoneFrame.onHome`
  default `Navigator.popUntil(ModalRoute.withName('/'))`. Auf
  Springboard selbst: deaktiviert (`enabled=false`).
- **Rechte Taste `▣`**: umfunktionieren als „Settings-Shortcut".
  Glyph `⚙`, immer enabled, pushed `SettingsPage`.
- `enabled=false` Path bleibt für back-on-springboard.

### 3. Settings-Page

`lib/features/settings/settings_page.dart` (NEU):
- Skeleton: PhoneFrame + Liste editierbarer Werte.
- Feld 1: **Taschengeld-Betrag** (Money, default 20 €). Persistiert via
  neuer Drift-Tabelle `SettingsTable` (singleton PK=0, columns: 
  allowanceCents, allowanceWeekday TEXT, playerName TEXT nullable).
- Feld 2: **Taschengeld-Wochentag** (Dropdown Mo–So, default Mo).
- Feld 3: **Spielername** (TextField, default „Spieler").
- Feld 4: **Sound an/aus** (Switch, default an). Persistiert.
  `SoundService.muted = true/false` reagiert.
- Save-Button schreibt durch DB; State sofort sichtbar.

`AllowanceListener` liest künftig aus `SettingsRepository` statt
hardcoded Konstante. Default-Konstante bleibt als Fallback.

### 4. Heimathafen-Basis

`lib/features/monetaria/island_page.dart`:
- Neuer Case `IslandId.heimathafen` zeigt eigene `HeimathafenPage`
  (separates File `lib/features/heimathafen/heimathafen_page.dart`).
- Inhalt P1:
  - NPC-Käpt'n-Begrüßung als Chat-Bubble (statischer Dialog, kein YAML-
    Quest nötig)
  - Buttons: „Hilfe lesen" (zeigt Erklärung der Inseln + Schloss-Hinweis),
    „Spar-Insel" (Push), „Quests" (Push QuestListPage)
- Reuses `PixelPanel` + `ChatBubble`.

### 5. SpringboardPage

- Settings-AppIcon (Grid Zeile 2 Spalte 3): pushed jetzt `SettingsPage`
  statt SnackBar.
- Springboard selbst übergibt `onHome: null` (oder `null` + showBack=false).

## Drift-Schema

11. Tabelle `SettingsTable`:
```dart
class SettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get allowanceCents => integer().withDefault(const Constant(2000))();
  TextColumn get allowanceWeekday => text().withDefault(const Constant('mon'))();
  TextColumn get playerName => text().withDefault(const Constant('Spieler'))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}
```

`DbSnapshot.settings` mit Defaults. `SettingsRepository` Riverpod-Provider
gleichen Stils wie spec-13/14.

## Files

- `lib/data/db/tables.dart`, `daos.dart`, `app_database.dart`,
  `app_database_provider.dart`
- `lib/features/settings/settings_page.dart` NEU
- `lib/features/settings/settings_repository.dart` NEU
- `lib/features/heimathafen/heimathafen_page.dart` NEU
- `lib/ui/widgets/status_bar.dart` Refactor zu ConsumerWidget
- `lib/ui/widgets/home_bar.dart` + `phone_frame.dart` HomeButton + Settings-Glyph
- `lib/features/phone_ui/springboard_page.dart` Settings-Push
- `lib/domain/sim/listeners/allowance_listener.dart` lesen aus Settings
- `lib/features/audio/sound_service.dart` `muted`-Flag respektieren

## Tests

- Round-trip: Settings.set(allowance=3000) → reopen DB → 3000
- AllowanceListener mit injizierten Settings produziert AllowanceEvent
  am konfigurierten Wochentag mit konfiguriertem Betrag
- Widget: SettingsPage tippt Allowance auf 30€, Save → state hat 3000
- Widget: HomeBar mittlere Taste push pop ruft `onHome`
- Widget: HomeBar rechte Taste pushed SettingsPage
- Heimathafen-Widget: zeigt Käpt'n + 3 Buttons

## Acceptance

- [ ] StatusBar zeigt rechts Tag-Counter, kein 100%
- [ ] HomeBar mittlere Taste funktional (pop-to-root)
- [ ] HomeBar rechte Taste öffnet Settings
- [ ] SettingsPage editiert + persistiert Taschengeld/Tag/Name/Sound
- [ ] AllowanceListener nutzt Settings-Werte
- [ ] SoundService.muted respektiert Settings
- [ ] Heimathafen mit Käpt'n + Navigation
- [ ] Bestehende 266 Tests grün, neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Release-APK gebaut + auf Sohn-Handy reinstalliert
- [ ] Commit: `feat(polish): settings + homebar + heimathafen base`

## Done When

Sohn öffnet App, Statusbar zeigt sinnvolle Info. Mittlere Taste bringt
zurück zum Springboard. Rechte Taste öffnet Settings. Settings editiert
Taschengeld auf 30€. Heimathafen zeigt Käpt'n-Dialog mit Erklärung.

## Risiko

`SettingsTable` ist 11. Tabelle bei `schemaVersion = 1`. Pre-Release-OK
solange Sohn keine Daten verliert die er behalten will. Aktuell nichts
schützenswert da APK ganz neu.
