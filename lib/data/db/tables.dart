import 'package:drift/drift.dart';

/// Singleton row holding the current GameClock day index.
/// PK = 0 (only one row).
@DataClassName('GameClockRow')
class GameClockTable extends Table {
  IntColumn get id => integer()();
  IntColumn get dayIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Singleton row for player cash balance in cents.
///
/// Also tracks lifetime stats keyed off the same singleton row:
/// - [plantHarvestTotalCents]: total cents earned from plant harvests
///   (only grows, used as ETF-island unlock milestone). Spec-13.
@DataClassName('CashRow')
class CashTable extends Table {
  IntColumn get id => integer()();
  IntColumn get cents => integer().withDefault(const Constant(5000))();
  IntColumn get plantHarvestTotalCents =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per unlocked island (PK = islandId).
///
/// Absence of a row means the island is still locked. Default seed
/// (`heimathafen`, `spar_insel`) is applied by [MonetariaState] on first
/// build when the snapshot is empty.
@DataClassName('UnlockedIslandRow')
class UnlockedIslandsTable extends Table {
  TextColumn get islandId => text()();

  @override
  Set<Column<Object>> get primaryKey => {islandId};
}

/// One row per plant in the world.
@DataClassName('PlantRow')
class PlantsTable extends Table {
  TextColumn get id => text()();
  TextColumn get islandId => text()();
  IntColumn get plotIndex => integer()();
  TextColumn get kind => text()();
  IntColumn get plantedOnDayIndex => integer()();
  IntColumn get currentStage => integer().withDefault(const Constant(0))();
  // spec-18: tenth-precision growth progress. stage = progress ~/ 10.
  IntColumn get growthProgress =>
      integer().withDefault(const Constant(0))();
  TextColumn get status =>
      text().withDefault(const Constant('growing'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ETF holdings keyed by etfId.
@DataClassName('EtfHoldingRow')
class EtfHoldingsTable extends Table {
  TextColumn get etfId => text()();
  IntColumn get shares => integer()();
  IntColumn get averageBuyPriceCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {etfId};
}

/// Current ETF price per share.
@DataClassName('EtfQuoteRow')
class EtfQuotesTable extends Table {
  TextColumn get etfId => text()();
  IntColumn get pricePerShareCents => integer()();
  IntColumn get onDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {etfId};
}

/// Stock holdings keyed by stockId.
@DataClassName('StockHoldingRow')
class StockHoldingsTable extends Table {
  TextColumn get stockId => text()();
  IntColumn get shares => integer()();
  IntColumn get averageBuyPriceCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {stockId};
}

/// Current stock price per share.
@DataClassName('StockQuoteRow')
class StockQuotesTable extends Table {
  TextColumn get stockId => text()();
  IntColumn get pricePerShareCents => integer()();
  IntColumn get onDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {stockId};
}

/// Spec-22: Crypto holdings keyed by assetId (e.g. `crypto_rugcoin`).
@DataClassName('CryptoHoldingRow')
class CryptoHoldingsTable extends Table {
  TextColumn get assetId => text()();
  IntColumn get shares => integer()();
  IntColumn get averageBuyPriceCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {assetId};
}

/// Spec-22: current crypto price per share.
@DataClassName('CryptoQuoteRow')
class CryptoQuotesTable extends Table {
  TextColumn get assetId => text()();
  IntColumn get pricePerShareCents => integer()();
  IntColumn get onDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {assetId};
}

/// Spec-22: Metal (Gold/Silber/Platin) holdings keyed by assetId.
@DataClassName('MetalHoldingRow')
class MetalHoldingsTable extends Table {
  TextColumn get assetId => text()();
  IntColumn get shares => integer()();
  IntColumn get averageBuyPriceCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {assetId};
}

/// Spec-22: current metal price per share.
@DataClassName('MetalQuoteRow')
class MetalQuotesTable extends Table {
  TextColumn get assetId => text()();
  IntColumn get pricePerShareCents => integer()();
  IntColumn get onDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {assetId};
}

/// Spec-42 Welle 6: Quest-Passiv-Einkommen-Queue. Eine Zeile pro
/// laufender Auszahlungs-Reihe (12 Monate). Wird pro Day-Tick geprüft.
@DataClassName('QuestPassiveRow')
class QuestPassivePaymentsTable extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get questId => text()();
  IntColumn get monthsRemaining => integer()();
  IntColumn get monthlyCents => integer()();
  IntColumn get lastPaidDayIndex => integer()();
}

/// Spec-43 Stage 1: per-island decor placement (Möbel/Deko auf Inseln).
/// Eine Zeile pro platziertem Item. Position normalisiert (0..1).
@DataClassName('IslandDecorRow')
class IslandDecorTable extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get islandId => text()();
  TextColumn get decorId => text()();
  RealColumn get x => real()();
  RealColumn get y => real()();
  IntColumn get rotation => integer().withDefault(const Constant(0))();
}

/// Welle-8: Möbel im Zimmer. Eine Zeile pro gekauftem Item. Persistiert
/// Besitz + welches Item pro Slot aktiv ist + User-Position + Sichtbarkeit.
/// Vorher in-memory-only → ging bei App-Neustart verloren (Sohn-Bug:
/// "Stuhl weg nach Spiel verlassen").
@DataClassName('FurnitureRow')
class FurnitureTable extends Table {
  TextColumn get itemId => text()();
  TextColumn get slot => text()();
  BoolColumn get active => boolean().withDefault(const Constant(false))();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
  RealColumn get posX => real().nullable()();
  RealColumn get posY => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {itemId};
}

/// Spec-45 A2 + G4: Lucky-Event Historie. Eine Zeile pro empfangenes
/// Glücks-/Pech-Event mit Title, Cash-Delta + Steuer-Abzug + Tag-Index.
/// Wird für Bank-History-Tab + Ruhestand-Top-3 ausgelesen.
@DataClassName('LuckyEventRow')
class LuckyEventHistoryTable extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  IntColumn get dayIndex => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  /// Netto-Cash-Delta in Cents (positiv = Einnahme, negativ = Ausgabe).
  IntColumn get amountCents => integer()();
  /// Bei Schenkungen über Freibetrag: einbehaltene Schenkungsteuer.
  IntColumn get taxDeductedCents => integer().withDefault(const Constant(0))();
}

/// Spec-45 G3 + Drift v15: NewGame+ Singleton State.
/// runCount + pending boni für Onboarding nach Reset.
@DataClassName('NewGameRow')
class NewGameStateTable extends Table {
  IntColumn get id => integer()(); // singleton, immer 0
  IntColumn get runCount => integer().withDefault(const Constant(0))();
  IntColumn get pendingInheritanceCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get pendingBonusXp => integer().withDefault(const Constant(0))();
  IntColumn get lastRunNetWorthCents =>
      integer().withDefault(const Constant(0))();

