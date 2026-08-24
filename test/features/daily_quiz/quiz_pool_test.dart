import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/daily_quiz/quiz_pool.dart';
import 'package:finanzgame/features/daily_quiz/quiz_question.dart';
import 'package:finanzgame/features/daily_quiz/quiz_topics.dart';

void main() {
  group('kQuizPool (spec-17)', () {
    test('has at least 20 entries', () {
      expect(kQuizPool.length, greaterThanOrEqualTo(20));
    });

    test('Round 28 v4: genug schwere Fragen für die Meisterprüfung (≥10)', () {
      final hard = kQuizPool
          .whereType<MultipleChoiceQuestion>()
          .where((q) => q.tier == QuizTier.hard)
          .length;
      expect(hard, greaterThanOrEqualTo(10),
          reason: 'Meisterprüfung zieht 10 Fragen aus dem hard-Pool');
    });

    test('every entry is a 4-option multiple-choice with valid correctIndex',
        () {
      for (final q in kQuizPool) {
        switch (q) {
          case MultipleChoiceQuestion(
                :final text,
                :final options,
                :final correctIndex,
                :final explanation,
              ):
            expect(text, isNotEmpty);
            expect(options.length, 4, reason: 'must have 4 options: $text');
            expect(correctIndex, inInclusiveRange(0, 3),
                reason: 'correctIndex out of range: $text');
            expect(explanation, isNotEmpty);
            for (final opt in options) {
              expect(opt, isNotEmpty);
            }
        }
      }
    });

    test('JSON round-trip preserves data', () {
      final original = kQuizPool.first;
      final json = original.toJson();
      final restored = QuizQuestion.fromJson(json);
      expect(restored, equals(original));
    });
  });
}
