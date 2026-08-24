import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/quest/chat_entry.dart';
import 'package:finanzgame/domain/quest/quest.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/quest_runner/quest_runner_controller.dart';

const _quest = Quest(
  id: 'q_test',
  title: 'Test',
  location: 'test',
  reward: QuestReward(cash: Money.cents(100), xp: 10),
  steps: [
    QuestStep.dialog(
      id: 'd1',
      speaker: 'NPC',
      lines: ['Line A', 'Line B'],
    ),
    QuestStep.quiz(
      id: 'q1',
      question: 'Pick correct',
      options: [
        QuestOption(id: 'x', label: 'Wrong'),
        QuestOption(id: 'y', label: 'Right'),
      ],
      correctId: 'y',
    ),
    QuestStep.choice(
      id: 'c1',
      prompt: 'Choose',
      options: [
        QuestOption(id: '1', label: 'One'),
        QuestOption(id: '2', label: 'Two'),
      ],
    ),
  ],
);

void main() {
  group('QuestRunnerController', () {
    test('start → dialog buffered, advance pushes lines', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final ctrl = c.read(questRunnerControllerProvider(_quest).notifier);
      var s = c.read(questRunnerControllerProvider(_quest));
      expect(s.chat, isEmpty);
      expect(s.dialog, isNotNull);

      ctrl.advance();
      s = c.read(questRunnerControllerProvider(_quest));
      expect(s.chat.length, 1);
      expect((s.chat.last as NpcEntry).text, 'Line A');

      ctrl.advance();
      s = c.read(questRunnerControllerProvider(_quest));
      // Line B pushed AND quiz prompt pushed (step auto-advanced).
      expect(s.chat.whereType<NpcEntry>().length, 3);
      expect(s.awaitingInput, isTrue);
    });

    test('wrong quiz pick → system note, still on step', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final ctrl = c.read(questRunnerControllerProvider(_quest).notifier)
        ..advance()
        ..advance();
      final stepIdxBefore =
          c.read(questRunnerControllerProvider(_quest)).stepIndex;
      ctrl.answerQuiz('x');
      final s = c.read(questRunnerControllerProvider(_quest));
      expect(s.stepIndex, stepIdxBefore);
      expect(s.chat.last, isA<SystemEntry>());
    });

    test('correct quiz advances to choice', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final ctrl = c.read(questRunnerControllerProvider(_quest).notifier)
        ..advance()
        ..advance();
      ctrl.answerQuiz('y');
      final s = c.read(questRunnerControllerProvider(_quest));
      expect(s.awaitingInput, isTrue);
      expect(s.stepIndex, 2);
    });

    test('full playthrough credits reward + marks finished', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final cashBefore = c.read(cashStateProvider);
      c.read(questRunnerControllerProvider(_quest).notifier)
        ..advance() // Line A
        ..advance() // Line B + auto-enter quiz
        ..answerQuiz('y')
        ..pickChoice('1');

      final s = c.read(questRunnerControllerProvider(_quest));
      expect(s.finished, isTrue);
      // L6 (Analyse 2026-08): Abschluss-Markierung UND Auszahlung laufen
      // gemeinsam in einer Microtask — vorher wurde erst gezahlt und dann
      // markiert, ein Prozess-Kill dazwischen hätte doppelt ausgezahlt.
      await Future<void>.microtask(() {});
      expect(
        c.read(cashStateProvider),
        cashBefore + const Money.cents(100),
      );
    });
  });
}
