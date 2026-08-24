// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockHolding {

 String get stockId; int get shares;@MoneyConverter() Money get averageBuyPrice;/// Spec-44 A.1: ist das zugrundeliegende Unternehmen pleite?
/// Holding bleibt sichtbar (für die Lehrwirkung), aber wertlos.
/// Bankrupt-Holdings können nur noch für ~1¢/Aktie verkauft
/// werden ("Notverkauf").
 bool get bankrupt;
/// Create a copy of StockHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockHoldingCopyWith<StockHolding> get copyWith => _$StockHoldingCopyWithImpl<StockHolding>(this as StockHolding, _$identity);

  /// Serializes this StockHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockHolding&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice)&&(identical(other.bankrupt, bankrupt) || other.bankrupt == bankrupt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stockId,shares,averageBuyPrice,bankrupt);

@override
String toString() {
  return 'StockHolding(stockId: $stockId, shares: $shares, averageBuyPrice: $averageBuyPrice, bankrupt: $bankrupt)';
}


}

/// @nodoc
abstract mixin class $StockHoldingCopyWith<$Res>  {
  factory $StockHoldingCopyWith(StockHolding value, $Res Function(StockHolding) _then) = _$StockHoldingCopyWithImpl;
@useResult
$Res call({
 String stockId, int shares,@MoneyConverter() Money averageBuyPrice, bool bankrupt
});




}
/// @nodoc
class _$StockHoldingCopyWithImpl<$Res>
    implements $StockHoldingCopyWith<$Res> {
  _$StockHoldingCopyWithImpl(this._self, this._then);

  final StockHolding _self;
  final $Res Function(StockHolding) _then;

/// Create a copy of StockHolding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stockId = null,Object? shares = null,Object? averageBuyPrice = null,Object? bankrupt = null,}) {
  return _then(_self.copyWith(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,bankrupt: null == bankrupt ? _self.bankrupt : bankrupt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StockHolding].
extension StockHoldingPatterns on StockHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockHolding() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockHolding value)  $default,){
final _that = this;
switch (_that) {
case _StockHolding():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockHolding value)?  $default,){
final _that = this;
switch (_that) {
case _StockHolding() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stockId,  int shares, @MoneyConverter()  Money averageBuyPrice,  bool bankrupt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockHolding() when $default != null:
return $default(_that.stockId,_that.shares,_that.averageBuyPrice,_that.bankrupt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stockId,  int shares, @MoneyConverter()  Money averageBuyPrice,  bool bankrupt)  $default,) {final _that = this;
switch (_that) {
case _StockHolding():
return $default(_that.stockId,_that.shares,_that.averageBuyPrice,_that.bankrupt);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stockId,  int shares, @MoneyConverter()  Money averageBuyPrice,  bool bankrupt)?  $default,) {final _that = this;
switch (_that) {
case _StockHolding() when $default != null:
return $default(_that.stockId,_that.shares,_that.averageBuyPrice,_that.bankrupt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockHolding implements StockHolding {
  const _StockHolding({required this.stockId, required this.shares, @MoneyConverter() required this.averageBuyPrice, this.bankrupt = false});
  factory _StockHolding.fromJson(Map<String, dynamic> json) => _$StockHoldingFromJson(json);

@override final  String stockId;
@override final  int shares;
@override@MoneyConverter() final  Money averageBuyPrice;
/// Spec-44 A.1: ist das zugrundeliegende Unternehmen pleite?
/// Holding bleibt sichtbar (für die Lehrwirkung), aber wertlos.
/// Bankrupt-Holdings können nur noch für ~1¢/Aktie verkauft
/// werden ("Notverkauf").
@override@JsonKey() final  bool bankrupt;

/// Create a copy of StockHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockHoldingCopyWith<_StockHolding> get copyWith => __$StockHoldingCopyWithImpl<_StockHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockHolding&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice)&&(identical(other.bankrupt, bankrupt) || other.bankrupt == bankrupt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stockId,shares,averageBuyPrice,bankrupt);

@override
String toString() {
  return 'StockHolding(stockId: $stockId, shares: $shares, averageBuyPrice: $averageBuyPrice, bankrupt: $bankrupt)';
}


}

/// @nodoc
abstract mixin class _$StockHoldingCopyWith<$Res> implements $StockHoldingCopyWith<$Res> {
  factory _$StockHoldingCopyWith(_StockHolding value, $Res Function(_StockHolding) _then) = __$StockHoldingCopyWithImpl;
@override @useResult
$Res call({
 String stockId, int shares,@MoneyConverter() Money averageBuyPrice, bool bankrupt
});




}
/// @nodoc
class __$StockHoldingCopyWithImpl<$Res>
    implements _$StockHoldingCopyWith<$Res> {
  __$StockHoldingCopyWithImpl(this._self, this._then);

  final _StockHolding _self;
  final $Res Function(_StockHolding) _then;

/// Create a copy of StockHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stockId = null,Object? shares = null,Object? averageBuyPrice = null,Object? bankrupt = null,}) {
  return _then(_StockHolding(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,bankrupt: null == bankrupt ? _self.bankrupt : bankrupt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StockQuote {

 String get stockId;@MoneyConverter() Money get pricePerShare; int get onDayIndex;
/// Create a copy of StockQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockQuoteCopyWith<StockQuote> get copyWith => _$StockQuoteCopyWithImpl<StockQuote>(this as StockQuote, _$identity);

  /// Serializes this StockQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockQuote&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stockId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'StockQuote(stockId: $stockId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class $StockQuoteCopyWith<$Res>  {
  factory $StockQuoteCopyWith(StockQuote value, $Res Function(StockQuote) _then) = _$StockQuoteCopyWithImpl;
@useResult
$Res call({
 String stockId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class _$StockQuoteCopyWithImpl<$Res>
    implements $StockQuoteCopyWith<$Res> {
  _$StockQuoteCopyWithImpl(this._self, this._then);

  final StockQuote _self;
  final $Res Function(StockQuote) _then;

/// Create a copy of StockQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stockId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_self.copyWith(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StockQuote].
extension StockQuotePatterns on StockQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockQuote() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockQuote value)  $default,){
final _that = this;
switch (_that) {
case _StockQuote():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockQuote value)?  $default,){
final _that = this;
switch (_that) {
case _StockQuote() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stockId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockQuote() when $default != null:
return $default(_that.stockId,_that.pricePerShare,_that.onDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stockId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)  $default,) {final _that = this;
switch (_that) {
case _StockQuote():
return $default(_that.stockId,_that.pricePerShare,_that.onDayIndex);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stockId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _StockQuote() when $default != null:
return $default(_that.stockId,_that.pricePerShare,_that.onDayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockQuote implements StockQuote {
  const _StockQuote({required this.stockId, @MoneyConverter() required this.pricePerShare, required this.onDayIndex});
  factory _StockQuote.fromJson(Map<String, dynamic> json) => _$StockQuoteFromJson(json);

@override final  String stockId;
@override@MoneyConverter() final  Money pricePerShare;
@override final  int onDayIndex;

/// Create a copy of StockQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockQuoteCopyWith<_StockQuote> get copyWith => __$StockQuoteCopyWithImpl<_StockQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockQuote&&(identical(other.stockId, stockId) || other.stockId == stockId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stockId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'StockQuote(stockId: $stockId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class _$StockQuoteCopyWith<$Res> implements $StockQuoteCopyWith<$Res> {
  factory _$StockQuoteCopyWith(_StockQuote value, $Res Function(_StockQuote) _then) = __$StockQuoteCopyWithImpl;
@override @useResult
$Res call({
 String stockId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class __$StockQuoteCopyWithImpl<$Res>
    implements _$StockQuoteCopyWith<$Res> {
  __$StockQuoteCopyWithImpl(this._self, this._then);

  final _StockQuote _self;
  final $Res Function(_StockQuote) _then;

/// Create a copy of StockQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stockId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_StockQuote(
stockId: null == stockId ? _self.stockId : stockId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
