import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../job_level.dart';

/// spec-35 phase G: Pflicht-Versicherungen ab Vollzeit-Job. Monatlich
/// (30-Tage-Zyklus) — Haftpflicht 30 €, Krankenkasse 80 €.
class InsuranceListener implements DayEventListener {
  const InsuranceListener({this.startAgeYears = 13});

  static const int cadenceDays = 30;
  static const Money haftpflichtPerMonth = Money.cents(3000);

  final int startAgeYears;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex == 0 || newDay.dayIndex % cadenceDays != 0) {
      return const [];
    }
    final job = JobConfig.forDay(newDay.dayIndex, startAgeYears: startAgeYears);
    if (job.index < JobLevel.vollzeit.index) return const [];
    // Krankenkasse ist Teil der 20 % Sozialabgaben im Lohn-Breakdown.
    // Hier nur noch Haftpflicht als realistische Pflicht-Privatvers.
    return [
      const DayEvent.insuranceFee(
        amount: haftpflichtPerMonth,
        kind: 'Haftpflicht',
      ),
    ];
  }
}
