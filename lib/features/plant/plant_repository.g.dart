// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted plant store. Seeds empty on first run; loads from
/// [PlantsTable] during pre-warm.

@ProviderFor(PlantRepository)
final plantRepositoryProvider = PlantRepositoryProvider._();

/// Persisted plant store. Seeds empty on first run; loads from
/// [PlantsTable] during pre-warm.
final class PlantRepositoryProvider
    extends $NotifierProvider<PlantRepository, List<Plant>> {
  /// Persisted plant store. Seeds empty on first run; loads from
  /// [PlantsTable] during pre-warm.
  PlantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantRepositoryHash();

  @$internal
  @override
  PlantRepository create() => PlantRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Plant> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Plant>>(value),
    );
  }
}

String _$plantRepositoryHash() => r'20841446a3f13d26091c25610d77a8a9df4095ba';

/// Persisted plant store. Seeds empty on first run; loads from
/// [PlantsTable] during pre-warm.

abstract class _$PlantRepository extends $Notifier<List<Plant>> {
  List<Plant> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Plant>, List<Plant>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Plant>, List<Plant>>,
              List<Plant>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
