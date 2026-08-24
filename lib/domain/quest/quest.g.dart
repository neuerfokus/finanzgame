// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestOption _$QuestOptionFromJson(Map<String, dynamic> json) =>
    _QuestOption(id: json['id'] as String, label: json['label'] as String);

Map<String, dynamic> _$QuestOptionToJson(_QuestOption instance) =>
    <String, dynamic>{'id': instance.id, 'label': instance.label};

_QuestReward _$QuestRewardFromJson(Map<String, dynamic> json) => _QuestReward(
  cash: const MoneyConverter().fromJson(json['cash'] as Map<String, dynamic>),
  xp: (json['xp'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$QuestRewardToJson(_QuestReward instance) =>
    <String, dynamic>{
      'cash': const MoneyConverter().toJson(instance.cash),
      'xp': instance.xp,
    };

DialogStep _$DialogStepFromJson(Map<String, dynamic> json) => DialogStep(
  id: json['id'] as String,
  speaker: json['speaker'] as String,
  lines: (json['lines'] as List<dynamic>).map((e) => e as String).toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$DialogStepToJson(DialogStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'speaker': instance.speaker,
      'lines': instance.lines,
      'type': instance.$type,
    };

QuizStep _$QuizStepFromJson(Map<String, dynamic> json) => QuizStep(
  id: json['id'] as String,
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => QuestOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  correctId: json['correctId'] as String,
  explanation: json['explanation'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$QuizStepToJson(QuizStep instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'options': instance.options,
  'correctId': instance.correctId,
  'explanation': instance.explanation,
  'type': instance.$type,
};

ChoiceStep _$ChoiceStepFromJson(Map<String, dynamic> json) => ChoiceStep(
  id: json['id'] as String,
  prompt: json['prompt'] as String,
  options: (json['options'] as List<dynamic>)
      .map((e) => QuestOption.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ChoiceStepToJson(ChoiceStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prompt': instance.prompt,
      'options': instance.options,
      'type': instance.$type,
    };

_Quest _$QuestFromJson(Map<String, dynamic> json) => _Quest(
  id: json['id'] as String,
  title: json['title'] as String,
  location: json['location'] as String,
  reward: QuestReward.fromJson(json['reward'] as Map<String, dynamic>),
  prerequisites:
      (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => QuestStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuestStep>[],
  topic: json['topic'] as String? ?? '',
);

Map<String, dynamic> _$QuestToJson(_Quest instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'location': instance.location,
  'reward': instance.reward,
  'prerequisites': instance.prerequisites,
  'steps': instance.steps,
  'topic': instance.topic,
};
