import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/life_goals/life_goals.dart';
import 'package:finanzgame/features/weekly_challenge/weekly_challenge.dart';

LifeGoalSnapshot _snap({int assetClassCount = 0, int streakDays = 0}) =>
    LifeGoalSnapshot(
      netWorthCents: 0,
      daysPlayed: 0,
      ageYears: 14,
      level: 1,
      assetClassCount: assetClassCount,
      streakDays: streakDays,
    );

/// Sammelt Belohnungen + persistierten Stand für die Assertions.
class _Sink {
  int xp = 0;
  int cents = 0;
  int? persistedWeek;
  int? persistedStreak;

  WeeklyClaimResult run({
    required int dayIndex,
    required LifeGoalSnapshot snap,
    required int claimedWeek,
    required int streak,
  }) =>
      applyWeeklyChallenge(
        snap: snap,
        dayIndex: dayIndex,
        claimedWeek: claimedWeek,
        streak: streak,
        addXp: (x) => xp += x,
        earnCents: (c) => cents += c,
        persist: ({required int claimedWeek, required int streak}) {
          persistedWeek = claimedWeek;
          persistedStreak = streak;
        },
      );
}

void main() {
  group('Wochen-Challenge (Round 28 v4)', () {
    test('Rotation: weekIndex + Challenge wechseln pro 7 Tage', () {
      expect(weekIndexFor(0), 0);
      expect(weekIndexFor(6), 0);
      expect(weekIndexFor(7), 1);
      // Rotiert zyklisch durch den Pool.
      expect(challengeForWeek(0).id, kWeeklyChallenges[0].id);
      expect(challengeForWeek(kWeeklyChallenges.length).id,
          kWeeklyChallenges[0].id);
    });

    test('alle Challenge-IDs eindeutig + Belohnung positiv', () {
      final ids = kWeeklyChallenges.map((c) => c.id).toSet();
      expect(ids.length, kWeeklyChallenges.length);
      for (final c in kWeeklyChallenges) {
        expect(c.xpReward, greaterThan(0));
        expect(c.cashCents, greaterThan(0));
        expect(c.progressLabel(_snap()).trim(), isNotEmpty);
      }
    });

    test('erfüllt + offen → eingelöst, Streak startet bei 1', () {
      // Woche 0 → wc_streak5 (braucht streak>=5). Snapshot erfüllt großzügig
      // alle Challenge-Typen (Streak + Diversifikation).
      final sink = _Sink();
      final r = sink.run(
        dayIndex: 0,
        snap: _snap(streakDays: 7, assetClassCount: 6),
        claimedWeek: -1,
        streak: 0,
      );
      expect(r.claimed, isTrue);
      expect(r.streak, 1);
      expect(sink.xp, greaterThan(0));
      // Cash = Challenge + Streak-Bonus (1×100).
      expect(sink.cents, challengeForWeek(0).cashCents + kWeeklyStreakBonusCents);
      expect(sink.persistedWeek, 0);
      expect(sink.persistedStreak, 1);
    });

    test('nicht erfüllt → kein Claim', () {
      final sink = _Sink();
      final r = sink.run(
        dayIndex: 0,
        snap: _snap(streakDays: 1),
        claimedWeek: -1,
        streak: 0,
      );
      expect(r.claimed, isFalse);
      expect(sink.xp, 0);
      expect(sink.persistedWeek, isNull);
    });

    test('diese Woche schon eingelöst → kein zweiter Claim', () {
      final sink = _Sink();
      final r = sink.run(
        dayIndex: 3, // Woche 0
        snap: _snap(streakDays: 7),
        claimedWeek: 0, // schon eingelöst
        streak: 1,
      );
      expect(r.claimed, isFalse);
      expect(sink.cents, 0);
    });

    test('aufeinanderfolgende Wochen → Streak +1; Lücke → Reset auf 1', () {
      // Vorwoche (Woche 0) war eingelöst, jetzt Woche 1 → Streak 2.
      final consec = _Sink();
      final r1 = consec.run(
        dayIndex: 7, // Woche 1
        snap: _snap(streakDays: 7, assetClassCount: 6),
        claimedWeek: 0,
        streak: 1,
      );
      expect(r1.claimed, isTrue);
      expect(r1.streak, 2);

      // Lücke: zuletzt Woche 0 eingelöst, jetzt Woche 3 → Reset auf 1.
      final gap = _Sink();
      final r2 = gap.run(
        dayIndex: 21, // Woche 3
        snap: _snap(streakDays: 7, assetClassCount: 6),
        claimedWeek: 0,
        streak: 5,
      );
      expect(r2.claimed, isTrue);
      expect(r2.streak, 1);
    });
  });
}
