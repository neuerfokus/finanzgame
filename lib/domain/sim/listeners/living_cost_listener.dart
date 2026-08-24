import 'dart:math' as math;

import '../../economy/money.dart';
import '../../wishlist/wish_item.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../job_level.dart';

/// Bug-fix v26 + Spec-Sprint-D-Vorlauf: monatliche Lebenskosten
/// (Miete + Essen + Versicherung), gestaffelt nach Job-Phase.
///
/// - Schüler / Ferienjob: 0 € (Eltern zahlen)
/// - Ausbildung:         200 € (eigenes Zimmer, Essensgeld)
/// - Vollzeit:           800 € (eigene Wohnung)
///
/// Emittiert als `InsuranceFeeEvent` mit kind=`"Lebenskosten"` —
/// re-uses existierenden force-deduct-Pfad im `game_clock` ohne
/// neue DayEvent-Variante.
class LivingCostListener implements DayEventListener {
  const LivingCostListener({
    this.startAgeYears = 13,
    this.ownHomeMarketRent,
  });

  static const int cadenceDays = 30;
  final int startAgeYears;

  /// Marktmiete der selbst bewohnten Immobilie — `null`, wenn man zur Miete
  /// wohnt.
  ///
  /// Gespart wird das Kleinere aus dieser Marktmiete und dem Miet-Anteil der
  /// Lebenskosten (60 %). Der Grund fiel erst beim Test am Gerät auf: nimmt
  /// man immer den vollen Miet-Anteil, spart eine 120.000-€-Wohnung (Marktmiete
  /// 350 €) genauso viel wie ein 480.000-€-Haus — nämlich 720 €. Damit wäre
  /// die BILLIGSTE Immobilie die beste, und das ist ökonomisch verkehrt
  /// herum. Wer in seiner kleinen Wohnung wohnt, spart eben nur, was diese
  /// Wohnung an Miete kosten würde.
  final Money? ownHomeMarketRent;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex == 0) return const [];
    if (newDay.dayIndex % cadenceDays != 0) return const [];
    final job = JobConfig.forDay(newDay.dayIndex, startAgeYears: startAgeYears);
    final full = JobConfig.monthlyLivingCost(job);
    final saved = JobConfig.savedRentFor(job, ownHomeMarketRent);
    final cost = Money.cents(full.cents - saved.cents);
    if (cost.cents <= 0) return const [];
    // Welle-8: Lebensmittel/Miete/Strom steigen mit Basis-Inflation.
    // Multipliziere Cost mit (1 + dailyRate)^dayIndex.
    final inflationMul = math.pow(
      1.0 + InflationConfig.dailyRate,
      newDay.dayIndex,
    );
    final inflated = Money.cents((cost.cents * inflationMul).round());
    return [
      DayEvent.insuranceFee(
        amount: inflated,
        kind: saved.cents > 0 ? 'Lebenskosten (ohne Miete)' : 'Lebenskosten',
      ),
    ];
  }
}
