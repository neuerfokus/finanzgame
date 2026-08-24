import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'legacy.dart';
import 'new_game_state.dart';

/// Welle B: Vermächtnis-Shop. Zeigt Generation + gesammelte Legacy-Punkte
/// und lässt permanente Start-Boni kaufen (kein Markt-Cheat — nur QoL).
class LegacyPage extends ConsumerWidget {
  const LegacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(newGameStateProvider);
    final notifier = ref.read(newGameStateProvider.notifier);
    final available = notifier.availableLegacyPoints();

    return PhoneFrame(
      appName: 'Vermächtnis',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            background: FgColors.backgroundDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('👑 Generation ${data.generation}',
                    style: FgTypography.bodyL
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: FgSpacing.xs),
                const Text(
                  'Jedes abgeschlossene Leben bringt Vermächtnis-Punkte. '
                  'Damit kaufst du dauerhafte Start-Vorteile — sie bleiben '
                  'über ALLE neuen Leben erhalten.',
                  style: FgTypography.bodyS,
                ),
                const SizedBox(height: FgSpacing.s),
                Row(
                  children: [
                    Expanded(
                      child: Text('🪙 $available Punkte frei',
                          style: FgTypography.bodyM.copyWith(
                              fontWeight: FontWeight.bold,
                              color: FgColors.primary)),
                    ),
                    Text('insgesamt ${data.legacyPoints} verdient',
                        style: FgTypography.bodyS),
                  ],
                ),
                if (data.runCount == 0) ...[
                  const SizedBox(height: FgSpacing.xs),
                  Text(
                    'Noch kein Leben abgeschlossen — beim ersten „neuen '
                    'Leben" (Ruhestand) bekommst du deine ersten Punkte.',
                    style: FgTypography.bodyS
                        .copyWith(color: FgColors.info),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final up in kLegacyUpgrades)
            _UpgradeCard(
              upgrade: up,
              owned: data.legacyUpgrades.contains(up.id),
              affordable: available >= up.cost,
              onBuy: () {
                final ok = notifier.buyLegacyUpgrade(up.id);
                if (ok) {
                  showFgSnack(
                    context,
                    '${up.emoji} „${up.title}" freigeschaltet — '
                    'gilt ab dem nächsten Leben!',
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({
    required this.upgrade,
    required this.owned,
    required this.affordable,
    required this.onBuy,
  });

  final LegacyUpgrade upgrade;
  final bool owned;
  final bool affordable;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      child: PixelPanel(
        background: owned
            ? FgColors.success.withValues(alpha: 0.15)
            : FgColors.backgroundElevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(upgrade.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: Text(upgrade.title,
                      style: FgTypography.bodyL
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                if (owned)
                  const Text('✅', style: TextStyle(fontSize: 22))
                else
                  Text('🪙 ${upgrade.cost}',
                      style: FgTypography.bodyM
                          .copyWith(color: FgColors.primary)),
              ],
            ),
            const SizedBox(height: FgSpacing.xs),
            Text(upgrade.description, style: FgTypography.bodyM),
            const SizedBox(height: FgSpacing.s),
            if (owned)
              Text('Dauerhaft aktiv 🎉',
                  style: FgTypography.bodyM.copyWith(
                      fontWeight: FontWeight.bold, color: FgColors.success))
            else if (affordable)
              PixelButton(
                label: 'Für ${upgrade.cost} Punkt'
                    '${upgrade.cost == 1 ? '' : 'e'} freischalten',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: onBuy,
              )
            else
              Text('Braucht ${upgrade.cost} Punkte — spiel ein Leben zu Ende '
                  'für mehr.',
                  style: FgTypography.bodyS.copyWith(color: FgColors.info)),
          ],
        ),
      ),
    );
  }
}
