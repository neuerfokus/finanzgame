import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:finanzgame/core/design_tokens.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/ui/widgets/app_icon.dart';
import 'package:finanzgame/ui/widgets/home_bar.dart';
import 'package:finanzgame/ui/widgets/money_header.dart';
import 'package:finanzgame/ui/widgets/pixel_button.dart';
import 'package:finanzgame/ui/widgets/status_bar.dart';

Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: FgColors.backgroundPrimary,
          body: Center(child: child),
        ),
      ),
    );

void main() {
  setUpAll(() async => loadAppFonts());

  group('pixel widgets goldens', () {
    testGoldens('pixel_button', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(PixelButton(label: 'Schlafen', onPressed: () {})),
        surfaceSize: const Size(240, 120),
      );
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'pixel_button');
    });

    testGoldens('app_icon', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(AppIcon(
          glyph: '🏦',
          label: 'Bank',
          background: FgColors.success,
          onTap: () {},
        )),
        surfaceSize: const Size(120, 120),
      );
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'app_icon');
    });

    testGoldens('money_header', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(const MoneyHeader(
          cash: Money.cents(2500),
          savings: Money.cents(10000),
        )),
        surfaceSize: const Size(390, 120),
      );
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'money_header');
    });

    testGoldens('status_bar', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(const StatusBar()),
        surfaceSize: const Size(390, 40),
      );
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'status_bar');
    });

    testGoldens('home_bar', (tester) async {
      await tester.pumpWidgetBuilder(
        _wrap(HomeBar(onBack: () {}, onHome: () {})),
        surfaceSize: const Size(390, 60),
      );
      await tester.pumpAndSettle();
      await screenMatchesGolden(tester, 'home_bar');
    });
  });
}
