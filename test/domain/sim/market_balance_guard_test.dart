import 'dart:math' as math;

import 'package:finanzgame/domain/sim/listeners/crypto_price_listener.dart';
import 'package:finanzgame/domain/sim/listeners/etf_price_listener.dart';
import 'package:finanzgame/domain/sim/market_phase.dart';
import 'package:finanzgame/domain/sim/rng.dart';
import 'package:finanzgame/domain/sim/weather.dart';
import 'package:finanzgame/features/weather/weather_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wächter für die Balance-Analyse 2026-08.
///
/// Gefunden wurde damals, dass die geplante Rendite jeder Anlageklasse von
/// unsichtbaren Effekten aufgefressen wurde: einem Zufallsgenerator mit
/// schiefem Mittelwert, einem Wetter mit negativem Erwartungswert, dem
/// Varianz-Drag multiplikativer Returns und Marktphasen, die nach jedem Crash
/// dauerhaft etwas einbehielten. Ein Welt-ETF verlor über zehn Spieljahre
/// knapp die Hälfte seines Werts — in einer App, die Anlegen lehren soll.
///
/// Die Tests hier prüfen nicht einzelne Zahlen, sondern die Eigenschaften, die
/// den Fehler unmöglich machen.
void main() {
  group('Zufall ohne Schlagseite', () {
    test('centeredNormal hat pro Jahresblock exakt Mittelwert 0', () {
      for (final assetSeed in [0xE7F00D, 0x57AC0, 12345]) {
        for (final year in [0, 3, 17]) {
          var sum = 0.0;
          for (var d = year * 365; d < (year + 1) * 365; d++) {
            sum += centeredNormal(assetSeed, d);
          }
          expect(
            (sum / 365).abs(),
            lessThan(1e-12),
            reason: 'Rausch-Mittel im Jahr $year ist nicht 0 — genau das '
                'kostete den ETF vorher 3,3 % Rendite pro Jahr.',
          );
        }
      }
    });

    test('centeredNormal streut weiterhin wie N(0,1)', () {
      var sumSq = 0.0;
      for (var d = 0; d < 3650; d++) {
        final z = centeredNormal(0xE7F00D, d);
        sumSq += z * z;
      }
      // Zentrieren darf die Schwankung nicht wegnehmen, nur den Trend.
      expect(math.sqrt(sumSq / 3650), closeTo(1.0, 0.1));
    });

    test('dealCard teilt jedes Deck vollständig aus', () {
      const deck = EtfPriceListener.yearRegimeDeck;
      for (final blockStart in [0, 10, 30]) {
        final drawn = [
          for (var i = blockStart; i < blockStart + deck.length; i++)
            dealCard(0xE7F1ED, i, deck),
        ];
        expect(
          (drawn..sort()).toString(),
          ([...deck]..sort()).toString(),
          reason: 'Ein Jahrzehnt muss exakt die geplante Mischung enthalten.',
        );
      }
    });

    test('Wetter trifft die geplanten Anteile exakt', () {
      final counts = <Weather, int>{};
      for (var d = 0; d < 365; d++) {
        counts.update(rollWeather(d), (v) => v + 1, ifAbsent: () => 1);
      }
      expect(counts[Weather.sunny], 128);
      expect(counts[Weather.cloudy], 128);
      expect(counts[Weather.rain], 80);
      expect(counts[Weather.storm], 29);
    });

    test('Wetter zieht dem Kurs im Jahresmittel nichts ab', () {
      var sum = 0.0;
      for (var d = 0; d < 365; d++) {
        sum += EtfPriceListener.weatherMarketDelta(rollWeather(d));
      }
      // Wetter ist Würze, kein Renditefaktor: vorher −1,9 %/Jahr.
      expect((sum * 100).abs(), lessThan(0.05));
    });
  });

  group('Geplante Rendite kommt auch an', () {
    /// Was die Drawdown/Recovery-Phasen einer Klasse pro Jahr dauerhaft
    /// kosten: ein Zyklus multipliziert den Kurs mit
    /// `(1−tiefe/dauer)^dauer × (1+tiefe·anteil/erholdauer)^erholdauer`.
    double phaseDragPerYear(MarketPhaseProfile p) {
      final depth = (p.crashDepthMin + p.crashDepthMax) / 2;
      final perCycle = math.log(
        math.pow(1 - depth / p.drawdownDuration, p.drawdownDuration) *
            math.pow(
              1 + depth * p.recoveryFraction / p.recoveryDuration,
              p.recoveryDuration,
            ),
      );
      final cyclesPerYear = 365 /
          (p.drawdownDuration + p.recoveryDuration + 1 / p.crashChancePerDay);
      return math.exp(perCycle * cyclesPerYear) - 1;
    }

    /// Der geplante Aufwärtstrend jeder Klasse, wie er in den jeweiligen
    /// Katalogen/Decks steht. Der Phasen-Abzug muss darunter bleiben, sonst
    /// fällt die Klasse langfristig, egal was der Katalog verspricht.
    const plannedUptrend = <String, double>{
      'etf': 0.054, // yearRegimeDeck, geometrisch
      'stock': 0.060, // niedrigste baseDriftPerDay im StockCatalog
      'gold': 0.036, // inflationFactor 1.8 × 2 %/Jahr Inflation
      'silver': 0.050, // inflationFactor 2.5
      'platin': 0.040, // inflationFactor 2.0
      'crypto': 0.098, // bitcoinYearDeck, geometrisch
    };

    test('Marktphasen kosten weniger, als die Klasse an Trend hergibt', () {
      for (final p in MarketProfiles.all) {
        final drag = phaseDragPerYear(p);
        final trend = plannedUptrend[p.classId]!;
        expect(
          -drag,
          lessThan(trend),
          reason: '${p.classId}: unvollständige Erholung ist ein PERMANENTER '
              'Abzug von ${(-drag * 100).toStringAsFixed(1)} %/Jahr gegen '
              'einen geplanten Trend von ${(trend * 100).toStringAsFixed(1)} %. '
              'Vor der Analyse lagen Aktien bei −10 %/Jahr und Krypto bei '
              '−25 %/Jahr — beide fielen dadurch langfristig.',
        );
        // Und mit Abstand, nicht auf Kante: mindestens die Hälfte des Trends
        // muss übrig bleiben, sonst frisst eine kleine Katalog-Änderung die
        // Rendite wieder auf.
        expect(-drag, lessThan(trend * 0.6));
      }
    });

    test('ETF-Jahresdeck liefert geometrisch 4–7 %/Jahr', () {
      var logSum = 0.0;
      for (final f in EtfPriceListener.yearRegimeDeck) {
        logSum += math.log(f);
      }
      final geo = math.exp(logSum / EtfPriceListener.yearRegimeDeck.length) - 1;
      // Muss die Inflation (2 %/Jahr) klar schlagen, sonst lehrt die App das
      // Gegenteil ihrer Botschaft — und darf nicht ins Unrealistische kippen.
      expect(geo, greaterThan(0.04));
      expect(geo, lessThan(0.07));
    });

    test('Bitcoin-Jahresdeck steigt langfristig', () {
      var logSum = 0.0;
      for (final f in CryptoPriceListener.bitcoinYearDeck) {
        logSum += math.log(f);
      }
      final geo =
          math.exp(logSum / CryptoPriceListener.bitcoinYearDeck.length) - 1;
      expect(geo, greaterThan(0.05));
    });

    test('Varianz-Drag-Korrektur entspricht sigma²/2', () {
      expect(varianceDragCorrection(0.009), closeTo(0.0000405, 1e-9));
      expect(varianceDragCorrection(0.0), 0.0);
    });
  });
}
