import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../highscore/net_worth.dart';
import '../life_goals/life_goals.dart';
import '../market_phase/diversification.dart';
import '../settings/settings_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import 'weekly_challenge.dart';

/// Round 28 v4: Wochen-Herausforderung-Seite. Zeigt die Challenge der
/// aktuellen Spielwoche + Fortschritt + Streak. Erfüllte werden beim Öffnen
/// sofort eingelöst (idempotent pro Woche), nicht erst beim nächsten
/// Schlafen.
class WeeklyChallengePage extends ConsumerStatefulWidget {
  const WeeklyChallengePage({super.key});

  @override
  ConsumerState<WeeklyChallengePage> createState() =>
      _WeeklyChallengePageState();
}

class _WeeklyChallengePageState extends ConsumerState<WeeklyChallengePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _claim());
  }

  LifeGoalSnapshot _snapshot(int dayIndex) {
    final settings = ref.read(settingsRepositoryProvider);
    return LifeGoalSnapshot(
      netWorthCents: ref.read(netWorthProvider(dayIndex)),
      daysPlayed: dayIndex,
      ageYears: settings.startAgeYears + dayIndex ~/ 365,
      level: LevelSystem.levelFor(ref.read(xpRepositoryProvider)),
      assetClassCount: ref.read(diversificationClassCountProvider),
      streakDays: settings.streakCount,
    );
  }

  void _claim() {
    if (!mounted) return;
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final settings = ref.read(settingsRepositoryProvider);
    final settingsRepo = ref.read(settingsRepositoryProvider.notifier);
    final cashRepo = ref.read(cashStateProvider.notifier);
    final result = applyWeeklyChallenge(
      snap: _snapshot(dayIndex),
      dayIndex: dayIndex,
      claimedWeek: settings.weeklyChallengeClaimedWeek,
      streak: settings.weeklyChallengeStreak,
      addXp: ref.read(xpRepositoryProvider.notifier).add,
      earnCents: (cents) => cashRepo.earn(Money.cents(cents)),
      persist: ({required int claimedWeek, required int streak}) =>
          settingsRepo.setWeeklyChallenge(
              claimedWeek: claimedWeek, streak: streak),
    );
    if (result.claimed && mounted) {
      showFgSnack(
        context,
        '🏅 Wochen-Challenge geschafft! +${result.xp} XP · '
        '+${result.cents ~/ 100} €  ·  Streak ${result.streak} 🔥',
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsRepositoryProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final snap = _snapshot(dayIndex);
    final week = weekIndexFor(dayIndex);
    final challenge = challengeForWeek(week);
    final settings = ref.read(settingsRepositoryProvider);
    final claimed = settings.weeklyChallengeClaimedWeek == week;
    final streak = settings.weeklyChallengeStreak;
    final met = challenge.met(snap);
    final daysLeft = daysUntilNextWeek(dayIndex);

    return PhoneFrame(
      appName: 'Wochen-Challenge',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            background: FgColors.backgroundDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔥 Streak: $streak Woche${streak == 1 ? '' : 'n'}',
                    style: FgTypography.bodyL
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: FgSpacing.xs),
                Text(
                  'Jede Spielwoche eine neue Aufgabe. Schaffst du sie, '
                  'wächst dein Streak (+1 € Bonus pro Streak-Woche). '
                  'Noch $daysLeft Tag${daysLeft == 1 ? '' : 'e'} diese Woche.',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelPanel(
            background: (claimed || met)
                ? FgColors.success.withValues(alpha: 0.15)
                : FgColors.backgroundElevated,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(challenge.emoji,
                        style: const TextStyle(fontSize: 30)),
                    const SizedBox(width: FgSpacing.s),
                    Expanded(
                      child: Text(challenge.title,
                          style: FgTypography.bodyL
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Text(claimed ? '✅' : (met ? '🎁' : '⏳'),
                        style: const TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: FgSpacing.xs),
                Text(challenge.description, style: FgTypography.bodyM),
                const SizedBox(height: FgSpacing.s),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        claimed
                            ? '🏅 Diese Woche geschafft!'
                            : (met
                                ? '🎁 Erfüllt — wird gutgeschrieben'
                                : challenge.progressLabel(snap)),
                        style: FgTypography.bodyM.copyWith(
                          fontWeight: FontWeight.bold,
                          color: (claimed || met)
                              ? FgColors.success
                              : FgColors.info,
                        ),
                      ),
                    ),
                    Text(
                      '+${challenge.xpReward} XP · '
                      '+${challenge.cashCents ~/ 100} €',
                      style: FgTypography.bodyS
                          .copyWith(color: FgColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