  /// Welle B (Drift v32): Vermächtnis-Prestige. Über alle Runs gesammelte
  /// Legacy-Punkte (permanent) + gekaufte Vermächtnis-Upgrades (CSV).
  IntColumn get legacyPoints => integer().withDefault(const Constant(0))();
  TextColumn get legacyUpgrades => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Spec-45 H3 + Drift v15: Wald-Wirtschaft Persistence.
/// 1 Row pro gepflanzten Baum auf Mischwald-Insel.
@DataClassName('PlantedTreeRow')
class TreeHoldingsTable extends Table {
  TextColumn get id => text()();
  /// Stores TreeKind.name (birke/eiche/pinie).
  TextColumn get kind => text()();
  IntColumn get plantedOnDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Spec-45 C5 + Drift v16: Job-Action Singleton-State.
@DataClassName('JobActionRow')
class JobActionStateTable extends Table {
  IntColumn get id => integer()(); // singleton 0
  IntColumn get careerBonusPct =>
      integer().withDefault(const Constant(0))();
  IntColumn get pauseUntilDay =>
      integer().withDefault(const Constant(-1))();
  // Drift v35: Anti-Glitch-Cooldown — frühester Tag für nächsten
  // Job-Wechsel (-1 = sofort erlaubt). Verhindert +5%-Farming.
  IntColumn get nextSwitchAllowedDay =>
      integer().withDefault(const Constant(-1))();
  // Drift v35: rotiert pro Wechsel durch den fiktiven Titel-Pool.
  IntColumn get jobVariantIndex =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Spec-45 Welle-8 + Drift v16: Quest-Fail-Cooldown Persistence.
@DataClassName('QuestFailRow')
class QuestFailureTable extends Table {
  TextColumn get questId => text()();
  IntColumn get failedOnDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {questId};
}

/// Spec-38 Welle 5: collectible holdings (Oldtimer/Diamanten/Gemälde).
/// Mehrere Exemplare pro specId möglich, deshalb auto-increment row-id als PK.
@DataClassName('CollectibleHoldingRow')
class CollectibleHoldingsTable extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get specId => text()();
  IntColumn get boughtAtDayIndex => integer()();
  IntColumn get boughtPriceCents => integer()();
}

/// spec-35 phase B: real-estate holdings. One row per owned property
/// (1 unit each — sell-or-keep semantics).
@DataClassName('RealEstateHoldingRow')
class RealEstateHoldingsTable extends Table {
  TextColumn get specId => text()();
  IntColumn get ownedSinceDayIndex => integer()();
  IntColumn get purchasePriceCents => integer()();

