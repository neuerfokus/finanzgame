# Spec 13 — Insel-Unlock-Gating + MonetariaState-Persistenz

## Goal

Inseln (ETF, Inflation, Aktien, Vulkan) starten **locked**. Spieler
schaltet sie durch Fortschritts-Milestones frei. Unlock-Set überlebt
App-Restart (Drift-persistiert).

## Why

Spec-07/08/09 forderten Gating, aber alle Inseln wurden default-unlocked
ausgeliefert (TODO-Kommentare in `monetaria_state.dart` 59–66). Spieler
hat keinen Progressions-Pfad. Zudem überlebt das Unlock-Set keinen
Restart, weil `MonetariaState` nicht in spec-12-Tabellen war.

## Non-Goals

- Visuelle Lock-Animation (Insel grau ist genug)
- Re-Lock (einmal frei, bleibt frei)
- Achievements / Milestones-Page

## Milestone-Regeln

| Insel | Bedingung |
|---|---|
| `heimathafen` | Start |
| `spar_insel` | Start |
| `mischwald` | (bleibt deferred — keine Sub-Mechanik) |
| `etf_insel` | Cash ≥ 50€ **UND** Plant-Verkaufserlös total ≥ 20€ |
| `inflation_atoll` | dayIndex ≥ 14 |
| `aktien_archipel` | ETF-Holdings Marktwert ≥ 100€ |
| `vulkan` | mindestens 1 Aktie im Besitz |

Milestones werden in `GameClock.advanceDay()`-Hook geprüft (nach allen
Listeners) und ggf. via `MonetariaState.unlock()` freigeschaltet. Locked-
Insel-Tap zeigt SnackBar mit Hinweis.

## Datenmodell

10. Drift-Tabelle:

```dart
class UnlockedIslandsTable extends Table {
  TextColumn get islandId => text()();
  @override
  Set<Column> get primaryKey => {islandId};
}
```

`MonetariaState.build()` lädt aus `dbSnapshotProvider.unlockedIslands`
(neues Feld in `DbSnapshot`). `unlock(id)` schreibt fire-and-forget.
Seed bei leerer Tabelle: `{heimathafen, spar_insel}`.

Total Plant-Erlös: neue Mini-Tabelle `LifetimeStatsTable` (singleton,
PK=0, columns: `plantHarvestTotalCents`). Statt eigener Tabelle: in
`CashTable` Zweitspalte `plantHarvestTotalCents` (default 0). Hooked an
`PlantRepository.harvest()`.

## UI

`MonetariaWorld.IslandMarker` rendert locked-Inseln grau + Schloss-Glyph
(SystemChrome PNG vermeiden — einfach `Icons.lock_outline` als
`TextComponent` „🔒" fallback ist genug für jetzt). `IslandPage`
zeigt bei locked: SnackBar „Noch verschlossen — siehe Hinweis im
Heimathafen-Quest".

## Files (zu ändern)

- `lib/data/db/tables.dart` — `UnlockedIslandsTable`, `cashTable` add column
- `lib/data/db/app_database.dart` — schemaVersion bleibt 1 (Pre-Release)
- `lib/data/db/daos.dart` — `UnlockedIslandsDao`
- `lib/data/db/app_database_provider.dart` — `DbSnapshot.unlockedIslands`,
  `lifetimeHarvestCents`
- `lib/game/monetaria/state/monetaria_state.dart` — load+persist
- `lib/features/plant/plant_repository.dart` — harvest hookt lifetimeStats
- `lib/core/game_clock.dart` — `_checkUnlocks()` nach advance
- `lib/features/monetaria/island_page.dart` — locked-SnackBar
- `lib/game/monetaria/components/island_marker.dart` — grau + Schloss

## Tests

- Unit: `MonetariaUnlocker` reine Funktion `compute({cash, harvestTotal,
  dayIndex, etfMarketValue, stockShares}) → Set<String>` — Tabellen-
  Tests pro Milestone
- Round-trip: unlock(`etf_insel`) → restart → contains
- Widget: locked IslandMarker tap → SnackBar

## Acceptance

- [ ] `UnlockedIslandsTable` (`schemaVersion = 1` — Pre-Release ok)
- [ ] `LifetimeStats` in cashTable (Erweiterung, kein zusätzliches Table)
- [ ] `MonetariaUnlocker` pure
- [ ] `GameClock.advanceDay()` ruft Unlocker nach allen Listeners
- [ ] Locked Islands grau gerendert + SnackBar bei Tap
- [ ] Defaults: nur heimathafen + spar_insel
- [ ] Bestehende 235 Tests grün, neue Unlock-Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(progression): island unlock gating + state persistence`

## Done When

Neuer Spieler sieht nur 2 Inseln. Pflanzt, schläft, erntet → ETF-Insel
schaltet frei. Kauft ETF, schläft 14 Tage → Inflations-Atoll. App-Kill
→ Reopen → freigeschaltete Inseln bleiben offen.

## Risiko

Bestehende Tests setzen ggf. `MonetariaState`-Default voraus (alle
unlocked). Vor Implementation grep nach `monetariaStateProvider`-Uses.
Falls Tests brechen: Test-Setup explizit auf „alle unlocken" via
override, statt Default ändern.
