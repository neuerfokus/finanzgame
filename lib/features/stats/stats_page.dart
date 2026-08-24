import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/forest/tree.dart';
import '../../domain/sim/job_level.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../bank/savings_repository.dart';
import '../collectibles/collectible_repository.dart';
import '../crypto/crypto_repository.dart';
import '../economy/cash_state.dart';
import '../etf/etf_repository.dart';
import '../forest/tree_repository.dart';
import '../highscore/net_worth.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../settings/settings_repository.dart';
import '../stock/stock_repository.dart';
import '../vorsorge/vorsorge_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';

/// spec-35 phase H: Statistik-Page. Übersicht Netto-Vermögen, Asset-
/// Klassen-Pie, Level/Titel + Job-Stufe.
class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  bool _donut = false;

  @override
  Widget build(BuildContext context) {
    final cash = ref.watch(cashStateProvider);
    final savings = ref.watch(savingsRepositoryProvider);
    final etf = ref.watch(etfRepositoryProvider);
    final stock = ref.watch(stockRepositoryProvider);
    final crypto = ref.watch(cryptoRepositoryProvider);
    final metal = ref.watch(metalRepositoryProvider);
    final realestate = ref.watch(realEstateRepositoryProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final xp = ref.watch(xpRepositoryProvider);
    final level = LevelSystem.levelFor(xp);
    final title = LevelSystem.titleFor(level);
    final startAge = ref.watch(
      settingsRepositoryProvider.select((s) => s.startAgeYears),
    );
    final job = JobConfig.forAge(startAge + dayIndex ~/ 365);

    // Asset-Wert-Berechnung.
    final etfValue = etf.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (etf.quotes[h.etfId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    final stockValue = stock.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (stock.quotes[h.stockId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    // Spec-38 follow-up: Bitcoin vs Krypto-Casino getrennt anzeigen.
    var bitcoinValue = 0;
    var cryptoCasinoValue = 0;
    for (final h in crypto.holdings) {
      final cents = (crypto.quotes[h.assetId]?.pricePerShare.cents ?? 0) *
          h.shares;
      if (h.assetId.contains('bitcoin')) {
        bitcoinValue += cents;
      } else {
        cryptoCasinoValue += cents;
      }
    }
    final metalValue = metal.holdings.fold<int>(
      0,
      (sum, h) =>
          sum + (metal.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    final reRepo = ref.read(realEstateRepositoryProvider.notifier);
    // Netto: Marktwert minus Restschuld (siehe NetWorth.compute).
    final reValue = realestate.fold<int>(
      0,
      (sum, h) =>
          sum +
          reRepo.currentValueOf(h, dayIndex).cents -
          reRepo.mortgageRemaining(h, dayIndex).cents,
    );
    final vorsorge = ref.watch(vorsorgeRepositoryProvider);
    final vorsorgeValue = vorsorge.fold<int>(
      0,
      (sum, c) =>
          sum + c.totalContributed.cents + c.totalSubsidy.cents,
    );
    // Spec-41 follow-up: Sammlerobjekte + Wunschartikel + Möbel auch
    // ins Netto-Vermögen einbeziehen — vorher unsichtbar.
    final collectibleRepo =
        ref.read(collectibleRepositoryProvider.notifier);
    final collectibles = ref.watch(collectibleRepositoryProvider);
    final collectibleValue = collectibles.fold<int>(
      0,
      (sum, h) => sum + collectibleRepo.currentValueOf(h, dayIndex).cents,
    );
    // Spec-43 v3: Möbel + Wunschartikel sind Konsumgüter, kein Vermögen
    // mehr in Stats-Donut. Sammlerobjekte bleiben (Real-Assets).
    // Bäume zum Anschaffungswert — sie fehlten überall im Vermögen, obwohl
    // Pflanzen echtes Geld kostet (siehe NetWorth.compute).
    final treeValue = ref.watch(treeRepositoryProvider).fold<int>(
          0,
          (sum, t) => sum + TreeCatalog.spec(t.kind).cost.cents,
        );
    final cashCents = cash.cents;
    final savingsCents = savings.cents;
    // Summe aus der zentralen Berechnung — die lokalen Werte oben sind nur
    // für die Donut-Aufschlüsselung da.
    final netWorth = ref.watch(netWorthProvider(dayIndex));

    final classes = [
      _AssetClass('Cash', cashCents, const Color(0xFFFFC107)),         // amber
      _AssetClass('Spar', savingsCents, const Color(0xFF4ED96A)),      // green
      _AssetClass('ETF', etfValue, const Color(0xFF5BC0EB)),           // cyan
      _AssetClass('Aktien', stockValue, const Color(0xFF7B61FF)),      // purple
      _AssetClass('Bitcoin', bitcoinValue, const Color(0xFFF7931A)),   // orange
      _AssetClass('Krypto-Casino', cryptoCasinoValue,
          const Color(0xFFE91E63)),                                    // magenta
      _AssetClass('Edelmetalle', metalValue, const Color(0xFFE5B847)), // gold
      _AssetClass('Immobilien', reValue, const Color(0xFFA0522D)),     // sienna
      _AssetClass('Vorsorge', vorsorgeValue, const Color(0xFF26C6DA)), // teal
      _AssetClass('Sammlerobjekte', collectibleValue,
          const Color(0xFF9C27B0)),                                    // deep purple
      _AssetClass('Bäume', treeValue, const Color(0xFF2E7D32)),        // forest
    ]..removeWhere((c) => c.cents <= 0);

    return PhoneFrame(
      appName: 'Deine Übersicht',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dein Vermögen gesamt', style: FgTypography.bodyM),
                Text(
                  Money.cents(netWorth).formatEur(),
                  style: FgTypography.displayLarge.copyWith(
                    color: netWorth >= 0
                        ? FgColors.success
                        : FgColors.alert,
                  ),
                ),
                const Text(
                  'Cash + Spar + Assets + Immobilien',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Level $level — $title',
                    style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                Text('Erfahrungspunkte: $xp', style: FgTypography.bodyS),
                Text('Beruf: ${JobConfig.displayName(job)}',
                    style: FgTypography.bodyS),
                Text('Tag im Spiel: ${dayIndex + 1}',
                    style: FgTypography.bodyS),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          // Welle-8 Round 17: Einnahmen / Ausgaben + Freistellungsauftrag.
          _IncomeExpensePanel(
            ageYears: startAge + dayIndex ~/ 365,
            job: job,
          ),
          const SizedBox(height: FgSpacing.m),
          if (classes.isNotEmpty)
            PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Vermögensverteilung',
                            style: FgTypography.bodyL),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _donut = !_donut),
                        child: Text(
                          _donut ? 'Balken' : 'Donut',
                          style: FgTypography.bodyS
                              .copyWith(color: FgColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FgSpacing.s),
                  if (_donut)
                    _DonutChart(classes: classes, total: netWorth)
                  else
                    for (final c in classes)
                      _AssetBar(klass: c, total: netWorth),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AssetClass {
  const _AssetClass(this.label, this.cents, this.color);
  final String label;
  final int cents;
  final Color color;
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.classes, required this.total});
  final List<_AssetClass> classes;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: CustomPaint(
            painter: _DonutPainter(classes: classes, total: total),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Money.cents(total).formatEur(),
                    style: FgTypography.bodyL.copyWith(
                      color: FgColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Netto', style: FgTypography.bodyS),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: FgSpacing.s),
        Wrap(
          spacing: FgSpacing.s,
          runSpacing: FgSpacing.xs,
          children: [
            for (final c in classes)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, color: c.color),
                  const SizedBox(width: 4),
                  Text(
                    '${c.label}  ${(c.cents / (total <= 0 ? 1 : total) * 100).toStringAsFixed(1)}%',
                    style: FgTypography.bodyS,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.classes, required this.total});
  final List<_AssetClass> classes;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.shortestSide * 0.45;
    final innerR = outerR * 0.55;
    var start = -1.5708; // -π/2 (start at top)
    for (final c in classes) {
      if (c.cents <= 0) continue;
      final sweep = (c.cents / total) * 6.2832;
      final paint = Paint()..color = c.color;
      final path = Path()
        ..moveTo(center.dx + outerR * _cos(start),
            center.dy + outerR * _sin(start))
        ..arcTo(
            Rect.fromCircle(center: center, radius: outerR), start, sweep, false)
        ..lineTo(center.dx + innerR * _cos(start + sweep),
            center.dy + innerR * _sin(start + sweep))
        ..arcTo(Rect.fromCircle(center: center, radius: innerR),
            start + sweep, -sweep, false)
        ..close();
      canvas.drawPath(path, paint);
      start += sweep;
    }
  }

  static double _cos(double r) => math.cos(r);
  static double _sin(double r) => math.sin(r);

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.classes != classes || old.total != total;
}

class _AssetBar extends StatelessWidget {
  const _AssetBar({required this.klass, required this.total});
  final _AssetClass klass;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total <= 0 ? 0.0 : klass.cents / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(klass.label, style: FgTypography.bodyM),
              ),
              Text(
                '${Money.cents(klass.cents).formatEur()}  '
                '(${(pct * 100).toStringAsFixed(1)} %)',
                style: FgTypography.bodyS,
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          ClipRRect(
            borderRadius:
                const BorderRadius.all(Radius.circular(FgRadius.tight)),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: FgColors.backgroundDeep,
              valueColor: AlwaysStoppedAnimation<Color>(klass.color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Welle-8 Round 17: Einnahmen-Ausgaben-Übersicht + Freistellungsauftrag.
class _IncomeExpensePanel extends ConsumerWidget {
  const _IncomeExpensePanel({required this.ageYears, required this.job});

  final int ageYears;
  final JobLevel job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsInLevel = JobConfig.yearsInLevel(ageYears);
    final gross =
        JobConfig.monthlyGrossSalary(job, yearsInLevel: yearsInLevel);
    // Die Spielfigur ist ledig → Lohnsteuerklasse I (Default). Der frei
    // waehlbare Selektor ist raus, siehe L11 im SettingsRepository.
    final net = JobConfig.monthlySalary(job, yearsInLevel: yearsInLevel);
    final living = JobConfig.monthlyLivingCost(job);
    final disposable = Money.cents(net.cents - living.cents);
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💰 Einnahmen & Ausgaben (Monat)',
              style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.xs),
          _Row(label: 'Brutto-Lohn', value: gross.formatEur()),
          _Row(
            label: 'Netto-Lohn',
            value: net.formatEur(),
            highlight: true,
          ),
          _Row(label: 'Lebenskosten', value: '− ${living.formatEur()}'),
          const Divider(color: FgColors.outline, height: 12),
          _Row(
            label: 'Frei verfügbar',
            value: disposable.formatEur(),
            highlight: true,
            color: disposable.cents >= 0
                ? FgColors.success
                : FgColors.alert,
          ),
          const SizedBox(height: FgSpacing.s),
          const Text(
            '📋 Freistellungsauftrag',
            style: FgTypography.bodyM,
          ),
          const SizedBox(height: 2),
          const Text(
            'Die ersten 1000 € Kapitalerträge pro Jahr sind steuerfrei '
            '(Sparerpauschbetrag). Stell den Auftrag bei deiner Bank '
            '— sonst werden Steuern direkt einbehalten + du holst sie '
            'erst per Steuererklärung zurück.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.highlight = false,
    this.color,
  });
  final String label;
  final String value;
  final bool highlight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = highlight
        ? FgTypography.bodyM.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? FgColors.primary,
          )
        : FgTypography.bodyS;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
