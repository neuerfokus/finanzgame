import 'package:finanzgame/core/design_tokens.dart';
import 'package:finanzgame/game/monetaria/components/island_label_layout.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lesbare Schrift nutzt die Plattformschrift, sonst Pixel',
      (tester) async {
    final lesbar = layoutIslandLabel('Spar-Insel', readableFont: true, scale: 1);
    final pixel = layoutIslandLabel('Spar-Insel', readableFont: false, scale: 1);
    expect(lesbar.style.fontFamily, isNull);
    expect(pixel.style.fontFamily, FgTypography.pixelFamily);
  });

  testWidgets('Schriftfaktor vergrößert die Beschriftung, gedeckelt auf 1,6',
      (tester) async {
    // Kurzes Wort: im Testlauf misst die Ahem-Schrift jedes Zeichen so
    // breit wie hoch, ein längerer Name würde schon verkleinert.
    final normal = layoutIslandLabel('ETF', readableFont: true, scale: 1);
    final gross = layoutIslandLabel('ETF', readableFont: true, scale: 1.2);
    final riesig = layoutIslandLabel('ETF', readableFont: true, scale: 3);
    expect(gross.style.fontSize, greaterThan(normal.style.fontSize!));
    expect(
      riesig.style.fontSize,
      lessThanOrEqualTo(kIslandLabelBaseSize * kIslandLabelMaxScale),
    );
  });

  testWidgets(
      'kein Inselname wird breiter als erlaubt — sonst überdeckt er den '
      'Nachbarn (Abstand 260)', (tester) async {
    for (final spec in kIslandSpecs) {
      for (final readable in [true, false]) {
        for (final scale in [0.9, 1.0, 1.2, 1.6]) {
          final l = layoutIslandLabel(
            spec.label,
            readableFont: readable,
            scale: scale,
          );
          expect(
            l.width,
            lessThanOrEqualTo(kIslandLabelMaxWidth),
            reason: '${spec.label} lesbar=$readable faktor=$scale',
          );
        }
      }
    }
  });

  testWidgets('zu breiter Name bricht am Bindestrich um', (tester) async {
    final l = layoutIslandLabel(
      'Goldminen-Insel',
      readableFont: true,
      scale: 1.6,
    );
    expect(l.text, 'Goldminen-\nInsel');
  });
}
