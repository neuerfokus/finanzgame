import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/main.dart';

void main() {
  testWidgets('Springboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Spec-17: pretend the daily quiz already fired today so the
          // springboard isn't covered by the overlay during this smoke test.
          dbSnapshotProvider.overrideWithValue(
            const DbSnapshot(
              settings: SettingsSnapshot(
                lastQuizDayIndex: 0,
                onboardingComplete: true,
              ),
              questProgress: {
                'q00_tutorial': QuestProgressRow(
                  questId: 'q00_tutorial',
                  currentStepIndex: 0,
                  status: 'completed',
                  startedOnDayIndex: 0,
                  completedOnDayIndex: 0,
                ),
              },
            ),
          ),
        ],
        child: const FinanzgameApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Spec-43 v4: Tag/Jahr/Alter sind nur noch in StatusBar.
    expect(find.textContaining('Tag 1'), findsOneWidget);
    expect(find.text('Schlafen 😴'), findsOneWidget);
    expect(find.text('Bank'), findsOneWidget);
    expect(find.text('Monetaria'), findsOneWidget);
  });
}
