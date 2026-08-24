// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furniture_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-29 + spec-38 P2-19: tracks owned furniture items (multiple per slot
/// allowed) + which item is currently "active" in each slot for the Zimmer
/// diorama layout.
///
/// Welle-8: jetzt persistent (FurnitureTable, Drift v22). Vorher
/// in-memory-only → Möbel gingen bei jedem App-Neustart verloren
/// (Sohn-Bug "Stuhl weg nach Spiel verlassen").

@ProviderFor(FurnitureRepository)
final furnitureRepositoryProvider = FurnitureRepositoryProvider._();

/// Spec-29 + spec-38 P2-19: tracks owned furniture items (multiple per slot
/// allowed) + which item is currently "active" in each slot for the Zimmer
/// diorama layout.
///
/// Welle-8: jetzt persistent (FurnitureTable, Drift v22). Vorher
/// in-memory-only → Möbel gingen bei jedem App-Neustart verloren
/// (Sohn-Bug "Stuhl weg nach Spiel verlassen").
final class FurnitureRepositoryProvider
    extends $NotifierProvider<FurnitureRepository, Map<FurnitureSlot, String>> {
  /// Spec-29 + spec-38 P2-19: tracks owned furniture items (multiple per slot
  /// allowed) + which item is currently "active" in each slot for the Zimmer
  /// diorama layout.
  ///
  /// Welle-8: jetzt persistent (FurnitureTable, Drift v22). Vorher
  /// in-memory-only → Möbel gingen bei jedem App-Neustart verloren
  /// (Sohn-Bug "Stuhl weg nach Spiel verlassen").
  FurnitureRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'furnitureRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$furnitureRepositoryHash();

  @$internal
  @override
  FurnitureRepository create() => FurnitureRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<FurnitureSlot, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<FurnitureSlot, String>>(value),
    );
  }
}

String _$furnitureRepositoryHash() =>
    r'79d197e1dd0f611bdc5bd493a81e5d024cb984e8';

/// Spec-29 + spec-38 P2-19: tracks owned furniture items (multiple per slot
/// allowed) + which item is currently "active" in each slot for the Zimmer
/// diorama layout.
///
/// Welle-8: jetzt persistent (FurnitureTable, Drift v22). Vorher
/// in-memory-only → Möbel gingen bei jedem App-Neustart verloren
/// (Sohn-Bug "Stuhl weg nach Spiel verlassen").

abstract class _$FurnitureRepository
    extends $Notifier<Map<FurnitureSlot, String>> {
  Map<FurnitureSlot, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<FurnitureSlot, String>, Map<FurnitureSlot, String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<FurnitureSlot, String>,
                Map<FurnitureSlot, String>
              >,
              Map<FurnitureSlot, String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
