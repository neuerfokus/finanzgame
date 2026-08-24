import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'portfolio_report_service.dart';
import 'weekly_report_service.dart';

/// Eigene „Berichte"-Seite vom Springboard (vor den Settings). Bündelt die
/// Teilen-Funktionen, die vorher tief in den Settings versteckt waren:
/// Bestand-Report + Wochen-Report. Beide bauen einen lesbaren Text und
/// öffnen das System-Share-Sheet (share_plus).
class BerichtePage extends ConsumerWidget {
  const BerichtePage({super.key});

  Future<void> _sharePortfolio(BuildContext context, WidgetRef ref) async {
    try {
      await PortfolioReportService.instance.shareReport(ref);
    } on Object catch (e) {
      if (context.mounted) {
        showFgSnack(context, 'Bestand-Report Fehler: $e', isError: true);
      }
    }
  }

  Future<void> _shareWeekly(BuildContext context, WidgetRef ref) async {
    try {
      await WeeklyReportService.instance.shareReport(ref);
    } on Object catch (e) {
      if (context.mounted) {
        showFgSnack(context, 'Wochen-Report Fehler: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PhoneFrame(
      appName: 'Berichte',
      onBack: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PixelPanel(
              child: Text(
                'Erstelle einen lesbaren Bericht deines Spielstands und '
                'teile ihn — z. B. mit deinen Eltern oder zum Vergleichen '
                'mit Freunden.',
                style: FgTypography.bodyM,
              ),
            ),
            const SizedBox(height: FgSpacing.l),
            const Text('📊 Bestand', style: FgTypography.bodyL),
            const SizedBox(height: FgSpacing.xs),
            const Text(
              'Dein komplettes Vermögen nach Anlageklasse — Cash, Sparen, '
              'ETF, Aktien, Krypto, Edelmetalle, Immobilien.',
              style: FgTypography.bodyS,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '📊 Bestand als Text teilen',
              background: FgColors.info,
              foreground: FgColors.onSurface,
              onPressed: () => _sharePortfolio(context, ref),
            ),
            const SizedBox(height: FgSpacing.l),
            const Text('📅 Wochen-Report', style: FgTypography.bodyL),
            const SizedBox(height: FgSpacing.xs),
            const Text(
              'Was sich in der letzten Spielwoche getan hat — Vermögens-'
              'Veränderung und neu gelernte Begriffe.',
              style: FgTypography.bodyS,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '📅 Wochen-Report teilen',
              background: FgColors.info,
              foreground: FgColors.onSurface,
              onPressed: () => _shareWeekly(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
