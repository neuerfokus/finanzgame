import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../sleep/streak_milestones.dart';
import 'settings_repository.dart';

/// Spec-42 Welle-6: Streak-Detail-Page mit 30-Tage-Grid.
///
/// Letzte 30 Real-Tage werden visualisiert. Heute = letzter
/// `lastSleepDateIso` minus N. Anzeige: 🔥 für aktive Streak-Tage,
/// hellgrau für übersprungene.
class StreakCalendarPage extends ConsumerWidget {
  const StreakCalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsRepositoryProvider);
    final streak = s.streakCount;
    // Lifetime bereits ausgezahlte Meilenstein-Schwelle (für ✓-Marker —
    // „einmalig" heißt: einmal verdient bleibt verdient, auch nach Bruch).
    final claimed = s.claimedStreakMilestone;
    final lastIso = s.lastSleepDateIso;
    final lastDate = lastIso.isEmpty
        ? DateTime.now()
        : DateTime.tryParse(lastIso) ?? DateTime.now();

    // 30-Tage-Grid. Aktive Streak-Tage = die letzten `streak` Tage
    // ab heute rückwärts. Frühere = leer.
    const totalDays = 30;
    final today = DateTime.now();
    final days = <_DayEntry>[];
    for (var i = totalDays - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final daysAgo = today.difference(date).inDays;
      final activeStreak = daysAgo < streak;
      final isToday = daysAgo == 0;
      final isLastSleep = date.year == lastDate.year &&
          date.month == lastDate.month &&
          date.day == lastDate.day;
      days.add(_DayEntry(
        date: date,
        isStreak: activeStreak,
        isToday: isToday,
        isLastSleep: isLastSleep,
      ));
    }

    return PhoneFrame(
      appName: '🔥 Streak-Kalender',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aktueller Streak: $streak ${streak == 1 ? "Tag" : "Tage"}',
                  style: FgTypography.bodyL,
                ),
                const SizedBox(height: FgSpacing.xs),
                Builder(builder: (_) {
                  final next = kStreakMilestones
                      .where((m) => m.days > streak)
                      .fold<int?>(null, (acc, m) => acc ?? m.days);
                  if (next == null) {
                    return Text('💯 100-Tage-Streak — alle Meilensteine!',
                        style: FgTypography.bodyS
                            .copyWith(color: FgColors.primary));
                  }
                  return Text(
                    streak == 0
                        ? 'Spiel täglich — bei 7/14/30/100 Tagen winken Boni.'
                        : 'Dranbleiben! Nächstes Ziel: $next Tage.',
                    style: FgTypography.bodyS
                        .copyWith(color: FgColors.info),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          const Text('Letzte 30 Tage',
              style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.s),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 6,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: [for (final d in days) _DayCell(entry: d)],
          ),
          const SizedBox(height: FgSpacing.m),
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reward-Schwellen (einmalig)',
                    style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                for (final m in kStreakMilestones)
                  Text(
                    '${m.emoji} ${m.days} Tage → +${m.cashCents ~/ 100} € '
                    '+${m.xp} XP${claimed >= m.days ? "  ✓" : ""}',
                    style: FgTypography.bodyM.copyWith(
                      color: claimed >= m.days
                          ? FgColors.success
                          : FgColors.onSurface,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayEntry {
  const _DayEntry({
    required this.date,
    required this.isStreak,
    required this.isToday,
    required this.isLastSleep,
  });
  final DateTime date;
  final bool isStreak;
  final bool isToday;
  final bool isLastSleep;
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.entry});
  final _DayEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = entry.isStreak
        ? const Color(0xFFFF7A1A)
        : FgColors.backgroundDeep;
    final borderColor = entry.isToday
        ? FgColors.primary
        : (entry.isStreak ? FgColors.alert : FgColors.outline);
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: entry.isToday ? 3 : 1),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (entry.isStreak)
            const Text('🔥', style: TextStyle(fontSize: 16))
          else
            const Text('·',
                style: TextStyle(fontSize: 14, color: FgColors.neutral)),
          Text(
            '${entry.date.day}.${entry.date.month}.',
            style: FgTypography.bodyS.copyWith(
              fontSize: 10,
              // A11y: Schwarz auf Orange ~8:1, onSurface waere nur 2,1:1.
              color: entry.isStreak ? Colors.black : FgColors.neutral,
            ),
          ),
        ],
      ),
    );
  }
}
