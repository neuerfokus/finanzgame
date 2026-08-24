// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_phase.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
MarketPhase _$MarketPhaseFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'normal':
          return NormalPhase.fromJson(
            json
          );
                case 'drawdown':
          return DrawdownPhase.fromJson(
            json
          );
                case 'recovery':
          return RecoveryPhase.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'MarketPhase',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$MarketPhase {



  /// Serializes this MarketPhase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketPhase);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketPhase()';
}


}

/// @nodoc
class $MarketPhaseCopyWith<$Res>  {
$MarketPhaseCopyWith(MarketPhase _, $Res Function(MarketPhase) __);
}


/// Adds pattern-matching-related methods to [MarketPhase].
extension MarketPhasePatterns on MarketPhase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NormalPhase value)?  normal,TResult Function( DrawdownPhase value)?  drawdown,TResult Function( RecoveryPhase value)?  recovery,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NormalPhase() when normal != null:
return normal(_that);case DrawdownPhase() when drawdown != null:
return drawdown(_that);case RecoveryPhase() when recovery != null:
return recovery(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NormalPhase value)  normal,required TResult Function( DrawdownPhase value)  drawdown,required TResult Function( RecoveryPhase value)  recovery,}){
final _that = this;
switch (_that) {
case NormalPhase():
return normal(_that);case DrawdownPhase():
return drawdown(_that);case RecoveryPhase():
return recovery(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NormalPhase value)?  normal,TResult? Function( DrawdownPhase value)?  drawdown,TResult? Function( RecoveryPhase value)?  recovery,}){
final _that = this;
switch (_that) {
case NormalPhase() when normal != null:
return normal(_that);case DrawdownPhase() when drawdown != null:
return drawdown(_that);case RecoveryPhase() when recovery != null:
return recovery(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  normal,TResult Function( int daysLeft,  int totalDays,  double depthPct)?  drawdown,TResult Function( int daysLeft,  int totalDays,  double targetReturnPct)?  recovery,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NormalPhase() when normal != null:
return normal();case DrawdownPhase() when drawdown != null:
return drawdown(_that.daysLeft,_that.totalDays,_that.depthPct);case RecoveryPhase() when recovery != null:
return recovery(_that.daysLeft,_that.totalDays,_that.targetReturnPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  normal,required TResult Function( int daysLeft,  int totalDays,  double depthPct)  drawdown,required TResult Function( int daysLeft,  int totalDays,  double targetReturnPct)  recovery,}) {final _that = this;
switch (_that) {
case NormalPhase():
return normal();case DrawdownPhase():
return drawdown(_that.daysLeft,_that.totalDays,_that.depthPct);case RecoveryPhase():
return recovery(_that.daysLeft,_that.totalDays,_that.targetReturnPct);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  normal,TResult? Function( int daysLeft,  int totalDays,  double depthPct)?  drawdown,TResult? Function( int daysLeft,  int totalDays,  double targetReturnPct)?  recovery,}) {final _that = this;
switch (_that) {
case NormalPhase() when normal != null:
return normal();case DrawdownPhase() when drawdown != null:
return drawdown(_that.daysLeft,_that.totalDays,_that.depthPct);case RecoveryPhase() when recovery != null:
return recovery(_that.daysLeft,_that.totalDays,_that.targetReturnPct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class NormalPhase implements MarketPhase {
  const NormalPhase({final  String? $type}): $type = $type ?? 'normal';
  factory NormalPhase.fromJson(Map<String, dynamic> json) => _$NormalPhaseFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$NormalPhaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NormalPhase);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketPhase.normal()';
}


}




/// @nodoc
@JsonSerializable()

class DrawdownPhase implements MarketPhase {
  const DrawdownPhase({required this.daysLeft, required this.totalDays, required this.depthPct, final  String? $type}): $type = $type ?? 'drawdown';
  factory DrawdownPhase.fromJson(Map<String, dynamic> json) => _$DrawdownPhaseFromJson(json);

 final  int daysLeft;
 final  int totalDays;
 final  double depthPct;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MarketPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawdownPhaseCopyWith<DrawdownPhase> get copyWith => _$DrawdownPhaseCopyWithImpl<DrawdownPhase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrawdownPhaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawdownPhase&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.depthPct, depthPct) || other.depthPct == depthPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,daysLeft,totalDays,depthPct);

@override
String toString() {
  return 'MarketPhase.drawdown(daysLeft: $daysLeft, totalDays: $totalDays, depthPct: $depthPct)';
}


}

/// @nodoc
abstract mixin class $DrawdownPhaseCopyWith<$Res> implements $MarketPhaseCopyWith<$Res> {
  factory $DrawdownPhaseCopyWith(DrawdownPhase value, $Res Function(DrawdownPhase) _then) = _$DrawdownPhaseCopyWithImpl;
@useResult
$Res call({
 int daysLeft, int totalDays, double depthPct
});




}
/// @nodoc
class _$DrawdownPhaseCopyWithImpl<$Res>
    implements $DrawdownPhaseCopyWith<$Res> {
  _$DrawdownPhaseCopyWithImpl(this._self, this._then);

  final DrawdownPhase _self;
  final $Res Function(DrawdownPhase) _then;

/// Create a copy of MarketPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? daysLeft = null,Object? totalDays = null,Object? depthPct = null,}) {
  return _then(DrawdownPhase(
daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,depthPct: null == depthPct ? _self.depthPct : depthPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RecoveryPhase implements MarketPhase {
  const RecoveryPhase({required this.daysLeft, required this.totalDays, required this.targetReturnPct, final  String? $type}): $type = $type ?? 'recovery';
  factory RecoveryPhase.fromJson(Map<String, dynamic> json) => _$RecoveryPhaseFromJson(json);

 final  int daysLeft;
 final  int totalDays;
 final  double targetReturnPct;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MarketPhase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecoveryPhaseCopyWith<RecoveryPhase> get copyWith => _$RecoveryPhaseCopyWithImpl<RecoveryPhase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecoveryPhaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecoveryPhase&&(identical(other.daysLeft, daysLeft) || other.daysLeft == daysLeft)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.targetReturnPct, targetReturnPct) || other.targetReturnPct == targetReturnPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,daysLeft,totalDays,targetReturnPct);

@override
String toString() {
  return 'MarketPhase.recovery(daysLeft: $daysLeft, totalDays: $totalDays, targetReturnPct: $targetReturnPct)';
}


}

/// @nodoc
abstract mixin class $RecoveryPhaseCopyWith<$Res> implements $MarketPhaseCopyWith<$Res> {
  factory $RecoveryPhaseCopyWith(RecoveryPhase value, $Res Function(RecoveryPhase) _then) = _$RecoveryPhaseCopyWithImpl;
@useResult
$Res call({
 int daysLeft, int totalDays, double targetReturnPct
});




}
/// @nodoc
class _$RecoveryPhaseCopyWithImpl<$Res>
    implements $RecoveryPhaseCopyWith<$Res> {
  _$RecoveryPhaseCopyWithImpl(this._self, this._then);

  final RecoveryPhase _self;
  final $Res Function(RecoveryPhase) _then;

/// Create a copy of MarketPhase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? daysLeft = null,Object? totalDays = null,Object? targetReturnPct = null,}) {
  return _then(RecoveryPhase(
daysLeft: null == daysLeft ? _self.daysLeft : daysLeft // ignore: cast_nullable_to_non_nullable
as int,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,targetReturnPct: null == targetReturnPct ? _self.targetReturnPct : targetReturnPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
