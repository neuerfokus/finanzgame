import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Spec-19 aggregate asset identifiers used by [HistoryRepository] for the
/// multi-line Zeitreise chart. Keep separate from per-ticker IDs so the
/// chart can stay readable.
abstract final class HistoryAssetIds {
  static const cash = 'cash';
  static const sparYield = 'spar_yield';
  static const etfIndex = 'etf_index';
  static const stockIndex = 'stock_index';
  static const wishlistCpi = 'wishlist_cpi';

  /// 2026-08 (User-Fund „bei der Zeitreise sind nicht alle Assets erfasst"):
  /// die Zeitreise kannte nur Bargeld, Sparen, ETF und Aktien — obwohl das
  /// Spiel sechs weitere Anlagen kennt, die alle ins Netto-Vermögen zählen.
  /// Wer sein Geld in Gold, Krypto oder eine Wohnung gesteckt hatte, sah im
  /// Rückblick eine Kurve, die einen Teil seines Vermögens schlicht nicht
  /// enthielt.
  static const cryptoIndex = 'crypto_index';
  static const metalIndex = 'metal_index';
  static const realEstateIndex = 'real_estate_index';
  static const vorsorgeIndex = 'vorsorge_index';
  static const collectibleIndex = 'collectible_index';
  static const treeIndex = 'tree_index';

  /// Internal marker recorded on crash days. Not selectable from the UI —
  /// the chart paints a vertical red dashed line at every dayIndex that
  /// has this row.
  static const crashMarker = 'crash_marker';

  /// User-selectable IDs, ordered for the default chip-row layout.
  /// Reihenfolge: erst die liquiden, dann die Sachwerte, Inflation zuletzt.
  static const all = <String>[
    cash,
    sparYield,
    etfIndex,
    stockIndex,
    cryptoIndex,
    metalIndex,
    realEstateIndex,
    vorsorgeIndex,
    collectibleIndex,
    treeIndex,
    wishlistCpi,
  ];
}

/// German labels for the aggregate asset IDs. Strings live here instead of
/// ARB because the Zeitreise is the only consumer + we want a one-line
/// lookup helper.
String labelForAsset(String assetId) {
  return switch (assetId) {
    HistoryAssetIds.cash => 'Bargeld',
    HistoryAssetIds.sparYield => 'Spareinlagen',
    HistoryAssetIds.etfIndex => 'ETFs',
    HistoryAssetIds.stockIndex => 'Aktien',
    HistoryAssetIds.cryptoIndex => 'Krypto',
    HistoryAssetIds.metalIndex => 'Edelmetalle',
    HistoryAssetIds.realEstateIndex => 'Immobilien',
    HistoryAssetIds.vorsorgeIndex => 'Vorsorge',
    HistoryAssetIds.collectibleIndex => 'Sammlerobjekte',
    HistoryAssetIds.treeIndex => 'Bäume',
    HistoryAssetIds.wishlistCpi => 'Inflations-Index',
    _ => assetId,
  };
}

/// Fixed colour per aggregate asset ID. Distinct enough to read off the
/// pixel-palette background. Falls back to [FgColors.primary] for unknown
/// IDs (per-ticker series, etc.).
Color colorForAsset(String assetId) {
  return switch (assetId) {
    HistoryAssetIds.cash => FgColors.primary,
    HistoryAssetIds.sparYield => FgColors.success,
    HistoryAssetIds.etfIndex => FgColors.info,
    HistoryAssetIds.stockIndex => FgColors.secondary,
    // Eigene Farben statt Token-Recycling: bei elf möglichen Linien muss man
    // sie in der Legende auseinanderhalten können. Angelehnt an die
    // Ring-Farben der Stats-Seite, damit dieselbe Anlage überall gleich
    // aussieht.
    HistoryAssetIds.cryptoIndex => const Color(0xFFE91E63), // magenta
    HistoryAssetIds.metalIndex => const Color(0xFFE5B847), // gold
    HistoryAssetIds.realEstateIndex => const Color(0xFFA0522D), // sienna
    HistoryAssetIds.vorsorgeIndex => const Color(0xFF26C6DA), // teal
    HistoryAssetIds.collectibleIndex => const Color(0xFF9C27B0), // violett
    HistoryAssetIds.treeIndex => const Color(0xFF2E7D32), // waldgrün
    HistoryAssetIds.wishlistCpi => FgColors.alert,
    _ => FgColors.primary,
  };
}
