import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/monetaria/island_page.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

void main() {
  testWidgets(
    'opening a locked island shows lock view + SnackBar',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: IslandPage(islandId: IslandId.vulkan),
          ),
        ),
      );
      // After first frame the SnackBar should be queued; pump one more to
      // surface it.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Noch verschlossen.'), findsOneWidget);
      expect(
        find.text(
          'Noch verschlossen — siehe Hinweis im Heimathafen-Quest.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'unlocked island bypasses the lock view',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Force the state to include vulkan so the page proceeds.
            monetariaStateProvider.overrideWith(_AllUnlocked.new),
          ],
          child: const MaterialApp(
            home: IslandPage(islandId: IslandId.vulkan),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The lock-view label is absent.
      expect(find.text('Noch verschlossen.'), findsNothing);
    },
  );
}

/// Test-only override that unlocks every island.
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
