// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metal_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted metal portfolio + quotes. Seeds from [MetalCatalog] when DB
/// is empty. Spec-22.

@ProviderFor(MetalRepository)
final metalRepositoryProvider = MetalRepositoryProvider._();

/// Persisted metal portfolio + quotes. Seeds from [MetalCatalog] when DB
/// is empty. Spec-22.
final class MetalRepositoryProvider
    extends $NotifierProvider<MetalRepository, MetalPortfolio> {
  /// Persisted metal portfolio + quotes. Seeds from [MetalCatalog] when DB
  /// is empty. Spec-22.
  MetalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metalRepositoryHash();

  @$internal
  @override
  MetalRepository create() => MetalRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MetalPortfolio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MetalPortfolio>(value),
    );
  }
}

String _$metalRepositoryHash() => r'90285e8ce2ef9904bfa86f589967588ba64b9ef4';

/// Persisted metal portfolio + quotes. Seeds from [MetalCatalog] when DB
/// is empty. Spec-22.

abstract class _$MetalRepository extends $Notifier<MetalPortfolio> {
  MetalPortfolio build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MetalPortfolio, MetalPortfolio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MetalPortfolio, MetalPortfolio>,
              MetalPortfolio,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
