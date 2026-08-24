import 'package:flutter/material.dart';

/// Spec-43 Stage 1: Decor-Item-Katalog.
///
/// Pro Insel platzierbare Deko. Stage 1 enthält 4 Items für die Sparinsel.
/// Erweiterung in Stage 2 (alle 9 Inseln, 12 Items) folgt.
class DecorSpec {
  const DecorSpec({
    required this.id,
    required this.label,
    required this.glyph,
    required this.xpCost,
    required this.color,
  });

  final String id;
  final String label;
  final String glyph;
  final int xpCost;
  final Color color;

  /// Spec-43 v2: Decor wandert in Furniture-Shop, Cash-Preis = xpCost × 10 ¢.
  int get priceCents => xpCost * 10;
}

/// Stage 2: 12 Items.
const List<DecorSpec> kDecorCatalog = <DecorSpec>[
  DecorSpec(
    id: 'palme',
    label: 'Palme',
    glyph: '🌴',
    xpCost: 50,
    color: Color(0xFF2E7D32),
  ),
  DecorSpec(
    id: 'blumentopf',
    label: 'Blumentopf',
    glyph: '🪴',
    xpCost: 60,
    color: Color(0xFF66BB6A),
  ),
  DecorSpec(
    id: 'bank',
    label: 'Bank',
    glyph: '🪑',
    xpCost: 80,
    color: Color(0xFF8D6E63),
  ),
  DecorSpec(
    id: 'zaun',
    label: 'Zaun',
    glyph: '🚧',
    xpCost: 90,
    color: Color(0xFFFB8C00),
  ),
  DecorSpec(
    id: 'fass',
    label: 'Fass',
    glyph: '🛢️',
    xpCost: 100,
    color: Color(0xFF6D4C41),
  ),
  DecorSpec(
    id: 'steinhaufen',
    label: 'Steinhaufen',
    glyph: '🪨',
    xpCost: 110,
    color: Color(0xFF757575),
  ),
  DecorSpec(
    id: 'lampe',
    label: 'Laterne',
    glyph: '🏮',
    xpCost: 120,
    color: Color(0xFFFFB300),
  ),
  DecorSpec(
    id: 'fackel',
    label: 'Fackel',
    glyph: '🔥',
    xpCost: 140,
    color: Color(0xFFE53935),
  ),
  DecorSpec(
    id: 'wegweiser',
    label: 'Wegweiser',
    glyph: '🪧',
    xpCost: 150,
    color: Color(0xFF6D4C41),
  ),
  DecorSpec(
    id: 'truhe',
    label: 'Truhe',
    glyph: '🧰',
    xpCost: 180,
    color: Color(0xFF795548),
  ),
  DecorSpec(
    id: 'brunnen',
    label: 'Brunnen',
    glyph: '⛲',
    xpCost: 200,
    color: Color(0xFF1E88E5),
  ),
  DecorSpec(
    id: 'statue',
    label: 'Statue',
    glyph: '🗿',
    xpCost: 500,
    color: Color(0xFF455A64),
  ),
];

DecorSpec? decorSpecById(String id) {
  for (final spec in kDecorCatalog) {
    if (spec.id == id) return spec;
  }
  return null;
}

/// Welle-8: Cap auf 30 erhöht (war 8). Zimmer hat genug Platz,
/// 8 war zu eng — Sohn wollte mehr sammeln.
const int kMaxDecorPerIsland = 30;
