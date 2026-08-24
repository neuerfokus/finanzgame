import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/game_clock.dart';
import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/plant/plant.dart';
import '../../domain/sim/listeners/plant_listener.dart';
import '../../domain/sim/weather.dart';
import '../audio/sound_service.dart';
import '../economy/cash_state.dart';
import 'plant_pricing.dart';
import '../weather/weather_state.dart';
import '../xp/xp_repository.dart';
import 'harvest_counter.dart';
import 'lifetime_harvest_state.dart';

part 'plant_repository.g.dart';

class HarvestResult {
  const HarvestResult({required this.plant, required this.yield_});
  final Plant plant;
  final Money yield_;
}

class PlantingError implements Exception {
  const PlantingError(this.message);
  final String message;
  @override
  String toString() => 'PlantingError: $message';
}

/// Persisted plant store. Seeds empty on first run; loads from
/// [PlantsTable] during pre-warm.
@Riverpod(keepAlive: true)
class PlantRepository extends _$PlantRepository implements PlantGrowthSource {
  int _idCounter = 0;

  @override
  List<Plant> build() {
    final snap = ref.watch(dbSnapshotProvider);
    final rows = snap.plants;
    final loaded = rows.map(_rowToPlant).toList(growable: false);
    // Re-seed id counter so newly planted ids don't collide with restored
    // ones. Welle-8: IDs sind "<Letter><n>" (z.B. "S5", "K3", "T2") —
    // alle führenden Buchstaben strippen, dann Zahl parsen.
    for (final p in loaded) {
      final digits = p.id.replaceAll(RegExp(r'[^0-9]'), '');
      final n = int.tryParse(digits);
      if (n != null && n >= _idCounter) _idCounter = n + 1;
    }
    return loaded;
  }

  /// Welle-8: kompletter Reset aller Pflanzen aller Inseln. User-Wunsch
  /// nach kaputten Saves. Entfernt auch harvested/withered Altlasten.
  /// Nicht mehr hinter dem 🧹-Button (zu brachial) — nur noch interner
  /// Hard-Reset-Pfad. Sichtbar räumt jetzt [clearWithered] auf.
  Future<void> resetAllPlants() async {
    state = const [];
    _idCounter = 0;
    final db = ref.read(appDatabaseProvider);
    await db.plantsDao.deleteAll().catchError((Object _) {});
  }

  /// 2026-06-04 (Sohn-Feedback): räumt NUR verdorrte (withered) Felder auf —
  /// und nur auf [islandId] (Sparinsel; andere Inseln haben keine
  /// verdorrenden Felder). Wachsende und reife Pflanzen bleiben unberührt —
  /// der 🧹-Button soll aufräumen, nicht laufende Ernten vernichten. Gibt die
  /// Anzahl entfernter Felder zurück.
  Future<int> clearWithered(String islandId) async {
    final witheredIds = {
      for (final p in state)
        if (p.islandId == islandId && p.status == PlantStatus.withered) p.id,
    };
    if (witheredIds.isEmpty) return 0;
    state = [
      for (final p in state)
        if (!witheredIds.contains(p.id)) p,
    ];
    final db = ref.read(appDatabaseProvider);
    for (final id in witheredIds) {
      await db.plantsDao.deleteById(id).catchError((Object _) {});
    }
    return witheredIds.length;
  }

  /// Returns all plants not yet harvested.
  @override
  List<Plant> getActive() =>
      state.where((p) => p.status != PlantStatus.harvested).toList();

  Plant? plantInPlot(String islandId, int plotIndex) {
    // Spec-38/40 follow-up: withered plants blockieren das Plot NICHT mehr
    // — sonst kann der Spieler nach einem Sturm nie wieder pflanzen.
    for (final p in state) {
      if (p.islandId == islandId &&
          p.plotIndex == plotIndex &&
          p.status != PlantStatus.harvested &&
          p.status != PlantStatus.withered) {
        return p;
      }
    }
    return null;
  }

