import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/realestate/real_estate.dart';
import '../../domain/sim/listeners/rent_listener.dart';
import '../economy/cash_state.dart';
import '../xp/xp_repository.dart';

part 'real_estate_repository.g.dart';

class RealEstateError implements Exception {
  const RealEstateError(this.message);
  final String message;
}

/// spec-35 phase B + spec-44 sprint D: Immobilien-Portfolio.
///
/// Sprint D: Hypothek-Hebel + Kaufnebenkosten + Instandhaltung +
/// Mieteinnahmen (nur MFH) + Spekulationssteuer (< 10 J, vermietet).
///
/// Klumpenrisiko: TODO — negative Gewichtung in der
/// E2-Diversifikations-Logik kommt in einem spaeteren Sprint.
@Riverpod(keepAlive: true)
class RealEstateRepository extends _$RealEstateRepository
    implements RealEstateHoldingsSource {
  @override
  List<RealEstateHolding> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return [
      for (final r in snap.realEstateHoldings)
        RealEstateHolding(
          specId: r.specId,
          ownedSinceDayIndex: r.ownedSinceDayIndex,
          purchasePrice: Money.cents(r.purchasePriceCents),
          usage: _usageFromName(r.usage),
        ),
    ];
  }

  static RealEstateUsage _usageFromName(String name) =>
      name == RealEstateUsage.selfOccupied.name
          ? RealEstateUsage.selfOccupied
          : RealEstateUsage.rented;

  /// Wohnt der Spieler in einer eigenen Immobilie? Steuert den Miet-Anteil
  /// der Lebenskosten (siehe [LivingCostListener]).
  bool get livesInOwnProperty =>
      state.any((h) => h.usage == RealEstateUsage.selfOccupied);

  /// Marktmiete der selbst bewohnten Immobilie — `null`, wenn man zur Miete
  /// wohnt. Genau so viel Miete spart man höchstens (gedeckelt durch den
  /// Miet-Anteil der Lebenskosten, siehe `JobConfig.savedRentFor`).
  Money? get ownHomeMarketRent {
    for (final h in state) {
      if (h.usage == RealEstateUsage.selfOccupied) {
        return RealEstateCatalog.byId(h.specId).monthlyRent;
      }
    }
    return null;
  }

  /// Nutzung umschalten.
  ///
  /// Zwei Regeln: man kann nur in EINER Immobilie gleichzeitig wohnen (die
  /// bisherige wird dabei automatisch vermietet), und das Mehrfamilienhaus
  /// ist ein reines Anlageobjekt — dort kann man nicht einziehen.
  void setUsage(String specId, RealEstateUsage usage) {
    final h = holdingFor(specId);
    if (h == null) throw const RealEstateError('not owned');
    if (usage == RealEstateUsage.selfOccupied &&
        !RealEstateCatalog.byId(specId).canBeSelfOccupied) {
      throw const RealEstateError('cannot live here');
    }
    state = [
      for (final x in state)
        if (x.specId == specId)
          x.copyWith(usage: usage)
        else if (usage == RealEstateUsage.selfOccupied &&
            x.usage == RealEstateUsage.selfOccupied)
          // Nur eine Wohnung gleichzeitig bewohnbar → die alte wird vermietet.
          x.copyWith(usage: RealEstateUsage.rented)
        else
          x,
    ];
    for (final x in state) {
      _persist(x);
    }
  }

  @override
  List<RealEstateHolding> currentHoldings() => state;

  @override
  void creditRent(Money amount) {
    ref.read(cashStateProvider.notifier).earn(amount);
  }

  bool owns(String specId) => state.any((h) => h.specId == specId);

  RealEstateHolding? holdingFor(String specId) =>
      state.cast<RealEstateHolding?>().firstWhere(
            (h) => h?.specId == specId,
            orElse: () => null,
          );

  static const int spekulationsfristYears = 10;
  static const int spekulationssteuerBps = 2500;

  Money currentValueOf(RealEstateHolding h, int currentDayIndex) {
    final spec = RealEstateCatalog.byId(h.specId);
    final years = (currentDayIndex - h.ownedSinceDayIndex) / 365.0;
    final factor = math.pow(1 + spec.appreciationPerYear, years);
    return Money.cents((h.purchasePrice.cents * factor).round());
  }

  Money mortgageRemaining(RealEstateHolding h, int currentDayIndex) {
    final spec = RealEstateCatalog.byId(h.specId);
    final months = MortgageMath.monthsPaid(
      currentDayIndex: currentDayIndex,
      ownedSinceDayIndex: h.ownedSinceDayIndex,
    );
    return MortgageMath.remainingPrincipal(spec: spec, monthsPaid: months);
  }

  Money monthlyMortgagePayment(RealEstateHolding h, int currentDayIndex) {
    final spec = RealEstateCatalog.byId(h.specId);
    final months = MortgageMath.monthsPaid(
      currentDayIndex: currentDayIndex,
      ownedSinceDayIndex: h.ownedSinceDayIndex,
    );
    return MortgageMath.monthlyPayment(spec: spec, monthsPaid: months);
  }

  /// Kauf: Anzahlung + Kaufnebenkosten sofort vom Cash, Rest als Hypothek.
  /// Welle-8: Age-Gate raus — Spielprogression läuft über XP + Cash.
  /// In Realität braucht man Geschäftsfähigkeit (18) für Kreditvertrag.
  void buy(String specId, int dayIndex) {
    if (owns(specId)) throw const RealEstateError('already owned');
    final spec = RealEstateCatalog.byId(specId);
    final cash = ref.read(cashStateProvider.notifier);
    final upfront = spec.mortgageEnabled ? spec.cashAtPurchase : spec.basePrice;
    if (!cash.spend(upfront)) {
      throw const RealEstateError('insufficient cash');
    }
    // Die ERSTE eigene Immobilie zieht man selbst ein — das ist der
    // Normalfall im echten Leben und macht den Nutzen sofort sichtbar (die
    // Miete in den Lebenskosten fällt weg). Jede weitere wird vermietet.
    final usage = spec.canBeSelfOccupied && !livesInOwnProperty
        ? RealEstateUsage.selfOccupied
        : RealEstateUsage.rented;
    final holding = RealEstateHolding(
      specId: specId,
      ownedSinceDayIndex: dayIndex,
      purchasePrice: spec.basePrice,
      usage: usage,
    );
    state = [...state, holding];
    _persist(holding);
    ref.read(xpRepositoryProvider.notifier).add(150);
  }

  /// Verkauf: Erloes = Marktwert − Restschuld. < 10 J & vermietet → 25 %
  /// Spekulationssteuer auf den Gewinn.
  ({Money netProceeds, Money speculationTax}) sell(
    String specId,
    int currentDayIndex,
  ) {
    final h = holdingFor(specId);
    if (h == null) throw const RealEstateError('not owned');
    final marketValue = currentValueOf(h, currentDayIndex);
    final remaining = mortgageRemaining(h, currentDayIndex);
    final grossProceeds = Money.cents(
      math.max(0, marketValue.cents - remaining.cents),
    );

    final years = (currentDayIndex - h.ownedSinceDayIndex) / 365.0;
    final gain = marketValue.cents - h.purchasePrice.cents;
    var tax = Money.zero;
    // Spekulationssteuer hängt jetzt an der NUTZUNG statt am Objekttyp — und
    // das ist auch die echte Regel: wer selbst drin gewohnt hat, zahlt beim
    // Verkauf keine, wer vermietet hat und vor Ablauf von 10 Jahren verkauft,
    // schon. Vorher galt sie nur fürs Mehrfamilienhaus.
    if (h.usage == RealEstateUsage.rented &&
        years < spekulationsfristYears &&
        gain > 0) {
      tax = Money.cents((gain * spekulationssteuerBps) ~/ 10000);
    }

    final netProceeds = Money.cents(
      math.max(0, grossProceeds.cents - tax.cents),
    );
    ref.read(cashStateProvider.notifier).earn(netProceeds);
    state = state.where((x) => x.specId != specId).toList();
    final db = ref.read(appDatabaseProvider);
    unawaited(db.realEstateDao.deleteHolding(specId).catchError((Object _) {}));

    return (netProceeds: netProceeds, speculationTax: tax);
  }

  void _persist(RealEstateHolding h) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.realEstateDao
          .upsert(RealEstateHoldingRow(
            specId: h.specId,
            ownedSinceDayIndex: h.ownedSinceDayIndex,
            purchasePriceCents: h.purchasePrice.cents,
            usage: h.usage.name,
          ))
          .catchError((Object _) {}),
    );
  }
}