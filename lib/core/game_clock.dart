import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/db/app_database_provider.dart';
import 'game_balance.dart';
import '../domain/economy/money.dart';
import '../domain/sim/day_event.dart';
import '../domain/sim/day_event_listener.dart';
import '../domain/sim/day_summary.dart';
import '../domain/sim/game_day.dart';
import '../domain/sim/listeners/allowance_listener.dart';
import '../domain/sim/listeners/birthday_listener.dart';
import '../domain/sim/listeners/crypto_price_listener.dart';
import '../domain/sim/listeners/etf_price_listener.dart';
import '../domain/sim/listeners/inflation_listener.dart';
import '../domain/sim/listeners/metal_price_listener.dart';
import '../domain/sim/listeners/debt_listener.dart';
import '../domain/sim/listeners/forest_listener.dart';
import '../domain/sim/listeners/insurance_listener.dart';
import '../domain/sim/listeners/living_cost_listener.dart';
import '../domain/sim/listeners/mortgage_listener.dart';
import '../domain/sim/listeners/plant_listener.dart';
import '../domain/sim/listeners/vorsorge_listener.dart';
import '../features/daily_quiz/daily_quiz_state.dart';
import '../features/job_action/job_action_repository.dart';
import '../features/lucky_events/lucky_event_history_repository.dart';
import '../features/savings_plan/savings_plan_repository.dart';
import '../domain/vorsorge/vorsorge.dart';
import '../features/vorsorge/vorsorge_repository.dart';
import '../domain/sim/listeners/rent_listener.dart';
import '../domain/sim/listeners/savings_interest_listener.dart';
import '../domain/sim/listeners/stock_price_listener.dart';
import '../domain/sim/listeners/lucky_event_listener.dart';
import '../domain/sim/listeners/seasonal_event_listener.dart';
import '../domain/sim/listeners/market_phase_listener.dart';
import '../features/market_phase/diversification.dart';
import '../features/market_phase/market_phase_repository.dart';
import '../features/market_phase/peak_tracker.dart';
import '../domain/sim/market_phase.dart';
import '../domain/sim/listeners/temptation_listener.dart';
import '../domain/sim/listeners/weather_listener.dart';
import '../domain/wishlist/wish_item.dart' show InflationConfig;
import '../features/bank/savings_repository.dart';
import '../features/economy/cash_state.dart';
import '../features/etf/etf_repository.dart';
import '../domain/highscore/highscore_entry.dart';
import '../features/highscore/highscore_repository.dart';
import '../features/highscore/net_worth.dart';
import '../features/life_goals/life_goals.dart';
import '../features/settings/settings_repository.dart';
import '../features/weekly_challenge/weekly_challenge.dart';
import '../features/history/history_repository.dart';
import '../features/plant/lifetime_harvest_state.dart';
import '../features/plant/plant_repository.dart';
import '../features/quest_runner/quest_availability.dart';
import '../features/quest_runner/quest_passive_income.dart';
import '../features/quest_runner/quest_progress_repository.dart';
import '../features/collectibles/collectible_repository.dart';
import '../domain/crypto/crypto.dart';
import '../features/crypto/crypto_repository.dart';
import '../features/metal/metal_repository.dart';
import '../features/forest/tree_repository.dart';
import '../features/realestate/real_estate_repository.dart';
import '../features/stock/stock_repository.dart';
import '../features/weather/weather_state.dart';
import '../features/wishlist/wishlist_repository.dart';
import '../features/xp/level_titles.dart';
import '../features/xp/xp_repository.dart';
import '../features/zimmer/achievements.dart';
import '../features/zimmer/achievements_repository.dart';
import '../game/monetaria/state/monetaria_state.dart';
import '../game/monetaria/state/monetaria_unlocker.dart';

part 'game_clock.g.dart';

// ── Per-stage listener providers ────────────────────────────────────────────

/// Listeners for the Allowance stage. Spec-15 reads amount + weekday from
/// [SettingsRepository] so the player can tweak both in [SettingsPage].
@riverpod
List<DayEventListener> allowanceListeners(Ref ref) {
  final settings = ref.watch(settingsRepositoryProvider);
  final jobAction = ref.watch(jobActionRepositoryProvider);
  return [
    AllowanceListener(
      amount: settings.allowance,
      weekday: settings.allowanceWeekday,
      startAgeYears: settings.startAgeYears,
      careerBonusPct: jobAction.careerBonusPct,
      pauseUntilDay: jobAction.pauseUntilDay,
    ),
    // spec-35 phase G: Insurance fires on the same monthly cadence.
    InsuranceListener(startAgeYears: settings.startAgeYears),
    // Bug-fix v26: Lebenskosten nach Job-Phase.
    //
    // 2026-08: wer in einer eigenen Immobilie wohnt, zahlt keine Miete mehr —
    // der Miet-Anteil (60 %) fällt weg, Essen/Strom/Versicherung bleiben.
    // Vorher liefen die Lebenskosten unverändert weiter, ein Eigenheim war
    // damit reine Zusatzbelastung ohne jeden Gegenwert.
    LivingCostListener(
      startAgeYears: settings.startAgeYears,
      ownHomeMarketRent:
          ref.read(realEstateRepositoryProvider.notifier).ownHomeMarketRent,
    ),
    // spec-36: Vorsorge-Prämien + Riester-Zulage.
    VorsorgeListener(
      ref.read(vorsorgeRepositoryProvider.notifier),
      startAgeYears: settings.startAgeYears,
    ),
    // spec-36: ETF-Sparplan executes monthly.
    SavingsPlanListener(ref),
    // spec-44 sprint D: Hypothek + Instandhaltung pro Immobilie.
    MortgageListener(ref.read(realEstateRepositoryProvider.notifier)),
  ];
}

/// Listeners for the Interest stage.
///
/// Analyse-Runde 2026-08: der Sprint-1-Stub `InterestListener` ist RAUS. Er
/// emittierte alle 30 Tage ein `interest`-Event über feste 15 ¢, die der
/// Settlement-Loop gar nicht verbucht (er kennt nur `DebtInterestEvent`
/// u. a.) — das Geld gab es nie, die Tageszusammenfassung zeigte aber eine
/// zweite, falsche „Zinsen +0,15 €"-Zeile neben dem echten Sparzins.
/// Zuständig ist allein [SavingsInterestListener].
///
/// spec-35 phase B: piggy-back RentListener here (monthly cadence so
/// timing aligns with allowance).
@riverpod
List<DayEventListener> interestListeners(Ref ref) => [
      SavingsInterestListener(ref.read(savingsRepositoryProvider.notifier)),
      RentListener(ref.read(realEstateRepositoryProvider.notifier)),
      DebtListener(ref.read(cashStateProvider.notifier)),
      // Spec-45 H3: Mischwald-Wald-Wirtschaft.
      ForestListener(ref.read(treeRepositoryProvider.notifier)),
    ];

