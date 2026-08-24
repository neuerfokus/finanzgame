import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/highscore/highscore_entry.dart';
import 'package:finanzgame/features/highscore/highscore_repository.dart';
import 'package:finanzgame/features/highscore/net_worth.dart';

void main() {
  group('HighscoreEntry JSON', () {
    test('round-trips through fromJson/toJson', () {
      final e = HighscoreEntry(
        playerName: 'Max',
        startedAt: DateTime.utc(2020, 1, 1, 12),
        endedAt: DateTime.utc(2026, 5, 23, 18),
        finalNetWorthCents: 1234567890,
        finalAgeYears: 80,
        firstMillionaireAgeYears: 47,
        firstMillionaireDayIndex: 12410,
      );
      final json = e.toJson();
      final back = HighscoreEntry.fromJson(json);
      expect(back.playerName, 'Max');
      expect(back.finalNetWorthCents, 1234567890);
      expect(back.firstMillionaireAgeYears, 47);
      expect(back.firstMillionaireDayIndex, 12410);
      expect(back.startedAt, e.startedAt);
      expect(back.endedAt, e.endedAt);
    });

    test('handles null firstMillionaire fields', () {
      final e = HighscoreEntry(
        playerName: 'Lara',
        startedAt: DateTime.utc(2020, 1, 1),
        endedAt: DateTime.utc(2024, 6, 6),
        finalNetWorthCents: 500000,
        finalAgeYears: 80,
      );
      final back = HighscoreEntry.fromJson(e.toJson());
      expect(back.firstMillionaireAgeYears, isNull);
      expect(back.firstMillionaireDayIndex, isNull);
    });
  });

  group('HighscoreData', () {
    HighscoreEntry mk(String name, int cents) => HighscoreEntry(
          playerName: name,
          startedAt: DateTime.utc(2020),
          endedAt: DateTime.utc(2024),
          finalNetWorthCents: cents,
          finalAgeYears: 80,
        );

    test('round-trips through JSON', () {
      final data = HighscoreData(
        firstMillionaireDayIndex: 1000,
        entries: [mk('A', 100), mk('B', 200)],
      );
      final back = HighscoreData.fromJson(
          (data.toJson())..['noise'] = 'ignored');
      expect(back.firstMillionaireDayIndex, 1000);
      expect(back.entries, hasLength(2));
      expect(back.entries.first.playerName, 'A');
    });

    test('sorts descending after manual sort (repo invariant)', () {
      final entries = <HighscoreEntry>[
        mk('low', 100),
        mk('high', 9000),
        mk('mid', 500),
      ]..sort(
          (a, b) => b.finalNetWorthCents.compareTo(a.finalNetWorthCents),
        );
      expect(entries.map((e) => e.playerName).toList(),
          ['high', 'mid', 'low']);
    });
  });

  group('NetWorth.sum', () {
    test('additive over parts', () {
      expect(NetWorth.sum([100, 200, 300]), 600);
      expect(NetWorth.sum(const []), 0);
      expect(NetWorth.sum([-50, 100]), 50);
    });

    test('millionaireThresholdCents = 100_000_000 (1 Mio €)', () {
      expect(millionaireThresholdCents, 100000000);
    });
  });
}
