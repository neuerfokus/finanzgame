// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WishItem {

 String get id; String get name; WishCategory get category;@MoneyConverter() Money get basePrice;@MoneyConverter() Money get currentPrice; String get emoji; int? get ownedOnDayIndex;/// Welle-8 Round 16: User-Foto-Pfad statt Emoji. Null = Emoji.
 String? get photoPath;
/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WishItemCopyWith<WishItem> get copyWith => _$WishItemCopyWithImpl<WishItem>(this as WishItem, _$identity);

  /// Serializes this WishItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WishItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.ownedOnDayIndex, ownedOnDayIndex) || other.ownedOnDayIndex == ownedOnDayIndex)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,basePrice,currentPrice,emoji,ownedOnDayIndex,photoPath);

@override
String toString() {
  return 'WishItem(id: $id, name: $name, category: $category, basePrice: $basePrice, currentPrice: $currentPrice, emoji: $emoji, ownedOnDayIndex: $ownedOnDayIndex, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $WishItemCopyWith<$Res>  {
  factory $WishItemCopyWith(WishItem value, $Res Function(WishItem) _then) = _$WishItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, WishCategory category,@MoneyConverter() Money basePrice,@MoneyConverter() Money currentPrice, String emoji, int? ownedOnDayIndex, String? photoPath
});




}
/// @nodoc
class _$WishItemCopyWithImpl<$Res>
    implements $WishItemCopyWith<$Res> {
  _$WishItemCopyWithImpl(this._self, this._then);

  final WishItem _self;
  final $Res Function(WishItem) _then;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? basePrice = null,Object? currentPrice = null,Object? emoji = null,Object? ownedOnDayIndex = freezed,Object? photoPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WishCategory,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as Money,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as Money,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,ownedOnDayIndex: freezed == ownedOnDayIndex ? _self.ownedOnDayIndex : ownedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WishItem].
extension WishItemPatterns on WishItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WishItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WishItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WishItem value)  $default,){
final _that = this;
switch (_that) {
case _WishItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WishItem value)?  $default,){
final _that = this;
switch (_that) {
case _WishItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  WishCategory category, @MoneyConverter()  Money basePrice, @MoneyConverter()  Money currentPrice,  String emoji,  int? ownedOnDayIndex,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.basePrice,_that.currentPrice,_that.emoji,_that.ownedOnDayIndex,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  WishCategory category, @MoneyConverter()  Money basePrice, @MoneyConverter()  Money currentPrice,  String emoji,  int? ownedOnDayIndex,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _WishItem():
return $default(_that.id,_that.name,_that.category,_that.basePrice,_that.currentPrice,_that.emoji,_that.ownedOnDayIndex,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  WishCategory category, @MoneyConverter()  Money basePrice, @MoneyConverter()  Money currentPrice,  String emoji,  int? ownedOnDayIndex,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _WishItem() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.basePrice,_that.currentPrice,_that.emoji,_that.ownedOnDayIndex,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WishItem implements WishItem {
  const _WishItem({required this.id, required this.name, required this.category, @MoneyConverter() required this.basePrice, @MoneyConverter() required this.currentPrice, required this.emoji, this.ownedOnDayIndex, this.photoPath});
  factory _WishItem.fromJson(Map<String, dynamic> json) => _$WishItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  WishCategory category;
@override@MoneyConverter() final  Money basePrice;
@override@MoneyConverter() final  Money currentPrice;
@override final  String emoji;
@override final  int? ownedOnDayIndex;
/// Welle-8 Round 16: User-Foto-Pfad statt Emoji. Null = Emoji.
@override final  String? photoPath;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WishItemCopyWith<_WishItem> get copyWith => __$WishItemCopyWithImpl<_WishItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WishItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WishItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.ownedOnDayIndex, ownedOnDayIndex) || other.ownedOnDayIndex == ownedOnDayIndex)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,basePrice,currentPrice,emoji,ownedOnDayIndex,photoPath);

@override
String toString() {
  return 'WishItem(id: $id, name: $name, category: $category, basePrice: $basePrice, currentPrice: $currentPrice, emoji: $emoji, ownedOnDayIndex: $ownedOnDayIndex, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$WishItemCopyWith<$Res> implements $WishItemCopyWith<$Res> {
  factory _$WishItemCopyWith(_WishItem value, $Res Function(_WishItem) _then) = __$WishItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, WishCategory category,@MoneyConverter() Money basePrice,@MoneyConverter() Money currentPrice, String emoji, int? ownedOnDayIndex, String? photoPath
});




}
/// @nodoc
class __$WishItemCopyWithImpl<$Res>
    implements _$WishItemCopyWith<$Res> {
  __$WishItemCopyWithImpl(this._self, this._then);

  final _WishItem _self;
  final $Res Function(_WishItem) _then;

/// Create a copy of WishItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? basePrice = null,Object? currentPrice = null,Object? emoji = null,Object? ownedOnDayIndex = freezed,Object? photoPath = freezed,}) {
  return _then(_WishItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WishCategory,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as Money,currentPrice: null == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as Money,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,ownedOnDayIndex: freezed == ownedOnDayIndex ? _self.ownedOnDayIndex : ownedOnDayIndex // ignore: cast_nullable_to_non_nullable
as int?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