/// Listeners for the Plant stage. Sprint 5 binds the listener to the
/// [PlantRepository] so growth events fire on each [GameClock.advanceDay].
/// Spec-18: also passes a deterministic per-day weather lookup so plant
/// growth + storm-wither react to weather.
@riverpod
List<DayEventListener> plantListeners(Ref ref) => [
      PlantListener(
        ref.read(plantRepositoryProvider.notifier),
        weatherFor: rollWeather,
      ),
    ];

/// Listeners for the Inflation stage. Sprint 8 binds [InflationListener]
/// to [WishlistRepository] so each `advanceDay()` drifts wishlist prices.
@riverpod
List<DayEventListener> inflationListeners(Ref ref) =>
    [InflationListener(ref.read(wishlistRepositoryProvider.notifier))];

/// Listeners for the Weather stage. Sprint 7 binds the global weather
/// roll to [WeatherState] (deterministic per dayIndex).
@riverpod
List<DayEventListener> weatherListeners(Ref ref) =>
    [WeatherListener(ref.read(weatherStateProvider.notifier))];

/// Listeners for the ETF-price stage. Added in Sprint 7 between weather +
/// birthday in the pipeline order. Sprint B: liest aktuelle MarketPhase
/// für die `etf`-Klasse und appliziert sie zusätzlich zum Drift.
@riverpod
List<DayEventListener> etfPriceListeners(Ref ref) {
  final volFactor =
      volatilityDampening(ref.watch(diversificationClassCountProvider));
  return [
    EtfPriceListener(
      source: ref.read(etfRepositoryProvider.notifier),
      seed: 0xE7F00D,
      marketPhase:
          ref.read(marketPhaseRepositoryProvider.notifier).phaseFor('etf'),
      volatilityFactor: volFactor,
    ),
  ];
}

/// Listeners for the stock-price stage (Sprint 9, after etfPrice).
@riverpod
List<DayEventListener> stockPriceListeners(Ref ref) {
  final volFactor =
      volatilityDampening(ref.watch(diversificationClassCountProvider));
  return [
    StockPriceListener(
      source: ref.read(stockRepositoryProvider.notifier),
      seed: 0x57AC0,
      marketPhase:
          ref.read(marketPhaseRepositoryProvider.notifier).phaseFor('stock'),
      volatilityFactor: volFactor,
    ),
  ];
}

/// Sprint B: Markt-Phase-Resolver — läuft VOR den Preis-Listenern.
/// Pures, deterministisches State-Maschine pro Asset-Klasse.
@riverpod
List<DayEventListener> marketPhaseListeners(Ref ref) => [
      MarketPhaseListener(
        source: ref.read(marketPhaseRepositoryProvider.notifier),
        seed: MarketPhaseListener.defaultSeed,
      ),
    ];

// Die alte Crash-Stage (`CrashListener`, 2 %/Tag ≈ 7 Crash-Tage pro Jahr,
// jeweils −20..50 % OHNE Erholungspfad) ist ERSATZLOS entfallen. Sie lief
// parallel zum neueren [MarketPhaseListener] auf denselben Kursen — ein
// buy-and-hold-ETF klebte dadurch dauerhaft an seinem 40-%-Boden, was das
// zentrale Lernziel („langfristig gehaltener ETF gewinnt") aushebelte. Die
// Pipeline-Tests hatten die Stage stumm geschaltet, deshalb fiel es dort nie
// auf. Crashes kommen jetzt ausschließlich aus dem Phasen-System
// (drawdown → recovery, Profile pro Asset-Klasse).

/// Listeners for the Birthday stage.
///
/// Sprint 1: hard-coded birthday on day 100 (year 0, day-of-year 100).
/// Sprint 5: read birthday from PlayerRepository during onboarding.
@riverpod
List<DayEventListener> birthdayListeners(Ref ref) =>
    [const BirthdayListener(birthdayDayIndex: 100)];

/// Listeners for the Temptation stage.
@riverpod
List<DayEventListener> temptationListeners(Ref ref) =>
    [const TemptationListener()];

@riverpod
List<DayEventListener> luckyEventListeners(Ref ref) {
  final settings = ref.watch(settingsRepositoryProvider);
  return [LuckyEventListener(startAgeYears: settings.startAgeYears)];
}

/// Round 28: Saisonale Lehr-Karten (Black Friday, Weihnachtsgeld-Tipp).
@riverpod
List<DayEventListener> seasonalEventListeners(Ref ref) =>
    [const SeasonalEventListener()];

// ── GameClock ────────────────────────────────────────────────────────────────

/// Player-initiated day-cycle service.
///
/// State is the current [GameDay]. Call [advanceDay] when the player chooses
/// to "sleep" — it runs the full pipeline and returns a [DaySummary].
///
/// Constraints (enforced by spec-01):
/// - NO [Timer] of any kind.
/// - NO `DateTime.now()` calls.
/// - Listeners are injected via Riverpod, not imported directly.
/// - Pipeline order is FIXED: Allowance → Interest → Plant → Inflation →
///   Weather → EtfPrice → StockPrice → Crash → Birthday → Temptation. Do
///   not reorder without updating spec.
@Riverpod(keepAlive: true)
class GameClock extends _$GameClock {
  @override
  GameDay build() {
    final snap = ref.watch(dbSnapshotProvider);
    return GameDay.fromIndex(snap.dayIndex ?? 0);
  }

