import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/design_tokens.dart';
import 'package:finanzgame/core/fg_theme.dart';
import 'package:finanzgame/ui/widgets/glossar_text.dart';

/// GlossarText mit Treffer lief über ein rohes RichText: das erbt weder den
/// DefaultTextStyle (also nie die Schrift aus dem Theme) noch die
/// Schriftgröße aus MediaQuery. Mit der Lesbarkeits-Einstellung muss es sich
/// verhalten wie jeder andere Fließtext.
Widget _wrap({required bool readable, double scale = 1.0}) => MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: MaterialApp(
        theme: buildFgTheme(readableFont: readable),
        home: const Scaffold(
          body: GlossarText(
            'Eine Aktie ist ein Anteil.',
            style: FgTypography.bodyM,
          ),
        ),
      ),
    );

RichText _rich(WidgetTester tester) => tester.widget<RichText>(
      find.descendant(
        of: find.byType(GlossarText),
        matching: find.byType(RichText),
      ),
    );

void main() {
  testWidgets('Glossar-Treffer folgt der Schrift-Einstellung', (tester) async {
    await tester.pumpWidget(_wrap(readable: false));
    expect(_rich(tester).text.style?.fontFamily, FgTypography.pixelFamily);

    await tester.pumpWidget(_wrap(readable: true));
    await tester.pumpAndSettle(); // AnimatedTheme blendet über
    expect(_rich(tester).text.style?.fontFamily,
        isNot(FgTypography.pixelFamily));
  });

  testWidgets('Glossar-Treffer skaliert mit der Schriftgröße', (tester) async {
    await tester.pumpWidget(_wrap(readable: true, scale: 1.2));
    expect(_rich(tester).textScaler.scale(10), closeTo(12, 0.001));
  });
}
