import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/wishlist/wish_item.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/wishlist/wishlist_repository.dart';

ProviderContainer _container({Money cash = const Money.cents(20000)}) {
  final c = ProviderContainer();
  c.read(cashStateProvider.notifier).state = cash;
  return c;
}

void main() {
  group('WishlistRepository', () {
    test('initial state seeded from catalog', () {
      final c = _container();
      addTearDown(c.dispose);
      final items = c.read(wishlistRepositoryProvider);
      expect(items.length, kWishCatalog.length);
      expect(items.every((i) => i.currentPrice == i.basePrice), isTrue);
      expect(items.every((i) => i.ownedOnDayIndex == null), isTrue);
    });

    test('buy deducts cash + marks owned with day index', () async {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(wishlistRepositoryProvider.notifier);
      repo.buy('snack_xxl');
      final item = repo.byId('snack_xxl')!;
      expect(item.ownedOnDayIndex, 0);
      expect(c.read(cashStateProvider), const Money.cents(19700));
    });

    test('buy throws when broke', () {
      final c = _container(cash: const Money.cents(50));
      addTearDown(c.dispose);
      final repo = c.read(wishlistRepositoryProvider.notifier);
      expect(
        () => repo.buy('sneaker_quantum_x'),
        throwsA(isA<WishlistError>()),
      );
    });

    test('buy throws when already owned', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(wishlistRepositoryProvider.notifier);
      repo.buy('snack_xxl');
      expect(
        () => repo.buy('snack_xxl'),
        throwsA(isA<WishlistError>()),
      );
    });

    test('inflate raises currentPrice but spares owned items', () {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(wishlistRepositoryProvider.notifier);
      repo.buy('snack_xxl');
      final ownedBefore = repo.byId('snack_xxl')!.currentPrice;
      final apexBefore = repo.byId('sneaker_apex')!.currentPrice;

      repo.inflate();

      expect(repo.byId('snack_xxl')!.currentPrice, ownedBefore);
      expect(repo.byId('sneaker_apex')!.currentPrice, greaterThan(apexBefore));
    });

    test('30x advanceDay lifts apex price', () async {
      final c = _container(cash: const Money.cents(100000));
      addTearDown(c.dispose);
      final repo = c.read(wishlistRepositoryProvider.notifier);
      final before = repo.byId('sneaker_apex')!.currentPrice;
      for (var i = 0; i < 30; i++) {
        await c.read(gameClockProvider.notifier).advanceDay();
      }
      final after = repo.byId('sneaker_apex')!.currentPrice;
      expect(after, greaterThan(before));
    });
  });
}
