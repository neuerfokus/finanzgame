// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Per-asset daily history. Indexed by assetId.
///
/// Two kinds of series live side-by-side in the same table:
/// 1. Per-ticker quote series (`welt_korb`, `aktie_fluxon`, …) — seeded
///    from the catalog at day 0 and appended every [recordToday].
/// 2. Spec-19 aggregate series ([HistoryAssetIds.cash],
///    [HistoryAssetIds.sparYield], [HistoryAssetIds.etfIndex],
///    [HistoryAssetIds.stockIndex], [HistoryAssetIds.wishlistCpi]). Used
///    by the Zeitreise multi-line chart.
///
/// Persisted to [PriceHistoryTable] composite (assetId, dayIndex). The
/// aggregate-asset values share the same `priceCents` column —
/// `wishlist_cpi` is an integer index (× 100), the rest are real cents.

@ProviderFor(HistoryRepository)
final historyRepositoryProvider = HistoryRepositoryProvider._();

/// Per-asset daily history. Indexed by assetId.
///
/// Two kinds of series live side-by-side in the same table:
/// 1. Per-ticker quote series (`welt_korb`, `aktie_fluxon`, …) — seeded
///    from the catalog at day 0 and appended every [recordToday].
/// 2. Spec-19 aggregate series ([HistoryAssetIds.cash],
///    [HistoryAssetIds.sparYield], [HistoryAssetIds.etfIndex],
///    [HistoryAssetIds.stockIndex], [HistoryAssetIds.wishlistCpi]). Used
///    by the Zeitreise multi-line chart.
///
/// Persisted to [PriceHistoryTable] composite (assetId, dayIndex). The
/// aggregate-asset values share the same `priceCents` column —
/// `wishlist_cpi` is an integer index (× 100), the rest are real cents.
final class HistoryRepositoryProvider
    extends
        $NotifierProvider<HistoryRepository, Map<String, List<HistoryPoint>>> {
  /// Per-asset daily history. Indexed by assetId.
  ///
  /// Two kinds of series live side-by-side in the same table:
  /// 1. Per-ticker quote series (`welt_korb`, `aktie_fluxon`, …) — seeded
  ///    from the catalog at day 0 and appended every [recordToday].
  /// 2. Spec-19 aggregate series ([HistoryAssetIds.cash],
  ///    [HistoryAssetIds.sparYield], [HistoryAssetIds.etfIndex],
  ///    [HistoryAssetIds.stockIndex], [HistoryAssetIds.wishlistCpi]). Used
  ///    by the Zeitreise multi-line chart.
  ///
  /// Persisted to [PriceHistoryTable] composite (assetId, dayIndex). The
  /// aggregate-asset values share the same `priceCents` column —
  /// `wishlist_cpi` is an integer index (× 100), the rest are real cents.
  HistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyRepositoryHash();

  @$internal
  @override
  HistoryRepository create() => HistoryRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<HistoryPoint>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<HistoryPoint>>>(
        value,
      ),
    );
  }
}

String _$historyRepositoryHash() => r'01252f32c65938e808ae0bce79f243e5e3253932';

/// Per-asset daily history. Indexed by assetId.
///
/// Two kinds of series live side-by-side in the same table:
/// 1. Per-ticker quote series (`welt_korb`, `aktie_fluxon`, …) — seeded
///    from the catalog at day 0 and appended every [recordToday].
/// 2. Spec-19 aggregate series ([HistoryAssetIds.cash],
///    [HistoryAssetIds.sparYield], [HistoryAssetIds.etfIndex],
///    [HistoryAssetIds.stockIndex], [HistoryAssetIds.wishlistCpi]). Used
///    by the Zeitreise multi-line chart.
///
/// Persisted to [PriceHistoryTable] composite (assetId, dayIndex). The
/// aggregate-asset values share the same `priceCents` column —
/// `wishlist_cpi` is an integer index (× 100), the rest are real cents.

abstract class _$HistoryRepository
    extends $Notifier<Map<String, List<HistoryPoint>>> {
  Map<String, List<HistoryPoint>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, List<HistoryPoint>>,
              Map<String, List<HistoryPoint>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, List<HistoryPoint>>,
                Map<String, List<HistoryPoint>>
              >,
              Map<String, List<HistoryPoint>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