  /// Drift v39: "selfOccupied" oder "rented" (RealEstateUsage.name).
  /// Selbst bewohnt = keine Miete, dafuer entfaellt der Miet-Anteil der
  /// Lebenskosten. Default "rented", damit Bestaende aus aelteren
  /// Spielstaenden nicht ploetzlich Lebenskosten sparen.
  TextColumn get usage => text().withDefault(const Constant('rented'))();

  @override
  Set<Column<Object>> get primaryKey => {specId};
}

/// spec-36: vorsorge contracts. One row per signed contract type.
@DataClassName('VorsorgeContractRow')
class VorsorgeContractsTable extends Table {
  /// Stores VorsorgeType.name (`bausparer`, `riester`, …).
  TextColumn get type => text()();
  IntColumn get startedOnDayIndex => integer()();
  IntColumn get totalContributedCents => integer()();
  IntColumn get totalSubsidyCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {type};
}

/// spec-36: ETF-Sparplan entries. Pro Eintrag: Asset-Klasse + Asset-ID +
/// monatlicher Betrag.
@DataClassName('SavingsPlanRow')
class SavingsPlansTable extends Table {
  /// Internal id (uuid-ish). Allows multiple plans per asset.
  TextColumn get id => text()();
  TextColumn get assetClass => text()(); // 'etf', 'stock', 'crypto'
  TextColumn get assetId => text()();
  IntColumn get monthlyCents => integer()();
  IntColumn get startedOnDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Wishlist item state. id PK, currentPriceCents drifts via inflation,
/// ownedOnDayIndex is null until purchased.
@DataClassName('WishItemRow')
class WishItemsTable extends Table {
  TextColumn get id => text()();
  IntColumn get currentPriceCents => integer()();
  IntColumn get ownedOnDayIndex => integer().nullable()();
  /// Welle-8 Round 16: optional User-Foto-Pfad (absolute Datei-Pfad im
  /// app-support dir). Null = Default-Emoji rendern.
  TextColumn get photoPath => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Per-asset price history. Composite PK (assetId, dayIndex).
@DataClassName('PriceHistoryRow')
class PriceHistoryTable extends Table {
  TextColumn get assetId => text()();
  IntColumn get dayIndex => integer()();
  IntColumn get priceCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {assetId, dayIndex};
}

/// Per-quest progress row. PK = questId. status = 'running' | 'completed'.
/// Absence of a row = quest never started.
@DataClassName('QuestProgressRow')
class QuestProgressTable extends Table {
  TextColumn get questId => text()();
  IntColumn get currentStepIndex => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  IntColumn get startedOnDayIndex => integer().nullable()();
  IntColumn get completedOnDayIndex => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {questId};
}

/// Append-only chat log per quest. (questId, orderIndex) is the logical
/// order; id is just a surrogate PK. payloadJson is the full [ChatEntry]
/// JSON; kind mirrors the union tag for cheap filtering/debugging.
@DataClassName('QuestChatEntryRow')
class QuestChatEntriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get questId => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get kind => text()();
  TextColumn get payloadJson => text()();
}

/// Singleton row holding the player's lifetime XP total (spec-21).
/// PK = 0 (only one row).
@DataClassName('XpRow')
class XpTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get total => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Singleton row for the savings (Spar) account balance in cents (spec-21).
/// PK = 0.
@DataClassName('SavingsRow')
class SavingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get cents => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// One row per unlocked achievement (spec-21).
@DataClassName('AchievementRow')
class AchievementsTable extends Table {
  TextColumn get id => text()();
  IntColumn get unlockedOnDayIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Welle-8 Round 24 (#10): Echte Erfolge, die der Vater im Eltern-Modus
/// (PIN-geschützt) einträgt — reale Spar-/Lern-Meilensteine des Kindes.
/// Werden in der Zimmer-Trophäenwand als eigene Reihe „Echte Erfolge
/// (von Papa)" angezeigt. Verbindet Spiel-Lernen mit echtem Verhalten.
/// Drift v26.
@DataClassName('RealMilestoneRow')
class RealMilestonesTable extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get emoji => text().withDefault(const Constant('💰'))();
  TextColumn get title => text()();

  /// Optionaler €-Betrag in Cents. Null = kein Betrag.
  IntColumn get amountCents => integer().nullable()();

  /// Eintrags-Datum als DD.MM.YYYY-String.
  TextColumn get dateIso => text().withDefault(const Constant(''))();

  /// Welle-8 Round 26: Kategorie (sparen/lernen/verzicht/sonstiges). Leer
  /// bei Alt-Einträgen. Drift v27.
  TextColumn get category => text().withDefault(const Constant(''))();
}

/// Welle C (Drift v33): Echtes-Sparziel-Begleiter.
/// Das Kind setzt ein reales Sparziel (Titel + Zielbetrag), trägt Fortschritt
/// ein; wenn erreicht, bestätigen die Eltern per PIN → In-Game-Belohnung.
/// Brücke zwischen echtem Sparen und dem Spiel. Mehrere Ziele über die Zeit
/// → autoIncrement row-id.
@DataClassName('RealSavingsGoalRow')
class RealSavingsGoalsTable extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get emoji => text().withDefault(const Constant('🐷'))();
  TextColumn get title => text()();
  IntColumn get targetCents => integer()();
  IntColumn get savedCents => integer().withDefault(const Constant(0))();

