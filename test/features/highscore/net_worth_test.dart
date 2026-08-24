import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/realestate/real_estate.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/highscore/net_worth.dart';
import 'package:finanzgame/features/realestate/real_estate_repository.dart';

/// Ein Immobilienkauf auf Hypothek darf das Vermögen NICHT um die Kreditsumme
/// erhöhen. Vorher zählte nur der Marktwert, die Restschuld fehlte komplett —
/// man konnte auf Kredit „Millionär" werden, und `sell()` (Marktwert −
/// Restschuld) widersprach der Anzeige.
void main() {
  // Erste Immobilie mit Hypothek aus dem Katalog.
  final spec = RealEstateCatalog.all.firstWhere((s) => s.mortgageEnabled);

  ProviderContainer container(Money cash) {
    final c = ProviderContainer();
    c.read(cashStateProvider.notifier).state = cash;
    return c;
  }

  test('Kauf auf Hypothek erhöht das Vermögen nicht um die Kreditsumme', () {
    final startCash = Money.cents(spec.basePrice.cents * 2);
    final c = container(startCash);
    addTearDown(c.dispose);

    final before = c.read(netWorthProvider(0));
    expect(before, startCash.cents);

    c.read(realEstateRepositoryProvider.notifier).buy(spec.id, 0);
    final after = c.read(netWorthProvider(0));

    // Kern-Invariante: ein Kauf auf Kredit macht NICHT reicher. Das Vermögen
    // darf höchstens gleich bleiben (Anzahlung wandert von Cash in Sachwert)
    // und sinkt um alles, was echt weg ist.
    expect(after, lessThanOrEqualTo(before));
    // Und vor allem: es steigt nicht um die Kreditsumme — das war der Bug.
    expect(after, lessThan(before + spec.initialMortgage.cents));

    // Gegenprobe gegen die Bestandteile: Cash plus Immobilien-NETTOwert.
    final repo = c.read(realEstateRepositoryProvider.notifier);
    final holding = c.read(realEstateRepositoryProvider).single;
    final netProperty = repo.currentValueOf(holding, 0).cents -
        repo.mortgageRemaining(holding, 0).cents;
    expect(after, c.read(cashStateProvider).cents + netProperty);
  });

  test('ohne den Schulden-Abzug wäre der Sprung genau die Hypothek', () {
    // Dokumentiert die Größenordnung des alten Fehlers: bei diesem Objekt
    // fehlten `initialMortgage` im Vermögen.
    final c = container(Money.cents(spec.basePrice.cents * 2));
    addTearDown(c.dispose);
    c.read(realEstateRepositoryProvider.notifier).buy(spec.id, 0);

    final repo = c.read(realEstateRepositoryProvider.notifier);
    final holding = c.read(realEstateRepositoryProvider).single;
    final gross = repo.currentValueOf(holding, 0).cents;
    final debt = repo.mortgageRemaining(holding, 0).cents;

    expect(debt, spec.initialMortgage.cents);
    expect(gross - debt, spec.downPayment.cents);
  });

  test('abbezahlte Immobilie zählt voll — Restschuld ist dann 0', () {
    final c = container(Money.cents(spec.basePrice.cents * 2));
    addTearDown(c.dispose);
    c.read(realEstateRepositoryProvider.notifier).buy(spec.id, 0);

    // Nach der vollen Laufzeit ist die Hypothek getilgt.
    final endDay = spec.mortgageTermYears * 365 + 365;
    final repo = c.read(realEstateRepositoryProvider.notifier);
    final holding = c.read(realEstateRepositoryProvider).single;

    expect(repo.mortgageRemaining(holding, endDay), Money.zero);
    // Dann steckt der komplette Marktwert im Vermögen.
    final netWorth = c.read(netWorthProvider(endDay));
    expect(netWorth,
        greaterThanOrEqualTo(repo.currentValueOf(holding, endDay).cents));
  });
}
