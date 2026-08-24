// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highscore_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HighscoreEntry _$HighscoreEntryFromJson(
  Map<String, dynamic> json,
) => _HighscoreEntry(
  playerName: json['playerName'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: DateTime.parse(json['endedAt'] as String),
  finalNetWorthCents: (json['finalNetWorthCents'] as num).toInt(),
  finalAgeYears: (json['finalAgeYears'] as num).toInt(),
  firstMillionaireAgeYears: (json['firstMillionaireAgeYears'] as num?)?.toInt(),
  firstMillionaireDayIndex: (json['firstMillionaireDayIndex'] as num?)?.toInt(),
  firstMillionaireNetWorthCents: (json['firstMillionaireNetWorthCents'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$HighscoreEntryToJson(_HighscoreEntry instance) =>
    <String, dynamic>{
      'playerName': instance.playerName,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'finalNetWorthCents': instance.finalNetWorthCents,
      'finalAgeYears': instance.finalAgeYears,
      'firstMillionaireAgeYears': instance.firstMillionaireAgeYears,
      'firstMillionaireDayIndex': instance.firstMillionaireDayIndex,
      'firstMillionaireNetWorthCents': instance.firstMillionaireNetWorthCents,
    };
