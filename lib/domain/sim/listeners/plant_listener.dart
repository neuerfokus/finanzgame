import 'dart:math' as math;

import '../../plant/plant.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../weather.dart';

/// Adapter the listener uses to read & mutate plant state.
///
/// Keeps the listener in `domain/` (no Riverpod import). The concrete
/// implementation lives in `features/plant/` and forwards to the
/// `PlantRepository` provider.
abstract class PlantGrowthSource {
  List<Plant> getActive();
  void update(Plant plant);
}

/// Lookup of the weather on a given day. Pure / deterministic; lives in
/// `features/weather/weather_state.dart` as `rollWeather`. Spec-18.
typedef WeatherForDay = Weather Function(int dayIndex);

/// Advances each active plant's growth based on the day's weather and emits
/// the matching events. Spec-18 — weather-aware growth.
///
/// Per neutral day a plant gains `ceil(10 * stages / growDays * 1.0)` tenths
/// of progress, scaled by [growthMultiplier]. `currentStage = progress ~/ 10`,
/// clamped to `spec.stages`. When `currentStage == spec.stages`, status
/// flips to [PlantStatus.ready].
///
/// On a [Weather.storm] day there is a 10 % chance (seeded with
/// `dayIndex * 31`) that one random ready plant withers — status flips to
/// [PlantStatus.withered] and a [DayEvent.plantWither] is emitted.
class PlantListener implements DayEventListener {
  const PlantListener(
    this._source, {
    required WeatherForDay weatherFor,
  }) : _weatherFor = weatherFor;

  final PlantGrowthSource _source;
  final WeatherForDay _weatherFor;

  /// Probability a single ready plant withers on a storm day.
  static const double stormWitherChance = 0.10;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final weather = _weatherFor(newDay.dayIndex);
    final plants = _source.getActive();
    final events = <DayEvent>[];
    final weatherMult = growthMultiplier(weather);
    final season = seasonForDayIndex(newDay.dayIndex);

    for (final plant in plants) {
      if (plant.status != PlantStatus.growing) continue;

      final spec = PlantKinds.spec(plant.kind);
      // Spec-43 v4: Saison-Modifier. In-season minimal-Bonus (1.05),
      // out-of-season 0.7. Klein gehalten damit Pflanzen-Tests stabil
      // bleiben (ceil-Round verhindert Drift).
      final seasonMult = spec.seasons.contains(season) ? 1.05 : 0.7;
      final mult = weatherMult * seasonMult;
      // Tenths added this day. Ceil so neutral weather still hits ripe
      // exactly on `growDays` (matches pre-spec-18 behaviour for cloudy).
      final delta =
          (10.0 * spec.stages * mult / spec.growDays).ceil();
      final maxProgress = spec.stages * 10;
      final newProgress =
          math.min(maxProgress, plant.growthProgress + delta);
      final newStage = (newProgress ~/ 10).clamp(0, spec.stages);

      if (newStage <= plant.currentStage &&
          newProgress == plant.growthProgress) {
        continue;
      }

      final reachedFinal = newStage >= spec.stages;
      final nextStatus =
          reachedFinal ? PlantStatus.ready : PlantStatus.growing;

      _source.update(
        plant.copyWith(
          currentStage: newStage,
          growthProgress: newProgress,
          status: nextStatus,
        ),
      );

      if (newStage > plant.currentStage) {
        events.add(
          DayEvent.plantGrowth(plantId: plant.id, newStage: newStage),
        );
      }
      if (reachedFinal && plant.status != PlantStatus.ready) {
        events.add(DayEvent.plantReady(plantId: plant.id));
      }
    }

    // Storm wither: deterministic per-day RNG. After growth so a plant
    // that ripened today can also wither today (worst-case Sturm-Schlag).
    if (weather == Weather.storm) {
      final rng = math.Random(newDay.dayIndex * 31);
      if (rng.nextDouble() < stormWitherChance) {
        // Re-read after growth-stage updates above.
        final ready = _source
            .getActive()
            .where((p) => p.status == PlantStatus.ready)
            .toList(growable: false);
        if (ready.isNotEmpty) {
          final victim = ready[rng.nextInt(ready.length)];
          _source.update(victim.copyWith(status: PlantStatus.withered));
          // Welle-8: wenn Pflanze gleich am Reifetag withered, plantReady
          // Event entfernen damit DaySummary nicht "erntereif" sagt obwohl
          // auf der Insel nichts mehr da ist.
          events.removeWhere((e) =>
              e is PlantReadyEvent && e.plantId == victim.id);
          events.add(DayEvent.plantWither(plantId: victim.id));
        }
      }
    }

    return events;
  }
}

/// Inert source used by the default provider until a real repo is bound.
class _EmptyPlantSource implements PlantGrowthSource {
  const _EmptyPlantSource();
  @override
  List<Plant> getActive() => const [];
  @override
  void update(Plant plant) {}
}

const PlantGrowthSource emptyPlantGrowthSource = _EmptyPlantSource();

/// Default neutral-weather lookup used when no real source is wired
/// (mostly inert tests).
Weather defaultWeatherFor(int dayIndex) => Weather.cloudy;
