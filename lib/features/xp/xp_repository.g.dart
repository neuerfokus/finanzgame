// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lifetime XP total (spec-21).
///
/// State = total earned XP. Mutator [add] bumps the counter synchronously
/// and persists fire-and-forget so callers (listeners, controllers, repos)
/// stay sync.
///
/// XP sources (each adds via [add]):
/// - quest complete: +10
/// - daily quiz correct: +5 (hook reserved for spec-17)
/// - plant harvest: +2
/// - ETF buy: +3, ETF sell: +1
/// - stock buy: +5
/// - sleep (per advanceDay): +1

@ProviderFor(XpRepository)
final xpRepositoryProvider = XpRepositoryProvider._();

/// Lifetime XP total (spec-21).
///
/// State = total earned XP. Mutator [add] bumps the counter synchronously
/// and persists fire-and-forget so callers (listeners, controllers, repos)
/// stay sync.
///
/// XP sources (each adds via [add]):
/// - quest complete: +10
/// - daily quiz correct: +5 (hook reserved for spec-17)
/// - plant harvest: +2
/// - ETF buy: +3, ETF sell: +1
/// - stock buy: +5
/// - sleep (per advanceDay): +1
final class XpRepositoryProvider extends $NotifierProvider<XpRepository, int> {
  /// Lifetime XP total (spec-21).
  ///
  /// State = total earned XP. Mutator [add] bumps the counter synchronously
  /// and persists fire-and-forget so callers (listeners, controllers, repos)
  /// stay sync.
  ///
  /// XP sources (each adds via [add]):
  /// - quest complete: +10
  /// - daily quiz correct: +5 (hook reserved for spec-17)
  /// - plant harvest: +2
  /// - ETF buy: +3, ETF sell: +1
  /// - stock buy: +5
  /// - sleep (per advanceDay): +1
  XpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xpRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xpRepositoryHash();

  @$internal
  @override
  XpRepository create() => XpRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$xpRepositoryHash() => r'a410d0d26085a2c40fe692ba3bfcb948001be5b2';

/// Lifetime XP total (spec-21).
///
/// State = total earned XP. Mutator [add] bumps the counter synchronously
/// and persists fire-and-forget so callers (listeners, controllers, repos)
/// stay sync.
///
/// XP sources (each adds via [add]):
/// - quest complete: +10
/// - daily quiz correct: +5 (hook reserved for spec-17)
/// - plant harvest: +2
/// - ETF buy: +3, ETF sell: +1
/// - stock buy: +5
/// - sleep (per advanceDay): +1

abstract class _$XpRepository extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Round 28: meldet UI-Listener wenn ein neues Level erreicht wurde.
/// Analog zu [LastAchievementUnlock] — `tick` zählt hoch damit
/// `ref.listen` auch bei mehreren Level-Ups hintereinander feuert.

@ProviderFor(LastLevelUp)
final lastLevelUpProvider = LastLevelUpProvider._();

/// Round 28: meldet UI-Listener wenn ein neues Level erreicht wurde.
/// Analog zu [LastAchievementUnlock] — `tick` zählt hoch damit
/// `ref.listen` auch bei mehreren Level-Ups hintereinander feuert.
final class LastLevelUpProvider
    extends
        $NotifierProvider<
          LastLevelUp,
          ({int? level, int rewardCents, int tick})
        > {
  /// Round 28: meldet UI-Listener wenn ein neues Level erreicht wurde.
  /// Analog zu [LastAchievementUnlock] — `tick` zählt hoch damit
  /// `ref.listen` auch bei mehreren Level-Ups hintereinander feuert.
  LastLevelUpProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastLevelUpProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastLevelUpHash();

  @$internal
  @override
  LastLevelUp create() => LastLevelUp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int? level, int rewardCents, int tick}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<({int? level, int rewardCents, int tick})>(value),
    );
  }
}

String _$lastLevelUpHash() => r'0bb875cacdcdfd8e72011993a139a6929a9c5aff';

/// Round 28: meldet UI-Listener wenn ein neues Level erreicht wurde.
/// Analog zu [LastAchievementUnlock] — `tick` zählt hoch damit
/// `ref.listen` auch bei mehreren Level-Ups hintereinander feuert.

abstract class _$LastLevelUp
    extends $Notifier<({int? level, int rewardCents, int tick})> {
  ({int? level, int rewardCents, int tick}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              ({int? level, int rewardCents, int tick}),
              ({int? level, int rewardCents, int tick})
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({int? level, int rewardCents, int tick}),
                ({int? level, int rewardCents, int tick})
              >,
              ({int? level, int rewardCents, int tick}),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
