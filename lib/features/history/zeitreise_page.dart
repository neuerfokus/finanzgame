import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../bank/savings_repository.dart';
import '../collectibles/collectible_repository.dart';
import '../crypto/crypto_repository.dart';
import '../forest/tree_repository.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../vorsorge/vorsorge_repository.dart';
import '../etf/etf_repository.dart';
import '../settings/settings_repository.dart';
import '../stock/stock_repository.dart';
import '../wishlist/wishlist_repository.dart';
import 'asset_labels.dart';
import 'ghost_paths.dart';
import 'history_repository.dart';
import 'opportunity_costs.dart';

/// Spec-19: multi-asset Zeitreise (time-travel) chart.
///
/// - Top chip row toggles which aggregate assets are drawn.
/// - Center: line chart with one path per selected asset, € on the Y
///   axis, vertical red dashes on crash days.
/// - Bottom: legend with current value + Δ since the start of the
///   visible window.
/// - First open shows a one-shot tutorial overlay; tap dismisses and
///   persists `zeitreiseTutorialSeen = true`.
class ZeitreisePage extends ConsumerStatefulWidget {
  const ZeitreisePage({super.key});

  @override
  ConsumerState<ZeitreisePage> createState() => _ZeitreisePageState();
}

class _ZeitreisePageState extends ConsumerState<ZeitreisePage> {
  static const _maxSelected = 4;

