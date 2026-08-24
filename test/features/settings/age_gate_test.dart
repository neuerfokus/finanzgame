import 'dart:math' as math;

import 'package:finanzgame/domain/age/age_state.dart';
import 'package:finanzgame/domain/age/parent_gate_challenge.dart';
import 'package:flutter_test/flutter_test.dart';

/// Altersgate + Elternschranke vor der Trinkgeld-Funktion.
///
/// Google verbietet nicht die Funktion, wohl aber einen für Kinder frei
/// erreichbaren Weg aus der App zu einem Zahlungsanbieter. Die Tests hier
/// sichern die beiden Bausteine ab, die das leisten.
void main() {
  group('Altersstatus aus dem Geburtsjahr', () {
    const currentYear = 2026;

    test('keine Angabe = unknown (NICHT adult)', () {
      // Der wichtigste Fall: „übersprungen" darf nie wie „volljährig"
      // behandelt werden.
      expect(ageStateFor(null, currentYear: currentYear), AgeState.unknown);
    });

    test('genau 18 ist volljährig', () {
      expect(
        ageStateFor(currentYear - 18, currentYear: currentYear),
        AgeState.adult,
      );
    });

    test('genau 17 ist minderjährig', () {
      expect(
        ageStateFor(currentYear - 17, currentYear: currentYear),
        AgeState.minor,
      );
    });

    test('Kind von 10 ist minderjährig', () {
      expect(
        ageStateFor(currentYear - 10, currentYear: currentYear),
        AgeState.minor,
      );
    });

    test('unplausible Jahre zählen als keine Angabe', () {
      // Zukunft, Tippfehler, uralt → unknown, nicht etwa adult.
      expect(
        ageStateFor(currentYear + 1, currentYear: currentYear),
        AgeState.unknown,
      );
      expect(ageStateFor(0, currentYear: currentYear), AgeState.unknown);
      expect(
        ageStateFor(currentYear - 121, currentYear: currentYear),
        AgeState.unknown,
      );
    });

    test('wächst mit der Zeit von selbst in adult', () {
      const birth = 2010;
      expect(ageStateFor(birth, currentYear: 2027), AgeState.minor);
      expect(ageStateFor(birth, currentYear: 2028), AgeState.adult);
    });

    test('Plausibilitätsgrenzen', () {
      expect(isPlausibleBirthYear(currentYear, currentYear: currentYear),
          isTrue);
      expect(
        isPlausibleBirthYear(minPlausibleBirthYear(currentYear),
            currentYear: currentYear),
        isTrue,
      );
      expect(
        isPlausibleBirthYear(minPlausibleBirthYear(currentYear) - 1,
            currentYear: currentYear),
        isFalse,
      );
    });
  });

  group('Eltern-Rechenaufgabe', () {
    test('akzeptiert nur das richtige Ergebnis', () {
      const c = ParentGateChallenge(a: 17, b: 14);
      expect(c.answer, 238);
      expect(c.accepts('238'), isTrue);
      expect(c.accepts(' 238 '), isTrue);
      expect(c.accepts('237'), isFalse);
      expect(c.accepts(''), isFalse);
      expect(c.accepts('abc'), isFalse);
    });

    test('Zahlen liegen im vorgesehenen Bereich', () {
      final rng = math.Random(1);
      for (var i = 0; i < 200; i++) {
        final c = ParentGateChallenge.generate(rng);
        expect(c.a, inInclusiveRange(12, 19));
        expect(c.b, inInclusiveRange(13, 19));
      }
    });

    test('Aufgabe ist nicht bei jedem Öffnen dieselbe', () {
      final rng = math.Random(7);
      final seen = {
        for (var i = 0; i < 50; i++) ParentGateChallenge.generate(rng).answer,
      };
      expect(seen.length, greaterThan(5));
    });
  });

  group('Sperre nach Fehlversuchen', () {
    // Zeit wird hineingereicht, nie aus DateTime.now() gelesen — sonst wäre
    // der Ablauf der Sperre nicht prüfbar.
    const now = 1000000;

    test('sperrt 60 Sekunden ab dem letzten Fehlversuch', () {
      final until = ParentGateLockout.lockedUntilMsFrom(now);
      expect(until, now + 60000);
      expect(ParentGateLockout.isLocked(until, now), isTrue);
      expect(ParentGateLockout.remainingSeconds(until, now), 60);
    });

    test('läuft nach Ablauf der Zeit aus', () {
      final until = ParentGateLockout.lockedUntilMsFrom(now);
      expect(ParentGateLockout.isLocked(until, now + 59999), isTrue);
      expect(ParentGateLockout.isLocked(until, now + 60000), isFalse);
      expect(ParentGateLockout.remainingSeconds(until, now + 60000), 0);
    });

    test('Restzeit wird aufgerundet (29,5 s → 30 s)', () {
      final until = ParentGateLockout.lockedUntilMsFrom(now);
      expect(ParentGateLockout.remainingSeconds(until, now + 30500), 30);
    });

    test('ohne gesetzte Sperre ist nichts gesperrt', () {
      expect(ParentGateLockout.isLocked(0, now), isFalse);
    });

    test('drei Versuche sind erlaubt', () {
      expect(ParentGateLockout.maxAttempts, 3);
    });
  });
}
