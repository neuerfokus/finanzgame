// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleChoiceQuestion _$MultipleChoiceQuestionFromJson(
  Map<String, dynamic> json,
) => MultipleChoiceQuestion(
  text: json['text'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIndex: (json['correctIndex'] as num).toInt(),
  explanation: json['explanation'] as String,
  topic: json['topic'] as String? ?? '',
  tier: (json['tier'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MultipleChoiceQuestionToJson(
  MultipleChoiceQuestion instance,
) => <String, dynamic>{
  'text': instance.text,
  'options': instance.options,
  'correctIndex': instance.correctIndex,
  'explanation': instance.explanation,
  'topic': instance.topic,
  'tier': instance.tier,
};