  /// Currently selected asset IDs (max [_maxSelected]). Initialised in
  /// [didChangeDependencies] once we can read the providers.
  late Set<String> _selected = const {};
  bool _selectionInit = false;
  bool _tutorialDismissed = false;
  // Bug-fix v28: Geisterlinien per Toggle (default off) — wurden
  // automatisch mit eigener Y-Skala gezeichnet und überlagerten die
  // echten Linien optisch verwirrend.
  bool _showGhosts = false;
  // Spec-44 E1: zusätzlicher Toggle für die Konsum-Schattenlinie. Default
  // off — die Lehrlinie ploppt nicht ungefragt auf, sondern auf Wunsch.
  bool _showConsumptionShadow = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectionInit) return;
    // spec-34: pre-select only the asset classes the player actually has
    // holdings in so the chart reads like a personal portfolio review.
    final available = ref
        .read(historyRepositoryProvider.notifier)
        .assetIdsAvailable
        .toSet();
    final picked = <String>{};
    // Cash is always relevant.
    if (available.contains(HistoryAssetIds.cash)) {
      picked.add(HistoryAssetIds.cash);
    }
    final hasEtf =
        ref.read(etfRepositoryProvider).holdings.isNotEmpty;
    final hasStock =
        ref.read(stockRepositoryProvider).holdings.isNotEmpty;
    final hasSavings =
        ref.read(savingsRepositoryProvider).cents > 0;
    if (hasEtf && available.contains(HistoryAssetIds.etfIndex)) {
      picked.add(HistoryAssetIds.etfIndex);
    }
    if (hasStock && available.contains(HistoryAssetIds.stockIndex)) {
      picked.add(HistoryAssetIds.stockIndex);
    }
    if (hasSavings && available.contains(HistoryAssetIds.sparYield)) {
      picked.add(HistoryAssetIds.sparYield);
    }
    // 2026-08: die übrigen Klassen genauso vorauswählen, wenn Bestand da ist.
    // Vorher endete die Liste bei Aktien — wer sein Geld in Gold, Krypto oder
    // eine Wohnung gesteckt hatte, musste die Linie erst von Hand suchen (und
    // vorher gab es sie gar nicht).
    void pickIfOwned(String id, bool owned) {
      if (owned && available.contains(id)) picked.add(id);
    }

    pickIfOwned(HistoryAssetIds.cryptoIndex,
        ref.read(cryptoRepositoryProvider).holdings.isNotEmpty);
    pickIfOwned(HistoryAssetIds.metalIndex,
        ref.read(metalRepositoryProvider).holdings.isNotEmpty);
    pickIfOwned(HistoryAssetIds.realEstateIndex,
        ref.read(realEstateRepositoryProvider).isNotEmpty);
    pickIfOwned(HistoryAssetIds.vorsorgeIndex,
        ref.read(vorsorgeRepositoryProvider).isNotEmpty);
    pickIfOwned(HistoryAssetIds.collectibleIndex,
        ref.read(collectibleRepositoryProvider).isNotEmpty);
    pickIfOwned(HistoryAssetIds.treeIndex,
        ref.read(treeRepositoryProvider).isNotEmpty);
    if (picked.isEmpty) {
      picked.addAll(
        available
            .where((id) => id != HistoryAssetIds.crashMarker)
            .take(3),
      );
    }
    // Mit elf möglichen Reihen kann die Vorauswahl das Chart-Limit sprengen —
    // zehn Linien übereinander liest ohnehin niemand. Es gewinnen die
    // GRÖSSTEN Positionen: das ist der Teil des Vermögens, um den es beim
    // Reinschauen geht. Der Rest bleibt eine Tipp-Bewegung entfernt.
    if (picked.length > _maxSelected) {
      final byValue = picked.toList()
        ..sort((a, b) {
          final va = repoLatest(a);
          final vb = repoLatest(b);
          return vb.compareTo(va);
        });
      picked
        ..clear()
        ..addAll(byValue.take(_maxSelected));
    }
    _selected = picked;
    _selectionInit = true;
  }

  /// Letzter bekannter Wert einer Reihe — nur zum Sortieren der Vorauswahl.
  int repoLatest(String assetId) {
    final pts = ref.read(historyRepositoryProvider.notifier)
        .seriesPoints(assetId);
    return pts.isEmpty ? 0 : pts.last.$2;
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        if (_selected.length >= _maxSelected) return;
        _selected.add(id);
      }
    });
  }

  void _dismissTutorial() {
    if (_tutorialDismissed) return;
    setState(() => _tutorialDismissed = true);
    ref
        .read(settingsRepositoryProvider.notifier)
        .setZeitreiseTutorialSeen(true);
  }

  /// Schattenlinie aus den bereits gekauften Wunsch-Items. Owned-Items
  /// frieren ihren Kaufpreis (`currentPrice`) ein (Wishlist.inflate lässt
  /// sie unverändert) → korrekter "was-hättest-du-investiert"-Wert. Quelle
  /// ist persistent (überlebt Neustart). Führende 0-Punkte (Tage vor dem
  /// ersten Kauf) werden entfernt, damit die Linie sauber am ersten Kauf
  /// beginnt statt am unteren Chart-Rand entlangzulaufen.
  List<(int, int)> _consumptionShadowPoints(
    WidgetRef ref, {
    required int startDayIndex,
    required int endDayIndex,
  }) {
    final owned = ref
        .watch(wishlistRepositoryProvider)
        .where((w) => w.ownedOnDayIndex != null)
        .map((w) => (
              dayIndex: w.ownedOnDayIndex!,
              cents: w.currentPrice.cents,
              label: w.name,
            ))
        .toList();
    final series = OpportunityCosts.shadowSeries(
      log: owned,
      startDayIndex: startDayIndex,
      endDayIndex: endDayIndex,
    );
    final firstNonZero = series.indexWhere((p) => p.$2 > 0);
    if (firstNonZero <= 0) return series;
    return series.sublist(firstNonZero);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for state-change rebuilds.
    ref.watch(historyRepositoryProvider);
    final repo = ref.read(historyRepositoryProvider.notifier);
    final available = repo.assetIdsAvailable;
    final crashDays = repo.crashDays();

    final lines = <ChartLine>[
      for (final id in _selected)
        ChartLine(
          assetId: id,
          color: colorForAsset(id),
          points: repo.seriesPoints(id),
        ),
    ];

    // Sprint C3: Geisterlinien — alles ETF / alles Gold / 60-40 gestreut
    // ausgehend vom Start-Vermögen (erste Bargeld-/Cash-History-Spur,
    // fallback = 25 € Onboarding-Startkapital).
    final cashSeries = repo.seriesPoints(HistoryAssetIds.cash);
    final startCents = cashSeries.isNotEmpty
        ? cashSeries.first.$2
        : GhostPaths.fallbackStartCents;
    final ghostStartDay = cashSeries.isNotEmpty
        ? cashSeries.first.$1
        : 0;
    var ghostDays = 0;
    if (lines.isNotEmpty) {
      final maxDay = lines
          .expand((l) => l.points)
          .map((p) => p.$1)
          .fold<int>(ghostStartDay, (a, b) => b > a ? b : a);
      ghostDays = (maxDay - ghostStartDay) + 1;
    }
    final ghosts = <ChartLine>[
      if (_showGhosts && ghostDays > 1) ...[
        ChartLine(
          assetId: 'ghost_etf',
          color: FgColors.info.withValues(alpha: 0.6),
          points: GhostPaths.compoundDailyFromYearly(
            startCents: startCents,
            days: ghostDays,
            yearlyPct: GhostPaths.etfYearlyPct,
            startDayIndex: ghostStartDay,
          ),
        ),
        ChartLine(
          assetId: 'ghost_gold',
          color: FgColors.primary.withValues(alpha: 0.5),
          points: GhostPaths.compoundDailyFromYearly(
            startCents: startCents,
            days: ghostDays,
            yearlyPct: GhostPaths.goldYearlyPct,
            startDayIndex: ghostStartDay,
          ),
        ),
        ChartLine(
          assetId: 'ghost_mix',
          color: FgColors.secondary.withValues(alpha: 0.6),
          points: GhostPaths.diversified(
            startCents: startCents,
            days: ghostDays,
            startDayIndex: ghostStartDay,
          ),
        ),
        // Spec-45 F1: Spar-Zins-Linie (1,8 %/J) — sichtbar unter den
        // anderen Lehrlinien.
        ChartLine(
          assetId: 'ghost_spar',
          color: FgColors.success.withValues(alpha: 0.55),
          points: GhostPaths.compoundDailyFromYearly(
            startCents: startCents,
            days: ghostDays,
            yearlyPct: GhostPaths.sparYearlyPct,
            startDayIndex: ghostStartDay,
          ),
        ),
      ],
    ];

    // Spec-44 E1: Konsum-Schattenlinie. Quelle = bereits gekaufte Wunsch-
    // Items aus dem persistierten Wishlist-Repo (überlebt App-Neustart;
    // das alte in-memory ConsumptionLog verlor frühere Sessions → Linie
    // blieb leer/flach). Führende 0-Punkte werden getrimmt, damit die Linie
    // am ersten Kauf startet statt unten am Rand zu kleben. Eigener
    // Painter-Slot (NICHT in `ghosts`): wird SOLID gezeichnet mit eigener
    // Y-Skala — als Ghost wurde sie index-gestrichelt, was bei vielen
    // Punkten (nach Zeitsprung ~1/Tag) zu unsichtbaren Mikro-Strichen wurde.
    final consumptionShadow = (_showConsumptionShadow && ghostDays > 1)
        ? ChartLine(
            assetId: 'ghost_consumption',
            color: FgColors.alert,
            points: _consumptionShadowPoints(
              ref,
              startDayIndex: ghostStartDay,
              endDayIndex: ghostStartDay + ghostDays - 1,
            ),
          )
        : null;

    final showTutorial = !_tutorialDismissed &&
        !ref.watch(settingsRepositoryProvider).zeitreiseTutorialSeen;

    return PhoneFrame(
      appName: 'Zeitreise',
      coachId: 'zeitreise',
      coachTitle: 'Zeitreise',
      coachMessage:
          'Hier siehst du deinen Vermögens-Verlauf — wie ist dein Geld '
          'gewachsen? Die Geisterlinie zeigt: Was wäre, wenn du das Geld '
          'nur gespart hättest? Vergleich macht klug.',
      onBack: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          // Welle-8 Round 22 v4: ganze Page scrollbar + Chart fix 280 px.
          // Toggles + Info-Text dürfen wachsen ohne Chart zu drücken.
          SingleChildScrollView(
            padding: const EdgeInsets.all(FgSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AssetChipRow(
                  available: available,
                  selected: _selected,
                  onToggle: _toggle,
                ),
                const SizedBox(height: FgSpacing.xs),
                // A11y: MergeSemantics — Schalter bekommt seinen Text-Namen.
                MergeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Vergleich „hätte ich" einblenden',
                        style: FgTypography.bodyS,
                      ),
                      Switch(
                        value: _showGhosts,
                        onChanged: (v) => setState(() => _showGhosts = v),
                      ),
                    ],
                  ),
                ),
                MergeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        '🛍 Konsum-Schattenlinie',
                        style: FgTypography.bodyS,
                      ),
                      Switch(
                        key: const Key('zeitreise-consumption-shadow-toggle'),
                        value: _showConsumptionShadow,
                        onChanged: (v) =>
                            setState(() => _showConsumptionShadow = v),
                      ),
                    ],
                  ),
                ),
                if (_showConsumptionShadow)
                  const Padding(
                    padding: EdgeInsets.only(
                      left: FgSpacing.s,
                      right: FgSpacing.s,
                      bottom: FgSpacing.xs,
                    ),
                    child: Text(
                      'Was deine Konsum-Käufe wären, wenn du sie als '
                      'ETF gehalten hättest.',
                      style: FgTypography.bodyS,
                    ),
                  ),
                const SizedBox(height: FgSpacing.s),
                SizedBox(
                  height: 280,
                  child: PixelPanel(
                    child: _ChartBody(
                      lines: lines,
                      crashDays: crashDays,
                      ghosts: ghosts,
                      consumptionShadow: consumptionShadow,
                    ),
                  ),
                ),
                const SizedBox(height: FgSpacing.m),
                _Legend(lines: lines),
              ],
            ),
          ),
          if (showTutorial)
            _TutorialOverlay(onDismiss: _dismissTutorial),
        ],
      ),
    );
  }
}

