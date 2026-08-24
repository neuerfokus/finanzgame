// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WishItem _$WishItemFromJson(Map<String, dynamic> json) => _WishItem(
  id: json['id'] as String,
  name: json['name'] as String,
  category: $enumDecode(_$WishCategoryEnumMap, json['category']),
  basePrice: const MoneyConverter().fromJson(
    json['basePrice'] as Map<String, dynamic>,
  ),
  currentPrice: const MoneyConverter().fromJson(
    json['currentPrice'] as Map<String, dynamic>,
  ),
  emoji: json['emoji'] as String,
  ownedOnDayIndex: (json['ownedOnDayIndex'] as num?)?.toInt(),
  photoPath: json['photoPath'] as String?,
);

Map<String, dynamic> _$WishItemToJson(_WishItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': _$WishCategoryEnumMap[instance.category]!,
  'basePrice': const MoneyConverter().toJson(instance.basePrice),
  'currentPrice': const MoneyConverter().toJson(instance.currentPrice),
  'emoji': instance.emoji,
  'ownedOnDayIndex': instance.ownedOnDayIndex,
  'photoPath': instance.photoPath,
};

const _$WishCategoryEnumMap = {
  WishCategory.sneaker: 'sneaker',
  WishCategory.social: 'social',
  WishCategory.snack: 'snack',
  WishCategory.game: 'game',
};
