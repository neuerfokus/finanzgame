import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/plant/plant.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import 'plant_pricing.dart';

/// Bottom-sheet shown when the player taps an empty plot. Lists available
/// [PlantKind]s with their cost; tapping "Pflanzen" returns the chosen kind.
class PlantingMenu extends ConsumerWidget {
  const PlantingMenu({super.key});

  static Future<PlantKind?> show(BuildContext context) {
    return showModalBottomSheet<PlantKind>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const PlantingMenu(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final pricing = PlantPricing(dayIndex);
    final season = seasonForDayIndex(dayIndex);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: PixelPanel(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Pflanzen-Shop', style: FgTypography.display),
                const SizedBox(height: FgSpacing.s),
                Text('Aktuelle Saison: ${season.label}',
                    style: FgTypography.bodyM.copyWith(
                      color: FgColors.primary,
                      fontWeight: FontWeight.bold,
                    )),
                Text('Cash: ${cash.formatEur()}',
                    style: FgTypography.bodyS),
                Text(
                  'Samen-Preise folgen der Inflation — früh pflanzen lohnt.',
                  style: FgTypography.bodyS.copyWith(color: FgColors.info),
                ),
                const SizedBox(height: FgSpacing.s),
                // Welle-8 Round 23: Saison-Tipps. ExpansionTile listet
                // alle 4 Jahreszeiten + welche Pflanzen jeweils gehen.
                _SaisonTippsBox(current: season, dayIndex: dayIndex),
                const SizedBox(height: FgSpacing.m),
                for (final spec in PlantKinds.all) ...[
                  _Row(
                    spec: spec,
                    currentCost: pricing.costFor(spec),
                    currentYield: pricing.yieldFor(spec),
                    affordable: cash >= pricing.costFor(spec),
                    inSeason: spec.seasons.contains(season),
                  ),
                  const SizedBox(height: FgSpacing.s),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SaisonTippsBox extends StatelessWidget {
  const _SaisonTippsBox({required this.current, required this.dayIndex});
  final Season current;
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    final dayOfYear = dayIndex % 365;
    int boundary;
    if (dayOfYear < 90) {
      boundary = 90;
    } else if (dayOfYear < 180) {
      boundary = 180;
    } else if (dayOfYear < 270) {
      boundary = 270;
    } else {
      boundary = 365;
    }
    final daysLeft = boundary - dayOfYear;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(top: FgSpacing.xs),
        iconColor: FgColors.primary,
        collapsedIconColor: FgColors.onSurface,
        title: Text(
          '🌱 Saison-Tipps (noch $daysLeft Tage)',
          style: FgTypography.bodyM.copyWith(color: FgColors.info),
        ),
        children: [
          for (final s in Season.values)
            Padding(
              padding: const EdgeInsets.only(bottom: FgSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      s.label,
                      style: FgTypography.bodyS.copyWith(
                        color: s == current
                            ? FgColors.success
                            : FgColors.onSurface,
                        fontWeight: s == current
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      PlantKinds.all
                          .where((p) => p.seasons.contains(s))
                          .map((p) => '${p.kind.emoji} ${p.kind.displayName}')
                          .join(' · '),
                      style: FgTypography.bodyS,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: FgSpacing.xs),
            child: Text(
              'Tipp: nur in der passenden Saison pflanzbar. '
              'Wetter (Sonne/Sturm) beeinflusst Wachstum.',
              style: FgTypography.bodyS.copyWith(color: FgColors.onSurfaceMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.spec,
    required this.currentCost,
    required this.currentYield,
    required this.affordable,
    required this.inSeason,
  });

  final PlantKindSpec spec;
  final Money currentCost;
  final Money currentYield;
  final bool affordable;
  final bool inSeason;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: inSeason ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(FgSpacing.s),
        decoration: BoxDecoration(
          color: FgColors.backgroundDeep,
          border: Border.all(
            color: inSeason ? FgColors.outline : FgColors.neutral,
            width: 2,
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(FgRadius.tight)),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(spec.kind.emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(spec.kind.displayName,
                    style: FgTypography.bodyL),
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text('Kosten: ${currentCost.formatEur()}',
              style: FgTypography.bodyS),
          Text('Wachstum: ${spec.growDays} Tage',
              style: FgTypography.bodyS),
          Text('Ertrag: ${currentYield.formatEur()}',
              style: FgTypography.bodyS),
          // Spec-41 follow-up: Rendite pro Wachstumszyklus + pro Tag.
          () {
            final gain = currentYield.cents - currentCost.cents;
            final cyclePct = currentCost.cents > 0
                ? gain * 100 / currentCost.cents
                : 0.0;
            final dailyPct = cyclePct / spec.growDays;
            return Text(
              'Rendite: ${cyclePct.toStringAsFixed(1)} % / Zyklus '
              '· ${dailyPct.toStringAsFixed(2)} % / Tag',
              style: FgTypography.bodyS.copyWith(
                color: gain >= 0 ? FgChart.up : FgChart.down,
              ),
            );
          }(),
          if (spec.weatherSensitivity != 0)
            Text(
              spec.weatherSensitivity > 0
                  ? 'Wetter-sensibel ☀ (Sonne hilft, Sturm stoppt)'
                  : 'Robust 🌵 (auch bei Sturm okay)',
              style: FgTypography.bodyS.copyWith(color: FgColors.info),
            ),
          Text(
            'Saison: ${spec.seasons.map((s) => s.label).join(", ")}',
            style: FgTypography.bodyS.copyWith(
              color: inSeason ? FgColors.success : FgColors.alert,
            ),
          ),
          if (!inSeason)
            Text(
              '🚫 Nicht in der aktuellen Jahreszeit pflanzbar',
              style: FgTypography.bodyS.copyWith(color: FgColors.alert),
            ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: inSeason ? 'Pflanzen' : 'Falsche Saison',
            background:
                inSeason ? FgColors.primary : FgColors.neutral,
            foreground: FgColors.onPrimary,
            onPressed: (affordable && inSeason)
                ? () => Navigator.of(context).pop(spec.kind)
                : null,
          ),
        ],
        ),
      ),
    );
  }
}
