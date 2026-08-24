// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highscore_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HighscoreEntry {

 String get playerName; DateTime get startedAt; DateTime get endedAt; int get finalNetWorthCents; int get finalAgeYears;/// Alter (in Jahren), bei dem Spieler erstmals Millionär wurde.
/// `null`, wenn nie erreicht.
 int? get firstMillionaireAgeYears;/// `null`, wenn nie erreicht.
 int? get firstMillionaireDayIndex;/// Welle-8 Round 20: Vermögen in Cents zum Zeitpunkt des
/// Millionär-Werdens (erste Überschreitung 1 Mio €). Null wenn nie.
 int? get firstMillionaireNetWorthCents;
/// Create a copy of HighscoreEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighscoreEntryCopyWith<HighscoreEntry> get copyWith => _$HighscoreEntryCopyWithImpl<HighscoreEntry>(this as HighscoreEntry, _$identity);

  /// Serializes this HighscoreEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HighscoreEntry&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.finalNetWorthCents, finalNetWorthCents) || other.finalNetWorthCents == finalNetWorthCents)&&(identical(other.finalAgeYears, finalAgeYears) || other.finalAgeYears == finalAgeYears)&&(identical(other.firstMillionaireAgeYears, firstMillionaireAgeYears) || other.firstMillionaireAgeYears == firstMillionaireAgeYears)&&(identical(other.firstMillionaireDayIndex, firstMillionaireDayIndex) || other.firstMillionaireDayIndex == firstMillionaireDayIndex)&&(identical(other.firstMillionaireNetWorthCents, firstMillionaireNetWorthCents) || other.firstMillionaireNetWorthCents == firstMillionaireNetWorthCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerName,startedAt,endedAt,finalNetWorthCents,finalAgeYears,firstMillionaireAgeYears,firstMillionaireDayIndex,firstMillionaireNetWorthCents);

@override
String toString() {
  return 'HighscoreEntry(playerName: $playerName, startedAt: $startedAt, endedAt: $endedAt, finalNetWorthCents: $finalNetWorthCents, finalAgeYears: $finalAgeYears, firstMillionaireAgeYears: $firstMillionaireAgeYears, firstMillionaireDayIndex: $firstMillionaireDayIndex, firstMillionaireNetWorthCents: $firstMillionaireNetWorthCents)';
}


}

