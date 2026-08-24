import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/realestate/real_estate.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/job_level.dart';
import 'package:finanzgame/domain/sim/listeners/living_cost_listener.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/realestate/real_estate_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Selbst bewohnen ⇄ vermieten.
///
/// **Der Fehler dahinter (User-Fund 2026-08):** nur das Mehrfamilienhaus
/// hatte eine Miete, alle anderen Objekte brachten null Einnahmen — während
/// die Lebenskosten (Miete + Essen + Versicherung) unverändert weiterliefen.
/// Ein Eigenheim kostete Anzahlung, 11 % Nebenkosten, 30 Jahre Hypothek und
/// Instandhaltung, **und man zahlte weiter Miete**. Kaufen war damit die
/// garantiert schlechteste Entscheidung im Spiel.
void main() {
  ProviderContainer containerWith(AppDatabase db, DbSnapshot snap) =>
      ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(snap),
      ]);

  group('Lebenskosten mit und ohne eigene Wohnung', () {
    test('Miet-Anteil sind 60 % — der Rest bleibt', () {
      const job = JobLevel.vollzeit;
      expect(JobConfig.monthlyLivingCost(job).cents, 80000);
      expect(JobConfig.monthlyRentShare(job).cents, 48000);
      expect(JobConfig.monthlyLivingCostWithoutRent(job).cents, 32000);
      // Beide Teile ergeben zusammen wieder die vollen Lebenskosten.
      expect(
        JobConfig.monthlyRentShare(job).cents +
            JobConfig.monthlyLivingCostWithoutRent(job).cents,
        JobConfig.monthlyLivingCost(job).cents,
      );
    });

    test('gespart wird höchstens die Miete der eigenen Wohnung', () {
      // Beim Test am Gerät aufgefallen: nimmt man immer den vollen
      // Miet-Anteil, spart die 120.000-€-Wohnung (Marktmiete 350 €) genauso
      // viel wie das 480.000-€-Haus — nämlich 720 €. Die BILLIGSTE Immobilie
      // wäre damit die beste, und das ist ökonomisch verkehrt herum.
      const job = JobLevel.lead; // 1.200 € Lebenskosten → 720 € Miet-Anteil
      expect(JobConfig.monthlyRentShare(job).cents, 72000);

      // Kleine Wohnung: nur ihre eigene Marktmiete.
      expect(
        JobConfig.savedRentFor(
          job,
          RealEstateCatalog.eigentumswohnung.monthlyRent,
        ).cents,
        35000,
      );
      // Großes Haus: gedeckelt auf das, was man vorher an Miete zahlte.
      expect(
        JobConfig.savedRentFor(
          job,
          RealEstateCatalog.freistehendesHaus.monthlyRent,
        ).cents,
        72000,
      );
      // Zur Miete wohnend: gar nichts.
      expect(JobConfig.savedRentFor(job, null).cents, 0);
    });

    test('Eigenheim senkt die monatliche Abbuchung', () async {
      const day = 3630; // Vielfaches von 30, Vollzeit-Phase
      final zurMiete = await const LivingCostListener(startAgeYears: 20)
          .onDayAdvance(GameDay.fromIndex(day));
      final imEigenheim = await const LivingCostListener(
        startAgeYears: 20,
        // Großes Haus → voller Miet-Anteil gespart.
        ownHomeMarketRent: Money.cents(140000),
      ).onDayAdvance(GameDay.fromIndex(day));

      expect(zurMiete, hasLength(1));
      expect(imEigenheim, hasLength(1));
      final mit = (zurMiete.first as dynamic).amount as Money;
      final ohne = (imEigenheim.first as dynamic).amount as Money;
      expect(ohne.cents, lessThan(mit.cents));
      // Exakt 40 % bleiben übrig (Essen, Strom, Versicherung).
      expect(ohne.cents, closeTo(mit.cents * 0.4, 2));
      // Und die Zeile heißt anders, damit man den Grund sieht.
      expect((imEigenheim.first as dynamic).kind, 'Lebenskosten (ohne Miete)');
    });

    test('kleine Wohnung senkt weniger als ein großes Haus', () async {
      const day = 3630;
      Future<int> costWith(Money? rent) async {
        final e = await LivingCostListener(
          startAgeYears: 20,
          ownHomeMarketRent: rent,
        ).onDayAdvance(GameDay.fromIndex(day));
        return ((e.first as dynamic).amount as Money).cents;
      }

      final wohnung = await costWith(const Money.cents(35000));
      final haus = await costWith(const Money.cents(140000));
      expect(haus, lessThan(wohnung));
    });
  });

  group('Nutzung umschalten', () {
    test('erste Immobilie zieht man selbst ein, weitere werden vermietet',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = containerWith(db, const DbSnapshot());
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(50000000));
      final repo = c.read(realEstateRepositoryProvider.notifier);

      repo.buy('re_etw', 0);
      expect(repo.holdingFor('re_etw')!.usage, RealEstateUsage.selfOccupied);
      expect(repo.livesInOwnProperty, isTrue);

      repo.buy('re_reihenhaus', 0);
      expect(repo.holdingFor('re_reihenhaus')!.usage, RealEstateUsage.rented);
    });

    test('man kann nur in EINER wohnen — die alte wird automatisch vermietet',
        () {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = containerWith(db, const DbSnapshot());
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(50000000));
      final repo = c.read(realEstateRepositoryProvider.notifier);
      repo.buy('re_etw', 0);
      repo.buy('re_reihenhaus', 0);

      repo.setUsage('re_reihenhaus', RealEstateUsage.selfOccupied);

      expect(repo.holdingFor('re_reihenhaus')!.usage,
          RealEstateUsage.selfOccupied);
      expect(repo.holdingFor('re_etw')!.usage, RealEstateUsage.rented);
      // Und weiterhin genau eine bewohnte.
      expect(
        c
            .read(realEstateRepositoryProvider)
            .where((h) => h.usage == RealEstateUsage.selfOccupied)
            .length,
        1,
      );
    });

    test('ins Mehrfamilienhaus kann man nicht einziehen', () {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = containerWith(db, const DbSnapshot());
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(50000000));
      final repo = c.read(realEstateRepositoryProvider.notifier);
      repo.buy('re_mfh', 0);

      expect(repo.holdingFor('re_mfh')!.usage, RealEstateUsage.rented);
      expect(
        () => repo.setUsage('re_mfh', RealEstateUsage.selfOccupied),
        throwsA(isA<RealEstateError>()),
      );
      expect(repo.livesInOwnProperty, isFalse);
    });

    test('Spekulationssteuer nur bei vermieteten Objekten', () {
      // Echte Regel: wer selbst drin gewohnt hat, zahlt beim Verkauf keine.
      // Vorher hing das am Objekttyp und galt nur fürs Mehrfamilienhaus.
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = containerWith(db, const DbSnapshot());
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(50000000));
      final repo = c.read(realEstateRepositoryProvider.notifier);

      repo.buy('re_etw', 0); // → selbst bewohnt
      final eigen = repo.sell('re_etw', 365 * 2);
      expect(eigen.speculationTax.cents, 0);

      repo.buy('re_reihenhaus', 0); // → vermietet (die ETW ist weg, aber
      // livesInOwnProperty war beim Kauf false → wird selbst bewohnt)
      repo.setUsage('re_reihenhaus', RealEstateUsage.rented);
      final vermietet = repo.sell('re_reihenhaus', 365 * 2);
      expect(vermietet.speculationTax.cents, greaterThan(0));
    });

    test('Nutzung überlebt den App-Neustart (Drift v39)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = containerWith(db, const DbSnapshot());
      c1.read(cashStateProvider.notifier).earn(const Money.cents(50000000));
      c1.read(realEstateRepositoryProvider.notifier).buy('re_etw', 0);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = containerWith(db, snap);
      addTearDown(c2.dispose);
      expect(
        c2.read(realEstateRepositoryProvider.notifier).holdingFor('re_etw')!
            .usage,
        RealEstateUsage.selfOccupied,
      );
    });
  });
}
