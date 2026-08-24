// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_estate_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// spec-35 phase B + spec-44 sprint D: Immobilien-Portfolio.
///
/// Sprint D: Hypothek-Hebel + Kaufnebenkosten + Instandhaltung +
/// Mieteinnahmen (nur MFH) + Spekulationssteuer (< 10 J, vermietet).
///
/// Klumpenrisiko: TODO — negative Gewichtung in der
/// E2-Diversifikations-Logik kommt in einem spaeteren Sprint.

@ProviderFor(RealEstateRepository)
final realEstateRepositoryProvider = RealEstateRepositoryProvider._();

/// spec-35 phase B + spec-44 sprint D: Immobilien-Portfolio.
///
/// Sprint D: Hypothek-Hebel + Kaufnebenkosten + Instandhaltung +
/// Mieteinnahmen (nur MFH) + Spekulationssteuer (< 10 J, vermietet).
///
/// Klumpenrisiko: TODO — negative Gewichtung in der
/// E2-Diversifikations-Logik kommt in einem spaeteren Sprint.
final class RealEstateRepositoryProvider
    extends $NotifierProvider<RealEstateRepository, List<RealEstateHolding>> {
  /// spec-35 phase B + spec-44 sprint D: Immobilien-Portfolio.
  ///
  /// Sprint D: Hypothek-Hebel + Kaufnebenkosten + Instandhaltung +
  /// Mieteinnahmen (nur MFH) + Spekulationssteuer (< 10 J, vermietet).
  ///
  /// Klumpenrisiko: TODO — negative Gewichtung in der
  /// E2-Diversifikations-Logik kommt in einem spaeteren Sprint.
  RealEstateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realEstateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realEstateRepositoryHash();

  @$internal
  @override
  RealEstateRepository create() => RealEstateRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RealEstateHolding> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RealEstateHolding>>(value),
    );
  }
}

String _$realEstateRepositoryHash() =>
    r'06e1a9ee2b5704c84406f3c88dad4149b02cf5cf';

/// spec-35 phase B + spec-44 sprint D: Immobilien-Portfolio.
///
/// Sprint D: Hypothek-Hebel + Kaufnebenkosten + Instandhaltung +
/// Mieteinnahmen (nur MFH) + Spekulationssteuer (< 10 J, vermietet).
///
/// Klumpenrisiko: TODO — negative Gewichtung in der
/// E2-Diversifikations-Logik kommt in einem spaeteren Sprint.

abstract class _$RealEstateRepository
    extends $Notifier<List<RealEstateHolding>> {
  List<RealEstateHolding> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<RealEstateHolding>, List<RealEstateHolding>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<RealEstateHolding>, List<RealEstateHolding>>,
              List<RealEstateHolding>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
