import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'app_database_provider.g.dart';

/// Lightweight view of [SettingsRow] for [DbSnapshot]. Carries the same
/// defaults as the Drift column constants so tests can fall back without
/// touching the DB.
class SettingsSnapshot {
  const SettingsSnapshot({
    this.allowanceCents = 8000,
    this.allowanceWeekday = 'mon',
    this.playerName = 'Spieler',
    this.soundEnabled = true,
    this.lastQuizDayIndex = -1,
    this.zeitreiseTutorialSeen = false,
    this.musicVolume = 0,
    this.masterVolume = 60,
    this.sfxVolume = 40,
    this.lastSleepEpochMs = 0,
    this.sleepCountInWindow = 0,
    this.onboardingComplete = false,
    this.avatarEmoji = '🧒',
    this.streakCount = 0,
    this.lastSleepDateIso = '',
    this.unlockedAvatars = '',
    this.unlockedDecor = '',
    this.sparPlotCount = 4,
    this.quizLearnedTopics = '',
    this.seenCoaches = '',
    this.lastWeekNetWorthCents = 0,
    this.lastWeeklyReviewDay = -1,
    this.recentQuizTexts = '',
    this.startAgeYears = 13,
    this.savingsRatePct = 0,
    this.lastClaimedGoalDay = -1,
    this.parentPin = '',
    this.unlockedSkills = '',
    this.weeklyChallengeClaimedWeek = -1,
    this.weeklyChallengeStreak = 0,
    this.claimedStreakMilestone = 0,
    this.autoSaveDisabled = false,
    this.backupFolderUri,
    this.birthYear,
    this.birthYearAsked = false,
    this.parentGateLockedUntilMs = 0,
  });

  final int allowanceCents;
  final String allowanceWeekday;
  final String playerName;
  final bool soundEnabled;

  /// Spec-17: last GameClock day on which the daily quiz overlay fired.
  /// -1 = never shown.
  final int lastQuizDayIndex;

  /// Spec-19: whether the Zeitreise tutorial overlay was already dismissed.
  final bool zeitreiseTutorialSeen;

  /// Spec-23: music volume percentage (0..100). Default 25.
  final int musicVolume;

  /// Spec-27: master volume multiplier (0..100). Default 60.
  final int masterVolume;

  /// Spec-27: SFX volume multiplier (0..100). Default 40.
  final int sfxVolume;

  /// Spec-33: sleep anti-glitch tracking.
  final int lastSleepEpochMs;
  final int sleepCountInWindow;

  /// Spec-34: onboarding flow state.
  final bool onboardingComplete;
  final String avatarEmoji;

  /// Spec-40 C: daily-streak persistence.
  final int streakCount;
  final String lastSleepDateIso;

  /// Spec-41 A: komma-separierte Liste freigeschalteter Avatar-Glyphs.
  final String unlockedAvatars;

  /// Spec-43 Stage 1: komma-separierte Liste freigeschalteter Decor-IDs.
  final String unlockedDecor;

  /// Spec-43 follow-up: Anzahl Spar-Insel-Plots (4..10).
  final int sparPlotCount;

  /// Welle-8 Round 14: Quiz-Topics 1× richtig beantwortet (CSV).
  final String quizLearnedTopics;

  /// Welle-8 Round 15: First-Steps-Coach gesehen-IDs (CSV).
  final String seenCoaches;

  /// Welle-8 Round 15: Vermögen-Snapshot vor 7 Spieltagen + Tag des
  /// letzten Wochen-Reviews.
  final int lastWeekNetWorthCents;
  final int lastWeeklyReviewDay;

  /// Welle-8 Round 15: Pipe-separierte Anti-Repeat-Liste der letzten
  /// gezeigten Quiz-Frage-Texte.
  final String recentQuizTexts;

  /// Spec-38 follow-up: Start-Alter aus dem Onboarding. Drift v21:
  /// persistent (war in-memory-only). Default 13.
  final int startAgeYears;

  /// Spec-44 E3: Pay-yourself-first Slider. Drift v23: persistent
  /// (war in-memory-only, sprang bei App-Restart auf 0).
  final int savingsRatePct;

