// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted unlocked achievement IDs keyed by id → dayIndex of unlock.
///
/// `keepAlive: true`. Hydrated from [DbSnapshot.achievements]. Adds are
/// idempotent (re-inserting an id is a no-op) so the GameClock can run the
/// rule evaluator every day without spam.

@ProviderFor(AchievementsRepository)
final achievementsRepositoryProvider = AchievementsRepositoryProvider._();

/// Persisted unlocked achievement IDs keyed by id → dayIndex of unlock.
///
/// `keepAlive: true`. Hydrated from [DbSnapshot.achievements]. Adds are
/// idempotent (re-inserting an id is a no-op) so the GameClock can run the
/// rule evaluator every day without spam.
final class AchievementsRepositoryProvider
    extends $NotifierProvider<AchievementsRepository, Map<String, int>> {
  /// Persisted unlocked achievement IDs keyed by id → dayIndex of unlock.
  ///
  /// `keepAlive: true`. Hydrated from [DbSnapshot.achievements]. Adds are
  /// idempotent (re-inserting an id is a no-op) so the GameClock can run the
  /// rule evaluator every day without spam.
  AchievementsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementsRepositoryHash();

  @$internal
  @override
  AchievementsRepository create() => AchievementsRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$achievementsRepositoryHash() =>
    r'a6d046d87f957754c0ac27a08c611a18ef73b045';

/// Persisted unlocked achievement IDs keyed by id → dayIndex of unlock.
///
/// `keepAlive: true`. Hydrated from [DbSnapshot.achievements]. Adds are
/// idempotent (re-inserting an id is a no-op) so the GameClock can run the
/// rule evaluator every day without spam.

abstract class _$AchievementsRepository extends $Notifier<Map<String, int>> {
  Map<String, int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, int>, Map<String, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, int>, Map<String, int>>,
              Map<String, int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Spec-43 v4: meldet UI-Listener wenn frisch unlocked.
/// State = (id, ticks) — ticks++ bei jedem fire damit ref.listen
/// auch identische IDs erneut triggert (z.B. mehrere Achievements
/// am selben Tag).

@ProviderFor(LastAchievementUnlock)
final lastAchievementUnlockProvider = LastAchievementUnlockProvider._();

/// Spec-43 v4: meldet UI-Listener wenn frisch unlocked.
/// State = (id, ticks) — ticks++ bei jedem fire damit ref.listen
/// auch identische IDs erneut triggert (z.B. mehrere Achievements
/// am selben Tag).
final class LastAchievementUnlockProvider
    extends $NotifierProvider<LastAchievementUnlock, ({String? id, int tick})> {
  /// Spec-43 v4: meldet UI-Listener wenn frisch unlocked.
  /// State = (id, ticks) — ticks++ bei jedem fire damit ref.listen
  /// auch identische IDs erneut triggert (z.B. mehrere Achievements
  /// am selben Tag).
  LastAchievementUnlockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastAchievementUnlockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastAchievementUnlockHash();

  @$internal
  @override
  LastAchievementUnlock create() => LastAchievementUnlock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({String? id, int tick}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({String? id, int tick})>(value),
    );
  }
}

String _$lastAchievementUnlockHash() =>
    r'bf9cfd7ff9f37216ce5de8bb3dc31adf19ac97c9';

/// Spec-43 v4: meldet UI-Listener wenn frisch unlocked.
/// State = (id, ticks) — ticks++ bei jedem fire damit ref.listen
/// auch identische IDs erneut triggert (z.B. mehrere Achievements
/// am selben Tag).

abstract class _$LastAchievementUnlock
    extends $Notifier<({String? id, int tick})> {
  ({String? id, int tick}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<({String? id, int tick}), ({String? id, int tick})>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<({String? id, int tick}), ({String? id, int tick})>,
              ({String? id, int tick}),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
