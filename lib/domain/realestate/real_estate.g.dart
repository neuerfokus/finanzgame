// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_estate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RealEstateHolding _$RealEstateHoldingFromJson(Map<String, dynamic> json) =>
    _RealEstateHolding(
      specId: json['specId'] as String,
      ownedSinceDayIndex: (json['ownedSinceDayIndex'] as num).toInt(),
      purchasePrice: const MoneyConverter().fromJson(
        json['purchasePrice'] as Map<String, dynamic>,
      ),
      usage:
          $enumDecodeNullable(_$RealEstateUsageEnumMap, json['usage']) ??
          RealEstateUsage.rented,
    );

Map<String, dynamic> _$RealEstateHoldingToJson(_RealEstateHolding instance) =>
    <String, dynamic>{
      'specId': instance.specId,
      'ownedSinceDayIndex': instance.ownedSinceDayIndex,
      'purchasePrice': const MoneyConverter().toJson(instance.purchasePrice),
      'usage': _$RealEstateUsageEnumMap[instance.usage]!,
    };

const _$RealEstateUsageEnumMap = {
  RealEstateUsage.selfOccupied: 'selfOccupied',
  RealEstateUsage.rented: 'rented',
};