  /// Advances the game by one day.
  ///
  /// Runs the full [DayEventListener] pipeline in fixed order and returns a
  /// [DaySummary] with all emitted events.
  ///
  /// Balance fields ([DaySummary.cashBefore] etc.) are [Money.zero] in Sprint
  /// 1 — wired to Drift account repos in Sprint 5.
  /// Bug-fix v26: `lightweight` skip per-day history-snapshot + unlock
  /// check + achievement-check + quest-passive-tick → spart 4 DB-Calls
  /// pro Tag. Im FastForward gesetzt, nur am Ende einmalig nachgeholt.
  Future<DaySummary> advanceDay({
    bool skipSleepCost = false,
    bool lightweight = false,
  }) async {
    final currentDay = state;
    // spec-26: hard lifetime cap. Once the player has lived through
    // Alter 80, sim stops advancing. Respektiert startAgeYears.
    final startAge = ref.read(settingsRepositoryProvider).startAgeYears;
    final maxDay = GameBalance.maxDayIndexFor(startAge);
    if (currentDay.dayIndex >= maxDay) {
      final cash = Money.cents(ref.read(cashStateProvider).cents);
      final savings =
          Money.cents(ref.read(savingsRepositoryProvider).cents);
      // v29: Highscore-Auto-Entry beim ersten Erreichen des Caps —
      // egal ob via Schlafen oder FastForward. Idempotent (Repo
      // ignoriert wenn schon eingetragen).
      unawaited(_recordFinalHighscoreEntry());
      return DaySummary(
        day: currentDay,
        events: const [DayEvent.lifetimeEnd()],
        cashBefore: cash,
        cashAfter: cash,
        savingsBefore: savings,
        savingsAfter: savings,
      );
    }
    final nextDay = GameDay.fromIndex(currentDay.dayIndex + 1);
    // v29: XP-Level vor Tagesbeginn merken — Level-Up-Event nach Pipeline.
    final xpBefore = ref.read(xpRepositoryProvider);
    final lvlBefore = LevelSystem.levelFor(xpBefore);

    // Spec-21: snapshot cash before the pipeline so we can decide whether
    // the player "survived" a CrashEvent. Simplification: crash_survivor
    // unlocks if a CrashEvent fires today *and* the cash balance didn't
    // drop more than 20 % (effectively: any day the crash is rolled, the
    // player hasn't panic-sold during the listeners — cash isn't directly
    // hit by crash, but a panic sale via UI would land between two days
    // not inside advanceDay; this is a deliberate simplification).
    final cashBefore = ref.read(cashStateProvider).cents;

    final events = <DayEvent>[];

    // Spec-20: Schlafen-Snack costs `sleepCostCents`. If the player can't
    // afford it, fall into the Hunger-Pfad — Plant + Allowance listeners
    // are skipped for the day, the rest of the pipeline still runs.
    // spec-33: during fast-forward we skip the per-day snack cost so the
    // cumulative drain doesn't starve the player into the Hunger-Pfad
    // for years on end.
    // Round 28 v4: Snack-/Essenskosten steigen mit dem Level.
    final sleepCost = skipSleepCost
        ? Money.zero
        : Money.cents(GameBalance.sleepCostCentsFor(
            LevelSystem.levelFor(ref.read(xpRepositoryProvider)),
          ));
    final cashNotifier = ref.read(cashStateProvider.notifier);
    // Im Zeitsprung NIE Hunger: `canAfford` ist `state >= amount`, also bei
    // negativem Cash (Dispo ist ein erlaubtes Spiel-Feature) auch für 0 €
    // false → jeder der bis zu 1825 Sprung-Tage wäre ein Hunger-Tag, das
    // Einkommen fiele weg und der DebtListener würde Zinsen kompoundieren:
    // garantierte Schuldenspirale, für den Spieler unerklärlich. spec-33
    // wollte genau das verhindern.
    final hunger = !skipSleepCost && !cashNotifier.canAfford(sleepCost);
    if (hunger) {
      events.add(const DayEvent.sleepCost(amount: Money.zero, hunger: true));
    } else {
      cashNotifier.spend(sleepCost);
      events.add(DayEvent.sleepCost(amount: sleepCost, hunger: false));
    }

    // Fixed pipeline order — DO NOT change without spec update.
    // Hunger-Pfad (Spec-20): skip Allowance + Plant when the player went
    // to bed without paying their snack.
    //
    // ABER nur das EINKOMMEN entfällt, nicht die Kosten: die Stage bündelt
    // auch Insurance/LivingCost/Vorsorge/Sparplan/Hypothek. Wurde alles
    // übersprungen, war „pleite sein" profitabel — keine Lebenskosten,
    // keine Prämien, keine Hypothekenrate, aber Miete/Zinsen/Holz liefen
    // weiter (Interest-Stage). Das invertierte die Lehr-Botschaft.
    final allowanceStage = ref.read(allowanceListenersProvider);
    events.addAll(await _runStage(
      hunger
          ? allowanceStage
              .where((l) => l is! AllowanceListener)
              .toList(growable: false)
          : allowanceStage,
      nextDay,
    ));
    events.addAll(
      await _runStage(ref.read(interestListenersProvider), nextDay),
    );
    if (!hunger) {
      events.addAll(
        await _runStage(ref.read(plantListenersProvider), nextDay),
      );
    }
    events.addAll(
      await _runStage(ref.read(inflationListenersProvider), nextDay),
    );
    events.addAll(
      await _runStage(ref.read(weatherListenersProvider), nextDay),
    );
    // Sprint B: Markt-Phase VOR Preis-Listenern auflösen, damit
    // ETF/Stock-Listener die aktualisierte Phase sehen.
    events.addAll(
      await _runStage(ref.read(marketPhaseListenersProvider), nextDay),
    );
    events.addAll(
      await _runStage(ref.read(etfPriceListenersProvider), nextDay),
    );
    events.addAll(
      await _runStage(ref.read(stockPriceListenersProvider), nextDay),
    );
    // Spec-22: crypto + metal listeners run *after* the phase + inflation
    // stages so they can react to same-day events. Krypto nimmt am
    // Crash-START-Tag der eigenen Klasse einen Extra-Schlag; Metalle werden
    // von der Tages-Inflation genudged.
    final cryptoCrashToday = events.whereType<CrashStartedEvent>().any(
          (e) => e.assetClassId == 'crypto',
        );
    final inflationEventsToday =
        events.whereType<InflationEvent>().toList(growable: false);
    // Sprint B (Spec-44): Crypto + Metal sind ab jetzt phase-aware.
    // Metalle teilen sich bewusst die Gold-Phase (Vereinfachung — eine
    // gemeinsame State-Maschine statt drei separater).
    final phaseRepo = ref.read(marketPhaseRepositoryProvider.notifier);
    final cryptoListener = CryptoPriceListener(
      source: ref.read(cryptoRepositoryProvider.notifier),
      seed: 0xC0FFEE,
      crashToday: cryptoCrashToday,
      marketPhase: phaseRepo.phaseFor('crypto'),
    );
    events.addAll(await cryptoListener.onDayAdvance(nextDay));
    final metalListener = MetalPriceListener(
      source: ref.read(metalRepositoryProvider.notifier),
      seed: 0x6017D,
      inflationEventsToday: inflationEventsToday,
      marketPhase: phaseRepo.phaseFor('gold'),
    );
    events.addAll(await metalListener.onDayAdvance(nextDay));
    events.addAll(
      await _runStage(ref.read(birthdayListenersProvider), nextDay),
    );
    events.addAll(
      await _runStage(ref.read(temptationListenersProvider), nextDay),
    );
    events.addAll(
      await _runStage(ref.read(luckyEventListenersProvider), nextDay),
    );
    events.addAll(
      await _runStage(ref.read(seasonalEventListenersProvider), nextDay),
    );

    // spec-35: post-pipeline cash settlement — credit/debit every
    // monetary event that wasn't already side-effected by its own
    // listener. Rent + savings-interest update cash inside the listener;
    // Allowance + Salary + Birthday + DebtInterest are pure-event and
    // land here.
    // Spec-44 E3 (Pay-yourself-first): User-konfigurierbarer Anteil von
    // Taschengeld + Gehalt wird VOR Giro auf Spar geschoben.
    final savingsRatePct =
        ref.read(settingsRepositoryProvider).savingsRatePct;
    void earnSplit(Money amount) {
      if (savingsRatePct <= 0) {
        cashNotifier.earn(amount);
        return;
      }
      final toSpar = Money.cents((amount.cents * savingsRatePct / 100).round());
      final toGiro = amount - toSpar;
      if (toGiro.cents > 0) cashNotifier.earn(toGiro);
      if (toSpar.cents > 0) {
        ref.read(savingsRepositoryProvider.notifier).creditInterest(toSpar);
      }
    }

    // Spec-44 F1 sprint F: Listings deren sellDelayDays erreicht ist
    // automatisch abwickeln (Cash-Gutschrift via Repository.sell).
    await ref
        .read(collectibleRepositoryProvider.notifier)
        .settleListings(nextDay.dayIndex);

    // Welle-8 Round 22 fix: ConcurrentModificationError — Settlement-
    // Loop fügte InsuranceFee-Schutz-Event direkt in `events` ein
    // während iteriert wurde. Jetzt in deferredEvents sammeln und
    // erst nach Loop appenden. Lucky-Aua-Pack triggert das öfter.
    final deferredEvents = <DayEvent>[];
    for (final e in events) {
      switch (e) {
        case AllowanceEvent(:final amount):
          earnSplit(amount);
        case SalaryEvent(:final amount):
          earnSplit(amount);
        case BirthdayEvent(:final giftAmount):
          cashNotifier.earn(giftAmount);
        case DebtInterestEvent(:final amount):
          cashNotifier.forceDeduct(amount);
        case InsuranceFeeEvent(:final amount):
          cashNotifier.forceDeduct(amount);
        case LuckyEvent(
            :final amount,
            :final title,
            :final description,
            :final taxDeducted,
          ):
          // Spec-45 A2 + G4: persistente Historie.
          ref.read(luckyEventHistoryRepositoryProvider.notifier).record(
                dayIndex: nextDay.dayIndex,
                title: title,
                description: description,
                amountCents: amount.cents,
                taxDeductedCents: taxDeducted.cents,
              );
          if (amount.cents >= 0) {
            cashNotifier.earn(amount);
          } else {
            // Spec-44 E4: aktive Versicherung kann Schaden abfangen.
            final covered = _insuranceCovers(title);
            if (covered) {
              // Schaden wird abgefangen — kein Cash-Abzug, aber Hinweis-
              // Event für DaySummary (re-use InsuranceFeeEvent mit
              // kind="Schutz" damit kein neuer DayEvent-Typ nötig).
              deferredEvents.add(DayEvent.insuranceFee(
                amount: Money.zero,
                kind: 'Versicherung hat ${Money.cents(-amount.cents).formatEur()} abgefangen ($title)',
              ));
            } else {
              cashNotifier.forceDeduct(Money.cents(-amount.cents));
            }
          }
        default:
          break;
      }
    }
    events.addAll(deferredEvents);

    // Welle-8 Round 22 / B3a — Geldentwertung auf herumliegendes BARGELD.
    // Nominal schrumpft es täglich mit der Basis-Inflation, sonst wäre der
    // Zeitsprung gratis Realgeld-Magie. Settlement-Loop ist bereits durch —
    // Event nur informativ, keine doppelte Buchung.
    //
    // Analyse-Runde 2026-08: das SPARKONTO ist hier RAUS. Der Sparzins ist
    // `balance ~/ 20000` (≈ 1,8 %/Jahr), der Inflationsabzug lag mit 2 %/Jahr
    // darüber — ab ~1.850 € rundete der Abzug höher als die Gutschrift, die
    // angezeigte Kontozahl SANK also jeden Tag, obwohl direkt darüber
    // „Zinsen +0,10 €" stand. Reale Inflation senkt keinen nominalen
    // Kontostand; für ein Kind ist genau das die verwirrendste mögliche
    // Darstellung. Der reale Kaufkraftverlust wird weiterhin über steigende
    // Wunsch-Preise, Lebenskosten und den Kaufkraft-Chart gelehrt.
    // Nebeneffekt (gewollt): die Rangfolge Bargeld < Sparkonto < ETF ist
    // jetzt auch nominal sichtbar.
    final cashNowCents = ref.read(cashStateProvider).cents;
    const inflRate = InflationConfig.dailyRate;
    final cashLoss =
        cashNowCents > 0 ? (cashNowCents * inflRate).round() : 0;
    if (cashLoss > 0) {
      cashNotifier.forceDeduct(Money.cents(cashLoss));
      events.add(DayEvent.insuranceFee(
        amount: Money.cents(cashLoss),
        kind: 'Geldentwertung (Bargeld)',
      ));
    }

    // Sprint C4: Peak-Tracking + Panic-Sell/Held-Through-Crash-Emission
    // pro Asset-Klasse. Läuft post-Pipeline auf den neu berechneten
    // Marktwerten.
    _checkPeakAndPanicSell('etf', _etfHoldingsValue(), events, nextDay.dayIndex);
    _checkPeakAndPanicSell(
        'stock', _stockHoldingsValue(), events, nextDay.dayIndex);

    state = nextDay;
    _persist(nextDay.dayIndex);

    // Snapshot today's asset prices for the Zeitreise view. Runs after the
    // day-index advance so the price-history row is keyed by the new day,
    // leaving day-0's catalog seed untouched. Spec-19: also flag the row
    // as a crash day so the chart can paint a vertical marker.
    final crashedToday = events.any((e) => e is CrashStartedEvent);
    // Bug-fix v26: im lightweight-Mode nur alle 30 Tage snapshotten +
    // Achievements/Unlocks checken — spart Großteil der DB-Schreibarbeit
    // im FastForward.
    final doFullPersist = !lightweight || nextDay.dayIndex % 30 == 0;
    if (doFullPersist) {
      ref
          .read(historyRepositoryProvider.notifier)
          .recordToday(crashedToday: crashedToday);
      _checkUnlocks(nextDay.dayIndex);
      ref.read(questPassiveIncomeProvider.notifier).tick(nextDay.dayIndex);
      _checkAchievements(
        dayIndex: nextDay.dayIndex,
        events: events,
        cashBeforeCents: cashBefore,
      );
    }
    // Spec-21: +1 XP for the act of sleeping (daily ritual reward).
    // Welle-8 Round 22 v3: NUR bei echtem Schlafen. FastForward
    // (skipSleepCost=true) skipt XP — sonst gratis Levels via Zeitsprung
    // (5J = 1825 XP ≈ 6 Levels ohne Aktion). Cheating-Vector.
    if (!skipSleepCost) {
      ref.read(xpRepositoryProvider.notifier).add(XpRewards.sleep);
    }

    // v29: Level-Up-Detection. Vergleicht Endstand vs lvlBefore.
    final xpAfter = ref.read(xpRepositoryProvider);
    final lvlAfter = LevelSystem.levelFor(xpAfter);
    if (lvlAfter > lvlBefore) {
      events.add(DayEvent.levelUp(
        newLevel: lvlAfter,
        title: LevelSystem.titleFor(lvlAfter),
        titleChanged: LevelSystem.titleFor(lvlAfter) !=
            LevelSystem.titleFor(lvlBefore),
      ));
    }

    // v29: Pleite-Check (Net-Worth < -10.000 €). Emittiert
    // BankruptcyEvent → DaySummary zeigt Game-Over-Cutscene.
    // Pleite-Schwelle bewusst nicht 0 — kurze Dispo-Phasen erlaubt.
    if (doFullPersist) {
      final nw = NetWorth.compute(ref, nextDay.dayIndex);
      if (nw < -1000000) {
        events.add(DayEvent.bankruptcy(netWorth: Money.cents(nw)));
      }
    }

    // Highscore-Hook: erste Millionärs-Schwelle persistieren (1 Mio €).
    // v29: bei Transition non→millionär zusätzlich MillionaireReachedEvent
    // emittieren — DaySummary zeigt Glückwunsch-Cutscene.
    if (doFullPersist) {
      final netWorthNow = NetWorth.compute(ref, nextDay.dayIndex);
      if (netWorthNow >= millionaireThresholdCents) {
        final hsData = await ref.read(highscoreRepositoryProvider.future);
        if (hsData.firstMillionaireDayIndex == null) {
          await ref
              .read(highscoreRepositoryProvider.notifier)
              .setFirstMillionaireDay(
                nextDay.dayIndex,
                netWorthCents: netWorthNow,
              );
          final startAge =
              ref.read(settingsRepositoryProvider).startAgeYears;
          final ageNow = startAge + (nextDay.dayIndex ~/ 365);
          events.add(
            DayEvent.millionaireReached(
              ageYears: ageNow,
              netWorth: Money.cents(netWorthNow),
            ),
          );
        }
      }
    }

    return DaySummary(
      day: nextDay,
      events: events,
      cashBefore: Money.zero,
      cashAfter: Money.zero,
      savingsBefore: Money.zero,
      savingsAfter: Money.zero,
    );
  }

