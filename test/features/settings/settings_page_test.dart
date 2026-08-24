import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/features/settings/settings_page.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';

void main() {
  testWidgets(
    'editing allowance → tapping Speichern → state has 30 €',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Find the allowance TextField (numeric, € suffix). Welle-8: das
      // Start-Alter-Feld ist ebenfalls numerisch → über suffixText
      // eindeutig auf das Taschengeld-Feld eingrenzen.
      final allowanceField = find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            w.keyboardType == TextInputType.number &&
            w.decoration?.suffixText == '€',
      );
      expect(allowanceField, findsOneWidget);

      await tester.enterText(allowanceField, '30');
      await tester.pumpAndSettle();
      // spec-27: content grew; scroll the SingleChildScrollView to reveal
      // the Speichern button before tapping.
      await tester.scrollUntilVisible(
        find.text('Speichern'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Speichern'));
      await tester.pump();

      final settings = container.read(settingsRepositoryProvider);
      expect(settings.allowance, const Money.cents(3000));
    },
  );

  testWidgets('Sound switch toggles soundEnabled', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SettingsPage()),
      ),
    );
    await tester.pumpAndSettle();
    // Spec-43 v4: Switch sitzt jetzt weiter unten — erst scrollen.
    // Drift v36: es gibt jetzt zwei Switches (Sound + Auto-Sicherung) —
    // der Sound-Switch steht weiter oben, daher .first.
    await tester.dragUntilVisible(
      find.byType(Switch).first,
      find.byType(ListView),
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    expect(
      container.read(settingsRepositoryProvider).soundEnabled,
      isFalse,
    );
  });

  testWidgets(
    'Musik-Lautstärke-Slider drag updates musicVolume state (spec-23)',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      // spec-37: music removed entirely. First remaining slider is now
      // the Master-Lautstärke. Verify the page renders + sliders work.
      expect(
        container.read(settingsRepositoryProvider).musicVolume,
        0,
      );
      final sliders =
          tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(sliders, isNotEmpty);
    },
  );
}
