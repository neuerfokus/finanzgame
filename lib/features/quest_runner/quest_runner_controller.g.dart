// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_runner_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State machine for a single quest playthrough.
///
/// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
/// [pickChoice] (free choice). The reward is paid out automatically when
/// the last step is consumed.
///
/// `keepAlive: true` + hydration from [QuestProgressRepository] means that
/// popping/pushing the runner page preserves chat + step, and a hard app
/// restart restores them from Drift (spec-14).
///
/// The family key is the full [Quest] (Freezed value-equal), not just the
/// id, so the notifier always has the parsed steps without an async lookup.

@ProviderFor(QuestRunnerController)
final questRunnerControllerProvider = QuestRunnerControllerFamily._();

/// State machine for a single quest playthrough.
///
/// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
/// [pickChoice] (free choice). The reward is paid out automatically when
/// the last step is consumed.
///
/// `keepAlive: true` + hydration from [QuestProgressRepository] means that
/// popping/pushing the runner page preserves chat + step, and a hard app
/// restart restores them from Drift (spec-14).
///
/// The family key is the full [Quest] (Freezed value-equal), not just the
/// id, so the notifier always has the parsed steps without an async lookup.
final class QuestRunnerControllerProvider
    extends $NotifierProvider<QuestRunnerController, QuestRunnerState> {
  /// State machine for a single quest playthrough.
  ///
  /// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
  /// [pickChoice] (free choice). The reward is paid out automatically when
  /// the last step is consumed.
  ///
  /// `keepAlive: true` + hydration from [QuestProgressRepository] means that
  /// popping/pushing the runner page preserves chat + step, and a hard app
  /// restart restores them from Drift (spec-14).
  ///
  /// The family key is the full [Quest] (Freezed value-equal), not just the
  /// id, so the notifier always has the parsed steps without an async lookup.
  QuestRunnerControllerProvider._({
    required QuestRunnerControllerFamily super.from,
    required Quest super.argument,
  }) : super(
         retry: null,
         name: r'questRunnerControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$questRunnerControllerHash();

  @override
  String toString() {
    return r'questRunnerControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QuestRunnerController create() => QuestRunnerController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestRunnerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestRunnerState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuestRunnerControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$questRunnerControllerHash() =>
    r'2aaa93759cbc6092995ab6365116212db21f1420';

/// State machine for a single quest playthrough.
///
/// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
/// [pickChoice] (free choice). The reward is paid out automatically when
/// the last step is consumed.
///
/// `keepAlive: true` + hydration from [QuestProgressRepository] means that
/// popping/pushing the runner page preserves chat + step, and a hard app
/// restart restores them from Drift (spec-14).
///
/// The family key is the full [Quest] (Freezed value-equal), not just the
/// id, so the notifier always has the parsed steps without an async lookup.

final class QuestRunnerControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          QuestRunnerController,
          QuestRunnerState,
          QuestRunnerState,
          QuestRunnerState,
          Quest
        > {
  QuestRunnerControllerFamily._()
    : super(
        retry: null,
        name: r'questRunnerControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// State machine for a single quest playthrough.
  ///
  /// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
  /// [pickChoice] (free choice). The reward is paid out automatically when
  /// the last step is consumed.
  ///
  /// `keepAlive: true` + hydration from [QuestProgressRepository] means that
  /// popping/pushing the runner page preserves chat + step, and a hard app
  /// restart restores them from Drift (spec-14).
  ///
  /// The family key is the full [Quest] (Freezed value-equal), not just the
  /// id, so the notifier always has the parsed steps without an async lookup.

  QuestRunnerControllerProvider call(Quest quest) =>
      QuestRunnerControllerProvider._(argument: quest, from: this);

  @override
  String toString() => r'questRunnerControllerProvider';
}

/// State machine for a single quest playthrough.
///
/// Caller drives via [advance] (dialog continue), [answerQuiz] (quiz pick),
/// [pickChoice] (free choice). The reward is paid out automatically when
/// the last step is consumed.
///
/// `keepAlive: true` + hydration from [QuestProgressRepository] means that
/// popping/pushing the runner page preserves chat + step, and a hard app
/// restart restores them from Drift (spec-14).
///
/// The family key is the full [Quest] (Freezed value-equal), not just the
/// id, so the notifier always has the parsed steps without an async lookup.

abstract class _$QuestRunnerController extends $Notifier<QuestRunnerState> {
  late final _$args = ref.$arg as Quest;
  Quest get quest => _$args;

  QuestRunnerState build(Quest quest);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<QuestRunnerState, QuestRunnerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuestRunnerState, QuestRunnerState>,
              QuestRunnerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
