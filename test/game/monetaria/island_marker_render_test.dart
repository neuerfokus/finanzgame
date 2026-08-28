import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/game/monetaria/components/island_marker.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

/// Minimal host game just for mounting IslandMarker components in tests.
class _HostGame extends FlameGame {}

void main() {
  // Aus kIslandSpecs abgeleitet statt handgepflegt: die alte Liste nannte
  // sieben IDs, die Karte hat aber neun — `goldmine` und `wohnviertel`
  // fehlten, und der Schatten-Waechter prüfte sie damit nicht. So bleibt
  // jede künftige Insel automatisch abgedeckt. Dasselbe Muster nutzt bereits
  // `island_overview_test`.
  final allIds = kIslandSpecs.map((s) => s.id).toList();

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

  // Der Schatten ist eine unscharfe schwarze Scheibe, die von 0,50 bis 1,40
  // Durchmesser reicht — die untere Haelfte jeder Insel liegt also in ihrem
  // Bereich. Liegt sie nicht ganz unten in der Zeichenreihenfolge, wird sie
  // UEBER die Insel gemalt statt darunter, und die Insel wirkt unten
  // abgedunkelt. Flame zeichnet nach priority aufsteigend, Hoeheres oben.
  group('Insel-Schatten liegt hinter der Insel', () {
    for (final id in allIds) {
      testWithGame<_HostGame>(
        '$id: Schatten hat die niedrigste priority',
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

          final shadow = marker.children.whereType<CircleComponent>().single;
          final others =
              marker.children.where((c) => !identical(c, shadow)).toList();
          expect(others, isNotEmpty);
          for (final c in others) {
            expect(
              c.priority,
              greaterThan(shadow.priority),
              reason: '${c.runtimeType} (priority ${c.priority}) wird vor dem '
                  'Schatten (priority ${shadow.priority}) gezeichnet und '
                  'verschwindet damit dahinter',
            );
          }
        },
      );
    }
  });
}
