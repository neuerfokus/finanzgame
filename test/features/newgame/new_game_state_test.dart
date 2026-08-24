import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/newgame/legacy.dart';
import 'package:finanzgame/features/newgame/new_game_state.dart';

Future<void> _flush() async {
  for (var i = 0; i < 6; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('NewGameState Vermächtnis (Welle B)', () {
    test('recordEndOfRun vergibt LP + erhöht Generation', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)]);
      addTearDown(c.dispose);
      final repo = c.read(newGameStateProvider.notifier);
      await _flush();

      repo.recordEndOfRun(netWorthCents: 100000000, finalXp: 0); // Millionär
      final s = c.read(newGameStateProvider);
      expect(s.runCount, 1);
      expect(s.generation, 2);
      expect(s.legacyPoints, 12); // 10 + 2 Millionär
      expect(repo.availableLegacyPoints(), 12);
    });

    test('buyLegacyUpgrade respektiert Punkte + idempotent', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)]);
      addTearDown(c.dispose);
      final repo = c.read(newGameStateProvider.notifier);
      await _flush();
      repo.recordEndOfRun(netWorthCents: 10000000, finalXp: 0); // 1 LP

      expect(repo.availableLegacyPoints(), 1);
      // „Familienbeet" kostet 3 → zu teuer.
      expect(repo.buyLegacyUpgrade(LegacyEffects.plot), isFalse);
      // „Früher Funke" kostet 1 → geht.
      expect(repo.buyLegacyUpgrade(LegacyEffects.startXp), isTrue);
      expect(repo.availableLegacyPoints(), 0);
      // nochmal kaufen → false (schon besessen, kein Punktverlust).
      expect(repo.buyLegacyUpgrade(LegacyEffects.startXp), isFalse);
      expect(repo.availableLegacyPoints(), 0);
    });

    test('Großes Erbe hebt Erbschafts-Cap auf 3.000 €', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)]);
      addTearDown(c.dispose);
      final repo = c.read(newGameStateProvider.notifier);
      await _flush();
      // Genug LP für das Upgrade (Kosten 2) sammeln.
      repo.recordEndOfRun(netWorthCents: 100000000, finalXp: 0);
      expect(repo.buyLegacyUpgrade(LegacyEffects.inheritance), isTrue);

      // Run mit hohem Vermögen → Erbschaft bis 3.000 €, nicht 1.000 €.
      repo.recordEndOfRun(netWorthCents: 1000000000, finalXp: 0); // 10 Mio €
      final got = repo.consumePending();
      expect(got.inheritanceCents, 300000); // 3.000 €
    });

    test('round-trip: Legacy überlebt DB-Reopen', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)]);
      final r1 = c1.read(newGameStateProvider.notifier);
      await _flush();
      r1.recordEndOfRun(netWorthCents: 100000000, finalXp: 0); // 12 LP
      r1.buyLegacyUpgrade(LegacyEffects.plot); // -3
      await _flush();
      c1.dispose();

      final c2 = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)]);
      addTearDown(c2.dispose);
      c2.read(newGameStateProvider); // trigger build + hydrate
      await _flush();
      final s = c2.read(newGameStateProvider);
      expect(s.runCount, 1);
      expect(s.legacyPoints, 12);
      expect(s.legacyUpgrades, {LegacyEffects.plot});
      expect(s.legacyStartPlotCount, 1);
      expect(c2.read(newGameStateProvider.notifier).availableLegacyPoints(), 9);
    });
  });
}
