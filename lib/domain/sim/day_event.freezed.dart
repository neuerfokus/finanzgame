// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
DayEvent _$DayEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'allowance':
          return AllowanceEvent.fromJson(
            json
          );
                case 'interest':
          return InterestEvent.fromJson(
            json
          );
                case 'plantGrowth':
          return PlantGrowthEvent.fromJson(
            json
          );
                case 'plantReady':
          return PlantReadyEvent.fromJson(
            json
          );
                case 'plantWither':
          return PlantWitherEvent.fromJson(
            json
          );
                case 'harvest':
          return HarvestEvent.fromJson(
            json
          );
                case 'inflation':
          return InflationEvent.fromJson(
            json
          );
                case 'weather':
          return WeatherEvent.fromJson(
            json
          );
                case 'etfPriceUpdate':
          return EtfPriceUpdateEvent.fromJson(
            json
          );
                case 'stockPriceUpdate':
          return StockPriceUpdateEvent.fromJson(
            json
          );
                case 'cryptoPriceUpdate':
          return CryptoPriceUpdateEvent.fromJson(
            json
          );
                case 'metalPriceUpdate':
          return MetalPriceUpdateEvent.fromJson(
            json
          );
                case 'crash':
          return CrashEvent.fromJson(
            json
          );
                case 'birthday':
          return BirthdayEvent.fromJson(
            json
          );
                case 'temptation':
          return TemptationEvent.fromJson(
            json
          );
                case 'sleepCost':
          return SleepCostEvent.fromJson(
            json
          );
                case 'lifetimeEnd':
          return LifetimeEndEvent.fromJson(
            json
          );
                case 'rentIncome':
          return RentIncomeEvent.fromJson(
            json
          );
                case 'salary':
          return SalaryEvent.fromJson(
            json
          );
                case 'savingsPlanExecuted':
          return SavingsPlanExecutedEvent.fromJson(
            json
          );
                case 'debtInterest':
          return DebtInterestEvent.fromJson(
            json
          );
                case 'insuranceFee':
          return InsuranceFeeEvent.fromJson(
            json
          );
                case 'luckyEvent':
          return LuckyEvent.fromJson(
            json
          );
                case 'crashStarted':
          return CrashStartedEvent.fromJson(
            json
          );
                case 'recoveryComplete':
          return RecoveryCompleteEvent.fromJson(
            json
          );
                case 'millionaireReached':
          return MillionaireReachedEvent.fromJson(
            json
          );
                case 'levelUp':
          return LevelUpEvent.fromJson(
            json
          );
                case 'bankruptcy':
          return BankruptcyEvent.fromJson(
            json
          );
                case 'panicSellRealized':
          return PanicSellRealizedEvent.fromJson(
            json
          );
                case 'heldThroughCrash':
          return HeldThroughCrashEvent.fromJson(
            json
          );
                case 'stockBankrupt':
          return StockBankruptEvent.fromJson(
            json
          );
                case 'seasonalEvent':
          return SeasonalEvent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'DayEvent',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$DayEvent {



  /// Serializes this DayEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DayEvent()';
}


}

/// @nodoc
class $DayEventCopyWith<$Res>  {
$DayEventCopyWith(DayEvent _, $Res Function(DayEvent) __);
}


