import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/sim/day_event.dart';

part 'event_triggered_quests.g.dart';

/// Sprint C4: Hält IDs von Quests, die durch DayEvents in der letzten
/// DaySummary freigeschaltet wurden. In-memory, keepAlive — passt zur
/// pragmatic-cuts-Linie (kein Drift-Schema-Change in diesem Sprint).
///
/// Die Quest-Liste filtert event-gating Quests anhand dieser Menge aus,
/// solange das Event nicht emittiert wurde. Sobald die Quest abgeschlossen
/// (oder explizit per [acknowledge] entfernt) wurde, fällt sie wieder
/// raus.
@Riverpod(keepAlive: true)
class EventTriggeredQuests extends _$EventTriggeredQuests {
  /// IDs der Event-getriggerten Quests, die wir kennen — werden in
  /// [QuestListPage] für die Sichtbarkeit konsultiert.
  static const Set<String> knownEventGatedIds = {
    'q40_panic_sell_loss',
    'q41_held_through_crash',
  };

  @override
  Set<String> build() => const <String>{};

  /// Wird vom Sleep-Flow nach einem `advanceDay()` mit der Event-Liste
  /// gefüttert. Idempotent.
  void registerFromEvents(List<DayEvent> events) {
    final next = {...state};
    for (final e in events) {
      switch (e) {
        case PanicSellRealizedEvent():
          next.add('q40_panic_sell_loss');
        case HeldThroughCrashEvent():
          next.add('q41_held_through_crash');
        default:
          break;
      }
    }
    if (next.length != state.length) state = next;
  }

  /// Entfernt eine Quest aus der Sichtbarkeit (z.B. nach Abschluss).
  void acknowledge(String questId) {
    if (!state.contains(questId)) return;
    state = {...state}..remove(questId);
  }

  /// True wenn die Quest entweder NICHT event-gated ist oder bereits
  /// durch ein Event freigeschaltet wurde.
  bool isVisible(String questId) =>
      !knownEventGatedIds.contains(questId) || state.contains(questId);
}
