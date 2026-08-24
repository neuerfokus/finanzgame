import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/sleep/streak_milestones.dart';

/// Sammelt die Effekte der reinen Funktion für die Assertions.
class _Sink {
  final unlocked = <String>[];
  int xp = 0;
  int cents = 0;
  int? persisted;

  StreakMilestoneResult run({required int streak, required int claimed}) =>
      applyStreakMilestones(
        streakCount: streak,
        alreadyClaimed: claimed,
        dayIndex: 5,
        unlock: (id, _) {
          unlocked.add(id);
          return true;
        },
        addXp: (x) => xp += x,
        earnCents: (c) => cents += c,
        persistClaimed: (m) => persisted = m,
      );
}

void main() {
  group('Streak-Meilensteine (Optionen-Backlog #2)', () {
    test('Tiers aufsteigend, eindeutig, Belohnung positiv', () {
      final days = kStreakMilestones.map((m) => m.days).toList();
      expect(days, [7, 14, 30, 100]);
      expect(days.toSet().length, days.length);
      for (final m in kStreakMilestones) {
        expect(m.xp, greaterThan(0));
        expect(m.cashCents, greaterThan(0));
        expect(m.badgeId, startsWith('streak_'));
      }
    });

    test('Erst-Klettern 0→7 zahlt nur die 7er-Schwelle', () {
      final s = _Sink();
      final r = s.run(streak: 7, claimed: 0);
      expect(r.granted.map((m) => m.days), [7]);
      expect(s.cents, 500);
      expect(s.xp, 30);
      expect(s.unlocked, ['streak_7']);
      expect(s.persisted, 7);
      expect(r.newClaimed, 7);
    });

    test('Zwischen-Tag (streak 10, schon 7 geclaimt) zahlt nichts', () {
      final s = _Sink();
      final r = s.run(streak: 10, claimed: 7);
      expect(r.hasReward, isFalse);
      expect(s.cents, 0);
      expect(s.persisted, isNull);
    });

    test('Re-Klettern nach Reset zahlt NICHT erneut (Anti-Farm)', () {
      // Streak war auf 30 (claimed=30), gebrochen, jetzt wieder bei 7.
      final s = _Sink();
      final r = s.run(streak: 7, claimed: 30);
      expect(r.hasReward, isFalse);
      expect(s.cents, 0);
      expect(s.unlocked, isEmpty);
    });

    test('großer Sprung 0→100 zahlt alle 4 Schwellen genau einmal', () {
      final s = _Sink();
      final r = s.run(streak: 100, claimed: 0);
      expect(r.granted.map((m) => m.days), [7, 14, 30, 100]);
      expect(s.unlocked, ['streak_7', 'streak_14', 'streak_30', 'streak_100']);
      expect(s.cents, 500 + 1000 + 2500 + 8000);
      expect(s.xp, 30 + 60 + 150 + 500);
      expect(s.persisted, 100);
    });

    test('idempotent: zweiter Aufruf mit gleichem Stand zahlt nicht', () {
      final s = _Sink();
      s.run(streak: 14, claimed: 0); // zahlt 7 + 14
      final before = s.cents;
      final r2 = s.run(streak: 14, claimed: 14); // nun alreadyClaimed=14
      expect(r2.hasReward, isFalse);
      expect(s.cents, before);
    });
  });
}
