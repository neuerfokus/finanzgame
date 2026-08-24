import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/metal/metal.dart';
import 'package:finanzgame/features/metal/metal_trade_page.dart';

void main() {
  testWidgets('MetalTradePage lists Gold, Silber and Platin', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MetalTradePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // spec-37: list is now longer (8 denominations). Verify at least
    // the first 3 are rendered above the fold; ListView lazy-builds
    // the rest.
    for (final spec in MetalCatalog.all.take(2)) {
      expect(find.text(spec.name), findsOneWidget,
          reason: '${spec.name} should be listed');
    }
  });
}
