import '../../realestate/real_estate.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import 'rent_listener.dart' show RealEstateHoldingsSource;

/// spec-44 sprint D (F2): zieht jeden 30. Tag die Hypotheken-Rate +
/// Instandhaltung fuer jede Immobilie im Bestand ein.
///
/// Laeuft in der Allowance-Stage zusammen mit Lebenskosten +
/// Versicherung, damit alle Fixkosten gebuendelt sichtbar werden.
///
/// Emittiert pro Property bis zu zwei InsuranceFeeEvent:
/// - kind 'Hypothek' (Tilgung + Zins; entfaellt nach Laufzeitende)
/// - kind 'Instandhaltung' (laufende Erhaltungskosten)
class MortgageListener implements DayEventListener {
  const MortgageListener(this._source);

  final RealEstateHoldingsSource _source;

  static const int cadenceDays = 30;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex == 0 || newDay.dayIndex % cadenceDays != 0) {
      return const [];
    }
    final events = <DayEvent>[];
    for (final h in _source.currentHoldings()) {
      final spec = RealEstateCatalog.byId(h.specId);
      final monthsPaid = MortgageMath.monthsPaid(
        currentDayIndex: newDay.dayIndex,
        ownedSinceDayIndex: h.ownedSinceDayIndex,
      );
      final payment =
          MortgageMath.monthlyPayment(spec: spec, monthsPaid: monthsPaid);
      if (payment.cents > 0) {
        events.add(DayEvent.insuranceFee(amount: payment, kind: 'Hypothek'));
      }
      final maint = spec.monthlyMaintenance;
      if (maint.cents > 0) {
        events
            .add(DayEvent.insuranceFee(amount: maint, kind: 'Instandhaltung'));
      }
    }
    return events;
  }
}