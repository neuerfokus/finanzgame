import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/plant/plant.dart';
import '../../game/monetaria/islands/spar_island_world.dart';
import '../../game/monetaria/state/monetaria_state.dart';
import '../../game/monetaria/state/monetaria_unlocker.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/money_header.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../bank/savings_repository.dart';
import '../economy/cash_state.dart';
import '../etf/etf_trade_page.dart';
import '../settings/settings_repository.dart';
import '../skills/skill_tree_data.dart';
import 'island_header.dart';
import '../plant/plant_plot_widget.dart';
import '../plant/plant_repository.dart';
import '../plant/planting_menu.dart';
import '../collectibles/collectible_trade_page.dart';
import '../crypto/crypto_trade_page.dart';
import '../metal/metal_trade_page.dart';
import '../newgame/new_game_state.dart';
import '../realestate/real_estate_trade_page.dart';
import '../stock/stock_trade_page.dart';
import '../wishlist/wishlist_page.dart';

/// Round 28: Gratis-Beete aus Skills — „Grüner Daumen" (+1) und Prestige
/// „Spar-Großmeister" (+1) stapeln. Zählen NICHT in die Kauf-Ökonomie.
int _bonusPlots(SettingsRepository settings) =>
    (settings.hasSkill(SkillEffects.bonusPlot) ? 1 : 0) +
    (settings.hasSkill(SkillEffects.bonusPlot2) ? 1 : 0);

class IslandPage extends ConsumerStatefulWidget {
  const IslandPage({required this.islandId, super.key});

  final String islandId;

  @override
  ConsumerState<IslandPage> createState() => _IslandPageState();
}

class _IslandPageState extends ConsumerState<IslandPage> {

  String get _label => switch (widget.islandId) {
        IslandId.heimathafen => 'Heimathafen',
        IslandId.sparInsel => 'Spar-Insel',
        IslandId.mischwald => 'Mischwald',
        IslandId.etfInsel => 'ETF-Insel',
        IslandId.inflationAtoll => 'Inflations-Atoll',
        IslandId.aktienArchipel => 'Aktien-Archipel',
        IslandId.vulkan => 'Vulkan-Insel',
        IslandId.goldmine => 'Goldminen-Insel',
        _ => widget.islandId,
      };

