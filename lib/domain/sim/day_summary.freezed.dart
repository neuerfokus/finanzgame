// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DaySummary {

/// The day that was advanced to.
@GameDayConverter() GameDay get day;/// All events emitted by the pipeline, in pipeline order.
@_DayEventListConverter() List<DayEvent> get events;/// Cash balance before the day's events were applied.
@MoneyConverter() Money get cashBefore;/// Cash balance after the day's events were applied.
@MoneyConverter() Money get cashAfter;/// Savings balance before the day's events were applied.
@MoneyConverter() Money get savingsBefore;/// Savings balance after the day's events were applied.
@MoneyConverter() Money get savingsAfter;
/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DaySummaryCopyWith<DaySummary> get copyWith => _$DaySummaryCopyWithImpl<DaySummary>(this as DaySummary, _$identity);

  /// Serializes this DaySummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DaySummary&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.cashBefore, cashBefore) || other.cashBefore == cashBefore)&&(identical(other.cashAfter, cashAfter) || other.cashAfter == cashAfter)&&(identical(other.savingsBefore, savingsBefore) || other.savingsBefore == savingsBefore)&&(identical(other.savingsAfter, savingsAfter) || other.savingsAfter == savingsAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,const DeepCollectionEquality().hash(events),cashBefore,cashAfter,savingsBefore,savingsAfter);

@override
String toString() {
  return 'DaySummary(day: $day, events: $events, cashBefore: $cashBefore, cashAfter: $cashAfter, savingsBefore: $savingsBefore, savingsAfter: $savingsAfter)';
}


}

/// @nodoc
abstract mixin class $DaySummaryCopyWith<$Res>  {
  factory $DaySummaryCopyWith(DaySummary value, $Res Function(DaySummary) _then) = _$DaySummaryCopyWithImpl;
@useResult
$Res call({
@GameDayConverter() GameDay day,@_DayEventListConverter() List<DayEvent> events,@MoneyConverter() Money cashBefore,@MoneyConverter() Money cashAfter,@MoneyConverter() Money savingsBefore,@MoneyConverter() Money savingsAfter
});


$GameDayCopyWith<$Res> get day;

}
/// @nodoc
class _$DaySummaryCopyWithImpl<$Res>
    implements $DaySummaryCopyWith<$Res> {
  _$DaySummaryCopyWithImpl(this._self, this._then);

  final DaySummary _self;
  final $Res Function(DaySummary) _then;

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? events = null,Object? cashBefore = null,Object? cashAfter = null,Object? savingsBefore = null,Object? savingsAfter = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as GameDay,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<DayEvent>,cashBefore: null == cashBefore ? _self.cashBefore : cashBefore // ignore: cast_nullable_to_non_nullable
as Money,cashAfter: null == cashAfter ? _self.cashAfter : cashAfter // ignore: cast_nullable_to_non_nullable
as Money,savingsBefore: null == savingsBefore ? _self.savingsBefore : savingsBefore // ignore: cast_nullable_to_non_nullable
as Money,savingsAfter: null == savingsAfter ? _self.savingsAfter : savingsAfter // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}
/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameDayCopyWith<$Res> get day {
  
  return $GameDayCopyWith<$Res>(_self.day, (value) {
    return _then(_self.copyWith(day: value));
  });
}
}


