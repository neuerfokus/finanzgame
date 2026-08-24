// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diversification.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-44 E2 (Diversifikations-Bonus): zählt, wie viele Asset-Klassen
/// der Spieler aktuell hält. Liefert einen Volatilitäts-Dämpfungs-
/// Faktor nach der Spec-Tabelle A.4:
///
///   classes  factor
///   1        1,00
///   2        0,85
///   3        0,70
///   4        0,55
///   5+       0,50
///
/// "free lunch" der Streuung — kein Renditebonus, nur weniger
/// Schwankung. Wird in den Preis-Listenern auf `volatility` angewandt.

@ProviderFor(diversificationClassCount)
final diversificationClassCountProvider = DiversificationClassCountProvider._();

/// Spec-44 E2 (Diversifikations-Bonus): zählt, wie viele Asset-Klassen
/// der Spieler aktuell hält. Liefert einen Volatilitäts-Dämpfungs-
/// Faktor nach der Spec-Tabelle A.4:
///
///   classes  factor
///   1        1,00
///   2        0,85
///   3        0,70
///   4        0,55
///   5+       0,50
///
/// "free lunch" der Streuung — kein Renditebonus, nur weniger
/// Schwankung. Wird in den Preis-Listenern auf `volatility` angewandt.

final class DiversificationClassCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Spec-44 E2 (Diversifikations-Bonus): zählt, wie viele Asset-Klassen
  /// der Spieler aktuell hält. Liefert einen Volatilitäts-Dämpfungs-
  /// Faktor nach der Spec-Tabelle A.4:
  ///
  ///   classes  factor
  ///   1        1,00
  ///   2        0,85
  ///   3        0,70
  ///   4        0,55
  ///   5+       0,50
  ///
  /// "free lunch" der Streuung — kein Renditebonus, nur weniger
  /// Schwankung. Wird in den Preis-Listenern auf `volatility` angewandt.
  DiversificationClassCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diversificationClassCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diversificationClassCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return diversificationClassCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$diversificationClassCountHash() =>
    r'6da2793479517a94f725977b23e7f2ad69340a7d';
