import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

void main() {
  group('MonetariaState', () {
    test('initial unlocks: heimathafen + spar-insel', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final unlocked = container.read(monetariaStateProvider);
      expect(unlocked, contains(IslandId.heimathafen));
      expect(unlocked, contains(IslandId.sparInsel));
      expect(unlocked, isNot(contains(IslandId.mischwald)));
    });

    test('isUnlocked reflects state set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(monetariaStateProvider.notifier);
      expect(notifier.isUnlocked(IslandId.sparInsel), isTrue);
      expect(notifier.isUnlocked(IslandId.mischwald), isFalse);
    });

    test('unlock adds island id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(monetariaStateProvider.notifier);
      notifier.unlock(IslandId.mischwald);

      final unlocked = container.read(monetariaStateProvider);
      expect(unlocked, contains(IslandId.mischwald));
    });

    test('unlock idempotent for already unlocked island', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(monetariaStateProvider.notifier);
      final before = container.read(monetariaStateProvider);
      notifier.unlock(IslandId.heimathafen);
      final after = container.read(monetariaStateProvider);

      expect(after, equals(before));
    });
  });

  group('kIslandSpecs', () {
    test('contains 9 islands with expected ids', () {
      expect(kIslandSpecs.length, 9);
      final ids = kIslandSpecs.map((s) => s.id).toSet();
      expect(
        ids,
        {
          IslandId.heimathafen,
          IslandId.sparInsel,
          IslandId.mischwald,
          IslandId.etfInsel,
          IslandId.inflationAtoll,
          IslandId.aktienArchipel,
          IslandId.vulkan,
          IslandId.goldmine,
          IslandId.wohnviertel,
        },
      );
    });
  });
}
