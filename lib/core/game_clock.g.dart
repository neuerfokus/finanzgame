// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_clock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Listeners for the Allowance stage. Spec-15 reads amount + weekday from
/// [SettingsRepository] so the player can tweak both in [SettingsPage].

@ProviderFor(allowanceListeners)
final allowanceListenersProvider = AllowanceListenersProvider._();

/// Listeners for the Allowance stage. Spec-15 reads amount + weekday from
/// [SettingsRepository] so the player can tweak both in [SettingsPage].

final class AllowanceListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the Allowance stage. Spec-15 reads amount + weekday from
  /// [SettingsRepository] so the player can tweak both in [SettingsPage].
  AllowanceListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allowanceListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allowanceListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return allowanceListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$allowanceListenersHash() =>
    r'c4a76f837f0e1540fae237d2d2d211bfb35a4fc8';

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

@ProviderFor(interestListeners)
final interestListenersProvider = InterestListenersProvider._();

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

final class InterestListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
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
  InterestListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return interestListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$interestListenersHash() => r'f511c85b84dc274e89114bf063fa21c868ad72d5';

/// Listeners for the Plant stage. Sprint 5 binds the listener to the
/// [PlantRepository] so growth events fire on each [GameClock.advanceDay].
/// Spec-18: also passes a deterministic per-day weather lookup so plant
/// growth + storm-wither react to weather.

@ProviderFor(plantListeners)
final plantListenersProvider = PlantListenersProvider._();

/// Listeners for the Plant stage. Sprint 5 binds the listener to the
/// [PlantRepository] so growth events fire on each [GameClock.advanceDay].
/// Spec-18: also passes a deterministic per-day weather lookup so plant
/// growth + storm-wither react to weather.

final class PlantListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the Plant stage. Sprint 5 binds the listener to the
  /// [PlantRepository] so growth events fire on each [GameClock.advanceDay].
  /// Spec-18: also passes a deterministic per-day weather lookup so plant
  /// growth + storm-wither react to weather.
  PlantListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return plantListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$plantListenersHash() => r'ba185ed5620227a1f3a7ea1849acb61216f231f6';

/// Listeners for the Inflation stage. Sprint 8 binds [InflationListener]
/// to [WishlistRepository] so each `advanceDay()` drifts wishlist prices.

@ProviderFor(inflationListeners)
final inflationListenersProvider = InflationListenersProvider._();

/// Listeners for the Inflation stage. Sprint 8 binds [InflationListener]
/// to [WishlistRepository] so each `advanceDay()` drifts wishlist prices.

final class InflationListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the Inflation stage. Sprint 8 binds [InflationListener]
  /// to [WishlistRepository] so each `advanceDay()` drifts wishlist prices.
  InflationListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inflationListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inflationListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return inflationListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$inflationListenersHash() =>
    r'e1770cf9032577ba670202c3ab347345d4e9f0c1';

/// Listeners for the Weather stage. Sprint 7 binds the global weather
/// roll to [WeatherState] (deterministic per dayIndex).

@ProviderFor(weatherListeners)
final weatherListenersProvider = WeatherListenersProvider._();

/// Listeners for the Weather stage. Sprint 7 binds the global weather
/// roll to [WeatherState] (deterministic per dayIndex).

final class WeatherListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the Weather stage. Sprint 7 binds the global weather
  /// roll to [WeatherState] (deterministic per dayIndex).
  WeatherListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return weatherListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$weatherListenersHash() => r'91c8ad0bc46929edf7fab80a12bab3b6bd5c03fb';

/// Listeners for the ETF-price stage. Added in Sprint 7 between weather +
/// birthday in the pipeline order. Sprint B: liest aktuelle MarketPhase
/// für die `etf`-Klasse und appliziert sie zusätzlich zum Drift.

@ProviderFor(etfPriceListeners)
final etfPriceListenersProvider = EtfPriceListenersProvider._();

/// Listeners for the ETF-price stage. Added in Sprint 7 between weather +
/// birthday in the pipeline order. Sprint B: liest aktuelle MarketPhase
/// für die `etf`-Klasse und appliziert sie zusätzlich zum Drift.

final class EtfPriceListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the ETF-price stage. Added in Sprint 7 between weather +
  /// birthday in the pipeline order. Sprint B: liest aktuelle MarketPhase
  /// für die `etf`-Klasse und appliziert sie zusätzlich zum Drift.
  EtfPriceListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'etfPriceListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$etfPriceListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return etfPriceListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$etfPriceListenersHash() => r'dce765dfb6791d891195175f09fededbca039866';

/// Listeners for the stock-price stage (Sprint 9, after etfPrice).

