// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collectible_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-38 Welle 5: persistente Sammlerobjekt-Holdings.
/// Mehrere Exemplare pro specId möglich — jede Holding hat eigene
/// Drift-row-id und boughtAtDayIndex (für Wertberechnung).

@ProviderFor(CollectibleRepository)
final collectibleRepositoryProvider = CollectibleRepositoryProvider._();

/// Spec-38 Welle 5: persistente Sammlerobjekt-Holdings.
/// Mehrere Exemplare pro specId möglich — jede Holding hat eigene
/// Drift-row-id und boughtAtDayIndex (für Wertberechnung).
final class CollectibleRepositoryProvider
    extends $NotifierProvider<CollectibleRepository, List<CollectibleHolding>> {
  /// Spec-38 Welle 5: persistente Sammlerobjekt-Holdings.
  /// Mehrere Exemplare pro specId möglich — jede Holding hat eigene
  /// Drift-row-id und boughtAtDayIndex (für Wertberechnung).
  CollectibleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectibleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectibleRepositoryHash();

  @$internal
  @override
  CollectibleRepository create() => CollectibleRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CollectibleHolding> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CollectibleHolding>>(value),
    );
  }
}

String _$collectibleRepositoryHash() =>
    r'3f31d2b6e2cdaff8b12e893597ac4612504ffce2';

/// Spec-38 Welle 5: persistente Sammlerobjekt-Holdings.
/// Mehrere Exemplare pro specId möglich — jede Holding hat eigene
/// Drift-row-id und boughtAtDayIndex (für Wertberechnung).

abstract class _$CollectibleRepository
    extends $Notifier<List<CollectibleHolding>> {
  List<CollectibleHolding> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<CollectibleHolding>, List<CollectibleHolding>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CollectibleHolding>, List<CollectibleHolding>>,
              List<CollectibleHolding>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
