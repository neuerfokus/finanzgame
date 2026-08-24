import 'package:json_annotation/json_annotation.dart';

import 'game_day.dart';

/// [JsonConverter] for [GameDay] in nested Freezed models.
///
/// Without this, `json_serializable` emits the raw Dart object into the JSON
/// map instead of calling [GameDay.toJson].
class GameDayConverter
    implements JsonConverter<GameDay, Map<String, dynamic>> {
  const GameDayConverter();

  @override
  GameDay fromJson(Map<String, dynamic> json) => GameDay.fromJson(json);

  @override
  Map<String, dynamic> toJson(GameDay day) => day.toJson();
}