/// Adds pattern-matching-related methods to [DaySummary].
extension DaySummaryPatterns on DaySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DaySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DaySummary value)  $default,){
final _that = this;
switch (_that) {
case _DaySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DaySummary value)?  $default,){
final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@GameDayConverter()  GameDay day, @_DayEventListConverter()  List<DayEvent> events, @MoneyConverter()  Money cashBefore, @MoneyConverter()  Money cashAfter, @MoneyConverter()  Money savingsBefore, @MoneyConverter()  Money savingsAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
return $default(_that.day,_that.events,_that.cashBefore,_that.cashAfter,_that.savingsBefore,_that.savingsAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@GameDayConverter()  GameDay day, @_DayEventListConverter()  List<DayEvent> events, @MoneyConverter()  Money cashBefore, @MoneyConverter()  Money cashAfter, @MoneyConverter()  Money savingsBefore, @MoneyConverter()  Money savingsAfter)  $default,) {final _that = this;
switch (_that) {
case _DaySummary():
return $default(_that.day,_that.events,_that.cashBefore,_that.cashAfter,_that.savingsBefore,_that.savingsAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@GameDayConverter()  GameDay day, @_DayEventListConverter()  List<DayEvent> events, @MoneyConverter()  Money cashBefore, @MoneyConverter()  Money cashAfter, @MoneyConverter()  Money savingsBefore, @MoneyConverter()  Money savingsAfter)?  $default,) {final _that = this;
switch (_that) {
case _DaySummary() when $default != null:
return $default(_that.day,_that.events,_that.cashBefore,_that.cashAfter,_that.savingsBefore,_that.savingsAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DaySummary implements DaySummary {
  const _DaySummary({@GameDayConverter() required this.day, @_DayEventListConverter() required final  List<DayEvent> events, @MoneyConverter() required this.cashBefore, @MoneyConverter() required this.cashAfter, @MoneyConverter() required this.savingsBefore, @MoneyConverter() required this.savingsAfter}): _events = events;
  factory _DaySummary.fromJson(Map<String, dynamic> json) => _$DaySummaryFromJson(json);

/// The day that was advanced to.
@override@GameDayConverter() final  GameDay day;
/// All events emitted by the pipeline, in pipeline order.
 final  List<DayEvent> _events;
/// All events emitted by the pipeline, in pipeline order.
@override@_DayEventListConverter() List<DayEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

/// Cash balance before the day's events were applied.
@override@MoneyConverter() final  Money cashBefore;
/// Cash balance after the day's events were applied.
@override@MoneyConverter() final  Money cashAfter;
/// Savings balance before the day's events were applied.
@override@MoneyConverter() final  Money savingsBefore;
/// Savings balance after the day's events were applied.
@override@MoneyConverter() final  Money savingsAfter;

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DaySummaryCopyWith<_DaySummary> get copyWith => __$DaySummaryCopyWithImpl<_DaySummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DaySummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DaySummary&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.cashBefore, cashBefore) || other.cashBefore == cashBefore)&&(identical(other.cashAfter, cashAfter) || other.cashAfter == cashAfter)&&(identical(other.savingsBefore, savingsBefore) || other.savingsBefore == savingsBefore)&&(identical(other.savingsAfter, savingsAfter) || other.savingsAfter == savingsAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,const DeepCollectionEquality().hash(_events),cashBefore,cashAfter,savingsBefore,savingsAfter);

@override
String toString() {
  return 'DaySummary(day: $day, events: $events, cashBefore: $cashBefore, cashAfter: $cashAfter, savingsBefore: $savingsBefore, savingsAfter: $savingsAfter)';
}


}

/// @nodoc
abstract mixin class _$DaySummaryCopyWith<$Res> implements $DaySummaryCopyWith<$Res> {
  factory _$DaySummaryCopyWith(_DaySummary value, $Res Function(_DaySummary) _then) = __$DaySummaryCopyWithImpl;
@override @useResult
$Res call({
@GameDayConverter() GameDay day,@_DayEventListConverter() List<DayEvent> events,@MoneyConverter() Money cashBefore,@MoneyConverter() Money cashAfter,@MoneyConverter() Money savingsBefore,@MoneyConverter() Money savingsAfter
});


@override $GameDayCopyWith<$Res> get day;

}
/// @nodoc
class __$DaySummaryCopyWithImpl<$Res>
    implements _$DaySummaryCopyWith<$Res> {
  __$DaySummaryCopyWithImpl(this._self, this._then);

  final _DaySummary _self;
  final $Res Function(_DaySummary) _then;

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? events = null,Object? cashBefore = null,Object? cashAfter = null,Object? savingsBefore = null,Object? savingsAfter = null,}) {
  return _then(_DaySummary(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as GameDay,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<DayEvent>,cashBefore: null == cashBefore ? _self.cashBefore : cashBefore // ignore: cast_nullable_to_non_nullable
as Money,cashAfter: null == cashAfter ? _self.cashAfter : cashAfter // ignore: cast_nullable_to_non_nullable
as Money,savingsBefore: null == savingsBefore ? _self.savingsBefore : savingsBefore // ignore: cast_nullable_to_non_nullable
as Money,savingsAfter: null == savingsAfter ? _self.savingsAfter : savingsAfter // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

/// Create a copy of DaySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameDayCopyWith<$Res> get day {
  
  return $GameDayCopyWith<$Res>(_self.day, (value) {
    return _then(_self.copyWith(day: value));
  });
}
}

// dart format on
