// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Plant _$PlantFromJson(Map<String, dynamic> json) => _Plant(
  id: json['id'] as String,
  islandId: json['islandId'] as String,
  plotIndex: (json['plotIndex'] as num).toInt(),
  kind: $enumDecode(_$PlantKindEnumMap, json['kind']),
  plantedOnDayIndex: (json['plantedOnDayIndex'] as num).toInt(),
  currentStage: (json['currentStage'] as num?)?.toInt() ?? 0,
  growthProgress: (json['growthProgress'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$PlantStatusEnumMap, json['status']) ??
      PlantStatus.growing,
);

Map<String, dynamic> _$PlantToJson(_Plant instance) => <String, dynamic>{
  'id': instance.id,
  'islandId': instance.islandId,
  'plotIndex': instance.plotIndex,
  'kind': _$PlantKindEnumMap[instance.kind]!,
  'plantedOnDayIndex': instance.plantedOnDayIndex,
  'currentStage': instance.currentStage,
  'growthProgress': instance.growthProgress,
  'status': _$PlantStatusEnumMap[instance.status]!,
};

const _$PlantKindEnumMap = {
  PlantKind.elephantsfoot: 'elephantsfoot',
  PlantKind.sonnenblume: 'sonnenblume',
  PlantKind.kaktus: 'kaktus',
  PlantKind.tomate: 'tomate',
  PlantKind.bambus: 'bambus',
  PlantKind.erdbeere: 'erdbeere',
  PlantKind.karotte: 'karotte',
  PlantKind.apfel: 'apfel',
  PlantKind.salat: 'salat',
  PlantKind.kuerbis: 'kuerbis',
};

const _$PlantStatusEnumMap = {
  PlantStatus.growing: 'growing',
  PlantStatus.ready: 'ready',
  PlantStatus.harvested: 'harvested',
  PlantStatus.withered: 'withered',
};
