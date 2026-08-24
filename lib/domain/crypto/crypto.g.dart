// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CryptoHolding _$CryptoHoldingFromJson(Map<String, dynamic> json) =>
    _CryptoHolding(
      assetId: json['assetId'] as String,
      shares: (json['shares'] as num).toInt(),
      averageBuyPrice: const MoneyConverter().fromJson(
        json['averageBuyPrice'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CryptoHoldingToJson(
  _CryptoHolding instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'shares': instance.shares,
  'averageBuyPrice': const MoneyConverter().toJson(instance.averageBuyPrice),
};

_CryptoQuote _$CryptoQuoteFromJson(Map<String, dynamic> json) => _CryptoQuote(
  assetId: json['assetId'] as String,
  pricePerShare: const MoneyConverter().fromJson(
    json['pricePerShare'] as Map<String, dynamic>,
  ),
  onDayIndex: (json['onDayIndex'] as num).toInt(),
);

Map<String, dynamic> _$CryptoQuoteToJson(_CryptoQuote instance) =>
    <String, dynamic>{
      'assetId': instance.assetId,
      'pricePerShare': const MoneyConverter().toJson(instance.pricePerShare),
      'onDayIndex': instance.onDayIndex,
    };
