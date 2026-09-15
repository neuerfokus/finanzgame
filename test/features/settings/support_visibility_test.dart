import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/age/age_state.dart';
import 'package:finanzgame/features/settings/settings_page.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';

/// Der Unterstützen-Bereich darf für Minderjährige und bei fehlender Angabe
/// **gar nicht existieren** — nicht ausgegraut, nicht mit Schloss, nicht als
/// Hinweis. Ein Kind soll nicht einmal erfahren, dass es ihn gibt.
Future<void> _pumpSettings(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(home: SettingsPage()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Sucht im gesamten Baum nach allem, was den Bereich verraten würde.
void _expectSupportHidden() {
  expect(find.textContaining('Unterstützen'), findsNothing);
  expect(find.textContaining('Trinkgeld'), findsNothing);
  // Beide Namen: 'Ko-fi' ist der aktuelle Anbieter, 'PayPal' stand bis
  // 2026-09-15 im Knopf. Ein Rückfall auf die alte Beschriftung soll hier
  // genauso auffallen.
  expect(find.textContaining('Ko-fi'), findsNothing);
  expect(find.textContaining('PayPal'), findsNothing);
  expect(find.textContaining('erstatte'), findsNothing);
}

void main() {
  testWidgets('ohne Altersangabe ist der Bereich nicht im Baum',
      (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(ageStateProvider), AgeState.unknown);

    await _pumpSettings(tester, c);
    _expectSupportHidden();
  });

  testWidgets('bei minderjährig ist der Bereich nicht im Baum',
      (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(settingsRepositoryProvider.notifier).setBirthYear(
          DateTime.now().year - 12,
          currentYear: DateTime.now().year,
        );
    expect(c.read(ageStateProvider), AgeState.minor);

    await _pumpSettings(tester, c);
    _expectSupportHidden();
  });

  testWidgets('bei volljährig erscheint der Bereich inklusive '
      'Erstattungshinweis', (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(settingsRepositoryProvider.notifier).setBirthYear(
          DateTime.now().year - 40,
          currentYear: DateTime.now().year,
        );
    expect(c.read(ageStateProvider), AgeState.adult);

    await _pumpSettings(tester, c);
    expect(find.textContaining('Trinkgeld'), findsWidgets);

    // Der Erstattungshinweis MUSS ohne Aufklappen und ohne Elternschranke
    // sichtbar sein, sobald eine Kontaktadresse hinterlegt ist — er fängt den
    // Fall ab, den keine Schranke verhindern kann. Ohne Adresse (Default im
    // Quelltext, siehe kContactEmail) entfällt er zwangsläufig; vor einem
    // Store-Release ist die Adresse Pflicht.
    if (kContactEmail.isEmpty) {
      expect(find.textContaining('erstatte'), findsNothing);
    } else {
      expect(find.textContaining('erstatte'), findsOneWidget);
      expect(find.text(kContactEmail), findsOneWidget);
    }
  });

  // Der Änderungs-Eintrag muss in JEDEM Zustand da sein — sonst könnte sich
  // ein fälschlich als minderjährig eingestufter Erwachsener nie korrigieren,
  // und ein übersprungener Dialog wäre eine Sackgasse.
  testWidgets('Geburtsjahr nachholen ist ohne Angabe erreichbar',
      (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await _pumpSettings(tester, c);
    expect(find.text('Geburtsjahr'), findsOneWidget);
    // Ohne bestehende Angabe heißt der Knopf „Angeben": das ist das
    // Nachholen der übersprungenen Frage, nicht das Ändern einer Aussage —
    // und deshalb ohne Rechenaufgabe davor.
    expect(find.text('Angeben'), findsOneWidget);
    expect(find.text('Ändern'), findsNothing);
  });

  testWidgets('Geburtsjahr ändern ist auch für Minderjährige erreichbar',
      (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.read(settingsRepositoryProvider.notifier).setBirthYear(
          DateTime.now().year - 12,
          currentYear: DateTime.now().year,
        );
    await _pumpSettings(tester, c);
    expect(find.text('Geburtsjahr'), findsOneWidget);
    expect(find.text('Ändern'), findsOneWidget);
  });

  test('unplausible Eingabe wird nicht übernommen', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final repo = c.read(settingsRepositoryProvider.notifier);
    final year = DateTime.now().year;

    expect(repo.setBirthYear(year + 5, currentYear: year), isFalse);
    expect(c.read(settingsRepositoryProvider).birthYear, isNull);
    expect(c.read(ageStateProvider), AgeState.unknown);

    expect(repo.setBirthYear(year - 30, currentYear: year), isTrue);
    expect(c.read(ageStateProvider), AgeState.adult);
  });

  test('Überspringen merkt sich die Frage, ohne etwas zu speichern', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final repo = c.read(settingsRepositoryProvider.notifier);

    repo.markBirthYearAsked();
    final s = c.read(settingsRepositoryProvider);
    expect(s.birthYearAsked, isTrue);
    expect(s.birthYear, isNull);
    expect(c.read(ageStateProvider), AgeState.unknown);
  });
}
