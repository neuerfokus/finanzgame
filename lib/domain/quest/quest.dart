import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

/// One selectable option within a quiz or choice step.
@freezed
abstract class QuestOption with _$QuestOption {
  const factory QuestOption({
    required String id,
    required String label,
  }) = _QuestOption;

  factory QuestOption.fromJson(Map<String, dynamic> json) =>
      _$QuestOptionFromJson(json);
}

/// Reward paid out when the player finishes the quest.
@freezed
abstract class QuestReward with _$QuestReward {
  const factory QuestReward({
    @MoneyConverter() required Money cash,
    @Default(0) int xp,
  }) = _QuestReward;

  factory QuestReward.fromJson(Map<String, dynamic> json) =>
      _$QuestRewardFromJson(json);
}

/// One step in a quest. Sprint 6 supports dialog/quiz/choice; pay/buy/wait
/// land in later sprints.
@Freezed(unionKey: 'type')
sealed class QuestStep with _$QuestStep {
  /// NPC dialog: a sequence of lines from one speaker.
  @FreezedUnionValue('dialog')
  const factory QuestStep.dialog({
    required String id,
    required String speaker,
    required List<String> lines,
  }) = DialogStep;

  /// Quiz with one correct answer. Wrong picks emit a system message and
  /// let the player retry (Sprint 6 = no penalty).
  @FreezedUnionValue('quiz')
  const factory QuestStep.quiz({
    required String id,
    required String question,
    required List<QuestOption> options,
    required String correctId,
    String? explanation,
  }) = QuizStep;

  /// Free choice — every option advances the quest. Used for value
  /// judgments where there is no "right" answer.
  @FreezedUnionValue('choice')
  const factory QuestStep.choice({
    required String id,
    required String prompt,
    required List<QuestOption> options,
  }) = ChoiceStep;

  factory QuestStep.fromJson(Map<String, dynamic> json) =>
      _$QuestStepFromJson(json);
}

@freezed
abstract class Quest with _$Quest {
  const factory Quest({
    required String id,
    required String title,
    required String location,
    required QuestReward reward,
    @Default(<String>[]) List<String> prerequisites,
    @Default(<QuestStep>[]) List<QuestStep> steps,
    // Spec-38 P3-3: topic-Tag für Quest/Quiz-Dedup. Leer = kein Tag.
    @Default('') String topic,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
