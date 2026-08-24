import 'dart:math' as math;

import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../market_phase.dart';

/// Adapter zum Lesen/Schreiben der aktuellen [MarketPhase] pro
/// Asset-Klasse. Implementiert auf Feature-Seite vom
/// `MarketPhaseRepository` (Riverpod).
abstract class MarketPhaseSource {
  MarketPhase phaseFor(String classId);
  void updatePhase(String classId, MarketPhase phase);
}

/// Sprint B: läuft VOR den Asset-Preis-Listenern in der Day-Pipeline.
/// Transitioniert pro Asset-Klasse:
///
///   normal       --(rng < chance)--> drawdown
///   drawdown(n)  --tick-->            drawdown(n-1)
///   drawdown(0)  --auto-->            recovery
///   recovery(n)  --tick-->            recovery(n-1)
///   recovery(0)  --auto-->            normal
///
/// Emittiert [CrashStartedEvent] / [RecoveryCompleteEvent] an den
/// Transitions-Tagen. Deterministisch über (seed, classId, dayIndex).
class MarketPhaseListener implements DayEventListener {
  MarketPhaseListener({
    required this.source,
    required this.seed,
    this.profiles = MarketProfiles.all,
  });

  final MarketPhaseSource source;
  final int seed;
  final List<MarketPhaseProfile> profiles;

  /// Seed, mit dem der Listener in der echten Pipeline läuft. Als Konstante
  /// hier, damit [willCrashWithin] denselben Wurf vorhersagen kann.
  static const int defaultSeed = 0xB0BCAFE;

  /// Deterministische Vorschau für den News-Ticker: startet in den nächsten
  /// [horizon] Tagen in irgendeiner Klasse ein Crash?
  ///
  /// Spiegelt exakt den Wurf aus [_transition]. Unschärfe by design: steckt
  /// eine Klasse gerade in drawdown/recovery, wird ihr Wurf an dem Tag gar
  /// nicht konsultiert — die Vorhersage kann also zu oft warnen, nie zu
  /// selten. Der Ticker formuliert deshalb „möglicherweise".
  static bool willCrashWithin(
    int currentDayIndex, {
    int horizon = 2,
    int seed = defaultSeed,
    List<MarketPhaseProfile> profiles = MarketProfiles.all,
  }) {
    for (var i = 1; i <= horizon; i++) {
      final d = currentDayIndex + i;
      for (final profile in profiles) {
        final rng = math.Random(seed ^ profile.classId.hashCode ^ (d * 2654435761));
        if (rng.nextDouble() < profile.crashChancePerDay) return true;
      }
    }
    return false;
  }

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final out = <DayEvent>[];
    for (final profile in profiles) {
      final current = source.phaseFor(profile.classId);
      final next = _transition(current, profile, newDay, out);
      source.updatePhase(profile.classId, next);
    }
    return out;
  }

  MarketPhase _transition(
    MarketPhase current,
    MarketPhaseProfile profile,
    GameDay day,
    List<DayEvent> out,
  ) {
    switch (current) {
      case NormalPhase():
        final rngSeed =
            seed ^ profile.classId.hashCode ^ (day.dayIndex * 2654435761);
        final rng = math.Random(rngSeed);
        if (rng.nextDouble() < profile.crashChancePerDay) {
          final depth = profile.crashDepthMin +
              rng.nextDouble() *
                  (profile.crashDepthMax - profile.crashDepthMin);
          out.add(
            DayEvent.crashStarted(
              assetClassId: profile.classId,
              depthPct: depth,
              durationDays: profile.drawdownDuration,
            ),
          );
          return MarketPhase.drawdown(
            daysLeft: profile.drawdownDuration,
            totalDays: profile.drawdownDuration,
            depthPct: depth,
          );
        }
        return current;

      case DrawdownPhase(:final daysLeft, :final totalDays, :final depthPct):
        if (daysLeft > 1) {
          return MarketPhase.drawdown(
            daysLeft: daysLeft - 1,
            totalDays: totalDays,
            depthPct: depthPct,
          );
        }
        // Drawdown-Boden erreicht → Recovery starten.
        return MarketPhase.recovery(
          daysLeft: profile.recoveryDuration,
          totalDays: profile.recoveryDuration,
          targetReturnPct: depthPct * profile.recoveryFraction,
        );

      case RecoveryPhase(:final daysLeft, :final totalDays, :final targetReturnPct):
        if (daysLeft > 1) {
          return MarketPhase.recovery(
            daysLeft: daysLeft - 1,
            totalDays: totalDays,
            targetReturnPct: targetReturnPct,
          );
        }
        out.add(DayEvent.recoveryComplete(assetClassId: profile.classId));
        return const MarketPhase.normal();
    }
  }

  /// Tages-Return-Modifier aus dem aktuellen Phase-Zustand. Wird vom
  /// jeweiligen Preis-Listener zusätzlich zum normalen Drift addiert.
  ///
  ///   normal     →  0
  ///   drawdown   → -(depthPct / totalDays)   [verteilt linear über Phase]
  ///   recovery   → +(targetReturnPct / totalDays)
  static double dailyModifierFor(MarketPhase phase) {
    return switch (phase) {
      NormalPhase() => 0.0,
      DrawdownPhase(:final totalDays, :final depthPct) =>
        -(depthPct / totalDays),
      RecoveryPhase(:final totalDays, :final targetReturnPct) =>
        targetReturnPct / totalDays,
    };
  }
}
