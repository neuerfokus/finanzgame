import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/glossar/glossar_entries.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

/// Die Insel-Übersicht lag früher im Hilfe-Dialog des Heimathafens. Die Seite
/// ist weg (der Hafen springt jetzt direkt ins Hauptmenü), der Inhalt wurde
/// ins Glossar gerettet — dort ist er durchsuchbar.
void main() {
  final entry = kGlossar.firstWhere(
    (e) => e.term == 'Inseln von Monetaria',
    orElse: () => throw StateError('Insel-Übersicht fehlt im Glossar'),
  );

  test('Glossar-Eintrag existiert und erklärt die Freischaltung', () {
    expect(entry.definition, isNotEmpty);
    expect(entry.example, isNotNull);
    expect(entry.example!.toLowerCase(), contains('xp'));
    expect(entry.example!.toLowerCase(), contains('quest'));
  });

  test('nennt JEDE Insel — und zwar unter ihrem Karten-Namen', () {
    // Guard gegen Text-Drift: früher stand im Hilfe-Dialog „Mischwald" und
    // „Goldmine", während die Karte „Sammlerinsel" und „Goldminen-Insel"
    // anzeigte. Wird eine Insel umbenannt, bricht dieser Test.
    for (final spec in kIslandSpecs) {
      expect(
        entry.definition,
        contains(spec.label),
        reason: '${spec.id} („${spec.label}") fehlt in der Übersicht',
      );
    }
  });

  test('Übersicht ist vollständig — keine Insel vergessen', () {
    // Jede Zeile der Definition beschreibt genau eine Insel.
    final lines = entry.definition
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    expect(lines, hasLength(kIslandSpecs.length));
  });
}
