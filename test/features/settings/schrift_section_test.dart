import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/settings/settings_page.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';
import 'package:finanzgame/features/settings/text_scale.dart';

Future<ProviderContainer> _pump(WidgetTester tester) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: SettingsPage()),
    ),
  );
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    find.byKey(const Key('schrift_vorschau')),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  group('Einstellungen: Abschnitt Schrift', () {
    testWidgets('Schalter „Lesbare Schrift“ schaltet readableFont',
        (tester) async {
      final c = await _pump(tester);
      expect(find.text('Schrift'), findsOneWidget);
      expect(find.text('Lesbare Schrift'), findsOneWidget);
      expect(c.read(settingsRepositoryProvider).readableFont, isTrue);

      await _tap(tester, find.byKey(const Key('schrift_lesbar_switch')));
      expect(c.read(settingsRepositoryProvider).readableFont, isFalse);
    });

    testWidgets('Chips Klein/Normal/Groß setzen die Stufe', (tester) async {
      final c = await _pump(tester);
      for (final label in ['Klein', 'Normal', 'Groß']) {
        expect(find.widgetWithText(ChoiceChip, label), findsOneWidget);
      }
      await _tap(tester, find.widgetWithText(ChoiceChip, 'Groß'));
      expect(c.read(settingsRepositoryProvider).textScale,
          TextScaleStufe.gross);
      final gross =
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Groß'));
      expect(gross.selected, isTrue);

      await _tap(tester, find.widgetWithText(ChoiceChip, 'Klein'));
      expect(c.read(settingsRepositoryProvider).textScale,
          TextScaleStufe.klein);
    });

    testWidgets('Schalter ist für TalkBack benannt', (tester) async {
      final handle = tester.ensureSemantics();
      await _pump(tester);
      expect(
        tester.getSemantics(find.byKey(const Key('schrift_lesbar_switch'))),
        isSemantics(
          label: 'Lesbare Schrift\nAus = Pixel-Schrift überall',
          hasToggledState: true,
          isToggled: true,
        ),
      );
      handle.dispose();
    });
  });
}
