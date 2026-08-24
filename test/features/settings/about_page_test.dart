import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/settings/about_page.dart';

/// spec-46: die Möbel-Sprites sind Twemoji unter CC-BY 4.0. Diese Lizenz
/// verlangt eine sichtbare Namensnennung — fehlt sie, darf die App nicht
/// verteilt werden. Der Test hält genau das fest, damit die Nennung nicht
/// bei einem UI-Umbau still verschwindet.
void main() {
  // PhoneFrame zieht die StatusBar, die auf Providern sitzt — ohne Scope
  // wirft sie beim Bauen.
  Future<void> pumpAbout(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AboutPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Sucht über alle Text-Widgets, weil die Nennungen in mehreren Absätzen
  /// stehen und `find.textContaining` nur ganze Widgets vergleicht.
  bool mentions(WidgetTester tester, String needle) {
    return tester
        .widgetList<Text>(find.byType(Text))
        .any((t) => (t.data ?? '').contains(needle));
  }

  testWidgets('nennt Twemoji samt CC-BY-Lizenz (Lizenzbedingung)',
      (tester) async {
    await pumpAbout(tester);
    expect(mentions(tester, 'Twemoji'), isTrue);
    expect(mentions(tester, 'CC-BY 4.0'), isTrue);
  });

  testWidgets('nennt Kenney und die eigene Lizenzierung', (tester) async {
    await pumpAbout(tester);
    expect(mentions(tester, 'Kenney'), isTrue);
    expect(mentions(tester, 'GNU General Public License'), isTrue);
    expect(mentions(tester, 'CC-BY-SA 4.0'), isTrue);
  });

  testWidgets('sagt, dass es keine Anlageberatung ist und nichts sendet',
      (tester) async {
    await pumpAbout(tester);
    expect(mentions(tester, 'keine'), isTrue);
    expect(mentions(tester, 'Anlageberatung'), isTrue);
    expect(mentions(tester, 'sendet nichts'), isTrue);
  });
}
