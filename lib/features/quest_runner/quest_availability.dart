import '../../domain/quest/quest.dart';

/// Quest-progress status constants. Stored as plain strings in the DB so the
/// Drift layer stays sealed-class-free.
const String questStatusRunning = 'running';
const String questStatusCompleted = 'completed';

/// Pure value object for per-quest progress. Mirrors [QuestProgressRow] but
/// stays Drift-free so it can live in widget signatures and pure tests.
class QuestProgress {
  const QuestProgress({
    required this.questId,
    required this.currentStepIndex,
    required this.status,
    this.startedOnDayIndex,
    this.completedOnDayIndex,
  });

  final String questId;
  final int currentStepIndex;

  /// `'running'` | `'completed'`. See [questStatusRunning] /
  /// [questStatusCompleted].
  final String status;
  final int? startedOnDayIndex;
  final int? completedOnDayIndex;

  QuestProgress copyWith({
    int? currentStepIndex,
    String? status,
    int? startedOnDayIndex,
    int? completedOnDayIndex,
  }) {
    return QuestProgress(
      questId: questId,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      status: status ?? this.status,
      startedOnDayIndex: startedOnDayIndex ?? this.startedOnDayIndex,
      completedOnDayIndex: completedOnDayIndex ?? this.completedOnDayIndex,
    );
  }
}

/// Pure helper: a quest is available iff every prerequisite has a
/// progress entry with status == [questStatusCompleted].
///
/// Quests without prerequisites are always available. Locked quests are
/// hidden behind the [questStatusCompleted] gate — the caller (e.g.
/// `QuestListPage`) renders them in the "Gesperrt" bucket.
bool isQuestAvailable(Quest quest, Map<String, QuestProgress> progress) {
  for (final prereqId in quest.prerequisites) {
    if (progress[prereqId]?.status != questStatusCompleted) return false;
  }
  return true;
}
