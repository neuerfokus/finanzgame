import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';
import 'weather.dart';

part 'day_event.freezed.dart';
part 'day_event.g.dart';

/// Sealed union of all events that can occur during a single game day.
///
/// Listeners emit these; the [GameClock] collects them into [DaySummary].
/// No listener mutates state — events are the only output.
///
/// JSON round-trip uses a `"type"` discriminator field, e.g.:
/// `{ "type": "allowance", "amount": { "cents": 2000 } }`.
@Freezed(unionKey: 'type')
sealed class DayEvent with _$DayEvent {
  /// Weekly allowance transferred to the player's cash account.
  @FreezedUnionValue('allowance')
  const factory DayEvent.allowance({
    @MoneyConverter() required Money amount,
  }) = AllowanceEvent;

  /// Interest credited to a savings account.
  @FreezedUnionValue('interest')
  const factory DayEvent.interest({
    @MoneyConverter() required Money amount,
    required String accountId,
  }) = InterestEvent;

  /// A plant advances one growth stage.
  @FreezedUnionValue('plantGrowth')
  const factory DayEvent.plantGrowth({
    required String plantId,
    required int newStage,
  }) = PlantGrowthEvent;

  /// A plant has reached maturity and is ready for harvest.
  @FreezedUnionValue('plantReady')
  const factory DayEvent.plantReady({
    required String plantId,
  }) = PlantReadyEvent;

  /// A ready plant was destroyed by a storm. Spec-18. No harvest.
  @FreezedUnionValue('plantWither')
  const factory DayEvent.plantWither({
    required String plantId,
  }) = PlantWitherEvent;

  /// A plant was harvested (auto-harvest or triggered by player).
  @FreezedUnionValue('harvest')
  const factory DayEvent.harvest({
    required String plantId,
    @MoneyConverter() required Money harvestYield,
  }) = HarvestEvent;

  /// General price inflation applied to a set of items.
  @FreezedUnionValue('inflation')
  const factory DayEvent.inflation({
    required double rate,
    required List<String> affectedItemIds,
  }) = InflationEvent;

  /// Weather rolled for an island.
  @FreezedUnionValue('weather')
  const factory DayEvent.weather({
    required String islandId,
    required Weather kind,
  }) = WeatherEvent;

  /// One ETF's price changed at end-of-day.
  @FreezedUnionValue('etfPriceUpdate')
  const factory DayEvent.etfPriceUpdate({
    required String etfId,
    @MoneyConverter() required Money newPrice,
    required double deltaPct,
  }) = EtfPriceUpdateEvent;

  /// One stock's price changed at end-of-day.
  @FreezedUnionValue('stockPriceUpdate')
  const factory DayEvent.stockPriceUpdate({
    required String stockId,
    @MoneyConverter() required Money newPrice,
    required double deltaPct,
  }) = StockPriceUpdateEvent;

  /// Spec-22: one crypto coin's price changed at end-of-day.
  @FreezedUnionValue('cryptoPriceUpdate')
  const factory DayEvent.cryptoPriceUpdate({
    required String assetId,
    @MoneyConverter() required Money newPrice,
    required double deltaPct,
  }) = CryptoPriceUpdateEvent;

  /// Spec-22: one precious metal's price changed at end-of-day.
  @FreezedUnionValue('metalPriceUpdate')
  const factory DayEvent.metalPriceUpdate({
    required String assetId,
    @MoneyConverter() required Money newPrice,
    required double deltaPct,
  }) = MetalPriceUpdateEvent;

  /// Market crash from the Vulkan-Insel. Hits all stocks + ETFs by `dropPct`.
  @FreezedUnionValue('crash')
  const factory DayEvent.crash({
    required double dropPct,
    required List<String> affectedAssetIds,
  }) = CrashEvent;

  /// Annual birthday gift.
  @FreezedUnionValue('birthday')
  const factory DayEvent.birthday({
    @MoneyConverter() required Money giftAmount,
  }) = BirthdayEvent;

  /// A fictional consumer item surfaces as a temptation.
  @FreezedUnionValue('temptation')
  const factory DayEvent.temptation({
    required String itemId,
    @MoneyConverter() required Money price,
  }) = TemptationEvent;

  /// Spec-20: cost charged for sleeping (one per `advanceDay`). When the
  /// player can't pay, `hunger=true` and `amount` is zero — Plant + Allowance
  /// listeners are skipped that day.
  @FreezedUnionValue('sleepCost')
  const factory DayEvent.sleepCost({
    @MoneyConverter() required Money amount,
    required bool hunger,
  }) = SleepCostEvent;

  /// Player has reached the lifetime cap (age 80). Spec-26 marker event;
  /// triggers the Lebensresümee screen and stops further day advancing.
  @FreezedUnionValue('lifetimeEnd')
  const factory DayEvent.lifetimeEnd() = LifetimeEndEvent;

  /// spec-35 phase B: monthly rent income from an owned real-estate unit.
  @FreezedUnionValue('rentIncome')
  const factory DayEvent.rentIncome({
    @MoneyConverter() required Money amount,
    required String propertyId,
  }) = RentIncomeEvent;

  /// spec-35 phase D: monthly salary from current job level.
  /// Spec-44 follow-up: zusätzlich Brutto + Lohnsteuer + Sozialabgaben
  /// für didaktische Aufschlüsselung. `amount` = Netto (Cash-Effekt).
  @FreezedUnionValue('salary')
  const factory DayEvent.salary({
    @MoneyConverter() required Money amount,
    required String jobLevel,
    @MoneyConverter() @Default(Money.zero) Money grossAmount,
    @MoneyConverter() @Default(Money.zero) Money taxAmount,
    @MoneyConverter() @Default(Money.zero) Money socialAmount,
    @MoneyConverter() @Default(Money.zero) Money soliAmount,
    @MoneyConverter() @Default(Money.zero) Money kircheAmount,
  }) = SalaryEvent;

