// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameDay {

/// 0-based day counter. 0 = first game day after onboarding.
 int get dayIndex;/// Day of the week derived from [dayIndex].
 Weekday get weekday;/// `dayIndex ~/ 7` — 0-based week counter.
 int get weekIndex;/// `dayIndex ~/ 30` — 0-based month counter.
 int get monthIndex;/// `dayIndex ~/ 365` — 0-based year counter.
 int get yearIndex;
/// Create a copy of GameDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameDayCopyWith<GameDay> get copyWith => _$GameDayCopyWithImpl<GameDay>(this as GameDay, _$identity);

  /// Serializes this GameDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameDay&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.weekIndex, weekIndex) || other.weekIndex == weekIndex)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.yearIndex, yearIndex) || other.yearIndex == yearIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayIndex,weekday,weekIndex,monthIndex,yearIndex);

@override
String toString() {
  return 'GameDay(dayIndex: $dayIndex, weekday: $weekday, weekIndex: $weekIndex, monthIndex: $monthIndex, yearIndex: $yearIndex)';
}


}

/// @nodoc
abstract mixin class $GameDayCopyWith<$Res>  {
  factory $GameDayCopyWith(GameDay value, $Res Function(GameDay) _then) = _$GameDayCopyWithImpl;
@useResult
$Res call({
 int dayIndex, Weekday weekday, int weekIndex, int monthIndex, int yearIndex
});




}
/// @nodoc
class _$GameDayCopyWithImpl<$Res>
    implements $GameDayCopyWith<$Res> {
  _$GameDayCopyWithImpl(this._self, this._then);

  final GameDay _self;
  final $Res Function(GameDay) _then;

/// Create a copy of GameDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayIndex = null,Object? weekday = null,Object? weekIndex = null,Object? monthIndex = null,Object? yearIndex = null,}) {
  return _then(_self.copyWith(
dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as Weekday,weekIndex: null == weekIndex ? _self.weekIndex : weekIndex // ignore: cast_nullable_to_non_nullable
as int,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,yearIndex: null == yearIndex ? _self.yearIndex : yearIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GameDay].
extension GameDayPatterns on GameDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameDay value)  $default,){
final _that = this;
switch (_that) {
case _GameDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameDay value)?  $default,){
final _that = this;
switch (_that) {
case _GameDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayIndex,  Weekday weekday,  int weekIndex,  int monthIndex,  int yearIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameDay() when $default != null:
return $default(_that.dayIndex,_that.weekday,_that.weekIndex,_that.monthIndex,_that.yearIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayIndex,  Weekday weekday,  int weekIndex,  int monthIndex,  int yearIndex)  $default,) {final _that = this;
switch (_that) {
case _GameDay():
return $default(_that.dayIndex,_that.weekday,_that.weekIndex,_that.monthIndex,_that.yearIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayIndex,  Weekday weekday,  int weekIndex,  int monthIndex,  int yearIndex)?  $default,) {final _that = this;
switch (_that) {
case _GameDay() when $default != null:
return $default(_that.dayIndex,_that.weekday,_that.weekIndex,_that.monthIndex,_that.yearIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameDay implements GameDay {
  const _GameDay({required this.dayIndex, required this.weekday, required this.weekIndex, required this.monthIndex, required this.yearIndex});
  factory _GameDay.fromJson(Map<String, dynamic> json) => _$GameDayFromJson(json);

/// 0-based day counter. 0 = first game day after onboarding.
@override final  int dayIndex;
/// Day of the week derived from [dayIndex].
@override final  Weekday weekday;
/// `dayIndex ~/ 7` — 0-based week counter.
@override final  int weekIndex;
/// `dayIndex ~/ 30` — 0-based month counter.
@override final  int monthIndex;
/// `dayIndex ~/ 365` — 0-based year counter.
@override final  int yearIndex;

/// Create a copy of GameDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameDayCopyWith<_GameDay> get copyWith => __$GameDayCopyWithImpl<_GameDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameDay&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.weekIndex, weekIndex) || other.weekIndex == weekIndex)&&(identical(other.monthIndex, monthIndex) || other.monthIndex == monthIndex)&&(identical(other.yearIndex, yearIndex) || other.yearIndex == yearIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayIndex,weekday,weekIndex,monthIndex,yearIndex);

@override
String toString() {
  return 'GameDay(dayIndex: $dayIndex, weekday: $weekday, weekIndex: $weekIndex, monthIndex: $monthIndex, yearIndex: $yearIndex)';
}


}

/// @nodoc
abstract mixin class _$GameDayCopyWith<$Res> implements $GameDayCopyWith<$Res> {
  factory _$GameDayCopyWith(_GameDay value, $Res Function(_GameDay) _then) = __$GameDayCopyWithImpl;
@override @useResult
$Res call({
 int dayIndex, Weekday weekday, int weekIndex, int monthIndex, int yearIndex
});




}
/// @nodoc
class __$GameDayCopyWithImpl<$Res>
    implements _$GameDayCopyWith<$Res> {
  __$GameDayCopyWithImpl(this._self, this._then);

  final _GameDay _self;
  final $Res Function(_GameDay) _then;

/// Create a copy of GameDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayIndex = null,Object? weekday = null,Object? weekIndex = null,Object? monthIndex = null,Object? yearIndex = null,}) {
  return _then(_GameDay(
dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as Weekday,weekIndex: null == weekIndex ? _self.weekIndex : weekIndex // ignore: cast_nullable_to_non_nullable
as int,monthIndex: null == monthIndex ? _self.monthIndex : monthIndex // ignore: cast_nullable_to_non_nullable
as int,yearIndex: null == yearIndex ? _self.yearIndex : yearIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
