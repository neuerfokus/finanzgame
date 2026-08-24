import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';

part 'plant.freezed.dart';
part 'plant.g.dart';

/// Species of plant. spec-34: catalogue extended — Sonnenblume (sun-loving,
/// short cycle), Kaktus (drought-resistant, slow but lucrative), Tomate
/// (high yield, weather-sensitive), Bambus (long cycle, best return).
/// Initial of the enum name doubles as the day-summary id prefix
/// (E1, S1, K1, T1, B1…).
enum PlantKind {
  elephantsfoot,
  sonnenblume,
  kaktus,
  tomate,
  bambus,
  erdbeere,
  karotte,
  apfel,
  salat,
  kuerbis,
}

/// Lifecycle of a plant in a plot.
///
/// `withered` (spec-18) = destroyed by a storm event; no harvest possible.
enum PlantStatus { growing, ready, harvested, withered }

/// Spec-43 v3: Jahreszeiten basierend auf dayIndex modulo 365.
/// 0–89 Winter, 90–179 Frühling, 180–269 Sommer, 270–364 Herbst.
enum Season {
  winter('❄️ Winter'),
  fruehling('🌸 Frühling'),
  sommer('☀️ Sommer'),
  herbst('🍂 Herbst');

  const Season(this.label);
  final String label;
}

Season seasonForDayIndex(int dayIndex) {
  final d = dayIndex % 365;
  if (d < 90) return Season.winter;
  if (d < 180) return Season.fruehling;
  if (d < 270) return Season.sommer;
  return Season.herbst;
}

/// Persistent state of one plant in one plot.
///
/// [growthProgress] is the weather-weighted growth counter in **tenths**
/// (spec-18). One neutral day advances it by `10 * stages / growDays`
/// (rounded up). [currentStage] = `growthProgress ~/ 10`, clamped to
/// `spec.stages`. Plants persisted before spec-18 land with
/// `growthProgress = currentStage * 10` so reload is transparent.
@freezed
abstract class Plant with _$Plant {
  const factory Plant({
    required String id,
    required String islandId,
    required int plotIndex,
    required PlantKind kind,
    required int plantedOnDayIndex,
    @Default(0) int currentStage,
    @Default(0) int growthProgress,
    @Default(PlantStatus.growing) PlantStatus status,
  }) = _Plant;

  factory Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);
}

/// Static configuration per [PlantKind]: cost, grow days, yield, stage count.
class PlantKindSpec {
  const PlantKindSpec({
    required this.kind,
    required this.cost,
    required this.growDays,
    required this.yield_,
    required this.stages,
    required this.weatherSensitivity,
    this.seasons = const <Season>{
      Season.winter,
      Season.fruehling,
      Season.sommer,
      Season.herbst,
    },
  });

  final PlantKind kind;
  final Money cost;
  final int growDays;
  // `yield` is a reserved word in Dart.
  final Money yield_;
  final int stages;
  final double weatherSensitivity;

  /// Spec-43 v3: Jahreszeiten in denen diese Pflanze gepflanzt werden darf.
  final Set<Season> seasons;
}

abstract final class PlantKinds {
  static const elephantsfoot = PlantKindSpec(
    kind: PlantKind.elephantsfoot,
    cost: Money.cents(50),
    growDays: 3,
    yield_: Money.cents(52),
    stages: 4,
    weatherSensitivity: 0.0,
  );

  // spec-43 follow-up: Renditen runter — realistic 3-15 %/Tag statt
  // teils >25 %. Obst+Gemüse waren extrem overpowered (Salat war +75 % in 2 d).
  // Spec-43 v4: Wachstumszeiten an realen Pflanzen-Zyklen orientiert
  // (real ~ 10× game-skaliert). Yields entsprechend gestiegen damit
  // Rendite pro Tag in 3–8 %-Range bleibt.
  static const sonnenblume = PlantKindSpec(
    kind: PlantKind.sonnenblume,
    cost: Money.cents(120),
    growDays: 8, // real ~80 d
    yield_: Money.cents(280),
    stages: 4,
    weatherSensitivity: 0.6,
    seasons: {Season.sommer},
  );
  static const kaktus = PlantKindSpec(
    kind: PlantKind.kaktus,
    cost: Money.cents(300),
    growDays: 14,
    yield_: Money.cents(700),
    stages: 5,
    weatherSensitivity: -0.3,
  );
  static const tomate = PlantKindSpec(
    kind: PlantKind.tomate,
    cost: Money.cents(200),
    growDays: 8, // real ~80 d
    yield_: Money.cents(420),
    stages: 4,
    weatherSensitivity: 0.4,
    seasons: {Season.sommer, Season.herbst},
  );
  static const bambus = PlantKindSpec(
    kind: PlantKind.bambus,
    cost: Money.cents(800),
    growDays: 20,
    yield_: Money.cents(2200),
    stages: 6,
    weatherSensitivity: 0.2,
  );

