import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/newgame/legacy.dart';
import 'package:finanzgame/features/xp/level_titles.dart';

void main() {
  group('Legacy-Punkte-Formel (Welle B)', () {
    test('1 LP je 100.000 € Netto-Vermögen', () {
      // 250.000 € = 25.000.000 ¢ → 2 LP (Level 0).
      expect(
        legacyPointsForRun(netWorthCents: 25000000, finalXp: 0),
        2,
      );
    });

    test('Millionär gibt +2 Bonus', () {
      // 1.000.000 € = 100.000.000 ¢ → 10 + 2 = 12 (Level 0).
      expect(
        legacyPointsForRun(netWorthCents: 100000000, finalXp: 0),
        12,
      );
    });

    test('Level gibt 1 LP je 10 Stufen', () {
      // Vermögen 0 → mind. 1, plus Level-Anteil.
      final xpForLevel30 = LevelSystem.xpForLevel(30);
      expect(
        legacyPointsForRun(netWorthCents: 0, finalXp: xpForLevel30),
        3, // 30 / 10
      );
    });

    test('Run-Abschluss bringt immer mindestens 1', () {
      expect(legacyPointsForRun(netWorthCents: 0, finalXp: 0), 1);
      expect(legacyPointsForRun(netWorthCents: -5000, finalXp: 0), 1);
    });

    test('gedeckelt bei 20', () {
      expect(
        legacyPointsForRun(netWorthCents: 999999999999, finalXp: 999999),
        20,
      );
    });
  });

  group('Vermächtnis-Effekte', () {
    test('Erbschafts-Cap 1.000 € normal, 3.000 € mit Upgrade', () {
      expect(legacyInheritanceCapCents({}), 100000);
      expect(
        legacyInheritanceCapCents({LegacyEffects.inheritance}),
        300000,
      );
    });

    test('Start-Cash / Start-XP / Beet nur mit jeweiligem Upgrade', () {
      expect(legacyStartCashCents({}), 0);
      expect(legacyStartCashCents({LegacyEffects.startCash}), 10000);
      expect(legacyStartXp({}), 0);
      expect(legacyStartXp({LegacyEffects.startXp}), 250);
      expect(legacyStartPlots({}), 0);
      expect(legacyStartPlots({LegacyEffects.plot}), 1);
    });

    test('legacySpentPoints summiert Upgrade-Kosten', () {
      final owned = {LegacyEffects.startXp, LegacyEffects.plot}; // 1 + 3
      expect(legacySpentPoints(owned), 4);
    });

    test('Katalog: IDs eindeutig + Kosten positiv + Lookup', () {
      final ids = kLegacyUpgrades.map((u) => u.id).toSet();
      expect(ids.length, kLegacyUpgrades.length);
      for (final u in kLegacyUpgrades) {
        expect(u.cost, greaterThan(0));
        expect(u.description.trim(), isNotEmpty);
        expect(legacyUpgradeById(u.id), same(u));
      }
      expect(legacyUpgradeById('does_not_exist'), isNull);
    });
  });
}
