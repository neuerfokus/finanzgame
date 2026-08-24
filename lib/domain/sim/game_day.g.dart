// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameDay _$GameDayFromJson(Map<String, dynamic> json) => _GameDay(
  dayIndex: (json['dayIndex'] as num).toInt(),
  weekday: $enumDecode(_$WeekdayEnumMap, json['weekday']),
  weekIndex: (json['weekIndex'] as num).toInt(),
  monthIndex: (json['monthIndex'] as num).toInt(),
  yearIndex: (json['yearIndex'] as num).toInt(),
);

Map<String, dynamic> _$GameDayToJson(_GameDay instance) => <String, dynamic>{
  'dayIndex': instance.dayIndex,
  'weekday': _$WeekdayEnumMap[instance.weekday]!,
  'weekIndex': instance.weekIndex,
  'monthIndex': instance.monthIndex,
  'yearIndex': instance.yearIndex,
};

const _$WeekdayEnumMap = {
  Weekday.mon: 'mon',
  Weekday.tue: 'tue',
  Weekday.wed: 'wed',
  Weekday.thu: 'thu',
  Weekday.fri: 'fri',
  Weekday.sat: 'sat',
  Weekday.sun: 'sun',
};
