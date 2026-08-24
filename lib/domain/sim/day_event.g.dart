// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllowanceEvent _$AllowanceEventFromJson(Map<String, dynamic> json) =>
    AllowanceEvent(
      amount: const MoneyConverter().fromJson(
        json['amount'] as Map<String, dynamic>,
      ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$AllowanceEventToJson(AllowanceEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'type': instance.$type,
    };

InterestEvent _$InterestEventFromJson(Map<String, dynamic> json) =>
    InterestEvent(
      amount: const MoneyConverter().fromJson(
        json['amount'] as Map<String, dynamic>,
      ),
      accountId: json['accountId'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InterestEventToJson(InterestEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'accountId': instance.accountId,
      'type': instance.$type,
    };

PlantGrowthEvent _$PlantGrowthEventFromJson(Map<String, dynamic> json) =>
    PlantGrowthEvent(
      plantId: json['plantId'] as String,
      newStage: (json['newStage'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PlantGrowthEventToJson(PlantGrowthEvent instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'newStage': instance.newStage,
      'type': instance.$type,
    };

PlantReadyEvent _$PlantReadyEventFromJson(Map<String, dynamic> json) =>
    PlantReadyEvent(
      plantId: json['plantId'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PlantReadyEventToJson(PlantReadyEvent instance) =>
    <String, dynamic>{'plantId': instance.plantId, 'type': instance.$type};

PlantWitherEvent _$PlantWitherEventFromJson(Map<String, dynamic> json) =>
    PlantWitherEvent(
      plantId: json['plantId'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$PlantWitherEventToJson(PlantWitherEvent instance) =>
    <String, dynamic>{'plantId': instance.plantId, 'type': instance.$type};

HarvestEvent _$HarvestEventFromJson(Map<String, dynamic> json) => HarvestEvent(
  plantId: json['plantId'] as String,
  harvestYield: const MoneyConverter().fromJson(
    json['harvestYield'] as Map<String, dynamic>,
  ),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$HarvestEventToJson(HarvestEvent instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'harvestYield': const MoneyConverter().toJson(instance.harvestYield),
      'type': instance.$type,
    };

InflationEvent _$InflationEventFromJson(Map<String, dynamic> json) =>
    InflationEvent(
      rate: (json['rate'] as num).toDouble(),
      affectedItemIds: (json['affectedItemIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InflationEventToJson(InflationEvent instance) =>
    <String, dynamic>{
      'rate': instance.rate,
      'affectedItemIds': instance.affectedItemIds,
      'type': instance.$type,
    };

WeatherEvent _$WeatherEventFromJson(Map<String, dynamic> json) => WeatherEvent(
  islandId: json['islandId'] as String,
  kind: $enumDecode(_$WeatherEnumMap, json['kind']),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$WeatherEventToJson(WeatherEvent instance) =>
    <String, dynamic>{
      'islandId': instance.islandId,
      'kind': _$WeatherEnumMap[instance.kind]!,
      'type': instance.$type,
    };

const _$WeatherEnumMap = {
  Weather.sunny: 'sunny',
  Weather.cloudy: 'cloudy',
  Weather.rain: 'rain',
  Weather.storm: 'storm',
};

EtfPriceUpdateEvent _$EtfPriceUpdateEventFromJson(Map<String, dynamic> json) =>
    EtfPriceUpdateEvent(
      etfId: json['etfId'] as String,
      newPrice: const MoneyConverter().fromJson(
        json['newPrice'] as Map<String, dynamic>,
      ),
      deltaPct: (json['deltaPct'] as num).toDouble(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$EtfPriceUpdateEventToJson(
  EtfPriceUpdateEvent instance,
) => <String, dynamic>{
  'etfId': instance.etfId,
  'newPrice': const MoneyConverter().toJson(instance.newPrice),
  'deltaPct': instance.deltaPct,
  'type': instance.$type,
};

StockPriceUpdateEvent _$StockPriceUpdateEventFromJson(
  Map<String, dynamic> json,
) => StockPriceUpdateEvent(
  stockId: json['stockId'] as String,
  newPrice: const MoneyConverter().fromJson(
    json['newPrice'] as Map<String, dynamic>,
  ),
  deltaPct: (json['deltaPct'] as num).toDouble(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$StockPriceUpdateEventToJson(
  StockPriceUpdateEvent instance,
) => <String, dynamic>{
  'stockId': instance.stockId,
  'newPrice': const MoneyConverter().toJson(instance.newPrice),
  'deltaPct': instance.deltaPct,
  'type': instance.$type,
};

CryptoPriceUpdateEvent _$CryptoPriceUpdateEventFromJson(
  Map<String, dynamic> json,
) => CryptoPriceUpdateEvent(
  assetId: json['assetId'] as String,
  newPrice: const MoneyConverter().fromJson(
    json['newPrice'] as Map<String, dynamic>,
  ),
  deltaPct: (json['deltaPct'] as num).toDouble(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CryptoPriceUpdateEventToJson(
  CryptoPriceUpdateEvent instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'newPrice': const MoneyConverter().toJson(instance.newPrice),
  'deltaPct': instance.deltaPct,
  'type': instance.$type,
};

MetalPriceUpdateEvent _$MetalPriceUpdateEventFromJson(
  Map<String, dynamic> json,
) => MetalPriceUpdateEvent(
  assetId: json['assetId'] as String,
  newPrice: const MoneyConverter().fromJson(
    json['newPrice'] as Map<String, dynamic>,
  ),
  deltaPct: (json['deltaPct'] as num).toDouble(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MetalPriceUpdateEventToJson(
  MetalPriceUpdateEvent instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'newPrice': const MoneyConverter().toJson(instance.newPrice),
  'deltaPct': instance.deltaPct,
  'type': instance.$type,
};

CrashEvent _$CrashEventFromJson(Map<String, dynamic> json) => CrashEvent(
  dropPct: (json['dropPct'] as num).toDouble(),
  affectedAssetIds: (json['affectedAssetIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$CrashEventToJson(CrashEvent instance) =>
    <String, dynamic>{
      'dropPct': instance.dropPct,
      'affectedAssetIds': instance.affectedAssetIds,
      'type': instance.$type,
    };

BirthdayEvent _$BirthdayEventFromJson(Map<String, dynamic> json) =>
    BirthdayEvent(
      giftAmount: const MoneyConverter().fromJson(
        json['giftAmount'] as Map<String, dynamic>,
      ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$BirthdayEventToJson(BirthdayEvent instance) =>
    <String, dynamic>{
      'giftAmount': const MoneyConverter().toJson(instance.giftAmount),
      'type': instance.$type,
    };

TemptationEvent _$TemptationEventFromJson(Map<String, dynamic> json) =>
    TemptationEvent(
      itemId: json['itemId'] as String,
      price: const MoneyConverter().fromJson(
        json['price'] as Map<String, dynamic>,
      ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$TemptationEventToJson(TemptationEvent instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'price': const MoneyConverter().toJson(instance.price),
      'type': instance.$type,
    };

SleepCostEvent _$SleepCostEventFromJson(Map<String, dynamic> json) =>
    SleepCostEvent(
      amount: const MoneyConverter().fromJson(
        json['amount'] as Map<String, dynamic>,
      ),
      hunger: json['hunger'] as bool,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$SleepCostEventToJson(SleepCostEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'hunger': instance.hunger,
      'type': instance.$type,
    };

LifetimeEndEvent _$LifetimeEndEventFromJson(Map<String, dynamic> json) =>
    LifetimeEndEvent($type: json['type'] as String?);

Map<String, dynamic> _$LifetimeEndEventToJson(LifetimeEndEvent instance) =>
    <String, dynamic>{'type': instance.$type};

RentIncomeEvent _$RentIncomeEventFromJson(Map<String, dynamic> json) =>
    RentIncomeEvent(
      amount: const MoneyConverter().fromJson(
        json['amount'] as Map<String, dynamic>,
      ),
      propertyId: json['propertyId'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$RentIncomeEventToJson(RentIncomeEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'propertyId': instance.propertyId,
      'type': instance.$type,
    };

SalaryEvent _$SalaryEventFromJson(Map<String, dynamic> json) => SalaryEvent(
  amount: const MoneyConverter().fromJson(
    json['amount'] as Map<String, dynamic>,
  ),
  jobLevel: json['jobLevel'] as String,
  grossAmount: json['grossAmount'] == null
      ? Money.zero
      : const MoneyConverter().fromJson(
          json['grossAmount'] as Map<String, dynamic>,
        ),
  taxAmount: json['taxAmount'] == null
      ? Money.zero
      : const MoneyConverter().fromJson(
          json['taxAmount'] as Map<String, dynamic>,
        ),
  socialAmount: json['socialAmount'] == null
      ? Money.zero
      : const MoneyConverter().fromJson(
          json['socialAmount'] as Map<String, dynamic>,
        ),
  soliAmount: json['soliAmount'] == null
      ? Money.zero
      : const MoneyConverter().fromJson(
          json['soliAmount'] as Map<String, dynamic>,
        ),
  kircheAmount: json['kircheAmount'] == null
      ? Money.zero
      : const MoneyConverter().fromJson(
          json['kircheAmount'] as Map<String, dynamic>,
        ),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$SalaryEventToJson(SalaryEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'jobLevel': instance.jobLevel,
      'grossAmount': const MoneyConverter().toJson(instance.grossAmount),
      'taxAmount': const MoneyConverter().toJson(instance.taxAmount),
      'socialAmount': const MoneyConverter().toJson(instance.socialAmount),
      'soliAmount': const MoneyConverter().toJson(instance.soliAmount),
      'kircheAmount': const MoneyConverter().toJson(instance.kircheAmount),
      'type': instance.$type,
    };

SavingsPlanExecutedEvent _$SavingsPlanExecutedEventFromJson(
  Map<String, dynamic> json,
) => SavingsPlanExecutedEvent(
  amount: const MoneyConverter().fromJson(
    json['amount'] as Map<String, dynamic>,
  ),
  targetAssetId: json['targetAssetId'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$SavingsPlanExecutedEventToJson(
  SavingsPlanExecutedEvent instance,
) => <String, dynamic>{
  'amount': const MoneyConverter().toJson(instance.amount),
  'targetAssetId': instance.targetAssetId,
  'type': instance.$type,
};

DebtInterestEvent _$DebtInterestEventFromJson(Map<String, dynamic> json) =>
    DebtInterestEvent(
      amount: const MoneyConverter().fromJson(
        json['amount'] as Map<String, dynamic>,
      ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$DebtInterestEventToJson(DebtInterestEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'type': instance.$type,
    };

InsuranceFeeEvent _$InsuranceFeeEventFromJson(Map<String, dynamic> json) =>
    InsuranceFeeEvent(
      amount: const MoneyConverter().fromJson(
        json['amount'] as Map<String, dynamic>,
      ),
      kind: json['kind'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$InsuranceFeeEventToJson(InsuranceFeeEvent instance) =>
    <String, dynamic>{
      'amount': const MoneyConverter().toJson(instance.amount),
      'kind': instance.kind,
      'type': instance.$type,
    };

LuckyEvent _$LuckyEventFromJson(Map<String, dynamic> json) => LuckyEvent(
  title: json['title'] as String,
  description: json['description'] as String,
  amount: const MoneyConverter().fromJson(
    json['amount'] as Map<String, dynamic>,
  ),
  taxDeducted: const MoneyConverter().fromJson(
    json['taxDeducted'] as Map<String, dynamic>,
  ),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$LuckyEventToJson(LuckyEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'amount': const MoneyConverter().toJson(instance.amount),
      'taxDeducted': const MoneyConverter().toJson(instance.taxDeducted),
      'type': instance.$type,
    };

CrashStartedEvent _$CrashStartedEventFromJson(Map<String, dynamic> json) =>
    CrashStartedEvent(
      assetClassId: json['assetClassId'] as String,
      depthPct: (json['depthPct'] as num).toDouble(),
      durationDays: (json['durationDays'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$CrashStartedEventToJson(CrashStartedEvent instance) =>
    <String, dynamic>{
      'assetClassId': instance.assetClassId,
      'depthPct': instance.depthPct,
      'durationDays': instance.durationDays,
      'type': instance.$type,
    };

RecoveryCompleteEvent _$RecoveryCompleteEventFromJson(
  Map<String, dynamic> json,
) => RecoveryCompleteEvent(
  assetClassId: json['assetClassId'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$RecoveryCompleteEventToJson(
  RecoveryCompleteEvent instance,
) => <String, dynamic>{
  'assetClassId': instance.assetClassId,
  'type': instance.$type,
};

MillionaireReachedEvent _$MillionaireReachedEventFromJson(
  Map<String, dynamic> json,
) => MillionaireReachedEvent(
  ageYears: (json['ageYears'] as num).toInt(),
  netWorth: const MoneyConverter().fromJson(
    json['netWorth'] as Map<String, dynamic>,
  ),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MillionaireReachedEventToJson(
  MillionaireReachedEvent instance,
) => <String, dynamic>{
  'ageYears': instance.ageYears,
  'netWorth': const MoneyConverter().toJson(instance.netWorth),
  'type': instance.$type,
};

LevelUpEvent _$LevelUpEventFromJson(Map<String, dynamic> json) => LevelUpEvent(
  newLevel: (json['newLevel'] as num).toInt(),
  title: json['title'] as String,
  titleChanged: json['titleChanged'] as bool,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$LevelUpEventToJson(LevelUpEvent instance) =>
    <String, dynamic>{
      'newLevel': instance.newLevel,
      'title': instance.title,
      'titleChanged': instance.titleChanged,
      'type': instance.$type,
    };

BankruptcyEvent _$BankruptcyEventFromJson(Map<String, dynamic> json) =>
    BankruptcyEvent(
      netWorth: const MoneyConverter().fromJson(
        json['netWorth'] as Map<String, dynamic>,
      ),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$BankruptcyEventToJson(BankruptcyEvent instance) =>
    <String, dynamic>{
      'netWorth': const MoneyConverter().toJson(instance.netWorth),
      'type': instance.$type,
    };

PanicSellRealizedEvent _$PanicSellRealizedEventFromJson(
  Map<String, dynamic> json,
) => PanicSellRealizedEvent(
  assetClassId: json['assetClassId'] as String,
  lossCents: (json['lossCents'] as num).toInt(),
  soldAtPct: (json['soldAtPct'] as num).toDouble(),
  currentPct: (json['currentPct'] as num).toDouble(),
  daysSinceSell: (json['daysSinceSell'] as num).toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$PanicSellRealizedEventToJson(
  PanicSellRealizedEvent instance,
) => <String, dynamic>{
  'assetClassId': instance.assetClassId,
  'lossCents': instance.lossCents,
  'soldAtPct': instance.soldAtPct,
  'currentPct': instance.currentPct,
  'daysSinceSell': instance.daysSinceSell,
  'type': instance.$type,
};

HeldThroughCrashEvent _$HeldThroughCrashEventFromJson(
  Map<String, dynamic> json,
) => HeldThroughCrashEvent(
  assetClassId: json['assetClassId'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$HeldThroughCrashEventToJson(
  HeldThroughCrashEvent instance,
) => <String, dynamic>{
  'assetClassId': instance.assetClassId,
  'type': instance.$type,
};

StockBankruptEvent _$StockBankruptEventFromJson(Map<String, dynamic> json) =>
    StockBankruptEvent(
      stockId: json['stockId'] as String,
      name: json['name'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$StockBankruptEventToJson(StockBankruptEvent instance) =>
    <String, dynamic>{
      'stockId': instance.stockId,
      'name': instance.name,
      'type': instance.$type,
    };

SeasonalEvent _$SeasonalEventFromJson(Map<String, dynamic> json) =>
    SeasonalEvent(
      title: json['title'] as String,
      message: json['message'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$SeasonalEventToJson(SeasonalEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'type': instance.$type,
    };