/// @nodoc
abstract mixin class $HighscoreEntryCopyWith<$Res>  {
  factory $HighscoreEntryCopyWith(HighscoreEntry value, $Res Function(HighscoreEntry) _then) = _$HighscoreEntryCopyWithImpl;
@useResult
$Res call({
 String playerName, DateTime startedAt, DateTime endedAt, int finalNetWorthCents, int finalAgeYears, int? firstMillionaireAgeYears, int? firstMillionaireDayIndex, int? firstMillionaireNetWorthCents
});




}
/// @nodoc
class _$HighscoreEntryCopyWithImpl<$Res>
    implements $HighscoreEntryCopyWith<$Res> {
  _$HighscoreEntryCopyWithImpl(this._self, this._then);

  final HighscoreEntry _self;
  final $Res Function(HighscoreEntry) _then;

/// Create a copy of HighscoreEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerName = null,Object? startedAt = null,Object? endedAt = null,Object? finalNetWorthCents = null,Object? finalAgeYears = null,Object? firstMillionaireAgeYears = freezed,Object? firstMillionaireDayIndex = freezed,Object? firstMillionaireNetWorthCents = freezed,}) {
  return _then(_self.copyWith(
playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finalNetWorthCents: null == finalNetWorthCents ? _self.finalNetWorthCents : finalNetWorthCents // ignore: cast_nullable_to_non_nullable
as int,finalAgeYears: null == finalAgeYears ? _self.finalAgeYears : finalAgeYears // ignore: cast_nullable_to_non_nullable
as int,firstMillionaireAgeYears: freezed == firstMillionaireAgeYears ? _self.firstMillionaireAgeYears : firstMillionaireAgeYears // ignore: cast_nullable_to_non_nullable
as int?,firstMillionaireDayIndex: freezed == firstMillionaireDayIndex ? _self.firstMillionaireDayIndex : firstMillionaireDayIndex // ignore: cast_nullable_to_non_nullable
as int?,firstMillionaireNetWorthCents: freezed == firstMillionaireNetWorthCents ? _self.firstMillionaireNetWorthCents : firstMillionaireNetWorthCents // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HighscoreEntry].
extension HighscoreEntryPatterns on HighscoreEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HighscoreEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HighscoreEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HighscoreEntry value)  $default,){
final _that = this;
switch (_that) {
case _HighscoreEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HighscoreEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HighscoreEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerName,  DateTime startedAt,  DateTime endedAt,  int finalNetWorthCents,  int finalAgeYears,  int? firstMillionaireAgeYears,  int? firstMillionaireDayIndex,  int? firstMillionaireNetWorthCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HighscoreEntry() when $default != null:
return $default(_that.playerName,_that.startedAt,_that.endedAt,_that.finalNetWorthCents,_that.finalAgeYears,_that.firstMillionaireAgeYears,_that.firstMillionaireDayIndex,_that.firstMillionaireNetWorthCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerName,  DateTime startedAt,  DateTime endedAt,  int finalNetWorthCents,  int finalAgeYears,  int? firstMillionaireAgeYears,  int? firstMillionaireDayIndex,  int? firstMillionaireNetWorthCents)  $default,) {final _that = this;
switch (_that) {
case _HighscoreEntry():
return $default(_that.playerName,_that.startedAt,_that.endedAt,_that.finalNetWorthCents,_that.finalAgeYears,_that.firstMillionaireAgeYears,_that.firstMillionaireDayIndex,_that.firstMillionaireNetWorthCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerName,  DateTime startedAt,  DateTime endedAt,  int finalNetWorthCents,  int finalAgeYears,  int? firstMillionaireAgeYears,  int? firstMillionaireDayIndex,  int? firstMillionaireNetWorthCents)?  $default,) {final _that = this;
switch (_that) {
case _HighscoreEntry() when $default != null:
return $default(_that.playerName,_that.startedAt,_that.endedAt,_that.finalNetWorthCents,_that.finalAgeYears,_that.firstMillionaireAgeYears,_that.firstMillionaireDayIndex,_that.firstMillionaireNetWorthCents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HighscoreEntry implements HighscoreEntry {
  const _HighscoreEntry({required this.playerName, required this.startedAt, required this.endedAt, required this.finalNetWorthCents, required this.finalAgeYears, this.firstMillionaireAgeYears, this.firstMillionaireDayIndex, this.firstMillionaireNetWorthCents});
  factory _HighscoreEntry.fromJson(Map<String, dynamic> json) => _$HighscoreEntryFromJson(json);

@override final  String playerName;
@override final  DateTime startedAt;
@override final  DateTime endedAt;
@override final  int finalNetWorthCents;
@override final  int finalAgeYears;
/// Alter (in Jahren), bei dem Spieler erstmals Millionär wurde.
/// `null`, wenn nie erreicht.
@override final  int? firstMillionaireAgeYears;
/// `null`, wenn nie erreicht.
@override final  int? firstMillionaireDayIndex;
/// Welle-8 Round 20: Vermögen in Cents zum Zeitpunkt des
/// Millionär-Werdens (erste Überschreitung 1 Mio €). Null wenn nie.
@override final  int? firstMillionaireNetWorthCents;

/// Create a copy of HighscoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HighscoreEntryCopyWith<_HighscoreEntry> get copyWith => __$HighscoreEntryCopyWithImpl<_HighscoreEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HighscoreEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HighscoreEntry&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.finalNetWorthCents, finalNetWorthCents) || other.finalNetWorthCents == finalNetWorthCents)&&(identical(other.finalAgeYears, finalAgeYears) || other.finalAgeYears == finalAgeYears)&&(identical(other.firstMillionaireAgeYears, firstMillionaireAgeYears) || other.firstMillionaireAgeYears == firstMillionaireAgeYears)&&(identical(other.firstMillionaireDayIndex, firstMillionaireDayIndex) || other.firstMillionaireDayIndex == firstMillionaireDayIndex)&&(identical(other.firstMillionaireNetWorthCents, firstMillionaireNetWorthCents) || other.firstMillionaireNetWorthCents == firstMillionaireNetWorthCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerName,startedAt,endedAt,finalNetWorthCents,finalAgeYears,firstMillionaireAgeYears,firstMillionaireDayIndex,firstMillionaireNetWorthCents);

@override
String toString() {
  return 'HighscoreEntry(playerName: $playerName, startedAt: $startedAt, endedAt: $endedAt, finalNetWorthCents: $finalNetWorthCents, finalAgeYears: $finalAgeYears, firstMillionaireAgeYears: $firstMillionaireAgeYears, firstMillionaireDayIndex: $firstMillionaireDayIndex, firstMillionaireNetWorthCents: $firstMillionaireNetWorthCents)';
}


}

/// @nodoc
abstract mixin class _$HighscoreEntryCopyWith<$Res> implements $HighscoreEntryCopyWith<$Res> {
  factory _$HighscoreEntryCopyWith(_HighscoreEntry value, $Res Function(_HighscoreEntry) _then) = __$HighscoreEntryCopyWithImpl;
@override @useResult
$Res call({
 String playerName, DateTime startedAt, DateTime endedAt, int finalNetWorthCents, int finalAgeYears, int? firstMillionaireAgeYears, int? firstMillionaireDayIndex, int? firstMillionaireNetWorthCents
});




}
/// @nodoc
class __$HighscoreEntryCopyWithImpl<$Res>
    implements _$HighscoreEntryCopyWith<$Res> {
  __$HighscoreEntryCopyWithImpl(this._self, this._then);

  final _HighscoreEntry _self;
  final $Res Function(_HighscoreEntry) _then;

/// Create a copy of HighscoreEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerName = null,Object? startedAt = null,Object? endedAt = null,Object? finalNetWorthCents = null,Object? finalAgeYears = null,Object? firstMillionaireAgeYears = freezed,Object? firstMillionaireDayIndex = freezed,Object? firstMillionaireNetWorthCents = freezed,}) {
  return _then(_HighscoreEntry(
playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finalNetWorthCents: null == finalNetWorthCents ? _self.finalNetWorthCents : finalNetWorthCents // ignore: cast_nullable_to_non_nullable
as int,finalAgeYears: null == finalAgeYears ? _self.finalAgeYears : finalAgeYears // ignore: cast_nullable_to_non_nullable
as int,firstMillionaireAgeYears: freezed == firstMillionaireAgeYears ? _self.firstMillionaireAgeYears : firstMillionaireAgeYears // ignore: cast_nullable_to_non_nullable
as int?,firstMillionaireDayIndex: freezed == firstMillionaireDayIndex ? _self.firstMillionaireDayIndex : firstMillionaireDayIndex // ignore: cast_nullable_to_non_nullable
as int?,firstMillionaireNetWorthCents: freezed == firstMillionaireNetWorthCents ? _self.firstMillionaireNetWorthCents : firstMillionaireNetWorthCents // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