@ProviderFor(stockPriceListeners)
final stockPriceListenersProvider = StockPriceListenersProvider._();

/// Listeners for the stock-price stage (Sprint 9, after etfPrice).

final class StockPriceListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the stock-price stage (Sprint 9, after etfPrice).
  StockPriceListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockPriceListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockPriceListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return stockPriceListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$stockPriceListenersHash() =>
    r'dd7ea85230b2f2554f82f76ba01e941000d891d3';

/// Sprint B: Markt-Phase-Resolver — läuft VOR den Preis-Listenern.
/// Pures, deterministisches State-Maschine pro Asset-Klasse.

@ProviderFor(marketPhaseListeners)
final marketPhaseListenersProvider = MarketPhaseListenersProvider._();

/// Sprint B: Markt-Phase-Resolver — läuft VOR den Preis-Listenern.
/// Pures, deterministisches State-Maschine pro Asset-Klasse.

final class MarketPhaseListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Sprint B: Markt-Phase-Resolver — läuft VOR den Preis-Listenern.
  /// Pures, deterministisches State-Maschine pro Asset-Klasse.
  MarketPhaseListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketPhaseListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketPhaseListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return marketPhaseListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$marketPhaseListenersHash() =>
    r'426ec26b2e58c9f9f98473c726712ed9cf178e4f';

/// Listeners for the Birthday stage.
///
/// Sprint 1: hard-coded birthday on day 100 (year 0, day-of-year 100).
/// Sprint 5: read birthday from PlayerRepository during onboarding.

@ProviderFor(birthdayListeners)
final birthdayListenersProvider = BirthdayListenersProvider._();

/// Listeners for the Birthday stage.
///
/// Sprint 1: hard-coded birthday on day 100 (year 0, day-of-year 100).
/// Sprint 5: read birthday from PlayerRepository during onboarding.

final class BirthdayListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the Birthday stage.
  ///
  /// Sprint 1: hard-coded birthday on day 100 (year 0, day-of-year 100).
  /// Sprint 5: read birthday from PlayerRepository during onboarding.
  BirthdayListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'birthdayListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$birthdayListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return birthdayListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$birthdayListenersHash() => r'a1ee6eaaf78a5bd770781344277c1f53dcf8e824';

/// Listeners for the Temptation stage.

@ProviderFor(temptationListeners)
final temptationListenersProvider = TemptationListenersProvider._();

/// Listeners for the Temptation stage.

final class TemptationListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Listeners for the Temptation stage.
  TemptationListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temptationListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temptationListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return temptationListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$temptationListenersHash() =>
    r'b24f67beb1f5d2c15973a55500361e4bccf2fb4f';

@ProviderFor(luckyEventListeners)
final luckyEventListenersProvider = LuckyEventListenersProvider._();

final class LuckyEventListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  LuckyEventListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'luckyEventListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$luckyEventListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return luckyEventListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$luckyEventListenersHash() =>
    r'192aa94de9c3211b2dddddc05cb0d3c2011debc8';

/// Round 28: Saisonale Lehr-Karten (Black Friday, Weihnachtsgeld-Tipp).

@ProviderFor(seasonalEventListeners)
final seasonalEventListenersProvider = SeasonalEventListenersProvider._();

/// Round 28: Saisonale Lehr-Karten (Black Friday, Weihnachtsgeld-Tipp).

final class SeasonalEventListenersProvider
    extends
        $FunctionalProvider<
          List<DayEventListener>,
          List<DayEventListener>,
          List<DayEventListener>
        >
    with $Provider<List<DayEventListener>> {
  /// Round 28: Saisonale Lehr-Karten (Black Friday, Weihnachtsgeld-Tipp).
  SeasonalEventListenersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalEventListenersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalEventListenersHash();

  @$internal
  @override
  $ProviderElement<List<DayEventListener>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DayEventListener> create(Ref ref) {
    return seasonalEventListeners(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DayEventListener> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DayEventListener>>(value),
    );
  }
}

String _$seasonalEventListenersHash() =>
    r'23927cc9f2b36833f31b23e7813eca4c04375ee4';

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

@ProviderFor(GameClock)
final gameClockProvider = GameClockProvider._();

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
final class GameClockProvider extends $NotifierProvider<GameClock, GameDay> {
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
  GameClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameClockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameClockHash();

  @$internal
  @override
  GameClock create() => GameClock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameDay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameDay>(value),
    );
  }
}

String _$gameClockHash() => r'222fb0f5133a5748663a5fb59c1967c3d817d0a1';

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

abstract class _$GameClock extends $Notifier<GameDay> {
  GameDay build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameDay, GameDay>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameDay, GameDay>,
              GameDay,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
