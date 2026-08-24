import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/game_clock.dart';
import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/etf/etf.dart';
import '../../domain/forest/tree.dart';
import '../../domain/stock/stock.dart';
import '../../domain/wishlist/wish_item.dart';
import '../bank/savings_repository.dart';
import '../collectibles/collectible_repository.dart';
import '../crypto/crypto_repository.dart';
import '../economy/cash_state.dart';
import '../etf/etf_repository.dart';
import '../forest/tree_repository.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../stock/stock_repository.dart';
import '../vorsorge/vorsorge_repository.dart';
import '../wishlist/wishlist_repository.dart';
import 'asset_labels.dart';

part 'history_repository.g.dart';

/// One data-point on an asset's history line. Day-index is canonical so
/// the chart can space points correctly even when an asset only starts
/// being recorded mid-game (e.g. wishlist_cpi catches up to the live
/// game clock).
class HistoryPoint {
  const HistoryPoint({required this.dayIndex, required this.valueCents});

  final int dayIndex;
  final int valueCents;
}

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
@Riverpod(keepAlive: true)
class HistoryRepository extends _$HistoryRepository {
  /// Day-0 baseline for the wishlist CPI. Captured on first record so
  /// the index reads exactly 100 on day 0 and drifts from there.
  int? _wishlistBaselineCents;

  @override
  Map<String, List<HistoryPoint>> build() {
    final snap = ref.watch(dbSnapshotProvider);

    // Seed per-ticker series with catalog initial prices on day 0.
    final seeded = <String, Map<int, int>>{};
    for (final s in EtfCatalog.all) {
      seeded[s.id] = {0: s.initialPrice.cents};
    }
    for (final s in StockCatalog.all) {
      seeded[s.id] = {0: s.initialPrice.cents};
    }

    // Layer DB rows on top.
    for (final row in snap.priceHistory) {
      (seeded[row.assetId] ??= <int, int>{})[row.dayIndex] = row.priceCents;
    }

    final out = <String, List<HistoryPoint>>{};
    seeded.forEach((id, byDay) {
      final keys = byDay.keys.toList()..sort();
      out[id] = [
        for (final k in keys)
          HistoryPoint(dayIndex: k, valueCents: byDay[k]!),
      ];
    });
    return out;
  }

