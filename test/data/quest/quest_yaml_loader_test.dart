import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/quest/quest_yaml_loader.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/quest/quest.dart';

const _sample = '''
id: q01
title: Test Quest
location: test.loc
prerequisites:
  - other_quest
reward:
  cash_cents: 100
  xp: 25
steps:
  - id: s1
    type: dialog
    speaker: Magister
    lines:
      - Hello
      - World
  - id: s2
    type: quiz
    question: 2 + 2?
    options:
      - { id: a, label: "3" }
      - { id: b, label: "4" }
    correct: b
    explanation: Math.
  - id: s3
    type: choice
    prompt: Pick one
    options:
      - { id: x, label: First }
      - { id: y, label: Second }
''';

void main() {
  group('QuestYamlLoader', () {
    test('parses sample quest', () {
      final quest = const QuestYamlLoader().parse(_sample);

      expect(quest.id, 'q01');
      expect(quest.title, 'Test Quest');
      expect(quest.location, 'test.loc');
      expect(quest.prerequisites, ['other_quest']);
      expect(quest.reward.cash, const Money.cents(100));
      expect(quest.reward.xp, 25);
      expect(quest.steps.length, 3);
    });

    test('parses dialog step', () {
      final quest = const QuestYamlLoader().parse(_sample);
      final step = quest.steps[0];
      expect(step, isA<DialogStep>());
      step as DialogStep;
      expect(step.speaker, 'Magister');
      expect(step.lines, ['Hello', 'World']);
    });

    test('parses quiz step', () {
      final quest = const QuestYamlLoader().parse(_sample);
      final step = quest.steps[1];
      expect(step, isA<QuizStep>());
      step as QuizStep;
      expect(step.correctId, 'b');
      expect(step.options.length, 2);
      expect(step.explanation, 'Math.');
    });

    test('parses choice step', () {
      final quest = const QuestYamlLoader().parse(_sample);
      final step = quest.steps[2];
      expect(step, isA<ChoiceStep>());
      step as ChoiceStep;
      expect(step.prompt, 'Pick one');
      expect(step.options.map((o) => o.id), ['x', 'y']);
    });

    test('throws on unknown step type', () {
      const bad = '''
id: q
title: t
location: l
reward: { cash_cents: 0 }
steps:
  - id: s
    type: bogus
''';
      expect(() => const QuestYamlLoader().parse(bad),
          throwsA(isA<QuestYamlError>()));
    });
  });
}
