// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'real_estate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RealEstateHolding {

 String get specId; int get ownedSinceDayIndex;@MoneyConverter() Money get purchasePrice;/// Drift v39. Default `rented`, damit Bestände aus älteren Spielständen
/// nicht plötzlich Lebenskosten sparen, ohne dass der Spieler das je
/// gewählt hat — er kann jederzeit umschalten.
 RealEstateUsage get usage;
/// Create a copy of RealEstateHolding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RealEstateHoldingCopyWith<RealEstateHolding> get copyWith => _$RealEstateHoldingCopyWithImpl<RealEstateHolding>(this as RealEstateHolding, _$identity);

  /// Serializes this RealEstateHolding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RealEstateHolding&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.ownedSinceDayIndex, ownedSinceDayIndex) || other.ownedSinceDayIndex == ownedSinceDayIndex)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.usage, usage) || other.usage == usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,specId,ownedSinceDayIndex,purchasePrice,usage);

@override
String toString() {
  return 'RealEstateHolding(specId: $specId, ownedSinceDayIndex: $ownedSinceDayIndex, purchasePrice: $purchasePrice, usage: $usage)';
}


}

/// @nodoc
abstract mixin class $RealEstateHoldingCopyWith<$Res>  {
  factory $RealEstateHoldingCopyWith(RealEstateHolding value, $Res Function(RealEstateHolding) _then) = _$RealEstateHoldingCopyWithImpl;
@useResult
$Res call({
 String specId, int ownedSinceDayIndex,@MoneyConverter() Money purchasePrice, RealEstateUsage usage
});




}
/// @nodoc
class _$RealEstateHoldingCopyWithImpl<$Res>
    implements $RealEstateHoldingCopyWith<$Res> {
  _$RealEstateHoldingCopyWithImpl(this._self, this._then);

  final RealEstateHolding _self;
  final $Res Function(RealEstateHolding) _then;

/// Create a copy of RealEstateHolding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specId = null,Object? ownedSinceDayIndex = null,Object? purchasePrice = null,Object? usage = null,}) {
  return _then(_self.copyWith(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,ownedSinceDayIndex: null == ownedSinceDayIndex ? _self.ownedSinceDayIndex : ownedSinceDayIndex // ignore: cast_nullable_to_non_nullable
as int,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Money,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as RealEstateUsage,
  ));
}

}


/// Adds pattern-matching-related methods to [RealEstateHolding].
extension RealEstateHoldingPatterns on RealEstateHolding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RealEstateHolding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RealEstateHolding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RealEstateHolding value)  $default,){
final _that = this;
switch (_that) {
case _RealEstateHolding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RealEstateHolding value)?  $default,){
final _that = this;
switch (_that) {
case _RealEstateHolding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String specId,  int ownedSinceDayIndex, @MoneyConverter()  Money purchasePrice,  RealEstateUsage usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RealEstateHolding() when $default != null:
return $default(_that.specId,_that.ownedSinceDayIndex,_that.purchasePrice,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String specId,  int ownedSinceDayIndex, @MoneyConverter()  Money purchasePrice,  RealEstateUsage usage)  $default,) {final _that = this;
switch (_that) {
case _RealEstateHolding():
return $default(_that.specId,_that.ownedSinceDayIndex,_that.purchasePrice,_that.usage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String specId,  int ownedSinceDayIndex, @MoneyConverter()  Money purchasePrice,  RealEstateUsage usage)?  $default,) {final _that = this;
switch (_that) {
case _RealEstateHolding() when $default != null:
return $default(_that.specId,_that.ownedSinceDayIndex,_that.purchasePrice,_that.usage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RealEstateHolding implements RealEstateHolding {
  const _RealEstateHolding({required this.specId, required this.ownedSinceDayIndex, @MoneyConverter() required this.purchasePrice, this.usage = RealEstateUsage.rented});
  factory _RealEstateHolding.fromJson(Map<String, dynamic> json) => _$RealEstateHoldingFromJson(json);

@override final  String specId;
@override final  int ownedSinceDayIndex;
@override@MoneyConverter() final  Money purchasePrice;
/// Drift v39. Default `rented`, damit Bestände aus älteren Spielständen
/// nicht plötzlich Lebenskosten sparen, ohne dass der Spieler das je
/// gewählt hat — er kann jederzeit umschalten.
@override@JsonKey() final  RealEstateUsage usage;

/// Create a copy of RealEstateHolding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RealEstateHoldingCopyWith<_RealEstateHolding> get copyWith => __$RealEstateHoldingCopyWithImpl<_RealEstateHolding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RealEstateHoldingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RealEstateHolding&&(identical(other.specId, specId) || other.specId == specId)&&(identical(other.ownedSinceDayIndex, ownedSinceDayIndex) || other.ownedSinceDayIndex == ownedSinceDayIndex)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.usage, usage) || other.usage == usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,specId,ownedSinceDayIndex,purchasePrice,usage);

@override
String toString() {
  return 'RealEstateHolding(specId: $specId, ownedSinceDayIndex: $ownedSinceDayIndex, purchasePrice: $purchasePrice, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$RealEstateHoldingCopyWith<$Res> implements $RealEstateHoldingCopyWith<$Res> {
  factory _$RealEstateHoldingCopyWith(_RealEstateHolding value, $Res Function(_RealEstateHolding) _then) = __$RealEstateHoldingCopyWithImpl;
@override @useResult
$Res call({
 String specId, int ownedSinceDayIndex,@MoneyConverter() Money purchasePrice, RealEstateUsage usage
});




}
/// @nodoc
class __$RealEstateHoldingCopyWithImpl<$Res>
    implements _$RealEstateHoldingCopyWith<$Res> {
  __$RealEstateHoldingCopyWithImpl(this._self, this._then);

  final _RealEstateHolding _self;
  final $Res Function(_RealEstateHolding) _then;

/// Create a copy of RealEstateHolding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specId = null,Object? ownedSinceDayIndex = null,Object? purchasePrice = null,Object? usage = null,}) {
  return _then(_RealEstateHolding(
specId: null == specId ? _self.specId : specId // ignore: cast_nullable_to_non_nullable
as String,ownedSinceDayIndex: null == ownedSinceDayIndex ? _self.ownedSinceDayIndex : ownedSinceDayIndex // ignore: cast_nullable_to_non_nullable
as int,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as Money,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as RealEstateUsage,
  ));
}


}

// dart format on