/// Adds pattern-matching-related methods to [DayEvent].
extension DayEventPatterns on DayEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AllowanceEvent value)?  allowance,TResult Function( InterestEvent value)?  interest,TResult Function( PlantGrowthEvent value)?  plantGrowth,TResult Function( PlantReadyEvent value)?  plantReady,TResult Function( PlantWitherEvent value)?  plantWither,TResult Function( HarvestEvent value)?  harvest,TResult Function( InflationEvent value)?  inflation,TResult Function( WeatherEvent value)?  weather,TResult Function( EtfPriceUpdateEvent value)?  etfPriceUpdate,TResult Function( StockPriceUpdateEvent value)?  stockPriceUpdate,TResult Function( CryptoPriceUpdateEvent value)?  cryptoPriceUpdate,TResult Function( MetalPriceUpdateEvent value)?  metalPriceUpdate,TResult Function( CrashEvent value)?  crash,TResult Function( BirthdayEvent value)?  birthday,TResult Function( TemptationEvent value)?  temptation,TResult Function( SleepCostEvent value)?  sleepCost,TResult Function( LifetimeEndEvent value)?  lifetimeEnd,TResult Function( RentIncomeEvent value)?  rentIncome,TResult Function( SalaryEvent value)?  salary,TResult Function( SavingsPlanExecutedEvent value)?  savingsPlanExecuted,TResult Function( DebtInterestEvent value)?  debtInterest,TResult Function( InsuranceFeeEvent value)?  insuranceFee,TResult Function( LuckyEvent value)?  luckyEvent,TResult Function( CrashStartedEvent value)?  crashStarted,TResult Function( RecoveryCompleteEvent value)?  recoveryComplete,TResult Function( MillionaireReachedEvent value)?  millionaireReached,TResult Function( LevelUpEvent value)?  levelUp,TResult Function( BankruptcyEvent value)?  bankruptcy,TResult Function( PanicSellRealizedEvent value)?  panicSellRealized,TResult Function( HeldThroughCrashEvent value)?  heldThroughCrash,TResult Function( StockBankruptEvent value)?  stockBankrupt,TResult Function( SeasonalEvent value)?  seasonalEvent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AllowanceEvent() when allowance != null:
return allowance(_that);case InterestEvent() when interest != null:
return interest(_that);case PlantGrowthEvent() when plantGrowth != null:
return plantGrowth(_that);case PlantReadyEvent() when plantReady != null:
return plantReady(_that);case PlantWitherEvent() when plantWither != null:
return plantWither(_that);case HarvestEvent() when harvest != null:
return harvest(_that);case InflationEvent() when inflation != null:
return inflation(_that);case WeatherEvent() when weather != null:
return weather(_that);case EtfPriceUpdateEvent() when etfPriceUpdate != null:
return etfPriceUpdate(_that);case StockPriceUpdateEvent() when stockPriceUpdate != null:
return stockPriceUpdate(_that);case CryptoPriceUpdateEvent() when cryptoPriceUpdate != null:
return cryptoPriceUpdate(_that);case MetalPriceUpdateEvent() when metalPriceUpdate != null:
return metalPriceUpdate(_that);case CrashEvent() when crash != null:
return crash(_that);case BirthdayEvent() when birthday != null:
return birthday(_that);case TemptationEvent() when temptation != null:
return temptation(_that);case SleepCostEvent() when sleepCost != null:
return sleepCost(_that);case LifetimeEndEvent() when lifetimeEnd != null:
return lifetimeEnd(_that);case RentIncomeEvent() when rentIncome != null:
return rentIncome(_that);case SalaryEvent() when salary != null:
return salary(_that);case SavingsPlanExecutedEvent() when savingsPlanExecuted != null:
return savingsPlanExecuted(_that);case DebtInterestEvent() when debtInterest != null:
return debtInterest(_that);case InsuranceFeeEvent() when insuranceFee != null:
return insuranceFee(_that);case LuckyEvent() when luckyEvent != null:
return luckyEvent(_that);case CrashStartedEvent() when crashStarted != null:
return crashStarted(_that);case RecoveryCompleteEvent() when recoveryComplete != null:
return recoveryComplete(_that);case MillionaireReachedEvent() when millionaireReached != null:
return millionaireReached(_that);case LevelUpEvent() when levelUp != null:
return levelUp(_that);case BankruptcyEvent() when bankruptcy != null:
return bankruptcy(_that);case PanicSellRealizedEvent() when panicSellRealized != null:
return panicSellRealized(_that);case HeldThroughCrashEvent() when heldThroughCrash != null:
return heldThroughCrash(_that);case StockBankruptEvent() when stockBankrupt != null:
return stockBankrupt(_that);case SeasonalEvent() when seasonalEvent != null:
return seasonalEvent(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AllowanceEvent value)  allowance,required TResult Function( InterestEvent value)  interest,required TResult Function( PlantGrowthEvent value)  plantGrowth,required TResult Function( PlantReadyEvent value)  plantReady,required TResult Function( PlantWitherEvent value)  plantWither,required TResult Function( HarvestEvent value)  harvest,required TResult Function( InflationEvent value)  inflation,required TResult Function( WeatherEvent value)  weather,required TResult Function( EtfPriceUpdateEvent value)  etfPriceUpdate,required TResult Function( StockPriceUpdateEvent value)  stockPriceUpdate,required TResult Function( CryptoPriceUpdateEvent value)  cryptoPriceUpdate,required TResult Function( MetalPriceUpdateEvent value)  metalPriceUpdate,required TResult Function( CrashEvent value)  crash,required TResult Function( BirthdayEvent value)  birthday,required TResult Function( TemptationEvent value)  temptation,required TResult Function( SleepCostEvent value)  sleepCost,required TResult Function( LifetimeEndEvent value)  lifetimeEnd,required TResult Function( RentIncomeEvent value)  rentIncome,required TResult Function( SalaryEvent value)  salary,required TResult Function( SavingsPlanExecutedEvent value)  savingsPlanExecuted,required TResult Function( DebtInterestEvent value)  debtInterest,required TResult Function( InsuranceFeeEvent value)  insuranceFee,required TResult Function( LuckyEvent value)  luckyEvent,required TResult Function( CrashStartedEvent value)  crashStarted,required TResult Function( RecoveryCompleteEvent value)  recoveryComplete,required TResult Function( MillionaireReachedEvent value)  millionaireReached,required TResult Function( LevelUpEvent value)  levelUp,required TResult Function( BankruptcyEvent value)  bankruptcy,required TResult Function( PanicSellRealizedEvent value)  panicSellRealized,required TResult Function( HeldThroughCrashEvent value)  heldThroughCrash,required TResult Function( StockBankruptEvent value)  stockBankrupt,required TResult Function( SeasonalEvent value)  seasonalEvent,}){
final _that = this;
switch (_that) {
case AllowanceEvent():
return allowance(_that);case InterestEvent():
return interest(_that);case PlantGrowthEvent():
return plantGrowth(_that);case PlantReadyEvent():
return plantReady(_that);case PlantWitherEvent():
return plantWither(_that);case HarvestEvent():
return harvest(_that);case InflationEvent():
return inflation(_that);case WeatherEvent():
return weather(_that);case EtfPriceUpdateEvent():
return etfPriceUpdate(_that);case StockPriceUpdateEvent():
return stockPriceUpdate(_that);case CryptoPriceUpdateEvent():
return cryptoPriceUpdate(_that);case MetalPriceUpdateEvent():
return metalPriceUpdate(_that);case CrashEvent():
return crash(_that);case BirthdayEvent():
return birthday(_that);case TemptationEvent():
return temptation(_that);case SleepCostEvent():
return sleepCost(_that);case LifetimeEndEvent():
return lifetimeEnd(_that);case RentIncomeEvent():
return rentIncome(_that);case SalaryEvent():
return salary(_that);case SavingsPlanExecutedEvent():
return savingsPlanExecuted(_that);case DebtInterestEvent():
return debtInterest(_that);case InsuranceFeeEvent():
return insuranceFee(_that);case LuckyEvent():
return luckyEvent(_that);case CrashStartedEvent():
return crashStarted(_that);case RecoveryCompleteEvent():
return recoveryComplete(_that);case MillionaireReachedEvent():
return millionaireReached(_that);case LevelUpEvent():
return levelUp(_that);case BankruptcyEvent():
return bankruptcy(_that);case PanicSellRealizedEvent():
return panicSellRealized(_that);case HeldThroughCrashEvent():
return heldThroughCrash(_that);case StockBankruptEvent():
return stockBankrupt(_that);case SeasonalEvent():
return seasonalEvent(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AllowanceEvent value)?  allowance,TResult? Function( InterestEvent value)?  interest,TResult? Function( PlantGrowthEvent value)?  plantGrowth,TResult? Function( PlantReadyEvent value)?  plantReady,TResult? Function( PlantWitherEvent value)?  plantWither,TResult? Function( HarvestEvent value)?  harvest,TResult? Function( InflationEvent value)?  inflation,TResult? Function( WeatherEvent value)?  weather,TResult? Function( EtfPriceUpdateEvent value)?  etfPriceUpdate,TResult? Function( StockPriceUpdateEvent value)?  stockPriceUpdate,TResult? Function( CryptoPriceUpdateEvent value)?  cryptoPriceUpdate,TResult? Function( MetalPriceUpdateEvent value)?  metalPriceUpdate,TResult? Function( CrashEvent value)?  crash,TResult? Function( BirthdayEvent value)?  birthday,TResult? Function( TemptationEvent value)?  temptation,TResult? Function( SleepCostEvent value)?  sleepCost,TResult? Function( LifetimeEndEvent value)?  lifetimeEnd,TResult? Function( RentIncomeEvent value)?  rentIncome,TResult? Function( SalaryEvent value)?  salary,TResult? Function( SavingsPlanExecutedEvent value)?  savingsPlanExecuted,TResult? Function( DebtInterestEvent value)?  debtInterest,TResult? Function( InsuranceFeeEvent value)?  insuranceFee,TResult? Function( LuckyEvent value)?  luckyEvent,TResult? Function( CrashStartedEvent value)?  crashStarted,TResult? Function( RecoveryCompleteEvent value)?  recoveryComplete,TResult? Function( MillionaireReachedEvent value)?  millionaireReached,TResult? Function( LevelUpEvent value)?  levelUp,TResult? Function( BankruptcyEvent value)?  bankruptcy,TResult? Function( PanicSellRealizedEvent value)?  panicSellRealized,TResult? Function( HeldThroughCrashEvent value)?  heldThroughCrash,TResult? Function( StockBankruptEvent value)?  stockBankrupt,TResult? Function( SeasonalEvent value)?  seasonalEvent,}){
final _that = this;
switch (_that) {
case AllowanceEvent() when allowance != null:
return allowance(_that);case InterestEvent() when interest != null:
return interest(_that);case PlantGrowthEvent() when plantGrowth != null:
return plantGrowth(_that);case PlantReadyEvent() when plantReady != null:
return plantReady(_that);case PlantWitherEvent() when plantWither != null:
return plantWither(_that);case HarvestEvent() when harvest != null:
return harvest(_that);case InflationEvent() when inflation != null:
return inflation(_that);case WeatherEvent() when weather != null:
return weather(_that);case EtfPriceUpdateEvent() when etfPriceUpdate != null:
return etfPriceUpdate(_that);case StockPriceUpdateEvent() when stockPriceUpdate != null:
return stockPriceUpdate(_that);case CryptoPriceUpdateEvent() when cryptoPriceUpdate != null:
return cryptoPriceUpdate(_that);case MetalPriceUpdateEvent() when metalPriceUpdate != null:
return metalPriceUpdate(_that);case CrashEvent() when crash != null:
return crash(_that);case BirthdayEvent() when birthday != null:
return birthday(_that);case TemptationEvent() when temptation != null:
return temptation(_that);case SleepCostEvent() when sleepCost != null:
return sleepCost(_that);case LifetimeEndEvent() when lifetimeEnd != null:
return lifetimeEnd(_that);case RentIncomeEvent() when rentIncome != null:
return rentIncome(_that);case SalaryEvent() when salary != null:
return salary(_that);case SavingsPlanExecutedEvent() when savingsPlanExecuted != null:
return savingsPlanExecuted(_that);case DebtInterestEvent() when debtInterest != null:
return debtInterest(_that);case InsuranceFeeEvent() when insuranceFee != null:
return insuranceFee(_that);case LuckyEvent() when luckyEvent != null:
return luckyEvent(_that);case CrashStartedEvent() when crashStarted != null:
return crashStarted(_that);case RecoveryCompleteEvent() when recoveryComplete != null:
return recoveryComplete(_that);case MillionaireReachedEvent() when millionaireReached != null:
return millionaireReached(_that);case LevelUpEvent() when levelUp != null:
return levelUp(_that);case BankruptcyEvent() when bankruptcy != null:
return bankruptcy(_that);case PanicSellRealizedEvent() when panicSellRealized != null:
return panicSellRealized(_that);case HeldThroughCrashEvent() when heldThroughCrash != null:
return heldThroughCrash(_that);case StockBankruptEvent() when stockBankrupt != null:
return stockBankrupt(_that);case SeasonalEvent() when seasonalEvent != null:
return seasonalEvent(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@MoneyConverter()  Money amount)?  allowance,TResult Function(@MoneyConverter()  Money amount,  String accountId)?  interest,TResult Function( String plantId,  int newStage)?  plantGrowth,TResult Function( String plantId)?  plantReady,TResult Function( String plantId)?  plantWither,TResult Function( String plantId, @MoneyConverter()  Money harvestYield)?  harvest,TResult Function( double rate,  List<String> affectedItemIds)?  inflation,TResult Function( String islandId,  Weather kind)?  weather,TResult Function( String etfId, @MoneyConverter()  Money newPrice,  double deltaPct)?  etfPriceUpdate,TResult Function( String stockId, @MoneyConverter()  Money newPrice,  double deltaPct)?  stockPriceUpdate,TResult Function( String assetId, @MoneyConverter()  Money newPrice,  double deltaPct)?  cryptoPriceUpdate,TResult Function( String assetId, @MoneyConverter()  Money newPrice,  double deltaPct)?  metalPriceUpdate,TResult Function( double dropPct,  List<String> affectedAssetIds)?  crash,TResult Function(@MoneyConverter()  Money giftAmount)?  birthday,TResult Function( String itemId, @MoneyConverter()  Money price)?  temptation,TResult Function(@MoneyConverter()  Money amount,  bool hunger)?  sleepCost,TResult Function()?  lifetimeEnd,TResult Function(@MoneyConverter()  Money amount,  String propertyId)?  rentIncome,TResult Function(@MoneyConverter()  Money amount,  String jobLevel, @MoneyConverter()  Money grossAmount, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money socialAmount, @MoneyConverter()  Money soliAmount, @MoneyConverter()  Money kircheAmount)?  salary,TResult Function(@MoneyConverter()  Money amount,  String targetAssetId)?  savingsPlanExecuted,TResult Function(@MoneyConverter()  Money amount)?  debtInterest,TResult Function(@MoneyConverter()  Money amount,  String kind)?  insuranceFee,TResult Function( String title,  String description, @MoneyConverter()  Money amount, @MoneyConverter()  Money taxDeducted)?  luckyEvent,TResult Function( String assetClassId,  double depthPct,  int durationDays)?  crashStarted,TResult Function( String assetClassId)?  recoveryComplete,TResult Function( int ageYears, @MoneyConverter()  Money netWorth)?  millionaireReached,TResult Function( int newLevel,  String title,  bool titleChanged)?  levelUp,TResult Function(@MoneyConverter()  Money netWorth)?  bankruptcy,TResult Function( String assetClassId,  int lossCents,  double soldAtPct,  double currentPct,  int daysSinceSell)?  panicSellRealized,TResult Function( String assetClassId)?  heldThroughCrash,TResult Function( String stockId,  String name)?  stockBankrupt,TResult Function( String title,  String message)?  seasonalEvent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AllowanceEvent() when allowance != null:
return allowance(_that.amount);case InterestEvent() when interest != null:
return interest(_that.amount,_that.accountId);case PlantGrowthEvent() when plantGrowth != null:
return plantGrowth(_that.plantId,_that.newStage);case PlantReadyEvent() when plantReady != null:
return plantReady(_that.plantId);case PlantWitherEvent() when plantWither != null:
return plantWither(_that.plantId);case HarvestEvent() when harvest != null:
return harvest(_that.plantId,_that.harvestYield);case InflationEvent() when inflation != null:
return inflation(_that.rate,_that.affectedItemIds);case WeatherEvent() when weather != null:
return weather(_that.islandId,_that.kind);case EtfPriceUpdateEvent() when etfPriceUpdate != null:
return etfPriceUpdate(_that.etfId,_that.newPrice,_that.deltaPct);case StockPriceUpdateEvent() when stockPriceUpdate != null:
return stockPriceUpdate(_that.stockId,_that.newPrice,_that.deltaPct);case CryptoPriceUpdateEvent() when cryptoPriceUpdate != null:
return cryptoPriceUpdate(_that.assetId,_that.newPrice,_that.deltaPct);case MetalPriceUpdateEvent() when metalPriceUpdate != null:
return metalPriceUpdate(_that.assetId,_that.newPrice,_that.deltaPct);case CrashEvent() when crash != null:
return crash(_that.dropPct,_that.affectedAssetIds);case BirthdayEvent() when birthday != null:
return birthday(_that.giftAmount);case TemptationEvent() when temptation != null:
return temptation(_that.itemId,_that.price);case SleepCostEvent() when sleepCost != null:
return sleepCost(_that.amount,_that.hunger);case LifetimeEndEvent() when lifetimeEnd != null:
return lifetimeEnd();case RentIncomeEvent() when rentIncome != null:
return rentIncome(_that.amount,_that.propertyId);case SalaryEvent() when salary != null:
return salary(_that.amount,_that.jobLevel,_that.grossAmount,_that.taxAmount,_that.socialAmount,_that.soliAmount,_that.kircheAmount);case SavingsPlanExecutedEvent() when savingsPlanExecuted != null:
return savingsPlanExecuted(_that.amount,_that.targetAssetId);case DebtInterestEvent() when debtInterest != null:
return debtInterest(_that.amount);case InsuranceFeeEvent() when insuranceFee != null:
return insuranceFee(_that.amount,_that.kind);case LuckyEvent() when luckyEvent != null:
return luckyEvent(_that.title,_that.description,_that.amount,_that.taxDeducted);case CrashStartedEvent() when crashStarted != null:
return crashStarted(_that.assetClassId,_that.depthPct,_that.durationDays);case RecoveryCompleteEvent() when recoveryComplete != null:
return recoveryComplete(_that.assetClassId);case MillionaireReachedEvent() when millionaireReached != null:
return millionaireReached(_that.ageYears,_that.netWorth);case LevelUpEvent() when levelUp != null:
return levelUp(_that.newLevel,_that.title,_that.titleChanged);case BankruptcyEvent() when bankruptcy != null:
return bankruptcy(_that.netWorth);case PanicSellRealizedEvent() when panicSellRealized != null:
return panicSellRealized(_that.assetClassId,_that.lossCents,_that.soldAtPct,_that.currentPct,_that.daysSinceSell);case HeldThroughCrashEvent() when heldThroughCrash != null:
return heldThroughCrash(_that.assetClassId);case StockBankruptEvent() when stockBankrupt != null:
return stockBankrupt(_that.stockId,_that.name);case SeasonalEvent() when seasonalEvent != null:
return seasonalEvent(_that.title,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@MoneyConverter()  Money amount)  allowance,required TResult Function(@MoneyConverter()  Money amount,  String accountId)  interest,required TResult Function( String plantId,  int newStage)  plantGrowth,required TResult Function( String plantId)  plantReady,required TResult Function( String plantId)  plantWither,required TResult Function( String plantId, @MoneyConverter()  Money harvestYield)  harvest,required TResult Function( double rate,  List<String> affectedItemIds)  inflation,required TResult Function( String islandId,  Weather kind)  weather,required TResult Function( String etfId, @MoneyConverter()  Money newPrice,  double deltaPct)  etfPriceUpdate,required TResult Function( String stockId, @MoneyConverter()  Money newPrice,  double deltaPct)  stockPriceUpdate,required TResult Function( String assetId, @MoneyConverter()  Money newPrice,  double deltaPct)  cryptoPriceUpdate,required TResult Function( String assetId, @MoneyConverter()  Money newPrice,  double deltaPct)  metalPriceUpdate,required TResult Function( double dropPct,  List<String> affectedAssetIds)  crash,required TResult Function(@MoneyConverter()  Money giftAmount)  birthday,required TResult Function( String itemId, @MoneyConverter()  Money price)  temptation,required TResult Function(@MoneyConverter()  Money amount,  bool hunger)  sleepCost,required TResult Function()  lifetimeEnd,required TResult Function(@MoneyConverter()  Money amount,  String propertyId)  rentIncome,required TResult Function(@MoneyConverter()  Money amount,  String jobLevel, @MoneyConverter()  Money grossAmount, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money socialAmount, @MoneyConverter()  Money soliAmount, @MoneyConverter()  Money kircheAmount)  salary,required TResult Function(@MoneyConverter()  Money amount,  String targetAssetId)  savingsPlanExecuted,required TResult Function(@MoneyConverter()  Money amount)  debtInterest,required TResult Function(@MoneyConverter()  Money amount,  String kind)  insuranceFee,required TResult Function( String title,  String description, @MoneyConverter()  Money amount, @MoneyConverter()  Money taxDeducted)  luckyEvent,required TResult Function( String assetClassId,  double depthPct,  int durationDays)  crashStarted,required TResult Function( String assetClassId)  recoveryComplete,required TResult Function( int ageYears, @MoneyConverter()  Money netWorth)  millionaireReached,required TResult Function( int newLevel,  String title,  bool titleChanged)  levelUp,required TResult Function(@MoneyConverter()  Money netWorth)  bankruptcy,required TResult Function( String assetClassId,  int lossCents,  double soldAtPct,  double currentPct,  int daysSinceSell)  panicSellRealized,required TResult Function( String assetClassId)  heldThroughCrash,required TResult Function( String stockId,  String name)  stockBankrupt,required TResult Function( String title,  String message)  seasonalEvent,}) {final _that = this;
switch (_that) {
case AllowanceEvent():
return allowance(_that.amount);case InterestEvent():
return interest(_that.amount,_that.accountId);case PlantGrowthEvent():
return plantGrowth(_that.plantId,_that.newStage);case PlantReadyEvent():
return plantReady(_that.plantId);case PlantWitherEvent():
return plantWither(_that.plantId);case HarvestEvent():
return harvest(_that.plantId,_that.harvestYield);case InflationEvent():
return inflation(_that.rate,_that.affectedItemIds);case WeatherEvent():
return weather(_that.islandId,_that.kind);case EtfPriceUpdateEvent():
return etfPriceUpdate(_that.etfId,_that.newPrice,_that.deltaPct);case StockPriceUpdateEvent():
return stockPriceUpdate(_that.stockId,_that.newPrice,_that.deltaPct);case CryptoPriceUpdateEvent():
return cryptoPriceUpdate(_that.assetId,_that.newPrice,_that.deltaPct);case MetalPriceUpdateEvent():
return metalPriceUpdate(_that.assetId,_that.newPrice,_that.deltaPct);case CrashEvent():
return crash(_that.dropPct,_that.affectedAssetIds);case BirthdayEvent():
return birthday(_that.giftAmount);case TemptationEvent():
return temptation(_that.itemId,_that.price);case SleepCostEvent():
return sleepCost(_that.amount,_that.hunger);case LifetimeEndEvent():
return lifetimeEnd();case RentIncomeEvent():
return rentIncome(_that.amount,_that.propertyId);case SalaryEvent():
return salary(_that.amount,_that.jobLevel,_that.grossAmount,_that.taxAmount,_that.socialAmount,_that.soliAmount,_that.kircheAmount);case SavingsPlanExecutedEvent():
return savingsPlanExecuted(_that.amount,_that.targetAssetId);case DebtInterestEvent():
return debtInterest(_that.amount);case InsuranceFeeEvent():
return insuranceFee(_that.amount,_that.kind);case LuckyEvent():
return luckyEvent(_that.title,_that.description,_that.amount,_that.taxDeducted);case CrashStartedEvent():
return crashStarted(_that.assetClassId,_that.depthPct,_that.durationDays);case RecoveryCompleteEvent():
return recoveryComplete(_that.assetClassId);case MillionaireReachedEvent():
return millionaireReached(_that.ageYears,_that.netWorth);case LevelUpEvent():
return levelUp(_that.newLevel,_that.title,_that.titleChanged);case BankruptcyEvent():
return bankruptcy(_that.netWorth);case PanicSellRealizedEvent():
return panicSellRealized(_that.assetClassId,_that.lossCents,_that.soldAtPct,_that.currentPct,_that.daysSinceSell);case HeldThroughCrashEvent():
return heldThroughCrash(_that.assetClassId);case StockBankruptEvent():
return stockBankrupt(_that.stockId,_that.name);case SeasonalEvent():
return seasonalEvent(_that.title,_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@MoneyConverter()  Money amount)?  allowance,TResult? Function(@MoneyConverter()  Money amount,  String accountId)?  interest,TResult? Function( String plantId,  int newStage)?  plantGrowth,TResult? Function( String plantId)?  plantReady,TResult? Function( String plantId)?  plantWither,TResult? Function( String plantId, @MoneyConverter()  Money harvestYield)?  harvest,TResult? Function( double rate,  List<String> affectedItemIds)?  inflation,TResult? Function( String islandId,  Weather kind)?  weather,TResult? Function( String etfId, @MoneyConverter()  Money newPrice,  double deltaPct)?  etfPriceUpdate,TResult? Function( String stockId, @MoneyConverter()  Money newPrice,  double deltaPct)?  stockPriceUpdate,TResult? Function( String assetId, @MoneyConverter()  Money newPrice,  double deltaPct)?  cryptoPriceUpdate,TResult? Function( String assetId, @MoneyConverter()  Money newPrice,  double deltaPct)?  metalPriceUpdate,TResult? Function( double dropPct,  List<String> affectedAssetIds)?  crash,TResult? Function(@MoneyConverter()  Money giftAmount)?  birthday,TResult? Function( String itemId, @MoneyConverter()  Money price)?  temptation,TResult? Function(@MoneyConverter()  Money amount,  bool hunger)?  sleepCost,TResult? Function()?  lifetimeEnd,TResult? Function(@MoneyConverter()  Money amount,  String propertyId)?  rentIncome,TResult? Function(@MoneyConverter()  Money amount,  String jobLevel, @MoneyConverter()  Money grossAmount, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money socialAmount, @MoneyConverter()  Money soliAmount, @MoneyConverter()  Money kircheAmount)?  salary,TResult? Function(@MoneyConverter()  Money amount,  String targetAssetId)?  savingsPlanExecuted,TResult? Function(@MoneyConverter()  Money amount)?  debtInterest,TResult? Function(@MoneyConverter()  Money amount,  String kind)?  insuranceFee,TResult? Function( String title,  String description, @MoneyConverter()  Money amount, @MoneyConverter()  Money taxDeducted)?  luckyEvent,TResult? Function( String assetClassId,  double depthPct,  int durationDays)?  crashStarted,TResult? Function( String assetClassId)?  recoveryComplete,TResult? Function( int ageYears, @MoneyConverter()  Money netWorth)?  millionaireReached,TResult? Function( int newLevel,  String title,  bool titleChanged)?  levelUp,TResult? Function(@MoneyConverter()  Money netWorth)?  bankruptcy,TResult? Function( String assetClassId,  int lossCents,  double soldAtPct,  double currentPct,  int daysSinceSell)?  panicSellRealized,TResult? Function( String assetClassId)?  heldThroughCrash,TResult? Function( String stockId,  String name)?  stockBankrupt,TResult? Function( String title,  String message)?  seasonalEvent,}) {final _that = this;
switch (_that) {
case AllowanceEvent() when allowance != null:
return allowance(_that.amount);case InterestEvent() when interest != null:
return interest(_that.amount,_that.accountId);case PlantGrowthEvent() when plantGrowth != null:
return plantGrowth(_that.plantId,_that.newStage);case PlantReadyEvent() when plantReady != null:
return plantReady(_that.plantId);case PlantWitherEvent() when plantWither != null:
return plantWither(_that.plantId);case HarvestEvent() when harvest != null:
return harvest(_that.plantId,_that.harvestYield);case InflationEvent() when inflation != null:
return inflation(_that.rate,_that.affectedItemIds);case WeatherEvent() when weather != null:
return weather(_that.islandId,_that.kind);case EtfPriceUpdateEvent() when etfPriceUpdate != null:
return etfPriceUpdate(_that.etfId,_that.newPrice,_that.deltaPct);case StockPriceUpdateEvent() when stockPriceUpdate != null:
return stockPriceUpdate(_that.stockId,_that.newPrice,_that.deltaPct);case CryptoPriceUpdateEvent() when cryptoPriceUpdate != null:
return cryptoPriceUpdate(_that.assetId,_that.newPrice,_that.deltaPct);case MetalPriceUpdateEvent() when metalPriceUpdate != null:
return metalPriceUpdate(_that.assetId,_that.newPrice,_that.deltaPct);case CrashEvent() when crash != null:
return crash(_that.dropPct,_that.affectedAssetIds);case BirthdayEvent() when birthday != null:
return birthday(_that.giftAmount);case TemptationEvent() when temptation != null:
return temptation(_that.itemId,_that.price);case SleepCostEvent() when sleepCost != null:
return sleepCost(_that.amount,_that.hunger);case LifetimeEndEvent() when lifetimeEnd != null:
return lifetimeEnd();case RentIncomeEvent() when rentIncome != null:
return rentIncome(_that.amount,_that.propertyId);case SalaryEvent() when salary != null:
return salary(_that.amount,_that.jobLevel,_that.grossAmount,_that.taxAmount,_that.socialAmount,_that.soliAmount,_that.kircheAmount);case SavingsPlanExecutedEvent() when savingsPlanExecuted != null:
return savingsPlanExecuted(_that.amount,_that.targetAssetId);case DebtInterestEvent() when debtInterest != null:
return debtInterest(_that.amount);case InsuranceFeeEvent() when insuranceFee != null:
return insuranceFee(_that.amount,_that.kind);case LuckyEvent() when luckyEvent != null:
return luckyEvent(_that.title,_that.description,_that.amount,_that.taxDeducted);case CrashStartedEvent() when crashStarted != null:
return crashStarted(_that.assetClassId,_that.depthPct,_that.durationDays);case RecoveryCompleteEvent() when recoveryComplete != null:
return recoveryComplete(_that.assetClassId);case MillionaireReachedEvent() when millionaireReached != null:
return millionaireReached(_that.ageYears,_that.netWorth);case LevelUpEvent() when levelUp != null:
return levelUp(_that.newLevel,_that.title,_that.titleChanged);case BankruptcyEvent() when bankruptcy != null:
return bankruptcy(_that.netWorth);case PanicSellRealizedEvent() when panicSellRealized != null:
return panicSellRealized(_that.assetClassId,_that.lossCents,_that.soldAtPct,_that.currentPct,_that.daysSinceSell);case HeldThroughCrashEvent() when heldThroughCrash != null:
return heldThroughCrash(_that.assetClassId);case StockBankruptEvent() when stockBankrupt != null:
return stockBankrupt(_that.stockId,_that.name);case SeasonalEvent() when seasonalEvent != null:
return seasonalEvent(_that.title,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class AllowanceEvent implements DayEvent {
  const AllowanceEvent({@MoneyConverter() required this.amount, final  String? $type}): $type = $type ?? 'allowance';
  factory AllowanceEvent.fromJson(Map<String, dynamic> json) => _$AllowanceEventFromJson(json);

@MoneyConverter() final  Money amount;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AllowanceEventCopyWith<AllowanceEvent> get copyWith => _$AllowanceEventCopyWithImpl<AllowanceEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AllowanceEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AllowanceEvent&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'DayEvent.allowance(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $AllowanceEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $AllowanceEventCopyWith(AllowanceEvent value, $Res Function(AllowanceEvent) _then) = _$AllowanceEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount
});




}
/// @nodoc
class _$AllowanceEventCopyWithImpl<$Res>
    implements $AllowanceEventCopyWith<$Res> {
  _$AllowanceEventCopyWithImpl(this._self, this._then);

  final AllowanceEvent _self;
  final $Res Function(AllowanceEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(AllowanceEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InterestEvent implements DayEvent {
  const InterestEvent({@MoneyConverter() required this.amount, required this.accountId, final  String? $type}): $type = $type ?? 'interest';
  factory InterestEvent.fromJson(Map<String, dynamic> json) => _$InterestEventFromJson(json);

@MoneyConverter() final  Money amount;
 final  String accountId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterestEventCopyWith<InterestEvent> get copyWith => _$InterestEventCopyWithImpl<InterestEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterestEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterestEvent&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.accountId, accountId) || other.accountId == accountId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,accountId);

@override
String toString() {
  return 'DayEvent.interest(amount: $amount, accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $InterestEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $InterestEventCopyWith(InterestEvent value, $Res Function(InterestEvent) _then) = _$InterestEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount, String accountId
});




}
/// @nodoc
class _$InterestEventCopyWithImpl<$Res>
    implements $InterestEventCopyWith<$Res> {
  _$InterestEventCopyWithImpl(this._self, this._then);

  final InterestEvent _self;
  final $Res Function(InterestEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? accountId = null,}) {
  return _then(InterestEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlantGrowthEvent implements DayEvent {
  const PlantGrowthEvent({required this.plantId, required this.newStage, final  String? $type}): $type = $type ?? 'plantGrowth';
  factory PlantGrowthEvent.fromJson(Map<String, dynamic> json) => _$PlantGrowthEventFromJson(json);

 final  String plantId;
 final  int newStage;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantGrowthEventCopyWith<PlantGrowthEvent> get copyWith => _$PlantGrowthEventCopyWithImpl<PlantGrowthEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlantGrowthEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantGrowthEvent&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.newStage, newStage) || other.newStage == newStage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plantId,newStage);

@override
String toString() {
  return 'DayEvent.plantGrowth(plantId: $plantId, newStage: $newStage)';
}


}

/// @nodoc
abstract mixin class $PlantGrowthEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $PlantGrowthEventCopyWith(PlantGrowthEvent value, $Res Function(PlantGrowthEvent) _then) = _$PlantGrowthEventCopyWithImpl;
@useResult
$Res call({
 String plantId, int newStage
});




}
/// @nodoc
class _$PlantGrowthEventCopyWithImpl<$Res>
    implements $PlantGrowthEventCopyWith<$Res> {
  _$PlantGrowthEventCopyWithImpl(this._self, this._then);

  final PlantGrowthEvent _self;
  final $Res Function(PlantGrowthEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plantId = null,Object? newStage = null,}) {
  return _then(PlantGrowthEvent(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as String,newStage: null == newStage ? _self.newStage : newStage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlantReadyEvent implements DayEvent {
  const PlantReadyEvent({required this.plantId, final  String? $type}): $type = $type ?? 'plantReady';
  factory PlantReadyEvent.fromJson(Map<String, dynamic> json) => _$PlantReadyEventFromJson(json);

 final  String plantId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantReadyEventCopyWith<PlantReadyEvent> get copyWith => _$PlantReadyEventCopyWithImpl<PlantReadyEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlantReadyEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantReadyEvent&&(identical(other.plantId, plantId) || other.plantId == plantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plantId);

@override
String toString() {
  return 'DayEvent.plantReady(plantId: $plantId)';
}


}

/// @nodoc
abstract mixin class $PlantReadyEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $PlantReadyEventCopyWith(PlantReadyEvent value, $Res Function(PlantReadyEvent) _then) = _$PlantReadyEventCopyWithImpl;
@useResult
$Res call({
 String plantId
});




}
/// @nodoc
class _$PlantReadyEventCopyWithImpl<$Res>
    implements $PlantReadyEventCopyWith<$Res> {
  _$PlantReadyEventCopyWithImpl(this._self, this._then);

  final PlantReadyEvent _self;
  final $Res Function(PlantReadyEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plantId = null,}) {
  return _then(PlantReadyEvent(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlantWitherEvent implements DayEvent {
  const PlantWitherEvent({required this.plantId, final  String? $type}): $type = $type ?? 'plantWither';
  factory PlantWitherEvent.fromJson(Map<String, dynamic> json) => _$PlantWitherEventFromJson(json);

 final  String plantId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantWitherEventCopyWith<PlantWitherEvent> get copyWith => _$PlantWitherEventCopyWithImpl<PlantWitherEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlantWitherEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantWitherEvent&&(identical(other.plantId, plantId) || other.plantId == plantId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plantId);

@override
String toString() {
  return 'DayEvent.plantWither(plantId: $plantId)';
}


}

/// @nodoc
abstract mixin class $PlantWitherEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $PlantWitherEventCopyWith(PlantWitherEvent value, $Res Function(PlantWitherEvent) _then) = _$PlantWitherEventCopyWithImpl;
@useResult
$Res call({
 String plantId
});




}
/// @nodoc
class _$PlantWitherEventCopyWithImpl<$Res>
    implements $PlantWitherEventCopyWith<$Res> {
  _$PlantWitherEventCopyWithImpl(this._self, this._then);

  final PlantWitherEvent _self;
  final $Res Function(PlantWitherEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plantId = null,}) {
  return _then(PlantWitherEvent(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class HarvestEvent implements DayEvent {
  const HarvestEvent({required this.plantId, @MoneyConverter() required this.harvestYield, final  String? $type}): $type = $type ?? 'harvest';
  factory HarvestEvent.fromJson(Map<String, dynamic> json) => _$HarvestEventFromJson(json);

 final  String plantId;
@MoneyConverter() final  Money harvestYield;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestEventCopyWith<HarvestEvent> get copyWith => _$HarvestEventCopyWithImpl<HarvestEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestEvent&&(identical(other.plantId, plantId) || other.plantId == plantId)&&(identical(other.harvestYield, harvestYield) || other.harvestYield == harvestYield));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plantId,harvestYield);

@override
String toString() {
  return 'DayEvent.harvest(plantId: $plantId, harvestYield: $harvestYield)';
}


}

/// @nodoc
abstract mixin class $HarvestEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $HarvestEventCopyWith(HarvestEvent value, $Res Function(HarvestEvent) _then) = _$HarvestEventCopyWithImpl;
@useResult
$Res call({
 String plantId,@MoneyConverter() Money harvestYield
});




}
/// @nodoc
class _$HarvestEventCopyWithImpl<$Res>
    implements $HarvestEventCopyWith<$Res> {
  _$HarvestEventCopyWithImpl(this._self, this._then);

  final HarvestEvent _self;
  final $Res Function(HarvestEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? plantId = null,Object? harvestYield = null,}) {
  return _then(HarvestEvent(
plantId: null == plantId ? _self.plantId : plantId // ignore: cast_nullable_to_non_nullable
as String,harvestYield: null == harvestYield ? _self.harvestYield : harvestYield // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InflationEvent implements DayEvent {
  const InflationEvent({required this.rate, required final  List<String> affectedItemIds, final  String? $type}): _affectedItemIds = affectedItemIds,$type = $type ?? 'inflation';
  factory InflationEvent.fromJson(Map<String, dynamic> json) => _$InflationEventFromJson(json);

 final  double rate;
 final  List<String> _affectedItemIds;
 List<String> get affectedItemIds {
  if (_affectedItemIds is EqualUnmodifiableListView) return _affectedItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_affectedItemIds);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InflationEventCopyWith<InflationEvent> get copyWith => _$InflationEventCopyWithImpl<InflationEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InflationEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InflationEvent&&(identical(other.rate, rate) || other.rate == rate)&&const DeepCollectionEquality().equals(other._affectedItemIds, _affectedItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rate,const DeepCollectionEquality().hash(_affectedItemIds));

@override
String toString() {
  return 'DayEvent.inflation(rate: $rate, affectedItemIds: $affectedItemIds)';
}


}

/// @nodoc
abstract mixin class $InflationEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $InflationEventCopyWith(InflationEvent value, $Res Function(InflationEvent) _then) = _$InflationEventCopyWithImpl;
@useResult
$Res call({
 double rate, List<String> affectedItemIds
});




}
/// @nodoc
class _$InflationEventCopyWithImpl<$Res>
    implements $InflationEventCopyWith<$Res> {
  _$InflationEventCopyWithImpl(this._self, this._then);

  final InflationEvent _self;
  final $Res Function(InflationEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rate = null,Object? affectedItemIds = null,}) {
  return _then(InflationEvent(
rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,affectedItemIds: null == affectedItemIds ? _self._affectedItemIds : affectedItemIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class WeatherEvent implements DayEvent {
  const WeatherEvent({required this.islandId, required this.kind, final  String? $type}): $type = $type ?? 'weather';
  factory WeatherEvent.fromJson(Map<String, dynamic> json) => _$WeatherEventFromJson(json);

 final  String islandId;
 final  Weather kind;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherEventCopyWith<WeatherEvent> get copyWith => _$WeatherEventCopyWithImpl<WeatherEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherEvent&&(identical(other.islandId, islandId) || other.islandId == islandId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,islandId,kind);

@override
String toString() {
  return 'DayEvent.weather(islandId: $islandId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $WeatherEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $WeatherEventCopyWith(WeatherEvent value, $Res Function(WeatherEvent) _then) = _$WeatherEventCopyWithImpl;
@useResult
$Res call({
 String islandId, Weather kind
});




}
/// @nodoc
class _$WeatherEventCopyWithImpl<$Res>
    implements $WeatherEventCopyWith<$Res> {
  _$WeatherEventCopyWithImpl(this._self, this._then);

  final WeatherEvent _self;
  final $Res Function(WeatherEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? islandId = null,Object? kind = null,}) {
  return _then(WeatherEvent(
islandId: null == islandId ? _self.islandId : islandId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as Weather,
  ));
}


}

/// @nodoc
@JsonSerializable()

class EtfPriceUpdateEvent implements DayEvent {
  const EtfPriceUpdateEvent({required this.etfId, @MoneyConverter() required this.newPrice, required this.deltaPct, final  String? $type}): $type = $type ?? 'etfPriceUpdate';
  factory EtfPriceUpdateEvent.fromJson(Map<String, dynamic> json) => _$EtfPriceUpdateEventFromJson(json);

 final  String etfId;
@MoneyConverter() final  Money newPrice;
 final  double deltaPct;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtfPriceUpdateEventCopyWith<EtfPriceUpdateEvent> get copyWith => _$EtfPriceUpdateEventCopyWithImpl<EtfPriceUpdateEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtfPriceUpdateEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtfPriceUpdateEvent&&(identical(other.etfId, etfId) || other.etfId == etfId)&&(identical(other.newPrice, newPrice) || other.newPrice == newPrice)&&(identical(other.deltaPct, deltaPct) || other.deltaPct == deltaPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etfId,newPrice,deltaPct);

@override
String toString() {
  return 'DayEvent.etfPriceUpdate(etfId: $etfId, newPrice: $newPrice, deltaPct: $deltaPct)';
}


}

/// @nodoc
abstract mixin class $EtfPriceUpdateEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $EtfPriceUpdateEventCopyWith(EtfPriceUpdateEvent value, $Res Function(EtfPriceUpdateEvent) _then) = _$EtfPriceUpdateEventCopyWithImpl;
@useResult
$Res call({
 String etfId,@MoneyConverter() Money newPrice, double deltaPct
});




}
/// @nodoc
class _$EtfPriceUpdateEventCopyWithImpl<$Res>
    implements $EtfPriceUpdateEventCopyWith<$Res> {
  _$EtfPriceUpdateEventCopyWithImpl(this._self, this._then);

  final EtfPriceUpdateEvent _self;
  final $Res Function(EtfPriceUpdateEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? etfId = null,Object? newPrice = null,Object? deltaPct = null,}) {
  return _then(EtfPriceUpdateEvent(
etfId: null == etfId ? _self.etfId : etfId // ignore: cast_nullable_to_non_nullable
as String,newPrice: null == newPrice ? _self.newPrice : newPrice // ignore: cast_nullable_to_non_nullable
as Money,deltaPct: null == deltaPct ? _self.deltaPct : deltaPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StockPriceUpdateEvent implements DayEvent {
  const StockPriceUpdateEvent({required this.stockId, @MoneyConverter() required this.newPrice, required this.deltaPct, final  String? $type}): $type = $type ?? 'stockPriceUpdate';
  factory StockPriceUpdateEvent.fromJson(Map<String, dynamic> json) => _$StockPriceUpdateEventFromJson(json);

 final  String stockId;
@MoneyConverter() final  Money newPrice;
 final  double deltaPct;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockPriceUpdateEventCopyWith<StockPriceUpdateEvent> get copyWith => _$StockPriceUpdateEventCopyWithImpl<StockPriceUpdateEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockPriceUpdateEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockPriceUpdateEvent&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.newPrice, newPrice) || other.newPrice == newPrice)&&(identical(other.deltaPct, deltaPct) || other.deltaPct == deltaPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stockId,newPrice,deltaPct);

@override
String toString() {
  return 'DayEvent.stockPriceUpdate(stockId: $stockId, newPrice: $newPrice, deltaPct: $deltaPct)';
}


}

/// @nodoc
abstract mixin class $StockPriceUpdateEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $StockPriceUpdateEventCopyWith(StockPriceUpdateEvent value, $Res Function(StockPriceUpdateEvent) _then) = _$StockPriceUpdateEventCopyWithImpl;
@useResult
$Res call({
 String stockId,@MoneyConverter() Money newPrice, double deltaPct
});




}
/// @nodoc
class _$StockPriceUpdateEventCopyWithImpl<$Res>
    implements $StockPriceUpdateEventCopyWith<$Res> {
  _$StockPriceUpdateEventCopyWithImpl(this._self, this._then);

  final StockPriceUpdateEvent _self;
  final $Res Function(StockPriceUpdateEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stockId = null,Object? newPrice = null,Object? deltaPct = null,}) {
  return _then(StockPriceUpdateEvent(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,newPrice: null == newPrice ? _self.newPrice : newPrice // ignore: cast_nullable_to_non_nullable
as Money,deltaPct: null == deltaPct ? _self.deltaPct : deltaPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CryptoPriceUpdateEvent implements DayEvent {
  const CryptoPriceUpdateEvent({required this.assetId, @MoneyConverter() required this.newPrice, required this.deltaPct, final  String? $type}): $type = $type ?? 'cryptoPriceUpdate';
  factory CryptoPriceUpdateEvent.fromJson(Map<String, dynamic> json) => _$CryptoPriceUpdateEventFromJson(json);

 final  String assetId;
@MoneyConverter() final  Money newPrice;
 final  double deltaPct;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoPriceUpdateEventCopyWith<CryptoPriceUpdateEvent> get copyWith => _$CryptoPriceUpdateEventCopyWithImpl<CryptoPriceUpdateEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CryptoPriceUpdateEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoPriceUpdateEvent&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.newPrice, newPrice) || other.newPrice == newPrice)&&(identical(other.deltaPct, deltaPct) || other.deltaPct == deltaPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,newPrice,deltaPct);

@override
String toString() {
  return 'DayEvent.cryptoPriceUpdate(assetId: $assetId, newPrice: $newPrice, deltaPct: $deltaPct)';
}


}

/// @nodoc
abstract mixin class $CryptoPriceUpdateEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $CryptoPriceUpdateEventCopyWith(CryptoPriceUpdateEvent value, $Res Function(CryptoPriceUpdateEvent) _then) = _$CryptoPriceUpdateEventCopyWithImpl;
@useResult
$Res call({
 String assetId,@MoneyConverter() Money newPrice, double deltaPct
});




}
/// @nodoc
class _$CryptoPriceUpdateEventCopyWithImpl<$Res>
    implements $CryptoPriceUpdateEventCopyWith<$Res> {
  _$CryptoPriceUpdateEventCopyWithImpl(this._self, this._then);

  final CryptoPriceUpdateEvent _self;
  final $Res Function(CryptoPriceUpdateEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? newPrice = null,Object? deltaPct = null,}) {
  return _then(CryptoPriceUpdateEvent(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,newPrice: null == newPrice ? _self.newPrice : newPrice // ignore: cast_nullable_to_non_nullable
as Money,deltaPct: null == deltaPct ? _self.deltaPct : deltaPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MetalPriceUpdateEvent implements DayEvent {
  const MetalPriceUpdateEvent({required this.assetId, @MoneyConverter() required this.newPrice, required this.deltaPct, final  String? $type}): $type = $type ?? 'metalPriceUpdate';
  factory MetalPriceUpdateEvent.fromJson(Map<String, dynamic> json) => _$MetalPriceUpdateEventFromJson(json);

 final  String assetId;
@MoneyConverter() final  Money newPrice;
 final  double deltaPct;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetalPriceUpdateEventCopyWith<MetalPriceUpdateEvent> get copyWith => _$MetalPriceUpdateEventCopyWithImpl<MetalPriceUpdateEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetalPriceUpdateEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetalPriceUpdateEvent&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.newPrice, newPrice) || other.newPrice == newPrice)&&(identical(other.deltaPct, deltaPct) || other.deltaPct == deltaPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,newPrice,deltaPct);

@override
String toString() {
  return 'DayEvent.metalPriceUpdate(assetId: $assetId, newPrice: $newPrice, deltaPct: $deltaPct)';
}


}

/// @nodoc
abstract mixin class $MetalPriceUpdateEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $MetalPriceUpdateEventCopyWith(MetalPriceUpdateEvent value, $Res Function(MetalPriceUpdateEvent) _then) = _$MetalPriceUpdateEventCopyWithImpl;
@useResult
$Res call({
 String assetId,@MoneyConverter() Money newPrice, double deltaPct
});




}
/// @nodoc
class _$MetalPriceUpdateEventCopyWithImpl<$Res>
    implements $MetalPriceUpdateEventCopyWith<$Res> {
  _$MetalPriceUpdateEventCopyWithImpl(this._self, this._then);

  final MetalPriceUpdateEvent _self;
  final $Res Function(MetalPriceUpdateEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? newPrice = null,Object? deltaPct = null,}) {
  return _then(MetalPriceUpdateEvent(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,newPrice: null == newPrice ? _self.newPrice : newPrice // ignore: cast_nullable_to_non_nullable
as Money,deltaPct: null == deltaPct ? _self.deltaPct : deltaPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CrashEvent implements DayEvent {
  const CrashEvent({required this.dropPct, required final  List<String> affectedAssetIds, final  String? $type}): _affectedAssetIds = affectedAssetIds,$type = $type ?? 'crash';
  factory CrashEvent.fromJson(Map<String, dynamic> json) => _$CrashEventFromJson(json);

 final  double dropPct;
 final  List<String> _affectedAssetIds;
 List<String> get affectedAssetIds {
  if (_affectedAssetIds is EqualUnmodifiableListView) return _affectedAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_affectedAssetIds);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrashEventCopyWith<CrashEvent> get copyWith => _$CrashEventCopyWithImpl<CrashEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrashEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrashEvent&&(identical(other.dropPct, dropPct) || other.dropPct == dropPct)&&const DeepCollectionEquality().equals(other._affectedAssetIds, _affectedAssetIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dropPct,const DeepCollectionEquality().hash(_affectedAssetIds));

@override
String toString() {
  return 'DayEvent.crash(dropPct: $dropPct, affectedAssetIds: $affectedAssetIds)';
}


}

/// @nodoc
abstract mixin class $CrashEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $CrashEventCopyWith(CrashEvent value, $Res Function(CrashEvent) _then) = _$CrashEventCopyWithImpl;
@useResult
$Res call({
 double dropPct, List<String> affectedAssetIds
});




}
/// @nodoc
class _$CrashEventCopyWithImpl<$Res>
    implements $CrashEventCopyWith<$Res> {
  _$CrashEventCopyWithImpl(this._self, this._then);

  final CrashEvent _self;
  final $Res Function(CrashEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dropPct = null,Object? affectedAssetIds = null,}) {
  return _then(CrashEvent(
dropPct: null == dropPct ? _self.dropPct : dropPct // ignore: cast_nullable_to_non_nullable
as double,affectedAssetIds: null == affectedAssetIds ? _self._affectedAssetIds : affectedAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BirthdayEvent implements DayEvent {
  const BirthdayEvent({@MoneyConverter() required this.giftAmount, final  String? $type}): $type = $type ?? 'birthday';
  factory BirthdayEvent.fromJson(Map<String, dynamic> json) => _$BirthdayEventFromJson(json);

@MoneyConverter() final  Money giftAmount;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BirthdayEventCopyWith<BirthdayEvent> get copyWith => _$BirthdayEventCopyWithImpl<BirthdayEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BirthdayEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BirthdayEvent&&(identical(other.giftAmount, giftAmount) || other.giftAmount == giftAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,giftAmount);

@override
String toString() {
  return 'DayEvent.birthday(giftAmount: $giftAmount)';
}


}

/// @nodoc
abstract mixin class $BirthdayEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $BirthdayEventCopyWith(BirthdayEvent value, $Res Function(BirthdayEvent) _then) = _$BirthdayEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money giftAmount
});




}
/// @nodoc
class _$BirthdayEventCopyWithImpl<$Res>
    implements $BirthdayEventCopyWith<$Res> {
  _$BirthdayEventCopyWithImpl(this._self, this._then);

  final BirthdayEvent _self;
  final $Res Function(BirthdayEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? giftAmount = null,}) {
  return _then(BirthdayEvent(
giftAmount: null == giftAmount ? _self.giftAmount : giftAmount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TemptationEvent implements DayEvent {
  const TemptationEvent({required this.itemId, @MoneyConverter() required this.price, final  String? $type}): $type = $type ?? 'temptation';
  factory TemptationEvent.fromJson(Map<String, dynamic> json) => _$TemptationEventFromJson(json);

 final  String itemId;
@MoneyConverter() final  Money price;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemptationEventCopyWith<TemptationEvent> get copyWith => _$TemptationEventCopyWithImpl<TemptationEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemptationEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemptationEvent&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,price);

@override
String toString() {
  return 'DayEvent.temptation(itemId: $itemId, price: $price)';
}


}

/// @nodoc
abstract mixin class $TemptationEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $TemptationEventCopyWith(TemptationEvent value, $Res Function(TemptationEvent) _then) = _$TemptationEventCopyWithImpl;
@useResult
$Res call({
 String itemId,@MoneyConverter() Money price
});




}
/// @nodoc
class _$TemptationEventCopyWithImpl<$Res>
    implements $TemptationEventCopyWith<$Res> {
  _$TemptationEventCopyWithImpl(this._self, this._then);

  final TemptationEvent _self;
  final $Res Function(TemptationEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? price = null,}) {
  return _then(TemptationEvent(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SleepCostEvent implements DayEvent {
  const SleepCostEvent({@MoneyConverter() required this.amount, required this.hunger, final  String? $type}): $type = $type ?? 'sleepCost';
  factory SleepCostEvent.fromJson(Map<String, dynamic> json) => _$SleepCostEventFromJson(json);

@MoneyConverter() final  Money amount;
 final  bool hunger;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SleepCostEventCopyWith<SleepCostEvent> get copyWith => _$SleepCostEventCopyWithImpl<SleepCostEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SleepCostEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SleepCostEvent&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.hunger, hunger) || other.hunger == hunger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,hunger);

@override
String toString() {
  return 'DayEvent.sleepCost(amount: $amount, hunger: $hunger)';
}


}

/// @nodoc
abstract mixin class $SleepCostEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $SleepCostEventCopyWith(SleepCostEvent value, $Res Function(SleepCostEvent) _then) = _$SleepCostEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount, bool hunger
});




}
/// @nodoc
class _$SleepCostEventCopyWithImpl<$Res>
    implements $SleepCostEventCopyWith<$Res> {
  _$SleepCostEventCopyWithImpl(this._self, this._then);

  final SleepCostEvent _self;
  final $Res Function(SleepCostEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? hunger = null,}) {
  return _then(SleepCostEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,hunger: null == hunger ? _self.hunger : hunger // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LifetimeEndEvent implements DayEvent {
  const LifetimeEndEvent({final  String? $type}): $type = $type ?? 'lifetimeEnd';
  factory LifetimeEndEvent.fromJson(Map<String, dynamic> json) => _$LifetimeEndEventFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$LifetimeEndEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LifetimeEndEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DayEvent.lifetimeEnd()';
}


}




/// @nodoc
@JsonSerializable()

class RentIncomeEvent implements DayEvent {
  const RentIncomeEvent({@MoneyConverter() required this.amount, required this.propertyId, final  String? $type}): $type = $type ?? 'rentIncome';
  factory RentIncomeEvent.fromJson(Map<String, dynamic> json) => _$RentIncomeEventFromJson(json);

@MoneyConverter() final  Money amount;
 final  String propertyId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentIncomeEventCopyWith<RentIncomeEvent> get copyWith => _$RentIncomeEventCopyWithImpl<RentIncomeEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentIncomeEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentIncomeEvent&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,propertyId);

@override
String toString() {
  return 'DayEvent.rentIncome(amount: $amount, propertyId: $propertyId)';
}


}

/// @nodoc
abstract mixin class $RentIncomeEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $RentIncomeEventCopyWith(RentIncomeEvent value, $Res Function(RentIncomeEvent) _then) = _$RentIncomeEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount, String propertyId
});




}
/// @nodoc
class _$RentIncomeEventCopyWithImpl<$Res>
    implements $RentIncomeEventCopyWith<$Res> {
  _$RentIncomeEventCopyWithImpl(this._self, this._then);

  final RentIncomeEvent _self;
  final $Res Function(RentIncomeEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? propertyId = null,}) {
  return _then(RentIncomeEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SalaryEvent implements DayEvent {
  const SalaryEvent({@MoneyConverter() required this.amount, required this.jobLevel, @MoneyConverter() this.grossAmount = Money.zero, @MoneyConverter() this.taxAmount = Money.zero, @MoneyConverter() this.socialAmount = Money.zero, @MoneyConverter() this.soliAmount = Money.zero, @MoneyConverter() this.kircheAmount = Money.zero, final  String? $type}): $type = $type ?? 'salary';
  factory SalaryEvent.fromJson(Map<String, dynamic> json) => _$SalaryEventFromJson(json);

@MoneyConverter() final  Money amount;
 final  String jobLevel;
@JsonKey()@MoneyConverter() final  Money grossAmount;
@JsonKey()@MoneyConverter() final  Money taxAmount;
@JsonKey()@MoneyConverter() final  Money socialAmount;
@JsonKey()@MoneyConverter() final  Money soliAmount;
@JsonKey()@MoneyConverter() final  Money kircheAmount;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalaryEventCopyWith<SalaryEvent> get copyWith => _$SalaryEventCopyWithImpl<SalaryEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalaryEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalaryEvent&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.jobLevel, jobLevel) || other.jobLevel == jobLevel)&&(identical(other.grossAmount, grossAmount) || other.grossAmount == grossAmount)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.socialAmount, socialAmount) || other.socialAmount == socialAmount)&&(identical(other.soliAmount, soliAmount) || other.soliAmount == soliAmount)&&(identical(other.kircheAmount, kircheAmount) || other.kircheAmount == kircheAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,jobLevel,grossAmount,taxAmount,socialAmount,soliAmount,kircheAmount);

@override
String toString() {
  return 'DayEvent.salary(amount: $amount, jobLevel: $jobLevel, grossAmount: $grossAmount, taxAmount: $taxAmount, socialAmount: $socialAmount, soliAmount: $soliAmount, kircheAmount: $kircheAmount)';
}


}

/// @nodoc
abstract mixin class $SalaryEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $SalaryEventCopyWith(SalaryEvent value, $Res Function(SalaryEvent) _then) = _$SalaryEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount, String jobLevel,@MoneyConverter() Money grossAmount,@MoneyConverter() Money taxAmount,@MoneyConverter() Money socialAmount,@MoneyConverter() Money soliAmount,@MoneyConverter() Money kircheAmount
});




}
/// @nodoc
class _$SalaryEventCopyWithImpl<$Res>
    implements $SalaryEventCopyWith<$Res> {
  _$SalaryEventCopyWithImpl(this._self, this._then);

  final SalaryEvent _self;
  final $Res Function(SalaryEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? jobLevel = null,Object? grossAmount = null,Object? taxAmount = null,Object? socialAmount = null,Object? soliAmount = null,Object? kircheAmount = null,}) {
  return _then(SalaryEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,jobLevel: null == jobLevel ? _self.jobLevel : jobLevel // ignore: cast_nullable_to_non_nullable
as String,grossAmount: null == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as Money,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as Money,socialAmount: null == socialAmount ? _self.socialAmount : socialAmount // ignore: cast_nullable_to_non_nullable
as Money,soliAmount: null == soliAmount ? _self.soliAmount : soliAmount // ignore: cast_nullable_to_non_nullable
as Money,kircheAmount: null == kircheAmount ? _self.kircheAmount : kircheAmount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SavingsPlanExecutedEvent implements DayEvent {
  const SavingsPlanExecutedEvent({@MoneyConverter() required this.amount, required this.targetAssetId, final  String? $type}): $type = $type ?? 'savingsPlanExecuted';
  factory SavingsPlanExecutedEvent.fromJson(Map<String, dynamic> json) => _$SavingsPlanExecutedEventFromJson(json);

@MoneyConverter() final  Money amount;
 final  String targetAssetId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsPlanExecutedEventCopyWith<SavingsPlanExecutedEvent> get copyWith => _$SavingsPlanExecutedEventCopyWithImpl<SavingsPlanExecutedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingsPlanExecutedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsPlanExecutedEvent&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.targetAssetId, targetAssetId) || other.targetAssetId == targetAssetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,targetAssetId);

@override
String toString() {
  return 'DayEvent.savingsPlanExecuted(amount: $amount, targetAssetId: $targetAssetId)';
}


}

