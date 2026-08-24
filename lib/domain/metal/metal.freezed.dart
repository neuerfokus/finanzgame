// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetalHolding {

 String get assetId; int get shares;@MoneyConverter() Money get averageBuyPrice;
/// Create a copy of MetalHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetalHoldingCopyWith<MetalHolding> get copyWith => _$MetalHoldingCopyWithImpl<MetalHolding>(this as MetalHolding, _$identity);

  /// Serializes this MetalHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetalHolding&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,shares,averageBuyPrice);

@override
String toString() {
  return 'MetalHolding(assetId: $assetId, shares: $shares, averageBuyPrice: $averageBuyPrice)';
}


}

/// @nodoc
abstract mixin class $MetalHoldingCopyWith<$Res>  {
  factory $MetalHoldingCopyWith(MetalHolding value, $Res Function(MetalHolding) _then) = _$MetalHoldingCopyWithImpl;
@useResult
$Res call({
 String assetId, int shares,@MoneyConverter() Money averageBuyPrice
});




}
/// @nodoc
class _$MetalHoldingCopyWithImpl<$Res>
    implements $MetalHoldingCopyWith<$Res> {
  _$MetalHoldingCopyWithImpl(this._self, this._then);

  final MetalHolding _self;
  final $Res Function(MetalHolding) _then;

/// Create a copy of MetalHolding
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


/// Adds pattern-matching-related methods to [MetalHolding].
extension MetalHoldingPatterns on MetalHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetalHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetalHolding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetalHolding value)  $default,){
final _that = this;
switch (_that) {
case _MetalHolding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetalHolding value)?  $default,){
final _that = this;
switch (_that) {
case _MetalHolding() when $default != null:
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
case _MetalHolding() when $default != null:
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
case _MetalHolding():
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
case _MetalHolding() when $default != null:
return $default(_that.assetId,_that.shares,_that.averageBuyPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetalHolding implements MetalHolding {
  const _MetalHolding({required this.assetId, required this.shares, @MoneyConverter() required this.averageBuyPrice});
  factory _MetalHolding.fromJson(Map<String, dynamic> json) => _$MetalHoldingFromJson(json);

@override final  String assetId;
@override final  int shares;
@override@MoneyConverter() final  Money averageBuyPrice;

/// Create a copy of MetalHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetalHoldingCopyWith<_MetalHolding> get copyWith => __$MetalHoldingCopyWithImpl<_MetalHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetalHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetalHolding&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.averageBuyPrice, averageBuyPrice) || other.averageBuyPrice == averageBuyPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,shares,averageBuyPrice);

@override
String toString() {
  return 'MetalHolding(assetId: $assetId, shares: $shares, averageBuyPrice: $averageBuyPrice)';
}


}

/// @nodoc
abstract mixin class _$MetalHoldingCopyWith<$Res> implements $MetalHoldingCopyWith<$Res> {
  factory _$MetalHoldingCopyWith(_MetalHolding value, $Res Function(_MetalHolding) _then) = __$MetalHoldingCopyWithImpl;
@override @useResult
$Res call({
 String assetId, int shares,@MoneyConverter() Money averageBuyPrice
});




}
/// @nodoc
class __$MetalHoldingCopyWithImpl<$Res>
    implements _$MetalHoldingCopyWith<$Res> {
  __$MetalHoldingCopyWithImpl(this._self, this._then);

  final _MetalHolding _self;
  final $Res Function(_MetalHolding) _then;

/// Create a copy of MetalHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? shares = null,Object? averageBuyPrice = null,}) {
  return _then(_MetalHolding(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,averageBuyPrice: null == averageBuyPrice ? _self.averageBuyPrice : averageBuyPrice // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}


/// @nodoc
mixin _$MetalQuote {

 String get assetId;@MoneyConverter() Money get pricePerShare; int get onDayIndex;
/// Create a copy of MetalQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetalQuoteCopyWith<MetalQuote> get copyWith => _$MetalQuoteCopyWithImpl<MetalQuote>(this as MetalQuote, _$identity);

  /// Serializes this MetalQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetalQuote&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'MetalQuote(assetId: $assetId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class $MetalQuoteCopyWith<$Res>  {
  factory $MetalQuoteCopyWith(MetalQuote value, $Res Function(MetalQuote) _then) = _$MetalQuoteCopyWithImpl;
@useResult
$Res call({
 String assetId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class _$MetalQuoteCopyWithImpl<$Res>
    implements $MetalQuoteCopyWith<$Res> {
  _$MetalQuoteCopyWithImpl(this._self, this._then);

  final MetalQuote _self;
  final $Res Function(MetalQuote) _then;

/// Create a copy of MetalQuote
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


/// Adds pattern-matching-related methods to [MetalQuote].
extension MetalQuotePatterns on MetalQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetalQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetalQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetalQuote value)  $default,){
final _that = this;
switch (_that) {
case _MetalQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetalQuote value)?  $default,){
final _that = this;
switch (_that) {
case _MetalQuote() when $default != null:
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
case _MetalQuote() when $default != null:
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
case _MetalQuote():
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
case _MetalQuote() when $default != null:
return $default(_that.assetId,_that.pricePerShare,_that.onDayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetalQuote implements MetalQuote {
  const _MetalQuote({required this.assetId, @MoneyConverter() required this.pricePerShare, required this.onDayIndex});
  factory _MetalQuote.fromJson(Map<String, dynamic> json) => _$MetalQuoteFromJson(json);

@override final  String assetId;
@override@MoneyConverter() final  Money pricePerShare;
@override final  int onDayIndex;

/// Create a copy of MetalQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetalQuoteCopyWith<_MetalQuote> get copyWith => __$MetalQuoteCopyWithImpl<_MetalQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetalQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetalQuote&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.pricePerShare, pricePerShare) || other.pricePerShare == pricePerShare)&&(identical(other.onDayIndex, onDayIndex) || other.onDayIndex == onDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,assetId,pricePerShare,onDayIndex);

@override
String toString() {
  return 'MetalQuote(assetId: $assetId, pricePerShare: $pricePerShare, onDayIndex: $onDayIndex)';
}


}

/// @nodoc
abstract mixin class _$MetalQuoteCopyWith<$Res> implements $MetalQuoteCopyWith<$Res> {
  factory _$MetalQuoteCopyWith(_MetalQuote value, $Res Function(_MetalQuote) _then) = __$MetalQuoteCopyWithImpl;
@override @useResult
$Res call({
 String assetId,@MoneyConverter() Money pricePerShare, int onDayIndex
});




}
/// @nodoc
class __$MetalQuoteCopyWithImpl<$Res>
    implements _$MetalQuoteCopyWith<$Res> {
  __$MetalQuoteCopyWithImpl(this._self, this._then);

  final _MetalQuote _self;
  final $Res Function(_MetalQuote) _then;

/// Create a copy of MetalQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? pricePerShare = null,Object? onDayIndex = null,}) {
  return _then(_MetalQuote(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,pricePerShare: null == pricePerShare ? _self.pricePerShare : pricePerShare // ignore: cast_nullable_to_non_nullable
as Money,onDayIndex: null == onDayIndex ? _self.onDayIndex : onDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
