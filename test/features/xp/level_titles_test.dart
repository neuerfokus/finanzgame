import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/xp/level_titles.dart';

void main() {
  group('LevelSystem (v29: 60 levels, 10er-titles)', () {
    test('xpForLevel monotonic and bounded', () {
      expect(LevelSystem.xpForLevel(0), 0);
      expect(LevelSystem.xpForLevel(1), 100);
      // exponent 1.6 → grobe Sanity (nicht hartkodiert pro Stufe).
      expect(LevelSystem.xpForLevel(10),
          greaterThan(LevelSystem.xpForLevel(5)));
      expect(LevelSystem.maxLevel, 60);
      expect(
        LevelSystem.xpForLevel(LevelSystem.maxLevel + 5),
        LevelSystem.xpForLevel(LevelSystem.maxLevel),
      );
    });

    test('levelFor + xpToNext are inverses', () {
      for (final xp in [0, 50, 100, 500, 1500, 5000, 20000]) {
        final lvl = LevelSystem.levelFor(xp);
        if (lvl < LevelSystem.maxLevel) {
          expect(xp + LevelSystem.xpToNext(xp),
              LevelSystem.xpForLevel(lvl + 1));
        }
      }
    });

    test('titles only on 10er-stages, lower levels keep last title', () {
      expect(LevelSystem.titleFor(0), 'Neuling');
      expect(LevelSystem.titleFor(1), 'Erste Schritte');
      expect(LevelSystem.titleFor(5), 'Erste Schritte');
      expect(LevelSystem.titleFor(9), 'Erste Schritte');
      expect(LevelSystem.titleFor(10), 'Cleveres Investieren');
      expect(LevelSystem.titleFor(20), 'Markt-Strategie');
      expect(LevelSystem.titleFor(30), 'Börsen-Erfahrung');
      expect(LevelSystem.titleFor(40), 'Geld-Meisterschaft');
      expect(LevelSystem.titleFor(60), 'Finanz-Legende');
    });

    test('kein Titel spricht die Person geschlechtsspezifisch an', () {
      // Der Titel wird direkt zugesprochen („Du bist jetzt …"). Generische
      // Maskulina sagen einem Mädchen dabei jedes zehnte Level, dass
      // eigentlich jemand anderes gemeint ist.
      const gendered = [
        'Investor',
        'Stratege',
        'Architekt',
        'Profi',
        'Lehrling',
        'Meister',
        'Experte',
        'Anleger',
        'Sparer',
      ];
      // Wortgrenzen, nicht Teilstrings: „Meisterschaft" und „Profiwissen"
      // benennen eine Fähigkeit und sind neutral — „Meister" und „Profi"
      // allein bezeichnen die Person.
      for (var lvl = 0; lvl <= LevelSystem.maxLevel; lvl++) {
        final title = LevelSystem.titleFor(lvl);
        for (final word in gendered) {
          expect(
            RegExp('\\b$word\\b').hasMatch(title),
            isFalse,
            reason: 'Level $lvl heißt „$title" und enthält „$word".',
          );
        }
      }
    });

    test('renditeMultiplier capped at +18 %', () {
      expect(LevelSystem.renditeMultiplier(0), 1.0);
      expect(LevelSystem.renditeMultiplier(10), closeTo(1.03, 1e-9));
      expect(LevelSystem.renditeMultiplier(60), closeTo(1.18, 1e-9));
      expect(LevelSystem.renditeMultiplier(100), closeTo(1.18, 1e-9));
    });

    test('Round 28 v4: Meister-Level ★ unbegrenzt ab Level 60', () {
      final base = LevelSystem.xpForLevel(LevelSystem.maxLevel);
      expect(LevelSystem.meisterLevelFor(0), 0);
      expect(LevelSystem.meisterLevelFor(base), 0);
      expect(LevelSystem.meisterLevelFor(base + LevelSystem.meisterXpPerLevel),
          1);
      expect(
        LevelSystem.meisterLevelFor(base + 10 * LevelSystem.meisterXpPerLevel),
        10,
      );
      // xpToNextMeister immer in (0, meisterXpPerLevel].
      expect(LevelSystem.xpToNextMeister(base),
          LevelSystem.meisterXpPerLevel);
      expect(LevelSystem.xpToNextMeister(base + 1),
          LevelSystem.meisterXpPerLevel - 1);
    });
  });
}