/// One drawable line on the Zeitreise chart. Made public so widget tests
/// can drive the painter directly.
class ChartLine {
  const ChartLine({
    required this.assetId,
    required this.color,
    required this.points,
  });

  final String assetId;
  final Color color;
  final List<(int, int)> points;
}

/// Horizontal chip row showing every available aggregate asset.
class _AssetChipRow extends StatelessWidget {
  const _AssetChipRow({
    required this.available,
    required this.selected,
    required this.onToggle,
  });

  final List<String> available;
  final Set<String> selected;
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    final chipIds = [
      for (final id in HistoryAssetIds.all)
        if (available.contains(id)) id,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final id in chipIds)
            Padding(
              padding: const EdgeInsets.only(right: FgSpacing.s),
              child: _AssetChip(
                key: Key('zeitreise-chip-$id'),
                id: id,
                selected: selected.contains(id),
                onTap: () => onToggle(id),
              ),
            ),
        ],
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  const _AssetChip({
    required this.id,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = colorForAsset(id);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FgSpacing.m,
          vertical: FgSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.2)
              : FgColors.backgroundElevated,
          border: Border.all(
            color: selected ? color : FgColors.outline,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 10, height: 10, color: color),
            const SizedBox(width: FgSpacing.xs),
            Text(labelForAsset(id), style: FgTypography.bodyS),
          ],
        ),
      ),
    );
  }
}

