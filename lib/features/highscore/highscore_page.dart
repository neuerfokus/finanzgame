import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../domain/highscore/highscore_entry.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../settings/settings_repository.dart';
import 'highscore_repository.dart';

/// Lifetime-Leaderboard: zeigt alle abgeschlossenen Runs (Alter 80) nach
/// finalem Netto-Vermögen absteigend sortiert.
class HighscorePage extends ConsumerWidget {
  const HighscorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(highscoreRepositoryProvider);
    return PhoneFrame(
      appName: 'Highscore',
      onBack: () => Navigator.of(context).pop(),
      child: async.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Fehler: $e', style: FgTypography.bodyM),
        ),
        data: (data) {
          final entries = data.entries;
          final startAge =
              ref.read(settingsRepositoryProvider).startAgeYears;
          // v29: aktueller Run — Millionär-Alter aus Day herleiten.
          final currentMillAge = data.firstMillionaireDayIndex == null
              ? null
              : startAge + (data.firstMillionaireDayIndex! ~/ 365);
          // 2 Rankings: schnellster Millionär (asc by age) + meistes
          // Vermögen mit 80 (desc by finalNetWorth).
          final byWealth = [...entries]..sort(
              (a, b) => b.finalNetWorthCents.compareTo(a.finalNetWorthCents),
            );
          final byMillionaire = [
            for (final e in entries)
              if (e.firstMillionaireAgeYears != null) e,
          ]..sort((a, b) => a.firstMillionaireAgeYears!
              .compareTo(b.firstMillionaireAgeYears!));
          return ListView(
            padding: const EdgeInsets.all(FgSpacing.l),
            children: [
              PixelPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🏆 Highscores',
                        style: FgTypography.display),
                    const SizedBox(height: FgSpacing.xs),
                    const Text(
                      'Zwei Bestenlisten: schnellster Millionär + '
                      'höchstes Vermögen am Lebensende (mit 80 Jahren).',
                      style: FgTypography.bodyS,
                    ),
                    if (currentMillAge != null) ...[
                      const SizedBox(height: FgSpacing.s),
                      Text(
                        '💰 Aktueller Run: Millionär mit '
                        '$currentMillAge Jahren (Tag '
                        '${data.firstMillionaireDayIndex! + 1})'
                        '${data.firstMillionaireNetWorthCents != null ? ' · ${Money.cents(data.firstMillionaireNetWorthCents!).formatEur()}' : ''}',
                        style: FgTypography.bodyS.copyWith(
                          color: FgColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: FgSpacing.m),
              if (entries.isEmpty)
                const PixelPanel(
                  child: Text(
                    'Noch kein Run abgeschlossen.\n\n'
                    'Lebe bis Alter 80, um deinen ersten Highscore '
                    'einzutragen.',
                    style: FgTypography.bodyM,
                  ),
                )
              else ...[
                const Text('💰 Höchstes Vermögen mit 80',
                    style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                for (var i = 0; i < byWealth.length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: FgSpacing.s),
                    child: _EntryTile(
                      rank: i + 1,
                      entry: byWealth[i],
                      highlight: 'wealth',
                    ),
                  ),
                if (byMillionaire.isNotEmpty) ...[
                  const SizedBox(height: FgSpacing.m),
                  const Text('⚡ Schnellster Millionär',
                      style: FgTypography.bodyL),
                  const SizedBox(height: FgSpacing.xs),
                  for (var i = 0; i < byMillionaire.length; i++)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: FgSpacing.s),
                      child: _EntryTile(
                        rank: i + 1,
                        entry: byMillionaire[i],
                        highlight: 'millionaire',
                      ),
                    ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.rank,
    required this.entry,
    this.highlight,
  });

  final int rank;
  final HighscoreEntry entry;
  /// 'wealth' = formatiert finalNetWorth gross, 'millionaire' = Alter gross.
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    final medal = switch (rank) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '#$rank',
    };
    final mill = entry.firstMillionaireAgeYears;
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(medal, style: FgTypography.bodyL),
              ),
              Expanded(
                child: Text(
                  entry.playerName,
                  style: FgTypography.bodyL,
                ),
              ),
              Text(
                Money.cents(entry.finalNetWorthCents).formatEur(),
                style: FgTypography.bodyL.copyWith(
                  color: entry.finalNetWorthCents >= 0
                      ? FgColors.success
                      : FgColors.alert,
                ),
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              'Alter ${entry.finalAgeYears} J · '
              '${mill != null ? 'Millionär mit $mill J${entry.firstMillionaireNetWorthCents != null ? ' (${Money.cents(entry.firstMillionaireNetWorthCents!).formatEur()})' : ''}' : 'Nie Millionär'}',
              style: FgTypography.bodyS,
            ),
          ),
        ],
      ),
    );
  }
}
