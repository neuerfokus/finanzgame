import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/daily_quiz/daily_quiz_state.dart';
import 'package:finanzgame/features/daily_quiz/quiz_queue_repository.dart';
import 'package:finanzgame/features/daily_quiz/quiz_question.dart';

Future<void> _flush() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  // Sohn-Report: „Tagesfrage wiederholt sich oft." Root cause: der Spaced-Rep-
  // Review-Pfad ist topic-gelockt. Bei einem dünnen Topic (1-2 Fragen) waren
  // nach 1-2 Tagen alle gesehen — der alte Picker fiel dann auf den VOLLEN
  // Topic-Pool zurück (seen-Set ignoriert) → dieselbe Frage Tag für Tag.
  //
  // Erwartet nach Fix: ist ein fälliger Review erschöpft (kein ungesehener
  // Topic-Treffer), verfällt er und der breite Tier-Pool übernimmt → keine
  // Wiederholung.
  test('fällige Reviews eines dünnen Topics wiederholen sich nicht', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);

    // notgroschen hat im easy-Tier nur ~2 Fragen. Mehrfach enqueuen → viele
    // fällige Reviews ab Tag 1, simuliert mehrere abgeschlossene Quests.
    final queue = c.read(quizQueueRepositoryProvider.notifier);
    for (var i = 0; i < 6; i++) {
      queue.enqueueForQuest('q03_notgroschen', 0); // due 1/3/7, topic notgroschen
    }

    // Tage 1..12 (alle < 30 → easy-Tier). Notifier jeden Tag frisch lesen,
    // weil _rememberSeen die Settings mutiert → Provider-Rebuild (wie UI).
    final texts = <String>[];
    for (var day = 1; day <= 12; day++) {
      final q = c.read(dailyQuizStateProvider.notifier).questionFor(day)
          as MultipleChoiceQuestion;
      texts.add(q.text);
      await _flush();
    }

    final distinct = texts.toSet();
    expect(
      distinct.length,
      texts.length,
      reason: 'Wiederholte Fragen in 12 Tagen: '
          '${texts.length - distinct.length}. Sequenz: $texts',
    );
  });
}
