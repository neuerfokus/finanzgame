import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/confetti.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../highscore/net_worth.dart';
import '../settings/settings_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import '../zimmer/achievements_repository.dart';
import 'skill_tree_data.dart';

/// Round 28: Skill-Baum-Seite. 3 Zweige mit je 4 Stufen + 1 Prestige-Knoten.
/// Pro Level 1 Skill-Punkt. Knoten schalten Mechaniken/Wissen frei (kein
/// Rendite-Boost). Erreichbar über das Level-Feld im Zimmer.
class SkillTreePage extends ConsumerWidget {
  const SkillTreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpRepositoryProvider);
    // Auf Settings-State hören, damit die Seite nach dem Freischalten neu
    // baut (Punkte-Zähler + Knoten-Status aktualisieren).
    ref.watch(settingsRepositoryProvider);
    final repo = ref.read(settingsRepositoryProvider.notifier);
    final level = LevelSystem.levelFor(xp);
    final unlocked = repo.unlockedSkills();
    final free = repo.availableSkillPoints();

    return PhoneFrame(
      appName: 'Fähigkeiten',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          _PointsHeader(level: level, free: free),
          // Round 28 v2/v4: Punkte-Senke — sobald ALLES (inkl. Prestige)
          // freigeschaltet ist, übrige Punkte in Taschengeld einlösen.
          if (free > 0 && everythingComplete(unlocked)) ...[
            const SizedBox(height: FgSpacing.s),
            _RedeemPanel(
              points: free,
              valuePerPoint: _redeemValue(ref, free),
              onRedeemAll: () => _redeem(context, ref, free),
            ),
          ],
          const SizedBox(height: FgSpacing.m),
          for (final branch in SkillBranch.values) ...[
            _BranchPanel(
              branch: branch,
              unlocked: unlocked,
              pointsFree: free,
              onTapNode: (node) => _onTapNode(context, ref, node),
            ),
            const SizedBox(height: FgSpacing.m),
          ],
        ],
      ),
    );
  }

  int _redeemValue(WidgetRef ref, int free) {
    final level = LevelSystem.levelFor(ref.read(xpRepositoryProvider));
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final netWorth = ref.read(netWorthProvider(dayIndex));
    return SkillRewards.redeemPointValueCents(
      level: level,
      netWorthCents: netWorth,
    );
  }

  /// Round 28 v2/v4: alle übrigen Punkte auf einmal einlösen → Cash.
  void _redeem(BuildContext context, WidgetRef ref, int points) {
    final repo = ref.read(settingsRepositoryProvider.notifier);
    final perPoint = _redeemValue(ref, points);
    var redeemed = 0;
    while (repo.redeemSkillPoint()) {
      redeemed++;
    }
    if (redeemed == 0) return;
    final cents = redeemed * perPoint;
    ref.read(cashStateProvider.notifier).earn(Money.cents(cents));
    _burst(context);
    showFgSnack(
      context,
      '🎓 $redeemed Punkt${redeemed == 1 ? '' : 'e'} eingelöst — '
      '+${cents ~/ 100} € Taschengeld!',
      duration: const Duration(seconds: 3),
    );
  }

  void _burst(BuildContext context) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;
    late OverlayEntry entry;
    entry = OverlayEntry(
        builder: (_) => const IgnorePointer(child: ConfettiBurst()));
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), entry.remove);
  }

  void _onTapNode(BuildContext context, WidgetRef ref, SkillNode node) {
    final settings = ref.read(settingsRepositoryProvider.notifier);
    final unlocked = settings.unlockedSkills();
    final free = settings.availableSkillPoints();

    // 1) Schon freigeschaltet → zeigen, was der Knoten bringt (User-Wunsch).
    if (unlocked.contains(node.id)) {
      _showInfo(context, node, owned: true);
      return;
    }

    // 2) Noch nicht wählbar (Vorgänger/Zweig fehlt) → Hinweis.
    final unlockable = node.isPrestige
        ? isPrestigeUnlockable(node, unlocked)
        : isNodeUnlockable(node, unlocked);
    if (!unlockable) {
      _showLockedHint(context, node);
      return;
    }

    // 3) Wählbar, aber zu wenig Punkte → Hinweis.
    if (free < node.cost) {
      showFgSnack(
        context,
        'Dafür brauchst du ${node.cost} Punkt${node.cost == 1 ? '' : 'e'} '
        '— du hast $free. Spiel weiter für mehr Level!',
        isError: true,
      );
      return;
    }

    // 4) Freischalten.
    if (!settings.unlockSkill(node.id)) return;
    final completionMsg = node.isPrestige
        ? _grantPrestigeRewards(ref, node)
        : _grantCompletionRewards(ref, node);
    _burst(context);
    _showUnlockDialog(context, node, completionMsg);
  }

  /// Info-Dialog für einen bereits freigeschalteten Knoten: erklärt, was er
  /// bringt (Mechanik-Effekt) bzw. welches Wissen dahinter steckt.
  void _showInfo(BuildContext context, SkillNode node, {required bool owned}) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text('${node.emoji}  ${node.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (owned)
              const Text('✅ Freigeschaltet', style: FgTypography.bodyS),
            const SizedBox(height: FgSpacing.xs),
            Text(node.lern, style: FgTypography.bodyM),
            const SizedBox(height: FgSpacing.m),
            Container(
              padding: const EdgeInsets.all(FgSpacing.s),
              color: (node.hasEffect ? FgColors.success : FgColors.primary)
                  .withValues(alpha: 0.2),
              child: Text(
                node.hasEffect
                    ? '🎁 Das bringt dir: ${node.effect}'
                    : '🧠 Reiner Wissens-Knoten — kein Spiel-Bonus, aber '
                        'wichtig fürs echte Geld-Leben.',
                style: FgTypography.bodyM.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showLockedHint(BuildContext context, SkillNode node) {
    final String why;
    if (node.isPrestige) {
      why = 'Meister-Knoten: erst den ganzen ${node.branch.label}-Zweig '
          '(alle 4 Stufen) freischalten. Dann kostet er ${node.cost} Punkte.';
    } else {
      final pred = predecessorOf(node);
      why = pred == null
          ? 'Noch nicht wählbar.'
          : 'Erst „${pred.title}" in diesem Zweig freischalten.';
    }
    _showInfoText(context, node, why);
  }

  void _showInfoText(BuildContext context, SkillNode node, String body) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text('🔒 ${node.title}'),
        content: Text(body, style: FgTypography.bodyM),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Alles klar'),
          ),
        ],
      ),
    );
  }

  void _showUnlockDialog(
    BuildContext context,
    SkillNode node,
    String? completionMsg,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text('${node.emoji}  ${node.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.lern, style: FgTypography.bodyM),
            if (node.hasEffect) ...[
              const SizedBox(height: FgSpacing.m),
              Container(
                padding: const EdgeInsets.all(FgSpacing.s),
                color: FgColors.success.withValues(alpha: 0.2),
                child: Text('✅ ${node.effect}',
                    style: FgTypography.bodyM
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
            if (completionMsg != null) ...[
              const SizedBox(height: FgSpacing.m),
              Container(
                padding: const EdgeInsets.all(FgSpacing.s),
                color: FgColors.primary.withValues(alpha: 0.25),
                child: Text(completionMsg,
                    style: FgTypography.bodyM
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Super!'),
          ),
        ],
      ),
    );
  }

  /// Round 28 v2: prüft ob mit [node] ein Zweig oder der ganze Kern-Baum
  /// fertig wurde → einmalig Trophäe + XP + Cash.
  String? _grantCompletionRewards(WidgetRef ref, SkillNode node) {
    final settings = ref.read(settingsRepositoryProvider.notifier);
    final unlocked = settings.unlockedSkills();
    final ach = ref.read(achievementsRepositoryProvider.notifier);
    final dayIdx = ref.read(gameClockProvider).dayIndex;
    String? msg;
    if (branchComplete(node.branch, unlocked) &&
        ach.unlock(branchTrophyId(node.branch), dayIdx)) {
      ref.read(xpRepositoryProvider.notifier).add(SkillRewards.branchCompleteXp);
      ref
          .read(cashStateProvider.notifier)
          .earn(const Money.cents(SkillRewards.branchCompleteCents));
      msg = '🏅 ${node.branch.label}-Zweig gemeistert!\n'
          '+${SkillRewards.branchCompleteXp} XP + '
          '${SkillRewards.branchCompleteCents ~/ 100} €\n'
          'Jetzt wartet der Meister-Knoten 🏆';
    }
    if (treeComplete(unlocked) && ach.unlock(treeTrophyId, dayIdx)) {
      ref.read(xpRepositoryProvider.notifier).add(SkillRewards.treeCompleteXp);
      ref
          .read(cashStateProvider.notifier)
          .earn(const Money.cents(SkillRewards.treeCompleteCents));
      msg = '👑 Großmeister! Du hast den ganzen Baum gemeistert!\n'
          '+${SkillRewards.treeCompleteXp} XP + '
          '${SkillRewards.treeCompleteCents ~/ 100} €';
    }
    return msg;
  }

  /// Round 28 v4: Prestige-Knoten freigeschaltet → XP + Cash, und wenn alle
  /// 3 Prestige-Knoten fertig sind die Prestige-Trophäe.
  String? _grantPrestigeRewards(WidgetRef ref, SkillNode node) {
    final settings = ref.read(settingsRepositoryProvider.notifier);
    ref.read(xpRepositoryProvider.notifier).add(SkillRewards.prestigeNodeXp);
    ref
        .read(cashStateProvider.notifier)
        .earn(const Money.cents(SkillRewards.prestigeNodeCents));
    var msg = '🏆 Meister-Knoten! +${SkillRewards.prestigeNodeXp} XP + '
        '${SkillRewards.prestigeNodeCents ~/ 100} €';
    final unlocked = settings.unlockedSkills();
    final ach = ref.read(achievementsRepositoryProvider.notifier);
    final dayIdx = ref.read(gameClockProvider).dayIndex;
    if (prestigeComplete(unlocked) && ach.unlock(prestigeTrophyId, dayIdx)) {
      msg = '🏆 Prestige-Meister! Alle drei Meister-Knoten gemeistert — '
          'die seltenste Trophäe ist deine!';
    }
    return msg;
  }
}

class _PointsHeader extends StatelessWidget {
  const _PointsHeader({required this.level, required this.free});

  final int level;
  final int free;

  @override
  Widget build(BuildContext context) {
    final hasPoints = free > 0;
    // Round 28 v4: auf Grün dunkle Schrift (heller Default war unleserlich).
    final fg = hasPoints ? Colors.black : FgColors.onSurface;
    return PixelPanel(
      background: hasPoints ? FgColors.success : FgColors.backgroundDeep,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasPoints
                ? '🌟 $free Skill-Punkt${free == 1 ? '' : 'e'} frei'
                : '🌟 Keine Punkte frei',
            style: FgTypography.bodyL
                .copyWith(fontWeight: FontWeight.bold, color: fg),
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            'Level $level · pro Level gibt es 1 Punkt. Tippe einen Knoten — '
            'offene schaltest du frei, fertige zeigen, was sie bringen.',
            style: FgTypography.bodyS.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

class _RedeemPanel extends StatelessWidget {
  const _RedeemPanel({
    required this.points,
    required this.valuePerPoint,
    required this.onRedeemAll,
  });

  final int points;
  final int valuePerPoint;
  final VoidCallback onRedeemAll;

  @override
  Widget build(BuildContext context) {
    final euro = points * valuePerPoint ~/ 100;
    return PixelPanel(
      background: FgColors.backgroundElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('🎓 Alles freigeschaltet!',
              style:
                  FgTypography.bodyL.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: FgSpacing.xs),
          Text(
            'Du hast $points übrige Punkte. Wissen zahlt sich aus — löse sie '
            'in Taschengeld ein (${valuePerPoint ~/ 100} € pro Punkt, steigt '
            'mit Level + Vermögen).',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: '$points Punkte einlösen → +$euro €',
            background: FgColors.success,
            foreground: Colors.black,
            onPressed: onRedeemAll,
          ),
        ],
      ),
    );
  }
}

class _BranchPanel extends StatelessWidget {
  const _BranchPanel({
    required this.branch,
    required this.unlocked,
    required this.pointsFree,
    required this.onTapNode,
  });

  final SkillBranch branch;
  final Set<String> unlocked;
  final int pointsFree;
  final void Function(SkillNode) onTapNode;

  @override
  Widget build(BuildContext context) {
    final nodes = skillsForBranch(branch);
    final prestige = prestigeForBranch(branch);
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${branch.emoji}  ${branch.label}',
            style: FgTypography.display.copyWith(fontSize: 20),
          ),
          const SizedBox(height: FgSpacing.s),
          for (final node in nodes)
            _SkillCard(
              node: node,
              isUnlocked: unlocked.contains(node.id),
              isUnlockable: isNodeUnlockable(node, unlocked),
              pointsFree: pointsFree,
              lockedHint: _coreLockedHint(node),
              onTap: () => onTapNode(node),
            ),
          if (prestige != null)
            _SkillCard(
              node: prestige,
              isUnlocked: unlocked.contains(prestige.id),
              isUnlockable: isPrestigeUnlockable(prestige, unlocked),
              pointsFree: pointsFree,
              lockedHint: 'Erst ganzen Zweig meistern',
              onTap: () => onTapNode(prestige),
            ),
        ],
      ),
    );
  }

  String _coreLockedHint(SkillNode node) {
    final pred = predecessorOf(node);
    return pred == null ? '' : 'Erst „${pred.title}"';
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.node,
    required this.isUnlocked,
    required this.isUnlockable,
    required this.pointsFree,
    required this.lockedHint,
    required this.onTap,
  });

  final SkillNode node;
  final bool isUnlocked;
  final bool isUnlockable;
  final int pointsFree;
  final String lockedHint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final canAfford = isUnlockable && pointsFree >= node.cost;
    final costLabel =
        node.cost == 1 ? '1 Punkt' : '${node.cost} Punkte';
    Color border;
    Color bg;
    Widget trailing;
    if (isUnlocked) {
      border = node.isPrestige ? const Color(0xFFFFC107) : FgColors.success;
      bg = (node.isPrestige ? const Color(0xFFFFC107) : FgColors.success)
          .withValues(alpha: 0.12);
      trailing = Text(node.isPrestige ? '🏆' : '✅',
          style: const TextStyle(fontSize: 18));
    } else if (isUnlockable) {
      border = canAfford
          ? (node.isPrestige ? const Color(0xFFFFC107) : FgColors.primary)
          : FgColors.outline;
      bg = FgColors.backgroundElevated;
      trailing = Text(
        canAfford ? costLabel : '$costLabel nötig',
        style: FgTypography.bodyS.copyWith(
          // A11y: neutral (#888) = 4,25:1 auf Elevated — knapp unter 4,5:1.
          color: canAfford
              ? (node.isPrestige ? const Color(0xFFFFA000) : FgColors.primary)
              : FgColors.onSurfaceMuted,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      border = FgColors.outline;
      bg = FgColors.backgroundDeep;
      trailing = const Text('🔒', style: TextStyle(fontSize: 16));
    }

    final emojiOpacity = isUnlocked || isUnlockable ? 1.0 : 0.35;
    final tierLabel = node.isPrestige ? '★' : '${node.tier}.';
    final card = Container(
      margin: const EdgeInsets.only(bottom: FgSpacing.s),
      padding: const EdgeInsets.all(FgSpacing.s),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: emojiOpacity,
            child: Text('$tierLabel ${node.emoji}',
                style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: FgSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(node.title,
                    style: FgTypography.bodyM
                        .copyWith(fontWeight: FontWeight.bold)),
                if (isUnlocked && node.hasEffect)
                  Text('✓ ${node.effect}', style: FgTypography.bodyS)
                else if (isUnlocked)
                  const Text('✓ Tipp lesen', style: FgTypography.bodyS)
                else if (!isUnlockable && lockedHint.isNotEmpty)
                  Text(lockedHint,
                      style: FgTypography.bodyS
                          .copyWith(color: FgColors.neutral))
                else if (node.isPrestige)
                  const Text('Meister-Knoten', style: FgTypography.bodyS)
                else if (node.hasEffect)
                  const Text('Schaltet etwas frei', style: FgTypography.bodyS)
                else
                  const Text('Wissens-Knoten', style: FgTypography.bodyS),
              ],
            ),
          ),
          const SizedBox(width: FgSpacing.s),
          trailing,
        ],
      ),
    );
    // Round 28 v4: ALLE Karten tippbar (fertige zeigen den Bonus, gesperrte
    // einen Hinweis) — nicht mehr nur die sofort freischaltbaren.
    // A11y: Button-Rolle + Zustand für TalkBack (wie Trophy-Tiles, Runde 2).
    final semanticState = isUnlocked
        ? 'freigeschaltet'
        : (isUnlockable
            ? (canAfford
                ? 'freischaltbar für $costLabel'
                : 'braucht $costLabel')
            : 'gesperrt');
    return Semantics(
      button: true,
      label: '${node.title}, $semanticState',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ExcludeSemantics(child: card),
      ),
    );
  }
}
