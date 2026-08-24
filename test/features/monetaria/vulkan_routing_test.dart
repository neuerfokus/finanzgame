import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/features/monetaria/island_page.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

/// Spec-22: Vulkan-Insel routes to CryptoTradePage (RugCoin etc. visible),
/// with the old Vulkan eruption-history kept as a sub-section.
void main() {
  testWidgets('Vulkan island shows crypto trade UI + crash history section',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monetariaStateProvider.overrideWith(_AllUnlocked.new),
          // Age-Gate Krypto: 18+. dayIndex 2000 = age 18.
          gameClockProvider.overrideWith(_AdultClock.new),
        ],
        child: const MaterialApp(
          home: IslandPage(islandId: IslandId.vulkan),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // spec-26: catalog reduced to Bitcoin + Krypto-Casino.
    // spec-37: multi-denom Bitcoin. First card is the smallest (Mikro).
    expect(find.text('Bitcoin (0,0001 BTC)'), findsOneWidget);

    final history = find.textContaining('Vulkan-Geschichte');
    await tester.dragUntilVisible(
      history,
      find.byType(ListView),
      const Offset(0, -200),
    );
    expect(history, findsOneWidget);
  });

  testWidgets('Goldmine island shows metal trade UI', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          monetariaStateProvider.overrideWith(_AllUnlocked.new),
        ],
        child: const MaterialApp(
          home: IslandPage(islandId: IslandId.goldmine),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // spec-37: multiple gold denominations now — first card is smallest.
    expect(find.text('Gold (0,1 g)'), findsOneWidget);
  });
}

class _AllUnlocked extends MonetariaState {
  @override
  Set<String> build() => const {
        IslandId.heimathafen,
        IslandId.sparInsel,
        IslandId.mischwald,
        IslandId.etfInsel,
        IslandId.inflationAtoll,
        IslandId.aktienArchipel,
        IslandId.vulkan,
        IslandId.goldmine,
      };
}

class _AdultClock extends GameClock {
  @override
  GameDay build() => GameDay.fromIndex(2000);
}
