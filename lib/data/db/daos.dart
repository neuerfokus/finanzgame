import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [GameClockTable])
class GameClockDao extends DatabaseAccessor<AppDatabase>
    with _$GameClockDaoMixin {
  GameClockDao(super.db);

  Future<int?> loadDayIndex() async {
    final row = await (select(gameClockTable)..where((t) => t.id.equals(0)))
        .getSingleOrNull();
    return row?.dayIndex;
  }

  Future<void> setDayIndex(int dayIndex) async {
    await into(gameClockTable).insertOnConflictUpdate(
      GameClockTableCompanion.insert(
        id: const Value(0),
        dayIndex: Value(dayIndex),
      ),
    );
  }
}

@DriftAccessor(tables: [CashTable])
class CashDao extends DatabaseAccessor<AppDatabase> with _$CashDaoMixin {
  CashDao(super.db);

  Future<CashRow?> loadRow() async {
    return (select(cashTable)..where((t) => t.id.equals(0))).getSingleOrNull();
  }

  Future<int?> loadCents() async => (await loadRow())?.cents;

  Future<int?> loadHarvestTotalCents() async =>
      (await loadRow())?.plantHarvestTotalCents;

  Future<void> setCents(int cents) async {
    // Preserve plantHarvestTotalCents across the update; if no row exists
    // yet the column defaults to 0.
    final existing = await loadRow();
    await into(cashTable).insertOnConflictUpdate(
      CashTableCompanion.insert(
        id: const Value(0),
        cents: Value(cents),
        plantHarvestTotalCents:
            Value(existing?.plantHarvestTotalCents ?? 0),
      ),
    );
  }

  /// Adds [cents] to the lifetime plant-harvest total. Used by
  /// [PlantRepository.harvest] to feed the ETF-island unlock milestone.
  Future<void> addHarvest(int cents) async {
    final existing = await loadRow();
    final newTotal = (existing?.plantHarvestTotalCents ?? 0) + cents;
    await into(cashTable).insertOnConflictUpdate(
      CashTableCompanion.insert(
        id: const Value(0),
        cents: Value(existing?.cents ?? 2500),
        plantHarvestTotalCents: Value(newTotal),
      ),
    );
  }
}

@DriftAccessor(tables: [UnlockedIslandsTable])
class UnlockedIslandsDao extends DatabaseAccessor<AppDatabase>
    with _$UnlockedIslandsDaoMixin {
  UnlockedIslandsDao(super.db);

  Future<List<String>> loadAll() async {
    final rows = await select(unlockedIslandsTable).get();
    return rows.map((r) => r.islandId).toList(growable: false);
  }

  Future<void> insert(String islandId) async {
    await into(unlockedIslandsTable).insertOnConflictUpdate(
      UnlockedIslandsTableCompanion.insert(islandId: islandId),
    );
  }
}

@DriftAccessor(tables: [PlantsTable])
class PlantsDao extends DatabaseAccessor<AppDatabase> with _$PlantsDaoMixin {
  PlantsDao(super.db);

  Future<List<PlantRow>> loadAll() => select(plantsTable).get();

