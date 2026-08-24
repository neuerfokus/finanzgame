// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decor_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-43 Stage 1: persistente Decor-Platzierungen pro Insel.
///
/// Hält den Vollzustand im Speicher (klein, max ~9 × 8 = 72 Einträge),
/// schreibt Mutationen sofort in Drift via [IslandDecorDao].

@ProviderFor(DecorRepository)
final decorRepositoryProvider = DecorRepositoryProvider._();

/// Spec-43 Stage 1: persistente Decor-Platzierungen pro Insel.
///
/// Hält den Vollzustand im Speicher (klein, max ~9 × 8 = 72 Einträge),
/// schreibt Mutationen sofort in Drift via [IslandDecorDao].
final class DecorRepositoryProvider
    extends $NotifierProvider<DecorRepository, List<DecorPlacement>> {
  /// Spec-43 Stage 1: persistente Decor-Platzierungen pro Insel.
  ///
  /// Hält den Vollzustand im Speicher (klein, max ~9 × 8 = 72 Einträge),
  /// schreibt Mutationen sofort in Drift via [IslandDecorDao].
  DecorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'decorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$decorRepositoryHash();

  @$internal
  @override
  DecorRepository create() => DecorRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DecorPlacement> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DecorPlacement>>(value),
    );
  }
}

String _$decorRepositoryHash() => r'cff0bb456a331f34588aa0cb06a6d1b684b49398';

/// Spec-43 Stage 1: persistente Decor-Platzierungen pro Insel.
///
/// Hält den Vollzustand im Speicher (klein, max ~9 × 8 = 72 Einträge),
/// schreibt Mutationen sofort in Drift via [IslandDecorDao].

abstract class _$DecorRepository extends $Notifier<List<DecorPlacement>> {
  List<DecorPlacement> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<DecorPlacement>, List<DecorPlacement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DecorPlacement>, List<DecorPlacement>>,
              List<DecorPlacement>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
