import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/audio/sound_service.dart';
import 'package:finanzgame/features/daily_quiz/daily_quiz_page.dart';
import 'package:finanzgame/features/daily_quiz/daily_quiz_state.dart';
import 'package:finanzgame/features/daily_quiz/quiz_question.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/xp/xp_repository.dart';
import 'package:finanzgame/ui/widgets/glossar_text.dart';

void main() {
  setUp(() => SoundService.use(RecordingSoundService()));
  tearDown(SoundService.reset);

  group('DailyQuizPage (spec-17)', () {
    testWidgets('correct answer awards cash + XP', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dbSnapshotProvider.overrideWithValue(
            const DbSnapshot(cashCents: 1000, xpTotal: 0),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: DailyQuizPage()),
        ),
      );
      await tester.pump();

      // Welle-8 Round 17: questionFor jetzt Random-Pick — Frage aus
      // Notifier holen statt aus kQuizPool[0].
      final q = container
          .read(dailyQuizStateProvider.notifier)
          .questionFor(0) as MultipleChoiceQuestion;
      final cashBefore = container.read(cashStateProvider);
      final xpBefore = container.read(xpRepositoryProvider);

      // Tap the correct option's label. Round 27 v6: ensureVisible, da
      // manche Fragen (z.B. Fake-Shop) lange Optionen haben, die im
      // 800×600-Test-Surface unter den Fold rutschen → tap verfehlt sonst.
      final correctFinder = find.text(q.options[q.correctIndex]);
      await tester.ensureVisible(correctFinder);
      await tester.tap(correctFinder);
      await tester.pumpAndSettle();

      final cashAfter = container.read(cashStateProvider);
      final xpAfter = container.read(xpRepositoryProvider);

      expect(cashAfter, cashBefore + DailyQuizPage.rewardForTier(q.tier));
      expect(xpAfter, xpBefore + XpRewards.dailyQuizCorrect);

      // Explanation now visible — rendered via GlossarText.
      expect(find.byType(GlossarText), findsAtLeastNWidgets(1));
    });

    testWidgets('wrong answer gives XP but no cash', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dbSnapshotProvider.overrideWithValue(
            const DbSnapshot(cashCents: 1000, xpTotal: 0),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: DailyQuizPage()),
        ),
      );
      await tester.pump();

      // Welle-8 Round 17: questionFor jetzt Random-Pick — Frage aus
      // Notifier holen statt aus kQuizPool[0].
      final q = container
          .read(dailyQuizStateProvider.notifier)
          .questionFor(0) as MultipleChoiceQuestion;
      // Spec-43 follow-up: 2 Versuche erlaubt. Beide falsch → finalized,
      // XP wird vergeben, kein Cash.
      final wrongs = <int>[];
      for (var i = 0; i < q.options.length; i++) {
        if (i != q.correctIndex) wrongs.add(i);
      }
      final cashBefore = container.read(cashStateProvider);

      final w0 = find.text(q.options[wrongs[0]]);
      await tester.ensureVisible(w0);
      await tester.tap(w0);
      await tester.pumpAndSettle();
      final w1 = find.text(q.options[wrongs[1]]);
      await tester.ensureVisible(w1);
      await tester.tap(w1);
      await tester.pumpAndSettle();

      expect(container.read(cashStateProvider), cashBefore);
      expect(
        container.read(xpRepositoryProvider),
        XpRewards.dailyQuizCorrect,
      );
    });

    testWidgets('skip button closes and marks shown', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dbSnapshotProvider.overrideWithValue(
            const DbSnapshot(),
          ),
        ],
      );
      addTearDown(container.dispose);

      bool popped = false;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  await Navigator.of(ctx).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const DailyQuizPage(),
                    ),
                  );
                  popped = true;
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // shouldShow(0) currently true
      expect(
        container.read(dailyQuizStateProvider.notifier).shouldShow(0),
        isTrue,
      );

      await tester.tap(find.byKey(const Key('daily_quiz_skip')));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
      // After skip, shouldShow(0) is now false
      expect(
        container.read(dailyQuizStateProvider.notifier).shouldShow(0),
        isFalse,
      );
    });

    testWidgets('Weiter button closes after answering', (tester) async {
      final container = ProviderContainer(
        overrides: [
          dbSnapshotProvider.overrideWithValue(const DbSnapshot()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.of(ctx).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const DailyQuizPage(),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Welle-8 Round 17: questionFor jetzt Random-Pick — Frage aus
      // Notifier holen statt aus kQuizPool[0].
      final q = container
          .read(dailyQuizStateProvider.notifier)
          .questionFor(0) as MultipleChoiceQuestion;
      final correctFinder = find.text(q.options[q.correctIndex]);
      await tester.ensureVisible(correctFinder);
      await tester.tap(correctFinder);
      await tester.pump();

      // Weiter button exists now
      expect(find.byKey(const Key('daily_quiz_continue')), findsOneWidget);

      await tester.tap(find.byKey(const Key('daily_quiz_continue')));
      await tester.pumpAndSettle();

      // Quiz page is gone
      expect(find.byType(DailyQuizPage), findsNothing);
      // Marked shown
      expect(
        container.read(dailyQuizStateProvider.notifier).shouldShow(0),
        isFalse,
      );
    });
  });
}

