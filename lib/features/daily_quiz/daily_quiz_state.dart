import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../quest_runner/quest_availability.dart';
import '../quest_runner/quest_progress_repository.dart';
import '../settings/settings_repository.dart';
import 'quiz_pool.dart';
import 'quiz_question.dart';
import 'quiz_queue_repository.dart';
import 'quiz_topics.dart';

part 'daily_quiz_state.g.dart';

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
@Riverpod(keepAlive: true)
class DailyQuizState extends _$DailyQuizState {
  @override
  int build() {
    final settings = ref.watch(settingsRepositoryProvider);
    return settings.lastQuizDayIndex;
  }

  /// True if the quiz has not yet been shown on [dayIndex].
  bool shouldShow(int dayIndex) => state < dayIndex;

  /// Persist that the quiz has been shown on [dayIndex]. Idempotent.
  void markShown(int dayIndex) {
    if (state >= dayIndex) return;
    ref.read(settingsRepositoryProvider.notifier).setLastQuizDayIndex(dayIndex);
  }

  /// Welle-8 Round 15: persistierter Anti-Repeat-Set via Settings.
  /// Pool=24 → Fenster bis ~20 sinnvoll, damit Spieler nicht binnen Tagen
  /// dieselbe Frage zweimal sieht.
  static const int _recentWindow = 22;

  /// Welle-8 Round 24 (Fix B): Mindestgröße des learnedTopics∩Tier-Pools,
  /// damit Pfad 2 überhaupt genutzt wird. Darunter → Tier-only-Fallback für
  /// mehr Abwechslung (sonst klebt early-game an ~2 „sparen"-Fragen).
  static const int _minLearnedPool = 4;

  Set<String> _seenSet() {
    final csv = ref.read(settingsRepositoryProvider).recentQuizTextsCsv;
    return {
      for (final t in csv.split('|')) if (t.trim().isNotEmpty) t,
    };
  }

  void _rememberSeen(String text) {
    // Defer persistierten Set-Update aus dem aktuellen Build-Frame heraus
    // — sonst meckert Riverpod über "modify provider during build".
    Future<void>.microtask(() {
      final set = _seenSet().toList()..add(text);
      while (set.length > _recentWindow) {
        set.removeAt(0);
      }
      ref
          .read(settingsRepositoryProvider.notifier)
          .setRecentQuizTexts(set.join('|'));
    });
  }

  /// Welle-8: Same-day pick wird gecacht damit Aufrufe innerhalb desselben
  /// Tags idempotent sind (Tests + UI rebuilds).
  int? _cachedDay;
  QuizQuestion? _cachedQuestion;

  /// Topic-aware Pick für [dayIndex].
  /// Priorität: Queue → learnedTopics+Tier → Tier-only.
  /// Welle-8: filter recently-shown items aus dem Pool wenn möglich.
  QuizQuestion questionFor(int dayIndex) {
    if (_cachedDay == dayIndex && _cachedQuestion != null) {
      return _cachedQuestion!;
    }
    final queue = ref.read(quizQueueRepositoryProvider.notifier);
    final allowedTiers = tiersFor(dayIndex);

    // 1) Fälligen Review aus Queue picken (verbraucht Eintrag).
    //    Welle-8 Round 24 (Fix C): unter den Topic-Treffern unseen+random
    //    wählen statt fix ersten — sonst lieferte ein Zeitsprung mit vielen
    //    überfälligen Reviews desselben Topics immer exakt dieselbe Frage.
    final due = queue.popDueOn(dayIndex);
    if (due != null) {
      final match = _pickByTopic(due.topic, allowedTiers, dayIndex);
      if (match != null) return _cacheAndReturn(dayIndex, match);
    }

    // 2) Filter nach gelernten Topics ∩ Tier.
    //    Welle-8 Round 24 (Fix B): nur nutzen wenn der gefilterte Pool groß
    //    genug ist (≥ _minLearnedPool). Sonst hing der Spieler early-game an
    //    ~2 Fragen fest (nur Topic „sparen" easy) → fühlte sich an wie
    //    Dauer-Wiederholung. Bei zu kleinem Pool → durchfallen zu Tier-only.
    final learned = ref.read(learnedTopicsProvider);
    if (learned.isNotEmpty) {
      final pool = [
        for (final q in kQuizPool)
          if (q is MultipleChoiceQuestion &&
              learned.contains(q.topic) &&
              allowedTiers.contains(q.tier))
            q,
      ];
      if (pool.length >= _minLearnedPool) {
        final unseen = _filterUnseen(pool);
        if (unseen.isNotEmpty) {
          return _cacheAndReturn(
              dayIndex, _pickRandom(unseen, dayIndex));
        }
        // Pool erschöpft → seen-Set leeren, dann gesamten Pool zur Auswahl.
        _clearSeen();
        return _cacheAndReturn(dayIndex, _pickRandom(pool, dayIndex));
      }
    }

    // 3) Fallback: nur Tier-Fenster.
    final tierPool = [
      for (final q in kQuizPool)
        if (q is MultipleChoiceQuestion && allowedTiers.contains(q.tier)) q,
    ];
    final unseenTier = _filterUnseen(tierPool);
    if (unseenTier.isNotEmpty) {
      return _cacheAndReturn(dayIndex, _pickRandom(unseenTier, dayIndex));
    }
    if (tierPool.isNotEmpty) {
      _clearSeen();
      return _cacheAndReturn(dayIndex, _pickRandom(tierPool, dayIndex));
    }

    // Sicherheits-Fallback: erster Pool-Eintrag.
    return _cacheAndReturn(
        dayIndex, kQuizPool[dayIndex.abs() % kQuizPool.length]);
  }