  /// active | reached | confirmed.
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get createdIso => text().withDefault(const Constant(''))();
  TextColumn get confirmedIso => text().withDefault(const Constant(''))();
}

/// Singleton row holding user-tunable settings (spec-15).
///
/// PK = 0. Defaults match the prior hard-coded values:
/// - allowanceCents = 2000  (20 € matches [AllowanceListener.defaultAmount])
/// - allowanceWeekday = 'mon'
/// - playerName = 'Spieler'
/// - soundEnabled = true
@DataClassName('SettingsRow')
class SettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get allowanceCents => integer().withDefault(const Constant(8000))();
  TextColumn get allowanceWeekday =>
      text().withDefault(const Constant('mon'))();
  TextColumn get playerName =>
      text().withDefault(const Constant('Spieler'))();
  BoolColumn get soundEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Spec-17: index of the last GameClock day on which the daily quiz was
  /// shown. -1 = never shown. Used to gate the once-per-day overlay.
  IntColumn get lastQuizDayIndex =>
      integer().withDefault(const Constant(-1))();

  /// Spec-19: tracks whether the Zeitreise tutorial overlay has already
  /// been shown + dismissed. Default false = show on first open.
  BoolColumn get zeitreiseTutorialSeen =>
      boolean().withDefault(const Constant(false))();

  /// Spec-23: music volume in percent (0..100). Default 25 — Sohn-Tag-2
  /// feedback: music at full volume is "nervig". Applied to the
  /// AudioPlayer at startMusic + on slider change.
  // spec-32: music defaults to OFF — Sohn-Feedback Tag 3, der mitgelieferte
  // Loop ist „schrecklich". Bleibt opt-in im Settings-Slider.
  IntColumn get musicVolume =>
      integer().withDefault(const Constant(0))();

