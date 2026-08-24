import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/economy/money.dart';
import '../../domain/economy/money_json_converter.dart';

part 'savings_plan.freezed.dart';
part 'savings_plan.g.dart';

/// spec-36: Sparplan-Eintrag (DCA-Plan). Pro Eintrag fester monatlicher
/// Betrag in ein Asset.
@freezed
abstract class SavingsPlan with _$SavingsPlan {
  const factory SavingsPlan({
    required String id,
    required String assetClass, // 'etf', 'stock', 'crypto'
    required String assetId,
    @MoneyConverter() required Money monthly,
    required int startedOnDayIndex,
  }) = _SavingsPlan;

  factory SavingsPlan.fromJson(Map<String, dynamic> json) =>
      _$SavingsPlanFromJson(json);
}
