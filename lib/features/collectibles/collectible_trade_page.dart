import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/collectibles/collectible.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../../domain/forest/tree.dart';
import '../economy/cash_state.dart';
import '../forest/tree_repository.dart';
import 'collectible_repository.dart';

/// Spec-38 Welle 5: Mischwald-Insel = Sammlerobjekte/Sachwerte.
class CollectibleTradePage extends ConsumerWidget {
  const CollectibleTradePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    final holdings = ref.watch(collectibleRepositoryProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final notifier = ref.read(collectibleRepositoryProvider.notifier);

    return PhoneFrame(
      appName: 'Mischwald',
      coachId: 'wald',
      coachTitle: 'Mischwald',
      coachMessage:
          'Pflanze Bäume — sie wachsen langsam, bringen aber jeden Tag '
          'Holz-Einkommen. Mehrere Arten = mehr Streuung. Fällst du, gibt '
          'es Einmal-Erlös. Geduld zahlt sich aus.',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cash ${cash.formatEur()}',
                    style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                const Text(
                  'Zwei Sachen hier: 🌳 Bäume pflanzen für tägliches '
                  'Holz-Einkommen und 🎨 Sammlerobjekte (Oldtimer, Gemälde, '
                  'Briefmarken) langfristig im Wert steigen lassen.',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          const _ForestSection(),
          const SizedBox(height: FgSpacing.m),
          if (holdings.isNotEmpty) ...[
            const Text('Im Besitz', style: FgTypography.display),
            const SizedBox(height: FgSpacing.s),
            for (final h in holdings)
              _OwnedRow(
                holding: h,
                currentValue: notifier.currentValueOf(h, dayIndex),
                yearsHeld: (dayIndex - h.boughtAtDayIndex) / 365.0,
                dayIndex: dayIndex,
                onList: () {
                  final ok = notifier.listForSale(h);
                  if (!context.mounted) return;
                  showFgSnack(
                    context,
                    ok
                        ? '${CollectibleCatalog.byId(h.specId).name} zum Verkauf angeboten'
                        : 'Listing fehlgeschlagen',
                    isError: !ok,
                  );
                },
                onCancel: () {
                  final ok = notifier.cancelListing(h);
                  if (!context.mounted) return;
                  showFgSnack(
                    context,
                    ok ? 'Listing abgebrochen' : 'Abbruch fehlgeschlagen',
                    isError: !ok,
                  );
                },
                onInstantSell: () async {
                  await notifier.instantSell(h);
                  if (!context.mounted) return;
                  showFgSnack(
                    context,
                    '${CollectibleCatalog.byId(h.specId).name} sofort verkauft (−5 % extra)',
                  );
                },
              ),
            const SizedBox(height: FgSpacing.m),
          ],
          const Text('Shop', style: FgTypography.display),
          const SizedBox(height: FgSpacing.s),
          for (final spec in CollectibleCatalog.all)
            _ShopRow(
              spec: spec,
              affordable: cash >= spec.basePrice,
              // v29: Button immer aktiv damit Spieler Feedback bekommt
              // (vorher disabled = sieht aus als wäre der Bug).
              onBuy: () async {
                if (cash < spec.basePrice) {
                  final missing = spec.basePrice - cash;
                  showFgSnack(
                    context,
                    'Brauchst ${missing.formatEur()} mehr',
                    isError: true,
                  );
                  return;
                }
                final ok = await notifier.buy(spec);
                if (!context.mounted) return;
                showFgSnack(context,
                    ok ? '${spec.name} gekauft' : 'Kauf fehlgeschlagen',
                    isError: !ok);
              },
            ),
        ],
      ),
    );
  }
}

class _OwnedRow extends StatelessWidget {
  const _OwnedRow({
    required this.holding,
    required this.currentValue,
    required this.yearsHeld,
    required this.dayIndex,
    required this.onList,
    required this.onCancel,
    required this.onInstantSell,
  });
  final CollectibleHolding holding;
  final Money currentValue;
  final double yearsHeld;
  final int dayIndex;
  final VoidCallback onList;
  final VoidCallback onCancel;
  final VoidCallback onInstantSell;