  /// Spec-27: master multiplier (0..100). Defaults to 60.
  IntColumn get masterVolume =>
      integer().withDefault(const Constant(60))();

  /// Spec-27: SFX-category multiplier (0..100). Defaults to 40.
  IntColumn get sfxVolume =>
      integer().withDefault(const Constant(40))();

  /// Spec-33: anti-glitch — millisecond epoch of the most recent
  /// real-world sleep action plus a counter of sleeps within the current
  /// 8-hour window. Used to escalate cost and enforce a cooldown.
  IntColumn get lastSleepEpochMs =>
      integer().withDefault(const Constant(0))();
  IntColumn get sleepCountInWindow =>
      integer().withDefault(const Constant(0))();

  /// Spec-34: onboarding flag + avatar emoji selected during first-run.
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  TextColumn get avatarEmoji =>
      text().withDefault(const Constant('🧒'))();

  /// Spec-40 C: Daily-Streak — Anzahl konsekutiver Real-Tage mit
  /// mindestens einer Schlaf-Aktion.
  IntColumn get streakCount => integer().withDefault(const Constant(0))();

  /// Letzter Schlaf-Real-Tag als YYYY-MM-DD-String. Empty bei null.
  TextColumn get lastSleepDateIso =>
      text().withDefault(const Constant(''))();

  /// Spec-41 A: freigeschaltete Avatar-Glyphs als komma-separierte Liste
  /// (z.B. "🦸,🐱"). Default-Glyph 🧒 ist immer implicit-unlocked.
  TextColumn get unlockedAvatars =>
      text().withDefault(const Constant(''))();

  /// Spec-43 Stage 1: freigeschaltete Decor-Items als CSV (decorId).
  TextColumn get unlockedDecor =>
      text().withDefault(const Constant(''))();

  /// Round 28: freigeschaltete Skill-Baum-Knoten als CSV (skillId). Pro
  /// Level 1 Skill-Punkt; verfügbar = Level − Anzahl freigeschaltet.
  TextColumn get unlockedSkills =>
      text().withDefault(const Constant(''))();

  /// Round 28 v4: Wochen-Herausforderung. Zuletzt eingelöste Spielwoche
  /// (`dayIndex ~/ 7`); -1 = noch keine. + Streak aufeinanderfolgender
  /// eingelöster Wochen.
  IntColumn get weeklyChallengeClaimedWeek =>
      integer().withDefault(const Constant(-1))();
  IntColumn get weeklyChallengeStreak =>
      integer().withDefault(const Constant(0))();

  /// Optionen-Backlog #2 (Drift v34): höchste bereits ausgezahlte Streak-
  /// Meilenstein-Schwelle (7/14/30/100). 0 = noch keine. Lifetime-Guard
  /// gegen Farming (Streak brechen + neu aufbauen zahlt nicht erneut).
  IntColumn get claimedStreakMilestone =>
      integer().withDefault(const Constant(0))();

  /// Drift v36: Auto-Sicherung nach Download/Finanzgame/ ist standardmäßig
  /// AN. Diese Spalte speichert das manuelle Ausschalten (opt-out) → `false`
  /// = AN (Default), `true` = vom Nutzer deaktiviert.
  BoolColumn get autoSaveDisabled =>
      boolean().withDefault(const Constant(false))();

  /// Drift v37: Storage-Access-Framework Tree-URI des vom Nutzer gewählten
  /// Backup-Ordners. Null = kein Ordner gewählt — dann schreibt der Auto-Save
  /// auf Android 11+ nirgendwohin mehr, seit MANAGE_EXTERNAL_STORAGE nicht
  /// mehr deklariert ist. Überlebt App-Neustart, NICHT Deinstall (die
  /// DB wird mit deinstalliert) — nach Reinstall wählt der Nutzer neu.
  TextColumn get backupFolderUri => text().nullable()();

