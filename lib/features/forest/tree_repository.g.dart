// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-45 H3: Mischwald-Wald-Wirtschaft.
///
/// In-Memory KeepAlive (bis Drift-Sammelmigration). Bäume verlieren
/// sich bei App-Restart — akzeptabel für Beta. Day-Listener bucht
/// Holz-Income für reife Bäume pro Tag.

@ProviderFor(TreeRepository)
final treeRepositoryProvider = TreeRepositoryProvider._();

/// Spec-45 H3: Mischwald-Wald-Wirtschaft.
///
/// In-Memory KeepAlive (bis Drift-Sammelmigration). Bäume verlieren
/// sich bei App-Restart — akzeptabel für Beta. Day-Listener bucht
/// Holz-Income für reife Bäume pro Tag.
final class TreeRepositoryProvider
    extends $NotifierProvider<TreeRepository, List<PlantedTree>> {
  /// Spec-45 H3: Mischwald-Wald-Wirtschaft.
  ///
  /// In-Memory KeepAlive (bis Drift-Sammelmigration). Bäume verlieren
  /// sich bei App-Restart — akzeptabel für Beta. Day-Listener bucht
  /// Holz-Income für reife Bäume pro Tag.
  TreeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'treeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$treeRepositoryHash();

  @$internal
  @override
  TreeRepository create() => TreeRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PlantedTree> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PlantedTree>>(value),
    );
  }
}

String _$treeRepositoryHash() => r'11118bf4845c6a73c4f7e2da21bdbe7d3e3799e1';

/// Spec-45 H3: Mischwald-Wald-Wirtschaft.
///
/// In-Memory KeepAlive (bis Drift-Sammelmigration). Bäume verlieren
/// sich bei App-Restart — akzeptabel für Beta. Day-Listener bucht
/// Holz-Income für reife Bäume pro Tag.

abstract class _$TreeRepository extends $Notifier<List<PlantedTree>> {
  List<PlantedTree> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<PlantedTree>, List<PlantedTree>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<PlantedTree>, List<PlantedTree>>,
              List<PlantedTree>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
