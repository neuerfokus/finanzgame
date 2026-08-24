# Spec 04 — Flame Monetaria-Hub

## Goal

Embed `FlameGame` als `MonetariaWorld` Vollbild-Widget hinter AppIcon „Monetaria" im Springboard. Tiled-Map zeigt Heimathafen + 3 Inseln (1 unlocked, 2 gelocked). Tap auf Insel → Bootsanimation → Inselansicht (Placeholder).

## Why

Monetaria ist die Fantasy-Welt. Flame-Engine = production-ready für 2D-Pixel-Sim. Phone-UI bleibt Flutter (schneller iterativ), Monetaria bekommt eigene Engine-Schicht.

## Non-Goals

- Pflanzen-Mechanik (Sprint 5)
- Wetter-Animation (Sprint 6)
- Mehrere Bootsklassen (Sprint 5+)

## Dependencies

```yaml
dependencies:
  flame: ^1.18.0
  flame_tiled: ^1.20.0
```

## Tiled-Map: assets/maps/monetaria.tmx

Layout (Beispiel-Layer-Stack):
- `background` — Ozean-Tiles
- `islands` — Statische Insel-Tiles
- `markers` — Object-Layer mit Punkten pro Insel: `id`, `name`, `unlockRequirement`
- `paths` — Boots-Wege als Polyline

3 Inseln:
- **Heimathafen** (zentral, Spawn)
- **Spar-Insel** (links unten, unlocked nach Sprint-1-Onboarding)
- **Mischwald-Insel** (rechts oben, gelocked initial)

## Code-Struktur

```
lib/game/monetaria/
  monetaria_world.dart       # FlameGame entry
  components/
    island_marker.dart       # SpriteComponent + tap callback
    boat.dart                # animated sprite, moves between markers
    weather_overlay.dart     # placeholder
  state/
    monetaria_state.dart     # Riverpod provider for unlocks
```

`MonetariaWorld` class:

```dart
class MonetariaWorld extends FlameGame with TapCallbacks {
  late TiledComponent map;
  late Boat boat;
  final List<IslandMarker> islands = [];

  @override
  Future<void> onLoad() async {
    map = await TiledComponent.load('monetaria.tmx', Vector2.all(32));
    add(map);
    _spawnIslandsFromMap();
    boat = Boat(homePort: islands.first.position);
    add(boat);
  }

  void _spawnIslandsFromMap() {
    final markers = map.tileMap.getLayer<ObjectGroup>('markers');
    for (final obj in markers!.objects) {
      islands.add(IslandMarker(
        id: obj.name,
        unlocked: _isUnlocked(obj.properties),
        position: Vector2(obj.x, obj.y),
      ));
      add(islands.last);
    }
  }
}
```

`IslandMarker`:

```dart
class IslandMarker extends SpriteComponent with TapCallbacks {
  IslandMarker({required this.id, required this.unlocked, required Vector2 position}) {
    this.position = position;
    size = Vector2.all(48);
  }
  final String id;
  final bool unlocked;

  @override
  void onTapDown(TapDownEvent event) {
    if (!unlocked) {
      // show lock sound + shake
      return;
    }
    (parent as MonetariaWorld).boat.travelTo(this);
  }
}
```

`Boat`:

```dart
class Boat extends SpriteComponent {
  Boat({required Vector2 homePort}) : super(position: homePort, size: Vector2(32, 32));

  Future<void> travelTo(IslandMarker dest) async {
    final tween = MoveEffect.to(dest.position, EffectController(duration: 1.5));
    add(tween);
    await Future.delayed(const Duration(milliseconds: 1500));
    // emit event so Flutter side opens IslandPage
  }
}
```

## Flutter-Integration

`monetaria_page.dart` ConsumerStatefulWidget:

```dart
class MonetariaPage extends ConsumerStatefulWidget {
  const MonetariaPage({super.key});
  @override
  ConsumerState<MonetariaPage> createState() => _State();
}

class _State extends ConsumerState<MonetariaPage> {
  late final MonetariaWorld _game;

  @override
  void initState() {
    super.initState();
    _game = MonetariaWorld(
      onIslandSelected: (id) => context.push('/monetaria/island/$id'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhoneFrame(
      appName: 'Monetaria',
      child: GameWidget(game: _game),
    );
  }
}
```

Router-Eintrag:

```dart
GoRoute(path: '/monetaria', builder: (_, _) => const MonetariaPage()),
GoRoute(path: '/monetaria/island/:id', builder: (_, s) => IslandPage(islandId: s.pathParameters['id']!)),
```

## Tests

- `test/game/monetaria_world_test.dart`: erstelle MonetariaWorld, load map, assert islands list length = 3, assert Spar-Insel unlocked, andere gelocked.
- `test/features/monetaria/monetaria_page_test.dart`: widget pump, assert GameWidget visible.

Limitation: Tap-Tests in Flame brauchen `tester.tapAt` + Pixel-Koordinaten — schwierig. Stattdessen Unit-Tests für `IslandMarker.onTapDown`-Logik mit Mocks.

## Acceptance

- [x] Flame als Dep, build clean
- [x] `assets/maps/monetaria.tmx` mit 3 Inseln + Heimathafen
- [x] Tap auf unlocked Insel → Boot-Animation → Flutter-Navigation zu IslandPage-Placeholder
- [x] Tap auf gelocked Insel → SFX-Stub + Shake-Animation
- [x] `MonetariaPage` integriert in Phone-Springboard (AppIcon Monetaria)
- [x] Golden-Test für MonetariaPage (Sprite-Layout)
- [x] `flutter analyze --fatal-infos` clean
- [x] Commit: `feat(game): add Flame Monetaria-Hub with Tiled map + 3 islands`

## Done When

Spieler tippt Monetaria-AppIcon, sieht Pixel-Karte mit 3 Inseln, tappt Spar-Insel, sieht Boot fahren, landet auf Placeholder-Island-Page.
