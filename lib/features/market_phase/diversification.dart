import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../crypto/crypto_repository.dart';
import '../etf/etf_repository.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../stock/stock_repository.dart';
import '../bank/savings_repository.dart';

part 'diversification.g.dart';

/// Spec-44 E2 (Diversifikations-Bonus): zählt, wie viele Asset-Klassen
/// der Spieler aktuell hält. Liefert einen Volatilitäts-Dämpfungs-
/// Faktor nach der Spec-Tabelle A.4:
///
///   classes  factor
///   1        1,00
///   2        0,85
///   3        0,70
///   4        0,55
///   5+       0,50
///
/// "free lunch" der Streuung — kein Renditebonus, nur weniger
/// Schwankung. Wird in den Preis-Listenern auf `volatility` angewandt.
@Riverpod(keepAlive: true)
int diversificationClassCount(Ref ref) {
  var n = 0;
  if (ref.watch(savingsRepositoryProvider).cents > 0) n++;
  if (ref.watch(etfRepositoryProvider).holdings.isNotEmpty) n++;
  if (ref.watch(stockRepositoryProvider).holdings.isNotEmpty) n++;
  if (ref.watch(cryptoRepositoryProvider).holdings.isNotEmpty) n++;
  if (ref.watch(metalRepositoryProvider).holdings.isNotEmpty) n++;
  if (ref.watch(realEstateRepositoryProvider).isNotEmpty) n++;
  return n;
}

double volatilityDampening(int classes) {
  if (classes <= 1) return 1.0;
  // 1 → 1.00, 2 → 0.85, 3 → 0.70, 4 → 0.55, 5+ → 0.50.
  final raw = 1.0 - 0.15 * (classes - 1);
  return raw < 0.5 ? 0.5 : raw;
}
