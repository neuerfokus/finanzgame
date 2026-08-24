import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';

part 'quest_failure_repository.g.dart';

/// Spec-45 Welle-8 Round 3: Quest-Fail-Cooldown.
///
/// Wenn Spieler im Quest-Quiz 2× falsch antwortet, ist die Quest für
/// [cooldownDays] Tage gesperrt. Danach kann er sie neu versuchen.
///
/// In-memory KeepAlive — überlebt App-Restart nicht, akzeptabel weil
/// Cooldown nur kurz (2 Tage = wenige Schlafen-Aktionen).
@Riverpod(keepAlive: true)
class QuestFailureRepository extends _$QuestFailureRepository {
  static const int cooldownDays = 2;

  @override
  Map<String, int> build() {
    // Drift v16: persistente Hydrate.
    Future<void>.microtask(_hydrate);
    return const {};
  }

  Future<void> _hydrate() async {
    if (!ref.mounted) return;
    final db = ref.read(appDatabaseProvider);
    final rows = await db.questFailureDao.loadAll();
    if (!ref.mounted) return;
    state = Map.unmodifiable({
      for (final r in rows) r.questId: r.failedOnDayIndex,
    });
  }

  /// Markiert Quest als gerade gescheitert. Cooldown läuft ab
  /// [currentDayIndex] + [cooldownDays].
  void recordFailure(String questId, int currentDayIndex) {
    state = Map.unmodifiable({...state, questId: currentDayIndex});
    final db = ref.read(appDatabaseProvider);
    unawaited(db.questFailureDao
        .upsert(questId, currentDayIndex)
        .catchError((Object _) {}));
  }

  /// True wenn Quest derzeit im Cooldown ist (nicht startbar).
  bool isOnCooldown(String questId, int currentDayIndex) {
    final failedDay = state[questId];
    if (failedDay == null) return false;
    return (currentDayIndex - failedDay) < cooldownDays;
  }

  /// Restliche Cooldown-Tage. 0 wenn nicht im Cooldown.
  int daysUntilRetry(String questId, int currentDayIndex) {
    final failedDay = state[questId];
    if (failedDay == null) return 0;
    final remaining = cooldownDays - (currentDayIndex - failedDay);
    return remaining < 0 ? 0 : remaining;
  }

  /// Cooldown manuell aufheben (Test-Hook).
  void clear(String questId) {
    final next = {...state}..remove(questId);
    state = Map.unmodifiable(next);
    final db = ref.read(appDatabaseProvider);
    unawaited(db.questFailureDao
        .deleteOne(questId)
        .catchError((Object _) {}));
  }
}