  QuizQuestion _pickRandom(List<QuizQuestion> pool, int seed) {
    final rng = math.Random(seed * 977 + 13);
    return pool[rng.nextInt(pool.length)];
  }

  void _clearSeen() {
    Future<void>.microtask(() {
      ref
          .read(settingsRepositoryProvider.notifier)
          .setRecentQuizTexts('');
    });
  }

  List<QuizQuestion> _filterUnseen(List<QuizQuestion> pool) {
    final seen = _seenSet();
    return [
      for (final q in pool)
        if (q is MultipleChoiceQuestion && !seen.contains(q.text)) q,
    ];
  }

  QuizQuestion _trackAndReturn(QuizQuestion q) {
    if (q is MultipleChoiceQuestion) {
      _rememberSeen(q.text);
    }
    return q;
  }

  /// Setter aus questionFor heraus (Cache update vor return).
  QuizQuestion _cacheAndReturn(int dayIndex, QuizQuestion q) {
    _cachedDay = dayIndex;
    _cachedQuestion = q;
    return _trackAndReturn(q);
  }

  /// Welle-8 Round 24 (Fix C): Topic-Pick für den Spaced-Rep-Review-Pfad.
  /// Bevorzugt Topic+Tier, sonst Topic-only. Wählt unter den Treffern eine
  /// ungesehene Frage random.
  ///
  /// Round 29 (Sohn-Bug „Tagesfrage wiederholt sich oft"): KEIN Rückfall mehr
  /// auf den vollen Topic-Pool wenn alle Treffer schon gesehen sind. Ein dünnes
  /// Topic (1-2 Fragen) ist nach 1-2 Tagen erschöpft — vorher lieferte der
  /// Review dann stur dieselben Fragen Tag für Tag. Jetzt → null, der Aufrufer
  /// lässt den Review verfallen und nimmt den breiten Tier-Pool (Abwechslung).
  QuizQuestion? _pickByTopic(String topic, Set<int> allowedTiers, int seed) {
    final withTier = [
      for (final q in kQuizPool)
        if (q is MultipleChoiceQuestion &&
            q.topic == topic &&
            allowedTiers.contains(q.tier))
          q,
    ];
    final pool = withTier.isNotEmpty
        ? withTier
        : [
            for (final q in kQuizPool)
              if (q is MultipleChoiceQuestion && q.topic == topic) q,
          ];
    if (pool.isEmpty) return null;
    final unseen = _filterUnseen(pool);
    if (unseen.isEmpty) return null; // Topic erschöpft → breiter Pool übernimmt
    return _pickRandom(unseen, seed);
  }
}

/// Spec-45 Bucket I: Topics die der Spieler bereits in abgeschlossenen
/// Quests gelernt hat. Quelle: [QuestProgressRepository] + [kQuestTopics].
@Riverpod(keepAlive: true)
Set<String> learnedTopics(Ref ref) {
  final progress = ref.watch(questProgressRepositoryProvider);
  final result = <String>{};
  for (final entry in progress.entries) {
    if (entry.value.status != questStatusCompleted) continue;
    final topics = kQuestTopics[entry.key];
    if (topics != null) result.addAll(topics);
  }
  // Welle-8 Round 14: Quiz-Topics (1× richtig beantwortet) ergänzen.
  final settings = ref.watch(settingsRepositoryProvider);
  for (final t in settings.quizLearnedTopicsCsv.split(',')) {
    final trimmed = t.trim();
    if (trimmed.isNotEmpty) result.add(trimmed);
  }
  return result;
}