class _ChartBody extends StatefulWidget {
  const _ChartBody({
    required this.lines,
    required this.crashDays,
    this.ghosts = const [],
    this.consumptionShadow,
  });

  final List<ChartLine> lines;
  final List<int> crashDays;
  final List<ChartLine> ghosts;

  /// Konsum-Schattenlinie — eigener Slot, SOLID gezeichnet mit eigener
  /// Y-Skala (siehe build()-Kommentar). `null` = ausgeblendet.
  final ChartLine? consumptionShadow;

  @override
  State<_ChartBody> createState() => _ChartBodyState();
}

class _ChartBodyState extends State<_ChartBody> {
  /// Textfassung des Diagramms fuer TalkBack: pro Linie Anfangs- und
  /// Endwert samt Richtung. Die Kurvenform bleibt visuell, aber die
  /// Kernaussage ("was ist aus meinem Geld geworden") wird hoerbar.
  String _diagrammBeschreibung(List<ChartLine> lines) {
    if (lines.isEmpty) return 'Vermögensverlauf, keine Reihe ausgewählt.';
    final teile = <String>[];
    for (final l in lines) {
      if (l.points.isEmpty) continue;
      final von = l.points.first.$2;
      final bis = l.points.last.$2;
      final richtung = bis > von
          ? 'gestiegen'
          : bis < von
              ? 'gefallen'
              : 'unverändert';
      teile.add('${labelForAsset(l.assetId)}: '
          'von ${Money.cents(von).formatEur()} '
          'auf ${Money.cents(bis).formatEur()}, $richtung');
    }
    if (teile.isEmpty) return 'Vermögensverlauf, noch keine Daten.';
    final krisen = widget.crashDays.isEmpty
        ? ''
        : ' ${widget.crashDays.length} Krisentage markiert.';
    return 'Vermögensverlauf. ${teile.join('. ')}.$krisen';
  }