  /// Drift v38 — Altersstatus für den Unterstützen-Bereich.
  ///
  /// Gespeichert wird AUSSCHLIESSLICH das Geburtsjahr, kein volles Datum und
  /// kein Name. Das reicht für die Unterscheidung volljährig/minderjährig und
  /// ist das Minimum an Angabe, das die Google-Familienrichtlinie für einen
  /// Weg aus der App zu einem Zahlungsanbieter verlangt. Null = noch nicht
  /// angegeben (der Nutzer darf die Frage überspringen).
  ///
  /// NICHT zu verwechseln mit `startAgeYears`: das ist das Start-Alter der
  /// SPIELFIGUR (steuert Job-Level, Lebenskosten, Versicherungsprämien).
  /// Hier geht es um die echte Person am Gerät.
  IntColumn get birthYear => integer().nullable()();

  /// Ob die Geburtsjahr-Frage schon einmal gestellt wurde. Sie wird pro
  /// Installation genau einmal gezeigt — wer sie überspringt, wird nicht bei
  /// jedem Start erneut gefragt.
  BoolColumn get birthYearAsked =>
      boolean().withDefault(const Constant(false))();

  /// Zeitstempel (ms seit Epoch), bis zu dem die Eltern-Rechenaufgabe
  /// gesperrt ist. Persistiert, damit die Sperre einen App-Neustart übersteht
  /// — sonst wäre sie mit einem Wisch aus dem Task-Switcher weg.
  IntColumn get parentGateLockedUntilMs =>
      integer().withDefault(const Constant(0))();

  /// Spec-43 follow-up: Anzahl Pflanz-Plots auf der Sparinsel.
  /// Default 4, kaufbar bis max 10 via XP.
  IntColumn get sparPlotCount =>
      integer().withDefault(const Constant(4))();

  /// Welle-8 Round 14: Quiz-Topics die der Spieler korrekt beantwortet
  /// hat (1. Versuch). Komma-separiert. Erweitert learnedTopicsProvider
  /// — Glossar markiert auch via Quiz gelernte Begriffe als gelernt.
  TextColumn get quizLearnedTopics =>
      text().withDefault(const Constant(''))();

  /// Welle-8 Round 15: First-Steps-Coach gesehen-IDs (CSV). Pro Screen
  /// ein Eintrag (z.B. "bank,etf,krypto") — Overlay verschwindet
  /// dauerhaft sobald getippt.
  TextColumn get seenCoaches =>
      text().withDefault(const Constant(''))();

  /// Welle-8 Round 15: Wochen-Rückblick — Vermögen vor 7 Spieltagen +
  /// letzter dayIndex bei dem Review angezeigt wurde.
  IntColumn get lastWeekNetWorthCents =>
      integer().withDefault(const Constant(0))();
  IntColumn get lastWeeklyReviewDay =>
      integer().withDefault(const Constant(-1))();

  /// Welle-8 Round 15: zuletzt gezeigte Quiz-Frage-Texte. Pipe-separiert
  /// (Quiz-Texte enthalten Kommas → Separator '|'). Anti-Repeat-Fenster.
  TextColumn get recentQuizTexts =>
      text().withDefault(const Constant(''))();

  /// Spec-38 follow-up: Start-Alter aus dem Onboarding. Default 13.
  /// Drift v21: bisher in-memory-only — ging bei jedem App-Neustart
  /// verloren (Alter fiel auf 13 zurück, verfälschte Job/Lebenskosten/
  /// age-gated Vorsorge). Jetzt persistent.
  IntColumn get startAgeYears =>
      integer().withDefault(const Constant(13))();

  /// Spec-44 E3 (Pay-yourself-first): Slider-Wert 0..100. Drift v23:
  /// vorher in-memory-only — Slider sprang bei App-Restart auf 0.
  IntColumn get savingsRatePct =>
      integer().withDefault(const Constant(0))();

  /// Welle-8 Round 22 / B7: Tag an dem das Tagesziel zuletzt gecaimt
  /// wurde. -1 = noch nie. Drift v24: war in-memory-only → Banner kam
  /// nach App-Restart wieder + claimbar.
  IntColumn get lastClaimedGoalDay =>
      integer().withDefault(const Constant(-1))();

  /// Welle-8 Round 23: Eltern-PIN (4-stellig). Leer = kein Lock.
  /// Schützt Reset, Import, Auto-Save-Erzwingen vor versehentlichem
  /// Wipe durch Kind. Plain-Text — keine Security-Critical-Daten,
  /// nur UX-Schutz. Drift v25.
  TextColumn get parentPin =>
      text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
