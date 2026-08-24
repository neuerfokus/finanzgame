// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_counter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Wie viele Pflanzen der Spieler am aktuellen Spieltag geerntet hat.
///
/// Analyse-Runde 2026-08: Das Tagesziel „3× ernten" prüfte
/// `lifetimeHarvestState >= 100` — also „hast du IRGENDWANN mal mindestens
/// 1 € aus Ernten bekommen". Nach der allerersten Ernte war das Ziel damit an
/// jedem weiteren Tag automatisch erfüllt: 5 € + 50 XP fürs Nichtstun.
///
/// Bewusst NUR im Speicher (keine Drift-Spalte): der Zähler lebt genau einen
/// Spieltag. Ein App-Neustart setzt ihn auf 0 zurück, das Ziel muss dann neu
/// erfüllt werden — die Auszahlung ist über `lastClaimedGoalDay` persistiert,
/// doppelt kassieren geht also nicht.

@ProviderFor(HarvestCounter)
final harvestCounterProvider = HarvestCounterProvider._();

/// Wie viele Pflanzen der Spieler am aktuellen Spieltag geerntet hat.
///
/// Analyse-Runde 2026-08: Das Tagesziel „3× ernten" prüfte
/// `lifetimeHarvestState >= 100` — also „hast du IRGENDWANN mal mindestens
/// 1 € aus Ernten bekommen". Nach der allerersten Ernte war das Ziel damit an
/// jedem weiteren Tag automatisch erfüllt: 5 € + 50 XP fürs Nichtstun.
///
/// Bewusst NUR im Speicher (keine Drift-Spalte): der Zähler lebt genau einen
/// Spieltag. Ein App-Neustart setzt ihn auf 0 zurück, das Ziel muss dann neu
/// erfüllt werden — die Auszahlung ist über `lastClaimedGoalDay` persistiert,
/// doppelt kassieren geht also nicht.
final class HarvestCounterProvider
    extends $NotifierProvider<HarvestCounter, ({int count, int dayIndex})> {
  /// Wie viele Pflanzen der Spieler am aktuellen Spieltag geerntet hat.
  ///
  /// Analyse-Runde 2026-08: Das Tagesziel „3× ernten" prüfte
  /// `lifetimeHarvestState >= 100` — also „hast du IRGENDWANN mal mindestens
  /// 1 € aus Ernten bekommen". Nach der allerersten Ernte war das Ziel damit an
  /// jedem weiteren Tag automatisch erfüllt: 5 € + 50 XP fürs Nichtstun.
  ///
  /// Bewusst NUR im Speicher (keine Drift-Spalte): der Zähler lebt genau einen
  /// Spieltag. Ein App-Neustart setzt ihn auf 0 zurück, das Ziel muss dann neu
  /// erfüllt werden — die Auszahlung ist über `lastClaimedGoalDay` persistiert,
  /// doppelt kassieren geht also nicht.
  HarvestCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'harvestCounterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$harvestCounterHash();

  @$internal
  @override
  HarvestCounter create() => HarvestCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int count, int dayIndex}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int count, int dayIndex})>(value),
    );
  }
}

String _$harvestCounterHash() => r'1b55517865713bf036f10e0b1b5e806856f19ec5';

/// Wie viele Pflanzen der Spieler am aktuellen Spieltag geerntet hat.
///
/// Analyse-Runde 2026-08: Das Tagesziel „3× ernten" prüfte
/// `lifetimeHarvestState >= 100` — also „hast du IRGENDWANN mal mindestens
/// 1 € aus Ernten bekommen". Nach der allerersten Ernte war das Ziel damit an
/// jedem weiteren Tag automatisch erfüllt: 5 € + 50 XP fürs Nichtstun.
///
/// Bewusst NUR im Speicher (keine Drift-Spalte): der Zähler lebt genau einen
/// Spieltag. Ein App-Neustart setzt ihn auf 0 zurück, das Ziel muss dann neu
/// erfüllt werden — die Auszahlung ist über `lastClaimedGoalDay` persistiert,
/// doppelt kassieren geht also nicht.

abstract class _$HarvestCounter extends $Notifier<({int count, int dayIndex})> {
  ({int count, int dayIndex}) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<({int count, int dayIndex}), ({int count, int dayIndex})>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({int count, int dayIndex}),
                ({int count, int dayIndex})
              >,
              ({int count, int dayIndex}),
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
