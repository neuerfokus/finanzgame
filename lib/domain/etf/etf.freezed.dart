// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'etf.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EtfHolding {

 String get etfId; int get shares;@MoneyConverter() Money get averageBuyPrice;
/// Create a copy of EtfHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtfHoldingCopyWith<EtfHolding> get copyWith => _$EtfHoldingCopyWithImpl<EtfHolding>(this as EtfHolding, _$identity);

  /// Serializes this EtfHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtfHolding&&(identical(other.etfId, etfId) || other.etfId == etfId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etfId,shares,averageBuyPrice);

@override
String toString() {
  return 'EtfHolding(etfId: $etfId, shares: $shares, averageBuyPrice: $averageBuyPrice)';
}


}

/// @nodoc
abstract mixin class $EtfHoldingCopyWith<$Res>  {
  factory $EtfHoldingCopyWith(EtfHolding value, $Res Function(EtfHolding) _then) = _$EtfHoldingCopyWithImpl;
@useResult
$Res call({
 String etfId, int shares,@MoneyConverter() Money averageBuyPrice
});




}
/// @nodoc
class _$EtfHoldingCopyWithImpl<$Res>
    implements $EtfHoldingCopyWith<$Res> {
  _$EtfHoldingCopyWithImpl(this._self, this._then);

  final EtfHolding _self;
  final $Res Function(EtfHolding) _then;

/// Create a copy of EtfHolding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? etfId = null,Object? shares = null,Object? averageBuyPrice = null,}) {
  return _then(_self.copyWith(
etfId: null == etfId ? _self.etfId : etfId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [EtfHolding].
extension EtfHoldingPatterns on EtfHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtfHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtfHolding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtfHolding value)  $default,){
final _that = this;
switch (_that) {
case _EtfHolding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtfHolding value)?  $default,){
final _that = this;
switch (_that) {
case _EtfHolding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String etfId,  int shares, @MoneyConverter()  Money averageBuyPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtfHolding() when $default != null:
return $default(_that.etfId,_that.shares,_that.averageBuyPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String etfId,  int shares, @MoneyConverter()  Money averageBuyPrice)  $default,) {final _that = this;
switch (_that) {
case _EtfHolding():
return $default(_that.etfId,_that.shares,_that.averageBuyPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String etfId,  int shares, @MoneyConverter()  Money averageBuyPrice)?  $default,) {final _that = this;
switch (_that) {
case _EtfHolding() when $default != null:
return $default(_that.etfId,_that.shares,_that.averageBuyPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtfHolding implements EtfHolding {
  const _EtfHolding({required this.etfId, required this.shares, @MoneyConverter() required this.averageBuyPrice});
  factory _EtfHolding.fromJson(Map<String, dynamic> json) => _$EtfHoldingFromJson(json);

@override final  String etfId;
@override final  int shares;
@override@MoneyConverter() final  Money averageBuyPrice;

/// Create a copy of EtfHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtfHoldingCopyWith<_EtfHolding> get copyWith => __$EtfHoldingCopyWithImpl<_EtfHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtfHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtfHolding&&(identical(other.etfId, etfId) || other.etfId == etfId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etfId,shares,averageBuyPrice);

@override
String toString() {
  return 'EtfHolding(etfId: $etfId, shares: $shares, averageBuyPrice: $averageBuyPrice)';
}


}

/// @nodoc
abstract mixin class _$EtfHoldingCopyWith<$Res> implements $EtfHoldingCopyWith<$Res> {
  factory _$EtfHoldingCopyWith(_EtfHolding value, $Res Function(_EtfHolding) _then) = __$EtfHoldingCopyWithImpl;
@override @useResult
$Res call({
 String etfId, int shares,@MoneyConverter() Money averageBuyPrice
});




}
/// @nodoc
class __$EtfHoldingCopyWithImpl<$Res>
    implements _$EtfHoldingCopyWith<$Res> {
  __$EtfHoldingCopyWithImpl(this._self, this._then);

  final _EtfHolding _self;
  final $Res Function(_EtfHolding) _then;

/// Create a copy of EtfHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? etfId = null,Object? shares = null,Object? averageBuyPrice = null,}) {
  return _then(_EtfHolding(
etfId: null == etfId ? _self.etfId : etfId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$EtfQuote {

 String get etfId;@MoneyConverter() Money get pricePerShare; int get onDayIndex;
/// Create a copy of EtfQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtfQuoteCopyWith<EtfQuote> get copyWith => _$EtfQuoteCopyWithImpl<EtfQuote>(this as EtfQuote, _$identity);

  /// Serializes this EtfQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtfQuote&&(identical(other.etfId, etfId) || other.etfId == etfId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etfId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'EtfQuote(etfId: $etfId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class $EtfQuoteCopyWith<$Res>  {
  factory $EtfQuoteCopyWith(EtfQuote value, $Res Function(EtfQuote) _then) = _$EtfQuoteCopyWithImpl;
@useResult
$Res call({
 String etfId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class _$EtfQuoteCopyWithImpl<$Res>
    implements $EtfQuoteCopyWith<$Res> {
  _$EtfQuoteCopyWithImpl(this._self, this._then);

  final EtfQuote _self;
  final $Res Function(EtfQuote) _then;

/// Create a copy of EtfQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? etfId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_self.copyWith(
etfId: null == etfId ? _self.etfId : etfId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EtfQuote].
extension EtfQuotePatterns on EtfQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtfQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtfQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtfQuote value)  $default,){
final _that = this;
switch (_that) {
case _EtfQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtfQuote value)?  $default,){
final _that = this;
switch (_that) {
case _EtfQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String etfId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtfQuote() when $default != null:
return $default(_that.etfId,_that.pricePerShare,_that.onDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String etfId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)  $default,) {final _that = this;
switch (_that) {
case _EtfQuote():
return $default(_that.etfId,_that.pricePerShare,_that.onDayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String etfId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _EtfQuote() when $default != null:
return $default(_that.etfId,_that.pricePerShare,_that.onDayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtfQuote implements EtfQuote {
  const _EtfQuote({required this.etfId, @MoneyConverter() required this.pricePerShare, required this.onDayIndex});
  factory _EtfQuote.fromJson(Map<String, dynamic> json) => _$EtfQuoteFromJson(json);

@override final  String etfId;
@override@MoneyConverter() final  Money pricePerShare;
@override final  int onDayIndex;

/// Create a copy of EtfQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtfQuoteCopyWith<_EtfQuote> get copyWith => __$EtfQuoteCopyWithImpl<_EtfQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtfQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtfQuote&&(identical(other.etfId, etfId) || other.etfId == etfId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,etfId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'EtfQuote(etfId: $etfId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class _$EtfQuoteCopyWith<$Res> implements $EtfQuoteCopyWith<$Res> {
  factory _$EtfQuoteCopyWith(_EtfQuote value, $Res Function(_EtfQuote) _then) = __$EtfQuoteCopyWithImpl;
@override @useResult
$Res call({
 String etfId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class __$EtfQuoteCopyWithImpl<$Res>
    implements _$EtfQuoteCopyWith<$Res> {
  __$EtfQuoteCopyWithImpl(this._self, this._then);

  final _EtfQuote _self;
  final $Res Function(_EtfQuote) _then;

/// Create a copy of EtfQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? etfId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_EtfQuote(
etfId: null == etfId ? _self.etfId : etfId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
