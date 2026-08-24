// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vorsorge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VorsorgeContract {

 VorsorgeType get type; int get startedOnDayIndex;@MoneyConverter() Money get totalContributed;@MoneyConverter() Money get totalSubsidy;
/// Create a copy of VorsorgeContract
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VorsorgeContractCopyWith<VorsorgeContract> get copyWith => _$VorsorgeContractCopyWithImpl<VorsorgeContract>(this as VorsorgeContract, _$identity);

  /// Serializes this VorsorgeContract to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VorsorgeContract&&(identical(other.type, type) || other.type == type)&&(identical(other.startedOnDayIndex, startedOnDayIndex) || other.startedOnDayIndex == startedOnDayIndex)&&(identical(other.totalContributed, totalContributed) || other.totalContributed == totalContributed)&&(identical(other.totalSubsidy, totalSubsidy) || other.totalSubsidy == totalSubsidy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,startedOnDayIndex,totalContributed,totalSubsidy);

@override
String toString() {
  return 'VorsorgeContract(type: $type, startedOnDayIndex: $startedOnDayIndex, totalContributed: $totalContributed, totalSubsidy: $totalSubsidy)';
}


}

/// @nodoc
abstract mixin class $VorsorgeContractCopyWith<$Res>  {
  factory $VorsorgeContractCopyWith(VorsorgeContract value, $Res Function(VorsorgeContract) _then) = _$VorsorgeContractCopyWithImpl;
@useResult
$Res call({
 VorsorgeType type, int startedOnDayIndex,@MoneyConverter() Money totalContributed,@MoneyConverter() Money totalSubsidy
});




}
/// @nodoc
class _$VorsorgeContractCopyWithImpl<$Res>
    implements $VorsorgeContractCopyWith<$Res> {
  _$VorsorgeContractCopyWithImpl(this._self, this._then);

  final VorsorgeContract _self;
  final $Res Function(VorsorgeContract) _then;

/// Create a copy of VorsorgeContract
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? startedOnDayIndex = null,Object? totalContributed = null,Object? totalSubsidy = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VorsorgeType,startedOnDayIndex: null == startedOnDayIndex ? _self.startedOnDayIndex : startedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int,totalContributed: null == totalContributed ? _self.totalContributed : totalContributed // ignore: cast_nullable_to_non_nullable
as Money,totalSubsidy: null == totalSubsidy ? _self.totalSubsidy : totalSubsidy // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [VorsorgeContract].
extension VorsorgeContractPatterns on VorsorgeContract {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VorsorgeContract value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VorsorgeContract() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VorsorgeContract value)  $default,){
final _that = this;
switch (_that) {
case _VorsorgeContract():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VorsorgeContract value)?  $default,){
final _that = this;
switch (_that) {
case _VorsorgeContract() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VorsorgeType type,  int startedOnDayIndex, @MoneyConverter()  Money totalContributed, @MoneyConverter()  Money totalSubsidy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VorsorgeContract() when $default != null:
return $default(_that.type,_that.startedOnDayIndex,_that.totalContributed,_that.totalSubsidy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VorsorgeType type,  int startedOnDayIndex, @MoneyConverter()  Money totalContributed, @MoneyConverter()  Money totalSubsidy)  $default,) {final _that = this;
switch (_that) {
case _VorsorgeContract():
return $default(_that.type,_that.startedOnDayIndex,_that.totalContributed,_that.totalSubsidy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VorsorgeType type,  int startedOnDayIndex, @MoneyConverter()  Money totalContributed, @MoneyConverter()  Money totalSubsidy)?  $default,) {final _that = this;
switch (_that) {
case _VorsorgeContract() when $default != null:
return $default(_that.type,_that.startedOnDayIndex,_that.totalContributed,_that.totalSubsidy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VorsorgeContract implements VorsorgeContract {
  const _VorsorgeContract({required this.type, required this.startedOnDayIndex, @MoneyConverter() required this.totalContributed, @MoneyConverter() required this.totalSubsidy});
  factory _VorsorgeContract.fromJson(Map<String, dynamic> json) => _$VorsorgeContractFromJson(json);

@override final  VorsorgeType type;
@override final  int startedOnDayIndex;
@override@MoneyConverter() final  Money totalContributed;
@override@MoneyConverter() final  Money totalSubsidy;

/// Create a copy of VorsorgeContract
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VorsorgeContractCopyWith<_VorsorgeContract> get copyWith => __$VorsorgeContractCopyWithImpl<_VorsorgeContract>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VorsorgeContractToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VorsorgeContract&&(identical(other.type, type) || other.type == type)&&(identical(other.startedOnDayIndex, startedOnDayIndex) || other.startedOnDayIndex == startedOnDayIndex)&&(identical(other.totalContributed, totalContributed) || other.totalContributed == totalContributed)&&(identical(other.totalSubsidy, totalSubsidy) || other.totalSubsidy == totalSubsidy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,startedOnDayIndex,totalContributed,totalSubsidy);

@override
String toString() {
  return 'VorsorgeContract(type: $type, startedOnDayIndex: $startedOnDayIndex, totalContributed: $totalContributed, totalSubsidy: $totalSubsidy)';
}


}

/// @nodoc
abstract mixin class _$VorsorgeContractCopyWith<$Res> implements $VorsorgeContractCopyWith<$Res> {
  factory _$VorsorgeContractCopyWith(_VorsorgeContract value, $Res Function(_VorsorgeContract) _then) = __$VorsorgeContractCopyWithImpl;
@override @useResult
$Res call({
 VorsorgeType type, int startedOnDayIndex,@MoneyConverter() Money totalContributed,@MoneyConverter() Money totalSubsidy
});




}
/// @nodoc
class __$VorsorgeContractCopyWithImpl<$Res>
    implements _$VorsorgeContractCopyWith<$Res> {
  __$VorsorgeContractCopyWithImpl(this._self, this._then);

  final _VorsorgeContract _self;
  final $Res Function(_VorsorgeContract) _then;

/// Create a copy of VorsorgeContract
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? startedOnDayIndex = null,Object? totalContributed = null,Object? totalSubsidy = null,}) {
  return _then(_VorsorgeContract(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VorsorgeType,startedOnDayIndex: null == startedOnDayIndex ? _self.startedOnDayIndex : startedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int,totalContributed: null == totalContributed ? _self.totalContributed : totalContributed // ignore: cast_nullable_to_non_nullable
as Money,totalSubsidy: null == totalSubsidy ? _self.totalSubsidy : totalSubsidy // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
