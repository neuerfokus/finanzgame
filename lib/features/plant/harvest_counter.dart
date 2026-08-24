import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'harvest_counter.g.dart';

/// Wie viele Pflanzen der Spieler am aktuellen Spieltag geerntet hat.
///
/// Analyse-Runde 2026-08: Das Tagesziel „3× ernten" prüfte
/// `lifetimeHarvestState >= 100` — also „hast du IRGENDWANN mal mindestens
/// 1 € aus Ernten bekommen". Nach der allerersten Ernte war das Ziel damit an
/// jedem weiteren Tag automatisch erfüllt: 5 € + 50 XP fürs Nichtstun.
///
/// Bewusst NUR im Speicher (keine Drift-Spalte): der Zähler lebt genau einen
/// Spieltag. Ein App-Neustart setzt ihn auf 0 zurück, das Ziel muss dann neu
/// erfüllt werden — die Auszahlung ist über `lastClaimedGoalDay` persistiert,
/// doppelt kassieren geht also nicht.
@Riverpod(keepAlive: true)
class HarvestCounter extends _$HarvestCounter {
  @override
  ({int dayIndex, int count}) build() => (dayIndex: -1, count: 0);

  /// Eine Ernte an [dayIndex] verbuchen. Wechselt der Tag, beginnt der
  /// Zähler von vorn.
  void record(int dayIndex) {
    state = state.dayIndex == dayIndex
        ? (dayIndex: dayIndex, count: state.count + 1)
        : (dayIndex: dayIndex, count: 1);
  }

  int countFor(int dayIndex) =>
      state.dayIndex == dayIndex ? state.count : 0;
}
