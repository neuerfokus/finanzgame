import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/sleep/fast_forward_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FastForwardFlow: pick 7 → summary screen with Weiter button',
      (tester) async {
    var done = false;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: FastForwardFlow(onDone: () => done = true),
        ),
      ),
    );
    // Give the container time to seed cash from default.
    await tester.pump();
    // Boost cash so 7 days doesn't hit Hunger-Pfad.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(FastForwardFlow)),
    );
    container.read(cashStateProvider.notifier).state =
        const Money.cents(50000);

    // Pick screen shows 3 buttons.
    expect(find.text('7 Tage'), findsOneWidget);
    expect(find.text('30 Tage'), findsOneWidget);
    expect(find.text('1 Jahr (365)'), findsOneWidget);

    await tester.tap(find.text('7 Tage'));
    // Welle-8: Confirm-Dialog vor Sprung.
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ja, los'));
    // Let fastForward complete + post-frame transitions settle.
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Summary screen shows aggregate header + Weiter button.
    expect(find.textContaining('Tage später'), findsOneWidget);
    expect(find.text('Weiter →'), findsOneWidget);

    await tester.tap(find.text('Weiter →'));
    await tester.pump();
    expect(done, isTrue);
  });
}