  /// Welle-8: Real-time Trigger nach Spieler-Aktion (Quest done,
  /// Plant-Harvest, Buy etc) damit Achievements sofort poppen statt
  /// erst beim Schlafen.
  void evaluateAchievementsNow() {
    _checkAchievements(
      dayIndex: state.dayIndex,
      events: const [],
      cashBeforeCents: ref.read(cashStateProvider).cents,
    );
  }

  /// Spec-21: runs [evaluateAchievements] and persists any new unlocks.
  /// Idempotent.
  void _checkAchievements({
    required int dayIndex,
    required List<DayEvent> events,
    required int cashBeforeCents,
  }) {
    final harvestTotal = ref.read(lifetimeHarvestStateProvider);
    final savings = ref.read(savingsRepositoryProvider);
    final etf = ref.read(etfRepositoryProvider);
    final quests = ref.read(questProgressRepositoryProvider);
    final monetaria = ref.read(monetariaStateProvider.notifier);
    final cashAfter = ref.read(cashStateProvider).cents;

    // crash_survivor: heute startete ein Crash (Phasen-System) UND das Cash
    // ist nicht um > 20 % gefallen. Cash wird vom Crash nicht direkt
    // getroffen (er repreist nur Kurse) — das approximiert „nicht
    // panisch intraday verkauft".
    final crashedToday = events.any((e) => e is CrashStartedEvent);
    final cashDroppedTooFar = cashBeforeCents > 0 &&
        cashAfter < (cashBeforeCents * 0.8).round();
    final crashSurvived = crashedToday && !cashDroppedTooFar;

    final questsCompleted = quests.values
        .where((p) => p.status == questStatusCompleted)
        .length;

    final realEstate = ref.read(realEstateRepositoryProvider);
    final settings = ref.read(settingsRepositoryProvider);
    // Round 27 v5 BUGFIX: vorher wurden crypto/metal/stock/level/wishlist/
    // vorsorge/sparplan/assetClass + echter Streak NICHT übergeben → ~15
    // Trophäen konnten NIE freischalten. Jetzt vollständig.
    final crypto = ref.read(cryptoRepositoryProvider);
    var bitcoinShares = 0;
    for (final h in crypto.holdings) {
      if (CryptoCatalog.btcPerShare(h.assetId) > 0) bitcoinShares += h.shares;
    }
    final metal = ref.read(metalRepositoryProvider);
    var metalShares = 0;
    for (final h in metal.holdings) {
      metalShares += h.shares;
    }
    final stock = ref.read(stockRepositoryProvider);
    var stockShares = 0;
    for (final h in stock.holdings) {
      stockShares += h.shares;
    }
    final wishlist = ref.read(wishlistRepositoryProvider);
    final wishOwned = wishlist.where((w) => w.ownedOnDayIndex != null).length;
    final xp = ref.read(xpRepositoryProvider);
    final level = LevelSystem.levelFor(xp);
    final vorsorgeCount = ref.read(vorsorgeRepositoryProvider).length;
    final sparplanCount = ref.read(savingsPlanRepositoryProvider).length;
    final assetClasses = ref.read(diversificationClassCountProvider);
    final netWorth = ref.read(netWorthProvider(dayIndex));
    final unlocked = evaluateAchievements(
      plantHarvestCount: harvestTotal > 0 ? 1 : 0,
      savingsCents: savings.cents,
      etfHoldingsCount: etf.holdings.length,
      questsCompleted: questsCompleted,
      inflationAtollUnlocked: monetaria.isUnlocked('inflation_atoll'),
      crashSurvived: crashSurvived,
      daysPlayed: dayIndex,
      monthlyAllowanceCents: settings.allowance.cents,
      realEstateCount: realEstate.length,
      streakDays: settings.streakCount,
      bitcoinShares: bitcoinShares,
      metalShares: metalShares,
      stockShares: stockShares,
      wishlistOwnedCount: wishOwned,
      wishlistTotalCount: wishlist.length,
      level: level,
      cashCents: cashAfter,
      vorsorgeContractsCount: vorsorgeCount,
      sparplanCount: sparplanCount,
      assetClassCount: assetClasses,
      netWorthCents: netWorth,
    );

    final repo = ref.read(achievementsRepositoryProvider.notifier);
    final xpRepo = ref.read(xpRepositoryProvider.notifier);
    for (final id in unlocked) {
      // Round 27 v7: frisch freigeschaltete Trophäe (inkl. Portfolio-
      // Stufen) gibt XP → XP-Fluss bleibt auch nach allen Quests.
      if (repo.unlock(id, dayIndex)) {
        xpRepo.add(XpRewards.achievementUnlocked);
      }
    }

    // Round 28 v4: Lebensziele-Leiter (Langzeit-Endgame). Eigene, große
    // XP/Cash-Belohnungen pro Ziel. Persistenz/Idempotenz via derselben
    // AchievementsRepository (IDs liegen NICHT in kAchievements → eigene
    // Seite, keine Trophäenwand-Kachel).
    final ageYears = settings.startAgeYears + dayIndex ~/ 365;
    final lifeSnap = LifeGoalSnapshot(
      netWorthCents: netWorth,
      daysPlayed: dayIndex,
      ageYears: ageYears,
      level: level,
      assetClassCount: assetClasses,
      streakDays: settings.streakCount,
    );
    final cashRepo = ref.read(cashStateProvider.notifier);
    applyLifeGoals(
      snap: lifeSnap,
      dayIndex: dayIndex,
      unlock: repo.unlock,
      addXp: xpRepo.add,
      earnCents: (cents) => cashRepo.earn(Money.cents(cents)),
    );

    // Round 28 v4: Wochen-Herausforderung (renewing). Nutzt denselben
    // Snapshot; löst die aktuelle Woche ein, falls erfüllt + offen.
    final settingsRepo = ref.read(settingsRepositoryProvider.notifier);
    applyWeeklyChallenge(
      snap: lifeSnap,
      dayIndex: dayIndex,
      claimedWeek: settings.weeklyChallengeClaimedWeek,
      streak: settings.weeklyChallengeStreak,
      addXp: xpRepo.add,
      earnCents: (cents) => cashRepo.earn(Money.cents(cents)),
      persist: ({required int claimedWeek, required int streak}) =>
          settingsRepo.setWeeklyChallenge(
              claimedWeek: claimedWeek, streak: streak),
    );
  }

