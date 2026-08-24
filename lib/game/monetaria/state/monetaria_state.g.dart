// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetaria_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state for Monetaria-Hub island unlocks.
///
/// Loads persisted unlocks from [DbSnapshot.unlockedIslands] on build; an
/// empty snapshot falls back to [kDefaultUnlocks]. [unlock] writes
/// fire-and-forget to keep the API synchronous.

@ProviderFor(MonetariaState)
final monetariaStateProvider = MonetariaStateProvider._();

/// Riverpod state for Monetaria-Hub island unlocks.
///
/// Loads persisted unlocks from [DbSnapshot.unlockedIslands] on build; an
/// empty snapshot falls back to [kDefaultUnlocks]. [unlock] writes
/// fire-and-forget to keep the API synchronous.
final class MonetariaStateProvider
    extends $NotifierProvider<MonetariaState, Set<String>> {
  /// Riverpod state for Monetaria-Hub island unlocks.
  ///
  /// Loads persisted unlocks from [DbSnapshot.unlockedIslands] on build; an
  /// empty snapshot falls back to [kDefaultUnlocks]. [unlock] writes
  /// fire-and-forget to keep the API synchronous.
  MonetariaStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monetariaStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monetariaStateHash();

  @$internal
  @override
  MonetariaState create() => MonetariaState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$monetariaStateHash() => r'5d317d3beb29304c04c57bfb17238cf928429629';

/// Riverpod state for Monetaria-Hub island unlocks.
///
/// Loads persisted unlocks from [DbSnapshot.unlockedIslands] on build; an
/// empty snapshot falls back to [kDefaultUnlocks]. [unlock] writes
/// fire-and-forget to keep the API synchronous.

abstract class _$MonetariaState extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
