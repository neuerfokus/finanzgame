import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'peak_tracker.g.dart';

/// Sprint C4: Pro Asset-Klasse mitgeführter Snapshot — Allzeit-Hoch,
/// ob & wann der Spieler im Drawdown verkauft hat. In-memory only
/// (keepAlive), keine Drift-Migration in diesem Sprint.
///
/// Wird konsumiert von:
/// - `advanceDay()`-Post-Pipeline → emittiert `panicSellRealized` /
///   `heldThroughCrash` wenn die Erholung greift.
/// - DaySummary-Breakdown (C1) → „vs. letztem Höchststand: −X €".
class PeakState {
  const PeakState({
    required this.peakValueCents,
    this.soldDuringDrawdown = false,
    this.soldAtDrawdownPct = 0.0,
    this.soldOnDay,
    this.soldValueCents = 0,
  });

  /// Bisheriges Allzeit-Hoch des Marktwerts der Klasse (in Cents).
  final int peakValueCents;

  /// True, wenn während eines Drawdowns verkauft wurde und das Event
  /// noch nicht abgearbeitet wurde (heldThroughCrash/panicSellRealized
  /// reset es wieder).
  final bool soldDuringDrawdown;

  /// Drawdown-% (positiv, 0.30 = 30% unter Peak) zum Zeitpunkt des
  /// Verkaufs.
  final double soldAtDrawdownPct;

  /// Game-Day, an dem verkauft wurde.
  final int? soldOnDay;

  /// Marktwert der Klasse direkt nach dem Verkauf, dient als Referenz
  /// für „Markt wieder über Verkaufs-Niveau".
  final int soldValueCents;

  PeakState copyWith({
    int? peakValueCents,
    bool? soldDuringDrawdown,
    double? soldAtDrawdownPct,
    int? soldOnDay,
    int? soldValueCents,
  }) =>
      PeakState(
        peakValueCents: peakValueCents ?? this.peakValueCents,
        soldDuringDrawdown: soldDuringDrawdown ?? this.soldDuringDrawdown,
        soldAtDrawdownPct: soldAtDrawdownPct ?? this.soldAtDrawdownPct,
        soldOnDay: soldOnDay ?? this.soldOnDay,
        soldValueCents: soldValueCents ?? this.soldValueCents,
      );

  /// Drawdown-% (positiv) für ein gegebenes [currentValueCents] —
  /// 0.0 wenn am oder über Peak.
  double drawdownFrom(int currentValueCents) {
    if (peakValueCents <= 0) return 0.0;
    if (currentValueCents >= peakValueCents) return 0.0;
    return (peakValueCents - currentValueCents) / peakValueCents;
  }
}

@Riverpod(keepAlive: true)
class PeakTracker extends _$PeakTracker {
  @override
  Map<String, PeakState> build() => const <String, PeakState>{};

  PeakState peakFor(String classId) =>
      state[classId] ?? const PeakState(peakValueCents: 0);

  /// Vergleicht aktuellen Wert mit Peak; setzt neuen Peak wenn höher.
  /// Wird in `advanceDay()` post-Pipeline für jede Asset-Klasse
  /// aufgerufen.
  void observeValue(String classId, int currentValueCents) {
    final prev = peakFor(classId);
    if (currentValueCents > prev.peakValueCents) {
      state = {
        ...state,
        classId: prev.copyWith(peakValueCents: currentValueCents),
      };
    }
  }

  /// Bookkeeping bei einem Verkauf während Drawdown. [currentValueCents]
  /// ist der Marktwert der Klasse *nach* dem Verkauf — er wird als
  /// Referenz für die Recovery-Schwelle gespeichert.
  void recordPanicSell({
    required String classId,
    required int dayIndex,
    required double drawdownPct,
    required int currentValueCents,
  }) {
    final prev = peakFor(classId);
    state = {
      ...state,
      classId: prev.copyWith(
        soldDuringDrawdown: true,
        soldAtDrawdownPct: drawdownPct,
        soldOnDay: dayIndex,
        soldValueCents: currentValueCents,
      ),
    };
  }

  /// Markiert das Panic-Sell-Flag als abgearbeitet (nach Emit von
  /// `panicSellRealized`). Peak bleibt erhalten.
  void clearPanicSell(String classId) {
    final prev = peakFor(classId);
    state = {
      ...state,
      classId: PeakState(peakValueCents: prev.peakValueCents),
    };
  }
}