  /// Evaluates [MonetariaUnlocker] against current state and unlocks any
  /// new island IDs via [MonetariaState]. Idempotent — already-unlocked
  /// IDs are no-ops.
  void _checkUnlocks(int dayIndex) {
    final cash = ref.read(cashStateProvider);
    final harvestTotal = ref.read(lifetimeHarvestStateProvider);
    final etf = ref.read(etfRepositoryProvider);
    var etfMarketValue = 0;
    for (final h in etf.holdings) {
      final quote = etf.quotes[h.etfId];
      if (quote != null) {
        etfMarketValue += quote.pricePerShare.cents * h.shares;
      }
    }
    final stock = ref.read(stockRepositoryProvider);
    var totalStockShares = 0;
    for (final h in stock.holdings) {
      totalStockShares += h.shares;
    }
    final xp = ref.read(xpRepositoryProvider);
    final learnedTopics = ref.read(learnedTopicsProvider);
    final target = MonetariaUnlocker.compute(
      cashCents: cash.cents,
      harvestTotalCents: harvestTotal,
      dayIndex: dayIndex,
      etfMarketValueCents: etfMarketValue,
      stockShares: totalStockShares,
      xp: xp,
      learnedTopics: learnedTopics,
    );
    final notifier = ref.read(monetariaStateProvider.notifier);
    for (final id in target) {
      if (!notifier.isUnlocked(id)) {
        notifier.unlock(id);
      }
    }
  }

