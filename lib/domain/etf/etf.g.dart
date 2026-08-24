// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EtfHolding _$EtfHoldingFromJson(Map<String, dynamic> json) => _EtfHolding(
  etfId: json['etfId'] as String,
  shares: (json['shares'] as num).toInt(),
  averageBuyPrice: const MoneyConverter().fromJson(
    json['averageBuyPrice'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$EtfHoldingToJson(
  _EtfHolding instance,
) => <String, dynamic>{
  'etfId': instance.etfId,
  'shares': instance.shares,
  'averageBuyPrice': const MoneyConverter().toJson(instance.averageBuyPrice),
};

_EtfQuote _$EtfQuoteFromJson(Map<String, dynamic> json) => _EtfQuote(
  etfId: json['etfId'] as String,
  pricePerShare: const MoneyConverter().fromJson(
    json['pricePerShare'] as Map<String, dynamic>,
  ),
  onDayIndex: (json['onDayIndex'] as num).toInt(),
);

Map<String, dynamic> _$EtfQuoteToJson(_EtfQuote instance) => <String, dynamic>{
  'etfId': instance.etfId,
  'pricePerShare': const MoneyConverter().toJson(instance.pricePerShare),
  'onDayIndex': instance.onDayIndex,
};
