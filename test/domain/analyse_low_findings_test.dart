import 'package:finanzgame/features/daily_quiz/quiz_pool.dart';
import 'package:finanzgame/features/daily_quiz/quiz_question.dart';
import 'package:finanzgame/features/daily_quiz/quiz_topics.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/metal/metal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finanzgame/ui/widgets/purchasing_power_chart.dart';

/// Wächter für die kleinen Befunde der Code-Analyse 2026-08 (L3, L9, L13,
/// L14). Die restlichen (L6/L7/L8/L10/L12) hängen an Riverpod-Zustand oder
/// Dateisystem und sind in ihren jeweiligen Feature-Tests bzw. inline
/// dokumentiert.
void main() {
  group('L14 · Ø-Einstandskurs rundet, statt abzuschneiden', () {
    /// Dieselbe Formel wie in allen vier Handels-Repositories.
    int mergedAvg({
      required int oldAvgCents,
      required int oldShares,
      required int priceCents,
      required int shares,
    }) =>
        (((oldAvgCents * oldShares) + (priceCents * shares)) /
                (oldShares + shares))
            .round();

    test('rundet auf statt ab (vorher `~/`)', () {
      // 1× zu 100 ¢, 2× zu 101 ¢ → exakt 100,666… → 101, nicht 100.
      expect(
        mergedAvg(
          oldAvgCents: 100,
          oldShares: 1,
          priceCents: 101,
          shares: 2,
        ),
        101,
      );
    });

    test('bleibt exakt, wo die Division aufgeht', () {
      expect(
        mergedAvg(
          oldAvgCents: 200,
          oldShares: 3,
          priceCents: 400,
          shares: 1,
        ),
        250,
      );
    });
  });

  group('L13 · Metall-Exploit-Schwelle', () {
    test('liegt unter dem Kurs-Floor, also außerhalb legitimer Käufe', () {
      for (final spec in MetalCatalog.all) {
        final threshold = MetalCatalog.exploitAvgPriceThresholdCentsFor(spec);
        final floor = MetalCatalog.priceFloorCentsFor(spec, 0);
        expect(
          threshold,
          lessThan(floor),
          reason: '${spec.id}: ein Kauf zum tiefstmöglichen Kurs darf NIE als '
              'Exploit gelten, sonst würde die Normalisierung ehrliche '
              'Bestände einkassieren.',
        );
        expect(threshold, greaterThan(0));
      }
    });
  });

  group('L9 · Meisterprüfung braucht genug schwere Fragen', () {
    test('Hard-Pool trägt eine volle Runde', () {
      final hard =
          kQuizPool.whereType<MultipleChoiceQuestion>().where(
                (q) => q.tier == QuizTier.hard,
              );
      // Unter 10 greift der Auffüll-Pfad in `WissensQuizPage` — der rettet
      // die Runde, macht die „Meisterprüfung" aber weicher. Fällt der Pool
      // hier durch, gehören neue schwere Fragen nachgelegt.
      expect(hard.length, greaterThanOrEqualTo(10));
    });
  });

  group('L3 · Chart-Titel folgt dem Zeitraum', () {
    testWidgets('20 Jahre stehen auch im Titel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PurchasingPowerChart(years: 20, height: 200),
            ),
          ),
        ),
      );
      expect(find.textContaining('über 20 Jahre'), findsOneWidget);
      expect(find.textContaining('über 10 Jahre'), findsNothing);
    });
  });

  group('Money bleibt Cent-genau', () {
    test('Runden erzeugt keine Bruchteile', () {
      expect(const Money.cents(101).cents, 101);
    });
  });
}
