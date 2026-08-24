import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/quest/chat_entry.dart';
import 'quest_availability.dart';

part 'quest_progress_repository.g.dart';

/// Persisted quest-progress state. The repository exposes:
/// - sync read of progress entries (hydrated from [DbSnapshot] at boot)
/// - async per-quest chat-history read (lazy, not preloaded)
/// - mutators that update the in-memory map AND fire-and-forget the DB write
///
/// State == `Map<String, QuestProgress>` (pure Dart) so widgets can rebuild
/// on any progress change (e.g. `QuestListPage` re-bucketing after
/// `markCompleted`). The Drift [QuestProgressRow] is mapped at the
/// boundary.
@Riverpod(keepAlive: true)
class QuestProgressRepository extends _$QuestProgressRepository {
  @override
  Map<String, QuestProgress> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return Map.unmodifiable({
      for (final r in snap.questProgress.values)
        r.questId: QuestProgress(
          questId: r.questId,
          currentStepIndex: r.currentStepIndex,
          status: r.status,
          startedOnDayIndex: r.startedOnDayIndex,
          completedOnDayIndex: r.completedOnDayIndex,
        ),
    });
  }

  QuestProgress? progressFor(String questId) => state[questId];

  /// Inserts/updates a 'running' entry with [dayIndex] as start day. If an
  /// entry already exists, leaves [QuestProgress.startedOnDayIndex] untouched.
  void markStarted(String questId, int dayIndex) {
    final existing = state[questId];
    final next = QuestProgress(
      questId: questId,
      currentStepIndex: existing?.currentStepIndex ?? 0,
      status: existing?.status ?? questStatusRunning,
      startedOnDayIndex: existing?.startedOnDayIndex ?? dayIndex,
      completedOnDayIndex: existing?.completedOnDayIndex,
    );
    _put(next);
  }

  /// Flips the entry to 'completed' and stamps [dayIndex].
  void markCompleted(String questId, int dayIndex) {
    final existing = state[questId];
    final next = QuestProgress(
      questId: questId,
      currentStepIndex: existing?.currentStepIndex ?? 0,
      status: questStatusCompleted,
      startedOnDayIndex: existing?.startedOnDayIndex ?? dayIndex,
      completedOnDayIndex: dayIndex,
    );
    _put(next);
  }

  /// Spec-42 Welle-6: löscht den persistenten Progress-Eintrag plus
  /// die zugehörige Chat-Historie. Verwendet vom Tutorial-Repeat.
  Future<void> deleteQuestProgress(String questId) async {
    final db = ref.read(appDatabaseProvider);
    await db.questProgressDao.deleteOne(questId).catchError((Object _) {});
    await db.questChatDao
        .deleteForQuest(questId)
        .catchError((Object _) {});
    final next = {...state}..remove(questId);
    state = next;
  }

  /// Updates the running step pointer. No-op if the quest has no entry yet —
  /// the caller is expected to [markStarted] first.
  void setStepIndex(String questId, int stepIndex) {
    final existing = state[questId];
    if (existing == null) return;
    _put(existing.copyWith(currentStepIndex: stepIndex));
  }

  /// Appends one chat entry to the persisted log. Order is determined by
  /// the DAO via `nextOrderIndex` so concurrent appends stay sequential.
  void appendChat(String questId, ChatEntry entry) {
    final db = ref.read(appDatabaseProvider);
    final payload = jsonEncode(entry.toJson());
    final kind = switch (entry) {
      NpcEntry() => 'npc',
      OwnEntry() => 'own',
      SystemEntry() => 'system',
    };
    unawaited(
      Future(() async {
        final order = await db.questChatDao.nextOrderIndex(questId);
        await db.questChatDao.append(
          questId: questId,
          orderIndex: order,
          kind: kind,
          payloadJson: payload,
        );
      }).catchError((Object _) {}),
    );
  }

  /// Lazy per-quest read of the persisted chat log. Returns an empty list
  /// when the quest has never been touched.
  Future<List<ChatEntry>> chatHistory(String questId) async {
    final db = ref.read(appDatabaseProvider);
    final rows = await db.questChatDao.loadFor(questId);
    return [
      for (final r in rows)
        ChatEntry.fromJson(jsonDecode(r.payloadJson) as Map<String, dynamic>),
    ];
  }

  void _put(QuestProgress next) {
    state = Map.unmodifiable({...state, next.questId: next});
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.questProgressDao
          .upsert(
            QuestProgressRow(
              questId: next.questId,
              currentStepIndex: next.currentStepIndex,
              status: next.status,
              startedOnDayIndex: next.startedOnDayIndex,
              completedOnDayIndex: next.completedOnDayIndex,
            ),
          )
          .catchError((Object _) {}),
    );
  }
}
