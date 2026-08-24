import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../daily_quiz/daily_quiz_state.dart';

/// Welle-8 Round 15: Wochen-Rückblick. Erscheint nach jeder 7-Tage-Marke
/// im Schlaf-Flow. Zeigt:
/// - Vermögens-Delta vs vor 7 Tagen
/// - Gesamt-gelernte-Begriffe-Anzahl
/// - Motivations-Snip
class WeeklyReviewPage extends ConsumerWidget {
  const WeeklyReviewPage({
    required this.netWorthBeforeCents,
    required this.netWorthNowCents,
    required this.onDone,
    super.key,
  });

  final int netWorthBeforeCents;
  final int netWorthNowCents;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deltaCents = netWorthNowCents - netWorthBeforeCents;
    final positive = deltaCents >= 0;
    final delta = Money.cents(deltaCents.abs());
    final learnedCount = ref.watch(learnedTopicsProvider).length;
    return PhoneFrame(
      appName: '📅 Wochen-Rückblick',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          const Text(
            'Eine Spiel-Woche ist vorbei!',
            style: FgTypography.display,
          ),
          const SizedBox(height: FgSpacing.m),
          PixelPanel(
            child: Padding(
              padding: const EdgeInsets.all(FgSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💰 Vermögens-Veränderung',
                    style: FgTypography.bodyL,
                  ),
                  const SizedBox(height: FgSpacing.s),
                  Text(
                    '${positive ? '+' : '−'}${delta.formatEur()}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: positive ? FgColors.success : FgColors.alert,
                    ),
                  ),
                  const SizedBox(height: FgSpacing.xs),
                  Text(
                    positive
                        ? 'Glückwunsch — du hast diese Woche zugelegt.'
                        : 'Diese Woche war rot. Crash, Inflation? Ruhig '
                            'bleiben — über Jahre zählt der Trend.',
                    style: FgTypography.bodyS,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelPanel(
            child: Padding(
              padding: const EdgeInsets.all(FgSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎓 Gelernte Begriffe',
                    style: FgTypography.bodyL,
                  ),
                  const SizedBox(height: FgSpacing.s),
                  Text(
                    '$learnedCount Begriffe markiert',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: FgColors.info,
                    ),
                  ),
                  const SizedBox(height: FgSpacing.xs),
                  const Text(
                    'Im Wissens-Bereich kannst du noch nicht gelernte '
                    'Begriffe nachlesen + Quiz machen.',
                    style: FgTypography.bodyS,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FgSpacing.xl),
          PixelButton(
            label: 'Weiter →',
            background: FgColors.success,
            foreground: FgColors.onSurface,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
