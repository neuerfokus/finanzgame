import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/daily_quiz/quiz_topics.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_unlocker.dart';

/// Welle-8 Hybrid C: Unlocker = XP-Schwelle + erforderliche Quest-Topic.
/// Mischwald als einzige Ausnahme nur XP.
Set<String> _run({int xp = 0, Set<String> topics = const {}}) =>
    MonetariaUnlocker.compute(
      cashCents: 0,
      harvestTotalCents: 0,
      dayIndex: 0,
      etfMarketValueCents: 0,
      stockShares: 0,
      xp: xp,
      learnedTopics: topics,
    );

void main() {
  group('MonetariaUnlocker (Hybrid XP + Topic)', () {
    test('zero progress → nur heimathafen + spar_insel', () {
      expect(_run(), {IslandId.heimathafen, IslandId.sparInsel});
    });

    test('XP allein ohne Topic reicht nicht (etf)', () {
      expect(_run(xp: 10000), isNot(contains(IslandId.etfInsel)));
    });

    test('Topic allein ohne XP reicht nicht (etf)', () {
      expect(
        _run(xp: 0, topics: {QuizTopic.etf}),
        isNot(contains(IslandId.etfInsel)),
      );
    });

    test('XP + Topic = etf-insel open', () {
      expect(
        _run(xp: MonetariaUnlocker.etfInselXp, topics: {QuizTopic.etf}),
        contains(IslandId.etfInsel),
      );
    });

    test('inflation_atoll braucht inflation-Topic', () {
      expect(
        _run(
          xp: MonetariaUnlocker.inflationAtollXp,
          topics: {QuizTopic.inflation},
        ),
        contains(IslandId.inflationAtoll),
      );
      expect(
        _run(
          xp: MonetariaUnlocker.inflationAtollXp,
          topics: {QuizTopic.etf},
        ),
        isNot(contains(IslandId.inflationAtoll)),
      );
    });

    test('goldmine braucht edelmetalle-Topic', () {
      expect(
        _run(
          xp: MonetariaUnlocker.goldmineXp,
          topics: {QuizTopic.edelmetalle},
        ),
        contains(IslandId.goldmine),
      );
    });

    test('aktien_archipel braucht aktien-Topic', () {
      expect(
        _run(
          xp: MonetariaUnlocker.aktienArchipelXp,
          topics: {QuizTopic.aktien},
        ),
        contains(IslandId.aktienArchipel),
      );
    });

    test('vulkan akzeptiert krypto ODER bitcoin', () {
      expect(
        _run(xp: MonetariaUnlocker.vulkanXp, topics: {QuizTopic.krypto}),
        contains(IslandId.vulkan),
      );
      expect(
        _run(xp: MonetariaUnlocker.vulkanXp, topics: {QuizTopic.bitcoin}),
        contains(IslandId.vulkan),
      );
    });

    test('wohnviertel braucht immobilie-Topic', () {
      expect(
        _run(
          xp: MonetariaUnlocker.wohnviertelXp,
          topics: {QuizTopic.immobilie},
        ),
        contains(IslandId.wohnviertel),
      );
    });

    test('mischwald rein XP, keine Topic-Anforderung', () {
      expect(
        _run(xp: MonetariaUnlocker.mischwaldXp - 1),
        isNot(contains(IslandId.mischwald)),
      );
      expect(
        _run(xp: MonetariaUnlocker.mischwaldXp),
        contains(IslandId.mischwald),
      );
    });

    test('hohe XP + alle Topics → alle Inseln', () {
      expect(
        _run(xp: 10000, topics: {
          QuizTopic.etf,
          QuizTopic.inflation,
          QuizTopic.edelmetalle,
          QuizTopic.aktien,
          QuizTopic.krypto,
          QuizTopic.immobilie,
        }),
        {
          IslandId.heimathafen,
          IslandId.sparInsel,
          IslandId.etfInsel,
          IslandId.inflationAtoll,
          IslandId.goldmine,
          IslandId.aktienArchipel,
          IslandId.vulkan,
          IslandId.wohnviertel,
          IslandId.mischwald,
        },
      );
    });

    test('Schwellen aufsteigend sortiert', () {
      final thresholds = [
        MonetariaUnlocker.etfInselXp,
        MonetariaUnlocker.inflationAtollXp,
        MonetariaUnlocker.goldmineXp,
        MonetariaUnlocker.aktienArchipelXp,
        MonetariaUnlocker.vulkanXp,
        MonetariaUnlocker.wohnviertelXp,
        MonetariaUnlocker.mischwaldXp,
      ];
      for (var i = 1; i < thresholds.length; i++) {
        expect(thresholds[i], greaterThan(thresholds[i - 1]));
      }
    });
  });
}
