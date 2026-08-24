// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ChatEntry _$ChatEntryFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'npc':
          return NpcEntry.fromJson(
            json
          );
                case 'own':
          return OwnEntry.fromJson(
            json
          );
                case 'system':
          return SystemEntry.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ChatEntry',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ChatEntry {

 String get text;
/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatEntryCopyWith<ChatEntry> get copyWith => _$ChatEntryCopyWithImpl<ChatEntry>(this as ChatEntry, _$identity);

  /// Serializes this ChatEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEntry&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'ChatEntry(text: $text)';
}


}

/// @nodoc
abstract mixin class $ChatEntryCopyWith<$Res>  {
  factory $ChatEntryCopyWith(ChatEntry value, $Res Function(ChatEntry) _then) = _$ChatEntryCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$ChatEntryCopyWithImpl<$Res>
    implements $ChatEntryCopyWith<$Res> {
  _$ChatEntryCopyWithImpl(this._self, this._then);

  final ChatEntry _self;
  final $Res Function(ChatEntry) _then;

/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatEntry].
extension ChatEntryPatterns on ChatEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NpcEntry value)?  npc,TResult Function( OwnEntry value)?  own,TResult Function( SystemEntry value)?  system,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NpcEntry() when npc != null:
return npc(_that);case OwnEntry() when own != null:
return own(_that);case SystemEntry() when system != null:
return system(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NpcEntry value)  npc,required TResult Function( OwnEntry value)  own,required TResult Function( SystemEntry value)  system,}){
final _that = this;
switch (_that) {
case NpcEntry():
return npc(_that);case OwnEntry():
return own(_that);case SystemEntry():
return system(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NpcEntry value)?  npc,TResult? Function( OwnEntry value)?  own,TResult? Function( SystemEntry value)?  system,}){
final _that = this;
switch (_that) {
case NpcEntry() when npc != null:
return npc(_that);case OwnEntry() when own != null:
return own(_that);case SystemEntry() when system != null:
return system(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String speaker,  String text)?  npc,TResult Function( String text)?  own,TResult Function( String text)?  system,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NpcEntry() when npc != null:
return npc(_that.speaker,_that.text);case OwnEntry() when own != null:
return own(_that.text);case SystemEntry() when system != null:
return system(_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String speaker,  String text)  npc,required TResult Function( String text)  own,required TResult Function( String text)  system,}) {final _that = this;
switch (_that) {
case NpcEntry():
return npc(_that.speaker,_that.text);case OwnEntry():
return own(_that.text);case SystemEntry():
return system(_that.text);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String speaker,  String text)?  npc,TResult? Function( String text)?  own,TResult? Function( String text)?  system,}) {final _that = this;
switch (_that) {
case NpcEntry() when npc != null:
return npc(_that.speaker,_that.text);case OwnEntry() when own != null:
return own(_that.text);case SystemEntry() when system != null:
return system(_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class NpcEntry implements ChatEntry {
  const NpcEntry({required this.speaker, required this.text, final  String? $type}): $type = $type ?? 'npc';
  factory NpcEntry.fromJson(Map<String, dynamic> json) => _$NpcEntryFromJson(json);

 final  String speaker;
@override final  String text;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpcEntryCopyWith<NpcEntry> get copyWith => _$NpcEntryCopyWithImpl<NpcEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpcEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpcEntry&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speaker,text);

@override
String toString() {
  return 'ChatEntry.npc(speaker: $speaker, text: $text)';
}


}

/// @nodoc
abstract mixin class $NpcEntryCopyWith<$Res> implements $ChatEntryCopyWith<$Res> {
  factory $NpcEntryCopyWith(NpcEntry value, $Res Function(NpcEntry) _then) = _$NpcEntryCopyWithImpl;
@override @useResult
$Res call({
 String speaker, String text
});




}
/// @nodoc
class _$NpcEntryCopyWithImpl<$Res>
    implements $NpcEntryCopyWith<$Res> {
  _$NpcEntryCopyWithImpl(this._self, this._then);

  final NpcEntry _self;
  final $Res Function(NpcEntry) _then;

/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speaker = null,Object? text = null,}) {
  return _then(NpcEntry(
speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class OwnEntry implements ChatEntry {
  const OwnEntry({required this.text, final  String? $type}): $type = $type ?? 'own';
  factory OwnEntry.fromJson(Map<String, dynamic> json) => _$OwnEntryFromJson(json);

@override final  String text;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnEntryCopyWith<OwnEntry> get copyWith => _$OwnEntryCopyWithImpl<OwnEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnEntry&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'ChatEntry.own(text: $text)';
}


}

/// @nodoc
abstract mixin class $OwnEntryCopyWith<$Res> implements $ChatEntryCopyWith<$Res> {
  factory $OwnEntryCopyWith(OwnEntry value, $Res Function(OwnEntry) _then) = _$OwnEntryCopyWithImpl;
@override @useResult
$Res call({
 String text
});




}
/// @nodoc
class _$OwnEntryCopyWithImpl<$Res>
    implements $OwnEntryCopyWith<$Res> {
  _$OwnEntryCopyWithImpl(this._self, this._then);

  final OwnEntry _self;
  final $Res Function(OwnEntry) _then;

/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(OwnEntry(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SystemEntry implements ChatEntry {
  const SystemEntry({required this.text, final  String? $type}): $type = $type ?? 'system';
  factory SystemEntry.fromJson(Map<String, dynamic> json) => _$SystemEntryFromJson(json);

@override final  String text;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemEntryCopyWith<SystemEntry> get copyWith => _$SystemEntryCopyWithImpl<SystemEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemEntry&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'ChatEntry.system(text: $text)';
}


}

/// @nodoc
abstract mixin class $SystemEntryCopyWith<$Res> implements $ChatEntryCopyWith<$Res> {
  factory $SystemEntryCopyWith(SystemEntry value, $Res Function(SystemEntry) _then) = _$SystemEntryCopyWithImpl;
@override @useResult
$Res call({
 String text
});




}
/// @nodoc
class _$SystemEntryCopyWithImpl<$Res>
    implements $SystemEntryCopyWith<$Res> {
  _$SystemEntryCopyWithImpl(this._self, this._then);

  final SystemEntry _self;
  final $Res Function(SystemEntry) _then;

/// Create a copy of ChatEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(SystemEntry(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
