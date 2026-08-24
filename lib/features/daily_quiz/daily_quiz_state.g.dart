// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_quiz_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-17 + Spec-45 Bucket I + E4: gate + topic-aware picker für die
/// einmal-pro-Tag Quiz-Overlay.
///
/// Persistierter Gate-State via [SettingsRepository.lastQuizDayIndex].
/// UI ruft [shouldShow] in Springboard-Build, falls true: Push +
/// [markShown].
///
/// Pick-Priorität in [questionFor]:
/// 1. Fälliger Review aus [QuizQueueRepository] (E4 Spaced-Rep)
/// 2. Filter Pool nach `learnedTopics ∩ tiersFor(dayIndex)`
/// 3. Fallback: tier-Fenster only

@ProviderFor(DailyQuizState)
final dailyQuizStateProvider = DailyQuizStateProvider._();

/// Spec-17 + Spec-45 Bucket I + E4: gate + topic-aware picker für die
/// einmal-pro-Tag Quiz-Overlay.
///
/// Persistierter Gate-State via [SettingsRepository.lastQuizDayIndex].
/// UI ruft [shouldShow] in Springboard-Build, falls true: Push +
/// [markShown].
///
/// Pick-Priorität in [questionFor]:
/// 1. Fälliger Review aus [QuizQueueRepository] (E4 Spaced-Rep)
/// 2. Filter Pool nach `learnedTopics ∩ tiersFor(dayIndex)`
/// 3. Fallback: tier-Fenster only
final class DailyQuizStateProvider
    extends $NotifierProvider<DailyQuizState, int> {
  /// Spec-17 + Spec-45 Bucket I + E4: gate + topic-aware picker für die
  /// einmal-pro-Tag Quiz-Overlay.
  ///
  /// Persistierter Gate-State via [SettingsRepository.lastQuizDayIndex].
  /// UI ruft [shouldShow] in Springboard-Build, falls true: Push +
  /// [markShown].
  ///
  /// Pick-Priorität in [questionFor]:
  /// 1. Fälliger Review aus [QuizQueueRepository] (E4 Spaced-Rep)
  /// 2. Filter Pool nach `learnedTopics ∩ tiersFor(dayIndex)`
  /// 3. Fallback: tier-Fenster only
  DailyQuizStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyQuizStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyQuizStateHash();

  @$internal
  @override
  DailyQuizState create() => DailyQuizState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$dailyQuizStateHash() => r'd413eca728cd0b8fee9bd48d0f0ac17c7f73d349';

/// Spec-17 + Spec-45 Bucket I + E4: gate + topic-aware picker für die
/// einmal-pro-Tag Quiz-Overlay.
///
/// Persistierter Gate-State via [SettingsRepository.lastQuizDayIndex].
/// UI ruft [shouldShow] in Springboard-Build, falls true: Push +
/// [markShown].
///
/// Pick-Priorität in [questionFor]:
/// 1. Fälliger Review aus [QuizQueueRepository] (E4 Spaced-Rep)
/// 2. Filter Pool nach `learnedTopics ∩ tiersFor(dayIndex)`
/// 3. Fallback: tier-Fenster only

abstract class _$DailyQuizState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Spec-45 Bucket I: Topics die der Spieler bereits in abgeschlossenen
/// Quests gelernt hat. Quelle: [QuestProgressRepository] + [kQuestTopics].

@ProviderFor(learnedTopics)
final learnedTopicsProvider = LearnedTopicsProvider._();

/// Spec-45 Bucket I: Topics die der Spieler bereits in abgeschlossenen
/// Quests gelernt hat. Quelle: [QuestProgressRepository] + [kQuestTopics].

final class LearnedTopicsProvider
    extends $FunctionalProvider<Set<String>, Set<String>, Set<String>>
    with $Provider<Set<String>> {
  /// Spec-45 Bucket I: Topics die der Spieler bereits in abgeschlossenen
  /// Quests gelernt hat. Quelle: [QuestProgressRepository] + [kQuestTopics].
  LearnedTopicsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learnedTopicsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learnedTopicsHash();

  @$internal
  @override
  $ProviderElement<Set<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String> create(Ref ref) {
    return learnedTopics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$learnedTopicsHash() => r'cb6eeb53e4c55ddc63a7a80aa4d3852d56430ce8';
