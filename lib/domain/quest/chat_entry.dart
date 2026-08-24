import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_entry.freezed.dart';
part 'chat_entry.g.dart';

/// One bubble in the quest chat stream.
///
/// Three sources: an NPC speaker, the player's own response, or a system
/// note (rewards, validation, hints).
@Freezed(unionKey: 'type')
sealed class ChatEntry with _$ChatEntry {
  @FreezedUnionValue('npc')
  const factory ChatEntry.npc({
    required String speaker,
    required String text,
  }) = NpcEntry;

  @FreezedUnionValue('own')
  const factory ChatEntry.own({required String text}) = OwnEntry;

  @FreezedUnionValue('system')
  const factory ChatEntry.system({required String text}) = SystemEntry;

  factory ChatEntry.fromJson(Map<String, dynamic> json) =>
      _$ChatEntryFromJson(json);
}
