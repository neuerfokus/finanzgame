import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../game/monetaria/state/monetaria_state.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/pixel_button.dart';
import '../settings/settings_repository.dart';
import 'daily_goal.dart';

/// Spec-41: Daily-Goal-Banner. Zeigt das aktuelle Mini-Ziel + Claim-Button
/// wenn erfüllt. Verschwindet nach Claim für den Tag.
///
/// Home-Screen-Cleanup: lebt jetzt oben in der Quests-Seite (statt als
/// Dauer-Banner auf dem Springboard) — der Springboard signalisiert ein
/// offenes Tagesziel nur noch über das Badge am Quests-Icon.
class DailyGoalBanner extends ConsumerWidget {
  const DailyGoalBanner({required this.dayIndex, super.key});
  final int dayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claimed = ref.watch(dailyGoalClaimedProvider);
    if (claimed.contains(dayIndex)) return const SizedBox.shrink();
    final notifier = ref.read(dailyGoalClaimedProvider.notifier);
    final unlocked = ref.watch(monetariaStateProvider);
    final settings = ref.watch(settingsRepositoryProvider);
    final age = settings.startAgeYears + (dayIndex ~/ 365);
    final goal = dailyGoalFor(dayIndex, unlocked, currentAgeYears: age);
    final eligible = notifier.isEligible(dayIndex);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FgSpacing.l,
        vertical: FgSpacing.xs,
      ),
      child: Container(
        padding: const EdgeInsets.all(FgSpacing.s),
        decoration: BoxDecoration(
          color: eligible
              ? FgColors.success.withValues(alpha: 0.2)
              : FgColors.backgroundDeep,
          border: Border.all(
            color: eligible ? FgColors.success : FgColors.outline,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎯 Tagesziel: ${goal.title}',
                      style: FgTypography.bodyL),
                  Text(goal.description, style: FgTypography.bodyS),
                  Text(
                    'Reward: ${notifier.rewardFor(goal).formatEur()} + ${goal.rewardXp} XP',
                    style:
                        FgTypography.bodyS.copyWith(color: FgColors.primary),
                  ),
                ],
              ),
            ),
            if (eligible)
              PixelButton(
                label: 'Abholen',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: () {
                  final claimedReward = notifier.rewardFor(goal);
                  final ok = notifier.claim(dayIndex);
                  if (ok) {
                    showFgSnack(
                      context,
                      '✓ Tagesziel geschafft! +${claimedReward.formatEur()} + ${goal.rewardXp} XP',
                      duration: const Duration(seconds: 3),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
