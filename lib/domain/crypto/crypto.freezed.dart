// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CryptoHolding {

 String get assetId; int get shares;@MoneyConverter() Money get averageBuyPrice;
/// Create a copy of CryptoHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoHoldingCopyWith<CryptoHolding> get copyWith => _$CryptoHoldingCopyWithImpl<CryptoHolding>(this as CryptoHolding, _$identity);

  /// Serializes this CryptoHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoHolding&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,shares,averageBuyPrice);

@override
String toString() {
  return 'CryptoHolding(assetId: $assetId, shares: $shares, averageBuyPrice: $averageBuyPrice)';
}


}

/// @nodoc
abstract mixin class $CryptoHoldingCopyWith<$Res>  {
  factory $CryptoHoldingCopyWith(CryptoHolding value, $Res Function(CryptoHolding) _then) = _$CryptoHoldingCopyWithImpl;
@useResult
$Res call({
 String assetId, int shares,@MoneyConverter() Money averageBuyPrice
});




}
/// @nodoc
class _$CryptoHoldingCopyWithImpl<$Res>
    implements $CryptoHoldingCopyWith<$Res> {
  _$CryptoHoldingCopyWithImpl(this._self, this._then);

  final CryptoHolding _self;
  final $Res Function(CryptoHolding) _then;

/// Create a copy of CryptoHolding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? shares = null,Object? averageBuyPrice = null,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [CryptoHolding].
extension CryptoHoldingPatterns on CryptoHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CryptoHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CryptoHolding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CryptoHolding value)  $default,){
final _that = this;
switch (_that) {
case _CryptoHolding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CryptoHolding value)?  $default,){
final _that = this;
switch (_that) {
case _CryptoHolding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assetId,  int shares, @MoneyConverter()  Money averageBuyPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CryptoHolding() when $default != null:
return $default(_that.assetId,_that.shares,_that.averageBuyPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assetId,  int shares, @MoneyConverter()  Money averageBuyPrice)  $default,) {final _that = this;
switch (_that) {
case _CryptoHolding():
return $default(_that.assetId,_that.shares,_that.averageBuyPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assetId,  int shares, @MoneyConverter()  Money averageBuyPrice)?  $default,) {final _that = this;
switch (_that) {
case _CryptoHolding() when $default != null:
return $default(_that.assetId,_that.shares,_that.averageBuyPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CryptoHolding implements CryptoHolding {
  const _CryptoHolding({required this.assetId, required this.shares, @MoneyConverter() required this.averageBuyPrice});
  factory _CryptoHolding.fromJson(Map<String, dynamic> json) => _$CryptoHoldingFromJson(json);

@override final  String assetId;
@override final  int shares;
@override@MoneyConverter() final  Money averageBuyPrice;

/// Create a copy of CryptoHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CryptoHoldingCopyWith<_CryptoHolding> get copyWith => __$CryptoHoldingCopyWithImpl<_CryptoHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CryptoHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CryptoHolding&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,shares,averageBuyPrice);

@override
String toString() {
  return 'CryptoHolding(assetId: $assetId, shares: $shares, averageBuyPrice: $averageBuyPrice)';
}


}

/// @nodoc
abstract mixin class _$CryptoHoldingCopyWith<$Res> implements $CryptoHoldingCopyWith<$Res> {
  factory _$CryptoHoldingCopyWith(_CryptoHolding value, $Res Function(_CryptoHolding) _then) = __$CryptoHoldingCopyWithImpl;
@override @useResult
$Res call({
 String assetId, int shares,@MoneyConverter() Money averageBuyPrice
});




}
/// @nodoc
class __$CryptoHoldingCopyWithImpl<$Res>
    implements _$CryptoHoldingCopyWith<$Res> {
  __$CryptoHoldingCopyWithImpl(this._self, this._then);

  final _CryptoHolding _self;
  final $Res Function(_CryptoHolding) _then;

/// Create a copy of CryptoHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? shares = null,Object? averageBuyPrice = null,}) {
  return _then(_CryptoHolding(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$CryptoQuote {

 String get assetId;@MoneyConverter() Money get pricePerShare; int get onDayIndex;
/// Create a copy of CryptoQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CryptoQuoteCopyWith<CryptoQuote> get copyWith => _$CryptoQuoteCopyWithImpl<CryptoQuote>(this as CryptoQuote, _$identity);

  /// Serializes this CryptoQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CryptoQuote&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'CryptoQuote(assetId: $assetId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class $CryptoQuoteCopyWith<$Res>  {
  factory $CryptoQuoteCopyWith(CryptoQuote value, $Res Function(CryptoQuote) _then) = _$CryptoQuoteCopyWithImpl;
@useResult
$Res call({
 String assetId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class _$CryptoQuoteCopyWithImpl<$Res>
    implements $CryptoQuoteCopyWith<$Res> {
  _$CryptoQuoteCopyWithImpl(this._self, this._then);

  final CryptoQuote _self;
  final $Res Function(CryptoQuote) _then;

/// Create a copy of CryptoQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CryptoQuote].
extension CryptoQuotePatterns on CryptoQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CryptoQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CryptoQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CryptoQuote value)  $default,){
final _that = this;
switch (_that) {
case _CryptoQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CryptoQuote value)?  $default,){
final _that = this;
switch (_that) {
case _CryptoQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String assetId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CryptoQuote() when $default != null:
return $default(_that.assetId,_that.pricePerShare,_that.onDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String assetId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)  $default,) {final _that = this;
switch (_that) {
case _CryptoQuote():
return $default(_that.assetId,_that.pricePerShare,_that.onDayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String assetId, @MoneyConverter()  Money pricePerShare,  int onDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _CryptoQuote() when $default != null:
return $default(_that.assetId,_that.pricePerShare,_that.onDayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CryptoQuote implements CryptoQuote {
  const _CryptoQuote({required this.assetId, @MoneyConverter() required this.pricePerShare, required this.onDayIndex});
  factory _CryptoQuote.fromJson(Map<String, dynamic> json) => _$CryptoQuoteFromJson(json);

@override final  String assetId;
@override@MoneyConverter() final  Money pricePerShare;
@override final  int onDayIndex;

/// Create a copy of CryptoQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CryptoQuoteCopyWith<_CryptoQuote> get copyWith => __$CryptoQuoteCopyWithImpl<_CryptoQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CryptoQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CryptoQuote&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'CryptoQuote(assetId: $assetId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class _$CryptoQuoteCopyWith<$Res> implements $CryptoQuoteCopyWith<$Res> {
  factory _$CryptoQuoteCopyWith(_CryptoQuote value, $Res Function(_CryptoQuote) _then) = __$CryptoQuoteCopyWithImpl;
@override @useResult
$Res call({
 String assetId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class __$CryptoQuoteCopyWithImpl<$Res>
    implements _$CryptoQuoteCopyWith<$Res> {
  __$CryptoQuoteCopyWithImpl(this._self, this._then);

  final _CryptoQuote _self;
  final $Res Function(_CryptoQuote) _then;

/// Create a copy of CryptoQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_CryptoQuote(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
