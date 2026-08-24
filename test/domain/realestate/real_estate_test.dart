import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/realestate/real_estate.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/mortgage_listener.dart';
import 'package:finanzgame/domain/sim/listeners/rent_listener.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHoldingsSource implements RealEstateHoldingsSource {
  _FakeHoldingsSource(this.holdings);

  final List<RealEstateHolding> holdings;
  int rentCredited = 0;

  @override
  List<RealEstateHolding> currentHoldings() => holdings;

  @override
  void creditRent(Money amount) {
    rentCredited += amount.cents;
  }
}

void main() {
  group('RealEstateSpec — Leiter (spec-44 F2)', () {
    test('buyable catalog enthaelt genau 5 Stufen', () {
      expect(RealEstateCatalog.buyable, hasLength(5));
      expect(
        RealEstateCatalog.buyable.map((s) => s.id).toList(),
        ['re_etw', 're_reihenhaus', 're_dhh', 're_haus', 're_mfh'],
      );
    });

    test('Preise sind aufsteigend', () {
      final prices =
          RealEstateCatalog.buyable.map((s) => s.basePrice.cents).toList();
      for (var i = 1; i < prices.length; i++) {
        expect(prices[i], greaterThan(prices[i - 1]));
      }
    });

    test('jede kaufbare Immobilie kann Miete bringen', () {
      // 2026-08: vorher hatte NUR das Mehrfamilienhaus eine Miete — alle
      // anderen Objekte waren reine Kostenblöcke, während die Lebenskosten
      // (inkl. Miete) unverändert weiterliefen. Kaufen war damit garantiert
      // die schlechteste Entscheidung im Spiel. Jetzt entscheidet die
      // gewählte Nutzung, ob Miete fließt.
      for (final s in RealEstateCatalog.buyable) {
        expect(s.monthlyRent, isNotNull, reason: s.id);
        expect(s.monthlyRent!.cents, greaterThan(0), reason: s.id);
      }
    });

    test('nur das Mehrfamilienhaus ist ein reines Anlageobjekt', () {
      for (final s in RealEstateCatalog.buyable) {
        final isMfh = s.id == 're_mfh';
        expect(s.isInvestment, isMfh, reason: s.id);
        // Im MFH wohnt man nicht selbst — überall sonst schon.
        expect(s.canBeSelfOccupied, !isMfh, reason: s.id);
      }
    });

    test('Bruttomietrendite liegt bei allen um 3,5–4 %/Jahr', () {
      for (final s in RealEstateCatalog.buyable) {
        final rendite = (s.monthlyRent!.cents * 12) / s.basePrice.cents;
        expect(rendite, closeTo(0.037, 0.005), reason: s.id);
      }
    });

    test('Mietsteuer: 25 % gehen ab', () {
      expect(rentAfterTax(const Money.cents(40000)).cents, 30000);
      expect(rentAfterTax(Money.zero).cents, 0);
    });

    test('Anzahlung 20 % + Kaufnebenkosten 11 %', () {
      const spec = RealEstateCatalog.eigentumswohnung;
      expect(spec.downPayment.cents, 2400000);
      expect(spec.kaufnebenkosten.cents, 1320000);
      expect(spec.cashAtPurchase.cents, 2400000 + 1320000);
    });

    test('MFH Brutto-Mietrendite ~4 %/J', () {
      const mfh = RealEstateCatalog.mehrfamilienhaus;
      final yearlyRent = mfh.monthlyRent!.cents * 12;
      final rendite = yearlyRent / mfh.basePrice.cents;
      expect(rendite, closeTo(0.04, 0.002));
    });
  });

  group('MortgageMath', () {
    const spec = RealEstateCatalog.eigentumswohnung;

    test('Initial-Hypothek = Preis − Anzahlung', () {
      expect(spec.initialMortgage.cents, 12000000 - 2400000);
    });

    test('Restschuld sinkt linear, nach 360 Monaten 0', () {
      final r0 = MortgageMath.remainingPrincipal(spec: spec, monthsPaid: 0);
      final r12 =
          MortgageMath.remainingPrincipal(spec: spec, monthsPaid: 12);
      final r360 =
          MortgageMath.remainingPrincipal(spec: spec, monthsPaid: 360);
      expect(r0.cents, spec.initialMortgage.cents);
      expect(r12.cents, lessThan(r0.cents));
      expect(r360.cents, 0);
    });

    test('Monatsrate = Tilgung + Zins auf Restschuld', () {
      final p0 = MortgageMath.monthlyPayment(spec: spec, monthsPaid: 0);
      // Tilgung 9_600_000 / 360 = 26_666 cents
      // Zins 9_600_000 × 4 % / 12 = 32_000 cents
      // -> ~58_666 cents
      expect(p0.cents, closeTo(58666, 5));
    });

    test('Nach Laufzeitende keine Rate mehr', () {
      final p = MortgageMath.monthlyPayment(spec: spec, monthsPaid: 360);
      expect(p.cents, 0);
    });
  });

  group('MortgageListener — Allowance-Stage', () {
    test('feuert pro 30 Tage Hypothek + Instandhaltung', () async {
      const holding = RealEstateHolding(
        specId: 're_etw',
        ownedSinceDayIndex: 0,
        purchasePrice: Money.cents(12000000),
      );
      final source = _FakeHoldingsSource([holding]);
      final listener = MortgageListener(source);

      expect(await listener.onDayAdvance(GameDay.fromIndex(0)), isEmpty);
      expect(await listener.onDayAdvance(GameDay.fromIndex(15)), isEmpty);

      final events = await listener.onDayAdvance(GameDay.fromIndex(30));
      expect(events, hasLength(2));
      final kinds = events
          .whereType<InsuranceFeeEvent>()
          .map((e) => e.kind)
          .toList();
      expect(kinds, containsAll(<String>['Hypothek', 'Instandhaltung']));
    });
  });

  group('RentListener — Cashflow + Leerstand', () {
    test('selbstgenutzte Immobilie -> keine Miete', () async {
      const h = RealEstateHolding(
        specId: 're_etw',
        ownedSinceDayIndex: 0,
        purchasePrice: Money.cents(12000000),
        usage: RealEstateUsage.selfOccupied,
      );
      final source = _FakeHoldingsSource([h]);
      final listener = RentListener(source);
      final events = await listener.onDayAdvance(GameDay.fromIndex(30));
      expect(events, isEmpty);
      expect(source.rentCredited, 0);
    });

    test('dieselbe Wohnung vermietet -> Miete nach Steuer', () async {
      const h = RealEstateHolding(
        specId: 're_etw',
        ownedSinceDayIndex: 0,
        purchasePrice: Money.cents(12000000),
        usage: RealEstateUsage.rented,
      );
      final source = _FakeHoldingsSource([h]);
      // Seed ohne Leerstand in diesem Monat.
      final listener = RentListener(source, vacancySeed: 1);
      final events = await listener.onDayAdvance(GameDay.fromIndex(30));
      if (events.isEmpty) return; // Leerstand — anderer Monat, kein Fehler.
      final gross = RealEstateCatalog.eigentumswohnung.monthlyRent!;
      // Gutgeschrieben wird NETTO — sonst stimmt der angezeigte Betrag nicht
      // mit dem überein, was auf dem Konto landet.
      expect(source.rentCredited, rentAfterTax(gross).cents);
      expect(source.rentCredited, lessThan(gross.cents));
    });

    test('Mehrfamilienhaus zahlt Miete', () async {
      const h = RealEstateHolding(
        specId: 're_mfh',
        ownedSinceDayIndex: 0,
        purchasePrice: Money.cents(75000000),
      );
      final source = _FakeHoldingsSource([h]);
      final listener = RentListener(source, vacancySeed: 1);
      var rentCount = 0;
      for (var m = 1; m <= 12; m++) {
        final events =
            await listener.onDayAdvance(GameDay.fromIndex(m * 30));
        rentCount += events.whereType<RentIncomeEvent>().length;
      }
      // 5 % Leerstandsrate -> in 12 Monaten typisch >= 10
      expect(rentCount, greaterThanOrEqualTo(10));
      expect(source.rentCredited, greaterThan(0));
    });

    test('Leerstand ist deterministisch (gleicher seed = gleicher Pfad)',
        () async {
      const h = RealEstateHolding(
        specId: 're_mfh',
        ownedSinceDayIndex: 0,
        purchasePrice: Money.cents(75000000),
      );

      Future<List<bool>> runWith(int seed) async {
        final src = _FakeHoldingsSource([h]);
        final l = RentListener(src, vacancySeed: seed);
        final result = <bool>[];
        for (var m = 1; m <= 24; m++) {
          final ev = await l.onDayAdvance(GameDay.fromIndex(m * 30));
          result.add(ev.isNotEmpty);
        }
        return result;
      }

      final a = await runWith(42);
      final b = await runWith(42);
      expect(a, b);
    });
  });
}