/// @nodoc
abstract mixin class $SavingsPlanExecutedEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $SavingsPlanExecutedEventCopyWith(SavingsPlanExecutedEvent value, $Res Function(SavingsPlanExecutedEvent) _then) = _$SavingsPlanExecutedEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount, String targetAssetId
});




}
/// @nodoc
class _$SavingsPlanExecutedEventCopyWithImpl<$Res>
    implements $SavingsPlanExecutedEventCopyWith<$Res> {
  _$SavingsPlanExecutedEventCopyWithImpl(this._self, this._then);

  final SavingsPlanExecutedEvent _self;
  final $Res Function(SavingsPlanExecutedEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? targetAssetId = null,}) {
  return _then(SavingsPlanExecutedEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,targetAssetId: null == targetAssetId ? _self.targetAssetId : targetAssetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DebtInterestEvent implements DayEvent {
  const DebtInterestEvent({@MoneyConverter() required this.amount, final  String? $type}): $type = $type ?? 'debtInterest';
  factory DebtInterestEvent.fromJson(Map<String, dynamic> json) => _$DebtInterestEventFromJson(json);

@MoneyConverter() final  Money amount;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebtInterestEventCopyWith<DebtInterestEvent> get copyWith => _$DebtInterestEventCopyWithImpl<DebtInterestEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebtInterestEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebtInterestEvent&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount);

@override
String toString() {
  return 'DayEvent.debtInterest(amount: $amount)';
}


}

/// @nodoc
abstract mixin class $DebtInterestEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $DebtInterestEventCopyWith(DebtInterestEvent value, $Res Function(DebtInterestEvent) _then) = _$DebtInterestEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount
});




}
/// @nodoc
class _$DebtInterestEventCopyWithImpl<$Res>
    implements $DebtInterestEventCopyWith<$Res> {
  _$DebtInterestEventCopyWithImpl(this._self, this._then);

  final DebtInterestEvent _self;
  final $Res Function(DebtInterestEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,}) {
  return _then(DebtInterestEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InsuranceFeeEvent implements DayEvent {
  const InsuranceFeeEvent({@MoneyConverter() required this.amount, required this.kind, final  String? $type}): $type = $type ?? 'insuranceFee';
  factory InsuranceFeeEvent.fromJson(Map<String, dynamic> json) => _$InsuranceFeeEventFromJson(json);

@MoneyConverter() final  Money amount;
 final  String kind;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsuranceFeeEventCopyWith<InsuranceFeeEvent> get copyWith => _$InsuranceFeeEventCopyWithImpl<InsuranceFeeEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsuranceFeeEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsuranceFeeEvent&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,kind);

@override
String toString() {
  return 'DayEvent.insuranceFee(amount: $amount, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $InsuranceFeeEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $InsuranceFeeEventCopyWith(InsuranceFeeEvent value, $Res Function(InsuranceFeeEvent) _then) = _$InsuranceFeeEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money amount, String kind
});




}
/// @nodoc
class _$InsuranceFeeEventCopyWithImpl<$Res>
    implements $InsuranceFeeEventCopyWith<$Res> {
  _$InsuranceFeeEventCopyWithImpl(this._self, this._then);

  final InsuranceFeeEvent _self;
  final $Res Function(InsuranceFeeEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? kind = null,}) {
  return _then(InsuranceFeeEvent(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LuckyEvent implements DayEvent {
  const LuckyEvent({required this.title, required this.description, @MoneyConverter() required this.amount, @MoneyConverter() required this.taxDeducted, final  String? $type}): $type = $type ?? 'luckyEvent';
  factory LuckyEvent.fromJson(Map<String, dynamic> json) => _$LuckyEventFromJson(json);

 final  String title;
 final  String description;
@MoneyConverter() final  Money amount;
@MoneyConverter() final  Money taxDeducted;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LuckyEventCopyWith<LuckyEvent> get copyWith => _$LuckyEventCopyWithImpl<LuckyEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LuckyEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LuckyEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.taxDeducted, taxDeducted) || other.taxDeducted == taxDeducted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,amount,taxDeducted);

@override
String toString() {
  return 'DayEvent.luckyEvent(title: $title, description: $description, amount: $amount, taxDeducted: $taxDeducted)';
}


}

/// @nodoc
abstract mixin class $LuckyEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $LuckyEventCopyWith(LuckyEvent value, $Res Function(LuckyEvent) _then) = _$LuckyEventCopyWithImpl;
@useResult
$Res call({
 String title, String description,@MoneyConverter() Money amount,@MoneyConverter() Money taxDeducted
});




}
/// @nodoc
class _$LuckyEventCopyWithImpl<$Res>
    implements $LuckyEventCopyWith<$Res> {
  _$LuckyEventCopyWithImpl(this._self, this._then);

  final LuckyEvent _self;
  final $Res Function(LuckyEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? amount = null,Object? taxDeducted = null,}) {
  return _then(LuckyEvent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,taxDeducted: null == taxDeducted ? _self.taxDeducted : taxDeducted // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CrashStartedEvent implements DayEvent {
  const CrashStartedEvent({required this.assetClassId, required this.depthPct, required this.durationDays, final  String? $type}): $type = $type ?? 'crashStarted';
  factory CrashStartedEvent.fromJson(Map<String, dynamic> json) => _$CrashStartedEventFromJson(json);

 final  String assetClassId;
 final  double depthPct;
 final  int durationDays;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrashStartedEventCopyWith<CrashStartedEvent> get copyWith => _$CrashStartedEventCopyWithImpl<CrashStartedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrashStartedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrashStartedEvent&&(identical(other.assetClassId, assetClassId) || other.assetClassId == assetClassId)&&(identical(other.depthPct, depthPct) || other.depthPct == depthPct)&&(identical(other.durationDays, durationDays) || other.durationDays == durationDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetClassId,depthPct,durationDays);

@override
String toString() {
  return 'DayEvent.crashStarted(assetClassId: $assetClassId, depthPct: $depthPct, durationDays: $durationDays)';
}


}

/// @nodoc
abstract mixin class $CrashStartedEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $CrashStartedEventCopyWith(CrashStartedEvent value, $Res Function(CrashStartedEvent) _then) = _$CrashStartedEventCopyWithImpl;
@useResult
$Res call({
 String assetClassId, double depthPct, int durationDays
});




}
/// @nodoc
class _$CrashStartedEventCopyWithImpl<$Res>
    implements $CrashStartedEventCopyWith<$Res> {
  _$CrashStartedEventCopyWithImpl(this._self, this._then);

  final CrashStartedEvent _self;
  final $Res Function(CrashStartedEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetClassId = null,Object? depthPct = null,Object? durationDays = null,}) {
  return _then(CrashStartedEvent(
assetClassId: null == assetClassId ? _self.assetClassId : assetClassId // ignore: cast_nullable_to_non_nullable
as String,depthPct: null == depthPct ? _self.depthPct : depthPct // ignore: cast_nullable_to_non_nullable
as double,durationDays: null == durationDays ? _self.durationDays : durationDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RecoveryCompleteEvent implements DayEvent {
  const RecoveryCompleteEvent({required this.assetClassId, final  String? $type}): $type = $type ?? 'recoveryComplete';
  factory RecoveryCompleteEvent.fromJson(Map<String, dynamic> json) => _$RecoveryCompleteEventFromJson(json);

 final  String assetClassId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecoveryCompleteEventCopyWith<RecoveryCompleteEvent> get copyWith => _$RecoveryCompleteEventCopyWithImpl<RecoveryCompleteEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecoveryCompleteEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecoveryCompleteEvent&&(identical(other.assetClassId, assetClassId) || other.assetClassId == assetClassId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetClassId);

@override
String toString() {
  return 'DayEvent.recoveryComplete(assetClassId: $assetClassId)';
}


}

/// @nodoc
abstract mixin class $RecoveryCompleteEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $RecoveryCompleteEventCopyWith(RecoveryCompleteEvent value, $Res Function(RecoveryCompleteEvent) _then) = _$RecoveryCompleteEventCopyWithImpl;
@useResult
$Res call({
 String assetClassId
});




}
/// @nodoc
class _$RecoveryCompleteEventCopyWithImpl<$Res>
    implements $RecoveryCompleteEventCopyWith<$Res> {
  _$RecoveryCompleteEventCopyWithImpl(this._self, this._then);

  final RecoveryCompleteEvent _self;
  final $Res Function(RecoveryCompleteEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetClassId = null,}) {
  return _then(RecoveryCompleteEvent(
assetClassId: null == assetClassId ? _self.assetClassId : assetClassId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MillionaireReachedEvent implements DayEvent {
  const MillionaireReachedEvent({required this.ageYears, @MoneyConverter() required this.netWorth, final  String? $type}): $type = $type ?? 'millionaireReached';
  factory MillionaireReachedEvent.fromJson(Map<String, dynamic> json) => _$MillionaireReachedEventFromJson(json);

 final  int ageYears;
@MoneyConverter() final  Money netWorth;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MillionaireReachedEventCopyWith<MillionaireReachedEvent> get copyWith => _$MillionaireReachedEventCopyWithImpl<MillionaireReachedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MillionaireReachedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MillionaireReachedEvent&&(identical(other.ageYears, ageYears) || other.ageYears == ageYears)&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ageYears,netWorth);

@override
String toString() {
  return 'DayEvent.millionaireReached(ageYears: $ageYears, netWorth: $netWorth)';
}


}

/// @nodoc
abstract mixin class $MillionaireReachedEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $MillionaireReachedEventCopyWith(MillionaireReachedEvent value, $Res Function(MillionaireReachedEvent) _then) = _$MillionaireReachedEventCopyWithImpl;
@useResult
$Res call({
 int ageYears,@MoneyConverter() Money netWorth
});




}
/// @nodoc
class _$MillionaireReachedEventCopyWithImpl<$Res>
    implements $MillionaireReachedEventCopyWith<$Res> {
  _$MillionaireReachedEventCopyWithImpl(this._self, this._then);

  final MillionaireReachedEvent _self;
  final $Res Function(MillionaireReachedEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ageYears = null,Object? netWorth = null,}) {
  return _then(MillionaireReachedEvent(
ageYears: null == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int,netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LevelUpEvent implements DayEvent {
  const LevelUpEvent({required this.newLevel, required this.title, required this.titleChanged, final  String? $type}): $type = $type ?? 'levelUp';
  factory LevelUpEvent.fromJson(Map<String, dynamic> json) => _$LevelUpEventFromJson(json);

 final  int newLevel;
 final  String title;
 final  bool titleChanged;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelUpEventCopyWith<LevelUpEvent> get copyWith => _$LevelUpEventCopyWithImpl<LevelUpEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelUpEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelUpEvent&&(identical(other.newLevel, newLevel) || other.newLevel == newLevel)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleChanged, titleChanged) || other.titleChanged == titleChanged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newLevel,title,titleChanged);

@override
String toString() {
  return 'DayEvent.levelUp(newLevel: $newLevel, title: $title, titleChanged: $titleChanged)';
}


}

/// @nodoc
abstract mixin class $LevelUpEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $LevelUpEventCopyWith(LevelUpEvent value, $Res Function(LevelUpEvent) _then) = _$LevelUpEventCopyWithImpl;
@useResult
$Res call({
 int newLevel, String title, bool titleChanged
});




}
/// @nodoc
class _$LevelUpEventCopyWithImpl<$Res>
    implements $LevelUpEventCopyWith<$Res> {
  _$LevelUpEventCopyWithImpl(this._self, this._then);

  final LevelUpEvent _self;
  final $Res Function(LevelUpEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newLevel = null,Object? title = null,Object? titleChanged = null,}) {
  return _then(LevelUpEvent(
newLevel: null == newLevel ? _self.newLevel : newLevel // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleChanged: null == titleChanged ? _self.titleChanged : titleChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BankruptcyEvent implements DayEvent {
  const BankruptcyEvent({@MoneyConverter() required this.netWorth, final  String? $type}): $type = $type ?? 'bankruptcy';
  factory BankruptcyEvent.fromJson(Map<String, dynamic> json) => _$BankruptcyEventFromJson(json);

@MoneyConverter() final  Money netWorth;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankruptcyEventCopyWith<BankruptcyEvent> get copyWith => _$BankruptcyEventCopyWithImpl<BankruptcyEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankruptcyEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankruptcyEvent&&(identical(other.netWorth, netWorth) || other.netWorth == netWorth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,netWorth);

@override
String toString() {
  return 'DayEvent.bankruptcy(netWorth: $netWorth)';
}


}

/// @nodoc
abstract mixin class $BankruptcyEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $BankruptcyEventCopyWith(BankruptcyEvent value, $Res Function(BankruptcyEvent) _then) = _$BankruptcyEventCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money netWorth
});




}
/// @nodoc
class _$BankruptcyEventCopyWithImpl<$Res>
    implements $BankruptcyEventCopyWith<$Res> {
  _$BankruptcyEventCopyWithImpl(this._self, this._then);

  final BankruptcyEvent _self;
  final $Res Function(BankruptcyEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? netWorth = null,}) {
  return _then(BankruptcyEvent(
netWorth: null == netWorth ? _self.netWorth : netWorth // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PanicSellRealizedEvent implements DayEvent {
  const PanicSellRealizedEvent({required this.assetClassId, required this.lossCents, required this.soldAtPct, required this.currentPct, required this.daysSinceSell, final  String? $type}): $type = $type ?? 'panicSellRealized';
  factory PanicSellRealizedEvent.fromJson(Map<String, dynamic> json) => _$PanicSellRealizedEventFromJson(json);

 final  String assetClassId;
 final  int lossCents;
 final  double soldAtPct;
 final  double currentPct;
 final  int daysSinceSell;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PanicSellRealizedEventCopyWith<PanicSellRealizedEvent> get copyWith => _$PanicSellRealizedEventCopyWithImpl<PanicSellRealizedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PanicSellRealizedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PanicSellRealizedEvent&&(identical(other.assetClassId, assetClassId) || other.assetClassId == assetClassId)&&(identical(other.lossCents, lossCents) || other.lossCents == lossCents)&&(identical(other.soldAtPct, soldAtPct) || other.soldAtPct == soldAtPct)&&(identical(other.currentPct, currentPct) || other.currentPct == currentPct)&&(identical(other.daysSinceSell, daysSinceSell) || other.daysSinceSell == daysSinceSell));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetClassId,lossCents,soldAtPct,currentPct,daysSinceSell);

@override
String toString() {
  return 'DayEvent.panicSellRealized(assetClassId: $assetClassId, lossCents: $lossCents, soldAtPct: $soldAtPct, currentPct: $currentPct, daysSinceSell: $daysSinceSell)';
}


}

/// @nodoc
abstract mixin class $PanicSellRealizedEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $PanicSellRealizedEventCopyWith(PanicSellRealizedEvent value, $Res Function(PanicSellRealizedEvent) _then) = _$PanicSellRealizedEventCopyWithImpl;
@useResult
$Res call({
 String assetClassId, int lossCents, double soldAtPct, double currentPct, int daysSinceSell
});




}
/// @nodoc
class _$PanicSellRealizedEventCopyWithImpl<$Res>
    implements $PanicSellRealizedEventCopyWith<$Res> {
  _$PanicSellRealizedEventCopyWithImpl(this._self, this._then);

  final PanicSellRealizedEvent _self;
  final $Res Function(PanicSellRealizedEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetClassId = null,Object? lossCents = null,Object? soldAtPct = null,Object? currentPct = null,Object? daysSinceSell = null,}) {
  return _then(PanicSellRealizedEvent(
assetClassId: null == assetClassId ? _self.assetClassId : assetClassId // ignore: cast_nullable_to_non_nullable
as String,lossCents: null == lossCents ? _self.lossCents : lossCents // ignore: cast_nullable_to_non_nullable
as int,soldAtPct: null == soldAtPct ? _self.soldAtPct : soldAtPct // ignore: cast_nullable_to_non_nullable
as double,currentPct: null == currentPct ? _self.currentPct : currentPct // ignore: cast_nullable_to_non_nullable
as double,daysSinceSell: null == daysSinceSell ? _self.daysSinceSell : daysSinceSell // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class HeldThroughCrashEvent implements DayEvent {
  const HeldThroughCrashEvent({required this.assetClassId, final  String? $type}): $type = $type ?? 'heldThroughCrash';
  factory HeldThroughCrashEvent.fromJson(Map<String, dynamic> json) => _$HeldThroughCrashEventFromJson(json);

 final  String assetClassId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeldThroughCrashEventCopyWith<HeldThroughCrashEvent> get copyWith => _$HeldThroughCrashEventCopyWithImpl<HeldThroughCrashEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeldThroughCrashEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeldThroughCrashEvent&&(identical(other.assetClassId, assetClassId) || other.assetClassId == assetClassId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetClassId);

@override
String toString() {
  return 'DayEvent.heldThroughCrash(assetClassId: $assetClassId)';
}


}

/// @nodoc
abstract mixin class $HeldThroughCrashEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $HeldThroughCrashEventCopyWith(HeldThroughCrashEvent value, $Res Function(HeldThroughCrashEvent) _then) = _$HeldThroughCrashEventCopyWithImpl;
@useResult
$Res call({
 String assetClassId
});




}
/// @nodoc
class _$HeldThroughCrashEventCopyWithImpl<$Res>
    implements $HeldThroughCrashEventCopyWith<$Res> {
  _$HeldThroughCrashEventCopyWithImpl(this._self, this._then);

  final HeldThroughCrashEvent _self;
  final $Res Function(HeldThroughCrashEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetClassId = null,}) {
  return _then(HeldThroughCrashEvent(
assetClassId: null == assetClassId ? _self.assetClassId : assetClassId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StockBankruptEvent implements DayEvent {
  const StockBankruptEvent({required this.stockId, required this.name, final  String? $type}): $type = $type ?? 'stockBankrupt';
  factory StockBankruptEvent.fromJson(Map<String, dynamic> json) => _$StockBankruptEventFromJson(json);

 final  String stockId;
 final  String name;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockBankruptEventCopyWith<StockBankruptEvent> get copyWith => _$StockBankruptEventCopyWithImpl<StockBankruptEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockBankruptEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockBankruptEvent&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stockId,name);

@override
String toString() {
  return 'DayEvent.stockBankrupt(stockId: $stockId, name: $name)';
}


}

/// @nodoc
abstract mixin class $StockBankruptEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $StockBankruptEventCopyWith(StockBankruptEvent value, $Res Function(StockBankruptEvent) _then) = _$StockBankruptEventCopyWithImpl;
@useResult
$Res call({
 String stockId, String name
});




}
/// @nodoc
class _$StockBankruptEventCopyWithImpl<$Res>
    implements $StockBankruptEventCopyWith<$Res> {
  _$StockBankruptEventCopyWithImpl(this._self, this._then);

  final StockBankruptEvent _self;
  final $Res Function(StockBankruptEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stockId = null,Object? name = null,}) {
  return _then(StockBankruptEvent(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SeasonalEvent implements DayEvent {
  const SeasonalEvent({required this.title, required this.message, final  String? $type}): $type = $type ?? 'seasonalEvent';
  factory SeasonalEvent.fromJson(Map<String, dynamic> json) => _$SeasonalEventFromJson(json);

 final  String title;
 final  String message;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonalEventCopyWith<SeasonalEvent> get copyWith => _$SeasonalEventCopyWithImpl<SeasonalEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonalEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonalEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,message);

@override
String toString() {
  return 'DayEvent.seasonalEvent(title: $title, message: $message)';
}


}

/// @nodoc
abstract mixin class $SeasonalEventCopyWith<$Res> implements $DayEventCopyWith<$Res> {
  factory $SeasonalEventCopyWith(SeasonalEvent value, $Res Function(SeasonalEvent) _then) = _$SeasonalEventCopyWithImpl;
@useResult
$Res call({
 String title, String message
});




}
/// @nodoc
class _$SeasonalEventCopyWithImpl<$Res>
    implements $SeasonalEventCopyWith<$Res> {
  _$SeasonalEventCopyWithImpl(this._self, this._then);

  final SeasonalEvent _self;
  final $Res Function(SeasonalEvent) _then;

/// Create a copy of DayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,}) {
  return _then(SeasonalEvent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
