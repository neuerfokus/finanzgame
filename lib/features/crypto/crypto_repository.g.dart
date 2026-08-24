// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted crypto portfolio + quotes. Seeds from [CryptoCatalog] when DB
/// is empty. Spec-22.

@ProviderFor(CryptoRepository)
final cryptoRepositoryProvider = CryptoRepositoryProvider._();

/// Persisted crypto portfolio + quotes. Seeds from [CryptoCatalog] when DB
/// is empty. Spec-22.
final class CryptoRepositoryProvider
    extends $NotifierProvider<CryptoRepository, CryptoPortfolio> {
  /// Persisted crypto portfolio + quotes. Seeds from [CryptoCatalog] when DB
  /// is empty. Spec-22.
  CryptoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cryptoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cryptoRepositoryHash();

  @$internal
  @override
  CryptoRepository create() => CryptoRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CryptoPortfolio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CryptoPortfolio>(value),
    );
  }
}

String _$cryptoRepositoryHash() => r'68d4ad3e40e29e60c6ab106ddc90e644c7c53e4c';

/// Persisted crypto portfolio + quotes. Seeds from [CryptoCatalog] when DB
/// is empty. Spec-22.

abstract class _$CryptoRepository extends $Notifier<CryptoPortfolio> {
  CryptoPortfolio build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CryptoPortfolio, CryptoPortfolio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CryptoPortfolio, CryptoPortfolio>,
              CryptoPortfolio,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
