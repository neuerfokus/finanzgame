import 'dart:async';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/listeners/debt_listener.dart';
import '../audio/sound_service.dart';

part 'cash_state.g.dart';

/// Player cash balance.
///
/// Backed by Drift: seed = 2500¢ on first run; loaded from DB during
/// pre-warm; mutators write through fire-and-forget so the public API
/// stays synchronous.
@Riverpod(keepAlive: true)
class CashState extends _$CashState implements CashBalanceSource {
  // Spec-43 v9: Start-Cash 25 € → 50 € — kleines Polster für die
  // ersten Tage Verpflegung (1 €/Tag).
  static const Money _initial = Money.cents(5000);

  @override
  Money build() {
    final snap = ref.watch(dbSnapshotProvider);
    if (snap.cashCents != null) {
      return Money.cents(snap.cashCents!);
    }
    return _initial;
  }

  bool canAfford(Money amount) => state >= amount;

  @override
  int currentCashCents() => state.cents;

  /// Returns false if the balance would go negative.
  bool spend(Money amount) {
    if (state < amount) return false;
    state = state - amount;
    _persist();
    return true;
  }

  /// spec-35 phase E: bypass the can-afford guard. Used by the debt
  /// listener so dispo interest accumulates even when cash is already
  /// negative — that's the whole point of the Schulden-Lehre.
  void forceDeduct(Money amount) {
    state = state - amount;
    _persist();
  }

  void earn(Money amount) {
    state = state + amount;
    if (amount.isPositive) {
      SoundService.instance.playSfx(AudioKey.coin);
      // spec-35 phase M: subtle haptic on every coin-in event. Wrap in
      // try so unit tests without ServicesBinding don't blow up.
      // Avoid HapticFeedback in unit tests (no ServicesBinding).
      try {
        ServicesBinding.instance;
        HapticFeedback.lightImpact();
      } catch (_) {}
    }
    _persist();
  }

  void _persist() {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.cashDao.setCents(state.cents).catchError((Object _) {}));
  }
}
