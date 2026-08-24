import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../island_editor/decor_catalog.dart';
import '../island_editor/decor_repository.dart';
import 'furniture_catalog.dart';
import 'furniture_repository.dart';
import 'furniture_sprite.dart';

/// Spec-29: Zimmer-Shop. Lists every [FurnitureCatalog.items] entry grouped
/// by slot; buying spends cash, replaces the slot, awards XP via
/// [FurnitureRepository.buy].
class FurnitureShopPage extends ConsumerWidget {
  const FurnitureShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    // Watch ensures rebuild when state changes (owned-set propagates).
    ref.watch(furnitureRepositoryProvider);
    final notifier = ref.read(furnitureRepositoryProvider.notifier);

    final grouped = <FurnitureSlot, List<FurnitureItem>>{};
    for (final item in FurnitureCatalog.items) {
      grouped.putIfAbsent(item.slot, () => []).add(item);
    }

    return PhoneFrame(
      appName: 'Möbel-Shop',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Row(
              children: [
                const Text('💰', style: TextStyle(fontSize: 28)),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: Text(
                    'Cash: ${cash.formatEur()}',
                    style: FgTypography.bodyL,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final entry in grouped.entries) ...[
            Text(
              FurnitureCatalog.labelForSlot(entry.key),
              style: FgTypography.display.copyWith(fontSize: 22),
            ),
            const SizedBox(height: FgSpacing.s),
            for (final item in entry.value)
              _ShopRow(
                item: item,
                owned: notifier.isOwned(item),
                visible: notifier.isItemVisible(item.id),
                onBuy: () {
                  final ok = notifier.buy(item);
                  if (ok) {
                    showFgSnack(context, '${item.name} gekauft ✓');
                  } else {
                    showFgSnack(
                      context,
                      'Nicht genug Geld oder bereits gekauft',
                      isError: true,
                    );
                  }
                },
                onSell: () {
                  final halfPrice = item.price.cents ~/ 2;
                  notifier.sell(item);
                  showFgSnack(context,
                      '${item.name} verkauft (+${(halfPrice / 100).toStringAsFixed(2)} €)');
                },
                onToggleVisible: () =>
                    notifier.toggleItemVisible(item.id),
              ),
            const SizedBox(height: FgSpacing.m),
          ],
          // Spec-43 v2: Decor-Sektion im Shop.
          Text(
            'Deko (frei platzierbar)',
            style: FgTypography.display.copyWith(fontSize: 22),
          ),
          const SizedBox(height: FgSpacing.s),
          const _DecorShopSection(),
        ],
      ),
    );
  }
}

class _DecorShopSection extends ConsumerWidget {
  const _DecorShopSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(decorRepositoryProvider);
    final notifier = ref.read(decorRepositoryProvider.notifier);
    return Column(
      children: [
        for (final spec in kDecorCatalog)
          Padding(
            padding: const EdgeInsets.only(bottom: FgSpacing.s),
            child: PixelPanel(
              child: Row(
                children: [
                  Text(spec.glyph, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: FgSpacing.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(spec.label, style: FgTypography.bodyM),
                        Text(
                          '${Money.cents(spec.priceCents).formatEur()}  '
                          '·  besitzt: ${notifier.zimmerCountOf(spec.id)}',
                          style: FgTypography.bodyS,
                        ),
                      ],
                    ),
                  ),
                  PixelButton(
                    label: 'Kaufen',
                    background: FgColors.primary,
                    foreground: FgColors.onPrimary,
                    onPressed: () async {
                      final ok = await notifier.buyForZimmer(spec);
                      if (!context.mounted) return;
                      showFgSnack(
                        context,
                        ok
                            ? '${spec.label} gekauft ✓'
                            : 'Nicht genug Geld oder Cap erreicht',
                        isError: !ok,
                      );
                    },
                  ),
                  if (notifier.zimmerCountOf(spec.id) > 0) ...[
                    const SizedBox(width: FgSpacing.xs),
                    PixelButton(
                      label: '−50%',
                      background: FgColors.alert,
                      foreground: FgColors.onSurface,
                      onPressed: () async {
                        await notifier.sellOneFromZimmer(spec.id);
                        if (!context.mounted) return;
                        showFgSnack(
                          context,
                          '${spec.label} verkauft '
                          '(+${(spec.priceCents ~/ 2 / 100).toStringAsFixed(2)} €)',
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ShopRow extends StatelessWidget {
  const _ShopRow({
    required this.item,
    required this.owned,
    required this.visible,
    required this.onBuy,
    required this.onSell,
    required this.onToggleVisible,
  });

  final FurnitureItem item;
  final bool owned;
  final bool visible;
  final VoidCallback onBuy;
  final VoidCallback onSell;
  final VoidCallback onToggleVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.s),
      child: PixelPanel(
        // v29: vertical layout damit 2 owned-Buttons nicht überlaufen.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FurnitureSprite(item: item, size: 40),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: FgTypography.bodyM),
                      Text(item.price.formatEur(),
                          style: FgTypography.bodyS),
                    ],
                  ),
                ),
                if (owned && visible)
                  const Text('📍 im Zimmer', style: FgTypography.bodyS),
              ],
            ),
            const SizedBox(height: FgSpacing.s),
            Wrap(
              spacing: FgSpacing.xs,
              runSpacing: FgSpacing.xs,
              children: [
                if (owned) ...[
                  PixelButton(
                    label: visible ? '👁 Verstecken' : '👁 Anzeigen',
                    background:
                        visible ? FgColors.neutral : FgColors.success,
                    foreground: FgColors.onSurface,
                    onPressed: onToggleVisible,
                  ),
                  PixelButton(
                    label: 'Verkaufen 50%',
                    background: FgColors.alert,
                    foreground: FgColors.onSurface,
                    onPressed: onSell,
                  ),
                ] else
                  PixelButton(
                    label: 'Kaufen',
                    background: FgColors.primary,
                    foreground: FgColors.onPrimary,
                    onPressed: onBuy,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
