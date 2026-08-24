import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bank/savings_repository.dart';
import '../collectibles/collectible_repository.dart';
import '../crypto/crypto_repository.dart';
import '../economy/cash_state.dart';
import '../../domain/forest/tree.dart';
import '../etf/etf_repository.dart';
import '../forest/tree_repository.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../stock/stock_repository.dart';
import '../vorsorge/vorsorge_repository.dart';

/// Zentrale Net-Worth-Berechnung in Cents.
///
/// Aggregiert alle Asset-Klassen: Cash + Spar + ETF + Aktien + Krypto +
/// Metalle + Immobilien + Vorsorge + Sammlerobjekte + Bäume.
///
/// EINZIGE Quelle der Wahrheit — `stats_page` und `ruhestand_page` hatten bis
/// zur Analyse-Runde 2026-08 je eine eigene Summe (Stats mit, Ruhestand ohne
/// Sammlerobjekte, beide ohne Bäume). Ein sammelnder Spieler sah in den Stats
/// mehr Vermögen als das, was für Highscore und Erbe zählte.
///
/// „Netto" ist wörtlich gemeint: Immobilien gehen mit Marktwert MINUS
/// Restschuld ein, und ein überzogenes Konto ist als negativer Cash-Betrag
/// automatisch enthalten. Schulden zählen also nie als Vermögen.
///
/// Wunsch-/Möbel-Werte sind bewusst NICHT enthalten — Spec-43 v3 definiert
/// sie als Konsumgüter, nicht als Vermögen.
class NetWorth {
  const NetWorth._();

  /// Liest alle Repositories über [ref] und liefert das aktuelle
  /// Netto-Vermögen in Cents.
  ///
  /// [dayIndex] wird für Immobilien-/Sammlerobjekt-Marktwerte gebraucht
  /// (die wachsen täglich).
  static int compute(Ref ref, int dayIndex) {
    final cash = ref.read(cashStateProvider).cents;
    final savings = ref.read(savingsRepositoryProvider).cents;

    final etf = ref.read(etfRepositoryProvider);
    final etfValue = etf.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (etf.quotes[h.etfId]?.pricePerShare.cents ?? 0) * h.shares,
    );

    final stock = ref.read(stockRepositoryProvider);
    final stockValue = stock.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (stock.quotes[h.stockId]?.pricePerShare.cents ?? 0) * h.shares,
    );

    final crypto = ref.read(cryptoRepositoryProvider);
    final cryptoValue = crypto.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (crypto.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
    );

    final metal = ref.read(metalRepositoryProvider);
    final metalValue = metal.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (metal.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
    );

    // Immobilien zählen mit dem MARKTWERT MINUS RESTSCHULD.
    //
    // Vorher ging nur der Marktwert ein — ein Wohnungskauf ließ das Vermögen
    // also um die Hypothek springen (bei 120.000 € Kaufpreis: 37.200 € Cash
    // raus, 120.000 € Wert rein, 96.000 € Schuld unsichtbar). Das ist für
    // eine Finanzbildungs-App der falsche Begriff von Vermögen: geliehenes
    // Geld ist kein Besitz. Man konnte damit auf Kredit „Millionär" werden.
    // `sell()` rechnete schon immer korrekt Marktwert − Restschuld — die
    // Anzeige war der Ausreißer, nicht die Absicht.
    final reRepo = ref.read(realEstateRepositoryProvider.notifier);
    final reValue = ref.read(realEstateRepositoryProvider).fold<int>(
          0,
          (sum, h) =>
              sum +
              reRepo.currentValueOf(h, dayIndex).cents -
              reRepo.mortgageRemaining(h, dayIndex).cents,
        );

    final vorsorgeValue = ref.read(vorsorgeRepositoryProvider).fold<int>(
          0,
          (sum, c) => sum + c.totalContributed.cents + c.totalSubsidy.cents,
        );

    final collectibleRepo = ref.read(collectibleRepositoryProvider.notifier);
    final collectibles = ref.read(collectibleRepositoryProvider);
    final collectibleValue = collectibles.fold<int>(
      0,
      (sum, h) => sum + collectibleRepo.currentValueOf(h, dayIndex).cents,
    );

    // Bäume (Sammlerinsel-Wald) — bis zur Analyse-Runde 2026-08 die einzige
    // gekaufte Anlage, die im Vermögen GAR NICHT auftauchte: wer vier Eichen
    // pflanzte, sah sein Vermögen um 2.000 € FALLEN, ohne dass das Kapital je
    // wieder sichtbar wurde. Das verfälschte Millionärs-Trophäe,
    // Lebensziele, Highscore, Legacy-Punkte und den Benchmark.
    //
    // Bewertet zum Kaufpreis (Anschaffungswert) — dieselbe Konvention wie bei
    // der Vorsorge, die mit Einzahlungen + Zulagen zählt. Ein Marktwert
    // existiert nicht: Bäume haben keinen Kurs, und der Fäll-Erlös
    // (30 × Tagesertrag) ist ein Schrottwert, kein Verkehrswert.
    final treeValue = ref.read(treeRepositoryProvider).fold<int>(
          0,
          (sum, t) => sum + TreeCatalog.spec(t.kind).cost.cents,
        );

    return cash +
        savings +
        etfValue +
        stockValue +
        cryptoValue +
        metalValue +
        reValue +
        vorsorgeValue +
        collectibleValue +
        treeValue;
  }

  /// Pure additive sum — für Tests.
  static int sum(List<int> parts) =>
      parts.fold<int>(0, (a, b) => a + b);
}

/// Schwelle: ab 100.000.000 ct (= 1.000.000 €) ist man Millionär.
const int millionaireThresholdCents = 100 * 1000 * 1000;

/// Welle-8 Round 15: Provider-Variante für WidgetRef-Konsumenten.
/// Liest dieselben Repos wie [NetWorth.compute], ist aber auch aus
/// Widget-Code aufrufbar (z.B. SchlafenButton's WeeklyReview-Hook).
final netWorthProvider = Provider.family<int, int>((ref, dayIndex) {
  // Abhängigkeiten EXPLIZIT beobachten. [NetWorth.compute] liest alles per
  // `ref.read` (weil es auch aus Notifier-Methoden aufgerufen wird, wo
  // `watch` nicht erlaubt ist) — ohne diese watches würde der Provider seinen
  // Wert einfrieren und nach einem Kauf/Verkauf innerhalb desselben Spieltags
  // noch den alten Stand liefern. Im Spiel fiel das kaum auf, weil der
  // Family-Key `dayIndex` täglich wechselt und damit neu rechnet.
  ref.watch(cashStateProvider);
  ref.watch(savingsRepositoryProvider);
  ref.watch(etfRepositoryProvider);
  ref.watch(stockRepositoryProvider);
  ref.watch(cryptoRepositoryProvider);
  ref.watch(metalRepositoryProvider);
  ref.watch(realEstateRepositoryProvider);
  ref.watch(vorsorgeRepositoryProvider);
  ref.watch(collectibleRepositoryProvider);
  ref.watch(treeRepositoryProvider);
  return NetWorth.compute(ref, dayIndex);
});
