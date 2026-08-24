// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsPlan {

 String get id; String get assetClass;// 'etf', 'stock', 'crypto'
 String get assetId;@MoneyConverter() Money get monthly; int get startedOnDayIndex;
/// Create a copy of SavingsPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsPlanCopyWith<SavingsPlan> get copyWith => _$SavingsPlanCopyWithImpl<SavingsPlan>(this as SavingsPlan, _$identity);

  /// Serializes this SavingsPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.assetClass, assetClass) || other.assetClass == assetClass)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.monthly, monthly) || other.monthly == monthly)&&(identical(other.startedOnDayIndex, startedOnDayIndex) || other.startedOnDayIndex == startedOnDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetClass,assetId,monthly,startedOnDayIndex);

@override
String toString() {
  return 'SavingsPlan(id: $id, assetClass: $assetClass, assetId: $assetId, monthly: $monthly, startedOnDayIndex: $startedOnDayIndex)';
}


}

/// @nodoc
abstract mixin class $SavingsPlanCopyWith<$Res>  {
  factory $SavingsPlanCopyWith(SavingsPlan value, $Res Function(SavingsPlan) _then) = _$SavingsPlanCopyWithImpl;
@useResult
$Res call({
 String id, String assetClass, String assetId,@MoneyConverter() Money monthly, int startedOnDayIndex
});




}
/// @nodoc
class _$SavingsPlanCopyWithImpl<$Res>
    implements $SavingsPlanCopyWith<$Res> {
  _$SavingsPlanCopyWithImpl(this._self, this._then);

  final SavingsPlan _self;
  final $Res Function(SavingsPlan) _then;

/// Create a copy of SavingsPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetClass = null,Object? assetId = null,Object? monthly = null,Object? startedOnDayIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetClass: null == assetClass ? _self.assetClass : assetClass // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,monthly: null == monthly ? _self.monthly : monthly // ignore: cast_nullable_to_non_nullable
as Money,startedOnDayIndex: null == startedOnDayIndex ? _self.startedOnDayIndex : startedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingsPlan].
extension SavingsPlanPatterns on SavingsPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingsPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingsPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingsPlan value)  $default,){
final _that = this;
switch (_that) {
case _SavingsPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingsPlan value)?  $default,){
final _that = this;
switch (_that) {
case _SavingsPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetClass,  String assetId, @MoneyConverter()  Money monthly,  int startedOnDayIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingsPlan() when $default != null:
return $default(_that.id,_that.assetClass,_that.assetId,_that.monthly,_that.startedOnDayIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetClass,  String assetId, @MoneyConverter()  Money monthly,  int startedOnDayIndex)  $default,) {final _that = this;
switch (_that) {
case _SavingsPlan():
return $default(_that.id,_that.assetClass,_that.assetId,_that.monthly,_that.startedOnDayIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetClass,  String assetId, @MoneyConverter()  Money monthly,  int startedOnDayIndex)?  $default,) {final _that = this;
switch (_that) {
case _SavingsPlan() when $default != null:
return $default(_that.id,_that.assetClass,_that.assetId,_that.monthly,_that.startedOnDayIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingsPlan implements SavingsPlan {
  const _SavingsPlan({required this.id, required this.assetClass, required this.assetId, @MoneyConverter() required this.monthly, required this.startedOnDayIndex});
  factory _SavingsPlan.fromJson(Map<String, dynamic> json) => _$SavingsPlanFromJson(json);

@override final  String id;
@override final  String assetClass;
// 'etf', 'stock', 'crypto'
@override final  String assetId;
@override@MoneyConverter() final  Money monthly;
@override final  int startedOnDayIndex;

/// Create a copy of SavingsPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingsPlanCopyWith<_SavingsPlan> get copyWith => __$SavingsPlanCopyWithImpl<_SavingsPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingsPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingsPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.assetClass, assetClass) || other.assetClass == assetClass)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.monthly, monthly) || other.monthly == monthly)&&(identical(other.startedOnDayIndex, startedOnDayIndex) || other.startedOnDayIndex == startedOnDayIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetClass,assetId,monthly,startedOnDayIndex);

@override
String toString() {
  return 'SavingsPlan(id: $id, assetClass: $assetClass, assetId: $assetId, monthly: $monthly, startedOnDayIndex: $startedOnDayIndex)';
}


}

/// @nodoc
abstract mixin class _$SavingsPlanCopyWith<$Res> implements $SavingsPlanCopyWith<$Res> {
  factory _$SavingsPlanCopyWith(_SavingsPlan value, $Res Function(_SavingsPlan) _then) = __$SavingsPlanCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetClass, String assetId,@MoneyConverter() Money monthly, int startedOnDayIndex
});




}
/// @nodoc
class __$SavingsPlanCopyWithImpl<$Res>
    implements _$SavingsPlanCopyWith<$Res> {
  __$SavingsPlanCopyWithImpl(this._self, this._then);

  final _SavingsPlan _self;
  final $Res Function(_SavingsPlan) _then;

/// Create a copy of SavingsPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetClass = null,Object? assetId = null,Object? monthly = null,Object? startedOnDayIndex = null,}) {
  return _then(_SavingsPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetClass: null == assetClass ? _self.assetClass : assetClass // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,monthly: null == monthly ? _self.monthly : monthly // ignore: cast_nullable_to_non_nullable
as Money,startedOnDayIndex: null == startedOnDayIndex ? _self.startedOnDayIndex : startedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
