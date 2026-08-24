# Spec 12 — DB-Foundation (Drift-Persistenz)

## Goal

Migriere alle bisher in-memory gehaltenen Riverpod-Stores auf Drift-SQLite,
damit App-State App-Restart überlebt. Plant-Wachstum, Cash, ETF/Stock-
Holdings, Wunschliste, Quest-Progress, GameClock, Wetter — alles
persistent.

## Why

Größtes ausstehendes Deferral nach Sprints 5–10. Sohn schließt App,
verliert kompletten Fortschritt. Killt jede Langzeit-Motivation.
Drift ist seit Sprint 0 in `pubspec.yaml`, drift_dev codegen vorhanden,
nur Schema fehlt.

## Non-Goals

- Cloud-Sync (Hardregel: offline-only)
- Migrations zwischen DB-Versionen (`schemaVersion = 1` bleibt; bei
  Schema-Change einfach App-Daten löschen während Pre-Release)
- Verschlüsselung (kein PII, kein Bedarf)
- Backup/Export (später)
- Schreiben auf jeden State-Change im UI-Thread (Batch in
  `GameClock.advanceDay()` reicht für Phase 1)

## Drift Schema

`lib/data/db/app_database.dart`:

```dart
@DriftDatabase(tables: [
  GameClockTable,
  CashTable,
  PlantsTable,
  EtfHoldingsTable, EtfQuotesTable,
  StockHoldingsTable, StockQuotesTable,
  WishItemsTable,
  PriceHistoryTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  @override int get schemaVersion => 1;
}
```

Tabellen:
- `GameClockTable` (singleton, primary key = 0) — dayIndex
- `CashTable` (singleton) — cents
- `PlantsTable` — id, islandId, plotIndex, kind, plantedOnDayIndex,
  currentStage, status
- `EtfHoldingsTable` — etfId PK, shares, averageBuyPriceCents
- `EtfQuotesTable` — etfId PK, pricePerShareCents, onDayIndex
- `StockHoldingsTable` — stockId PK, shares, averageBuyPriceCents
- `StockQuotesTable` — stockId PK, pricePerShareCents, onDayIndex
- `WishItemsTable` — id PK, currentPriceCents, ownedOnDayIndex (nullable)
- `PriceHistoryTable` — composite PK (assetId, dayIndex), priceCents

## Migration-Strategie

Pre-Release ist OK: bei Schema-Bruch wird App-Daten gelöscht.
Sobald **erste echte Sideload-APK beim Sohn** läuft, friert
`schemaVersion = 1`. Spätere Sprints inkrementieren + schreiben
`MigrationStrategy`.

## Repository-Refactor

Pro Domain ein konkretes Drift-Backend, Provider behält gleiches Interface:

```dart
@Riverpod(keepAlive: true)
class CashState extends _$CashState {
  @override
  Money build() {
    final db = ref.read(appDatabaseProvider);
    return _loadOrSeed(db);
  }

  Future<bool> spend(Money amount) async {
    if (state < amount) return false;
    state = state - amount;
    await ref.read(appDatabaseProvider).cashDao.set(state);
    return true;
  }
  // ...
}
```

Alle Notifier:
- `build()` lädt aus DB (oder seed-Defaults bei leerer Tabelle)
- Mutator-Methoden schreiben Async durch
- API-Signatur bleibt synchron wo möglich (write fire-and-forget mit
  `unawaited`), sonst Future<...>

Riverpod-Provider für `AppDatabase` selbst:

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(NativeDatabase.createInBackground(_dbFile()));
  ref.onDispose(db.close);
  return db;
}
```

## ProviderScope-Bootstrapping

`main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SoundService.use(AudioplayersSoundService());
  // Provider warms up — DB opened, all state pre-loaded.
  final container = ProviderContainer();
  await container.read(appDatabaseProvider).warmup();
  // ...
  runApp(UncontrolledProviderScope(container: container, child: ...));
}
```

## Test-Strategie

- `AppDatabase` mit `NativeDatabase.memory()` für alle Tests
- Pro Repo: round-trip-Test (write → close → reopen → read)
- Integration: 5x `advanceDay()`, App "restart" (dispose container,
  reopen), erwarte Plant-Stage + Cash + ETF-Quotes erhalten

## Acceptance

- [ ] `AppDatabase` mit allen 9 Tabellen
- [ ] Pro Domain ein DAO (`cashDao`, `plantsDao`, etc.)
- [ ] 7 Repositories laden + schreiben durch DB
- [ ] `appDatabaseProvider` + Dispose
- [ ] HistoryRepository persistiert (oder bewusst weiterhin in-memory
       mit dokumentierter Begründung — Diagramm-Daten dürfen weg sein)
- [ ] Bestehende Tests grün ohne Anpassung an API (synchron-bleibend)
- [ ] Neue Persistence-Round-Trip-Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(db): Drift persistence for all game state`

## Done When

Spieler pflanzt Pflanze, kauft ETF, schließt App. Beim nächsten Start
ist alles noch da: gleicher Tag, gleicher Cash, gleiche Plants, gleiche
ETF-Quotes.

## Risiko

Größter Refactor seit Sprint 1. Alle Repos angefasst. Wenn etwas
bricht: behalte API synchron, sodass UI-Code unverändert. Bei
Async-Schreibfehlern: `unawaited` + Log, kein UI-Crash.
