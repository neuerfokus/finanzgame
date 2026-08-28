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

  /// Solange true, geben Geldeingänge weder Klang noch Vibration.
  ///
  /// Der Zeitsprung schaltet das für seine Dauer ein. Dort kommen
  /// Holzertrag (täglich), Miete, Taschengeld, Gehalt und Lucky-Events
  /// zusammen — ein 5-Jahres-Sprung löste 1.800 bis 3.700 Aufrufe aus. Der
  /// Klang ist auf 80 ms gedrosselt, das waren immer noch ~180
  /// Münzgeräusche am Stück; die **Vibration war gar nicht gedrosselt** und
  /// flutete den Platform-Channel über die gesamte Dauer des Sprungs.
  ///
  /// Ein Schalter statt eines Parameters, weil `earn` aus vielen Listenern
  /// und Repositories heraus gerufen wird — der Sprung soll alle Quellen
  /// stummschalten, nicht nur die, die davon wissen.
  bool quiet = false;

  void earn(Money amount) {
    state = state + amount;
    if (amount.isPositive && !quiet) {
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
