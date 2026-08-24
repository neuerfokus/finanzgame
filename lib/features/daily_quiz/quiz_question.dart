import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

/// Spec-17: a single daily-quiz question.
///
/// Sealed union — currently only [QuizQuestion.multipleChoice] but kept
/// open for future formats (true/false, ordering, etc).
@Freezed(unionKey: 'type')
sealed class QuizQuestion with _$QuizQuestion {
  /// Multiple-choice question with exactly one correct answer.
  ///
  /// - [text] — the question prompt shown to the player.
  /// - [options] — typically 4 entries; UI renders one button per entry.
  /// - [correctIndex] — 0-based index into [options].
  /// - [explanation] — shown after the player picks, regardless of right/wrong.
  @FreezedUnionValue('multipleChoice')
  const factory QuizQuestion.multipleChoice({
    required String text,
    required List<String> options,
    required int correctIndex,
    required String explanation,
    // Spec-38 P3-3: topic-Tag für Quest/Quiz-Dedup. Leer = kein Tag.
    @Default('') String topic,
    // Spec-45 Bucket I: 0=easy, 1=mid, 2=hard (siehe quiz_topics.dart).
    @Default(0) int tier,
  }) = MultipleChoiceQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

/// spec-32: deterministic per-day shuffle so the "correct answer is always
/// the middle one" pattern from the static catalog disappears.
extension QuizQuestionShuffle on QuizQuestion {
  QuizQuestion shuffled(int seed) {
    return switch (this) {
      MultipleChoiceQuestion(
        :final text,
        :final options,
        :final correctIndex,
        :final explanation,
        :final topic,
        :final tier,
      ) =>
        () {
          final indices = List<int>.generate(options.length, (i) => i);
          indices.shuffle(math.Random(seed));
          final newOptions = [for (final i in indices) options[i]];
          final newCorrect = indices.indexOf(correctIndex);
          return QuizQuestion.multipleChoice(
            text: text,
            options: newOptions,
            correctIndex: newCorrect,
            explanation: explanation,
            topic: topic,
            tier: tier,
          );
        }(),
    };
  }
}
