// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestOption {

 String get id; String get label;
/// Create a copy of QuestOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestOptionCopyWith<QuestOption> get copyWith => _$QuestOptionCopyWithImpl<QuestOption>(this as QuestOption, _$identity);

  /// Serializes this QuestOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label);

@override
String toString() {
  return 'QuestOption(id: $id, label: $label)';
}


}

/// @nodoc
abstract mixin class $QuestOptionCopyWith<$Res>  {
  factory $QuestOptionCopyWith(QuestOption value, $Res Function(QuestOption) _then) = _$QuestOptionCopyWithImpl;
@useResult
$Res call({
 String id, String label
});




}
/// @nodoc
class _$QuestOptionCopyWithImpl<$Res>
    implements $QuestOptionCopyWith<$Res> {
  _$QuestOptionCopyWithImpl(this._self, this._then);

  final QuestOption _self;
  final $Res Function(QuestOption) _then;

/// Create a copy of QuestOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestOption].
extension QuestOptionPatterns on QuestOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestOption value)  $default,){
final _that = this;
switch (_that) {
case _QuestOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestOption value)?  $default,){
final _that = this;
switch (_that) {
case _QuestOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestOption() when $default != null:
return $default(_that.id,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label)  $default,) {final _that = this;
switch (_that) {
case _QuestOption():
return $default(_that.id,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label)?  $default,) {final _that = this;
switch (_that) {
case _QuestOption() when $default != null:
return $default(_that.id,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestOption implements QuestOption {
  const _QuestOption({required this.id, required this.label});
  factory _QuestOption.fromJson(Map<String, dynamic> json) => _$QuestOptionFromJson(json);

@override final  String id;
@override final  String label;

/// Create a copy of QuestOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestOptionCopyWith<_QuestOption> get copyWith => __$QuestOptionCopyWithImpl<_QuestOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestOption&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label);

@override
String toString() {
  return 'QuestOption(id: $id, label: $label)';
}


}

/// @nodoc
abstract mixin class _$QuestOptionCopyWith<$Res> implements $QuestOptionCopyWith<$Res> {
  factory _$QuestOptionCopyWith(_QuestOption value, $Res Function(_QuestOption) _then) = __$QuestOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String label
});




}
/// @nodoc
class __$QuestOptionCopyWithImpl<$Res>
    implements _$QuestOptionCopyWith<$Res> {
  __$QuestOptionCopyWithImpl(this._self, this._then);

  final _QuestOption _self;
  final $Res Function(_QuestOption) _then;

/// Create a copy of QuestOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,}) {
  return _then(_QuestOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuestReward {

@MoneyConverter() Money get cash; int get xp;
/// Create a copy of QuestReward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestRewardCopyWith<QuestReward> get copyWith => _$QuestRewardCopyWithImpl<QuestReward>(this as QuestReward, _$identity);

  /// Serializes this QuestReward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestReward&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.xp, xp) || other.xp == xp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cash,xp);

@override
String toString() {
  return 'QuestReward(cash: $cash, xp: $xp)';
}


}

/// @nodoc
abstract mixin class $QuestRewardCopyWith<$Res>  {
  factory $QuestRewardCopyWith(QuestReward value, $Res Function(QuestReward) _then) = _$QuestRewardCopyWithImpl;
@useResult
$Res call({
@MoneyConverter() Money cash, int xp
});




}
/// @nodoc
class _$QuestRewardCopyWithImpl<$Res>
    implements $QuestRewardCopyWith<$Res> {
  _$QuestRewardCopyWithImpl(this._self, this._then);

  final QuestReward _self;
  final $Res Function(QuestReward) _then;

/// Create a copy of QuestReward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cash = null,Object? xp = null,}) {
  return _then(_self.copyWith(
cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as Money,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestReward].
extension QuestRewardPatterns on QuestReward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestReward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestReward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestReward value)  $default,){
final _that = this;
switch (_that) {
case _QuestReward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestReward value)?  $default,){
final _that = this;
switch (_that) {
case _QuestReward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@MoneyConverter()  Money cash,  int xp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestReward() when $default != null:
return $default(_that.cash,_that.xp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@MoneyConverter()  Money cash,  int xp)  $default,) {final _that = this;
switch (_that) {
case _QuestReward():
return $default(_that.cash,_that.xp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@MoneyConverter()  Money cash,  int xp)?  $default,) {final _that = this;
switch (_that) {
case _QuestReward() when $default != null:
return $default(_that.cash,_that.xp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestReward implements QuestReward {
  const _QuestReward({@MoneyConverter() required this.cash, this.xp = 0});
  factory _QuestReward.fromJson(Map<String, dynamic> json) => _$QuestRewardFromJson(json);

@override@MoneyConverter() final  Money cash;
@override@JsonKey() final  int xp;

/// Create a copy of QuestReward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestRewardCopyWith<_QuestReward> get copyWith => __$QuestRewardCopyWithImpl<_QuestReward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestRewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestReward&&(identical(other.cash, cash) || other.cash == cash)&&(identical(other.xp, xp) || other.xp == xp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cash,xp);

@override
String toString() {
  return 'QuestReward(cash: $cash, xp: $xp)';
}


}

/// @nodoc
abstract mixin class _$QuestRewardCopyWith<$Res> implements $QuestRewardCopyWith<$Res> {
  factory _$QuestRewardCopyWith(_QuestReward value, $Res Function(_QuestReward) _then) = __$QuestRewardCopyWithImpl;
@override @useResult
$Res call({
@MoneyConverter() Money cash, int xp
});




}
/// @nodoc
class __$QuestRewardCopyWithImpl<$Res>
    implements _$QuestRewardCopyWith<$Res> {
  __$QuestRewardCopyWithImpl(this._self, this._then);

  final _QuestReward _self;
  final $Res Function(_QuestReward) _then;

/// Create a copy of QuestReward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cash = null,Object? xp = null,}) {
  return _then(_QuestReward(
cash: null == cash ? _self.cash : cash // ignore: cast_nullable_to_non_nullable
as Money,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

QuestStep _$QuestStepFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'dialog':
          return DialogStep.fromJson(
            json
          );
                case 'quiz':
          return QuizStep.fromJson(
            json
          );
                case 'choice':
          return ChoiceStep.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'QuestStep',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$QuestStep {

 String get id;
/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestStepCopyWith<QuestStep> get copyWith => _$QuestStepCopyWithImpl<QuestStep>(this as QuestStep, _$identity);

  /// Serializes this QuestStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestStep&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'QuestStep(id: $id)';
}


}

/// @nodoc
abstract mixin class $QuestStepCopyWith<$Res>  {
  factory $QuestStepCopyWith(QuestStep value, $Res Function(QuestStep) _then) = _$QuestStepCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$QuestStepCopyWithImpl<$Res>
    implements $QuestStepCopyWith<$Res> {
  _$QuestStepCopyWithImpl(this._self, this._then);

  final QuestStep _self;
  final $Res Function(QuestStep) _then;

/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestStep].
extension QuestStepPatterns on QuestStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DialogStep value)?  dialog,TResult Function( QuizStep value)?  quiz,TResult Function( ChoiceStep value)?  choice,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DialogStep() when dialog != null:
return dialog(_that);case QuizStep() when quiz != null:
return quiz(_that);case ChoiceStep() when choice != null:
return choice(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DialogStep value)  dialog,required TResult Function( QuizStep value)  quiz,required TResult Function( ChoiceStep value)  choice,}){
final _that = this;
switch (_that) {
case DialogStep():
return dialog(_that);case QuizStep():
return quiz(_that);case ChoiceStep():
return choice(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DialogStep value)?  dialog,TResult? Function( QuizStep value)?  quiz,TResult? Function( ChoiceStep value)?  choice,}){
final _that = this;
switch (_that) {
case DialogStep() when dialog != null:
return dialog(_that);case QuizStep() when quiz != null:
return quiz(_that);case ChoiceStep() when choice != null:
return choice(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String speaker,  List<String> lines)?  dialog,TResult Function( String id,  String question,  List<QuestOption> options,  String correctId,  String? explanation)?  quiz,TResult Function( String id,  String prompt,  List<QuestOption> options)?  choice,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DialogStep() when dialog != null:
return dialog(_that.id,_that.speaker,_that.lines);case QuizStep() when quiz != null:
return quiz(_that.id,_that.question,_that.options,_that.correctId,_that.explanation);case ChoiceStep() when choice != null:
return choice(_that.id,_that.prompt,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String speaker,  List<String> lines)  dialog,required TResult Function( String id,  String question,  List<QuestOption> options,  String correctId,  String? explanation)  quiz,required TResult Function( String id,  String prompt,  List<QuestOption> options)  choice,}) {final _that = this;
switch (_that) {
case DialogStep():
return dialog(_that.id,_that.speaker,_that.lines);case QuizStep():
return quiz(_that.id,_that.question,_that.options,_that.correctId,_that.explanation);case ChoiceStep():
return choice(_that.id,_that.prompt,_that.options);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String speaker,  List<String> lines)?  dialog,TResult? Function( String id,  String question,  List<QuestOption> options,  String correctId,  String? explanation)?  quiz,TResult? Function( String id,  String prompt,  List<QuestOption> options)?  choice,}) {final _that = this;
switch (_that) {
case DialogStep() when dialog != null:
return dialog(_that.id,_that.speaker,_that.lines);case QuizStep() when quiz != null:
return quiz(_that.id,_that.question,_that.options,_that.correctId,_that.explanation);case ChoiceStep() when choice != null:
return choice(_that.id,_that.prompt,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class DialogStep implements QuestStep {
  const DialogStep({required this.id, required this.speaker, required final  List<String> lines, final  String? $type}): _lines = lines,$type = $type ?? 'dialog';
  factory DialogStep.fromJson(Map<String, dynamic> json) => _$DialogStepFromJson(json);

@override final  String id;
 final  String speaker;
 final  List<String> _lines;
 List<String> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogStepCopyWith<DialogStep> get copyWith => _$DialogStepCopyWithImpl<DialogStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogStep&&(identical(other.id, id) || other.id == id)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,speaker,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'QuestStep.dialog(id: $id, speaker: $speaker, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $DialogStepCopyWith<$Res> implements $QuestStepCopyWith<$Res> {
  factory $DialogStepCopyWith(DialogStep value, $Res Function(DialogStep) _then) = _$DialogStepCopyWithImpl;
@override @useResult
$Res call({
 String id, String speaker, List<String> lines
});




}
/// @nodoc
class _$DialogStepCopyWithImpl<$Res>
    implements $DialogStepCopyWith<$Res> {
  _$DialogStepCopyWithImpl(this._self, this._then);

  final DialogStep _self;
  final $Res Function(DialogStep) _then;

/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? speaker = null,Object? lines = null,}) {
  return _then(DialogStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class QuizStep implements QuestStep {
  const QuizStep({required this.id, required this.question, required final  List<QuestOption> options, required this.correctId, this.explanation, final  String? $type}): _options = options,$type = $type ?? 'quiz';
  factory QuizStep.fromJson(Map<String, dynamic> json) => _$QuizStepFromJson(json);

@override final  String id;
 final  String question;
 final  List<QuestOption> _options;
 List<QuestOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  String correctId;
 final  String? explanation;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizStepCopyWith<QuizStep> get copyWith => _$QuizStepCopyWithImpl<QuizStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizStep&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctId, correctId) || other.correctId == correctId)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(_options),correctId,explanation);

@override
String toString() {
  return 'QuestStep.quiz(id: $id, question: $question, options: $options, correctId: $correctId, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $QuizStepCopyWith<$Res> implements $QuestStepCopyWith<$Res> {
  factory $QuizStepCopyWith(QuizStep value, $Res Function(QuizStep) _then) = _$QuizStepCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, List<QuestOption> options, String correctId, String? explanation
});




}
/// @nodoc
class _$QuizStepCopyWithImpl<$Res>
    implements $QuizStepCopyWith<$Res> {
  _$QuizStepCopyWithImpl(this._self, this._then);

  final QuizStep _self;
  final $Res Function(QuizStep) _then;

/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? options = null,Object? correctId = null,Object? explanation = freezed,}) {
  return _then(QuizStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestOption>,correctId: null == correctId ? _self.correctId : correctId // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChoiceStep implements QuestStep {
  const ChoiceStep({required this.id, required this.prompt, required final  List<QuestOption> options, final  String? $type}): _options = options,$type = $type ?? 'choice';
  factory ChoiceStep.fromJson(Map<String, dynamic> json) => _$ChoiceStepFromJson(json);

@override final  String id;
 final  String prompt;
 final  List<QuestOption> _options;
 List<QuestOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceStepCopyWith<ChoiceStep> get copyWith => _$ChoiceStepCopyWithImpl<ChoiceStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoiceStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoiceStep&&(identical(other.id, id) || other.id == id)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,prompt,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'QuestStep.choice(id: $id, prompt: $prompt, options: $options)';
}


}

/// @nodoc
abstract mixin class $ChoiceStepCopyWith<$Res> implements $QuestStepCopyWith<$Res> {
  factory $ChoiceStepCopyWith(ChoiceStep value, $Res Function(ChoiceStep) _then) = _$ChoiceStepCopyWithImpl;
@override @useResult
$Res call({
 String id, String prompt, List<QuestOption> options
});




}
/// @nodoc
class _$ChoiceStepCopyWithImpl<$Res>
    implements $ChoiceStepCopyWith<$Res> {
  _$ChoiceStepCopyWithImpl(this._self, this._then);

  final ChoiceStep _self;
  final $Res Function(ChoiceStep) _then;

/// Create a copy of QuestStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? prompt = null,Object? options = null,}) {
  return _then(ChoiceStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestOption>,
  ));
}


}


/// @nodoc
mixin _$Quest {

 String get id; String get title; String get location; QuestReward get reward; List<String> get prerequisites; List<QuestStep> get steps;// Spec-38 P3-3: topic-Tag für Quest/Quiz-Dedup. Leer = kein Tag.
 String get topic;
/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestCopyWith<Quest> get copyWith => _$QuestCopyWithImpl<Quest>(this as Quest, _$identity);

  /// Serializes this Quest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Quest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.location, location) || other.location == location)&&(identical(other.reward, reward) || other.reward == reward)&&const DeepCollectionEquality().equals(other.prerequisites, prerequisites)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.topic, topic) || other.topic == topic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,location,reward,const DeepCollectionEquality().hash(prerequisites),const DeepCollectionEquality().hash(steps),topic);

@override
String toString() {
  return 'Quest(id: $id, title: $title, location: $location, reward: $reward, prerequisites: $prerequisites, steps: $steps, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $QuestCopyWith<$Res>  {
  factory $QuestCopyWith(Quest value, $Res Function(Quest) _then) = _$QuestCopyWithImpl;
@useResult
$Res call({
 String id, String title, String location, QuestReward reward, List<String> prerequisites, List<QuestStep> steps, String topic
});


$QuestRewardCopyWith<$Res> get reward;

}
/// @nodoc
class _$QuestCopyWithImpl<$Res>
    implements $QuestCopyWith<$Res> {
  _$QuestCopyWithImpl(this._self, this._then);

  final Quest _self;
  final $Res Function(Quest) _then;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? location = null,Object? reward = null,Object? prerequisites = null,Object? steps = null,Object? topic = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as QuestReward,prerequisites: null == prerequisites ? _self.prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<QuestStep>,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestRewardCopyWith<$Res> get reward {
  
  return $QuestRewardCopyWith<$Res>(_self.reward, (value) {
    return _then(_self.copyWith(reward: value));
  });
}
}


/// Adds pattern-matching-related methods to [Quest].
extension QuestPatterns on Quest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Quest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Quest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Quest value)  $default,){
final _that = this;
switch (_that) {
case _Quest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Quest value)?  $default,){
final _that = this;
switch (_that) {
case _Quest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String location,  QuestReward reward,  List<String> prerequisites,  List<QuestStep> steps,  String topic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Quest() when $default != null:
return $default(_that.id,_that.title,_that.location,_that.reward,_that.prerequisites,_that.steps,_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String location,  QuestReward reward,  List<String> prerequisites,  List<QuestStep> steps,  String topic)  $default,) {final _that = this;
switch (_that) {
case _Quest():
return $default(_that.id,_that.title,_that.location,_that.reward,_that.prerequisites,_that.steps,_that.topic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String location,  QuestReward reward,  List<String> prerequisites,  List<QuestStep> steps,  String topic)?  $default,) {final _that = this;
switch (_that) {
case _Quest() when $default != null:
return $default(_that.id,_that.title,_that.location,_that.reward,_that.prerequisites,_that.steps,_that.topic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Quest implements Quest {
  const _Quest({required this.id, required this.title, required this.location, required this.reward, final  List<String> prerequisites = const <String>[], final  List<QuestStep> steps = const <QuestStep>[], this.topic = ''}): _prerequisites = prerequisites,_steps = steps;
  factory _Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);

@override final  String id;
@override final  String title;
@override final  String location;
@override final  QuestReward reward;
 final  List<String> _prerequisites;
@override@JsonKey() List<String> get prerequisites {
  if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prerequisites);
}

 final  List<QuestStep> _steps;
@override@JsonKey() List<QuestStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

// Spec-38 P3-3: topic-Tag für Quest/Quiz-Dedup. Leer = kein Tag.
@override@JsonKey() final  String topic;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestCopyWith<_Quest> get copyWith => __$QuestCopyWithImpl<_Quest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Quest&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.location, location) || other.location == location)&&(identical(other.reward, reward) || other.reward == reward)&&const DeepCollectionEquality().equals(other._prerequisites, _prerequisites)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.topic, topic) || other.topic == topic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,location,reward,const DeepCollectionEquality().hash(_prerequisites),const DeepCollectionEquality().hash(_steps),topic);

@override
String toString() {
  return 'Quest(id: $id, title: $title, location: $location, reward: $reward, prerequisites: $prerequisites, steps: $steps, topic: $topic)';
}


}

/// @nodoc
abstract mixin class _$QuestCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$QuestCopyWith(_Quest value, $Res Function(_Quest) _then) = __$QuestCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String location, QuestReward reward, List<String> prerequisites, List<QuestStep> steps, String topic
});


@override $QuestRewardCopyWith<$Res> get reward;

}
/// @nodoc
class __$QuestCopyWithImpl<$Res>
    implements _$QuestCopyWith<$Res> {
  __$QuestCopyWithImpl(this._self, this._then);

  final _Quest _self;
  final $Res Function(_Quest) _then;

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? location = null,Object? reward = null,Object? prerequisites = null,Object? steps = null,Object? topic = null,}) {
  return _then(_Quest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as QuestReward,prerequisites: null == prerequisites ? _self._prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<QuestStep>,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Quest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestRewardCopyWith<$Res> get reward {
  
  return $QuestRewardCopyWith<$Res>(_self.reward, (value) {
    return _then(_self.copyWith(reward: value));
  });
}
}

// dart format on
