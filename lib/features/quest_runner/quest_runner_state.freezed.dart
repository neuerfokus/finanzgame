// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_runner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DialogProgress {

 int get stepIndex; int get linesShown;
/// Create a copy of DialogProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogProgressCopyWith<DialogProgress> get copyWith => _$DialogProgressCopyWithImpl<DialogProgress>(this as DialogProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogProgress&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.linesShown, linesShown) || other.linesShown == linesShown));
}


@override
int get hashCode => Object.hash(runtimeType,stepIndex,linesShown);

@override
String toString() {
  return 'DialogProgress(stepIndex: $stepIndex, linesShown: $linesShown)';
}


}

/// @nodoc
abstract mixin class $DialogProgressCopyWith<$Res>  {
  factory $DialogProgressCopyWith(DialogProgress value, $Res Function(DialogProgress) _then) = _$DialogProgressCopyWithImpl;
@useResult
$Res call({
 int stepIndex, int linesShown
});




}
/// @nodoc
class _$DialogProgressCopyWithImpl<$Res>
    implements $DialogProgressCopyWith<$Res> {
  _$DialogProgressCopyWithImpl(this._self, this._then);

  final DialogProgress _self;
  final $Res Function(DialogProgress) _then;

/// Create a copy of DialogProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepIndex = null,Object? linesShown = null,}) {
  return _then(_self.copyWith(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,linesShown: null == linesShown ? _self.linesShown : linesShown // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogProgress].
extension DialogProgressPatterns on DialogProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogProgress value)  $default,){
final _that = this;
switch (_that) {
case _DialogProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogProgress value)?  $default,){
final _that = this;
switch (_that) {
case _DialogProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepIndex,  int linesShown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogProgress() when $default != null:
return $default(_that.stepIndex,_that.linesShown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepIndex,  int linesShown)  $default,) {final _that = this;
switch (_that) {
case _DialogProgress():
return $default(_that.stepIndex,_that.linesShown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepIndex,  int linesShown)?  $default,) {final _that = this;
switch (_that) {
case _DialogProgress() when $default != null:
return $default(_that.stepIndex,_that.linesShown);case _:
  return null;

}
}

}

/// @nodoc


class _DialogProgress implements DialogProgress {
  const _DialogProgress({required this.stepIndex, required this.linesShown});
  

@override final  int stepIndex;
@override final  int linesShown;

/// Create a copy of DialogProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogProgressCopyWith<_DialogProgress> get copyWith => __$DialogProgressCopyWithImpl<_DialogProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogProgress&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.linesShown, linesShown) || other.linesShown == linesShown));
}


@override
int get hashCode => Object.hash(runtimeType,stepIndex,linesShown);

@override
String toString() {
  return 'DialogProgress(stepIndex: $stepIndex, linesShown: $linesShown)';
}


}

/// @nodoc
abstract mixin class _$DialogProgressCopyWith<$Res> implements $DialogProgressCopyWith<$Res> {
  factory _$DialogProgressCopyWith(_DialogProgress value, $Res Function(_DialogProgress) _then) = __$DialogProgressCopyWithImpl;
@override @useResult
$Res call({
 int stepIndex, int linesShown
});




}
/// @nodoc
class __$DialogProgressCopyWithImpl<$Res>
    implements _$DialogProgressCopyWith<$Res> {
  __$DialogProgressCopyWithImpl(this._self, this._then);

  final _DialogProgress _self;
  final $Res Function(_DialogProgress) _then;

/// Create a copy of DialogProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepIndex = null,Object? linesShown = null,}) {
  return _then(_DialogProgress(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,linesShown: null == linesShown ? _self.linesShown : linesShown // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$QuestRunnerState {

 Quest get quest; List<ChatEntry> get chat; int get stepIndex; DialogProgress? get dialog; bool get awaitingInput; bool get finished; bool get questAborted;
/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestRunnerStateCopyWith<QuestRunnerState> get copyWith => _$QuestRunnerStateCopyWithImpl<QuestRunnerState>(this as QuestRunnerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestRunnerState&&(identical(other.quest, quest) || other.quest == quest)&&const DeepCollectionEquality().equals(other.chat, chat)&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.dialog, dialog) || other.dialog == dialog)&&(identical(other.awaitingInput, awaitingInput) || other.awaitingInput == awaitingInput)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.questAborted, questAborted) || other.questAborted == questAborted));
}


