// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Plant {

 String get id; String get islandId; int get plotIndex; PlantKind get kind; int get plantedOnDayIndex; int get currentStage; int get growthProgress; PlantStatus get status;
/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantCopyWith<Plant> get copyWith => _$PlantCopyWithImpl<Plant>(this as Plant, _$identity);

  /// Serializes this Plant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plant&&(identical(other.id, id) || other.id == id)&&(identical(other.islandId, islandId) || other.islandId == islandId)&&(identical(other.plotIndex, plotIndex) || other.plotIndex == plotIndex)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.plantedOnDayIndex, plantedOnDayIndex) || other.plantedOnDayIndex == plantedOnDayIndex)&&(identical(other.currentStage, currentStage) || other.currentStage == currentStage)&&(identical(other.growthProgress, growthProgress) || other.growthProgress == growthProgress)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,islandId,plotIndex,kind,plantedOnDayIndex,currentStage,growthProgress,status);

@override
String toString() {
  return 'Plant(id: $id, islandId: $islandId, plotIndex: $plotIndex, kind: $kind, plantedOnDayIndex: $plantedOnDayIndex, currentStage: $currentStage, growthProgress: $growthProgress, status: $status)';
}


}

/// @nodoc
abstract mixin class $PlantCopyWith<$Res>  {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) _then) = _$PlantCopyWithImpl;
@useResult
$Res call({
 String id, String islandId, int plotIndex, PlantKind kind, int plantedOnDayIndex, int currentStage, int growthProgress, PlantStatus status
});




}
/// @nodoc
class _$PlantCopyWithImpl<$Res>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._self, this._then);

  final Plant _self;
  final $Res Function(Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? islandId = null,Object? plotIndex = null,Object? kind = null,Object? plantedOnDayIndex = null,Object? currentStage = null,Object? growthProgress = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,islandId: null == islandId ? _self.islandId : islandId // ignore: cast_nullable_to_non_nullable
as String,plotIndex: null == plotIndex ? _self.plotIndex : plotIndex // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PlantKind,plantedOnDayIndex: null == plantedOnDayIndex ? _self.plantedOnDayIndex : plantedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int,currentStage: null == currentStage ? _self.currentStage : currentStage // ignore: cast_nullable_to_non_nullable
as int,growthProgress: null == growthProgress ? _self.growthProgress : growthProgress // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlantStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Plant].
extension PlantPatterns on Plant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Plant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Plant value)  $default,){
final _that = this;
switch (_that) {
case _Plant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Plant value)?  $default,){
final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String islandId,  int plotIndex,  PlantKind kind,  int plantedOnDayIndex,  int currentStage,  int growthProgress,  PlantStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.islandId,_that.plotIndex,_that.kind,_that.plantedOnDayIndex,_that.currentStage,_that.growthProgress,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String islandId,  int plotIndex,  PlantKind kind,  int plantedOnDayIndex,  int currentStage,  int growthProgress,  PlantStatus status)  $default,) {final _that = this;
switch (_that) {
case _Plant():
return $default(_that.id,_that.islandId,_that.plotIndex,_that.kind,_that.plantedOnDayIndex,_that.currentStage,_that.growthProgress,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String islandId,  int plotIndex,  PlantKind kind,  int plantedOnDayIndex,  int currentStage,  int growthProgress,  PlantStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.islandId,_that.plotIndex,_that.kind,_that.plantedOnDayIndex,_that.currentStage,_that.growthProgress,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Plant implements Plant {
  const _Plant({required this.id, required this.islandId, required this.plotIndex, required this.kind, required this.plantedOnDayIndex, this.currentStage = 0, this.growthProgress = 0, this.status = PlantStatus.growing});
  factory _Plant.fromJson(Map<String, dynamic> json) => _$PlantFromJson(json);

@override final  String id;
@override final  String islandId;
@override final  int plotIndex;
@override final  PlantKind kind;
@override final  int plantedOnDayIndex;
@override@JsonKey() final  int currentStage;
@override@JsonKey() final  int growthProgress;
@override@JsonKey() final  PlantStatus status;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantCopyWith<_Plant> get copyWith => __$PlantCopyWithImpl<_Plant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plant&&(identical(other.id, id) || other.id == id)&&(identical(other.islandId, islandId) || other.islandId == islandId)&&(identical(other.plotIndex, plotIndex) || other.plotIndex == plotIndex)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.plantedOnDayIndex, plantedOnDayIndex) || other.plantedOnDayIndex == plantedOnDayIndex)&&(identical(other.currentStage, currentStage) || other.currentStage == currentStage)&&(identical(other.growthProgress, growthProgress) || other.growthProgress == growthProgress)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,islandId,plotIndex,kind,plantedOnDayIndex,currentStage,growthProgress,status);

@override
String toString() {
  return 'Plant(id: $id, islandId: $islandId, plotIndex: $plotIndex, kind: $kind, plantedOnDayIndex: $plantedOnDayIndex, currentStage: $currentStage, growthProgress: $growthProgress, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PlantCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$PlantCopyWith(_Plant value, $Res Function(_Plant) _then) = __$PlantCopyWithImpl;
@override @useResult
$Res call({
 String id, String islandId, int plotIndex, PlantKind kind, int plantedOnDayIndex, int currentStage, int growthProgress, PlantStatus status
});




}
/// @nodoc
class __$PlantCopyWithImpl<$Res>
    implements _$PlantCopyWith<$Res> {
  __$PlantCopyWithImpl(this._self, this._then);

  final _Plant _self;
  final $Res Function(_Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? islandId = null,Object? plotIndex = null,Object? kind = null,Object? plantedOnDayIndex = null,Object? currentStage = null,Object? growthProgress = null,Object? status = null,}) {
  return _then(_Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,islandId: null == islandId ? _self.islandId : islandId // ignore: cast_nullable_to_non_nullable
as String,plotIndex: null == plotIndex ? _self.plotIndex : plotIndex // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PlantKind,plantedOnDayIndex: null == plantedOnDayIndex ? _self.plantedOnDayIndex : plantedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int,currentStage: null == currentStage ? _self.currentStage : currentStage // ignore: cast_nullable_to_non_nullable
as int,growthProgress: null == growthProgress ? _self.growthProgress : growthProgress // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlantStatus,
  ));
}


}

// dart format on
