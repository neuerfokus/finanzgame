import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/sim/fast_forward_crisis.dart';

/// CI-Waechter fuer den Krisenwurf des Zeitsprungs.
///
/// **Was hier schiefging** (gemessen 2026-08-24): der alte Wurf hatte einen
/// Sockel von 2 % Krisenchance und 5 % Mindestschwere PRO SPRUNG. Der
/// Kursgewinn waechst proportional zu den Tagen, dieser Sockel nicht — also
/// war der Erwartungswert kurzer Spruenge negativ. Die 7-Tage-Voreinstellung
/// kostete **−13,1 % pro Spieljahr**. Im Spielstand eines Testers standen
/// deshalb alle fuenf ETFs, alle drei Aktien und Bitcoin auf exakt ihrem
/// Bandboden.
///
/// Der Waechter prueft deshalb nicht einzelne Zahlen (die darf man tunen),
/// sondern die Eigenschaften, die den Fehler unmoeglich machen:
///
///  1. Kein Sprung darf im Erwartungswert Vermoegen vernichten.
///  2. Die Kosten pro Tag duerfen bei KURZEN Spruengen nicht hoeher sein als
///     bei langen — genau diese Umkehrung war die Signatur des Fehlers.
///  3. Vergeht kein Tag, gibt es keine Krise.
///  4. Der Wurf ist deterministisch.
void main() {
  /// Die Voreinstellungen des ⏩-Knopfes.
  const presets = [7, 30, 90, 365, 1825];

  /// Gemessene Rendite eines gehaltenen Welt-ETF ueber die echte
  /// Listener-Kette: +4,84 %/Jahr. Konservativ auf 4,5 % gerundet, damit der
  /// Waechter nicht bei jeder Balance-Feinjustierung ausschlaegt.
  const baselineGrowthPerYear = 0.045;
  final baselineGrowthPerDay = math.log(1 + baselineGrowthPerYear) / 365.0;

  /// Erwartete Krisenkosten pro Spieltag, gemittelt ueber viele Spielstaende.
  /// Laeuft gegen die ausgelieferte Funktion, nicht gegen eine nachgebaute
  /// Formel — eine Aenderung an [FastForwardCrisisModel] schlaegt hier durch.
  double expectedCostPerDay(int days, {int samples = 20000}) {
    var total = 0.0;
    for (var i = 0; i < samples; i++) {
      // Verschiedene Spielstaende: dayIndex wandert ueber ein ganzes Leben.
      final crisis = FastForwardCrisisModel.roll(days: days, dayIndex: i * 7);
      total += crisis.dropPct;
    }
    return (total / samples) / days;
  }

  group('Zeitsprung-Krise: kein Sprung vernichtet Vermoegen', () {
    for (final days in presets) {
      test('$days Tage: Kosten/Tag unter dem Kurswachstum/Tag', () {
        final cost = expectedCostPerDay(days);
        expect(
          cost,
          lessThan(baselineGrowthPerDay),
          reason: 'Ein Sprung ueber $days Tage kostet im Mittel '
              '${(cost * 100).toStringAsFixed(5)} % pro Tag, der Kurs waechst '
              'aber nur um ${(baselineGrowthPerDay * 100).toStringAsFixed(5)} % '
              'pro Tag. Diese Sprungweite verbrennt damit Vermoegen — genau '
              'der Fehler, den der 2-%-Sockel 2026-08 verursacht hat.',
        );
      });
    }

    test('kein kurzer Sprung kostet pro Tag mehr als der laengste', () {
      // Bewusst NICHT auf Nachbarpaare geprueft: 7 und 30 Tage liegen
      // rechnerisch nur 3 % auseinander, die Krise trifft bei 7 Tagen aber
      // nur in 0,14 % der Faelle — eine Stichprobe schwankt staerker als der
      // Unterschied gross ist, der Test waere ein Flackerlicht.
      //
      // Der Abstand, der den FEHLER beschreibt, ist dagegen riesig: im alten
      // Modell kostete der 7-Tage-Sprung 5,1e-4 pro Tag und der
      // 5-Jahres-Sprung 6,4e-5 — Faktor 8 in die falsche Richtung. Der
      // Faktor 1,25 hier laesst dem Rauschen Luft und faengt jede
      // Wiederkehr dieser Umkehrung.
      final perDay = {for (final d in presets) d: expectedCostPerDay(d)};
      final laengster = perDay[presets.last]!;
      for (final days in presets) {
        expect(
          perDay[days]!,
          lessThanOrEqualTo(laengster * 1.25),
          reason: 'Ein Sprung ueber $days Tage kostet pro Tag '
              '${perDay[days]!.toStringAsExponential(2)}, der ueber '
              '${presets.last} Tage nur ${laengster.toStringAsExponential(2)}. '
              'Kurzes Vorspulen waere damit teurer als langes — die '
              'Umkehrung, die den alten Fehler ausgemacht hat.',
        );
      }
    });

    test('lange Spruenge bleiben spuerbar riskanter als kurze', () {
      // Die Absicht des Features bleibt erhalten: wer fuenf Jahre ueberspringt,
      // geht ein echtes Risiko ein. Ohne diese Zusicherung koennte man den
      // Waechter oben auch erfuellen, indem man die Krise ganz abschafft.
      var hits = 0;
      const samples = 4000;
      for (var i = 0; i < samples; i++) {
        if (FastForwardCrisisModel.roll(days: 1825, dayIndex: i * 7).hit) {
          hits++;
        }
      }
      final rate = hits / samples;
      expect(rate, greaterThan(0.15),
          reason: '5-Jahres-Sprung trifft nur in ${(rate * 100).round()} % der '
              'Faelle eine Krise — das Feature waere zahnlos.');
      expect(rate, lessThan(0.50),
          reason: '5-Jahres-Sprung trifft in ${(rate * 100).round()} % der '
              'Faelle — das ist Gluecksspiel statt Risiko.');
    });
  });

  group('Zeitsprung-Krise: Randfaelle', () {
    test('vergeht kein Tag, gibt es keine Krise', () {
      // Am Lebensende trimmt fastForward auf null echte Tage. Der alte Wurf
      // lief trotzdem: bis zu 15 % auf alle Anlagen weg, ohne dass ein Tag
      // verging, ueber den ungegateten ⏩-Knopf beliebig oft wiederholbar.
      for (var dayIndex = 0; dayIndex < 3000; dayIndex += 7) {
        for (final days in const [0, -1, -1825]) {
          final crisis =
              FastForwardCrisisModel.roll(days: days, dayIndex: dayIndex);
          expect(crisis.hit, isFalse);
          expect(crisis.dropPct, 0.0);
        }
      }
    });

    test('derselbe Spielstand liefert denselben Wurf', () {
      // Vorher stand hier ein ungeseedetes math.Random() — nicht reproduzierbar
      // und eine Einladung, bis zum guenstigen Wurf neu zu starten.
      for (final days in presets) {
        for (final dayIndex in const [0, 137, 4271, 6574]) {
          final a = FastForwardCrisisModel.roll(days: days, dayIndex: dayIndex);
          final b = FastForwardCrisisModel.roll(days: days, dayIndex: dayIndex);
          expect(a.hit, b.hit);
          expect(a.severity, b.severity);
        }
      }
    });

    test('Schwere liegt immer in der Spanne ihrer Sprungweite', () {
      for (final days in presets) {
        final maxSev = FastForwardCrisisModel.maxSeverityFor(days);
        for (var i = 0; i < 2000; i++) {
          final c = FastForwardCrisisModel.roll(days: days, dayIndex: i * 13);
          if (!c.hit) {
            expect(c.severity, 0.0);
            continue;
          }
          expect(c.severity,
              inInclusiveRange(FastForwardCrisisModel.minSeverity, maxSev));
          // Ein Totalverlust darf nie herauskommen.
          expect(c.severity, lessThan(1.0));
        }
      }
    });

    test('Trefferquote waechst monoton mit der Sprungweite', () {
      double rate(int days) {
        var hits = 0;
        const samples = 4000;
        for (var i = 0; i < samples; i++) {
          if (FastForwardCrisisModel.roll(days: days, dayIndex: i * 7).hit) {
            hits++;
          }
        }
        return hits / samples;
      }

      var prev = -1.0;
      for (final days in presets) {
        final r = rate(days);
        expect(r, greaterThan(prev),
            reason: '$days Tage trifft nicht haeufiger als die kuerzere '
                'Voreinstellung davor.');
        prev = r;
      }
    });

    test('failChanceFor folgt der Tages-Gefahr, nicht einem Sockel', () {
      const h = FastForwardCrisisModel.hazardPerDay;
      // Kein Sockel: bei einem Tag ist die Chance genau die Tages-Gefahr.
      expect(FastForwardCrisisModel.failChanceFor(1, h), closeTo(h, 1e-12));
      // Und sie waechst wie 1 - (1-h)^n.
      expect(
        FastForwardCrisisModel.failChanceFor(1825, h),
        closeTo(1 - math.pow(1 - h, 1825).toDouble(), 1e-12),
      );
      expect(FastForwardCrisisModel.failChanceFor(0, h), 0.0);
    });
  });
}
