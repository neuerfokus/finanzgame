import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/game/monetaria/components/island_marker.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

/// Minimal host game just for mounting IslandMarker components in tests.
class _HostGame extends FlameGame {}

void main() {
  const allIds = [
    IslandId.heimathafen,
    IslandId.sparInsel,
    IslandId.mischwald,
    IslandId.etfInsel,
    IslandId.inflationAtoll,
    IslandId.aktienArchipel,
    IslandId.vulkan,
  ];

  group('IslandMarker render smoke (spec-16)', () {
    for (final id in allIds) {
      testWithGame<_HostGame>(
        'unlocked $id mounts without crash',
        _HostGame.new,
        (game) async {
          final marker = IslandMarker(
            id: id,
            label: id,
            unlocked: true,
            worldPosition: Vector2.zero(),
            onSelected: (_) {},
          );
          await game.add(marker);
          await game.ready();
          expect(marker.isMounted, isTrue);
        },
      );

      testWithGame<_HostGame>(
        'locked $id mounts without crash',
        _HostGame.new,
        (game) async {
          final marker = IslandMarker(
            id: id,
            label: id,
            unlocked: false,
            worldPosition: Vector2.zero(),
            onSelected: (_) {},
          );
          await game.add(marker);
          await game.ready();
          expect(marker.isMounted, isTrue);
        },
      );
    }
  });
}
