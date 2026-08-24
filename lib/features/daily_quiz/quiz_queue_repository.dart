import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'quiz_topics.dart';

part 'quiz_queue_repository.g.dart';

/// Spec-45 E4: Spaced-Repetition Queue für Quiz-Reviews nach Quest-Complete.
///
/// In-memory (kein Drift bis H1 Sammelmigration). Geht bei App-Restart
/// verloren — akzeptabel für Lern-Loop, fällige Reviews kommen sonst
/// einfach am nächsten Schlafen vorbei.
///
/// Hook: `QuestRunnerController` ruft [enqueueForQuest] beim Wechsel auf
/// completed. Pick-Priorität in [DailyQuizState.questionFor].
@Riverpod(keepAlive: true)
class QuizQueueRepository extends _$QuizQueueRepository {
  @override
  List<QueuedReview> build() => const [];

  /// Lege 3 Reviews für Quest [questId] in die Queue: Topics aus
  /// [kQuestTopics], Offsets aus [kReviewOffsets].
  void enqueueForQuest(String questId, int currentDayIndex) {
    final topics = kQuestTopics[questId];
    if (topics == null || topics.isEmpty) return;
    final additions = <QueuedReview>[];
    for (final offset in kReviewOffsets) {
      additions.add(
        QueuedReview(
          questId: questId,
          topic: topics.first,
          dueDayIndex: currentDayIndex + offset,
        ),
      );
    }
    state = List.unmodifiable([...state, ...additions]);
  }

  /// Gibt den ältesten fälligen Review (dueDay ≤ dayIndex) zurück und
  /// entfernt ihn. Null wenn nichts fällig.
  QueuedReview? popDueOn(int dayIndex) {
    final idx = state.indexWhere((r) => r.dueDayIndex <= dayIndex);
    if (idx < 0) return null;
    final picked = state[idx];
    final next = [...state]..removeAt(idx);
    state = List.unmodifiable(next);
    return picked;
  }

  /// Test-Hook: aktueller Queue-Stand.
  List<QueuedReview> get queue => state;
}

/// Spec-45 E4: ein gequeueter Review-Eintrag.
class QueuedReview {
  const QueuedReview({
    required this.questId,
    required this.topic,
    required this.dueDayIndex,
  });

  final String questId;
  final String topic;
  final int dueDayIndex;

  @override
  bool operator ==(Object other) =>
      other is QueuedReview &&
      other.questId == questId &&
      other.topic == topic &&
      other.dueDayIndex == dueDayIndex;

  @override
  int get hashCode => Object.hash(questId, topic, dueDayIndex);
}
