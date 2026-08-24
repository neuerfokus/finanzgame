import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/ui/widgets/home_bar.dart';

void main() {
  testWidgets('middle ● invokes onHome when set', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeBar(onHome: () => taps++, onSettings: () {}),
        ),
      ),
    );
    await tester.tap(find.text('●'));
    expect(taps, 1);
  });

  testWidgets('middle ● is disabled when onHome is null', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeBar(onSettings: () => taps++),
        ),
      ),
    );
    // Tapping the (disabled) home glyph must NOT call the settings tap by
    // accident. We only assert that no exception fires and that taps=0.
    await tester.tap(find.text('●'));
    expect(taps, 0);
  });

  testWidgets('right ⚙ invokes onSettings', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeBar(onSettings: () => taps++),
        ),
      ),
    );
    await tester.tap(find.text('⚙'));
    expect(taps, 1);
  });
}
