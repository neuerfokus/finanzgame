// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
QuizQuestion _$QuizQuestionFromJson(
  Map<String, dynamic> json
) {
    return MultipleChoiceQuestion.fromJson(
      json
    );
}

/// @nodoc
mixin _$QuizQuestion {

 String get text; List<String> get options; int get correctIndex; String get explanation;// Spec-38 P3-3: topic-Tag für Quest/Quiz-Dedup. Leer = kein Tag.
 String get topic;// Spec-45 Bucket I: 0=easy, 1=mid, 2=hard (siehe quiz_topics.dart).
 int get tier;
/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<QuizQuestion> get copyWith => _$QuizQuestionCopyWithImpl<QuizQuestion>(this as QuizQuestion, _$identity);

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizQuestion&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.tier, tier) || other.tier == tier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(options),correctIndex,explanation,topic,tier);

@override
String toString() {
  return 'QuizQuestion(text: $text, options: $options, correctIndex: $correctIndex, explanation: $explanation, topic: $topic, tier: $tier)';
}


}

/// @nodoc
abstract mixin class $QuizQuestionCopyWith<$Res>  {
  factory $QuizQuestionCopyWith(QuizQuestion value, $Res Function(QuizQuestion) _then) = _$QuizQuestionCopyWithImpl;
@useResult
$Res call({
 String text, List<String> options, int correctIndex, String explanation, String topic, int tier
});




}
/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._self, this._then);

  final QuizQuestion _self;
  final $Res Function(QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? options = null,Object? correctIndex = null,Object? explanation = null,Object? topic = null,Object? tier = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizQuestion].
extension QuizQuestionPatterns on QuizQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MultipleChoiceQuestion value)?  multipleChoice,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MultipleChoiceQuestion value)  multipleChoice,}){
final _that = this;
switch (_that) {
case MultipleChoiceQuestion():
return multipleChoice(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MultipleChoiceQuestion value)?  multipleChoice,}){
final _that = this;
switch (_that) {
case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text,  List<String> options,  int correctIndex,  String explanation,  String topic,  int tier)?  multipleChoice,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that.text,_that.options,_that.correctIndex,_that.explanation,_that.topic,_that.tier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text,  List<String> options,  int correctIndex,  String explanation,  String topic,  int tier)  multipleChoice,}) {final _that = this;
switch (_that) {
case MultipleChoiceQuestion():
return multipleChoice(_that.text,_that.options,_that.correctIndex,_that.explanation,_that.topic,_that.tier);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text,  List<String> options,  int correctIndex,  String explanation,  String topic,  int tier)?  multipleChoice,}) {final _that = this;
switch (_that) {
case MultipleChoiceQuestion() when multipleChoice != null:
return multipleChoice(_that.text,_that.options,_that.correctIndex,_that.explanation,_that.topic,_that.tier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MultipleChoiceQuestion implements QuizQuestion {
  const MultipleChoiceQuestion({required this.text, required final  List<String> options, required this.correctIndex, required this.explanation, this.topic = '', this.tier = 0}): _options = options;
  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) => _$MultipleChoiceQuestionFromJson(json);

@override final  String text;
 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int correctIndex;
@override final  String explanation;
// Spec-38 P3-3: topic-Tag für Quest/Quiz-Dedup. Leer = kein Tag.
@override@JsonKey() final  String topic;
// Spec-45 Bucket I: 0=easy, 1=mid, 2=hard (siehe quiz_topics.dart).
@override@JsonKey() final  int tier;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultipleChoiceQuestionCopyWith<MultipleChoiceQuestion> get copyWith => _$MultipleChoiceQuestionCopyWithImpl<MultipleChoiceQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultipleChoiceQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultipleChoiceQuestion&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.tier, tier) || other.tier == tier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_options),correctIndex,explanation,topic,tier);

@override
String toString() {
  return 'QuizQuestion.multipleChoice(text: $text, options: $options, correctIndex: $correctIndex, explanation: $explanation, topic: $topic, tier: $tier)';
}


}

/// @nodoc
abstract mixin class $MultipleChoiceQuestionCopyWith<$Res> implements $QuizQuestionCopyWith<$Res> {
  factory $MultipleChoiceQuestionCopyWith(MultipleChoiceQuestion value, $Res Function(MultipleChoiceQuestion) _then) = _$MultipleChoiceQuestionCopyWithImpl;
@override @useResult
$Res call({
 String text, List<String> options, int correctIndex, String explanation, String topic, int tier
});




}
/// @nodoc
class _$MultipleChoiceQuestionCopyWithImpl<$Res>
    implements $MultipleChoiceQuestionCopyWith<$Res> {
  _$MultipleChoiceQuestionCopyWithImpl(this._self, this._then);

  final MultipleChoiceQuestion _self;
  final $Res Function(MultipleChoiceQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? options = null,Object? correctIndex = null,Object? explanation = null,Object? topic = null,Object? tier = null,}) {
  return _then(MultipleChoiceQuestion(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