  /// Pulls current quotes + aggregate values and appends them to the
  /// history. Called from `GameClock.advanceDay()` after the pipeline
  /// completes. [crashedToday] toggles a row under
  /// [HistoryAssetIds.crashMarker] so the chart can render a vertical
  /// red line at that x-position.
  void recordToday({bool crashedToday = false}) {
    final etfPortfolio = ref.read(etfRepositoryProvider);
    final stockPortfolio = ref.read(stockRepositoryProvider);
    final today = ref.read(gameClockProvider).dayIndex;

    final next = <String, List<HistoryPoint>>{};
    state.forEach((id, points) => next[id] = [...points]);
    final newRows = <PriceHistoryRow>[];

    void recordRow(String assetId, int valueCents) {
      (next[assetId] ??= []).add(
        HistoryPoint(dayIndex: today, valueCents: valueCents),
      );
      newRows.add(PriceHistoryRow(
        assetId: assetId,
        dayIndex: today,
        priceCents: valueCents,
      ));
    }

    // 1. Per-ticker price snapshots (unchanged from spec-09).
    for (final entry in etfPortfolio.quotes.entries) {
      recordRow(entry.key, entry.value.pricePerShare.cents);
    }
    for (final entry in stockPortfolio.quotes.entries) {
      recordRow(entry.key, entry.value.pricePerShare.cents);
    }

    // 2. Aggregate series (spec-19). Cash + spar (lifetime harvest +
    //    savings balance) + ETF/stock market value + wishlist CPI.
    final cashCents = ref.read(cashStateProvider).cents;
    recordRow(HistoryAssetIds.cash, cashCents);

    // Spec-43 v8: nur Spareinlagen, KEINE Ernte (User-Feedback).
    // Ernte ist eine Aktion, kein passives Anlage-Asset.
    final savingsCents = ref.read(savingsRepositoryProvider).cents;
    recordRow(HistoryAssetIds.sparYield, savingsCents);

    var etfMarketValue = 0;
    for (final h in etfPortfolio.holdings) {
      final quote = etfPortfolio.quotes[h.etfId];
      if (quote != null) {
        etfMarketValue += quote.pricePerShare.cents * h.shares;
      }
    }
    recordRow(HistoryAssetIds.etfIndex, etfMarketValue);

    var stockMarketValue = 0;
    for (final h in stockPortfolio.holdings) {
      final quote = stockPortfolio.quotes[h.stockId];
      if (quote != null) {
        stockMarketValue += quote.pricePerShare.cents * h.shares;
      }
    }
    recordRow(HistoryAssetIds.stockIndex, stockMarketValue);

    // 2026-08: die übrigen sechs Anlageklassen. Sie zählen längst ins
    // Netto-Vermögen (`NetWorth.compute`), fehlten in der Zeitreise aber
    // komplett — wer sein Geld in Gold, Krypto oder eine Wohnung gesteckt
    // hatte, sah im Rückblick eine Kurve ohne diesen Teil seines Vermögens.
    // Bewertet wird jeweils GENAU wie im Netto-Vermögen, damit Zeitreise und
    // Portfolio nie zwei verschiedene Zahlen zeigen.
    final crypto = ref.read(cryptoRepositoryProvider);
    recordRow(
      HistoryAssetIds.cryptoIndex,
      crypto.holdings.fold<int>(
        0,
        (sum, h) =>
            sum + (crypto.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
      ),
    );

    final metal = ref.read(metalRepositoryProvider);
    recordRow(
      HistoryAssetIds.metalIndex,
      metal.holdings.fold<int>(
        0,
        (sum, h) =>
            sum + (metal.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
      ),
    );

    // Immobilien: Marktwert MINUS Restschuld — geliehenes Geld ist kein
    // Vermögen (siehe NetWorth.compute).
    final reRepo = ref.read(realEstateRepositoryProvider.notifier);
    recordRow(
      HistoryAssetIds.realEstateIndex,
      ref.read(realEstateRepositoryProvider).fold<int>(
            0,
            (sum, h) =>
                sum +
                reRepo.currentValueOf(h, today).cents -
                reRepo.mortgageRemaining(h, today).cents,
          ),
    );

    recordRow(
      HistoryAssetIds.vorsorgeIndex,
      ref.read(vorsorgeRepositoryProvider).fold<int>(
            0,
            (sum, c) => sum + c.totalContributed.cents + c.totalSubsidy.cents,
          ),
    );

    final collectibleRepo = ref.read(collectibleRepositoryProvider.notifier);
    recordRow(
      HistoryAssetIds.collectibleIndex,
      ref.read(collectibleRepositoryProvider).fold<int>(
            0,
            (sum, h) => sum + collectibleRepo.currentValueOf(h, today).cents,
          ),
    );

    // Bäume zum Anschaffungswert — dieselbe Konvention wie im Vermögen.
    recordRow(
      HistoryAssetIds.treeIndex,
      ref.read(treeRepositoryProvider).fold<int>(
            0,
            (sum, t) => sum + TreeCatalog.spec(t.kind).cost.cents,
          ),
    );

    final wishItems = ref.read(wishlistRepositoryProvider);
    recordRow(HistoryAssetIds.wishlistCpi, _wishlistCpi(wishItems));

    if (crashedToday) {
      recordRow(HistoryAssetIds.crashMarker, 1);
    }

    _pruneLongSeries(next);
    state = next;
    _persist(newRows);
  }

  /// Obergrenze an Punkten pro Reihe. Darüber wird die ältere Hälfte auf
  /// jeden zweiten Punkt ausgedünnt.
  static const int _maxPointsPerSeries = 1200;

  /// Dünnt zu lange Reihen aus (in-memory UND in der DB).
  ///
  /// Ohne das wuchs `priceHistory` unbegrenzt: ~15 Zeilen pro Spieltag, im
  /// Zeitsprung alle 30 Tage — und `loadAll()` zieht beim Kaltstart JEDE
  /// Zeile, noch vor `runApp`. Der Start wurde also mit jedem Spielmonat
  /// langsamer. Das Zeitreise-Chart normalisiert pro Linie und zeichnet
  /// hunderte Punkte auf ein paar hundert Pixel → das Ausdünnen der alten
  /// Hälfte ist visuell nicht sichtbar. Der erste Punkt (Tag 0, Baseline)
  /// bleibt immer erhalten.
  void _pruneLongSeries(Map<String, List<HistoryPoint>> series) {
    final db = ref.read(appDatabaseProvider);
    series.forEach((assetId, points) {
      if (points.length <= _maxPointsPerSeries) return;
      final half = points.length ~/ 2;
      final thinned = <HistoryPoint>[
        for (var i = 0; i < half; i++)
          if (i == 0 || i.isEven) points[i],
        ...points.sublist(half),
      ];
      series[assetId] = thinned;
      unawaited(db.priceHistoryDao
          .replaceAssetSeries(
            assetId,
            [
              for (final p in thinned)
                PriceHistoryRow(
                  assetId: assetId,
                  dayIndex: p.dayIndex,
                  priceCents: p.valueCents,
                ),
            ],
          )
          .catchError((Object _) {}));
    });
  }

  /// Returns (dayIndex, valueCents) tuples for [assetId] in day order.
  List<(int, int)> seriesPoints(String assetId) => [
        for (final p in state[assetId] ?? const <HistoryPoint>[])
          (p.dayIndex, p.valueCents),
      ];

  /// Day-indices flagged as crash days. Used by the Zeitreise chart to
  /// paint a vertical red line at each x-position.
  List<int> crashDays() => [
        for (final p in state[HistoryAssetIds.crashMarker] ??
            const <HistoryPoint>[])
          p.dayIndex,
      ];

  /// All asset IDs that currently have at least one data-point, sorted
  /// alphabetically. Excludes the internal [HistoryAssetIds.crashMarker]
  /// — it's a chart-internal marker, not a selectable line.
  List<String> get assetIdsAvailable {
    final keys = state.keys.where((k) => k != HistoryAssetIds.crashMarker)
        .toList()
      ..sort();
    return keys;
  }

  /// Spec-19 wishlist CPI: round(sum(current) / sum(base) × 100).
  /// Captured baseline survives the session — first call seeds it from
  /// the catalog basePrices so the index always reads 100 on day 0.
  int _wishlistCpi(List<WishItem> items) {
    var baseline = 0;
    var current = 0;
    for (final i in items) {
      baseline += i.basePrice.cents;
      current += i.currentPrice.cents;
    }
    _wishlistBaselineCents ??= baseline;
    final base = _wishlistBaselineCents!;
    if (base == 0) return 100;
    return ((current / base) * 100).round();
  }

  /// Legacy alias from spec-09 returning just the values (cents wrapped
  /// in Money). Kept for callers that don't need day-indices.
  List<Money> seriesFor(String assetId) => [
        for (final p in state[assetId] ?? const <HistoryPoint>[])
          Money.cents(p.valueCents),
      ];

  void _persist(List<PriceHistoryRow> rows) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.priceHistoryDao.appendAll(rows).catchError((Object _) {}));
  }
}