  /// spec-35 phase C: savings-plan auto-execution.
  @FreezedUnionValue('savingsPlanExecuted')
  const factory DayEvent.savingsPlanExecuted({
    @MoneyConverter() required Money amount,
    required String targetAssetId,
  }) = SavingsPlanExecutedEvent;

  /// spec-35 phase E: dispo interest on negative cash.
  @FreezedUnionValue('debtInterest')
  const factory DayEvent.debtInterest({
    @MoneyConverter() required Money amount,
  }) = DebtInterestEvent;

  /// spec-35 phase G: monthly insurance fee (Haftpflicht/Kranken).
  @FreezedUnionValue('insuranceFee')
  const factory DayEvent.insuranceFee({
    @MoneyConverter() required Money amount,
    required String kind,
  }) = InsuranceFeeEvent;

  /// Spec-43 v9: Funny Random Event mit Geld-Kontext.
  /// Bei [taxableOver] = true wird Schenkungsteuer abgezogen
  /// (Bildungs-Hinweis).
  @FreezedUnionValue('luckyEvent')
  const factory DayEvent.luckyEvent({
    required String title,
    required String description,
    @MoneyConverter() required Money amount,
    @MoneyConverter() required Money taxDeducted,
  }) = LuckyEvent;

  /// Sprint B: Drawdown beginnt für eine Asset-Klasse.
  @FreezedUnionValue('crashStarted')
  const factory DayEvent.crashStarted({
    required String assetClassId,
    required double depthPct,
    required int durationDays,
  }) = CrashStartedEvent;

  /// Sprint B: Erholung einer Asset-Klasse abgeschlossen.
  @FreezedUnionValue('recoveryComplete')
  const factory DayEvent.recoveryComplete({
    required String assetClassId,
  }) = RecoveryCompleteEvent;

  /// v29: Spieler hat erstmals 1 Mio € Netto-Vermögen geknackt.
  /// Glückwunsch-Cutscene + Highscore-Marker.
  @FreezedUnionValue('millionaireReached')
  const factory DayEvent.millionaireReached({
    required int ageYears,
    @MoneyConverter() required Money netWorth,
  }) = MillionaireReachedEvent;

  /// v29: Spieler ist im Laufe des Tages min. 1 Stufe aufgestiegen.
  /// `newLevel` = Endstand am Tagesende, `title` = (ggf. neuer) Titel.
  @FreezedUnionValue('levelUp')
  const factory DayEvent.levelUp({
    required int newLevel,
    required String title,
    required bool titleChanged,
  }) = LevelUpEvent;

  /// v29: Pleite — Netto-Vermögen unter Pleite-Schwelle. Game-Over.
  @FreezedUnionValue('bankruptcy')
  const factory DayEvent.bankruptcy({
    @MoneyConverter() required Money netWorth,
  }) = BankruptcyEvent;

  /// Sprint C4: Spieler hat während eines Drawdowns verkauft, und der
  /// Markt hat sich inzwischen wieder über das Verkaufs-Niveau (oder die
  /// Recovery-Phase ist abgeschlossen) zurückgekämpft. Der Verlust ist
  /// jetzt "realisiert" im didaktischen Sinn (er hätte ihn nicht gehabt).
  ///
  /// - [lossCents] = aktueller Wert − Verkaufs-Wert, positive Zahl in Cents
  ///   für „so viel hätte das Asset jetzt mehr wert gewesen".
  /// - [soldAtPct] / [currentPct] = Drawdown-% zum Zeitpunkt des Verkaufs
  ///   bzw. heute (gegen Peak).
  @FreezedUnionValue('panicSellRealized')
  const factory DayEvent.panicSellRealized({
    required String assetClassId,
    required int lossCents,
    required double soldAtPct,
    required double currentPct,
    required int daysSinceSell,
  }) = PanicSellRealizedEvent;

  /// Sprint C4: Spieler hat den Crash ausgesessen (kein Verkauf während
  /// Drawdown) und die Erholung ist abgeschlossen. Lob-Event.
  @FreezedUnionValue('heldThroughCrash')
  const factory DayEvent.heldThroughCrash({
    required String assetClassId,
  }) = HeldThroughCrashEvent;

  /// Spec-44 A.1: Einzelaktie ist pleitegegangen. Quote dauerhaft ~1¢,
  /// erholt sich NIE. Im Kontrast zum diversifizierten ETF. DaySummary
  /// zeigt "💀 X AG ist pleite — Aktien wertlos".
  @FreezedUnionValue('stockBankrupt')
  const factory DayEvent.stockBankrupt({
    required String stockId,
    required String name,
  }) = StockBankruptEvent;

  /// Round 28: Saisonale Lehr-Karte (Black Friday, Weihnachts-Geld) —
  /// reine Bildungs-Botschaft ohne Geld-Effekt. Anti-Konsum ohne
  /// Moralkeule: zeigt die Konsequenz, ohne zu verbieten.
  @FreezedUnionValue('seasonalEvent')
  const factory DayEvent.seasonalEvent({
    required String title,
    required String message,
  }) = SeasonalEvent;

  factory DayEvent.fromJson(Map<String, dynamic> json) =>
      _$DayEventFromJson(json);
}