@override
int get hashCode => Object.hash(runtimeType,quest,const DeepCollectionEquality().hash(chat),stepIndex,dialog,awaitingInput,finished,questAborted);

@override
String toString() {
  return 'QuestRunnerState(quest: $quest, chat: $chat, stepIndex: $stepIndex, dialog: $dialog, awaitingInput: $awaitingInput, finished: $finished, questAborted: $questAborted)';
}


}

/// @nodoc
abstract mixin class $QuestRunnerStateCopyWith<$Res>  {
  factory $QuestRunnerStateCopyWith(QuestRunnerState value, $Res Function(QuestRunnerState) _then) = _$QuestRunnerStateCopyWithImpl;
@useResult
$Res call({
 Quest quest, List<ChatEntry> chat, int stepIndex, DialogProgress? dialog, bool awaitingInput, bool finished, bool questAborted
});


$QuestCopyWith<$Res> get quest;$DialogProgressCopyWith<$Res>? get dialog;

}
/// @nodoc
class _$QuestRunnerStateCopyWithImpl<$Res>
    implements $QuestRunnerStateCopyWith<$Res> {
  _$QuestRunnerStateCopyWithImpl(this._self, this._then);

  final QuestRunnerState _self;
  final $Res Function(QuestRunnerState) _then;

/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quest = null,Object? chat = null,Object? stepIndex = null,Object? dialog = freezed,Object? awaitingInput = null,Object? finished = null,Object? questAborted = null,}) {
  return _then(_self.copyWith(
quest: null == quest ? _self.quest : quest // ignore: cast_nullable_to_non_nullable
as Quest,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as List<ChatEntry>,stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as DialogProgress?,awaitingInput: null == awaitingInput ? _self.awaitingInput : awaitingInput // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,questAborted: null == questAborted ? _self.questAborted : questAborted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestCopyWith<$Res> get quest {
  
  return $QuestCopyWith<$Res>(_self.quest, (value) {
    return _then(_self.copyWith(quest: value));
  });
}/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DialogProgressCopyWith<$Res>? get dialog {
    if (_self.dialog == null) {
    return null;
  }

  return $DialogProgressCopyWith<$Res>(_self.dialog!, (value) {
    return _then(_self.copyWith(dialog: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuestRunnerState].
extension QuestRunnerStatePatterns on QuestRunnerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestRunnerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestRunnerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestRunnerState value)  $default,){
final _that = this;
switch (_that) {
case _QuestRunnerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestRunnerState value)?  $default,){
final _that = this;
switch (_that) {
case _QuestRunnerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Quest quest,  List<ChatEntry> chat,  int stepIndex,  DialogProgress? dialog,  bool awaitingInput,  bool finished,  bool questAborted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestRunnerState() when $default != null:
return $default(_that.quest,_that.chat,_that.stepIndex,_that.dialog,_that.awaitingInput,_that.finished,_that.questAborted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Quest quest,  List<ChatEntry> chat,  int stepIndex,  DialogProgress? dialog,  bool awaitingInput,  bool finished,  bool questAborted)  $default,) {final _that = this;
switch (_that) {
case _QuestRunnerState():
return $default(_that.quest,_that.chat,_that.stepIndex,_that.dialog,_that.awaitingInput,_that.finished,_that.questAborted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Quest quest,  List<ChatEntry> chat,  int stepIndex,  DialogProgress? dialog,  bool awaitingInput,  bool finished,  bool questAborted)?  $default,) {final _that = this;
switch (_that) {
case _QuestRunnerState() when $default != null:
return $default(_that.quest,_that.chat,_that.stepIndex,_that.dialog,_that.awaitingInput,_that.finished,_that.questAborted);case _:
  return null;

}
}

}

/// @nodoc


class _QuestRunnerState implements QuestRunnerState {
  const _QuestRunnerState({required this.quest, final  List<ChatEntry> chat = const <ChatEntry>[], required this.stepIndex, this.dialog, this.awaitingInput = false, this.finished = false, this.questAborted = false}): _chat = chat;
  

@override final  Quest quest;
 final  List<ChatEntry> _chat;
@override@JsonKey() List<ChatEntry> get chat {
  if (_chat is EqualUnmodifiableListView) return _chat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chat);
}

@override final  int stepIndex;
@override final  DialogProgress? dialog;
@override@JsonKey() final  bool awaitingInput;
@override@JsonKey() final  bool finished;
@override@JsonKey() final  bool questAborted;

/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestRunnerStateCopyWith<_QuestRunnerState> get copyWith => __$QuestRunnerStateCopyWithImpl<_QuestRunnerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestRunnerState&&(identical(other.quest, quest) || other.quest == quest)&&const DeepCollectionEquality().equals(other._chat, _chat)&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.dialog, dialog) || other.dialog == dialog)&&(identical(other.awaitingInput, awaitingInput) || other.awaitingInput == awaitingInput)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.questAborted, questAborted) || other.questAborted == questAborted));
}


