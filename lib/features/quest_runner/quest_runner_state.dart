import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/quest/chat_entry.dart';
import '../../domain/quest/quest.dart';

part 'quest_runner_state.freezed.dart';

/// Sub-state while the player is reading dialog lines. The runner advances
/// one line at a time so the chat scroll feels paced.
@freezed
abstract class DialogProgress with _$DialogProgress {
  const factory DialogProgress({
    required int stepIndex,
    required int linesShown,
  }) = _DialogProgress;
}

/// Top-level runner state.
@freezed
abstract class QuestRunnerState with _$QuestRunnerState {
  const factory QuestRunnerState({
    required Quest quest,
    @Default(<ChatEntry>[]) List<ChatEntry> chat,
    required int stepIndex,
    DialogProgress? dialog,
    @Default(false) bool awaitingInput,
    @Default(false) bool finished,
    @Default(false) bool questAborted,
  }) = _QuestRunnerState;
}
