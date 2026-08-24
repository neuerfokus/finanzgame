// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifetime_harvest_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lifetime cents earned from plant harvests.
///
/// Seeded from [DbSnapshot.lifetimeHarvestCents]; incremented by
/// [PlantRepository.harvest]. Used by [MonetariaUnlocker] to gate the
/// ETF-island unlock (≥ 20 €). Only ever grows.

@ProviderFor(LifetimeHarvestState)
final lifetimeHarvestStateProvider = LifetimeHarvestStateProvider._();

/// Lifetime cents earned from plant harvests.
///
/// Seeded from [DbSnapshot.lifetimeHarvestCents]; incremented by
/// [PlantRepository.harvest]. Used by [MonetariaUnlocker] to gate the
/// ETF-island unlock (≥ 20 €). Only ever grows.
final class LifetimeHarvestStateProvider
    extends $NotifierProvider<LifetimeHarvestState, int> {
  /// Lifetime cents earned from plant harvests.
  ///
  /// Seeded from [DbSnapshot.lifetimeHarvestCents]; incremented by
  /// [PlantRepository.harvest]. Used by [MonetariaUnlocker] to gate the
  /// ETF-island unlock (≥ 20 €). Only ever grows.
  LifetimeHarvestStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lifetimeHarvestStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lifetimeHarvestStateHash();

  @$internal
  @override
  LifetimeHarvestState create() => LifetimeHarvestState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$lifetimeHarvestStateHash() =>
    r'49674ac4eb4dd811b95f7a14af2f93829951fb2f';

/// Lifetime cents earned from plant harvests.
///
/// Seeded from [DbSnapshot.lifetimeHarvestCents]; incremented by
/// [PlantRepository.harvest]. Used by [MonetariaUnlocker] to gate the
/// ETF-island unlock (≥ 20 €). Only ever grows.

abstract class _$LifetimeHarvestState extends $Notifier<int> {
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
