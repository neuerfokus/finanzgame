import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finanzgame/features/daily_quiz/quiz_queue_repository.dart';
import 'package:finanzgame/features/daily_quiz/quiz_topics.dart';

/// Spec-45 E4: enqueueForQuest fills 3 reviews (offsets 1/3/7),
/// popDueOn pops oldest due, leaves the rest.
void main() {
  test('enqueueForQuest adds 3 reviews with kReviewOffsets', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repo = container.read(quizQueueRepositoryProvider.notifier);

    repo.enqueueForQuest('q01_sparschwein', 10);

    expect(repo.queue, hasLength(3));
    expect(repo.queue.map((r) => r.dueDayIndex), [11, 13, 17]);
    expect(repo.queue.every((r) => r.topic == QuizTopic.sparen), isTrue);
  });

  test('enqueueForQuest is no-op for unknown questId', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repo = container.read(quizQueueRepositoryProvider.notifier);

    repo.enqueueForQuest('q99_does_not_exist', 5);

    expect(repo.queue, isEmpty);
  });

  test('popDueOn returns due review and removes it; null when nothing due',
      () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repo = container.read(quizQueueRepositoryProvider.notifier);

    repo.enqueueForQuest('q03_notgroschen', 0); // due 1, 3, 7

    // Day 0: nothing due.
    expect(repo.popDueOn(0), isNull);

    // Day 1: first review fires.
    final r1 = repo.popDueOn(1);
    expect(r1, isNotNull);
    expect(r1!.dueDayIndex, 1);
    expect(repo.queue, hasLength(2));

    // Day 4: only the 3-day-old one due (not the 7-day one).
    final r2 = repo.popDueOn(4);
    expect(r2, isNotNull);
    expect(r2!.dueDayIndex, 3);
    expect(repo.queue, hasLength(1));
  });

  test('tiersFor: <30=easy, <90=easy+mid, else all', () {
    expect(tiersFor(0), {QuizTier.easy});
    expect(tiersFor(29), {QuizTier.easy});
    expect(tiersFor(30), {QuizTier.easy, QuizTier.mid});
    expect(tiersFor(89), {QuizTier.easy, QuizTier.mid});
    expect(tiersFor(90), {QuizTier.easy, QuizTier.mid, QuizTier.hard});
    expect(tiersFor(500), {QuizTier.easy, QuizTier.mid, QuizTier.hard});
  });
}