  static const erdbeere = PlantKindSpec(
    kind: PlantKind.erdbeere,
    cost: Money.cents(80),
    growDays: 6, // real ~60 d
    yield_: Money.cents(170),
    stages: 3,
    weatherSensitivity: 0.5,
    seasons: {Season.fruehling, Season.sommer},
  );
  static const karotte = PlantKindSpec(
    kind: PlantKind.karotte,
    cost: Money.cents(60),
    growDays: 7, // real ~70 d
    yield_: Money.cents(140),
    stages: 4,
    weatherSensitivity: 0.1,
    seasons: {Season.sommer, Season.herbst},
  );
  static const apfel = PlantKindSpec(
    kind: PlantKind.apfel,
    cost: Money.cents(1500),
    growDays: 30, // real ~ 1 Jahr
    yield_: Money.cents(4500),
    stages: 8,
    weatherSensitivity: 0.3,
    seasons: {Season.herbst},
  );
  static const salat = PlantKindSpec(
    kind: PlantKind.salat,
    cost: Money.cents(40),
    growDays: 3, // real ~30 d
    yield_: Money.cents(85),
    stages: 3,
    weatherSensitivity: 0.2,
    seasons: {Season.fruehling, Season.sommer, Season.herbst},
  );
  static const kuerbis = PlantKindSpec(
    kind: PlantKind.kuerbis,
    cost: Money.cents(400),
    growDays: 10, // real ~100 d
    yield_: Money.cents(820),
    stages: 5,
    weatherSensitivity: 0.4,
    seasons: {Season.herbst},
  );

  static const all = <PlantKindSpec>[
    salat,
    elephantsfoot,
    karotte,
    sonnenblume,
    erdbeere,
    tomate,
    kuerbis,
    kaktus,
    bambus,
    apfel,
  ];

  static PlantKindSpec spec(PlantKind k) => switch (k) {
        PlantKind.elephantsfoot => elephantsfoot,
        PlantKind.sonnenblume => sonnenblume,
        PlantKind.kaktus => kaktus,
        PlantKind.tomate => tomate,
        PlantKind.bambus => bambus,
        PlantKind.erdbeere => erdbeere,
        PlantKind.karotte => karotte,
        PlantKind.apfel => apfel,
        PlantKind.salat => salat,
        PlantKind.kuerbis => kuerbis,
      };
}

/// spec-34: visible emoji + display name per plant. Used by planting-menu
/// and day-summary rows so the player can distinguish species at a glance.
extension PlantKindUi on PlantKind {
  String get emoji => switch (this) {
        PlantKind.elephantsfoot => '🌿',
        PlantKind.sonnenblume => '🌻',
        PlantKind.kaktus => '🌵',
        PlantKind.tomate => '🍅',
        PlantKind.bambus => '🎋',
        PlantKind.erdbeere => '🍓',
        PlantKind.karotte => '🥕',
        PlantKind.apfel => '🍎',
        PlantKind.salat => '🥬',
        PlantKind.kuerbis => '🎃',
      };

  String get displayName => switch (this) {
        PlantKind.elephantsfoot => 'Elefantenfuß',
        PlantKind.sonnenblume => 'Sonnenblume',
        PlantKind.kaktus => 'Kaktus',
        PlantKind.tomate => 'Tomate',
        PlantKind.bambus => 'Bambus',
        PlantKind.erdbeere => 'Erdbeere',
        PlantKind.karotte => 'Karotte',
        PlantKind.apfel => 'Apfelbaum',
        PlantKind.salat => 'Salat',
        PlantKind.kuerbis => 'Kürbis',
      };
}
