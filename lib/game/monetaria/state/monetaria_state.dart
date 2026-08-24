import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/db/app_database_provider.dart';

part 'monetaria_state.g.dart';

/// Identifier strings for islands on the Monetaria hub map.
///
/// Kept as plain string IDs so they round-trip cleanly through routes
/// (`/monetaria/island/:id`) and Tiled-map object names later.
abstract final class IslandId {
  static const heimathafen = 'heimathafen';
  static const sparInsel = 'spar_insel';
  static const mischwald = 'mischwald';
  static const etfInsel = 'etf_insel';
  static const inflationAtoll = 'inflation_atoll';
  static const aktienArchipel = 'aktien_archipel';
  static const vulkan = 'vulkan';

  /// Spec-22: Goldminen-Insel — Edelmetalle (Gold/Silber/Platin) als
  /// Inflations-Hedge. Unlock-Bedingung: nach Inflations-Atoll.
  static const goldmine = 'goldmine';

  /// spec-35 phase B: Immobilien-Insel — passive Miete + Wertsteigerung.
  static const wohnviertel = 'wohnviertel';
}

/// Static description of one island shown on the Monetaria map.
class IslandSpec {
  const IslandSpec({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
  });

  final String id;
  final String label;

  /// Position on the world (logical pixels). World size is fixed at
  /// World coordinates: 720×1200 — see [MonetariaWorld] (spec-28).
  final double x;
  final double y;
}

/// Hardcoded island layout. Spec-43 v4: world 880×1400. Spalten x=180/
/// 440/720 — rechte + mittlere noch weiter rechts.
const List<IslandSpec> kIslandSpecs = [
  // obere Reihe (y=260)
  IslandSpec(id: IslandId.etfInsel, label: 'ETF-Insel', x: 180, y: 260),
  IslandSpec(id: IslandId.wohnviertel, label: 'Wohnviertel', x: 440, y: 260),
  IslandSpec(id: IslandId.mischwald, label: 'Sammlerinsel', x: 720, y: 260),

  // mittlere Reihe (y=700)
  IslandSpec(
    id: IslandId.aktienArchipel,
    label: 'Aktien-Archipel',
    x: 180,
    y: 700,
  ),
  IslandSpec(id: IslandId.heimathafen, label: 'Heimathafen', x: 440, y: 700),
  IslandSpec(id: IslandId.vulkan, label: 'Vulkan-Insel', x: 720, y: 700),

  // untere Reihe (y=1140)
  IslandSpec(id: IslandId.sparInsel, label: 'Spar-Insel', x: 180, y: 1140),
  IslandSpec(
    id: IslandId.goldmine,
    label: 'Goldminen-Insel',
    x: 440,
    y: 1140,
  ),
  IslandSpec(
    id: IslandId.inflationAtoll,
    label: 'Inflations-Atoll',
    x: 720,
    y: 1140,
  ),
];

/// Default seed: heimathafen + spar_insel only. Everything else gates on
/// progression milestones in [MonetariaUnlocker] (spec-13).
const Set<String> kDefaultUnlocks = {
  IslandId.heimathafen,
  IslandId.sparInsel,
};

/// Riverpod state for Monetaria-Hub island unlocks.
///
/// Loads persisted unlocks from [DbSnapshot.unlockedIslands] on build; an
/// empty snapshot falls back to [kDefaultUnlocks]. [unlock] writes
/// fire-and-forget to keep the API synchronous.
@Riverpod(keepAlive: true)
class MonetariaState extends _$MonetariaState {
  @override
  Set<String> build() {
    final snap = ref.watch(dbSnapshotProvider);
    if (snap.unlockedIslands.isEmpty) {
      return kDefaultUnlocks;
    }
    // Always keep the defaults present even if the persisted set somehow
    // missed them (defensive — DB is the source of truth otherwise).
    return {...kDefaultUnlocks, ...snap.unlockedIslands};
  }

  bool isUnlocked(String islandId) => state.contains(islandId);

  void unlock(String islandId) {
    if (state.contains(islandId)) return;
    state = {...state, islandId};
    _persist(islandId);
  }

  void _persist(String islandId) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.unlockedIslandsDao.insert(islandId).catchError((Object _) {}),
    );
  }
}
