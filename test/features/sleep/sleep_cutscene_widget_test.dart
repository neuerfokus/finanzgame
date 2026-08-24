import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/sleep/sleep_cutscene_widget.dart';

void main() {
  group('SleepCutsceneWidget', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SleepCutsceneWidget(onComplete: () {}),
        ),
      );

      // Initial render should show the widget.
      expect(find.byType(SleepCutsceneWidget), findsOneWidget);
    });

    testWidgets('calls onComplete after full cutscene via pumpAndSettle',
        (tester) async {
      var completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SleepCutsceneWidget(onComplete: () => completed = true),
        ),
      );

      // Not complete yet.
      expect(completed, isFalse);

      // pumpAndSettle runs frames until no more are pending, up to timeout.
      // Default timeout is 100ms per interval, 1000 total. We need ~2800ms
      // total, so we pump through all phases with a generous timeout.
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 10),
      );

      expect(completed, isTrue);
    });

    testWidgets('shows AnimatedBuilder during fadeBlack phase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SleepCutsceneWidget(onComplete: () {}),
        ),
      );

      // At t=0 the fadeBlack phase is active — AnimatedBuilder wraps Opacity.
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('shows AnimatedBuilder during moon phase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SleepCutsceneWidget(onComplete: () {}),
        ),
      );

      // Advance past fade-black (800ms) + two extra pumps to flush the async
      // setState chain that transitions to moon phase.
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump();
      await tester.pump();

      // During moon phase the rotating moon widget uses AnimatedBuilder.
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('no crash when widget is replaced mid-cutscene', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SleepCutsceneWidget(onComplete: () {}),
        ),
      );

      // Advance only partway through the cutscene.
      await tester.pump(const Duration(milliseconds: 500));

      // Replace the widget before the cutscene finishes.
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('replaced'))),
      );

      // Advance past the point where onComplete would have fired.
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // Verify no crash occurred and the replacement widget is shown.
      expect(find.text('replaced'), findsOneWidget);
    });

    testWidgets('shows Opacity widget during fadeBlack phase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SleepCutsceneWidget(onComplete: () {}),
        ),
      );

      // At time 0 the fadeBlack phase is active.
      expect(find.byType(Opacity), findsWidgets);

      // Advance partway through fade-black — opacity should be increasing.
      await tester.pump(const Duration(milliseconds: 400));

      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      expect(opacityWidgets, isNotEmpty);
    });
  });
}
