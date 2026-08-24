// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_queue_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-45 E4: Spaced-Repetition Queue für Quiz-Reviews nach Quest-Complete.
///
/// In-memory (kein Drift bis H1 Sammelmigration). Geht bei App-Restart
/// verloren — akzeptabel für Lern-Loop, fällige Reviews kommen sonst
/// einfach am nächsten Schlafen vorbei.
///
/// Hook: `QuestRunnerController` ruft [enqueueForQuest] beim Wechsel auf
/// completed. Pick-Priorität in [DailyQuizState.questionFor].

@ProviderFor(QuizQueueRepository)
final quizQueueRepositoryProvider = QuizQueueRepositoryProvider._();

/// Spec-45 E4: Spaced-Repetition Queue für Quiz-Reviews nach Quest-Complete.
///
/// In-memory (kein Drift bis H1 Sammelmigration). Geht bei App-Restart
/// verloren — akzeptabel für Lern-Loop, fällige Reviews kommen sonst
/// einfach am nächsten Schlafen vorbei.
///
/// Hook: `QuestRunnerController` ruft [enqueueForQuest] beim Wechsel auf
/// completed. Pick-Priorität in [DailyQuizState.questionFor].
final class QuizQueueRepositoryProvider
    extends $NotifierProvider<QuizQueueRepository, List<QueuedReview>> {
  /// Spec-45 E4: Spaced-Repetition Queue für Quiz-Reviews nach Quest-Complete.
  ///
  /// In-memory (kein Drift bis H1 Sammelmigration). Geht bei App-Restart
  /// verloren — akzeptabel für Lern-Loop, fällige Reviews kommen sonst
  /// einfach am nächsten Schlafen vorbei.
  ///
  /// Hook: `QuestRunnerController` ruft [enqueueForQuest] beim Wechsel auf
  /// completed. Pick-Priorität in [DailyQuizState.questionFor].
  QuizQueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizQueueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizQueueRepositoryHash();

  @$internal
  @override
  QuizQueueRepository create() => QuizQueueRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<QueuedReview> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<QueuedReview>>(value),
    );
  }
}

String _$quizQueueRepositoryHash() =>
    r'29dbdb941096f13002fa1af1f2517e49c3b8fa6d';

/// Spec-45 E4: Spaced-Repetition Queue für Quiz-Reviews nach Quest-Complete.
///
/// In-memory (kein Drift bis H1 Sammelmigration). Geht bei App-Restart
/// verloren — akzeptabel für Lern-Loop, fällige Reviews kommen sonst
/// einfach am nächsten Schlafen vorbei.
///
/// Hook: `QuestRunnerController` ruft [enqueueForQuest] beim Wechsel auf
/// completed. Pick-Priorität in [DailyQuizState.questionFor].

abstract class _$QuizQueueRepository extends $Notifier<List<QueuedReview>> {
  List<QueuedReview> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<QueuedReview>, List<QueuedReview>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<QueuedReview>, List<QueuedReview>>,
              List<QueuedReview>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