  /// Welle-8 Round 22 / B7: Tag an dem Tagesziel zuletzt gecaimt wurde.
  /// -1 = noch nie. Drift v24.
  final int lastClaimedGoalDay;

  /// Welle-8 Round 23: Eltern-PIN-Lock für Reset/Import. Leer = aus.
  /// Drift v25.
  final String parentPin;

  /// Round 28: freigeschaltete Skill-Baum-Knoten als CSV. Drift v30.
  final String unlockedSkills;

  /// Round 28 v4: Wochen-Herausforderung. Drift v31.
  final int weeklyChallengeClaimedWeek;
  final int weeklyChallengeStreak;
  final int claimedStreakMilestone;

  /// Drift v36: Auto-Sicherung opt-out. false = AN (Default).
  final bool autoSaveDisabled;

  /// Drift v37: SAF-Backup-Ordner-URI. null = kein Ordner gewählt.
  final String? backupFolderUri;

  /// Drift v38: Geburtsjahr der echten Person am Gerät (nur das Jahr).
  /// null = keine Angabe. Steuert die Sichtbarkeit des Unterstützen-Bereichs.
  final int? birthYear;

  /// Drift v38: ob die Geburtsjahr-Frage schon gestellt wurde (einmal pro
  /// Installation).
  final bool birthYearAsked;

  /// Drift v38: Sperre der Eltern-Rechenaufgabe (ms seit Epoch, 0 = frei).
  final int parentGateLockedUntilMs;
}

/// Sync snapshot of all DB tables, populated by [DatabaseWarmup.run] in
/// `main.dart` before `runApp` and consumed by every repository's
/// (synchronous) `build()`.
///
/// Tests that construct a [ProviderContainer] without overrides get the
/// default empty snapshot, so repositories fall back to their seed defaults
/// and the existing 226 tests stay synchronous and green.
class DbSnapshot {
  const DbSnapshot({
    this.dayIndex,
    this.cashCents,
    this.lifetimeHarvestCents,
    this.plants = const [],
    this.etfHoldings = const [],
    this.etfQuotes = const [],
    this.stockHoldings = const [],
    this.stockQuotes = const [],
    this.cryptoHoldings = const [],
    this.cryptoQuotes = const [],
    this.metalHoldings = const [],
    this.metalQuotes = const [],
    this.wishItems = const [],
    this.priceHistory = const [],
    this.unlockedIslands = const [],
    this.questProgress = const {},
    this.settings = const SettingsSnapshot(),
    this.xpTotal,
    this.savingsCents,
    this.achievements = const {},
    this.realEstateHoldings = const [],
    this.collectibleHoldings = const [],
    this.questPassivePayments = const [],
    this.vorsorgeContracts = const [],
    this.savingsPlans = const [],
    this.islandDecor = const [],
    this.furniture = const [],
    this.realMilestones = const [],
    this.realSavingsGoals = const [],
  });

  /// Empty snapshot — repositories will seed from their domain catalogs.
  const DbSnapshot.empty() : this();

  final int? dayIndex;
  final int? cashCents;

  /// Lifetime cents earned from plant harvests. Null when the DB has no
  /// cash row yet — spec-13 ETF-island milestone treats this as 0.
  final int? lifetimeHarvestCents;
  final List<PlantRow> plants;
  final List<EtfHoldingRow> etfHoldings;
  final List<EtfQuoteRow> etfQuotes;
  final List<StockHoldingRow> stockHoldings;
  final List<StockQuoteRow> stockQuotes;

  /// Spec-22: crypto holdings + quotes.
  final List<CryptoHoldingRow> cryptoHoldings;
  final List<CryptoQuoteRow> cryptoQuotes;

  /// Spec-22: metal (Gold/Silber/Platin) holdings + quotes.
  final List<MetalHoldingRow> metalHoldings;
  final List<MetalQuoteRow> metalQuotes;

  final List<WishItemRow> wishItems;
  final List<PriceHistoryRow> priceHistory;

  /// Persisted unlocked island IDs. Empty list means "use default seed"
  /// — see [MonetariaState].
  final List<String> unlockedIslands;

