// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted stock portfolio + quotes. Seeds from [StockCatalog] when DB
/// is empty.

@ProviderFor(StockRepository)
final stockRepositoryProvider = StockRepositoryProvider._();

/// Persisted stock portfolio + quotes. Seeds from [StockCatalog] when DB
/// is empty.
final class StockRepositoryProvider
    extends $NotifierProvider<StockRepository, StockPortfolio> {
  /// Persisted stock portfolio + quotes. Seeds from [StockCatalog] when DB
  /// is empty.
  StockRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockRepositoryHash();

  @$internal
  @override
  StockRepository create() => StockRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockPortfolio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockPortfolio>(value),
    );
  }
}

String _$stockRepositoryHash() => r'06ffe49b045a8aec39674ef9656813ebb12ba05b';

/// Persisted stock portfolio + quotes. Seeds from [StockCatalog] when DB
/// is empty.

abstract class _$StockRepository extends $Notifier<StockPortfolio> {
  StockPortfolio build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StockPortfolio, StockPortfolio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StockPortfolio, StockPortfolio>,
              StockPortfolio,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