  @override
  Widget build(BuildContext context) {
    final spec = CollectibleCatalog.byId(holding.specId);
    final pnl = currentValue - holding.boughtPrice;
    final listedOn = holding.listedOnDay;
    final isListed = listedOn != null;
    final daysRemaining = isListed
        ? (spec.sellDelayDays - (dayIndex - listedOn)).clamp(0, 999)
        : 0;
    final statusLabel = isListed
        ? 'Im Verkauf — noch $daysRemaining Tag${daysRemaining == 1 ? '' : 'e'}'
        : 'Im Besitz';

    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.s),
      child: PixelPanel(
        background: FgColors.backgroundDeep,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(spec.glyph, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(spec.name, style: FgTypography.bodyM),
                      Text(
                        'Wert: ${currentValue.formatEur()}  ·  Gehalten ${yearsHeld.toStringAsFixed(1)} J',
                        style: FgTypography.bodyS,
                      ),
                      Text(
                        'GuV ${pnl.formatEur()}',
                        style: FgTypography.bodyS.copyWith(
                          color: pnl.cents >= 0
                              ? FgColors.success
                              : FgColors.alert,
                        ),
                      ),
                      Text(
                        statusLabel,
                        style: FgTypography.bodyS.copyWith(
                          color: isListed
                              ? FgColors.primary
                              : FgColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: FgSpacing.s),
            Wrap(
              spacing: FgSpacing.s,
              runSpacing: FgSpacing.xs,
              children: isListed
                  ? [
                      PixelButton(
                        label: '↩ Verkauf abbrechen',
                        background: FgColors.neutral,
                        foreground: FgColors.onSurface,
                        onPressed: onCancel,
                      ),
                      PixelButton(
                        label: '⚡ Schnell weg (5 % weniger)',
                        background: FgColors.alert,
                        foreground: FgColors.onSurface,
                        onPressed: onInstantSell,
                      ),
                    ]
                  : [
                      PixelButton(
                        label: '🏷 Zum Verkauf anbieten',
                        background: FgColors.primary,
                        foreground: FgColors.onPrimary,
                        onPressed: onList,
                      ),
                      PixelButton(
                        label: '⚡ Schnell weg (5 % weniger)',
                        background: FgColors.alert,
                        foreground: FgColors.onSurface,
                        onPressed: onInstantSell,
                      ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopRow extends StatelessWidget {
  const _ShopRow({
    required this.spec,
    required this.affordable,
    required this.onBuy,
  });
  final CollectibleSpec spec;
  final bool affordable;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Text(spec.name, style: FgTypography.bodyM),
                  Text(spec.description, style: FgTypography.bodyS),
                  Text(
                    'Preis ${spec.basePrice.formatEur()}  ·  '
                    '+${spec.annualGrowthPct.toStringAsFixed(1)} %/Jahr',
                    style: FgTypography.bodyS,
                  ),
                ],
              ),
            ),
            PixelButton(
              label: 'Kaufen',
              background:
                  affordable ? FgColors.primary : FgColors.neutral,
              foreground: FgColors.onPrimary,
              onPressed: onBuy,
            ),
          ],
        ),
      ),
    );
  }
}

