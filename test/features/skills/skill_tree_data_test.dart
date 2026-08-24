import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/skills/skill_tree_data.dart';

void main() {
  group('Skill-Baum Daten (Round 28)', () {
    test('12 Knoten, 3 Zweige × 4 Stufen', () {
      expect(kSkillNodes.length, 12);
      for (final b in SkillBranch.values) {
        final nodes = skillsForBranch(b);
        expect(nodes.length, 4, reason: b.label);
        expect(nodes.map((n) => n.tier).toList(), [1, 2, 3, 4]);
      }
    });

    test('alle IDs eindeutig', () {
      final ids = kSkillNodes.map((n) => n.id).toSet();
      expect(ids.length, kSkillNodes.length);
    });

    test('Effekt-Skill-IDs existieren + tragen einen Effekt', () {
      final byId = {for (final n in kSkillNodes) n.id: n};
      for (final eid in [
        SkillEffects.paySliderHighCap,
        SkillEffects.bonusPlot,
        SkillEffects.panicGuardAlways,
        SkillEffects.weeklyReport,
      ]) {
        expect(byId.containsKey(eid), isTrue, reason: eid);
        expect(byId[eid]!.hasEffect, isTrue, reason: eid);
      }
    });

    test('Tier-Gate: Tier 1 offen, Tier 2 erst nach Tier 1', () {
      final spar = skillsForBranch(SkillBranch.spar);
      final t1 = spar[0];
      final t2 = spar[1];
      expect(isNodeUnlockable(t1, <String>{}), isTrue);
      expect(isNodeUnlockable(t2, <String>{}), isFalse);
      expect(isNodeUnlockable(t2, {t1.id}), isTrue);
      // Bereits freigeschaltet → nicht erneut wählbar.
      expect(isNodeUnlockable(t1, {t1.id}), isFalse);
    });

    test('predecessorOf: Tier 1 null, sonst eine Stufe tiefer im Zweig', () {
      for (final b in SkillBranch.values) {
        final nodes = skillsForBranch(b);
        expect(predecessorOf(nodes[0]), isNull);
        expect(predecessorOf(nodes[3])!.id, nodes[2].id);
      }
    });

    test('jeder Knoten hat eine Lern-Botschaft', () {
      for (final n in kSkillNodes) {
        expect(n.lern.trim(), isNotEmpty, reason: n.id);
      }
    });

    test('branchComplete + treeComplete (Round 28 v2)', () {
      final allSpar =
          skillsForBranch(SkillBranch.spar).map((n) => n.id).toSet();
      expect(branchComplete(SkillBranch.spar, allSpar), isTrue);
      expect(branchComplete(SkillBranch.spar, <String>{}), isFalse);
      final all = kSkillNodes.map((n) => n.id).toSet();
      expect(treeComplete(all), isTrue);
      expect(treeComplete(allSpar), isFalse);
    });

    test('redeemedCount zählt nur redeem_*-IDs', () {
      expect(redeemedCount({'spar_routine', 'redeem_0', 'redeem_1'}), 2);
      expect(redeemedCount({'spar_routine'}), 0);
    });

    test('branchTrophyId folgt skilltree_<name>', () {
      expect(branchTrophyId(SkillBranch.spar), 'skilltree_spar');
      expect(branchTrophyId(SkillBranch.invest), 'skilltree_invest');
      expect(branchTrophyId(SkillBranch.schutz), 'skilltree_schutz');
    });
  });

  group('Prestige-Knoten (Round 28 v4)', () {
    test('3 Prestige-Knoten, je 1 pro Zweig, Tier 5, Kosten > 1', () {
      expect(kPrestigeNodes.length, 3);
      for (final b in SkillBranch.values) {
        final n = prestigeForBranch(b);
        expect(n, isNotNull, reason: b.label);
        expect(n!.tier, 5);
        expect(n.isPrestige, isTrue);
        expect(n.cost, prestigeCost);
        expect(n.cost, greaterThan(1));
      }
    });

    test('Kern-Baum bleibt 12 Knoten (Prestige separat)', () {
      expect(kSkillNodes.length, 12);
      expect(kSkillNodes.any((n) => n.isPrestige), isFalse);
      expect(allSkillNodes.length, 15);
    });

    test('skillCost: Kern 1, Prestige prestigeCost, redeem 1, unbekannt 1', () {
      expect(skillCost('spar_notgroschen'), 1);
      expect(skillCost(SkillEffects.bonusPlot2), prestigeCost);
      expect(skillCost('redeem_0'), 1);
      expect(skillCost('gibts_nicht'), 1);
    });

    test('spentSkillPoints summiert Kosten (Prestige zählt mehrfach)', () {
      final unlocked = {'spar_notgroschen', SkillEffects.bonusPlot2, 'redeem_0'};
      expect(spentSkillPoints(unlocked), 1 + prestigeCost + 1);
    });

    test('Prestige erst wählbar wenn Kern-Zweig komplett', () {
      final prestige = prestigeForBranch(SkillBranch.spar)!;
      final sparCore =
          skillsForBranch(SkillBranch.spar).map((n) => n.id).toSet();
      expect(isPrestigeUnlockable(prestige, <String>{}), isFalse);
      expect(isPrestigeUnlockable(prestige, sparCore), isTrue);
      // Schon freigeschaltet → nicht erneut.
      expect(
        isPrestigeUnlockable(prestige, {...sparCore, prestige.id}),
        isFalse,
      );
    });

    test('everythingComplete erst mit Kern + allen Prestige-Knoten', () {
      final core = kSkillNodes.map((n) => n.id).toSet();
      expect(treeComplete(core), isTrue);
      expect(everythingComplete(core), isFalse);
      final all = allSkillNodes.map((n) => n.id).toSet();
      expect(prestigeComplete(all), isTrue);
      expect(everythingComplete(all), isTrue);
    });

    test('redeemPointValueCents skaliert mit Level + Vermögen, Floor 5 €', () {
      // Niedrig → Floor.
      expect(
        SkillRewards.redeemPointValueCents(level: 1, netWorthCents: 0),
        SkillRewards.redeemCentsPerPoint,
      );
      // Endgame deutlich mehr als die alten fixen 5 €.
      final rich = SkillRewards.redeemPointValueCents(
        level: 30,
        netWorthCents: 5000000, // 50.000 €
      );
      expect(rich, 30 * 200 + 5000000 ~/ 1000); // 6000 + 5000 = 11000¢
      expect(rich, greaterThan(SkillRewards.redeemCentsPerPoint));
      // Review-Fix: Deckel greift bei extremem Horten (Millionär+).
      final hoarder = SkillRewards.redeemPointValueCents(
        level: 60,
        netWorthCents: 1000000000, // 10 Mio €
      );
      expect(hoarder, SkillRewards.redeemCentsPerPointCap);
    });
  });
}
