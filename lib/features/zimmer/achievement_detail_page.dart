import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'achievements.dart';
import 'achievements_repository.dart';

/// Spec-42 Welle-6: Achievement-Detail-Page. Zeigt Emoji, Label,
/// Unlock-Bedingung in Worten, Unlock-Tag (falls erreicht).
class AchievementDetailPage extends ConsumerWidget {
  const AchievementDetailPage({required this.achievement, super.key});

  final Achievement achievement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(achievementsRepositoryProvider);
    final unlocked = map.containsKey(achievement.id);
    final unlockDay = map[achievement.id];

    return PhoneFrame(
      appName: 'Trophäe',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welle-8 Round 23: Geist-Teaser — Achievement-Emoji
                // halbtransparent + kleines 🔒 unten rechts wenn locked.
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: unlocked ? 1.0 : 0.25,
                      child: Text(
                        achievement.emoji,
                        style: const TextStyle(fontSize: 96),
                      ),
                    ),
                    if (!unlocked)
                      const Positioned(
                        bottom: 8,
                        right: 8,
                        child: Text('🔒',
                            style: TextStyle(fontSize: 32)),
                      ),
                  ],
                ),
                const SizedBox(height: FgSpacing.s),
                Text(
                  achievement.label,
                  style: FgTypography.displayLarge.copyWith(
                    fontSize: 26,
                    color: unlocked
                        ? FgColors.primary
                        : FgColors.neutral,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FgSpacing.s),
                Text(
                  unlocked
                      ? '✓ Freigeschaltet${unlockDay != null ? " an Tag ${unlockDay + 1}" : ""}'
                      : '🔒 Noch nicht freigeschaltet',
                  style: FgTypography.bodyL.copyWith(
                    color: unlocked
                        ? FgColors.success
                        : FgColors.neutral,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bedingung', style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                Text(_conditionFor(achievement.id),
                    style: FgTypography.bodyM),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _conditionFor(String id) {
    return switch (id) {
      'first_harvest' => 'Ernte deine erste Pflanze auf der Spar-Insel.',
      'savings_100' => 'Hab 100 € auf dem Sparkonto.',
      'savings_1000' => 'Hab 1000 € auf dem Sparkonto.',
      'first_etf' => 'Kauf deinen ersten ETF-Anteil.',
      'first_stock' || 'stock_first' =>
        'Kauf deine erste Einzelaktie.',
      'bitcoin_first' => 'Kauf deinen ersten Bitcoin-Anteil.',
      'gold_first' => 'Kauf dein erstes Edelmetall.',
      'quest_1' => 'Schließe deine erste Quest ab.',
      'quest_5' => 'Schließe 5 Quests ab.',
      'quest_10' => 'Schließe 10 Quests ab.',
      'quest_20' => 'Schließe 20 Quests ab.',
      'inflation_unlocked' => 'Öffne das Inflations-Atoll.',
      'crash_survivor' =>
        'Überlebe einen Markt-Crash ohne Panik-Verkauf.',
      'days_30' => 'Spiele 30 Tage (sleeps).',
      'notgroschen_3m' =>
        'Spar mindestens 3 Monate Taschengeld aufs Spar-Konto '
            '(Notgroschen-Regel).',
      'realestate_1' => 'Kauf deine erste Wohnung oder dein erstes Haus.',
      'realestate_4' => 'Besitze 4 Immobilien gleichzeitig.',
      'streak_7' => '7 echte Tage hintereinander gespielt.',
      'streak_30' => '30 echte Tage hintereinander gespielt.',
      'diversified_5' =>
        'Halte mindestens 5 verschiedene Sorten gleichzeitig '
            '(Spar/ETF/Aktien/Krypto/Gold/Immobilien).',
      'millionaire' => 'Vermögen ≥ 1 Million €.',
      'wishlist_first' => 'Kauf deinen ersten Wunschartikel.',
      'wishlist_all' => 'Kauf alle Wunschartikel.',
      'level_10' => 'Erreiche Level 10.',
      'level_20' => 'Erreiche Level 20.',
      'level_30' => 'Erreiche Level 30 (Max).',
      'quiz_streak_7' => '7 Quiz-Fragen richtig beantwortet.',
      'vorsorge_first' => 'Schließe deinen ersten Vorsorgevertrag ab.',
      'sparplan_first' => 'Richte deinen ersten Sparplan ein.',
      _ => 'Im Spiel verborgen — überrasch dich selbst.',
    };
  }
}
