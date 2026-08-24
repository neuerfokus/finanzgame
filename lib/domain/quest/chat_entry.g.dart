// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NpcEntry _$NpcEntryFromJson(Map<String, dynamic> json) => NpcEntry(
  speaker: json['speaker'] as String,
  text: json['text'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$NpcEntryToJson(NpcEntry instance) => <String, dynamic>{
  'speaker': instance.speaker,
  'text': instance.text,
  'type': instance.$type,
};

OwnEntry _$OwnEntryFromJson(Map<String, dynamic> json) =>
    OwnEntry(text: json['text'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$OwnEntryToJson(OwnEntry instance) => <String, dynamic>{
  'text': instance.text,
  'type': instance.$type,
};

SystemEntry _$SystemEntryFromJson(Map<String, dynamic> json) =>
    SystemEntry(text: json['text'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$SystemEntryToJson(SystemEntry instance) =>
    <String, dynamic>{'text': instance.text, 'type': instance.$type};