  Future<void> upsert(PlantRow row) async {
    await into(plantsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteById(String id) async {
    await (delete(plantsTable)..where((t) => t.id.equals(id))).go();
  }

  /// Welle-8: kompletter Tabel-Wipe für PlantRepository.resetAllPlants.
  Future<void> deleteAll() async {
    await delete(plantsTable).go();
  }

  Future<void> replaceAll(List<PlantRow> rows) async {
    await transaction(() async {
      await delete(plantsTable).go();
      for (final r in rows) {
        await into(plantsTable).insert(r);
      }
    });
  }
}

@DriftAccessor(tables: [EtfHoldingsTable, EtfQuotesTable])
class EtfDao extends DatabaseAccessor<AppDatabase> with _$EtfDaoMixin {
  EtfDao(super.db);

  Future<List<EtfHoldingRow>> loadHoldings() =>
      select(etfHoldingsTable).get();

  Future<List<EtfQuoteRow>> loadQuotes() => select(etfQuotesTable).get();

  Future<void> upsertHolding(EtfHoldingRow row) async {
    await into(etfHoldingsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteHolding(String etfId) async {
    await (delete(etfHoldingsTable)..where((t) => t.etfId.equals(etfId))).go();
  }

  Future<void> upsertQuote(EtfQuoteRow row) async {
    await into(etfQuotesTable).insertOnConflictUpdate(row);
  }

  Future<void> upsertQuotes(List<EtfQuoteRow> rows) async {
    await batch((b) {
      for (final r in rows) {
        b.insert(etfQuotesTable, r, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

@DriftAccessor(tables: [StockHoldingsTable, StockQuotesTable])
class StockDao extends DatabaseAccessor<AppDatabase> with _$StockDaoMixin {
  StockDao(super.db);

  Future<List<StockHoldingRow>> loadHoldings() =>
      select(stockHoldingsTable).get();

  Future<List<StockQuoteRow>> loadQuotes() => select(stockQuotesTable).get();

  Future<void> upsertHolding(StockHoldingRow row) async {
    await into(stockHoldingsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteHolding(String stockId) async {
    await (delete(stockHoldingsTable)..where((t) => t.stockId.equals(stockId)))
        .go();
  }

  Future<void> upsertQuote(StockQuoteRow row) async {
    await into(stockQuotesTable).insertOnConflictUpdate(row);
  }

  Future<void> upsertQuotes(List<StockQuoteRow> rows) async {
    await batch((b) {
      for (final r in rows) {
        b.insert(stockQuotesTable, r, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

@DriftAccessor(tables: [CryptoHoldingsTable, CryptoQuotesTable])
class CryptoDao extends DatabaseAccessor<AppDatabase> with _$CryptoDaoMixin {
  CryptoDao(super.db);

  Future<List<CryptoHoldingRow>> loadHoldings() =>
      select(cryptoHoldingsTable).get();

  Future<List<CryptoQuoteRow>> loadQuotes() => select(cryptoQuotesTable).get();

  Future<void> upsertHolding(CryptoHoldingRow row) async {
    await into(cryptoHoldingsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteHolding(String assetId) async {
    await (delete(cryptoHoldingsTable)
          ..where((t) => t.assetId.equals(assetId)))
        .go();
  }

  Future<void> upsertQuote(CryptoQuoteRow row) async {
    await into(cryptoQuotesTable).insertOnConflictUpdate(row);
  }

  Future<void> upsertQuotes(List<CryptoQuoteRow> rows) async {
    await batch((b) {
      for (final r in rows) {
        b.insert(cryptoQuotesTable, r, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

@DriftAccessor(tables: [MetalHoldingsTable, MetalQuotesTable])
class MetalDao extends DatabaseAccessor<AppDatabase> with _$MetalDaoMixin {
  MetalDao(super.db);

  Future<List<MetalHoldingRow>> loadHoldings() =>
      select(metalHoldingsTable).get();

  Future<List<MetalQuoteRow>> loadQuotes() => select(metalQuotesTable).get();

  Future<void> upsertHolding(MetalHoldingRow row) async {
    await into(metalHoldingsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteHolding(String assetId) async {
    await (delete(metalHoldingsTable)
          ..where((t) => t.assetId.equals(assetId)))
        .go();
  }

  Future<void> upsertQuote(MetalQuoteRow row) async {
    await into(metalQuotesTable).insertOnConflictUpdate(row);
  }

  Future<void> upsertQuotes(List<MetalQuoteRow> rows) async {
    await batch((b) {
      for (final r in rows) {
        b.insert(metalQuotesTable, r, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

@DriftAccessor(tables: [WishItemsTable])
class WishItemsDao extends DatabaseAccessor<AppDatabase>
    with _$WishItemsDaoMixin {
  WishItemsDao(super.db);

  Future<List<WishItemRow>> loadAll() => select(wishItemsTable).get();

  Future<void> upsert(WishItemRow row) async {
    await into(wishItemsTable).insertOnConflictUpdate(row);
  }

  Future<void> upsertAll(List<WishItemRow> rows) async {
    await batch((b) {
      for (final r in rows) {
        b.insert(wishItemsTable, r, mode: InsertMode.insertOrReplace);
      }
    });
  }
}

@DriftAccessor(tables: [PriceHistoryTable])
class PriceHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$PriceHistoryDaoMixin {
  PriceHistoryDao(super.db);

  Future<List<PriceHistoryRow>> loadAll() => select(priceHistoryTable).get();

  Future<void> append(PriceHistoryRow row) async {
    await into(priceHistoryTable).insertOnConflictUpdate(row);
  }

  Future<void> appendAll(List<PriceHistoryRow> rows) async {
    await batch((b) {
      for (final r in rows) {
        b.insert(priceHistoryTable, r, mode: InsertMode.insertOrReplace);
      }
    });
  }

  /// Ersetzt die komplette Reihe eines Assets — für das Ausdünnen alter
  /// Punkte. Die Tabelle wuchs sonst unbegrenzt (~15 Zeilen pro Spieltag,
  /// im Zeitsprung alle 30 Tage) und wurde bei JEDEM Kaltstart komplett
  /// geladen → die Startzeit wuchs mit der Spieldauer.
  Future<void> replaceAssetSeries(
    String assetId,
    List<PriceHistoryRow> rows,
  ) async {
    await transaction(() async {
      await (delete(priceHistoryTable)
            ..where((t) => t.assetId.equals(assetId)))
          .go();
      await batch((b) {
        for (final r in rows) {
          b.insert(priceHistoryTable, r, mode: InsertMode.insertOrReplace);
        }
      });
    });
  }
}

@DriftAccessor(tables: [QuestProgressTable])
class QuestProgressDao extends DatabaseAccessor<AppDatabase>
    with _$QuestProgressDaoMixin {
  QuestProgressDao(super.db);

  Future<List<QuestProgressRow>> loadAll() => select(questProgressTable).get();

  Future<QuestProgressRow?> loadFor(String questId) {
    return (select(questProgressTable)
          ..where((t) => t.questId.equals(questId)))
        .getSingleOrNull();
  }

  Future<void> upsert(QuestProgressRow row) async {
    await into(questProgressTable).insertOnConflictUpdate(row);
  }

  /// Spec-42 Welle-6: löscht Progress-Row für [questId].
  Future<void> deleteOne(String questId) async {
    await (delete(questProgressTable)
          ..where((t) => t.questId.equals(questId)))
        .go();
  }
}

@DriftAccessor(tables: [QuestChatEntriesTable])
class QuestChatDao extends DatabaseAccessor<AppDatabase>
    with _$QuestChatDaoMixin {
  QuestChatDao(super.db);

  /// Returns chat rows for [questId] ordered by [QuestChatEntriesTable.orderIndex].
  Future<List<QuestChatEntryRow>> loadFor(String questId) {
    return (select(questChatEntriesTable)
          ..where((t) => t.questId.equals(questId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
  }

  Future<void> append({
    required String questId,
    required int orderIndex,
    required String kind,
    required String payloadJson,
  }) async {
    await into(questChatEntriesTable).insert(
      QuestChatEntriesTableCompanion.insert(
        questId: questId,
        orderIndex: orderIndex,
        kind: kind,
        payloadJson: payloadJson,
      ),
    );
  }

  /// Spec-42 Welle-6: löscht alle Chat-Einträge für [questId].
  Future<void> deleteForQuest(String questId) async {
    await (delete(questChatEntriesTable)
          ..where((t) => t.questId.equals(questId)))
        .go();
  }

  Future<int> nextOrderIndex(String questId) async {
    final rows = await (select(questChatEntriesTable)
          ..where((t) => t.questId.equals(questId))
          ..orderBy([(t) => OrderingTerm.desc(t.orderIndex)])
          ..limit(1))
        .get();
    if (rows.isEmpty) return 0;
    return rows.first.orderIndex + 1;
  }
}

@DriftAccessor(tables: [XpTable])
class XpDao extends DatabaseAccessor<AppDatabase> with _$XpDaoMixin {
  XpDao(super.db);

  Future<int?> loadTotal() async {
    final row = await (select(xpTable)..where((t) => t.id.equals(0)))
        .getSingleOrNull();
    return row?.total;
  }

  Future<void> setTotal(int total) async {
    await into(xpTable).insertOnConflictUpdate(
      XpTableCompanion.insert(
        id: const Value(0),
        total: Value(total),
      ),
    );
  }
}

@DriftAccessor(tables: [SavingsTable])
class SavingsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsDaoMixin {
  SavingsDao(super.db);

  Future<int?> loadCents() async {
    final row = await (select(savingsTable)..where((t) => t.id.equals(0)))
        .getSingleOrNull();
    return row?.cents;
  }

  Future<void> setCents(int cents) async {
    await into(savingsTable).insertOnConflictUpdate(
      SavingsTableCompanion.insert(
        id: const Value(0),
        cents: Value(cents),
      ),
    );
  }
}

@DriftAccessor(tables: [QuestPassivePaymentsTable])
class QuestPassiveDao extends DatabaseAccessor<AppDatabase>
    with _$QuestPassiveDaoMixin {
  QuestPassiveDao(super.db);

  Future<List<QuestPassiveRow>> loadAll() =>
      select(questPassivePaymentsTable).get();

  Future<int> insertRow({
    required String questId,
    required int monthsRemaining,
    required int monthlyCents,
    required int lastPaidDayIndex,
  }) =>
      into(questPassivePaymentsTable).insert(
        QuestPassivePaymentsTableCompanion.insert(
          questId: questId,
          monthsRemaining: monthsRemaining,
          monthlyCents: monthlyCents,
          lastPaidDayIndex: lastPaidDayIndex,
        ),
      );

  Future<void> updateRow({
    required int rowId,
    required int monthsRemaining,
    required int lastPaidDayIndex,
  }) async {
    await (update(questPassivePaymentsTable)
          ..where((t) => t.rowId.equals(rowId)))
        .write(QuestPassivePaymentsTableCompanion(
      monthsRemaining: Value(monthsRemaining),
      lastPaidDayIndex: Value(lastPaidDayIndex),
    ));
  }

  Future<void> deleteRow(int rowId) async {
    await (delete(questPassivePaymentsTable)
          ..where((t) => t.rowId.equals(rowId)))
        .go();
  }
}

@DriftAccessor(tables: [CollectibleHoldingsTable])
class CollectibleDao extends DatabaseAccessor<AppDatabase>
    with _$CollectibleDaoMixin {
  CollectibleDao(super.db);

  Future<List<CollectibleHoldingRow>> loadAll() =>
      select(collectibleHoldingsTable).get();

  Future<int> insertHolding({
    required String specId,
    required int boughtAtDayIndex,
    required int boughtPriceCents,
  }) async {
    return into(collectibleHoldingsTable).insert(
      CollectibleHoldingsTableCompanion.insert(
        specId: specId,
        boughtAtDayIndex: boughtAtDayIndex,
        boughtPriceCents: boughtPriceCents,
      ),
    );
  }

  Future<void> deleteRow(int rowId) async {
    await (delete(collectibleHoldingsTable)
          ..where((t) => t.rowId.equals(rowId)))
        .go();
  }
}

/// Spec-43 Stage 1: per-island decor placement DAO.
@DriftAccessor(tables: [IslandDecorTable])
class IslandDecorDao extends DatabaseAccessor<AppDatabase>
    with _$IslandDecorDaoMixin {
  IslandDecorDao(super.db);

  Future<List<IslandDecorRow>> loadForIsland(String islandId) =>
      (select(islandDecorTable)..where((t) => t.islandId.equals(islandId)))
          .get();

  Future<List<IslandDecorRow>> loadAll() => select(islandDecorTable).get();

  Future<int> insertPlacement({
    required String islandId,
    required String decorId,
    required double x,
    required double y,
    required int rotation,
  }) async {
    return into(islandDecorTable).insert(
      IslandDecorTableCompanion.insert(
        islandId: islandId,
        decorId: decorId,
        x: x,
        y: y,
        rotation: Value(rotation),
      ),
    );
  }

  Future<void> updatePlacement({
    required int rowId,
    required double x,
    required double y,
    required int rotation,
  }) async {
    await (update(islandDecorTable)..where((t) => t.rowId.equals(rowId)))
        .write(IslandDecorTableCompanion(
      x: Value(x),
      y: Value(y),
      rotation: Value(rotation),
    ));
  }

  Future<void> deleteRow(int rowId) async {
    await (delete(islandDecorTable)..where((t) => t.rowId.equals(rowId)))
        .go();
  }

  Future<void> deleteForIsland(String islandId) async {
    await (delete(islandDecorTable)
          ..where((t) => t.islandId.equals(islandId)))
        .go();
  }
}

@DriftAccessor(tables: [FurnitureTable])
class FurnitureDao extends DatabaseAccessor<AppDatabase>
    with _$FurnitureDaoMixin {
  FurnitureDao(super.db);

  Future<List<FurnitureRow>> loadAll() => select(furnitureTable).get();

  Future<void> upsert({
    required String itemId,
    required String slot,
    required bool active,
    required bool hidden,
    double? posX,
    double? posY,
  }) async {
    await into(furnitureTable).insertOnConflictUpdate(
      FurnitureTableCompanion.insert(
        itemId: itemId,
        slot: slot,
        active: Value(active),
        hidden: Value(hidden),
        posX: Value(posX),
        posY: Value(posY),
      ),
    );
  }

  Future<void> deleteItem(String itemId) async {
    await (delete(furnitureTable)..where((t) => t.itemId.equals(itemId)))
        .go();
  }
}

/// Welle-8 Round 24 (#10): Echte Erfolge (Eltern-Modus).
@DriftAccessor(tables: [RealMilestonesTable])
class RealMilestonesDao extends DatabaseAccessor<AppDatabase>
    with _$RealMilestonesDaoMixin {
  RealMilestonesDao(super.db);

  Future<List<RealMilestoneRow>> loadAll() =>
      (select(realMilestonesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.rowId)]))
          .get();

  Future<int> add({
    required String emoji,
    required String title,
    int? amountCents,
    required String dateIso,
    String category = '',
  }) {
    return into(realMilestonesTable).insert(
      RealMilestonesTableCompanion.insert(
        emoji: Value(emoji),
        title: title,
        amountCents: Value(amountCents),
        dateIso: Value(dateIso),
        category: Value(category),
      ),
    );
  }

  Future<void> deleteRow(int rowId) async {
    await (delete(realMilestonesTable)..where((t) => t.rowId.equals(rowId)))
        .go();
  }
}

/// Welle C + Drift v33: Echtes-Sparziel-Persistence.
@DriftAccessor(tables: [RealSavingsGoalsTable])
class RealSavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$RealSavingsGoalsDaoMixin {
  RealSavingsGoalsDao(super.db);

  Future<List<RealSavingsGoalRow>> loadAll() =>
      (select(realSavingsGoalsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.rowId)]))
          .get();

  Future<int> add({
    required String emoji,
    required String title,
    required int targetCents,
    required String createdIso,
  }) {
    return into(realSavingsGoalsTable).insert(
      RealSavingsGoalsTableCompanion.insert(
        emoji: Value(emoji),
        title: title,
        targetCents: targetCents,
        createdIso: Value(createdIso),
      ),
    );
  }

  Future<void> updateProgress({
    required int rowId,
    required int savedCents,
    required String status,
  }) async {
    await (update(realSavingsGoalsTable)..where((t) => t.rowId.equals(rowId)))
        .write(RealSavingsGoalsTableCompanion(
      savedCents: Value(savedCents),
      status: Value(status),
    ));
  }

  Future<void> confirm({
    required int rowId,
    required String confirmedIso,
  }) async {
    await (update(realSavingsGoalsTable)..where((t) => t.rowId.equals(rowId)))
        .write(RealSavingsGoalsTableCompanion(
      status: const Value('confirmed'),
      confirmedIso: Value(confirmedIso),
    ));
  }

  Future<void> deleteRow(int rowId) async {
    await (delete(realSavingsGoalsTable)..where((t) => t.rowId.equals(rowId)))
        .go();
  }
}

@DriftAccessor(tables: [RealEstateHoldingsTable])
class RealEstateDao extends DatabaseAccessor<AppDatabase>
    with _$RealEstateDaoMixin {
  RealEstateDao(super.db);

  Future<List<RealEstateHoldingRow>> loadHoldings() =>
      select(realEstateHoldingsTable).get();

  Future<void> upsert(RealEstateHoldingRow row) async {
    await into(realEstateHoldingsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteHolding(String specId) async {
    await (delete(realEstateHoldingsTable)
          ..where((t) => t.specId.equals(specId)))
        .go();
  }
}

/// spec-36: vorsorge contracts DAO.
@DriftAccessor(tables: [VorsorgeContractsTable])
class VorsorgeDao extends DatabaseAccessor<AppDatabase>
    with _$VorsorgeDaoMixin {
  VorsorgeDao(super.db);

  Future<List<VorsorgeContractRow>> loadAll() =>
      select(vorsorgeContractsTable).get();

  Future<void> upsert(VorsorgeContractRow row) async {
    await into(vorsorgeContractsTable).insertOnConflictUpdate(row);
  }

  Future<void> deleteContract(String type) async {
    await (delete(vorsorgeContractsTable)
          ..where((t) => t.type.equals(type)))
        .go();
  }
}

/// spec-36: savings-plan DAO.
@DriftAccessor(tables: [SavingsPlansTable])
class SavingsPlansDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsPlansDaoMixin {
  SavingsPlansDao(super.db);

  Future<List<SavingsPlanRow>> loadAll() => select(savingsPlansTable).get();

  Future<void> upsert(SavingsPlanRow row) async {
    await into(savingsPlansTable).insertOnConflictUpdate(row);
  }

  Future<void> deletePlan(String id) async {
    await (delete(savingsPlansTable)..where((t) => t.id.equals(id))).go();
  }
}

@DriftAccessor(tables: [AchievementsTable])
class AchievementsDao extends DatabaseAccessor<AppDatabase>
    with _$AchievementsDaoMixin {
  AchievementsDao(super.db);

  Future<List<AchievementRow>> loadAll() => select(achievementsTable).get();

  Future<void> insert(String id, int unlockedOnDayIndex) async {
    await into(achievementsTable).insertOnConflictUpdate(
      AchievementsTableCompanion.insert(
        id: id,
        unlockedOnDayIndex: unlockedOnDayIndex,
      ),
    );
  }
}

@DriftAccessor(tables: [SettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<SettingsRow?> loadRow() async {
    return (select(settingsTable)..where((t) => t.id.equals(0)))
        .getSingleOrNull();
  }

  Future<void> upsert({
    required int allowanceCents,
    required String allowanceWeekday,
    required String playerName,
    required bool soundEnabled,
    required int lastQuizDayIndex,
    required bool zeitreiseTutorialSeen,
    required int musicVolume,
    required int masterVolume,
    required int sfxVolume,
    required int lastSleepEpochMs,
    required int sleepCountInWindow,
    required bool onboardingComplete,
    required String avatarEmoji,
    int streakCount = 0,
    String lastSleepDateIso = '',
    String unlockedAvatars = '',
    String unlockedDecor = '',
    int sparPlotCount = 4,
    String quizLearnedTopics = '',
    String seenCoaches = '',
    int lastWeekNetWorthCents = 0,
    int lastWeeklyReviewDay = -1,
    String recentQuizTexts = '',
    int startAgeYears = 13,
    int savingsRatePct = 0,
    int lastClaimedGoalDay = -1,
    String parentPin = '',
    String unlockedSkills = '',
    int weeklyChallengeClaimedWeek = -1,
    int weeklyChallengeStreak = 0,
    int claimedStreakMilestone = 0,
    bool autoSaveDisabled = false,
    String? backupFolderUri,
    int? birthYear,
    bool birthYearAsked = false,
    int parentGateLockedUntilMs = 0,
  }) async {
    await into(settingsTable).insertOnConflictUpdate(
      SettingsTableCompanion.insert(
        id: const Value(0),
        allowanceCents: Value(allowanceCents),
        allowanceWeekday: Value(allowanceWeekday),
        playerName: Value(playerName),
        soundEnabled: Value(soundEnabled),
        lastQuizDayIndex: Value(lastQuizDayIndex),
        zeitreiseTutorialSeen: Value(zeitreiseTutorialSeen),
        musicVolume: Value(musicVolume),
        masterVolume: Value(masterVolume),
        sfxVolume: Value(sfxVolume),
        lastSleepEpochMs: Value(lastSleepEpochMs),
        sleepCountInWindow: Value(sleepCountInWindow),
        onboardingComplete: Value(onboardingComplete),
        avatarEmoji: Value(avatarEmoji),
        streakCount: Value(streakCount),
        lastSleepDateIso: Value(lastSleepDateIso),
        unlockedAvatars: Value(unlockedAvatars),
        unlockedDecor: Value(unlockedDecor),
        sparPlotCount: Value(sparPlotCount),
        quizLearnedTopics: Value(quizLearnedTopics),
        seenCoaches: Value(seenCoaches),
        lastWeekNetWorthCents: Value(lastWeekNetWorthCents),
        lastWeeklyReviewDay: Value(lastWeeklyReviewDay),
        recentQuizTexts: Value(recentQuizTexts),
        startAgeYears: Value(startAgeYears),
        savingsRatePct: Value(savingsRatePct),
        lastClaimedGoalDay: Value(lastClaimedGoalDay),
        parentPin: Value(parentPin),
        unlockedSkills: Value(unlockedSkills),
        weeklyChallengeClaimedWeek: Value(weeklyChallengeClaimedWeek),
        weeklyChallengeStreak: Value(weeklyChallengeStreak),
        claimedStreakMilestone: Value(claimedStreakMilestone),
        autoSaveDisabled: Value(autoSaveDisabled),
        backupFolderUri: Value(backupFolderUri),
        birthYear: Value(birthYear),
        birthYearAsked: Value(birthYearAsked),
        parentGateLockedUntilMs: Value(parentGateLockedUntilMs),
      ),
    );
  }
}


/// Spec-45 A2 + G4: DAO für persistente Lucky-Event-Historie.
@DriftAccessor(tables: [LuckyEventHistoryTable])
class LuckyEventHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$LuckyEventHistoryDaoMixin {
  LuckyEventHistoryDao(super.db);

  Future<List<LuckyEventRow>> loadAll() =>
      (select(luckyEventHistoryTable)
            ..orderBy([(t) => OrderingTerm.desc(t.dayIndex)]))
          .get();

  Future<int> insertRow({
    required int dayIndex,
    required String title,
    required String description,
    required int amountCents,
    required int taxDeductedCents,
  }) =>
      into(luckyEventHistoryTable).insert(
        LuckyEventHistoryTableCompanion.insert(
          dayIndex: dayIndex,
          title: title,
          description: description,
          amountCents: amountCents,
          taxDeductedCents: Value(taxDeductedCents),
        ),
      );
}

/// Spec-45 G3 + Drift v15: NewGame+ Persistence-DAO.
@DriftAccessor(tables: [NewGameStateTable])
class NewGameDao extends DatabaseAccessor<AppDatabase>
    with _$NewGameDaoMixin {
  NewGameDao(super.db);

  Future<NewGameRow?> load() async =>
      (select(newGameStateTable)..where((t) => t.id.equals(0))).getSingleOrNull();

  Future<void> upsert({
    required int runCount,
    required int pendingInheritanceCents,
    required int pendingBonusXp,
    required int lastRunNetWorthCents,
    required int legacyPoints,
    required String legacyUpgrades,
  }) async {
    await into(newGameStateTable).insertOnConflictUpdate(
      NewGameStateTableCompanion.insert(
        id: const Value(0),
        runCount: Value(runCount),
        pendingInheritanceCents: Value(pendingInheritanceCents),
        pendingBonusXp: Value(pendingBonusXp),
        lastRunNetWorthCents: Value(lastRunNetWorthCents),
        legacyPoints: Value(legacyPoints),
        legacyUpgrades: Value(legacyUpgrades),
      ),
    );
  }
}

/// Spec-45 H3 + Drift v15: Tree-Holdings-DAO.
@DriftAccessor(tables: [TreeHoldingsTable])
class TreeHoldingsDao extends DatabaseAccessor<AppDatabase>
    with _$TreeHoldingsDaoMixin {
  TreeHoldingsDao(super.db);

  Future<List<PlantedTreeRow>> loadAll() => select(treeHoldingsTable).get();

  Future<void> insertTree({
    required String id,
    required String kind,
    required int plantedOnDayIndex,
  }) async {
    await into(treeHoldingsTable).insert(
      TreeHoldingsTableCompanion.insert(
        id: id,
        kind: kind,
        plantedOnDayIndex: plantedOnDayIndex,
      ),
    );
  }

  Future<void> deleteById(String id) async {
    await (delete(treeHoldingsTable)..where((t) => t.id.equals(id))).go();
  }
}

/// Spec-45 C5 + Drift v16: JobAction-DAO.
@DriftAccessor(tables: [JobActionStateTable])
class JobActionDao extends DatabaseAccessor<AppDatabase>
    with _$JobActionDaoMixin {
  JobActionDao(super.db);

  Future<JobActionRow?> load() async =>
      (select(jobActionStateTable)..where((t) => t.id.equals(0)))
          .getSingleOrNull();

  Future<void> upsert({
    required int careerBonusPct,
    required int pauseUntilDay,
    required int nextSwitchAllowedDay,
    required int jobVariantIndex,
  }) async {
    await into(jobActionStateTable).insertOnConflictUpdate(
      JobActionStateTableCompanion.insert(
        id: const Value(0),
        careerBonusPct: Value(careerBonusPct),
        pauseUntilDay: Value(pauseUntilDay),
        nextSwitchAllowedDay: Value(nextSwitchAllowedDay),
        jobVariantIndex: Value(jobVariantIndex),
      ),
    );
  }
}

/// Spec-45 Welle-8 + Drift v16: Quest-Failure-DAO.
@DriftAccessor(tables: [QuestFailureTable])
class QuestFailureDao extends DatabaseAccessor<AppDatabase>
    with _$QuestFailureDaoMixin {
  QuestFailureDao(super.db);

  Future<List<QuestFailRow>> loadAll() => select(questFailureTable).get();

  Future<void> upsert(String questId, int failedOnDayIndex) async {
    await into(questFailureTable).insertOnConflictUpdate(
      QuestFailureTableCompanion.insert(
        questId: questId,
        failedOnDayIndex: failedOnDayIndex,
      ),
    );
  }

  Future<void> deleteOne(String questId) async {
    await (delete(questFailureTable)..where((t) => t.questId.equals(questId)))
        .go();
  }
}
