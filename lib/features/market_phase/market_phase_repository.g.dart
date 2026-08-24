// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_phase_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-Memory-Halter der aktuellen [MarketPhase] pro Asset-Klasse.
///
/// Sprint B v1: keine Persistenz — Phase resettet bei App-Kaltstart.
/// Persistenz folgt in Sprint H (schemaVersion 13 → 14).

@ProviderFor(MarketPhaseRepository)
final marketPhaseRepositoryProvider = MarketPhaseRepositoryProvider._();

/// In-Memory-Halter der aktuellen [MarketPhase] pro Asset-Klasse.
///
/// Sprint B v1: keine Persistenz — Phase resettet bei App-Kaltstart.
/// Persistenz folgt in Sprint H (schemaVersion 13 → 14).
final class MarketPhaseRepositoryProvider
    extends $NotifierProvider<MarketPhaseRepository, Map<String, MarketPhase>> {
  /// In-Memory-Halter der aktuellen [MarketPhase] pro Asset-Klasse.
  ///
  /// Sprint B v1: keine Persistenz — Phase resettet bei App-Kaltstart.
  /// Persistenz folgt in Sprint H (schemaVersion 13 → 14).
  MarketPhaseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketPhaseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketPhaseRepositoryHash();

  @$internal
  @override
  MarketPhaseRepository create() => MarketPhaseRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, MarketPhase> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, MarketPhase>>(value),
    );
  }
}

String _$marketPhaseRepositoryHash() =>
    r'b3ac79e460473d28510e740a9e2f76729e3d9e64';

/// In-Memory-Halter der aktuellen [MarketPhase] pro Asset-Klasse.
///
/// Sprint B v1: keine Persistenz — Phase resettet bei App-Kaltstart.
/// Persistenz folgt in Sprint H (schemaVersion 13 → 14).

abstract class _$MarketPhaseRepository
    extends $Notifier<Map<String, MarketPhase>> {
  Map<String, MarketPhase> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, MarketPhase>, Map<String, MarketPhase>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, MarketPhase>, Map<String, MarketPhase>>,
              Map<String, MarketPhase>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
