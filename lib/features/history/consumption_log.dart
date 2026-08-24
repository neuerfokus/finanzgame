import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consumption_log.g.dart';

/// Spec-44 E1 — Opportunitätskosten.
///
/// In-memory Log aller Konsum-Käufe (Wishlist-Items). Bewusst KEIN
/// Drift-Schema-Change (pragmatischer Cut): das Log lebt nur für die
/// laufende Session, reicht aber für die Schattenlinie im Zeitreise-Chart.
///
/// Tupel: `(dayIndex, cents, label)`.
typedef ConsumptionEntry = ({int dayIndex, int cents, String label});

@Riverpod(keepAlive: true)
class ConsumptionLog extends _$ConsumptionLog {
  @override
  List<ConsumptionEntry> build() => const [];

  void add({required int dayIndex, required int cents, required String label}) {
    if (cents <= 0) return;
    state = [...state, (dayIndex: dayIndex, cents: cents, label: label)];
  }

  void clear() {
    state = const [];
  }
}