  @override
  Widget build(BuildContext context) {
    // Spec-13: defensive guard — if the page is opened for a still-locked
    // island (deep link, hot reload, future router shortcut), bounce back
    // with a SnackBar instead of leaking the trade UI.
    final isUnlocked = ref
        .watch(monetariaStateProvider.notifier)
        .isUnlocked(widget.islandId);
    if (!isUnlocked) {
      return _LockedIslandView(label: _label, islandId: widget.islandId);
    }

    // Heimathafen hat keine eigene Seite mehr — MonetariaPage._openIsland
    // springt direkt zum Springboard (siehe dort). Landet man doch hier
    // (Deep-Link/Alt-Route), tun wir dasselbe statt eine leere Seite zu zeigen.
    if (widget.islandId == IslandId.heimathafen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      });
      return const SizedBox.shrink();
    }
    if (widget.islandId == IslandId.etfInsel) {
      return const EtfTradePage();
    }
    if (widget.islandId == IslandId.inflationAtoll) {
      return const WishlistPage();
    }
    if (widget.islandId == IslandId.aktienArchipel) {
      return const StockTradePage();
    }
    if (widget.islandId == IslandId.vulkan) {
      final dayIndex = ref.read(gameClockProvider).dayIndex;
      return CryptoTradePage(currentDayIndex: dayIndex);
    }
    if (widget.islandId == IslandId.goldmine) {
      return const MetalTradePage();
    }
    if (widget.islandId == IslandId.wohnviertel) {
      return const RealEstateTradePage();
    }
    if (widget.islandId == IslandId.mischwald) {
      return const CollectibleTradePage();
    }
    final isSpar = widget.islandId == IslandId.sparInsel;

    if (isSpar) {
      final purchasedPlots =
          ref.watch(settingsRepositoryProvider).sparPlotCount;
      // Round 28: Skill „Grüner Daumen" (+1) und Prestige „Spar-Großmeister"
      // (+1) geben Gratis-Beete. Nur nutzbar, zählen NICHT in die Kauf-
      // Ökonomie (purchasedPlots steuert Preis).
      final plotCount = purchasedPlots +
          _bonusPlots(ref.read(settingsRepositoryProvider.notifier)) +
          ref.watch(newGameStateProvider).legacyStartPlotCount;
      final plants = ref.watch(plantRepositoryProvider);
      final cash = ref.watch(cashStateProvider);
      final sparDayIndex = ref.watch(gameClockProvider).dayIndex;
      return PhoneFrame(
        appName: _label,
        onBack: () => Navigator.of(context).pop(),
        child: SingleChildScrollView(
          // Welle-8 Round 17: ganze Seite scrollbar — Grid + Buttons +
          // Footer in einem Scroll-Container, Grid feste Cell-Größe.
          child: Column(
          children: [
            IslandHeader.forId(widget.islandId),
            MoneyHeader(cash: cash, savings: ref.watch(savingsRepositoryProvider)),
            _SparIslandGrid(
              plotCount: plotCount,
              plants: plants,
              onEmptyTap: _onEmptyPlot,
              onReadyTap: _onReadyPlot,
              currentDayIndex: sparDayIndex,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: FgSpacing.s, vertical: FgSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: PixelButton(
                      label: '🌾 Alle reifen ernten',
                      background: FgColors.success,
                      foreground: Colors.black,
                      onPressed: _harvestAll,
                    ),
                  ),
                  const SizedBox(width: FgSpacing.xs),
                  Expanded(
                    child: PixelButton(
                      label: '🌱 Alle leeren bepflanzen',
                      background: FgColors.info,
                      foreground: Colors.black,
                      onPressed: _plantAllEmpty,
                    ),
                  ),
                  const SizedBox(width: FgSpacing.xs),
                  // Welle-8: Plot-Reset kompakt als Icon-Button neben Ernte.
                  GestureDetector(
                    onTap: _confirmClearWithered,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: FgColors.alert,
                        border: Border.all(
                            color: FgColors.outline, width: 2),
                      ),
                      child: const Text('🧹',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
            _PlotPurchaseRow(
              purchased: purchasedPlots,
              bonus: plotCount - purchasedPlots,
            ),
          ],
        ),
        ),
      );
    }

    return PhoneFrame(
      appName: _label,
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          IslandHeader.forId(widget.islandId),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(FgSpacing.xl),
                child: PixelPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_label, style: FgTypography.displayLarge),
                      const SizedBox(height: FgSpacing.l),
                      const Text(
                        'Hier wird bald was wachsen.',
                        style: FgTypography.bodyL,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: FgSpacing.s),
                      const Text(
                        '(Insel-Inhalte folgen in späteren Sprints.)',
                        style: FgTypography.bodyS,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onEmptyPlot(int plotIndex) async {
    final kind = await PlantingMenu.show(context);
    if (kind == null || !mounted) return;
    final day = ref.read(gameClockProvider).dayIndex;
    try {
      ref.read(plantRepositoryProvider.notifier).plant(
        islandId: SparIslandWorld.islandId,
        plotIndex: plotIndex,
        kind: kind,
        dayIndex: day,
      );
      // Spec-43 v8: Erfolgs-Snackbar entfernt (User-Feedback).
      // Welle-7: Flutter-Grid rebuilt automatisch via ref.watch.
    } on PlantingError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fehler: ${e.message}',
            style: FgTypography.bodyM,
          ),
          backgroundColor: FgColors.alert,
        ),
      );
    }
  }

  Future<void> _onReadyPlot(int plotIndex) async {
    final plant = ref
        .read(plantRepositoryProvider.notifier)
        .plantInPlot(SparIslandWorld.islandId, plotIndex);
    if (plant == null || plant.status != PlantStatus.ready) return;

    ref.read(plantRepositoryProvider.notifier).harvest(plant.id);
  }

  /// Welle-8 Round 17: Alle leeren Plots mit derselben Pflanze bestellen.
  /// User wählt eine Pflanze, App pflanzt sie in jeden freien Plot
  /// (cash + season + plot-availability werden pro Plot geprüft).
  Future<void> _plantAllEmpty() async {
    final kind = await PlantingMenu.show(context);
    if (kind == null || !mounted) return;
    final day = ref.read(gameClockProvider).dayIndex;
    final repo = ref.read(plantRepositoryProvider.notifier);
    final plotCount = ref.read(settingsRepositoryProvider).sparPlotCount +
        _bonusPlots(ref.read(settingsRepositoryProvider.notifier)) +
        ref.read(newGameStateProvider).legacyStartPlotCount;
    var planted = 0;
    var failedReason = '';
    for (var i = 0; i < plotCount; i++) {
      final occupied =
          repo.plantInPlot(SparIslandWorld.islandId, i) != null;
      if (occupied) continue;
      try {
        repo.plant(
          islandId: SparIslandWorld.islandId,
          plotIndex: i,
          kind: kind,
          dayIndex: day,
        );
        planted++;
      } on PlantingError catch (e) {
        failedReason = e.message;
        // Bei "insufficient cash" oder "Falsche Jahreszeit" abbrechen —
        // weitere Versuche scheitern aus dem gleichen Grund.
        if (e.message.contains('cash') || e.message.contains('Jahreszeit')) {
          break;
        }
      }
    }
    if (!mounted) return;
    if (planted == 0) {
      showFgSnack(
        context,
        failedReason.isEmpty
            ? 'Keine leeren Felder zum Bepflanzen.'
            : 'Konnte nichts bepflanzen: $failedReason',
        isError: true,
      );
      return;
    }
    showFgSnack(
      context,
      '🌱 $planted Feld${planted == 1 ? '' : 'er'} bepflanzt.',
    );
  }

  /// Spec-43 v9: Alle reifen Pflanzen auf einmal ernten.
  Future<void> _harvestAll() async {
    final plants = ref.read(plantRepositoryProvider);
    final repo = ref.read(plantRepositoryProvider.notifier);
    final ready = plants
        .where(
          (p) =>
              p.islandId == SparIslandWorld.islandId &&
              p.status == PlantStatus.ready,
        )
        .toList();
    if (ready.isEmpty) {
      if (mounted) {
        showFgSnack(context, 'Nichts zu ernten — keine Pflanze reif.');
      }
      return;
    }
    var totalCents = 0;
    var harvestedCount = 0;
    for (final p in ready) {
      final result = repo.harvest(p.id);
      totalCents += result.yield_.cents;
      harvestedCount++;
    }
    if (!mounted) return;
    final yieldStr = Money.cents(totalCents).formatEur();
    showFgSnack(
      context,
      '🌾 $harvestedCount geerntet · +$yieldStr',
    );
  }

  /// 2026-06-04 (Sohn-Feedback): 🧹 räumt nur VERDORRTE Felder auf — wachsende
  /// und reife Pflanzen bleiben stehen (vorher löschte der Button ALLES, auch
  /// laufende Ernten). Cash + XP unverändert.
  Future<void> _confirmClearWithered() async {
    final witheredCount = ref
        .read(plantRepositoryProvider)
        .where((p) =>
            p.islandId == SparIslandWorld.islandId &&
            p.status == PlantStatus.withered)
        .length;
    if (witheredCount == 0) {
      showFgSnack(context, 'Keine verdorrten Felder zum Aufräumen. 🌱');
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('🧹 Verdorrte Felder aufräumen?',
            style: FgTypography.bodyL),
        content: Text(
          'Entfernt $witheredCount verdorrte'
          '${witheredCount == 1 ? 's Feld' : ' Felder'}. '
          'Wachsende und reife Pflanzen bleiben stehen. '
          'Cash + XP bleiben gleich.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Ja, aufräumen',
                style: FgTypography.bodyM
                    .copyWith(color: FgColors.alert)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final removed = await ref
        .read(plantRepositoryProvider.notifier)
        .clearWithered(SparIslandWorld.islandId);
    if (!mounted) return;
    showFgSnack(
      context,
      '🧹 $removed verdorrte${removed == 1 ? 's Feld' : ' Felder'} aufgeräumt',
    );
  }
}

/// Spec-43 follow-up: Footer auf Sparinsel mit Plot-Kauf-Button.
class _PlotPurchaseRow extends ConsumerWidget {
  const _PlotPurchaseRow({required this.purchased, required this.bonus});

  /// Gekaufte Beete (steuern Preis + 18er-Kauf-Cap).
  final int purchased;

  /// Gratis-Beete aus Skill-Baum/Prestige/Vermächtnis — liegen ON TOP der 18
  /// und erklären, warum das Grid (und „Alle bepflanzen") mehr als 18 zeigen
  /// kann. Ohne Hinweis wirkte die 20 wie ein Bug.
  final int bonus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsRepositoryProvider.notifier);
    final preview = settings.sparPlotCostPreview();
    if (preview == null) {
      final total = purchased + bonus;
      return Padding(
        padding: const EdgeInsets.all(FgSpacing.s),
        child: Text(
          bonus > 0
              ? '🌱 Maximal gekauft: 18 · +$bonus Bonus-Beet'
                  '${bonus == 1 ? '' : 'e'} = $total Felder'
              : '🌱 Maximum: 18 Felder erreicht',
          style: FgTypography.bodyM,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(FgSpacing.s),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Felder: $purchased/18'
              '${bonus > 0 ? ' +$bonus 🎁' : ''}  ·  Nächstes: '
              '${preview.cost} XP · Lvl ${preview.minLevel}',
              style: FgTypography.bodyS,
            ),
          ),
          PixelButton(
            label: '🌱+ Feld',
            background: FgColors.success,
            foreground: Colors.black,
            onPressed: () {
              final ok = settings.purchaseSparPlot();
              if (ok) {
                showFgSnack(context, 'Feld gekauft ✓');
              } else {
                showFgSnack(
                  context,
                  'Zu wenig XP oder Level',
                  isError: true,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Locked-island fallback view: shows a hint and pops back to Monetaria.
///
/// Surfaces a SnackBar on first frame so the player gets feedback even
/// if the page is reached via deep link or hot-reload (spec-13).
class _LockedIslandView extends StatefulWidget {
  const _LockedIslandView({required this.label, required this.islandId});

  final String label;
  final String islandId;

  @override
  State<_LockedIslandView> createState() => _LockedIslandViewState();
}

class _LockedIslandViewState extends State<_LockedIslandView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Noch verschlossen — siehe Hinweis im Heimathafen-Quest.',
            style: FgTypography.bodyM,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhoneFrame(
      appName: widget.label,
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          IslandHeader.forId(widget.islandId),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(FgSpacing.xl),
                child: PixelPanel(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔒', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: FgSpacing.m),
                      Text(widget.label, style: FgTypography.displayLarge),
                      const SizedBox(height: FgSpacing.l),
                      const Text(
                        'Noch verschlossen.',
                        style: FgTypography.bodyL,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: FgSpacing.m),
                      // spec-33: show the unlock criterion explicitly so
                      // the player knows what to do next.
                      Text(
                        MonetariaUnlocker.criterionFor(widget.islandId) ??
                            'Mach weiter, dann öffnet sich diese Insel.',
                        style: FgTypography.bodyM,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Spec-45 Welle-7: Plot-Grid in Flutter (statt Flame). Horizontal scrollend.
/// Cells fix 160×160 — bei mehr Plots wächst Grid nach rechts, bestehende
/// Cells bleiben gleich groß.
class _SparIslandGrid extends StatelessWidget {
  const _SparIslandGrid({
    required this.plotCount,
    required this.plants,
    required this.onEmptyTap,
    required this.onReadyTap,
    required this.currentDayIndex,
  });

  final int plotCount;
  final List<Plant> plants;
  final void Function(int plotIndex) onEmptyTap;
  final void Function(int plotIndex) onReadyTap;
  final int currentDayIndex;

  static const String _islandId = 'spar_insel';

  @override
  Widget build(BuildContext context) {
    // Welle-8 Round 17: shrinkWrap + NeverScrollable — Parent-Page
    // scrollt jetzt, Grid zeigt feste Cell-Größe statt zu schrumpfen
    // wenn Buttons unten Platz fressen.
    return Container(
      color: const Color(0xFF7BC383),
      padding: const EdgeInsets.all(FgSpacing.s),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemCount: plotCount,
        itemBuilder: (_, i) {
              // Welle-8: bevorzuge active (growing/ready) über withered.
              // Sonst zeigt UI alte verdorrte Reste obwohl frische Pflanze
              // im Plot ist (z.B. nach Storm-Race).
              final inPlot = plants.where((pl) =>
                  pl.islandId == _islandId &&
                  pl.plotIndex == i &&
                  pl.status != PlantStatus.harvested);
              final active = inPlot.where((pl) =>
                  pl.status == PlantStatus.growing ||
                  pl.status == PlantStatus.ready);
              final p = active.firstOrNull ?? inPlot.firstOrNull;
          return PlantPlotWidget(
            plotIndex: i,
            plant: p,
            onEmptyTap: onEmptyTap,
            onReadyTap: onReadyTap,
            currentDayIndex: currentDayIndex,
          );
        },
      ),
    );
  }
}