@override
int get hashCode => Object.hash(runtimeType,quest,const DeepCollectionEquality().hash(_chat),stepIndex,dialog,awaitingInput,finished,questAborted);

@override
String toString() {
  return 'QuestRunnerState(quest: $quest, chat: $chat, stepIndex: $stepIndex, dialog: $dialog, awaitingInput: $awaitingInput, finished: $finished, questAborted: $questAborted)';
}


}

/// @nodoc
abstract mixin class _$QuestRunnerStateCopyWith<$Res> implements $QuestRunnerStateCopyWith<$Res> {
  factory _$QuestRunnerStateCopyWith(_QuestRunnerState value, $Res Function(_QuestRunnerState) _then) = __$QuestRunnerStateCopyWithImpl;
@override @useResult
$Res call({
 Quest quest, List<ChatEntry> chat, int stepIndex, DialogProgress? dialog, bool awaitingInput, bool finished, bool questAborted
});


@override $QuestCopyWith<$Res> get quest;@override $DialogProgressCopyWith<$Res>? get dialog;

}
/// @nodoc
class __$QuestRunnerStateCopyWithImpl<$Res>
    implements _$QuestRunnerStateCopyWith<$Res> {
  __$QuestRunnerStateCopyWithImpl(this._self, this._then);

  final _QuestRunnerState _self;
  final $Res Function(_QuestRunnerState) _then;

/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quest = null,Object? chat = null,Object? stepIndex = null,Object? dialog = freezed,Object? awaitingInput = null,Object? finished = null,Object? questAborted = null,}) {
  return _then(_QuestRunnerState(
quest: null == quest ? _self.quest : quest // ignore: cast_nullable_to_non_nullable
as Quest,chat: null == chat ? _self._chat : chat // ignore: cast_nullable_to_non_nullable
as List<ChatEntry>,stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as DialogProgress?,awaitingInput: null == awaitingInput ? _self.awaitingInput : awaitingInput // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,questAborted: null == questAborted ? _self.questAborted : questAborted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestCopyWith<$Res> get quest {
  
  return $QuestCopyWith<$Res>(_self.quest, (value) {
    return _then(_self.copyWith(quest: value));
  });
}/// Create a copy of QuestRunnerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DialogProgressCopyWith<$Res>? get dialog {
    if (_self.dialog == null) {
    return null;
  }

  return $DialogProgressCopyWith<$Res>(_self.dialog!, (value) {
    return _then(_self.copyWith(dialog: value));
  });
}
}

// dart format on
