import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/monetaria/island_header.dart';
import 'package:finanzgame/features/monetaria/island_identity.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

void main() {
  group('spec-17 island lessons', () {
    test('every island has a non-trivial (>=50 char) lesson', () {
      for (final entry in kIslandIdentities.entries) {
        expect(
          entry.value.lesson.length,
          greaterThanOrEqualTo(50),
          reason: '${entry.key} lesson too short: ${entry.value.lesson}',
        );
      }
    });

    testWidgets('"Was ist das?" button opens lesson bottom-sheet',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IslandHeader.forId(IslandId.sparInsel)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Was ist das?'), findsOneWidget);

      await tester.tap(find.text('Was ist das?'));
      await tester.pumpAndSettle();

      final lesson = islandIdentityFor(IslandId.sparInsel).lesson;
      expect(find.text(lesson), findsOneWidget);
      expect(find.text('Schließen'), findsOneWidget);

      // Close it
      await tester.tap(find.text('Schließen'));
      await tester.pumpAndSettle();
      expect(find.text(lesson), findsNothing);
    });
  });
}
