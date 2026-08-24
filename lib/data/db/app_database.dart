import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Top-level Drift database for all persistent game state.
///
/// schemaVersion = 1 — no migrations until first sideload APK lands on
/// the Sohn's device. See spec-12.
@DriftDatabase(
  tables: [
    GameClockTable,
    CashTable,
    PlantsTable,
    EtfHoldingsTable,
    EtfQuotesTable,
    StockHoldingsTable,
    StockQuotesTable,
    CryptoHoldingsTable,
    CryptoQuotesTable,
    MetalHoldingsTable,
    MetalQuotesTable,
    RealEstateHoldingsTable,
    CollectibleHoldingsTable,
    IslandDecorTable,
    QuestPassivePaymentsTable,
    VorsorgeContractsTable,
    SavingsPlansTable,
    WishItemsTable,
    PriceHistoryTable,
    UnlockedIslandsTable,
    QuestProgressTable,
    QuestChatEntriesTable,
    SettingsTable,
    XpTable,
    SavingsTable,
    AchievementsTable,
    LuckyEventHistoryTable,
    NewGameStateTable,
    TreeHoldingsTable,
    JobActionStateTable,
    QuestFailureTable,
    FurnitureTable,
    RealMilestonesTable,
    RealSavingsGoalsTable,
  ],
  daos: [
    GameClockDao,
    CashDao,
    PlantsDao,
    EtfDao,
    StockDao,
    CryptoDao,
    MetalDao,
    RealEstateDao,
    CollectibleDao,
    IslandDecorDao,
    QuestPassiveDao,
    VorsorgeDao,
    SavingsPlansDao,
    WishItemsDao,
    PriceHistoryDao,
    UnlockedIslandsDao,
    QuestProgressDao,
    QuestChatDao,
    SettingsDao,
    XpDao,
    SavingsDao,
    AchievementsDao,
    LuckyEventHistoryDao,
    NewGameDao,
    TreeHoldingsDao,
    JobActionDao,
    QuestFailureDao,
    FurnitureDao,
    RealMilestonesDao,
    RealSavingsGoalsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Factory for production: file-backed DB in the platform's app-data dir,
  /// opened lazily on a background isolate.
  factory AppDatabase.forProduction() {
    return AppDatabase(NativeDatabase.createInBackground(_dbFile()));
  }

  /// Factory for tests: throw-away in-memory DB.
  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 39;

  /// Setzt BTC-Stückelungen + ETF-Quotes auf ihre kanonischen Basispreise.
  /// Genutzt von Migrationen v28 (Preis-Korrektur) + v29 (Desync-Heilung).
  /// Holdings/Kaufbasis bleiben unberührt.
  Future<void> _resetMarketQuotesToBase() async {
    const btc = {
      'crypto_bitcoin_mikro': 630,
      'crypto_bitcoin': 6300,
      'crypto_bitcoin_gross': 63000,
      'crypto_bitcoin_zehntel': 630000,
      'crypto_bitcoin_ganz': 6300000,
    };
    for (final e in btc.entries) {
      await customStatement(
        'UPDATE crypto_quotes_table SET price_per_share_cents = ? '
        'WHERE asset_id = ?',
        [e.value, e.key],
      );
    }
    const etf = {
      'welt_korb': 11000,
      'tech_korb': 40000,
      'dax_korb': 19000,
      'emerging_korb': 5500,
      'esg_korb': 9000,
    };
    for (final e in etf.entries) {
      await customStatement(
        'UPDATE etf_quotes_table SET price_per_share_cents = ? '
        'WHERE etf_id = ?',
        [e.value, e.key],
      );
    }
  }

  /// Fügt eine Spalte nur hinzu, wenn sie in der Tabelle noch FEHLT.
  ///
  /// Schützt vor „duplicate column"-Migrations-Crashes in ZWEI Szenarien
  /// (beide brechen sonst die GANZE Kette ab → Crash-Loop → der +166-Guard
  /// quarantänt einen intakten Save):
  /// 1. `createTable` in einer Migration nutzt immer die AKTUELLE
  ///    Tabellendefinition (inkl. Spalten, die erst eine SPÄTERE Migration
  ///    per `addColumn` ergänzt) — der v25→v36-Crash eines Testers
  ///    (`real_milestones.category`).
  /// 2. Kill-Retry: Drift wrappt onUpgrade NICHT in eine Transaktion und
  ///    setzt `user_version` erst NACH Erfolg. App-Kill mitten im
  ///    Update-Sprung → beim nächsten Start läuft dieselbe Kette erneut
  ///    über eine DB, die die Spalten teilweise schon hat.
  ///
  /// Tabellen-/Spaltennamen kommen direkt aus der Drift-Definition — kein
  /// Tippfehler-Risiko bei ~25 Call-Sites.
  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo<Table, dynamic> table,
    GeneratedColumn<Object> column,
  ) async {
    if (!await hasColumn(table.actualTableName, column.$name)) {
      await m.addColumn(table, column);
    }
  }

  /// True wenn `tableName` eine Spalte `columnName` hat (via PRAGMA
  /// table_info). Basis des „duplicate column"-Migrations-Guards
  /// ([_addColumnIfMissing]) — public für Migrations-Regressionstests.
  Future<bool> hasColumn(String tableName, String columnName) async {
    final info = await customSelect('PRAGMA table_info($tableName)').get();
    return info.any((r) => r.read<String>('name') == columnName);
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // spec-34: switched to additive migrations so the Sohn's saved
        // progress survives version bumps. Each version that adds a
        // SettingsTable column registers an explicit addColumn step.
        onUpgrade: (m, from, to) async {
          // JEDER addColumn-Schritt läuft über _addColumnIfMissing — siehe
          // dort: schützt sowohl vor createTable-mit-neuer-Def als auch vor
          // dem Kill-Retry (Drift hat keine Migrations-Transaktion).
          if (from < 3) {
            // Analyse-Runde 2026-08: diese drei SettingsTable-Spalten waren
            // die EINZIGEN ohne Migrations-Schritt — sie kamen aus spec-17
            // (lastQuizDayIndex), spec-19 (zeitreiseTutorialSeen) und
            // spec-23 (musicVolume), also aus der Zeit VOR dem niedrigsten
            // Guard hier. Ein Save der Schema-Version 1/2 hätte sie nie
            // bekommen → `no such column` beim ersten SELECT → DB-Open in
            // main() scheitert → der Crash-Guard hält einen INTAKTEN Save
            // für „beschädigt" und quarantänt ihn (Tester-Fehlerklasse).
            // Solche Saves sind heute vermutlich nicht mehr im Umlauf, der
            // Schritt ist über _addColumnIfMissing aber ohnehin idempotent.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.lastQuizDayIndex);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.zeitreiseTutorialSeen);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.musicVolume);
            // Pre-spec-27 schema lacked masterVolume + sfxVolume.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.masterVolume);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.sfxVolume);
          }
          if (from < 4) {
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.lastSleepEpochMs);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.sleepCountInWindow);
          }
          if (from < 5) {
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.onboardingComplete);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.avatarEmoji);
          }
          if (from < 6) {
            // spec-35 phase B: real-estate table.
            await m.createTable(realEstateHoldingsTable);
          }
          if (from < 7) {
            // spec-36: vorsorge + savings-plan tables.
            await m.createTable(vorsorgeContractsTable);
            await m.createTable(savingsPlansTable);
          }
          if (from < 8) {
            // Spec-38 Welle 5: collectibles table.
            await m.createTable(collectibleHoldingsTable);
          }
          if (from < 9) {
            // Spec-40 C: daily streak columns.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.streakCount);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.lastSleepDateIso);
          }
          if (from < 10) {
            // Spec-41 A: unlocked avatars column.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.unlockedAvatars);
          }
          if (from < 11) {
            // Spec-42 Welle-6: quest-passive payments table.
            await m.createTable(questPassivePaymentsTable);
          }
          if (from < 12) {
            // Spec-43 Stage 1: island decor + unlockedDecor column.
            await m.createTable(islandDecorTable);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.unlockedDecor);
          }
          if (from < 13) {
            // Spec-43 follow-up: kaufbare Spar-Insel-Plots.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.sparPlotCount);
          }
          if (from < 14) {
            // Spec-45 A2 + G4: Lucky-Event Historie persistent.
            await m.createTable(luckyEventHistoryTable);
          }
          if (from < 15) {
            // Spec-45 G3 + H3: NewGame+ und Wald-Bäume persistent.
            await m.createTable(newGameStateTable);
            await m.createTable(treeHoldingsTable);
          }
          if (from < 16) {
            // Spec-45 C5 + Welle-8: JobAction + Quest-Failure persistent.
            await m.createTable(jobActionStateTable);
            await m.createTable(questFailureTable);
          }
          if (from < 17) {
            // Welle-8 Round 14: Quiz-Topics als gelernt markieren.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.quizLearnedTopics);
          }
          if (from < 18) {
            // Welle-8 Round 15: First-Steps-Coach + Weekly-Review.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.seenCoaches);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.lastWeekNetWorthCents);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.lastWeeklyReviewDay);
          }
          if (from < 19) {
            // Welle-8 Round 15: Quiz-Anti-Repeat persistent.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.recentQuizTexts);
          }
          if (from < 20) {
            // Welle-8 Round 16: User-Foto-Pfad pro Wish-Item.
            await _addColumnIfMissing(m, wishItemsTable,
                wishItemsTable.photoPath);
          }
          if (from < 21) {
            // Welle-8: startAgeYears war in-memory-only → ging bei
            // App-Neustart verloren (Alter fiel auf 13, verfälschte
            // Job/Lebenskosten/age-gated Vorsorge). Jetzt persistent.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.startAgeYears);
          }
          if (from < 22) {
            // Welle-8: Möbel waren in-memory-only → gingen bei
            // App-Neustart verloren (Sohn-Bug "Stuhl weg"). Jetzt
            // persistent.
            await m.createTable(furnitureTable);
          }
          if (from < 23) {
            // Welle-8 Round 22: Pay-yourself-first Slider war
            // in-memory-only → sprang bei App-Neustart auf 0.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.savingsRatePct);
          }
          if (from < 24) {
            // Welle-8 Round 22 / B7: Tagesziel-Claim war in-memory-only
            // → Banner kam nach App-Restart wieder + erneut claimbar.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.lastClaimedGoalDay);
          }
          if (from < 25) {
            // Welle-8 Round 23: Eltern-PIN-Lock für Reset/Import/Wipe-
            // Aktionen. Schützt vor versehentlichem Datenverlust durch
            // Kind. Leer = kein Lock (default).
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.parentPin);
          }
          if (from < 26) {
            // Welle-8 Round 24 (#10): Echte Erfolge (Eltern-Modus) —
            // reale Spar-/Lern-Meilensteine in der Trophäenwand.
            await m.createTable(realMilestonesTable);
          }
          if (from < 27) {
            // Welle-8 Round 26: Kategorie pro echtem Erfolg.
            // Guard: bei Saves von <26 hat die v26-createTable die Spalte
            // schon angelegt (aktuelle Tabellendef) → sonst „duplicate
            // column: category" (der v25→v36-Crash eines Testers).
            await _addColumnIfMissing(
                m, realMilestonesTable, realMilestonesTable.category);
          }
          if (from < 28) {
            // Welle-8 Round 27: einmaliger Anker-Reset. Alte Saves trugen
            // veraltete BTC- (90k-Ära) + zu billige ETF-Quotes. Setzt die
            // Markt-Quotes EINMALIG auf die neuen Basispreise. Holdings/
            // Kaufbasis bleiben → Drift läuft danach frei (BTC 16k-250k).
            await _resetMarketQuotesToBase();
          }
          if (from < 29) {
            // Welle-8 Round 27 v3: Re-Anchor nach dem Stückelungs-Desync-
            // Bugfix (Listener gab Member-Stückelungen den Tages-Return
            // doppelt → divergierten). Saves aus +133/+134 könnten schon
            // desynced sein → einmal sauber auf Basis zurücksetzen.
            await _resetMarketQuotesToBase();
          }
          if (from < 30) {
            // Round 28: Skill-Baum — freigeschaltete Knoten als CSV.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.unlockedSkills);
          }
          if (from < 31) {
            // Round 28 v4: Wochen-Herausforderung (Claimed-Woche + Streak).
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.weeklyChallengeClaimedWeek);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.weeklyChallengeStreak);
          }
          if (from < 32) {
            // Welle B: Vermächtnis-Prestige — permanente Legacy-Punkte +
            // gekaufte Upgrades über Generationen. Guard gegen „duplicate
            // column" für Saves von <15 (v15-createTable legt sie schon an).
            await _addColumnIfMissing(
                m, newGameStateTable, newGameStateTable.legacyPoints);
            await _addColumnIfMissing(
                m, newGameStateTable, newGameStateTable.legacyUpgrades);
          }
          if (from < 33) {
            // Welle C: Echtes-Sparziel-Begleiter.
            await m.createTable(realSavingsGoalsTable);
          }
          if (from < 34) {
            // Optionen-Backlog #2: Streak-Meilenstein-Farm-Guard. Default 0.
            // Hinweis: Bestehende Saves mit hohem streakCount holen beim
            // nächsten Schlafen die bereits überschrittenen Tiers EINMALIG
            // rückwirkend nach (gewollt, lifetime-gedeckelt, nicht farmbar).
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.claimedStreakMilestone);
          }
          if (from < 35) {
            // Job-Wechsel: Cooldown-Gate (Anti-Glitch) + Titel-Rotation.
            // Guard gegen „duplicate column" für Saves von <16 (v16-createTable
            // legt die Spalten schon mit der aktuellen Def an).
            await _addColumnIfMissing(m, jobActionStateTable,
                jobActionStateTable.nextSwitchAllowedDay);
            await _addColumnIfMissing(m, jobActionStateTable,
                jobActionStateTable.jobVariantIndex);
          }
          if (from < 36) {
            // Auto-Sicherung default-AN + manueller Aus-Schalter (opt-out).
            // Default false = AN für alle bestehenden Saves.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.autoSaveDisabled);
          }
          if (from < 37) {
            // SAF-Backup-Ordner-URI (nullable). Default null = Legacy-Pfad.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.backupFolderUri);
          }
          if (from < 38) {
            // Altersstatus für den Unterstützen-Bereich: nur das Geburtsjahr,
            // ob die Frage schon gestellt wurde, und die Sperrzeit der
            // Eltern-Rechenaufgabe.
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.birthYear);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.birthYearAsked);
            await _addColumnIfMissing(m, settingsTable,
                settingsTable.parentGateLockedUntilMs);
          }
          if (from < 39) {
            // Nutzung pro Immobilie: selbst bewohnt oder vermietet.
            await _addColumnIfMissing(m, realEstateHoldingsTable,
                realEstateHoldingsTable.usage);
          }
        },
      );

  /// Spec-38 follow-up: Reset-Game — löscht alle Tabellen. Wird vom
  /// Settings-Reset-Button aufgerufen. App muss danach neu gestartet werden
  /// damit Riverpod-Provider rebuild + Onboarding wieder erscheint.
  Future<void> wipeAll() async {
    await transaction(() async {
      for (final t in allTables) {
        // Welle B: NewGame-Zeile (runCount + Vermächtnis-Prestige + pending
        // Erbschaft) MUSS den Reset überleben — sie ist der Träger der
        // generationsübergreifenden Progression.
        if (t == newGameStateTable) continue;
        await delete(t).go();
      }
    });
  }

  static File _dbFile() {
    // path_provider's app-data dir is only resolvable inside the Flutter
    // engine; production callers must `await getApplicationSupportDirectory()`
    // before constructing the DB. We expose the helper for callers that need
    // it but keep [forProduction] using a LazyDatabase-style indirection.
    throw UnimplementedError(
      'Use AppDatabase.forProductionAsync() — path_provider needs an await.',
    );
  }
}

/// Builds a production [AppDatabase] backed by a file in the app-support dir.
///
/// `await`ed in `main.dart` before `runApp`, so the first frame already has
/// all repositories pre-warmed.
Future<AppDatabase> openProductionDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final file = File(p.join(dir.path, 'finanzgame.sqlite'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}
