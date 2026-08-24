import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/design_tokens.dart';
import 'components/boat.dart';
import 'components/island_marker.dart';
import 'components/smoke_emitter.dart';
import 'state/monetaria_state.dart';

/// Flame world for the Monetaria hub: ocean background + 3 islands + boat.
///
/// Tiled-map integration deferred: islands spawn from [kIslandSpecs] until a
/// `monetaria.tmx` + tileset land (see spec-04 §Tiled-Map).
class MonetariaWorld extends FlameGame with HasGameReference {
  MonetariaWorld({
    required this.unlockedIslandIds,
    required this.onIslandSelected,
    this.onIslandLockedTap,
    this.onIslandLongPressed,
    this.decorByIsland = const <String, List<String>>{},
  });

  // spec-41: world auf 720×1400 erweitert für die 160-px-Marker.
  // island markers + labels still fit without crowding each other.
  // Spec-43 v4: World noch breiter (800→880) — User will rechte +
  // mittlere Inseln weiter rechts. Marker bleibt 200 px.
  static final Vector2 worldSize = Vector2(880, 1400);

  final Set<String> unlockedIslandIds;
  final void Function(String islandId) onIslandSelected;

  /// Welle-8 Round 17: Tap auf gesperrte Insel → Unlock-Hinweis-Snack.
  final void Function(String islandId)? onIslandLockedTap;

  /// Spec-43 Stage 3: Long-Press auf Marker öffnet Decor-Editor.
  final void Function(String islandId)? onIslandLongPressed;

  /// Spec-43 Stage 3: pro Insel die Decor-Glyphs (max 3 rendered).
  final Map<String, List<String>> decorByIsland;

  final List<IslandMarker> islands = [];
  late final Boat boat;

  @override
  Color backgroundColor() => FgColors.info;

  /// Pirate-pack tile chosen as the water background (spec-23).
  /// Swap to a different `tile_NN.png` later if a more obviously-water
  /// tile shows up in the pack.
  static const String _waterTileAsset = 'iso/water.png';

  @override
  Future<void> onLoad() async {
    camera.viewfinder.visibleGameSize = worldSize;
    camera.viewfinder.anchor = Anchor.topLeft;

    // Ocean background — plain fill first so we always have a deterministic
    // visual in tests. Upgrades to a stretched water sprite when the
    // asset bundle is available.
    world.add(
      RectangleComponent(
        size: worldSize,
        paint: Paint()..color = FgColors.info,
      ),
    );
    if (_canLoadAssets) {
      try {
        final waterSprite = await Sprite.load(_waterTileAsset);
        world.add(
          SpriteComponent(
            sprite: waterSprite,
            size: worldSize,
            anchor: Anchor.topLeft,
            priority: -1,
          ),
        );
      } on Object {
        // Asset missing or decode failed — solid fill stays.
      }
    }

    // Spawn island markers from static layout.
    Vector2 homePort = Vector2.zero();
    for (final spec in kIslandSpecs) {
      final marker = IslandMarker(
        id: spec.id,
        label: spec.label,
        unlocked: unlockedIslandIds.contains(spec.id),
        worldPosition: Vector2(spec.x, spec.y),
        onSelected: _onIslandSelected,
        onLockedTap: onIslandLockedTap == null
            ? null
            : (m) => onIslandLockedTap!(m.id),
        onLongPressed: onIslandLongPressed == null
            ? null
            : (m) => onIslandLongPressed!(m.id),
        decorGlyphs: decorByIsland[spec.id] ?? const <String>[],
      );
      islands.add(marker);
      world.add(marker);
      if (spec.id == IslandId.heimathafen) {
        homePort = Vector2(spec.x, spec.y);
      }
      // Spec-40 B: Rauchsäule am Vulkan-Marker.
      if (spec.id == IslandId.vulkan) {
        world.add(
          SmokeEmitter(position: Vector2(spec.x, spec.y - 40)),
        );
      }
    }

    boat = Boat(homePort: homePort);
    world.add(boat);
  }

  Future<void> _onIslandSelected(IslandMarker island) async {
    await boat.travelTo(island.position);
    onIslandSelected(island.id);
  }

  /// Mirror of [Boat._canLoadAssets] — tests without an initialized binding
  /// can't reach `rootBundle` so we skip the sprite load entirely.
  bool get _canLoadAssets {
    try {
      ServicesBinding.instance;
      return true;
    } on Object {
      return false;
    }
  }
}
