import 'package:json_annotation/json_annotation.dart';

import 'money.dart';

/// [JsonConverter] for [Money] — serializes as `{ "cents": 1250 }`.
///
/// Use as an annotation on Freezed fields that hold [Money]:
/// ```dart
/// @MoneyConverter()
/// required Money amount,
/// ```
class MoneyConverter implements JsonConverter<Money, Map<String, dynamic>> {
  const MoneyConverter();

  @override
  Money fromJson(Map<String, dynamic> json) => Money.fromJson(json);

  @override
  Map<String, dynamic> toJson(Money money) => money.toJson();
}
