// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_phase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NormalPhase _$NormalPhaseFromJson(Map<String, dynamic> json) =>
    NormalPhase($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NormalPhaseToJson(NormalPhase instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

DrawdownPhase _$DrawdownPhaseFromJson(Map<String, dynamic> json) =>
    DrawdownPhase(
      daysLeft: (json['daysLeft'] as num).toInt(),
      totalDays: (json['totalDays'] as num).toInt(),
      depthPct: (json['depthPct'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DrawdownPhaseToJson(DrawdownPhase instance) =>
    <String, dynamic>{
      'daysLeft': instance.daysLeft,
      'totalDays': instance.totalDays,
      'depthPct': instance.depthPct,
      'runtimeType': instance.$type,
    };

RecoveryPhase _$RecoveryPhaseFromJson(Map<String, dynamic> json) =>
    RecoveryPhase(
      daysLeft: (json['daysLeft'] as num).toInt(),
      totalDays: (json['totalDays'] as num).toInt(),
      targetReturnPct: (json['targetReturnPct'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$RecoveryPhaseToJson(RecoveryPhase instance) =>
    <String, dynamic>{
      'daysLeft': instance.daysLeft,
      'totalDays': instance.totalDays,
      'targetReturnPct': instance.targetReturnPct,
      'runtimeType': instance.$type,
    };