/// Spec-45 H3: Mischwald-Wald-Wirtschaft. Bäume pflanzen → täglich
/// Holz-Income nach Reife.
class _ForestSection extends ConsumerWidget {
  const _ForestSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trees = ref.watch(treeRepositoryProvider);
    final notifier = ref.read(treeRepositoryProvider.notifier);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final mature = notifier.matureCount(dayIndex);
    final growing = notifier.growingCount(dayIndex);
    final dailyTotal = trees
        .where((t) => t.isMature(dayIndex))
        .fold<int>(0,
            (sum, t) => sum + TreeCatalog.spec(t.kind).dailyYield.cents);
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌳 Wald-Wirtschaft', style: FgTypography.bodyL),
              const Spacer(),
              Text(
                'reif: $mature · wächst: $growing',
                style: FgTypography.bodyS,
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            dailyTotal > 0
                ? '🪵 Holz-Einkommen heute: '
                    '${Money.cents(dailyTotal).formatEur()} pro Tag'
                : 'Noch keine reifen Bäume. Pflanze welche!',
            style: FgTypography.bodyS.copyWith(
              color: dailyTotal > 0 ? FgColors.success : FgColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          for (final spec in TreeCatalog.all) ...[
            _TreeBuyRow(spec: spec),
            const SizedBox(height: FgSpacing.xs),
          ],
          if (trees.isNotEmpty) ...[
            const SizedBox(height: FgSpacing.s),
            const Text('Deine Bäume', style: FgTypography.bodyM),
            const SizedBox(height: FgSpacing.xs),
            for (final t in trees)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(TreeCatalog.spec(t.kind).emoji,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: FgSpacing.s),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TreeCatalog.spec(t.kind).displayName,
                              style: FgTypography.bodyM),
                          if (t.isMature(dayIndex))
                            Text(
                              '✅ REIF — ${TreeCatalog.spec(t.kind).dailyYield.formatEur()}/Tag',
                              style: FgTypography.bodyS
                                  .copyWith(color: FgColors.success),
                            )
                          else
                            Text(
                              '⏳ reif in ${t.daysUntilMature(dayIndex)} Tagen',
                              style: FgTypography.bodyS
                                  .copyWith(color: FgColors.alert),
                            ),
                          // Der Erlös MUSS vor dem Antippen sichtbar sein —
                          // Fällen ist unumkehrbar, und vorher war es ein
                          // Totalverlust, den niemand kommen sah.
                          Text(
                            'Fällen bringt '
                            '${t.fellingValue(dayIndex).formatEur()}',
                            style: FgTypography.bodyS,
                          ),
                        ],
                      ),
                    ),
                    if (t.isMature(dayIndex))
                      GestureDetector(
                        onTap: () {
                          try {
                            final payout = ref
                                .read(treeRepositoryProvider.notifier)
                                .fellTree(t.id, dayIndex);
                            showFgSnack(
                              context,
                              'Baum gefällt: +${payout.formatEur()}',
                            );
                          } on TreeError catch (e) {
                            showFgSnack(context, e.message, isError: true);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: FgColors.alert,
                            border:
                                Border.all(color: FgColors.outline, width: 2),
                          ),
                          child: const Text('🪓 Fällen',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TreeBuyRow extends ConsumerWidget {
  const _TreeBuyRow({required this.spec});
  final TreeSpec spec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    final canBuy = cash >= spec.cost;
    return Row(
      children: [
        Text(spec.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: FgSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(spec.displayName, style: FgTypography.bodyS),
              Text(
                '${spec.cost.formatEur()} · reif nach ${spec.maturityDays} '
                'Tagen · ${spec.dailyYield.formatEur()}/Tag',
                style: FgTypography.bodyS.copyWith(color: FgColors.onSurfaceMuted),
              ),
              Text(
                '≈ ${(spec.dailyYield.cents * 365 / spec.cost.cents * 100).toStringAsFixed(0)} %/Jahr Rendite (ab Reife)',
                style: FgTypography.bodyS.copyWith(color: FgColors.success),
              ),
            ],
          ),
        ),
        PixelButton(
          label: 'Pflanzen',
          background: FgColors.success,
          onPressed: canBuy
              ? () {
                  try {
                    final dayIndex =
                        ref.read(gameClockProvider).dayIndex;
                    ref
                        .read(treeRepositoryProvider.notifier)
                        .plant(spec.kind, dayIndex);
                    showFgSnack(context, '${spec.displayName} gepflanzt 🌱');
                  } on TreeError catch (e) {
                    showFgSnack(context, e.message, isError: true);
                  }
                }
              : null,
        ),
      ],
    );
  }
}