  /// v29: ruft addEntry am Lebensende (Alter 80). Idempotent — Repo
  /// ignoriert weitere Aufrufe da firstMillionaireDayIndex bereits in
  /// gleichem Run gesetzt und Entries nicht dedupliziert werden — daher
  /// hier hartes guard via _highscoreEntered.
  bool _highscoreEntered = false;
  Future<void> _recordFinalHighscoreEntry() async {
    if (_highscoreEntered) return;
    _highscoreEntered = true;
    try {
      final settings = ref.read(settingsRepositoryProvider);
      final startAge = settings.startAgeYears;
      final maxDay = GameBalance.maxDayIndexFor(startAge);
      final netWorth = NetWorth.compute(ref, maxDay);
      final hsData = await ref.read(highscoreRepositoryProvider.future);
      final firstMillDay = hsData.firstMillionaireDayIndex;
      final entry = HighscoreEntry(
        playerName: settings.playerName,
        startedAt: DateTime.now().subtract(
          Duration(days: GameBalance.maxAgeYears - startAge),
        ),
        endedAt: DateTime.now(),
        finalNetWorthCents: netWorth,
        finalAgeYears: GameBalance.maxAgeYears,
        firstMillionaireAgeYears: firstMillDay == null
            ? null
            : startAge + (firstMillDay ~/ 365),
        firstMillionaireDayIndex: firstMillDay,
        // Welle-8 Round 20: Vermögen zum Millionärs-Zeitpunkt mit-übernehmen.
        firstMillionaireNetWorthCents: hsData.firstMillionaireNetWorthCents,
      );
      await ref.read(highscoreRepositoryProvider.notifier).addEntry(entry);
    } on Object {
      _highscoreEntered = false; // Retry später erlauben.
    }
  }

  /// Spec-44 E4: prüft ob aktiver Vorsorge-Vertrag den Schaden via
  /// `coversEventTitleKeywords` abdeckt. Match = irgendein Keyword
  /// als Substring im Event-Titel.
  bool _insuranceCovers(String eventTitle) {
    final contracts = ref.read(vorsorgeRepositoryProvider);
    for (final c in contracts) {
      final spec = VorsorgeCatalog.byType(c.type);
      for (final kw in spec.coversEventTitleKeywords) {
        if (eventTitle.contains(kw)) return true;
      }
    }
    return false;
  }

