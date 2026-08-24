import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../settings/settings_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import 'avatar_catalog.dart';

/// Spec-41 A: Avatar-Shop. Spieler kauft Glyph mit XP, schaltet ihn frei
/// und aktiviert ihn automatisch.
class AvatarShopPage extends ConsumerWidget {
  const AvatarShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsRepositoryProvider);
    final xp = ref.watch(xpRepositoryProvider);
    final level = LevelSystem.levelFor(xp);
    final notifier = ref.read(settingsRepositoryProvider.notifier);
    final unlocked = notifier.unlockedAvatars();

    return PhoneFrame(
      appName: 'Avatar-Shop',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(settings.avatarEmoji,
                        style: const TextStyle(fontSize: 48)),
                    const SizedBox(width: FgSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('XP: $xp', style: FgTypography.bodyL),
                          Text('Level $level',
                              style: FgTypography.bodyS),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final spec in AvatarCatalog.all)
            _Row(
              spec: spec,
              owned: spec.isFreeDefault() || unlocked.contains(spec.glyph),
              active: settings.avatarEmoji == spec.glyph,
              affordable:
                  xp >= spec.xpCost && level >= spec.minLevel,
              onActivate: () {
                notifier.setAvatarEmoji(spec.glyph);
                showFgSnack(context, '${spec.glyph} aktiviert');
              },
              onUnlock: () => _confirmUnlock(context, ref, spec),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmUnlock(
    BuildContext context,
    WidgetRef ref,
    AvatarSpec spec,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text(
          '${spec.glyph} ${spec.name} freischalten?',
          style: FgTypography.bodyL,
        ),
        content: Text(
          'Kostet ${spec.xpCost} XP. XP wird abgezogen, Avatar wird '
          'aktiviert.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Kaufen',
                style: FgTypography.bodyM.copyWith(color: FgColors.primary)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final notifier = ref.read(settingsRepositoryProvider.notifier);
    final success = notifier.purchaseAvatar(
      glyph: spec.glyph,
      xpCost: spec.xpCost,
      minLevel: spec.minLevel,
    );
    if (success) {
      showFgSnack(context, '${spec.glyph} ${spec.name} freigeschaltet!');
    } else {
      showFgSnack(context, 'Nicht genug XP oder Level zu niedrig',
          isError: true);
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.spec,
    required this.owned,
    required this.active,
    required this.affordable,
    required this.onActivate,
    required this.onUnlock,
  });
  final AvatarSpec spec;
  final bool owned;
  final bool active;
  final bool affordable;
  final VoidCallback onActivate;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.s),
      child: PixelPanel(
        background: active
            ? FgColors.primary.withValues(alpha: 0.2)
            : FgColors.backgroundElevated,
        child: Row(
          children: [
            Text(
              owned ? spec.glyph : '🔒',
              style: TextStyle(
                fontSize: 36,
                color: owned ? null : FgColors.neutral,
              ),
            ),
            const SizedBox(width: FgSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spec.name, style: FgTypography.bodyL),
                  if (!owned)
                    Text(
                      spec.minLevel > 0
                          ? 'Kosten: ${spec.xpCost} XP · Level ≥ ${spec.minLevel}'
                          : 'Kosten: ${spec.xpCost} XP',
                      style: FgTypography.bodyS,
                    )
                  else if (active)
                    const Text('Aktiv ✓', style: FgTypography.bodyS),
                ],
              ),
            ),
            if (active)
              const SizedBox.shrink()
            else if (owned)
              PixelButton(
                label: 'Wählen',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: onActivate,
              )
            else
              PixelButton(
                label: 'Kaufen',
                background:
                    affordable ? FgColors.secondary : FgColors.neutral,
                foreground: FgColors.onSurface,
                onPressed: affordable ? onUnlock : null,
              ),
          ],
        ),
      ),
    );
  }
}
