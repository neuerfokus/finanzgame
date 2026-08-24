import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/sim/listeners/market_phase_listener.dart';
import '../../domain/sim/market_phase.dart';

part 'market_phase_repository.g.dart';

/// In-Memory-Halter der aktuellen [MarketPhase] pro Asset-Klasse.
///
/// Sprint B v1: keine Persistenz — Phase resettet bei App-Kaltstart.
/// Persistenz folgt in Sprint H (schemaVersion 13 → 14).
@Riverpod(keepAlive: true)
class MarketPhaseRepository extends _$MarketPhaseRepository
    implements MarketPhaseSource {
  @override
  Map<String, MarketPhase> build() {
    return {
      for (final p in MarketProfiles.all) p.classId: const MarketPhase.normal(),
    };
  }

  @override
  MarketPhase phaseFor(String classId) =>
      state[classId] ?? const MarketPhase.normal();

  @override
  void updatePhase(String classId, MarketPhase phase) {
    state = {...state, classId: phase};
  }
}
