// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MetalHolding _$MetalHoldingFromJson(Map<String, dynamic> json) =>
    _MetalHolding(
      assetId: json['assetId'] as String,
      shares: (json['shares'] as num).toInt(),
      averageBuyPrice: const MoneyConverter().fromJson(
        json['averageBuyPrice'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MetalHoldingToJson(
  _MetalHolding instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'shares': instance.shares,
  'averageBuyPrice': const MoneyConverter().toJson(instance.averageBuyPrice),
};

_MetalQuote _$MetalQuoteFromJson(Map<String, dynamic> json) => _MetalQuote(
  assetId: json['assetId'] as String,
  pricePerShare: const MoneyConverter().fromJson(
    json['pricePerShare'] as Map<String, dynamic>,
  ),
  onDayIndex: (json['onDayIndex'] as num).toInt(),
);

Map<String, dynamic> _$MetalQuoteToJson(_MetalQuote instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'pricePerShare': const MoneyConverter().toJson(instance.pricePerShare),
      'onDayIndex': instance.onDayIndex,
    };
