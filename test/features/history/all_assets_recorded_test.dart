import 'package:finanzgame/features/history/asset_labels.dart';
import 'package:flutter_test/flutter_test.dart';

/// Die Zeitreise muss JEDE Anlageklasse kennen, die ins Netto-Vermögen
/// zählt.
///
/// **Der Fehler (User-Fund 2026-08):** aufgezeichnet wurden nur Bargeld,
/// Spareinlagen, ETFs und Aktien — obwohl das Spiel sechs weitere Anlagen
/// kennt (Krypto, Edelmetalle, Immobilien, Vorsorge, Sammlerobjekte, Bäume),
/// die alle im Vermögen mitzählen. Wer sein Geld in Gold oder eine Wohnung
/// gesteckt hatte, sah im Rückblick eine Kurve, die einen Teil seines
/// Vermögens schlicht nicht enthielt.
void main() {
  group('Zeitreise kennt alle Anlageklassen', () {
    test('alle Klassen aus dem Netto-Vermögen sind auswählbar', () {
      // Spiegelt `NetWorth.compute`: Cash, Sparen, ETF, Aktien, Krypto,
      // Metalle, Immobilien, Vorsorge, Sammlerobjekte, Bäume. Kommt eine
      // Anlageklasse dazu, muss sie hier UND in `recordToday` auftauchen.
      const expected = <String>{
        HistoryAssetIds.cash,
        HistoryAssetIds.sparYield,
        HistoryAssetIds.etfIndex,
        HistoryAssetIds.stockIndex,
        HistoryAssetIds.cryptoIndex,
        HistoryAssetIds.metalIndex,
        HistoryAssetIds.realEstateIndex,
        HistoryAssetIds.vorsorgeIndex,
        HistoryAssetIds.collectibleIndex,
        HistoryAssetIds.treeIndex,
      };
      expect(HistoryAssetIds.all.toSet(), containsAll(expected));
    });

    test('jede auswählbare Reihe hat eine deutsche Beschriftung', () {
      for (final id in HistoryAssetIds.all) {
        final label = labelForAsset(id);
        expect(label, isNot(id),
            reason: '$id fällt auf die ID zurück statt einen Namen zu haben');
        expect(label, isNotEmpty);
      }
    });

    test('die Farben sind paarweise verschieden', () {
      // Bei elf möglichen Linien muss man sie in der Legende
      // auseinanderhalten können.
      final colors = HistoryAssetIds.all.map(colorForAsset).toList();
      expect(colors.toSet().length, colors.length);
    });

    test('der Crash-Marker bleibt aus der Auswahl heraus', () {
      // Er ist ein interner Marker für die roten Linien, keine Anlage.
      expect(HistoryAssetIds.all, isNot(contains(HistoryAssetIds.crashMarker)));
    });
  });
}
