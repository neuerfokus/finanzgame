# Spec 05 — Spar-Insel + Pflanzen-Mechanik

## Goal

Erste echte Insel-Interaktion. Spar-Insel hat 4 Plots, Spieler pflanzt Elefantenfuß, Pflanzen reifen via `advanceDay()` (Spec-01-Pipeline), Spieler erntet mit Juice (Particle + Sound + Coin-Pop), Ertrag landet im Spar-Account.

## Why

Beweist Loop: Insel → Investition → Tage skippen → Ernte → Belohnung. Ohne diese Mechanik bleibt Monetaria leere Hülle. Pflanzen sind Stardew-vertraut + lehren Liquidität (Wachstumsdauer = Anlagehorizont).

## Non-Goals

- Mischwald (mehrere Pflanzen-Typen) — Sprint 6
- Wetter-Einfluss — Sprint 6
- Vulkan-Risiko — Sprint 8

## Domain Model

### `Plant` Entity

```dart
@freezed
abstract class Plant with _$Plant {
  const factory Plant({
    required String id,                    // UUID
    required String islandId,              // 'spar' for now
    required int plotIndex,                // 0..3
    required PlantKind kind,               // elephantsfoot for now
    required int plantedOnDayIndex,        // GameDay at planting
    required int currentStage,             // 0..maxStages
    required PlantStatus status,           // growing / ready / harvested
  }) = _Plant;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);
}

enum PlantKind { elephantsfoot }
enum PlantStatus { growing, ready, harvested }
```

### `PlantKindSpec` (configuration)

```dart
abstract final class PlantKinds {
  static const elephantsfoot = PlantKindSpec(
    kind: PlantKind.elephantsfoot,
    costCents: 50,
    growDays: 3,
    yieldCents: 52,
    stages: 4,
    weatherSensitivity: 0.0,
  );
}
```

## Drift Schema

```dart
class Plants extends Table {
  TextColumn get id => text()();
  TextColumn get islandId => text()();
  IntColumn get plotIndex => integer()();
  TextColumn get kind => text()();
  IntColumn get plantedOnDayIndex => integer()();
  IntColumn get currentStage => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('growing'))();
  @override
  Set<Column> get primaryKey => {id};
}
```

## DayEventListener: `PlantGrowthListener`

```dart
class PlantGrowthListener implements DayEventListener {
  PlantGrowthListener(this._plantRepo);
  final PlantRepository _plantRepo;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final plants = await _plantRepo.getActive();
    final events = <DayEvent>[];
    for (final p in plants) {
      final spec = PlantKinds.bySpec(p.kind);
      final daysGrown = newDay.dayIndex - p.plantedOnDayIndex;
      final expectedStage = (daysGrown * spec.stages / spec.growDays).floor().clamp(0, spec.stages);
      if (expectedStage > p.currentStage) {
        events.add(DayEvent.plantGrowth(plantId: p.id, newStage: expectedStage));
        if (expectedStage >= spec.stages) {
          events.add(DayEvent.plantReady(plantId: p.id));
        }
      }
    }
    return events;
  }
}
```

(Add `plantReady` variant to `DayEvent` union.)

## Repository

```dart
class PlantRepository {
  PlantRepository(this._db);
  final AppDatabase _db;

  Future<List<Plant>> getActive() async { ... }
  Future<Plant> plant({required String islandId, required int plotIndex, required PlantKind kind, required int dayIndex}) async { ... }
  Future<HarvestResult> harvest(String plantId) async { ... }
}

class HarvestResult {
  final Money yield;
  final Plant plant;
}
```

## Flame Components für Spar-Insel

`lib/game/monetaria/islands/spar_island.dart`:

```dart
class SparIslandScene extends Component with HasGameRef {
  final List<PlantPlot> plots = [];
  @override
  Future<void> onLoad() async {
    for (var i = 0; i < 4; i++) {
      plots.add(PlantPlot(plotIndex: i, position: _plotPosition(i)));
      add(plots[i]);
    }
  }
}

class PlantPlot extends SpriteComponent with TapCallbacks {
  // Tap empty plot → open PlantingMenu
  // Tap ready plant → harvest with juice
}
```

Plant-Sprites: 4 Stages für Elefantenfuß (Sapling → Small → Medium → Large).

Juice bei Harvest:
- Particle-Burst (Flame `ParticleSystemComponent`)
- Coin-Pop (mehrere Münz-Sprites, easeOutBack)
- Screen-Shake 200ms
- SFX `assets/sfx/harvest.wav`
- `flutter_animate` auf CashCounter im HUD (+N pop)

## UI: `PlantingMenu`

Modal-Sheet bei Tap auf leeren Plot:
- Liste verfügbarer PlantKinds (nur Elefantenfuß in Sprint-5)
- Kosten anzeigen
- „Pflanzen"-Button → deduct cash → create Plant entity → close menu → plot zeigt Stage-0-Sprite

## Tests

- Unit: `PlantGrowthListener` mit fake repo, verifiziere Stage-Progression über `advanceDay()` 1x, 2x, 3x.
- Unit: `PlantRepository.harvest` returnt korrekten Yield + setzt status = harvested.
- Widget: `PlantingMenu` zeigt Elefantenfuß-Eintrag, Tap pflanzt + schließt.
- Integration: `GameClock.advanceDay()` 4x → Plant geht von growing → ready → harvest gibt 52¢.

## Acceptance

- [x] `Plant` Entity + Drift table + Migration v2
- [x] `PlantRepository` mit getActive/plant/harvest
- [x] `PlantGrowthListener` in GameClock-Pipeline registriert (Stage 3 = plants)
- [x] Spar-Insel Flame-Scene mit 4 Plots
- [x] PlantingMenu UI
- [x] Harvest mit Juice (Particle + Sound-Stub + Coin-Pop + Shake)
- [x] Unit + Widget + Integration Tests grün
- [x] `flutter analyze --fatal-infos` clean
- [x] Commit: `feat(island): add Spar-Insel with Elefantenfuß plant mechanic`

## Done When

Spieler kann auf Spar-Insel einen Elefantenfuß pflanzen, 3x „Schlafen" drücken, sieht Pflanze wachsen, erntet mit Juice, Cash steigt um 52¢.
