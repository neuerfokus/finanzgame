import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/design_tokens.dart';
import 'package:finanzgame/ui/widgets/answer_button.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        backgroundColor: FgColors.backgroundPrimary,
        body: Center(child: child),
      ),
    );

/// Hintergrundfarbe der sichtbaren Button-Fläche (der Container mit dem
/// dicken schwarzen Rahmen, wie bei PixelButton).
Color? _faceColor(WidgetTester tester) {
  final boxes = tester
      .widgetList<Container>(find.descendant(
        of: find.byType(AnswerButton),
        matching: find.byType(Container),
      ))
      .map((c) => c.decoration)
      .whereType<BoxDecoration>()
      .where((d) => d.border != null);
  return boxes.first.color;
}

void main() {
  group('AnswerButton — gemeinsamer Antwort-Stil (Quest + Quiz)', () {
    testWidgets('offene Antwort ist gelb wie die Quest-Antworten',
        (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(
        AnswerButton(label: 'Antwort A', onPressed: () => tapped++),
      ));
      await tester.pumpAndSettle();
      expect(_faceColor(tester), FgColors.primary);
      await tester.tap(find.text('Antwort A'));
      expect(tapped, 1);
    });

    testWidgets('richtige Antwort bleibt grün, mit Präfix', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnswerButton(
          label: 'Antwort B',
          onPressed: null,
          feedback: AnswerFeedback.correct,
        ),
      ));
      await tester.pumpAndSettle();
      expect(_faceColor(tester), FgColors.success);
      expect(find.text('✓ Richtig: Antwort B'), findsOneWidget);
    });

    testWidgets('falsche Antwort bleibt rot, mit Präfix', (tester) async {
      await tester.pumpWidget(_wrap(
        const AnswerButton(
          label: 'Antwort C',
          onPressed: null,
          feedback: AnswerFeedback.wrong,
        ),
      ));
      await tester.pumpAndSettle();
      expect(_faceColor(tester), FgColors.alert);
      expect(find.text('✗ Falsch: Antwort C'), findsOneWidget);
    });

    testWidgets('Fehlversuch (noch nicht aufgelöst) ist rötlich markiert',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AnswerButton(
          label: 'Antwort D',
          onPressed: null,
          feedback: AnswerFeedback.wrongTry,
        ),
      ));
      await tester.pumpAndSettle();
      final c = _faceColor(tester)!;
      expect(c, isNot(FgColors.primary));
      expect(c, isNot(FgColors.neutral));
      expect(find.text('✗ Antwort D'), findsOneWidget);
    });

    testWidgets('Semantics: Button-Rolle + Ergebnis im vorgelesenen Label',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_wrap(
        const AnswerButton(
          label: 'Antwort E',
          onPressed: null,
          feedback: AnswerFeedback.correct,
          selected: true,
        ),
      ));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.bySemanticsLabel('✓ Richtig: Antwort E')),
        isSemantics(
          label: '✓ Richtig: Antwort E',
          isButton: true,
          isSelected: true,
        ),
      );
      handle.dispose();
    });
  });
}