  /// Sprint C2: aktuell angetippter Crash-Tag mit Drop-%. Verschwindet
  /// beim nächsten Tap außerhalb der Marker.
  ({int day, double dayDropPct, double peakToTroughPct})? _tappedCrash;

  void _handleTapUp(TapUpDetails details, _ChartLayout layout) {
    if (widget.crashDays.isEmpty) return;
    // Tap-X im Diagramm → nähester Crash-Tag.
    int? best;
    var bestDistance = double.infinity;
    for (final day in widget.crashDays) {
      if (day < layout.minDay || day > layout.maxDay) continue;
      final x = layout.pad +
          ((day - layout.minDay) / layout.dayRange) * layout.w;
      final d = (x - details.localPosition.dx).abs();
      if (d < bestDistance) {
        bestDistance = d;
        best = day;
      }
    }
    if (best == null || bestDistance > 14.0) {
      if (_tappedCrash != null) setState(() => _tappedCrash = null);
      return;
    }
    // Day-Drop + Peak-to-Trough aus erster gezeichneter Linie ableiten.
    final ref = widget.lines.isNotEmpty ? widget.lines.first : null;
    if (ref == null || ref.points.isEmpty) return;
    int? before;
    int? at;
    var maxPrior = 0;
    var minSince = 1 << 30;
    for (final (d, v) in ref.points) {
      if (d < best) {
        if (v > maxPrior) maxPrior = v;
        before = v;
      }
      if (d == best) at = v;
      if (d >= best && v < minSince) minSince = v;
    }
    if (at == null) return;
    final dayDrop = (before == null || before == 0)
        ? 0.0
        : (at - before) / before;
    final p2t = (maxPrior == 0)
        ? 0.0
        : (minSince - maxPrior) / maxPrior;
    setState(() {
      _tappedCrash = (
        day: best!,
        dayDropPct: dayDrop,
        peakToTroughPct: p2t,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final drawable = widget.lines.where((l) => l.points.length >= 2).toList();
    if (drawable.isEmpty) {
      return const Center(
        child: Text(
          'Noch nicht genug Tage zum Zeichnen.\n'
          '(Mindestens 2 Tage Verlauf nötig.)',
          style: FgTypography.bodyS,
          textAlign: TextAlign.center,
        ),
      );
    }
    // spec-30: axis labels + crash-marker explanation so the chart isn't
    // a soup of unidentified lines.
    final minDay = drawable.first.points.first.$1;
    final maxDay = drawable
        .expand((l) => l.points)
        .map((p) => p.$1)
        .fold<int>(minDay, (a, b) => b > a ? b : a);
    final dayRange = (maxDay - minDay).clamp(1, 1 << 30).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(builder: (ctx, constraints) {
            const pad = 12.0;
            final layout = _ChartLayout(
              pad: pad,
              w: constraints.maxWidth - 2 * pad,
              minDay: minDay,
              maxDay: maxDay,
              dayRange: dayRange,
            );
            return Stack(
              children: [
                // Bug-fix v29: CustomPaint braucht explizite size, sonst
                // zeichnet er in 0×0 (Chart "oben links gequetscht").
                Positioned.fill(
                  // Fuer TalkBack ist ein CustomPaint eine leere Flaeche.
                  // Der Vermoegensverlauf ist die zentrale Aussage der Seite,
                  // deshalb bekommt er wenigstens Anfang, Ende und Richtung
                  // als Text — die Kurvenform bleibt notgedrungen visuell.
                  child: Semantics(
                    image: true,
                    label: _diagrammBeschreibung(drawable),
                    child: GestureDetector(
                      onTapUp: (d) => _handleTapUp(d, layout),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: MultiLineChartPainter(
                          lines: drawable,
                          crashDays: widget.crashDays,
                          ghosts: widget.ghosts,
                          consumptionShadow: widget.consumptionShadow,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_tappedCrash != null)
                  Positioned(
                    left: (layout.pad +
                            ((_tappedCrash!.day - layout.minDay) /
                                    layout.dayRange) *
                                layout.w)
                        .clamp(4.0, constraints.maxWidth - 160),
                    top: 4,
                    child: _CrashTooltip(info: _tappedCrash!),
                  ),
              ],
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: FgSpacing.xs),
          child: Row(
            children: [
              Text('Tag $minDay', style: FgTypography.bodyS),
              const Spacer(),
              Text('Tag $maxDay', style: FgTypography.bodyS),
            ],
          ),
        ),
        if (widget.crashDays.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: FgSpacing.xs),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 2,
                  color: FgChart.down,
                ),
                const SizedBox(width: FgSpacing.s),
                const Expanded(
                  child: Text(
                    'Rote gestrichelte Senkrechte = Markt-Crash '
                    '(antippen für Drop-%)',
                    style: FgTypography.bodyS,
                  ),
                ),
              ],
            ),
          ),
        if (widget.ghosts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: FgSpacing.xs),
            // Welle-8: Wrap statt Row damit Labels umbrechen statt
            // rechts rauslaufen.
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final g in widget.ghosts)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 12, height: 2, color: g.color),
                      const SizedBox(width: 4),
                      Text(_ghostLabel(g.assetId),
                          style: FgTypography.bodyS),
                    ],
                  ),
              ],
            ),
          ),
        if (widget.consumptionShadow != null)
          Padding(
            padding: const EdgeInsets.only(top: FgSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 2,
                  color: widget.consumptionShadow!.color,
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    '🛍 Konsum als ETF gehalten',
                    style: FgTypography.bodyS,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.lines});

  final List<ChartLine> lines;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: FgSpacing.xs),
              child: _LegendRow(line: l),
            ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.line});

  final ChartLine line;

  @override
  Widget build(BuildContext context) {
    final points = line.points;
    if (points.isEmpty) return const SizedBox.shrink();
    final first = points.first.$2;
    final last = points.last.$2;
    final delta = last - first;
    final isCpi = line.assetId == HistoryAssetIds.wishlistCpi;
    final deltaPositive = delta >= 0;
    // Rising CPI = inflation hot = bad for the player → flip colors.
    final deltaColor = isCpi
        ? (deltaPositive ? FgColors.alert : FgColors.success)
        : (deltaPositive ? FgColors.success : FgColors.alert);
    // Spec-45 F2: CAGR % über die sichtbare Periode (Performance pro Jahr,
    // didaktisch wichtig für ETF-Beurteilung). Nur wenn Periode ≥ 30 Tage
    // damit kurze Spannen keine wilden Annualisierungen produzieren.
    final firstDay = points.first.$1;
    final lastDay = points.last.$1;
    final days = lastDay - firstDay;
    String? cagrLabel;
    // Welle-8: Cash + Spar haben keine sinnvolle CAGR — Cash schwankt
    // mit Allowance/Käufen extrem (kleine Basis), gibt absurde %-Werte.
    final isCashOrSpar = line.assetId == HistoryAssetIds.cash ||
        line.assetId == HistoryAssetIds.sparYield;
    if (!isCpi && !isCashOrSpar && days >= 30 && first > 0 && last > 0) {
      final ratio = last / first;
      final years = days / 365.0;
      final cagr = (math.pow(ratio, 1.0 / years) - 1.0).toDouble();
      // Cap bei +/-100 %/J damit krasse Sprünge nicht das Label fluten.
      final pct = (cagr * 100).clamp(-100.0, 100.0);
      final sign = pct >= 0 ? '+' : '';
      cagrLabel = '$sign${pct.toStringAsFixed(1)} %/J';
    }
    return Row(
      children: [
        Container(width: 12, height: 12, color: line.color),
        const SizedBox(width: FgSpacing.s),
        Expanded(
          child: Text(
            labelForAsset(line.assetId),
            style: FgTypography.bodyS,
          ),
        ),
        Text(_formatValue(line.assetId, last), style: FgTypography.bodyS),
        const SizedBox(width: FgSpacing.s),
        Text(
          (deltaPositive ? '+' : '') + _formatValue(line.assetId, delta),
          style: FgTypography.bodyS.copyWith(color: deltaColor),
        ),
        if (cagrLabel != null) ...[
          const SizedBox(width: FgSpacing.s),
          Text(
            cagrLabel,
            style: FgTypography.bodyS.copyWith(
              color: deltaColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

class _TutorialOverlay extends StatelessWidget {
  const _TutorialOverlay({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      key: const Key('zeitreise-tutorial-overlay'),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        child: const ColoredBox(
          color: Colors.black54,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(FgSpacing.xl),
              child: PixelPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tippe auf die Asset-Knöpfe oben, um Linien '
                      'ein- oder auszublenden.',
                      style: FgTypography.bodyM,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: FgSpacing.m),
                    Text(
                      'Hier siehst du, wie sich dein Geld über Zeit '
                      'entwickelt.',
                      style: FgTypography.bodyM,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: FgSpacing.m),
                    Text(
                      '(Tippe irgendwo zum Schließen.)',
                      style: FgTypography.bodyS,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _ghostLabel(String id) {
  return switch (id) {
    'ghost_etf' => 'alles ETF (8 %/J)',
    'ghost_gold' => 'alles Gold (4 %/J)',
    'ghost_mix' => '60/40 (~6 %/J)',
    'ghost_spar' => 'nur Spar (1,8 %/J)',
    'ghost_consumption' => '🛍 als ETF gehalten',
    _ => id,
  };
}

String _formatValue(String assetId, int value) {
  if (assetId == HistoryAssetIds.wishlistCpi) {
    return '$value';
  }
  return Money.cents(value).formatEur();
}

/// Sprint C2: Layout-Snapshot pro Frame, damit der Tap-Handler die
/// Crash-Marker treffen kann ohne dass der Painter selbst stateful wird.
class _ChartLayout {
  const _ChartLayout({
    required this.pad,
    required this.w,
    required this.minDay,
    required this.maxDay,
    required this.dayRange,
  });

  final double pad;
  final double w;
  final int minDay;
  final int maxDay;
  final double dayRange;
}

/// Sprint C2: kleines Overlay über dem getroffenen Crash-Marker.
class _CrashTooltip extends StatelessWidget {
  const _CrashTooltip({required this.info});

  final ({int day, double dayDropPct, double peakToTroughPct}) info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: FgColors.backgroundDeep,
        border: Border.all(color: FgChart.down, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Crash Tag ${info.day}', style: FgTypography.bodyS),
          Text(
            'Tag: ${(info.dayDropPct * 100).toStringAsFixed(1)}%',
            style: FgTypography.bodyS.copyWith(color: FgChart.down),
          ),
          Text(
            'Peak→Tief: ${(info.peakToTroughPct * 100).toStringAsFixed(1)}%',
            style: FgTypography.bodyS.copyWith(color: FgChart.down),
          ),
        ],
      ),
    );
  }
}

/// Renders one path per [ChartLine] sharing the same X-axis (game-day
/// index) but normalising each line independently along the Y-axis so
/// assets at vastly different scales stay readable side-by-side.
class MultiLineChartPainter extends CustomPainter {
  MultiLineChartPainter({
    required this.lines,
    required this.crashDays,
    this.ghosts = const [],
    this.consumptionShadow,
  });

  final List<ChartLine> lines;
  final List<int> crashDays;

  /// Sprint C3: hypothetische Pfade — gestrichelt gezeichnet, eigene
  /// Y-Normalisierung (gemeinsamer Y-Range über alle Ghosts).
  final List<ChartLine> ghosts;

  /// Spec-44 E1: Konsum-Schattenlinie — SOLID (nicht gestrichelt) mit
  /// eigener Y-Skala, damit sie auch nach einem Zeitsprung (viele Punkte)
  /// sauber sichtbar ist statt als unsichtbare Index-Mikro-Striche.
  final ChartLine? consumptionShadow;

  @override
  void paint(Canvas canvas, Size size) {
    if (lines.isEmpty) return;
    const pad = 12.0;
    final w = size.width - 2 * pad;
    final h = size.height - 2 * pad;

    // Compute the shared X-range (min..max dayIndex across all lines).
    var minDay = lines.first.points.first.$1;
    var maxDay = minDay;
    for (final l in lines) {
      for (final p in l.points) {
        if (p.$1 < minDay) minDay = p.$1;
        if (p.$1 > maxDay) maxDay = p.$1;
      }
    }
    final dayRange = (maxDay - minDay).clamp(1, 1 << 30).toDouble();

    // Frame.
    final framePaint = Paint()
      ..color = FgColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Rect.fromLTWH(pad, pad, w, h), framePaint);

    // Crash markers — dashed vertical red lines under the data lines.
    if (crashDays.isNotEmpty) {
      final crashPaint = Paint()
        ..color = FgChart.down
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      for (final day in crashDays) {
        if (day < minDay || day > maxDay) continue;
        final x = pad + ((day - minDay) / dayRange) * w;
        _drawDashedV(canvas, crashPaint, x, pad, pad + h);
      }
    }

    // Each line normalised on its own Y-range.
    for (final l in lines) {
      if (l.points.length < 2) continue;
      var minV = l.points.first.$2.toDouble();
      var maxV = minV;
      for (final p in l.points) {
        final v = p.$2.toDouble();
        if (v < minV) minV = v;
        if (v > maxV) maxV = v;
      }
      final vRange = (maxV - minV).clamp(1.0, double.infinity);

      final paint = Paint()
        ..color = l.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final path = Path();
      for (var i = 0; i < l.points.length; i++) {
        final (day, value) = l.points[i];
        final x = pad + ((day - minDay) / dayRange) * w;
        final y = pad + h - ((value - minV) / vRange) * h;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Sprint C3: Geisterlinien — gemeinsamer Y-Range, gestrichelt,
    // dünn, leicht transparent (Farben bereits halbtransparent).
    if (ghosts.isNotEmpty) {
      var gMin = double.infinity;
      var gMax = -double.infinity;
      for (final g in ghosts) {
        for (final p in g.points) {
          final v = p.$2.toDouble();
          if (v < gMin) gMin = v;
          if (v > gMax) gMax = v;
        }
      }
      if (gMin.isFinite && gMax.isFinite && gMax > gMin) {
        final gRange = gMax - gMin;
        for (final g in ghosts) {
          if (g.points.length < 2) continue;
          final paint = Paint()
            ..color = g.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5;
          // Dashed: gehe Punkt für Punkt, jeweils kurzes Segment + Gap.
          for (var i = 1; i < g.points.length; i++) {
            if (i % 2 == 0) continue; // skip every other segment → dash
            final (d0, v0) = g.points[i - 1];
            final (d1, v1) = g.points[i];
            final x0 = pad + ((d0 - minDay) / dayRange) * w;
            final x1 = pad + ((d1 - minDay) / dayRange) * w;
            final y0 = pad + h - ((v0 - gMin) / gRange) * h;
            final y1 = pad + h - ((v1 - gMin) / gRange) * h;
            canvas.drawLine(Offset(x0, y0), Offset(x1, y1), paint);
          }
        }
      }
    }

    // Spec-44 E1: Konsum-Schattenlinie SOLID mit eigener Y-Normalisierung —
    // bleibt nach Zeitsprung (viele Punkte) sauber sichtbar.
    final cs = consumptionShadow;
    if (cs != null && cs.points.length >= 2) {
      var minV = cs.points.first.$2.toDouble();
      var maxV = minV;
      for (final p in cs.points) {
        final v = p.$2.toDouble();
        if (v < minV) minV = v;
        if (v > maxV) maxV = v;
      }
      final vRange = (maxV - minV).clamp(1.0, double.infinity);
      final paint = Paint()
        ..color = cs.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final path = Path();
      for (var i = 0; i < cs.points.length; i++) {
        final (day, value) = cs.points[i];
        final x = pad + ((day - minDay) / dayRange) * w;
        final y = pad + h - ((value - minV) / vRange) * h;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawDashedV(Canvas canvas, Paint paint, double x, double y0, double y1) {
    const dash = 4.0;
    const gap = 3.0;
    var y = y0;
    while (y < y1) {
      final end = (y + dash).clamp(y0, y1);
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant MultiLineChartPainter old) =>
      old.lines != lines ||
      old.crashDays != crashDays ||
      old.ghosts != ghosts ||
      old.consumptionShadow != consumptionShadow;
}
