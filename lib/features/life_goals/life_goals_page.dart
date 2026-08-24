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
import '../market_phase/diversification.dart';
import '../settings/settings_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import '../zimmer/achievements_repository.dart';
import 'life_goals.dart';

/// Round 28 v4: Lebensziele-Leiter — Langzeit-Endgame-Übersicht. Zeigt jedes
/// weit gesteckte Ziel mit Fortschritt + Belohnung.
///
/// „Sauber erkannt"-Fix (v4 follow-up): beim Öffnen werden alle bereits
/// erfüllten, noch nicht gutgeschriebenen Ziele SOFORT freigeschaltet +
/// belohnt (idempotent über [applyLifeGoals]) — nicht erst beim nächsten
/// Schlafen. Erfüllte Ziele werden zusätzlich live als ✅ angezeigt.
class LifeGoalsPage extends ConsumerStatefulWidget {
  const LifeGoalsPage({super.key});

  @override
  ConsumerState<LifeGoalsPage> createState() => _LifeGoalsPageState();
}

class _LifeGoalsPageState extends ConsumerState<LifeGoalsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _grantMet());
  }

  void _grantMet() {
    if (!mounted) return;
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final settings = ref.read(settingsRepositoryProvider);
    final snap = LifeGoalSnapshot(
      netWorthCents: ref.read(netWorthProvider(dayIndex)),
      daysPlayed: dayIndex,
      ageYears: settings.startAgeYears + dayIndex ~/ 365,
      level: LevelSystem.levelFor(ref.read(xpRepositoryProvider)),
      assetClassCount: ref.read(diversificationClassCountProvider),
      streakDays: settings.streakCount,
    );
    final cashRepo = ref.read(cashStateProvider.notifier);
    final granted = applyLifeGoals(
      snap: snap,
      dayIndex: dayIndex,
      unlock: ref.read(achievementsRepositoryProvider.notifier).unlock,
      addXp: ref.read(xpRepositoryProvider.notifier).add,
      earnCents: (cents) => cashRepo.earn(Money.cents(cents)),
    );
    if (granted.isNotEmpty && mounted) {
      final totalCash =
          granted.fold<int>(0, (s, g) => s + g.cashCents) ~/ 100;
      final totalXp = granted.fold<int>(0, (s, g) => s + g.xpReward);
      showFgSnack(
        context,
        '🎯 ${granted.length} Lebensziel${granted.length == 1 ? '' : 'e'} '
        'erreicht! +$totalXp XP · +$totalCash €',
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(achievementsRepositoryProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final netWorth = ref.watch(netWorthProvider(dayIndex));
    final settings = ref.watch(settingsRepositoryProvider);
    final level = LevelSystem.levelFor(ref.watch(xpRepositoryProvider));
    final assetClasses = ref.watch(diversificationClassCountProvider);
    final snap = LifeGoalSnapshot(
      netWorthCents: netWorth,
      daysPlayed: dayIndex,
      ageYears: settings.startAgeYears + dayIndex ~/ 365,
      level: level,
      assetClassCount: assetClasses,
      streakDays: settings.streakCount,
    );
    // „Geschafft" = bereits gutgeschrieben ODER aktuell erfüllt (sofort
    // sichtbar, Gutschrift folgt durch _grantMet / nächsten Schlafen).
    final doneCount = kLifeGoals
        .where((g) => unlocked.containsKey(g.id) || g.met(snap))
        .length;

    return PhoneFrame(
      appName: 'Lebensziele',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            background: FgColors.backgroundDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎯 Lebensziele  $doneCount/${kLifeGoals.length}',
                    style: FgTypography.bodyL
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: FgSpacing.xs),
                const Text(
                  'Große Ziele für die lange Sicht. Erfüllte Ziele werden '
                  'beim Öffnen gutgeschrieben — Geduld lohnt sich.',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final goal in kLifeGoals) ...[
            _GoalCard(
              goal: goal,
              claimed: unlocked.containsKey(goal.id),
              met: goal.met(snap),
              unreachable: goal.isUnreachable(snap),
              snap: snap,
            ),
            const SizedBox(height: FgSpacing.s),
          ],
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.claimed,
    required this.met,
    required this.unreachable,
    required this.snap,
  });

  final LifeGoal goal;

  /// Belohnung bereits gutgeschrieben (in AchievementsRepository).
  final bool claimed;

  /// Kriterium aktuell erfüllt (Snapshot).
  final bool met;

  /// Dauerhaft verpasst (Zeitfenster vorbei) — wird ausgegraut.
  final bool unreachable;
  final LifeGoalSnapshot snap;

  @override
  Widget build(BuildContext context) {
    final done = claimed || met;
    // Verpasst NUR wenn nicht (schon) geschafft — ein bereits gutgeschriebenes
    // Ziel bleibt „Geschafft", auch wenn das Zeitfenster inzwischen vorbei ist.
    final missed = unreachable && !done;
    final String statusText;
    if (claimed) {
      statusText = '🏆 Geschafft!';
    } else if (met) {
      statusText = '✅ Erreicht — wird gutgeschrieben';
    } else if (missed) {
      statusText = '🚫 Verpasst — dieses Ziel geht nicht mehr';
    } else {
      statusText = goal.progressLabel(snap);
    }
    // Verpasste Ziele werden ausgegraut: gedämpfte Farben + reduzierte
    // Deckkraft, damit klar ist „läuft nicht mehr" ohne es zu verstecken.
    final Color statusColor = done
        ? FgColors.success
        : missed
            ? FgColors.onSurfaceMuted
            : FgColors.info;
    final card = PixelPanel(
      background: done
          ? FgColors.success.withValues(alpha: 0.15)
          : FgColors.backgroundElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goal.emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(goal.title,
                    style: FgTypography.bodyL
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Text(
                done
                    ? '✅'
                    : missed
                        ? '🚫'
                        : '⏳',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(goal.description, style: FgTypography.bodyS),
          const SizedBox(height: FgSpacing.s),
          Row(
            children: [
              Expanded(
                child: Text(
                  statusText,
                  style: FgTypography.bodyM.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              Text(
                '+${goal.xpReward} XP · +${goal.cashCents ~/ 100} €',
                style: FgTypography.bodyS.copyWith(
                  color: missed ? FgColors.onSurfaceMuted : FgColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // Ausgrauen nur wenn verpasst (nicht erreicht + Fenster vorbei).
    return missed ? Opacity(opacity: 0.55, child: card) : card;
  }
}
