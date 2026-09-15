# Spec 21 — Bank + Zimmer + XP-System

## Goal

Drei fehlende Springboard-Features:
1. **Bank**: Konto-Übersicht + Spar-Konto + Zins
2. **Zimmer**: Avatar + Trophäen-Wand + erspielte Items
3. **XP**: echtes Erfahrungs-Punkte-System mit Quellen + Anzeige

## Why

Test-Feedback: „Bank und Zimmer geht noch nicht. Auch die XP werden
nicht gutgeschrieben." Springboard-Icons sind seit Sprint 3 SnackBar-
Stubs. XP wird im MoneyHeader angezeigt aber bleibt auf 0.

## Non-Goals

- Mehrere Bank-Konten (1 Giro + 1 Spar reicht)
- Animationen in Zimmer (deferred)
- Level-System (XP zeigt nur Total, kein Level-Up-Flow)

## Tasks

### 1. XP-System

Neue Drift-Tabelle `XpTable` (singleton PK=0, columns: `total int`).
Neuer Repository `XpRepository` (Riverpod keepAlive).

XP-Quellen:
- Quest abgeschlossen: +10 XP
- Daily-Quiz richtig: +5 XP
- Plant geerntet: +2 XP
- ETF-Kauf: +3 XP, ETF-Verkauf: +1 XP
- Stock-Kauf: +5 XP
- Schlafen: +1 XP

Hook-Points: jeweilige Listener / Controller rufen
`xpRepository.add(int)` synchron, persistiert fire-and-forget.

MoneyHeader.xp aus Repository statt hardcoded.

### 2. Bank-Feature

`lib/features/bank/bank_page.dart` NEU:
- Zwei Konten: **Giro** (= aktuelles `CashState`), **Spar** (neue
  Tabelle `SavingsTable` singleton, cents).
- Transfer-UI: Slider/Buttons „Auf Spar überweisen 10€/50€/100€",
  „Vom Spar abheben".
- Spar-Konto verzinst sich täglich: 0.1% pro Tag (~36% p.a., bewusst
  überhöht für Lern-Wirkung). Listener
  `SavingsInterestListener` in `GameClock`.
- Tabs/Sections: **Übersicht** (Giro/Spar/Total) | **Verlauf** (letzte
  N Transaktionen aus PriceHistoryTable mit assetId='savings').

### 3. Zimmer-Feature

`lib/features/zimmer/zimmer_page.dart` NEU:
- Avatar oben (statische Pixel-Figur — TextComponent „🧒" mit Skin-
  Color Switch in Settings; sprite-Asset deferred).
- **Trophäen-Wand**: Grid von Achievements.
  Achievements als const Pool:
    - erste Pflanze geerntet
    - 100 € auf Spar-Konto
    - erster ETF-Kauf
    - 1 Quest abgeschlossen
    - 5 Quests abgeschlossen
    - Inflations-Atoll freigeschaltet
    - Crash überlebt (= nicht alles verkauft am Crash-Tag)
    - 30 Tage gespielt
  Trophäe = Emoji + Label. Locked = grau + 🔒.
  Status-Check: pure Funktion `evaluateAchievements({...stats})` →
  `Set<String>` unlocked IDs.
- **Erspielte Wunschartikel**: Liste aus `WishItemsTable` wo
  `ownedOnDayIndex != null`. Zeigt Item-Glyph + „Tag N gekauft".

`AchievementsTable` (singleton list von unlocked IDs) oder direkt aus
Stats berechnet. Bevorzugt: persisted Set für Notification-Trigger.

### 4. Springboard-Verdrahtung

`lib/features/phone_ui/springboard_page.dart`:
- Bank-Icon: pushed `BankPage`
- Zimmer-Icon: pushed `ZimmerPage`
- `_xp = 0` Konstante weg, `ref.watch(xpRepositoryProvider)`.

## Tabellen-Erweiterung

```dart
class XpTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get total => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class SavingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get cents => integer().withDefault(const Constant(0))();
  @override Set<Column> get primaryKey => {id};
}

class AchievementsTable extends Table {
  TextColumn get id => text()();
  IntColumn get unlockedOnDayIndex => integer()();
  @override Set<Column> get primaryKey => {id};
}
```

Schema-Version bleibt 1 (Pre-Release-Wipe OK).

## Tests

- XP: jede Quelle hookt + Total stimmt
- XP round-trip
- Bank: transfer 10€ Giro→Spar, beide korrekt
- Bank: Zinsen täglich akkumulieren
- Bank round-trip
- Zimmer: AchievementsEvaluator Tabellen-Test
- Achievements round-trip

## Acceptance

- [ ] 3 neue Tabellen + DAOs
- [ ] `XpRepository`, `SavingsRepository`, `AchievementsRepository`
- [ ] `SavingsInterestListener` daily
- [ ] BankPage funktional mit Transfer + Verzinsung
- [ ] ZimmerPage mit Avatar + Trophäen + Wunschartikel
- [ ] XP wird in MoneyHeader live aus Repo gelesen
- [ ] Bestehende Tests grün
- [ ] Neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(meta): bank + zimmer + xp system`

## Done When

Testspieler tippt Bank → Konto-Übersicht + Transfer. Tippt Zimmer → Avatar +
Trophäen-Wand mit erworbenen Artikeln. XP zählt nach Quests, Ernte,
Quiz.