  /// Persisted quest progress keyed by questId. Empty map = no quests
  /// started yet. Chat history is NOT preloaded — see
  /// [QuestProgressRepository.chatHistory] for lazy per-quest read.
  final Map<String, QuestProgressRow> questProgress;

  /// User-tunable settings (spec-15). Defaults match the prior
  /// hard-coded behaviour, so tests without overrides still pass.
  final SettingsSnapshot settings;

  /// Spec-21: lifetime XP total. Null = no row yet, treat as 0.
  final int? xpTotal;

  /// Spec-21: savings (Spar) account balance in cents. Null = no row yet,
  /// treat as 0.
  final int? savingsCents;

  /// Spec-21: unlocked achievement IDs keyed by id → day-index they were
  /// unlocked. Empty map = none unlocked yet.
  final Map<String, int> achievements;

  /// spec-35 phase B: real-estate holdings.
  final List<RealEstateHoldingRow> realEstateHoldings;

  /// Spec-38 Welle 5: collectible holdings.
  final List<CollectibleHoldingRow> collectibleHoldings;

  /// Spec-42 Welle 6: quest-passive-payment queue.
  final List<QuestPassiveRow> questPassivePayments;

  /// spec-36: signed vorsorge contracts (Bausparer/Riester/…).
  final List<VorsorgeContractRow> vorsorgeContracts;

  /// spec-36: active savings-plan entries (DCA).
  final List<SavingsPlanRow> savingsPlans;

  /// Spec-43 Stage 1: persisted decor placements.
  final List<IslandDecorRow> islandDecor;

  /// Welle-8: persistierte Zimmer-Möbel (Besitz + aktiv/Position/sichtbar).
  final List<FurnitureRow> furniture;

  /// Welle-8 Round 24 (#10): echte Erfolge (Eltern-Modus), neueste zuerst.
  final List<RealMilestoneRow> realMilestones;

  /// Welle C: echte Sparziele des Kindes, neueste zuerst.
  final List<RealSavingsGoalRow> realSavingsGoals;
}

/// In-memory DB by default. Production overrides this with a file-backed DB
/// in `main.dart`. The provider owns the connection lifecycle.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.memory();
  ref.onDispose(db.close);
  return db;
}

/// DB snapshot loaded once at startup. Default = empty (tests + cold start).
/// Production main pre-warms and overrides this with real values before
/// runApp.
@Riverpod(keepAlive: true)
DbSnapshot dbSnapshot(Ref ref) => const DbSnapshot.empty();

