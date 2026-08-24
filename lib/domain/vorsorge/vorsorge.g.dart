// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vorsorge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VorsorgeContract _$VorsorgeContractFromJson(Map<String, dynamic> json) =>
    _VorsorgeContract(
      type: $enumDecode(_$VorsorgeTypeEnumMap, json['type']),
      startedOnDayIndex: (json['startedOnDayIndex'] as num).toInt(),
      totalContributed: const MoneyConverter().fromJson(
        json['totalContributed'] as Map<String, dynamic>,
      ),
      totalSubsidy: const MoneyConverter().fromJson(
        json['totalSubsidy'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$VorsorgeContractToJson(
  _VorsorgeContract instance,
) => <String, dynamic>{
  'type': _$VorsorgeTypeEnumMap[instance.type]!,
  'startedOnDayIndex': instance.startedOnDayIndex,
  'totalContributed': const MoneyConverter().toJson(instance.totalContributed),
  'totalSubsidy': const MoneyConverter().toJson(instance.totalSubsidy),
};

const _$VorsorgeTypeEnumMap = {
  VorsorgeType.bausparer: 'bausparer',
  VorsorgeType.riester: 'riester',
  VorsorgeType.hausrat: 'hausrat',
  VorsorgeType.bu: 'bu',
  VorsorgeType.lebensvers: 'lebensvers',
};
