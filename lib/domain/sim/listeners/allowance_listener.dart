import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../job_level.dart';
import '../weekday.dart';

/// Emits an [AllowanceEvent] once per "month" (every 30 in-game days).
///
/// spec-32: user feedback — real-world Taschengeld is monthly, not weekly.
/// Anchored to the player's preferred weekday so paydays still feel
/// consistent (e.g. always a Monday) but only once every 30 days.
class AllowanceListener implements DayEventListener {
  const AllowanceListener({
    this.amount = defaultAmount,
    this.weekday = Weekday.mon,
    this.startAgeYears = 13,
    this.careerBonusPct = 0,
    this.pauseUntilDay = -1,
    this.steuerklasse = 1,
  });

  /// Monthly default: 80 € so the cadence feels like a real allowance.
  static const Money defaultAmount = Money.cents(8000);

  /// Emit cadence in days. 30 ≈ one month — kept exact so tests are
  /// deterministic without calendar arithmetic.
  static const int cadenceDays = 30;

  final Money amount;
  final Weekday weekday;
  final int startAgeYears;
  /// Spec-45 C5: Bonus aus Job-Wechseln (Prozent auf Brutto).
  final int careerBonusPct;
  /// Spec-45 C5: bis zu diesem Tag (exkl.) kein Gehalt.
  final int pauseUntilDay;
  /// Spec-45 C4: Steuerklasse 1..6.
  final int steuerklasse;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final offset = weekday.index;
    if (newDay.dayIndex > 0 &&
        newDay.dayIndex % cadenceDays == offset % cadenceDays) {
      final events = <DayEvent>[];
      final ageYears = startAgeYears + newDay.dayIndex ~/ 365;
      final job = JobConfig.forAge(ageYears);
      final yearsInLevel = JobConfig.yearsInLevel(ageYears);
      // Bug-fix v26: Allowance phase-out wenn eigenes Einkommen.
      // - Schüler (none):     100 %
      // - Ferienjob:          50 %  (Eltern unterstützen noch teilweise)
      // - Ausbildung+:         0 % (Job ersetzt Taschengeld)
      final factor = switch (job) {
        JobLevel.none => 1.0,
        JobLevel.ferienjob => 0.5,
        JobLevel.ausbildung => 0.0,
        JobLevel.vollzeit => 0.0,
        JobLevel.senior => 0.0,
        JobLevel.lead => 0.0,
      };
      if (factor > 0) {
        events.add(DayEvent.allowance(
          amount: Money.cents((amount.cents * factor).round()),
        ));
      }
      // Spec-45 C5: Übergangs-Pause durch Job-Wechsel/Sabbatical.
      if (newDay.dayIndex < pauseUntilDay) {
        return events;
      }
      var gross = JobConfig.monthlyGrossSalary(job, yearsInLevel: yearsInLevel);
      // Spec-45 C5: Bonus aus erfolgreichen Job-Wechseln.
      if (gross.cents > 0 && careerBonusPct > 0) {
        gross = Money.cents(
          (gross.cents * (100 + careerBonusPct)) ~/ 100,
        );
      }
      if (gross.cents > 0) {
        final breakdown =
            SalaryBreakdown.forGross(gross, steuerklasse: steuerklasse);
        events.add(DayEvent.salary(
          amount: breakdown.net,
          jobLevel: job.name,
          grossAmount: breakdown.gross,
          taxAmount: breakdown.tax,
          socialAmount: breakdown.social,
          soliAmount: breakdown.soli,
          kircheAmount: breakdown.kirche,
        ));
      }
      return events;
    }
    return const [];
  }
}
