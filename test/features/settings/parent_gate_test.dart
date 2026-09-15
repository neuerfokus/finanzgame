import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/settings/parent_gate.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';

/// Test-Fund: ohne gesetzten Eltern-PIN liess sich „Eltern bestätigen"
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

  testWidgets('Einrichten allein gibt die Belohnung NICHT frei',
      (tester) async {
    // Vorher lieferte _offerSetup direkt true: wer zweimal dieselben vier
    // Ziffern eintippte, bekam die Belohnung sofort — das Einrichten WAR die
    // Freigabe, ein Erwachsener war nie beteiligt. Jetzt sind es zwei
    // getrennte Handlungen.
    final c = ProviderContainer();
    addTearDown(c.dispose);

    final results = await pumpGate(tester, c);
    await tester.tap(find.text('PIN festlegen'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '4321');
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '4321');
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    // PIN steht — die Belohnung aber nicht.
    expect(c.read(settingsRepositoryProvider).parentPin, isNotEmpty);
    expect(results, [false],
        reason: 'Das Anlegen des PINs darf die Belohnung nicht mitgeben');

    // Zweiter Anlauf mit dem gerade gesetzten PIN gibt frei.
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '4321');
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    expect(results, [false, true]);
  });

  group('verifyIfConfigured (Spielstand ersetzen)', () {
    Future<List<bool?>> pumpVerify(
        WidgetTester tester, ProviderContainer c) async {
      final results = <bool?>[];
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  onPressed: () async {
                    results.add(
                        await ParentGate.verifyIfConfigured(context, ref));
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

    testWidgets('ohne PIN: laesst durch, ohne Einrichten zu verlangen',
        (tester) async {
      // Ohne PIN ist auch die Einstellungsseite offen — es gaebe nichts zu
      // schuetzen. Und der Datei-Oeffnen-Import ist zugleich der Rettungsweg
      // nach einem beschaedigten Spielstand: wer seine Sicherung einspielen
      // will, soll nicht zuerst ein Einrichtungsformular ausfuellen muessen.
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final results = await pumpVerify(tester, c);
      expect(results, [true]);
      expect(find.text('Eltern-PIN einrichten'), findsNothing);
    });

    testWidgets('mit PIN: verlangt ihn und lehnt falsche Eingabe ab',
        (tester) async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(settingsRepositoryProvider.notifier).setParentPin('1234');

      final results = await pumpVerify(tester, c);
      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
      expect(results, [false]);
    });

    testWidgets('mit PIN: richtige Eingabe laesst durch', (tester) async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(settingsRepositoryProvider.notifier).setParentPin('1234');

      final results = await pumpVerify(tester, c);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();
      expect(results, [true]);
    });
  });
}
