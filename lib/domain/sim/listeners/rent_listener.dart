import 'dart:math' as math;

import '../../economy/money.dart';
import '../../realestate/real_estate.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Source the rent listener pulls the player's owned properties from.
abstract class RealEstateHoldingsSource {
  List<RealEstateHolding> currentHoldings();
  void creditRent(Money amount);
}

/// spec-35 phase B + spec-44 sprint D: monthly real-estate cashflow.
///
/// Miete gibt es für jede Immobilie, die auf `vermietet` steht — abzüglich
/// Leerstand (5 %/Monat) und 25 % Steuer. Wartung + Hypothek laufen über den
/// MortgageListener in der Allowance-Stage.
///
/// 2026-08: vorher hing die Miete an `spec.isInvestment`, also ausschließlich
/// am Mehrfamilienhaus — jede andere Immobilie war ein reiner Kostenblock.
/// Jetzt entscheidet die vom Spieler gewählte Nutzung.
class RentListener implements DayEventListener {
  const RentListener(this._source, {this.vacancySeed = 0xACE});

  final RealEstateHoldingsSource _source;
  final int vacancySeed;

  static const int cadenceDays = 30;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex == 0 || newDay.dayIndex % cadenceDays != 0) {
      return const [];
    }
    final events = <DayEvent>[];
    for (final h in _source.currentHoldings()) {
      if (h.usage != RealEstateUsage.rented) continue;
      final spec = RealEstateCatalog.byId(h.specId);
      final gross = spec.monthlyRent;
      if (gross == null || gross.cents <= 0) continue;

      final monthIndex = newDay.dayIndex ~/ cadenceDays;
      final rng = math.Random(
        vacancySeed ^ h.specId.hashCode ^ monthIndex,
      );
      if (rng.nextDouble() < spec.vacancyChancePerMonth) {
        // Leerstand → keine Miete diesen Monat.
        continue;
      }

      // Gutgeschrieben wird die Miete NACH Steuer — sonst wäre der angezeigte
      // Betrag ein anderer als der, der auf dem Konto landet.
      final net = rentAfterTax(gross);
      _source.creditRent(net);
      events.add(DayEvent.rentIncome(amount: net, propertyId: h.specId));
    }
    return events;
  }
}