import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/life_goals/life_goals.dart';

LifeGoalSnapshot _snap({
  int netWorthCents = 0,
  int daysPlayed = 0,
  int ageYears = 14,
  int level = 1,
  int assetClassCount = 0,
  int streakDays = 0,
}) =>
    LifeGoalSnapshot(
      netWorthCents: netWorthCents,
      daysPlayed: daysPlayed,
      ageYears: ageYears,
      level: level,
      assetClassCount: assetClassCount,
      streakDays: streakDays,
    );

void main() {
  group('Lebensziele (Round 28 v4)', () {
    test('leerer Snapshot → kein Ziel erreicht', () {
      expect(evaluateLifeGoals(_snap()), isEmpty);
    });

    test('alle IDs eindeutig + lifeGoalById findet sie', () {
      final ids = kLifeGoals.map((g) => g.id).toSet();
      expect(ids.length, kLifeGoals.length);
      for (final g in kLifeGoals) {
        expect(lifeGoalById(g.id), same(g));
      }
      expect(lifeGoalById('gibts_nicht'), isNull);
    });

    test('Lebensziel-IDs kollidieren NICHT mit Achievement-Konventionen', () {
      // Eigene life_-Präfix-Konvention (liegen NICHT in kAchievements).
      for (final g in kLifeGoals) {
        expect(g.id.startsWith('life_'), isTrue, reason: g.id);
      }
    });

    test('Schwellen: Diversifikation/Dekade/Streak/FIRE/Million', () {
      expect(evaluateLifeGoals(_snap(assetClassCount: 6)),
          contains('life_diversified'));
      expect(evaluateLifeGoals(_snap(assetClassCount: 5)),
          isNot(contains('life_diversified')));

      expect(evaluateLifeGoals(_snap(daysPlayed: 3650)),
          contains('life_decade'));
      expect(evaluateLifeGoals(_snap(streakDays: 100)),
          contains('life_streak_100'));

      expect(evaluateLifeGoals(_snap(netWorthCents: 50000000)),
          contains('life_fire'));
      expect(evaluateLifeGoals(_snap(netWorthCents: 100000000)),
          contains('life_million'));
    });

    test('Früh-Rentner braucht Vermögen UND Alter ≤ 40', () {
      expect(
        evaluateLifeGoals(_snap(netWorthCents: 25000000, ageYears: 40)),
        contains('life_early_retire'),
      );
      // Zu alt → nicht erreicht.
      expect(
        evaluateLifeGoals(_snap(netWorthCents: 25000000, ageYears: 41)),
        isNot(contains('life_early_retire')),
      );
      // Jung genug, aber zu wenig Vermögen → nicht erreicht.
      expect(
        evaluateLifeGoals(_snap(netWorthCents: 24999999, ageYears: 30)),
        isNot(contains('life_early_retire')),
      );
    });

    test('applyLifeGoals schreibt erfüllte Ziele genau EINMAL gut', () {
      final claimed = <String>{};
      var xp = 0;
      var cash = 0;
      bool unlock(String id, int day) => claimed.add(id); // true wenn neu
      // Snapshot erfüllt mehrere Ziele gleichzeitig.
      final snap = _snap(
        netWorthCents: 100000000,
        daysPlayed: 3650,
        streakDays: 100,
        assetClassCount: 6,
        ageYears: 30,
      );
      final first = applyLifeGoals(
        snap: snap,
        dayIndex: 1,
        unlock: unlock,
        addXp: (x) => xp += x,
        earnCents: (c) => cash += c,
      );
      expect(first, isNotEmpty);
      expect(xp, greaterThan(0));
      expect(cash, greaterThan(0));
      final xpAfterFirst = xp;
      final cashAfterFirst = cash;

      // Zweiter Aufruf mit gleichem Snapshot → nichts Neues (idempotent).
      final second = applyLifeGoals(
        snap: snap,
        dayIndex: 2,
        unlock: unlock,
        addXp: (x) => xp += x,
        earnCents: (c) => cash += c,
      );
      expect(second, isEmpty);
      expect(xp, xpAfterFirst);
      expect(cash, cashAfterFirst);
    });

    test('isUnreachable: nur Früh-Rentner verfällt (Alter > 40)', () {
      final earlyRetire = lifeGoalById('life_early_retire')!;
      // ≤ 40 + noch nicht erreicht → erreichbar (nicht ausgegraut).
      expect(earlyRetire.isUnreachable(_snap(ageYears: 40)), isFalse);
      // > 40 + nicht erreicht → dauerhaft verpasst.
      expect(earlyRetire.isUnreachable(_snap(ageYears: 41)), isTrue);
      // ≤ 40 + genug Vermögen → met() greift, also nicht verpasst.
      expect(
        earlyRetire.isUnreachable(_snap(netWorthCents: 25000000, ageYears: 40)),
        isFalse,
      );
      // > 40 + Vermögen, aber nie rechtzeitig erreicht → met()=false (Alter),
      // also dauerhaft verpasst. (Der „schon gutgeschrieben"-Schutz läuft in
      // der Page über `claimed`, nicht über isUnreachable.)
      expect(
        earlyRetire.isUnreachable(_snap(netWorthCents: 25000000, ageYears: 41)),
        isTrue,
      );
      // Alle cumulative Ziele sind nie unerreichbar, egal wie alt.
      for (final g in kLifeGoals.where((g) => g.id != 'life_early_retire')) {
        expect(g.isUnreachable(_snap(ageYears: 79)), isFalse, reason: g.id);
      }
    });

    test('jedes Ziel hat Belohnung + nicht-leere Texte', () {
      for (final g in kLifeGoals) {
        expect(g.xpReward, greaterThan(0), reason: g.id);
        expect(g.cashCents, greaterThan(0), reason: g.id);
        expect(g.title.trim(), isNotEmpty);
        expect(g.description.trim(), isNotEmpty);
        expect(g.progressLabel(_snap()).trim(), isNotEmpty);
      }
    });
  });
}
