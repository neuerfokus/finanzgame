// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etf_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted ETF portfolio + price book.
///
/// Seed = quotes from [EtfCatalog] on first build (or empty DB). Loaded
/// from `EtfHoldingsTable` + `EtfQuotesTable` during pre-warm.

@ProviderFor(EtfRepository)
final etfRepositoryProvider = EtfRepositoryProvider._();

/// Persisted ETF portfolio + price book.
///
/// Seed = quotes from [EtfCatalog] on first build (or empty DB). Loaded
/// from `EtfHoldingsTable` + `EtfQuotesTable` during pre-warm.
final class EtfRepositoryProvider
    extends $NotifierProvider<EtfRepository, EtfPortfolio> {
  /// Persisted ETF portfolio + price book.
  ///
  /// Seed = quotes from [EtfCatalog] on first build (or empty DB). Loaded
  /// from `EtfHoldingsTable` + `EtfQuotesTable` during pre-warm.
  EtfRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'etfRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$etfRepositoryHash();

  @$internal
  @override
  EtfRepository create() => EtfRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EtfPortfolio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EtfPortfolio>(value),
    );
  }
}

String _$etfRepositoryHash() => r'd9107ee999023b9a10c120adca3dcd3ca9b56bf3';

/// Persisted ETF portfolio + price book.
///
/// Seed = quotes from [EtfCatalog] on first build (or empty DB). Loaded
/// from `EtfHoldingsTable` + `EtfQuotesTable` during pre-warm.

abstract class _$EtfRepository extends $Notifier<EtfPortfolio> {
  EtfPortfolio build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EtfPortfolio, EtfPortfolio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EtfPortfolio, EtfPortfolio>,
              EtfPortfolio,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