  void _persist(int dayIndex) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.gameClockDao.setDayIndex(dayIndex).catchError((Object _) {}),
    );
  }

  /// Spec-20: Loops [advanceDay] `days` times, aggregating cash deltas +
  /// event totals into a [FastForwardSummary]. Sleep cost applies per day,
  /// so the Hunger-Pfad naturally kicks in if cash runs out mid-jump.
  ///
  /// B5/B6 Welle-8 Round 22:
  /// - [onProgress] feuert ca. alle 30 Tage mit dem aktuellen Index —
  ///   damit "Tage vergehen…" Anzeige tatsächlich fortschreitet.
  /// - Crisis-Roll vorab: je länger der Sprung, desto höher die Chance
  ///   auf ein "Krisenjahr". Trifft Cash + Spar + ETF + Aktien + Krypto
  ///   + Metall gleichermaßen. Wahrscheinlichkeit + Stärke skalieren
  ///   linear mit days/1825 (5 Jahre = max).
  Future<FastForwardSummary> fastForward(
    int days, {
    void Function(int currentDay)? onProgress,
  }) async {
    assert(days > 0, 'fastForward requires positive day count');

    // Welle-8 Round 22: vorab auf verbleibende Lebenstage cappen —
    // sonst zeigt Progress „Tag 211 von 1825" und bricht bei
    // LifetimeEnd ab → wirkt für Spieler wie Hänger. Mit Trim läuft
    // Bar bis 100 %, Summary kommt direkt.
    final startAge = ref.read(settingsRepositoryProvider).startAgeYears;
    final maxDay = GameBalance.maxDayIndexFor(startAge);
    final remaining = maxDay - state.dayIndex;
    if (remaining <= 0) {
      days = 1;
    } else if (days > remaining) {
      days = remaining;
    }

    // B6 — Crisis-Roll vor dem Sprung. Welle-8 Round 22 v2: alles
    // randomisiert in Skalierungs-Range damit Spieler es NICHT
    // einkalkulieren kann. lenFactor 0..1 = Skalierungs-Faktor für
    // max-Risiko + max-Stärke. Sockel 2 % auch bei kurzen Sprüngen.
    final rand = math.Random();
    final lenFactor = (days / 1825.0).clamp(0.0, 1.0);
    final maxFail = 0.05 + 0.55 * lenFactor;
    final failChance = 0.02 + rand.nextDouble() * (maxFail - 0.02);
    final crisisHit = rand.nextDouble() < failChance;
    final maxSev = 0.15 + 0.55 * lenFactor;
    final severity = 0.05 + rand.nextDouble() * (maxSev - 0.05);
    final crisisDropPct = crisisHit ? severity : 0.0;
    if (crisisHit) {
      final cashCur = ref.read(cashStateProvider).cents;
      if (cashCur > 0) {
        ref
            .read(cashStateProvider.notifier)
            .forceDeduct(Money.cents((cashCur * severity).round()));
      }
      final savCur = ref.read(savingsRepositoryProvider).cents;
      if (savCur > 0) {
        ref
            .read(savingsRepositoryProvider.notifier)
            .deductInflation(Money.cents((savCur * severity).round()));
      }
      ref.read(etfRepositoryProvider.notifier).applyCrash(severity);
      ref.read(stockRepositoryProvider.notifier).applyCrash(severity);
      ref.read(cryptoRepositoryProvider.notifier).applyCrash(severity);
      ref.read(metalRepositoryProvider.notifier).applyCrash(severity);
    }

    final cashBeforeCents = ref.read(cashStateProvider).cents;

    // spec-38 P0-7: actual holding-value delta instead of raw per-share
    // delta. Captures shares * (priceAfter - priceBefore) so multi-year
    // jumps report the real portfolio gain on assets the player holds.
    final etfBeforeCents = _etfHoldingsValue();
    final stockBeforeCents = _stockHoldingsValue();
    final cryptoBeforeCents = _cryptoHoldingsValue();
    final metalBeforeCents = _metalHoldingsValue();
    // Spec-43 follow-up: cover remaining asset classes.
    final dayBefore = state.dayIndex;
    final realEstateBeforeCents = _realEstateValue(dayBefore);
    final collectibleBeforeCents = _collectiblesValue(dayBefore);
    final savingsBeforeCents = ref.read(savingsRepositoryProvider).cents;
    final vorsorgeBeforeCents = _vorsorgeTotalValue();

    final summaries = <DaySummary>[];
    final luckyEvents = <LuckyEventEntry>[];
    var allowanceTotal = 0;
    var harvestTotal = 0;
    var crashCount = 0;

    for (var i = 0; i < days; i++) {
      // B5: progress-Tick + Frame-Yield, sonst blockt der synchrone Loop den
      // UI-Thread (die awaits dazwischen sind Microtasks, kein Render).
      // delayed(1ms) zwingt den EventLoop zu einem Frame-Pump. Intervall 10
      // statt 30 Tage: 30 Tages-Pipelines in Folge waren 30-150 ms Blöcke →
      // die Progress-Bar fror auf dem Mi A3 sichtbar in Stufen ein.
      if (i % 10 == 0) {
        if (onProgress != null) onProgress(i);
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      // spec-33: bypass sleep cost during multi-day jumps so years of
      // allowance/harvest don't get nuked by accumulated snack expense.
      final s = await advanceDay(skipSleepCost: true, lightweight: true);
      summaries.add(s);
      // v29: Stopp wenn 80-Jahre-Cap erreicht — LifetimeEnd-Event ist
      // terminierend, weiter advancen würde immer wieder das selbe Event
      // returnen ohne Spielstand-Fortschritt.
      if (s.events.any((e) => e is LifetimeEndEvent)) {
        if (onProgress != null) onProgress(days - 1);
        break;
      }
      for (final e in s.events) {
        switch (e) {
          case AllowanceEvent(:final amount):
            allowanceTotal += amount.cents;
          case HarvestEvent(:final harvestYield):
            harvestTotal += harvestYield.cents;
          case CrashStartedEvent():
            crashCount += 1;
          case LuckyEvent(:final title, :final amount):
            luckyEvents.add(LuckyEventEntry(
              title: title,
              amountCents: amount.cents,
              dayIndex: s.day.dayIndex,
            ));
          default:
            break;
        }
      }
    }

    // Yield damit UI letzten Progress-Tick rendern kann bevor Post-Loop-
    // Persist arbeitet (recordToday + Achievements können DB-Calls
    // machen).
    if (onProgress != null) onProgress(days - 1);
    await Future<void>.delayed(const Duration(milliseconds: 1));

    // Bug-fix v26: nach lightweight-FastForward einmaliger Final-Snapshot +
    // Achievement/Unlock-Check, damit Zeitreise + Trophäen aktuell sind.
    ref.read(historyRepositoryProvider.notifier).recordToday(crashedToday: false);
    _checkUnlocks(state.dayIndex);
    _checkAchievements(
      dayIndex: state.dayIndex,
      events: const [],
      cashBeforeCents: cashBeforeCents,
    );

    final cashAfterCents = ref.read(cashStateProvider).cents;
    final etfDelta = _etfHoldingsValue() - etfBeforeCents;
    final stockDelta = _stockHoldingsValue() - stockBeforeCents;
    final cryptoDelta = _cryptoHoldingsValue() - cryptoBeforeCents;
    final metalDelta = _metalHoldingsValue() - metalBeforeCents;
    final dayAfter = state.dayIndex;
    final realEstateDelta = _realEstateValue(dayAfter) - realEstateBeforeCents;
    final collectibleDelta =
        _collectiblesValue(dayAfter) - collectibleBeforeCents;
    final savingsDelta =
        ref.read(savingsRepositoryProvider).cents - savingsBeforeCents;
    final vorsorgeDelta = _vorsorgeTotalValue() - vorsorgeBeforeCents;

    return FastForwardSummary(
      totalDays: days,
      cashBeforeCents: cashBeforeCents,
      cashAfterCents: cashAfterCents,
      allowanceTotalCents: allowanceTotal,
      harvestTotalCents: harvestTotal,
      etfDeltaCents: etfDelta,
      stockDeltaCents: stockDelta,
      cryptoDeltaCents: cryptoDelta,
      metalDeltaCents: metalDelta,
      realEstateDeltaCents: realEstateDelta,
      collectibleDeltaCents: collectibleDelta,
      savingsDeltaCents: savingsDelta,
      vorsorgeDeltaCents: vorsorgeDelta,
      crashCount: crashCount,
      summaries: summaries,
      luckyEvents: luckyEvents,
      crisisDropPct: crisisDropPct,
    );
  }

  /// Immobilien-NETTOwert: Marktwert minus Restschuld. Geliehenes Geld ist
  /// kein Vermögen — sonst machte ein Kauf auf Hypothek das Vermögen um die
  /// Kreditsumme größer (siehe NetWorth.compute).
  int _realEstateValue(int dayIndex) {
    final repo = ref.read(realEstateRepositoryProvider.notifier);
    var total = 0;
    for (final h in ref.read(realEstateRepositoryProvider)) {
      total += repo.currentValueOf(h, dayIndex).cents -
          repo.mortgageRemaining(h, dayIndex).cents;
    }
    return total;
  }

  int _collectiblesValue(int dayIndex) {
    final repo = ref.read(collectibleRepositoryProvider.notifier);
    return repo.totalCurrentValue(dayIndex).cents;
  }

  int _vorsorgeTotalValue() {
    var total = 0;
    for (final c in ref.read(vorsorgeRepositoryProvider)) {
      total += c.totalContributed.cents + c.totalSubsidy.cents;
    }
    return total;
  }

  int _etfHoldingsValue() {
    final p = ref.read(etfRepositoryProvider);
    var total = 0;
    for (final h in p.holdings) {
      final q = p.quotes[h.etfId];
      if (q != null) total += h.shares * q.pricePerShare.cents;
    }
    return total;
  }

  int _stockHoldingsValue() {
    final p = ref.read(stockRepositoryProvider);
    var total = 0;
    for (final h in p.holdings) {
      final q = p.quotes[h.stockId];
      if (q != null) total += h.shares * q.pricePerShare.cents;
    }
    return total;
  }

  int _cryptoHoldingsValue() {
    final p = ref.read(cryptoRepositoryProvider);
    var total = 0;
    for (final h in p.holdings) {
      final q = p.quotes[h.assetId];
      if (q != null) total += h.shares * q.pricePerShare.cents;
    }
    return total;
  }

  int _metalHoldingsValue() {
    final p = ref.read(metalRepositoryProvider);
    var total = 0;
    for (final h in p.holdings) {
      final q = p.quotes[h.assetId];
      if (q != null) total += h.shares * q.pricePerShare.cents;
    }
    return total;
  }

  /// Sprint C4: aktualisiert Peak und prüft, ob ein Panic-Sell-Event
  /// oder ein Held-Through-Crash-Event emittiert werden muss.
  ///
  /// Regeln:
  /// - currentValue > Peak → Peak hochsetzen.
  /// - soldDuringDrawdown == true und (Phase wieder normal ODER
  ///   currentValue >= soldValueCents) → `panicSellRealized` mit
  ///   lossCents = currentValue - soldValueCents.
  /// - soldDuringDrawdown == false und es war an einem der letzten
  ///   Tage ein `recoveryComplete` für diese Klasse → `heldThroughCrash`.
  void _checkPeakAndPanicSell(
    String classId,
    int currentValueCents,
    List<DayEvent> events,
    int dayIndex,
  ) {
    final tracker = ref.read(peakTrackerProvider.notifier);
    final phase = ref
        .read(marketPhaseRepositoryProvider.notifier)
        .phaseFor(classId);
    tracker.observeValue(classId, currentValueCents);
    final peak = tracker.peakFor(classId);

    // Held-Through-Crash: heutiges Recovery-Event und kein Sell-Flag.
    final recoveredToday = events.any((e) =>
        e is RecoveryCompleteEvent && e.assetClassId == classId);
    if (recoveredToday && !peak.soldDuringDrawdown) {
      events.add(DayEvent.heldThroughCrash(assetClassId: classId));
      return;
    }

    // Panic-Sell-Realized: Sell-Flag gesetzt und Markt zurück über
    // Verkaufs-Niveau (oder Phase wieder normal).
    if (peak.soldDuringDrawdown && peak.soldOnDay != null) {
      final recovered = phase is NormalPhase ||
          currentValueCents >= peak.soldValueCents;
      if (recovered) {
        final loss = currentValueCents - peak.soldValueCents;
        final currentPct = peak.drawdownFrom(currentValueCents);
        events.add(DayEvent.panicSellRealized(
          assetClassId: classId,
          lossCents: loss > 0 ? loss : 0,
          soldAtPct: peak.soldAtDrawdownPct,
          currentPct: currentPct,
          daysSinceSell: dayIndex - (peak.soldOnDay ?? dayIndex),
        ));
        tracker.clearPanicSell(classId);
      }
    }
  }

  /// Runs all listeners in [listeners] for [day] and collects their events.
  Future<List<DayEvent>> _runStage(
    List<DayEventListener> listeners,
    GameDay day,
  ) async {
    final result = <DayEvent>[];
    for (final listener in listeners) {
      result.addAll(await listener.onDayAdvance(day));
    }
    return result;
  }
}

