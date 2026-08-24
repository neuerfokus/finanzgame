import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';

part 'achievements_repository.g.dart';

/// Persisted unlocked achievement IDs keyed by id → dayIndex of unlock.
///
/// `keepAlive: true`. Hydrated from [DbSnapshot.achievements]. Adds are
/// idempotent (re-inserting an id is a no-op) so the GameClock can run the
/// rule evaluator every day without spam.
@Riverpod(keepAlive: true)
class AchievementsRepository extends _$AchievementsRepository {
  @override
  Map<String, int> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return Map<String, int>.from(snap.achievements);
  }

  /// Inserts [id] into the unlocked set if absent. Returns true if the id
  /// is new (caller can fire a Juice-popup); false if it was already there.
  bool unlock(String id, int dayIndex) {
    if (state.containsKey(id)) return false;
    state = {...state, id: dayIndex};
    _persist(id, dayIndex);
    // Spec-43 v4: trigger toast/confetti via separate emitter-provider.
    ref.read(lastAchievementUnlockProvider.notifier).fire(id);
    return true;
  }

  bool isUnlocked(String id) => state.containsKey(id);

  void _persist(String id, int dayIndex) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.achievementsDao.insert(id, dayIndex).catchError((Object _) {}),
    );
  }
}

/// Spec-43 v4: meldet UI-Listener wenn frisch unlocked.
/// State = (id, ticks) — ticks++ bei jedem fire damit ref.listen
/// auch identische IDs erneut triggert (z.B. mehrere Achievements
/// am selben Tag).
@Riverpod(keepAlive: true)
class LastAchievementUnlock extends _$LastAchievementUnlock {
  @override
  ({String? id, int tick}) build() => (id: null, tick: 0);

  void fire(String id) {
    state = (id: id, tick: state.tick + 1);
  }
}
