import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/savings_interest_listener.dart';
import 'package:finanzgame/features/bank/savings_repository.dart';
import 'package:finanzgame/features/economy/cash_state.dart';

ProviderContainer _container(AppDatabase db, {DbSnapshot? snap}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
}

Future<void> _flush() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('SavingsRepository', () {
    test('starts at 0', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(savingsRepositoryProvider), Money.zero);
    });

    test('deposit moves cents from Giro to Spar', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      // CashState seed = 5000¢ (Spec-43 v9)
      final ok = c
          .read(savingsRepositoryProvider.notifier)
          .deposit(const Money.cents(1000));
      expect(ok, isTrue);
      expect(c.read(cashStateProvider), const Money.cents(4000));
      expect(c.read(savingsRepositoryProvider), const Money.cents(1000));
    });

    test('deposit fails when cash insufficient', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final ok = c
          .read(savingsRepositoryProvider.notifier)
          .deposit(const Money.cents(100000));
      expect(ok, isFalse);
      expect(c.read(savingsRepositoryProvider), Money.zero);
      expect(c.read(cashStateProvider), const Money.cents(5000));
    });

    test('withdraw moves cents from Spar back to Giro', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c
          .read(savingsRepositoryProvider.notifier)
          .deposit(const Money.cents(1000));
      final ok = c
          .read(savingsRepositoryProvider.notifier)
          .withdraw(const Money.cents(500));
      expect(ok, isTrue);
      expect(c.read(savingsRepositoryProvider), const Money.cents(500));
      expect(c.read(cashStateProvider), const Money.cents(4500));
    });

    test('withdraw fails when savings insufficient', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final ok = c
          .read(savingsRepositoryProvider.notifier)
          .withdraw(const Money.cents(100));
      expect(ok, isFalse);
    });

    test('round-trip: deposit → reopen → preserved', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _container(db);
      c1
          .read(savingsRepositoryProvider.notifier)
          .deposit(const Money.cents(800));
      await _flush();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _container(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(savingsRepositoryProvider), const Money.cents(800));
    });
  });

  group('SavingsInterestListener', () {
    test('credits realistic 0.005 %/day (= 0.15 %/month, spec-26)',
        () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      // 100 000 ¢ (= 1 000 €) → 100000/20000 = 5 ¢/day.
      c.read(savingsRepositoryProvider.notifier).state =
          const Money.cents(100000);

      final listener = SavingsInterestListener(
        c.read(savingsRepositoryProvider.notifier),
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events, hasLength(1));
      expect(
        c.read(savingsRepositoryProvider),
        const Money.cents(100005),
      );
    });

    test('emits nothing when balance is 0', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final listener = SavingsInterestListener(
        c.read(savingsRepositoryProvider.notifier),
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events, isEmpty);
    });

    test('rounds down — small balance accrues nothing (spec-26)', () async {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      // 19 999 ¢ / 20 000 → 0 ¢; spec-26 rate.
      c.read(savingsRepositoryProvider.notifier).state =
          const Money.cents(19999);
      final listener = SavingsInterestListener(
        c.read(savingsRepositoryProvider.notifier),
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events, isEmpty);
      expect(c.read(savingsRepositoryProvider), const Money.cents(19999));
    });
  });
}
