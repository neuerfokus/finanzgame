// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_goal.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-41 + B7: claimed-state pro dayIndex. B7: jetzt persistent via
/// SettingsRepository.lastClaimedGoalDay — Banner kommt nach App-
/// Restart nicht wieder. Nur der zuletzt geclaimte Tag wird gehalten
/// (alte Tage interessieren nicht, Banner zeigt nur aktuelles dayIndex).

@ProviderFor(DailyGoalClaimed)
final dailyGoalClaimedProvider = DailyGoalClaimedProvider._();

/// Spec-41 + B7: claimed-state pro dayIndex. B7: jetzt persistent via
/// SettingsRepository.lastClaimedGoalDay — Banner kommt nach App-
/// Restart nicht wieder. Nur der zuletzt geclaimte Tag wird gehalten
/// (alte Tage interessieren nicht, Banner zeigt nur aktuelles dayIndex).
final class DailyGoalClaimedProvider
    extends $NotifierProvider<DailyGoalClaimed, Set<int>> {
  /// Spec-41 + B7: claimed-state pro dayIndex. B7: jetzt persistent via
  /// SettingsRepository.lastClaimedGoalDay — Banner kommt nach App-
  /// Restart nicht wieder. Nur der zuletzt geclaimte Tag wird gehalten
  /// (alte Tage interessieren nicht, Banner zeigt nur aktuelles dayIndex).
  DailyGoalClaimedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyGoalClaimedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyGoalClaimedHash();

  @$internal
  @override
  DailyGoalClaimed create() => DailyGoalClaimed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$dailyGoalClaimedHash() => r'bdcb69b7fe6a815a40c19ae9aa61d83647b6614b';

/// Spec-41 + B7: claimed-state pro dayIndex. B7: jetzt persistent via
/// SettingsRepository.lastClaimedGoalDay — Banner kommt nach App-
/// Restart nicht wieder. Nur der zuletzt geclaimte Tag wird gehalten
/// (alte Tage interessieren nicht, Banner zeigt nur aktuelles dayIndex).

abstract class _$DailyGoalClaimed extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
