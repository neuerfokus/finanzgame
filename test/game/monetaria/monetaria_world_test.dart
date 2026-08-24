import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/game/monetaria/components/island_marker.dart';
import 'package:finanzgame/game/monetaria/monetaria_world.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

MonetariaWorld _makeWorld({
  Set<String> unlocked = const {IslandId.heimathafen, IslandId.sparInsel},
  void Function(String)? onSelected,
}) {
  return MonetariaWorld(
    unlockedIslandIds: unlocked,
    onIslandSelected: onSelected ?? (_) {},
  );
}

void main() {
  group('MonetariaWorld', () {
    testWithGame<MonetariaWorld>(
      'spawns 9 island markers',
      _makeWorld,
      (world) async {
        await world.ready();
        expect(world.islands.length, 9);
      },
    );

    testWithGame<MonetariaWorld>(
      'spar-insel unlocked, mischwald locked',
      _makeWorld,
      (world) async {
        await world.ready();
        final spar = world.islands.firstWhere((i) => i.id == IslandId.sparInsel);
        final misch = world.islands.firstWhere((i) => i.id == IslandId.mischwald);
        expect(spar.unlocked, isTrue);
        expect(misch.unlocked, isFalse);
      },
    );

    testWithGame<MonetariaWorld>(
      'boat spawns at heimathafen position',
      _makeWorld,
      (world) async {
        await world.ready();
        final home = world.islands.firstWhere(
          (i) => i.id == IslandId.heimathafen,
        );
        expect(world.boat.position, home.position);
      },
    );
  });

  group('IslandMarker', () {
    test('locked marker stores unlocked=false', () {
      final marker = IslandMarker(
        id: IslandId.mischwald,
        label: 'Mischwald',
        unlocked: false,
        worldPosition: Vector2.zero(),
        onSelected: (_) => fail('locked island must not trigger selection'),
      );
      expect(marker.unlocked, isFalse);
    });

    test('unlocked marker passes id to onSelected', () {
      String? capturedId;
      final marker = IslandMarker(
        id: IslandId.sparInsel,
        label: 'Spar-Insel',
        unlocked: true,
        worldPosition: Vector2.zero(),
        onSelected: (m) => capturedId = m.id,
      );
      // Direct callback invocation since onTapDown requires Flame event plumbing.
      marker.onSelected(marker);
      expect(capturedId, IslandId.sparInsel);
    });
  });
}
