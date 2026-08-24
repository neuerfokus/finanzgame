// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockHolding _$StockHoldingFromJson(Map<String, dynamic> json) =>
    _StockHolding(
      stockId: json['stockId'] as String,
      shares: (json['shares'] as num).toInt(),
      averageBuyPrice: const MoneyConverter().fromJson(
        json['averageBuyPrice'] as Map<String, dynamic>,
      ),
      bankrupt: json['bankrupt'] as bool? ?? false,
    );

Map<String, dynamic> _$StockHoldingToJson(
  _StockHolding instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'shares': instance.shares,
  'averageBuyPrice': const MoneyConverter().toJson(instance.averageBuyPrice),
  'bankrupt': instance.bankrupt,
};

_StockQuote _$StockQuoteFromJson(Map<String, dynamic> json) => _StockQuote(
  stockId: json['stockId'] as String,
  pricePerShare: const MoneyConverter().fromJson(
    json['pricePerShare'] as Map<String, dynamic>,
  ),
  onDayIndex: (json['onDayIndex'] as num).toInt(),
);

Map<String, dynamic> _$StockQuoteToJson(_StockQuote instance) =>
    <String, dynamic>{
      'stockId': instance.stockId,
      'pricePerShare': const MoneyConverter().toJson(instance.pricePerShare),
      'onDayIndex': instance.onDayIndex,
    };
