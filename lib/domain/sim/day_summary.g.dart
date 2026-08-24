// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DaySummary _$DaySummaryFromJson(Map<String, dynamic> json) => _DaySummary(
  day: const GameDayConverter().fromJson(json['day'] as Map<String, dynamic>),
  events: const _DayEventListConverter().fromJson(json['events'] as List),
  cashBefore: const MoneyConverter().fromJson(
    json['cashBefore'] as Map<String, dynamic>,
  ),
  cashAfter: const MoneyConverter().fromJson(
    json['cashAfter'] as Map<String, dynamic>,
  ),
  savingsBefore: const MoneyConverter().fromJson(
    json['savingsBefore'] as Map<String, dynamic>,
  ),
  savingsAfter: const MoneyConverter().fromJson(
    json['savingsAfter'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DaySummaryToJson(_DaySummary instance) =>
    <String, dynamic>{
      'day': const GameDayConverter().toJson(instance.day),
      'events': const _DayEventListConverter().toJson(instance.events),
      'cashBefore': const MoneyConverter().toJson(instance.cashBefore),
      'cashAfter': const MoneyConverter().toJson(instance.cashAfter),
      'savingsBefore': const MoneyConverter().toJson(instance.savingsBefore),
      'savingsAfter': const MoneyConverter().toJson(instance.savingsAfter),
    };