/// Spec-20: aggregate result of [GameClock.fastForward].
///
/// All money values are in cents (positive = gain, negative = loss).
class FastForwardSummary {
  const FastForwardSummary({
    required this.totalDays,
    required this.cashBeforeCents,
    required this.cashAfterCents,
    required this.allowanceTotalCents,
    required this.harvestTotalCents,
    required this.etfDeltaCents,
    required this.stockDeltaCents,
    this.cryptoDeltaCents = 0,
    this.metalDeltaCents = 0,
    this.realEstateDeltaCents = 0,
    this.collectibleDeltaCents = 0,
    this.savingsDeltaCents = 0,
    this.vorsorgeDeltaCents = 0,
    required this.crashCount,
    required this.summaries,
    this.luckyEvents = const [],
    this.crisisDropPct = 0.0,
  });

  final int totalDays;
  final int cashBeforeCents;
  final int cashAfterCents;
  final int allowanceTotalCents;
  final int harvestTotalCents;
  final int etfDeltaCents;
  final int stockDeltaCents;
  final int cryptoDeltaCents;
  final int metalDeltaCents;

  /// Spec-43 follow-up: Immobilien-Marktwert-Delta.
  final int realEstateDeltaCents;

  /// Spec-43 follow-up: Sammlerobjekte-Marktwert-Delta.
  final int collectibleDeltaCents;

  /// Spec-43 follow-up: Sparkonto-Zins-Delta.
  final int savingsDeltaCents;

  /// Spec-43 follow-up: Vorsorge-Beitrag + Zulagen-Akkumulation.
  final int vorsorgeDeltaCents;

  final int crashCount;
  final List<DaySummary> summaries;

  /// Spec-44 follow-up: Lucky-Events während FastForward für Transparenz.
  /// Spieler sieht WAS passiert ist (Opa-Schenkung, Steuer-Rückzahlung,
  /// Werkstatt-Rechnung) — nicht nur Aggregat.
  final List<LuckyEventEntry> luckyEvents;

  /// B6: Stärke der Zeitsprung-Krise (0.0 = kein Krisenjahr).
  /// 0.10..0.50 wenn getroffen. Trifft Cash + Spar + ETF + Aktien +
  /// Krypto + Metalle gleichmäßig.
  final double crisisDropPct;

  int get cashDeltaCents => cashAfterCents - cashBeforeCents;
}

/// FastForward-Eintrag für einen LuckyEvent (Title + Netto-Cash-Effekt).
class LuckyEventEntry {
  const LuckyEventEntry({
    required this.title,
    required this.amountCents,
    required this.dayIndex,
  });
  final String title;
  final int amountCents;
  final int dayIndex;
}