  Plant plant({
    required String islandId,
    required int plotIndex,
    required PlantKind kind,
    required int dayIndex,
  }) {
    if (plantInPlot(islandId, plotIndex) != null) {
      throw const PlantingError('plot already occupied');
    }
    // Welle-8: entferne vorhandene WITHERED plant im selben Plot bevor neu
    // gepflanzt wird — sonst blockiert die alte verdorrte Pflanze die UI
    // (Grid zeigt firstOrNull, würde withered statt growing zeigen).
    final withered = state.firstWhere(
      (p) =>
          p.islandId == islandId &&
          p.plotIndex == plotIndex &&
          p.status == PlantStatus.withered,
      orElse: () => const Plant(
        id: '',
        islandId: '',
        plotIndex: -1,
        kind: PlantKind.salat,
        plantedOnDayIndex: 0,
      ),
    );
    if (withered.id.isNotEmpty) {
      state = state.where((p) => p.id != withered.id).toList();
    }
    final spec = PlantKinds.spec(kind);
    // Spec-43 v3: Saison-Check. Pflanze nur in passender Jahreszeit.
    final season = seasonForDayIndex(dayIndex);
    if (!spec.seasons.contains(season)) {
      final allowed = spec.seasons.map((s) => s.label).join(', ');
      throw PlantingError(
        'Falsche Jahreszeit (${season.label}). '
        '${kind.name} braucht: $allowed',
      );
    }
    final cashNotifier = ref.read(cashStateProvider.notifier);
    // spec-34: seed price drifts with inflation (early planting cheaper).
    final cost = PlantPricing(dayIndex).costFor(spec);
    if (!cashNotifier.spend(cost)) {
      throw const PlantingError('insufficient cash');
    }
    // spec-33: id prefix = first letter of plant kind so day-summary rows
    // read "E1, E2…" rather than "P1, P2".
    final prefix = kind.name.substring(0, 1).toUpperCase();
    final plant = Plant(
      id: '$prefix${_idCounter++}',
      islandId: islandId,
      plotIndex: plotIndex,
      kind: kind,
      plantedOnDayIndex: dayIndex,
    );
    state = [...state, plant];
    _persist(plant);
    // Spec-43 v4: Plant-SFX.
    SoundService.instance.playSfx(AudioKey.uiTap);
    return plant;
  }

  /// Replaces [updated] in the store (matched by id). Used by listener to
  /// advance growth stage / status.
  @override
  void update(Plant updated) {
    state = [
      for (final p in state)
        if (p.id == updated.id) updated else p,
    ];
    _persist(updated);
  }

  HarvestResult harvest(String plantId) {
    final plant = state.firstWhere(
      (p) => p.id == plantId,
      orElse: () => throw PlantingError('plant $plantId not found'),
    );
    if (plant.status != PlantStatus.ready) {
      throw const PlantingError('plant not ready');
    }
    final spec = PlantKinds.spec(plant.kind);
    final today = ref.read(gameClockProvider).dayIndex;
    final weather = rollWeather(today);
    final mult = yieldMultiplier(weather);
    final inflatedYield = PlantPricing(today).yieldFor(spec);
    var adjustedYield =
        Money.cents((inflatedYield.cents * mult).round());

    // Welle-7: Tages-Cap entfernt. User-Feedback: Werte im Pflanz-Menü
    // sollen exakt der Ernte entsprechen (modulo Wetter + Inflation).
    // Lategame-Balance läuft über ETF-Skalierung mit Kapital — ab ~30k €
    // ETF schlägt 8 %/J Drift die 12 Plots × Bambus-Yield-Decke.

    ref.read(cashStateProvider.notifier).earn(adjustedYield);
    // Lifetime harvest total — feeds ETF-island unlock milestone (spec-13).
    ref
        .read(lifetimeHarvestStateProvider.notifier)
        .addCents(adjustedYield.cents);
    // Tageszähler für das Tagesziel „3× ernten" (in-memory, siehe
    // HarvestCounter).
    ref.read(harvestCounterProvider.notifier).record(today);
    // Spec-21: +2 XP per harvest.
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.plantHarvested);
    final harvested = plant.copyWith(status: PlantStatus.harvested);
    update(harvested);
    // Welle-8: Achievements real-time (first_harvest etc).
    ref.read(gameClockProvider.notifier).evaluateAchievementsNow();
    return HarvestResult(plant: harvested, yield_: adjustedYield);
  }

  void _persist(Plant plant) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.plantsDao.upsert(_plantToRow(plant)).catchError((Object _) {}));
  }

  static Plant _rowToPlant(PlantRow row) {
    // Spec-18: derive progress from stage when row has the column default
    // (0) but stage > 0 — covers plants persisted before spec-18.
    final progress = row.growthProgress == 0 && row.currentStage > 0
        ? row.currentStage * 10
        : row.growthProgress;
    return Plant(
      id: row.id,
      islandId: row.islandId,
      plotIndex: row.plotIndex,
      kind: _kindFromString(row.kind),
      plantedOnDayIndex: row.plantedOnDayIndex,
      currentStage: row.currentStage,
      growthProgress: progress,
      status: _statusFromString(row.status),
    );
  }

  static PlantRow _plantToRow(Plant p) => PlantRow(
        id: p.id,
        islandId: p.islandId,
        plotIndex: p.plotIndex,
        kind: p.kind.name,
        plantedOnDayIndex: p.plantedOnDayIndex,
        currentStage: p.currentStage,
        growthProgress: p.growthProgress,
        status: p.status.name,
      );

  static PlantKind _kindFromString(String s) => PlantKind.values.firstWhere(
        (k) => k.name == s,
        orElse: () => PlantKind.elephantsfoot,
      );

  static PlantStatus _statusFromString(String s) =>
      PlantStatus.values.firstWhere(
        (k) => k.name == s,
        orElse: () => PlantStatus.growing,
      );
}
