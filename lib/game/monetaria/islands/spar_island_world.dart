import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../domain/plant/plant.dart';
import 'plant_plot.dart';

/// Flame world for the Spar-Insel. Hosts 4 plant plots in a 2×2 grid.
///
/// Plant lifecycle (plant / grow / harvest) is owned by `PlantRepository` on
/// the Flutter side. This world only renders state and forwards taps via
/// [onEmptyPlotTap] / [onReadyPlotTap].
class SparIslandWorld extends FlameGame {
  SparIslandWorld({
    required this.onEmptyPlotTap,
    required this.onReadyPlotTap,
    this.plotCount = 4,
  });

  static const String islandId = 'spar_insel';
  // Spec-43 v4: world fix 320×480. Cell-Größe passt sich so an dass
  // der Bereich bei voller plotCount=10 sauber gefüllt ist und bei
  // wenigen Plots große Felder vorhanden sind (cap 96).
  // Bug-fix v26: 4×6=24 Slots für daumenfreundliche Cells (~100×107).
  // 5×7=35 war zu klein zum Anklicken auf Mi A3.
  static final Vector2 worldSize = Vector2(460, 720);
  final int plotCount;

  final void Function(int plotIndex) onEmptyPlotTap;
  final void Function(int plotIndex) onReadyPlotTap;

  final List<PlantPlot> plots = [];

  /// Latest plant list received via [syncPlants]. When [syncPlants] is called
  /// before [onLoad] completes (common on first build with persisted plants
  /// from spec-34 migration), plots are empty — we stash the data here and
  /// apply it at the end of [onLoad]. Spec-38 P0-1.
  List<Plant>? _pendingPlants;

  @override
  Color backgroundColor() => const Color(0xFF7BC383); // grass green

  @override
  Future<void> onLoad() async {
    camera.viewfinder.visibleGameSize = worldSize;
    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(
      RectangleComponent(
        size: worldSize,
        paint: Paint()..color = const Color(0xFF7BC383),
      ),
    );

    // Adaptive grid: cells skalieren mit Plot-Count, so dass wenige
    // Plots große Felder bekommen (2-3× current). Cap 12.
    //  1-4 → 2×2 (cell ~222×344, ~3× area)
    //  5-6 → 2×3 (cell ~222×229)
    //  7-9 → 3×3 (cell ~142×229)
    // 10-12 → 3×4 (cell ~142×165, v29-style)
    final (cols, totalRows) = _gridFor(plotCount);
    const gap = 16.0;
    const sideMargin = 8.0;
    final cellW =
        (worldSize.x - 2 * sideMargin - (cols - 1) * gap) / cols;
    final cellH =
        (worldSize.y - 2 * sideMargin - (totalRows - 1) * gap) / totalRows;
    final startX = sideMargin + cellW / 2;
    final startY = sideMargin + cellH / 2;

    for (var i = 0; i < plotCount; i++) {
      final row = i ~/ cols;
      final col = i % cols;
      final pos = Vector2(
        startX + col * (cellW + gap),
        startY + row * (cellH + gap),
      );
      final plot = PlantPlot(
        plotIndex: i,
        worldPosition: pos,
        onEmptyTap: onEmptyPlotTap,
        onReadyTap: onReadyPlotTap,
        tileSize: Vector2(cellW, cellH),
      );
      plots.add(plot);
      world.add(plot);
    }

    // Spec-43 v3: "Spar-Insel"-Title-Text auf dem Gras entfernt (User-Feedback).

    // Apply plants that arrived while plots weren't ready (spec-38 P0-1).
    final pending = _pendingPlants;
    if (pending != null) {
      _pendingPlants = null;
      _applyPlants(pending);
    }
  }

  /// Sync world plots with the canonical plant list from the repo.
  void syncPlants(List<Plant> plants) {
    if (plots.isEmpty) {
      _pendingPlants = plants;
      return;
    }
    _applyPlants(plants);
  }

  void _applyPlants(List<Plant> plants) {
    for (final plot in plots) {
      // Spec-38 hotfix: withered plants should also clear the plot so the
      // player can re-plant. Otherwise a single Sturm leaves the plot
      // permanently blocked.
      final match = plants.firstWhere(
        (p) =>
            p.islandId == islandId &&
            p.plotIndex == plot.plotIndex &&
            p.status != PlantStatus.harvested &&
            p.status != PlantStatus.withered,
        orElse: () => _noPlant,
      );
      plot.setPlant(identical(match, _noPlant) ? null : match);
    }
  }

  static (int cols, int rows) _gridFor(int n) {
    if (n <= 4) return (2, 2);
    if (n <= 6) return (2, 3);
    if (n <= 9) return (3, 3);
    return (3, 4);
  }

  static const Plant _noPlant = Plant(
    id: '',
    islandId: '',
    plotIndex: -1,
    kind: PlantKind.elephantsfoot,
    plantedOnDayIndex: 0,
  );
}
