import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/listeners/savings_interest_listener.dart';
import '../economy/cash_state.dart';

part 'savings_repository.g.dart';

class SavingsError implements Exception {
  const SavingsError(this.message);
  final String message;
  @override
  String toString() => 'SavingsError: $message';
}

/// Savings (Spar) account balance in cents (spec-21).
///
/// Backed by Drift; seed = 0 on first run.
/// `keepAlive: true` so transfers persist through nav pops.
@Riverpod(keepAlive: true)
class SavingsRepository extends _$SavingsRepository
    implements SavingsBalanceSource {
  @override
  Money build() {
    final snap = ref.watch(dbSnapshotProvider);
    return Money.cents(snap.savingsCents ?? 0);
  }

  /// Moves [amount] from Giro (cash) → Spar.
  /// Returns true on success, false if cash is insufficient. amount<=0 is a
  /// no-op returning false.
  bool deposit(Money amount) {
    if (!amount.isPositive) return false;
    final cash = ref.read(cashStateProvider.notifier);
    if (!cash.spend(amount)) return false;
    state = state + amount;
    _persist();
    return true;
  }

  /// Moves [amount] from Spar → Giro (cash).
  /// Returns true on success, false if savings is insufficient.
  bool withdraw(Money amount) {
    if (!amount.isPositive) return false;
    if (state < amount) return false;
    state = state - amount;
    ref.read(cashStateProvider.notifier).earn(amount);
    _persist();
    return true;
  }

  /// B3a: zieht Geldentwertung vom Spar-Bestand ab (kein Cash-Transfer,
  /// kein negativer Saldo — Inflation kann nicht unter 0 drücken).
  void deductInflation(Money amount) {
    if (!amount.isPositive) return;
    final next = state - amount;
    state = next.cents < 0 ? Money.zero : next;
    _persist();
  }

  /// Adds raw interest (no cash transfer). Used by [SavingsInterestListener].
  @override
  void creditInterest(Money amount) {
    if (!amount.isPositive) return;
    state = state + amount;
    _persist();
  }

  @override
  int currentCents() => state.cents;

  void _persist() {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.savingsDao.setCents(state.cents).catchError((Object _) {}));
  }
}
