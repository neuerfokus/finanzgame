import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/quest/quest.dart';
import 'package:finanzgame/features/quest_runner/quest_availability.dart';

Quest _quest(String id, List<String> prerequisites) {
  return Quest(
    id: id,
    title: id,
    location: 'x',
    reward: const QuestReward(cash: Money.cents(0)),
    prerequisites: prerequisites,
  );
}

QuestProgress _completed(String id) => QuestProgress(
      questId: id,
      currentStepIndex: 0,
      status: questStatusCompleted,
      startedOnDayIndex: 0,
      completedOnDayIndex: 1,
    );

QuestProgress _running(String id) => QuestProgress(
      questId: id,
      currentStepIndex: 0,
      status: questStatusRunning,
      startedOnDayIndex: 0,
    );

void main() {
  group('isQuestAvailable', () {
    final cases = <(String, Quest, Map<String, QuestProgress>, bool)>[
      (
        'no prerequisites → always available',
        _quest('q1', const []),
        const {},
        true,
      ),
      (
        'single prereq completed → available',
        _quest('q2', const ['q1']),
        {'q1': _completed('q1')},
        true,
      ),
      (
        'single prereq running → locked',
        _quest('q2', const ['q1']),
        {'q1': _running('q1')},
        false,
      ),
      (
        'single prereq missing entirely → locked',
        _quest('q2', const ['q1']),
        const {},
        false,
      ),
      (
        'two prereqs both completed → available',
        _quest('q3', const ['q1', 'q2']),
        {'q1': _completed('q1'), 'q2': _completed('q2')},
        true,
      ),
      (
        'two prereqs, one running → locked',
        _quest('q3', const ['q1', 'q2']),
        {'q1': _completed('q1'), 'q2': _running('q2')},
        false,
      ),
    ];

    for (final c in cases) {
      test(c.$1, () {
        expect(isQuestAvailable(c.$2, c.$3), c.$4);
      });
    }
  });
}
