import '../../economy/money.dart';
import '../../vorsorge/vorsorge.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

abstract class VorsorgeSource {
  List<VorsorgeContract> currentContracts();
  void recordPremium(VorsorgeType t, Money premium);
  void recordSubsidy(VorsorgeType t, Money subsidy);
}

/// spec-36: monthly premium debit + yearly Riester subsidy.
/// Welle-8 Round 22 v3: nimmt startAgeYears um signed-Age pro Contract
/// für age-staffel zu berechnen (BU/Hausrat/Lebensvers teurer je
/// später abgeschlossen).
class VorsorgeListener implements DayEventListener {
  const VorsorgeListener(this._source, {this.startAgeYears = 13});

  final VorsorgeSource _source;
  final int startAgeYears;

  static const int monthlyCadence = 30;
  static const int yearlyCadence = 365;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex == 0) return const [];
    final events = <DayEvent>[];
    for (final c in _source.currentContracts()) {
      final spec = VorsorgeCatalog.byType(c.type);
      final signedAge = startAgeYears + c.startedOnDayIndex ~/ 365;
      final premium = spec.monthlyPremiumAt(signedAge);
      if (newDay.dayIndex % monthlyCadence == 0) {
        _source.recordPremium(c.type, premium);
        events.add(DayEvent.insuranceFee(
          amount: premium,
          kind: spec.name,
        ));
      }
      // Yearly subsidy (Riester).
      if (spec.yearlyStateSubsidy.cents > 0 &&
          newDay.dayIndex % yearlyCadence == 0) {
        _source.recordSubsidy(c.type, spec.yearlyStateSubsidy);
      }
    }
    return events;
  }
}
