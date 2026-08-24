import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wissens_quiz_stats.g.dart';

/// Spec-43 v4: in-memory aggregate des Wissens-Quiz-Modus.
///
/// Tracks lifetime Spielereien dieser Session — Sessions/Total-Attempts,
/// Total-Correct, Best-Score. Wird zurückgesetzt bei App-Restart.
class WissensQuizStats {
  const WissensQuizStats({
    this.sessions = 0,
    this.totalQuestions = 0,
    this.totalCorrect = 0,
    this.bestCorrect = 0,
    this.lastCorrect = 0,
    this.lastTotal = 0,
    this.wrongTexts = const <String>{},
    this.seenTexts = const <String>{},
  });

  final int sessions;
  final int totalQuestions;
  final int totalCorrect;
  final int bestCorrect;
  final int lastCorrect;
  final int lastTotal;

  /// Spec-43 v8: Fragen die noch nicht richtig im 1. Versuch beantwortet
  /// wurden. Diese werden im nächsten Session-Pool priorisiert (Lerneffekt).
  final Set<String> wrongTexts;

  /// Round 27 v6: kürzlich GEZEIGTE Fragen (Anti-Repeat). Wird im nächsten
  /// Session-Pool zurückgestellt, damit nicht jede Session dieselben 10
  /// Fragen kommen. In-memory (resetet bei App-Restart) — reicht für die
  /// „doppeln sich oft"-Beschwerde innerhalb einer Spiel-Sitzung.
  final Set<String> seenTexts;

  double get winRate =>
      totalQuestions == 0 ? 0 : totalCorrect / totalQuestions;
}

@Riverpod(keepAlive: true)
class WissensQuizStatsRepo extends _$WissensQuizStatsRepo {
  @override
  WissensQuizStats build() => const WissensQuizStats();

  void recordSession({
    required int correct,
    required int total,
    Set<String> newlyMastered = const {},
    Set<String> newlyWrong = const {},
    Set<String> shownTexts = const {},
  }) {
    final s = state;
    final wrong = {...s.wrongTexts, ...newlyWrong}
      ..removeWhere(newlyMastered.contains);
    // Round 27 v6: gezeigte Fragen merken (Anti-Repeat). Wenn fast der
    // ganze Pool gesehen wurde, Set leeren — sonst gäbe es keine frischen
    // Fragen mehr. Schwelle wird vom Caller (kQuizPool-Größe) bestimmt.
    final seen = {...s.seenTexts, ...shownTexts};
    state = WissensQuizStats(
      sessions: s.sessions + 1,
      totalQuestions: s.totalQuestions + total,
      totalCorrect: s.totalCorrect + correct,
      bestCorrect: correct > s.bestCorrect ? correct : s.bestCorrect,
      lastCorrect: correct,
      lastTotal: total,
      wrongTexts: wrong,
      seenTexts: seen,
    );
  }

  /// Round 27 v6: Anti-Repeat-Set leeren, wenn der Pool fast durch ist.
  void resetSeen() {
    final s = state;
    state = WissensQuizStats(
      sessions: s.sessions,
      totalQuestions: s.totalQuestions,
      totalCorrect: s.totalCorrect,
      bestCorrect: s.bestCorrect,
      lastCorrect: s.lastCorrect,
      lastTotal: s.lastTotal,
      wrongTexts: s.wrongTexts,
      seenTexts: const {},
    );
  }
}
