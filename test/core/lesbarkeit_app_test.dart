import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/design_tokens.dart';
import 'package:finanzgame/core/fg_text_scaler.dart';
import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/main.dart';
import 'package:finanzgame/ui/widgets/status_bar.dart';

/// Springboard mit gegebenen Lesbarkeits-Einstellungen (wie widget_test.dart,
/// Tages-Quiz + Tutorial als erledigt markiert).
Widget _app({bool readableFont = true, int textScalePct = 100}) {
  return ProviderScope(
    overrides: [
      dbSnapshotProvider.overrideWithValue(
        DbSnapshot(
          settings: SettingsSnapshot(
            lastQuizDayIndex: 0,
            onboardingComplete: true,
            birthYearAsked: true,
            readableFont: readableFont,
            textScalePct: textScalePct,
          ),
          questProgress: const {
            'q00_tutorial': QuestProgressRow(
              questId: 'q00_tutorial',
              currentStepIndex: 0,
              status: 'completed',
              startedOnDayIndex: 0,
              completedOnDayIndex: 0,
            ),
          },
        ),
      ),
    ],
    child: const FinanzgameApp(),
  );
}

/// Effektive Schriftfamilie eines Textes (Text merged seinen Stil mit dem
/// DefaultTextStyle und reicht das Ergebnis an RichText weiter).
String? _familyOf(WidgetTester tester, Finder text) {
  final rich = tester.widget<RichText>(
    find.descendant(of: text, matching: find.byType(RichText)).first,
  );
  return rich.text.style?.fontFamily;
}

/// Ein Fließtext-Probestück, eingehängt ins echte App-Theme.
class _Probe extends StatelessWidget {
  const _Probe();

  @override
  Widget build(BuildContext context) => const Text(
        'Fließtext-Probe',
        style: FgTypography.bodyM,
      );
}

void main() {
  group('Lesbare Schrift', () {
    testWidgets('AN: Fließtext in Systemschrift, HUD bleibt Pixel',
        (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      final ctx = tester.element(find.byType(StatusBar));
      final theme = Theme.of(ctx);
      expect(theme.textTheme.bodyMedium?.fontFamily,
          isNot(FgTypography.pixelFamily));
      expect(theme.textTheme.labelLarge?.fontFamily,
          isNot(FgTypography.pixelFamily));
      // Überschriften-Rollen bleiben Pixel.
      expect(theme.textTheme.titleLarge?.fontFamily, FgTypography.pixelFamily);

      // Ein bodyM-Text erbt die Systemschrift …
      await tester.pumpWidget(
        MaterialApp(theme: theme, home: const Scaffold(body: _Probe())),
      );
      expect(_familyOf(tester, find.text('Fließtext-Probe')),
          isNot(FgTypography.pixelFamily));

      // … die Statusleiste (HUD) bleibt Pixel.
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      expect(
        _familyOf(tester, find.textContaining('Tag 1')),
        FgTypography.pixelFamily,
      );
    });

    testWidgets('AUS: Pixel-Schrift überall (alter Look)', (tester) async {
      await tester.pumpWidget(_app(readableFont: false));
      await tester.pumpAndSettle();
      final theme = Theme.of(tester.element(find.byType(StatusBar)));
      expect(theme.textTheme.bodyMedium?.fontFamily, FgTypography.pixelFamily);
      expect(theme.textTheme.labelLarge?.fontFamily, FgTypography.pixelFamily);

      await tester.pumpWidget(
        MaterialApp(theme: theme, home: const Scaffold(body: _Probe())),
      );
      expect(_familyOf(tester, find.text('Fließtext-Probe')),
          FgTypography.pixelFamily);
    });
  });

  group('Schriftgröße', () {
    Future<TextScaler> scalerIn(WidgetTester tester) async {
      await tester.pumpAndSettle();
      return MediaQuery.textScalerOf(tester.element(find.byType(StatusBar)));
    }

    testWidgets('Normal: System-Skalierung unverändert', (tester) async {
      await tester.pumpWidget(_app());
      expect((await scalerIn(tester)).scale(10), closeTo(10, 0.001));
    });

    testWidgets('Groß: × 1,2', (tester) async {
      await tester.pumpWidget(_app(textScalePct: 120));
      expect((await scalerIn(tester)).scale(10), closeTo(12, 0.001));
    });

    testWidgets('Klein: × 0,9', (tester) async {
      await tester.pumpWidget(_app(textScalePct: 90));
      expect((await scalerIn(tester)).scale(10), closeTo(9, 0.001));
    });

    testWidgets('System-Schriftgröße bleibt berücksichtigt, Deckel 1,6',
        (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(_app(textScalePct: 120));
      // 1,2 × 1,2 = 1,44 — unter dem Deckel.
      expect((await scalerIn(tester)).scale(10), closeTo(14.4, 0.001));

      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      await tester.pumpWidget(_app(textScalePct: 120));
      // 2,0 × 1,2 = 2,4 → gedeckelt auf 1,6.
      expect((await scalerIn(tester)).scale(10), closeTo(16, 0.001));
    });

    test('combineTextScale multipliziert und deckelt', () {
      final s = combineTextScale(const TextScaler.linear(1.5), 1.2, 1.6);
      expect(s.scale(10), closeTo(16, 0.001));
      final k = combineTextScale(TextScaler.noScaling, 0.9, 1.6);
      expect(k.scale(10), closeTo(9, 0.001));
    });
  });
}
