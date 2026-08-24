// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsPlan _$SavingsPlanFromJson(Map<String, dynamic> json) => _SavingsPlan(
  id: json['id'] as String,
  assetClass: json['assetClass'] as String,
  assetId: json['assetId'] as String,
  monthly: const MoneyConverter().fromJson(
    json['monthly'] as Map<String, dynamic>,
  ),
  startedOnDayIndex: (json['startedOnDayIndex'] as num).toInt(),
);

Map<String, dynamic> _$SavingsPlanToJson(_SavingsPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetClass': instance.assetClass,
      'assetId': instance.assetId,
      'monthly': const MoneyConverter().toJson(instance.monthly),
      'startedOnDayIndex': instance.startedOnDayIndex,
    };
