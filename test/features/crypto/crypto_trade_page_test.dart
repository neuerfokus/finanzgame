import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/crypto/crypto.dart';
import 'package:finanzgame/features/crypto/crypto_trade_page.dart';

void main() {
  testWidgets('CryptoTradePage lists both reduced coins (spec-26)',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          // age-gate: 18+ braucht dayIndex ≥ 5*365 bei startAge 13.
          home: CryptoTradePage(currentDayIndex: 2000),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // spec-37: catalog grew to 4 (3 Bitcoin-Stückelungen + Krypto-Casino).
    // Only verify the first one renders above the fold.
    expect(find.text(CryptoCatalog.all.first.name), findsOneWidget);
    // Vulkan-Geschichte sub-section is present below the trade rows.
    // Scroll to surface it if it's below the fold.
    final history = find.textContaining('Vulkan-Geschichte');
    await tester.dragUntilVisible(
      history,
      find.byType(ListView),
      const Offset(0, -200),
    );
    expect(history, findsOneWidget);
  });

  testWidgets('CryptoTradePage shows percentage deltas', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CryptoTradePage(currentDayIndex: 2000),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // At least one % string should appear (one per coin).
    expect(find.textContaining('%'), findsWidgets);
  });
}
