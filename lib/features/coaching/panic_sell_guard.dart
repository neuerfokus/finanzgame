/// Welle-8 Round 23: Panik-Verkauf-Coach.
///
/// Wenn der Spieler beim Verkauf einen Verlust ≥ 20 % realisiert,
/// zeigt ein Coach-Overlay einen kurzen Hinweis zum „Buy-and-Hold"-
/// Prinzip + zur Vermeidung emotionaler Trades. Kein Hard-Block —
/// User kann trotzdem verkaufen. Edukativer Snack.
library;

import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';

/// Zeigt einen Hinweis-Dialog wenn `pnlPct < lossThresholdPct`. Liefert
/// true wenn der User trotzdem verkaufen will, false wenn abgebrochen.
/// Liefert sofort true wenn kein (ausreichender) Verlust (kein Block).
///
/// Round 28: [lossThresholdPct] standard -20. Der Skill „Cooler Kopf"
/// senkt ihn an den Call-Sites auf -10 → die Warnung greift früher.
Future<bool> maybeWarnPanicSell({
  required BuildContext context,
  required String assetName,
  required Money avgBuyPricePerShare,
  required Money currentPricePerShare,
  double lossThresholdPct = -20,
}) async {
  if (avgBuyPricePerShare.cents <= 0) return true;
  final pnlPct = (currentPricePerShare.cents - avgBuyPricePerShare.cents) *
      100.0 /
      avgBuyPricePerShare.cents;
  if (pnlPct > lossThresholdPct) return true;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: FgColors.backgroundElevated,
      title: const Text(
        '⚠ Verlust-Verkauf?',
        style: FgTypography.bodyL,
      ),
      content: Text(
        '$assetName steht gerade ${pnlPct.toStringAsFixed(0)} % unter '
        'deinem Kaufpreis.\n\n'
        'Profis sagen: nicht aus Panik bei Tiefstand verkaufen — '
        'oft holt der Markt wieder auf. Wer in der Krise verkauft, '
        'macht den Verlust echt.\n\n'
        'Drei große Börsen-Crashs in echt:\n'
        '• 1987 (Schwarzer Montag) — nach ~2 Jahren erholt\n'
        '• 2000 (Dotcom-Blase) — nach einigen Jahren erholt\n'
        '• 2008 (Lehman/Finanzkrise) — nach ~4-5 Jahren erholt\n'
        'Wer durchgehalten hat, war später wieder im Plus.\n\n'
        'Aber: nur dein Geld, deine Entscheidung. Trotzdem verkaufen?',
        style: FgTypography.bodyM,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Lieber halten', style: FgTypography.bodyM),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            'Trotzdem verkaufen',
            style: FgTypography.bodyM.copyWith(color: FgColors.alert),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
