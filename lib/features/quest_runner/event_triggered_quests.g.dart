// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_triggered_quests.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sprint C4: Hält IDs von Quests, die durch DayEvents in der letzten
/// DaySummary freigeschaltet wurden. In-memory, keepAlive — passt zur
/// pragmatic-cuts-Linie (kein Drift-Schema-Change in diesem Sprint).
///
/// Die Quest-Liste filtert event-gating Quests anhand dieser Menge aus,
/// solange das Event nicht emittiert wurde. Sobald die Quest abgeschlossen
/// (oder explizit per [acknowledge] entfernt) wurde, fällt sie wieder
/// raus.

@ProviderFor(EventTriggeredQuests)
final eventTriggeredQuestsProvider = EventTriggeredQuestsProvider._();

/// Sprint C4: Hält IDs von Quests, die durch DayEvents in der letzten
/// DaySummary freigeschaltet wurden. In-memory, keepAlive — passt zur
/// pragmatic-cuts-Linie (kein Drift-Schema-Change in diesem Sprint).
///
/// Die Quest-Liste filtert event-gating Quests anhand dieser Menge aus,
/// solange das Event nicht emittiert wurde. Sobald die Quest abgeschlossen
/// (oder explizit per [acknowledge] entfernt) wurde, fällt sie wieder
/// raus.
final class EventTriggeredQuestsProvider
    extends $NotifierProvider<EventTriggeredQuests, Set<String>> {
  /// Sprint C4: Hält IDs von Quests, die durch DayEvents in der letzten
  /// DaySummary freigeschaltet wurden. In-memory, keepAlive — passt zur
  /// pragmatic-cuts-Linie (kein Drift-Schema-Change in diesem Sprint).
  ///
  /// Die Quest-Liste filtert event-gating Quests anhand dieser Menge aus,
  /// solange das Event nicht emittiert wurde. Sobald die Quest abgeschlossen
  /// (oder explizit per [acknowledge] entfernt) wurde, fällt sie wieder
  /// raus.
  EventTriggeredQuestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventTriggeredQuestsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventTriggeredQuestsHash();

  @$internal
  @override
  EventTriggeredQuests create() => EventTriggeredQuests();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$eventTriggeredQuestsHash() =>
    r'8da4899c33705c4672e380f9e603776e2ac2cbdb';

/// Sprint C4: Hält IDs von Quests, die durch DayEvents in der letzten
/// DaySummary freigeschaltet wurden. In-memory, keepAlive — passt zur
/// pragmatic-cuts-Linie (kein Drift-Schema-Change in diesem Sprint).
///
/// Die Quest-Liste filtert event-gating Quests anhand dieser Menge aus,
/// solange das Event nicht emittiert wurde. Sobald die Quest abgeschlossen
/// (oder explizit per [acknowledge] entfernt) wurde, fällt sie wieder
/// raus.

abstract class _$EventTriggeredQuests extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