/// Reads every table once and assembles a [DbSnapshot]. Call before
/// runApp so the first frame has all repositories pre-warmed.
Future<DbSnapshot> loadDbSnapshot(AppDatabase db) async {
  final cashRow = await db.cashDao.loadRow();
  final settingsRow = await db.settingsDao.loadRow();
  final xpTotal = await db.xpDao.loadTotal();
  final savingsCents = await db.savingsDao.loadCents();
  final achievementRows = await db.achievementsDao.loadAll();
  final results = await Future.wait([
    db.gameClockDao.loadDayIndex(),
    db.plantsDao.loadAll(),
    db.etfDao.loadHoldings(),
    db.etfDao.loadQuotes(),
    db.stockDao.loadHoldings(),
    db.stockDao.loadQuotes(),
    db.cryptoDao.loadHoldings(),
    db.cryptoDao.loadQuotes(),
    db.metalDao.loadHoldings(),
    db.metalDao.loadQuotes(),
    db.wishItemsDao.loadAll(),
    db.priceHistoryDao.loadAll(),
    db.unlockedIslandsDao.loadAll(),
    db.questProgressDao.loadAll(),
    db.realEstateDao.loadHoldings(),
    db.vorsorgeDao.loadAll(),
    db.savingsPlansDao.loadAll(),
    db.collectibleDao.loadAll(),
    db.questPassiveDao.loadAll(),
    db.islandDecorDao.loadAll(),
    db.furnitureDao.loadAll(),
    db.realMilestonesDao.loadAll(),
    db.realSavingsGoalsDao.loadAll(),
  ]);
  final questRows = results[13] as List<QuestProgressRow>;
  return DbSnapshot(
    dayIndex: results[0] as int?,
    cashCents: cashRow?.cents,
    lifetimeHarvestCents: cashRow?.plantHarvestTotalCents,
    plants: results[1] as List<PlantRow>,
    etfHoldings: results[2] as List<EtfHoldingRow>,
    etfQuotes: results[3] as List<EtfQuoteRow>,
    stockHoldings: results[4] as List<StockHoldingRow>,
    stockQuotes: results[5] as List<StockQuoteRow>,
    cryptoHoldings: results[6] as List<CryptoHoldingRow>,
    cryptoQuotes: results[7] as List<CryptoQuoteRow>,
    metalHoldings: results[8] as List<MetalHoldingRow>,
    metalQuotes: results[9] as List<MetalQuoteRow>,
    wishItems: results[10] as List<WishItemRow>,
    priceHistory: results[11] as List<PriceHistoryRow>,
    unlockedIslands: results[12] as List<String>,
    questProgress: {for (final r in questRows) r.questId: r},
    realEstateHoldings:
        results[14] as List<RealEstateHoldingRow>,
    vorsorgeContracts: results[15] as List<VorsorgeContractRow>,
    savingsPlans: results[16] as List<SavingsPlanRow>,
    collectibleHoldings:
        results[17] as List<CollectibleHoldingRow>,
    questPassivePayments: results[18] as List<QuestPassiveRow>,
    islandDecor: results[19] as List<IslandDecorRow>,
    furniture: results[20] as List<FurnitureRow>,
    realMilestones: results[21] as List<RealMilestoneRow>,
    realSavingsGoals: results[22] as List<RealSavingsGoalRow>,
    settings: settingsRow == null
        ? const SettingsSnapshot()
        : SettingsSnapshot(
            allowanceCents: settingsRow.allowanceCents,
            allowanceWeekday: settingsRow.allowanceWeekday,
            playerName: settingsRow.playerName,
            soundEnabled: settingsRow.soundEnabled,
            lastQuizDayIndex: settingsRow.lastQuizDayIndex,
            zeitreiseTutorialSeen: settingsRow.zeitreiseTutorialSeen,
            musicVolume: settingsRow.musicVolume,
            masterVolume: settingsRow.masterVolume,
            sfxVolume: settingsRow.sfxVolume,
            lastSleepEpochMs: settingsRow.lastSleepEpochMs,
            sleepCountInWindow: settingsRow.sleepCountInWindow,
            onboardingComplete: settingsRow.onboardingComplete,
            avatarEmoji: settingsRow.avatarEmoji,
            streakCount: settingsRow.streakCount,
            lastSleepDateIso: settingsRow.lastSleepDateIso,
            unlockedAvatars: settingsRow.unlockedAvatars,
            unlockedDecor: settingsRow.unlockedDecor,
            sparPlotCount: settingsRow.sparPlotCount,
            quizLearnedTopics: settingsRow.quizLearnedTopics,
            seenCoaches: settingsRow.seenCoaches,
            lastWeekNetWorthCents: settingsRow.lastWeekNetWorthCents,
            lastWeeklyReviewDay: settingsRow.lastWeeklyReviewDay,
            recentQuizTexts: settingsRow.recentQuizTexts,
            startAgeYears: settingsRow.startAgeYears,
            savingsRatePct: settingsRow.savingsRatePct,
            lastClaimedGoalDay: settingsRow.lastClaimedGoalDay,
            parentPin: settingsRow.parentPin,
            unlockedSkills: settingsRow.unlockedSkills,
            weeklyChallengeClaimedWeek:
                settingsRow.weeklyChallengeClaimedWeek,
            weeklyChallengeStreak: settingsRow.weeklyChallengeStreak,
            claimedStreakMilestone: settingsRow.claimedStreakMilestone,
            autoSaveDisabled: settingsRow.autoSaveDisabled,
            backupFolderUri: settingsRow.backupFolderUri,
            birthYear: settingsRow.birthYear,
            birthYearAsked: settingsRow.birthYearAsked,
            parentGateLockedUntilMs:
                settingsRow.parentGateLockedUntilMs,
          ),
    xpTotal: xpTotal,
    savingsCents: savingsCents,
    achievements: {for (final r in achievementRows) r.id: r.unlockedOnDayIndex},
  );
}
