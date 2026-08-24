import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/settings/parent_gate.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';

/// Sohn-Fund: ohne gesetzten Eltern-PIN liess sich „Eltern bestätigen"
/// einfach selbst drücken — XP (bis 600 beim Sparziel, 150 pro echtem Erfolg)
/// plus Trophäe auf Knopfdruck, beliebig oft. Der Gate verlangt jetzt einen
/// PIN und führt, wenn keiner existiert, ins Einrichten.
void main() {
  /// Pumpt einen Button, der den Gate aufruft, und merkt sich das Ergebnis.
  Future<List<bool?>> pumpGate(WidgetTester tester, ProviderContainer c) async {
    final results = <bool?>[];
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => ElevatedButton(
                onPressed: () async {
                  results.add(await ParentGate.require(context, ref));
                },
                child: const Text('go'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    return results;
  }

  testWidgets('ohne PIN: Gate gibt NICHT frei, sondern bietet Einrichten an',
      (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(settingsRepositoryProvider).parentPin, isEmpty);

    final results = await pumpGate(tester, c);

    // Der Einrichten-Dialog steht — freigegeben ist noch nichts.
    expect(find.text('Eltern-PIN einrichten'), findsOneWidget);
    expect(results, isEmpty, reason: 'Gate wartet noch auf die Eingabe');

    // „Später" → keine Freigabe, kein PIN gesetzt.
    await tester.tap(find.text('Später'));
    await tester.pumpAndSettle();
    expect(results, [false]);
    expect(c.read(settingsRepositoryProvider).parentPin, isEmpty);
  });

  testWidgets('mit PIN: falsche Eingabe gibt nicht frei', (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(settingsRepositoryProvider.notifier).setParentPin('1234');

    final results = await pumpGate(tester, c);
    await tester.enterText(find.byType(TextField), '9999');
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    expect(results, [false]);
  });

  testWidgets('mit PIN: richtige Eingabe gibt frei', (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(settingsRepositoryProvider.notifier).setParentPin('1234');

    final results = await pumpGate(tester, c);
    await tester.enterText(find.byType(TextField), '1234');
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    expect(results, [true]);
  });
}
