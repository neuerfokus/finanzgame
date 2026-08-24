import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../settings/settings_repository.dart';
import '../skills/skill_tree_data.dart';
import '../../domain/economy/money.dart';
import '../../domain/etf/etf.dart';
import '../../domain/sim/weather.dart';
import '../../ui/widgets/phone_frame.dart';
import '../coaching/panic_sell_guard.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../savings_plan/savings_plan_page.dart';
import '../weather/weather_state.dart';
import 'etf_repository.dart';

/// Buy/sell page for fictive ETFs. Lists all [EtfCatalog.all] entries with
/// current quote + own holding + P&L. Buttons open a quantity stepper.
class EtfTradePage extends ConsumerWidget {
  const EtfTradePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(etfRepositoryProvider);
    final cash = ref.watch(cashStateProvider);
    final weather = ref.watch(weatherStateProvider);

    return PhoneFrame(
      appName: 'Börse',
      coachId: 'etf',
      coachTitle: 'ETFs kaufen',
      coachMessage:
          'Ein ETF ist ein Korb aus hunderten Aktien gleichzeitig — '
          'damit streust du dein Risiko automatisch. Kauf am besten '
          'monatlich kleine Beträge, dann ist der Einstiegs-Zeitpunkt '
          'egal.',
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          _Header(cash: cash, weather: weather),
          // spec-37: ETF-Sparplan-Shortcut auf der ETF-Insel.
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FgSpacing.l,
              vertical: FgSpacing.xs,
            ),
            child: PixelButton(
              label: '🔁 Sparplan einrichten',
              background: FgColors.success,
              foreground: FgColors.onSurface,
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const SavingsPlanPage(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FgSpacing.l),
              children: [
                for (final spec in EtfCatalog.all)
                  _EtfRow(
                    spec: spec,
                    quote: portfolio.quotes[spec.id]!,
                    holding: portfolio.holdings.firstWhere(
                      (h) => h.etfId == spec.id,
                      orElse: () => EtfHolding(
                        etfId: spec.id,
                        shares: 0,
                        averageBuyPrice: Money.zero,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.cash, required this.weather});
  final Money cash;
  final Weather weather;

  String get _weatherEmoji => switch (weather) {
        Weather.sunny => '☀',
        Weather.cloudy => '⛅',
        Weather.rain => '🌧',
        Weather.storm => '⛈',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FgSpacing.l),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Cash ${cash.formatEur()}', style: FgTypography.bodyL),
          Text(_weatherEmoji, style: const TextStyle(fontSize: 28)),
        ],
      ),
    );
  }
}

class _EtfRow extends ConsumerWidget {
  const _EtfRow({
    required this.spec,
    required this.quote,
    required this.holding,
  });
  final EtfSpec spec;
  final EtfQuote quote;
  final EtfHolding holding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = quote.pricePerShare * holding.shares;
    final cost = holding.averageBuyPrice * holding.shares;
    final pnl = value - cost;

    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spec.name, style: FgTypography.bodyL),
            Text(
              'Aktueller Preis: ${quote.pricePerShare.formatEur()}',
              style: FgTypography.bodyM,
            ),
            // Welle-8: Erklärung + Zusammensetzung pro ETF.
            if (spec.description.isNotEmpty) ...[
              const SizedBox(height: FgSpacing.xs),
              Text(
                spec.description,
                style: FgTypography.bodyS.copyWith(
                  color: FgColors.onSurface,
                ),
              ),
            ],
            if (spec.composition.isNotEmpty) ...[
              const SizedBox(height: FgSpacing.xs),
              const Text(
                'Drin steckt:',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              for (final c in spec.composition)
                Padding(
                  padding: const EdgeInsets.only(left: FgSpacing.s),
                  child: Text(
                    '• ${c.label} ${c.percent} %',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: FgSpacing.s),
            Text(
              'Du hast: ${holding.shares} Anteile · Wert ${value.formatEur()}',
              style: FgTypography.bodyS,
            ),
            if (holding.shares > 0)
              Text(
                'Ø beim Kauf ${holding.averageBuyPrice.formatEur()}  ·  '
                'Gewinn/Verlust ${pnl.formatEur()}',
                style: FgTypography.bodyS.copyWith(
                  color: pnl.isNegative ? FgColors.alert : FgColors.success,
                ),
              ),
            const SizedBox(height: FgSpacing.s),
            Row(
              children: [
                PixelButton(
                  label: 'Kaufen',
                  onPressed: () => _showStepper(context, ref, buy: true),
                ),
                const SizedBox(width: FgSpacing.s),
                PixelButton(
                  label: 'Verkaufen',
                  onPressed: holding.shares > 0
                      ? () => _showStepper(context, ref, buy: false)
                      : null,
                  background: FgColors.alert,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStepper(
    BuildContext context,
    WidgetRef ref, {
    required bool buy,
  }) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: _QuantitySheet(
          spec: spec,
          quote: quote,
          maxShares: buy ? null : holding.shares,
          buy: buy,
        ),
      ),
    );
    if (result == null || result <= 0) return;
    // Welle-8 Round 23: Panik-Sell-Coach.
    if (!buy && context.mounted) {
      final proceed = await maybeWarnPanicSell(
        context: context,
        assetName: spec.name,
        avgBuyPricePerShare: holding.averageBuyPrice,
        currentPricePerShare: quote.pricePerShare,
        lossThresholdPct: ref
                .read(settingsRepositoryProvider.notifier)
                .hasSkill(SkillEffects.panicGuardAlways)
            ? -10
            : -20,
      );
      if (!proceed) return;
    }
    final repo = ref.read(etfRepositoryProvider.notifier);
    try {
      if (buy) {
        repo.buy(etfId: spec.id, shares: result);
      } else {
        repo.sell(etfId: spec.id, shares: result);
      }
    } on EtfError catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message, style: FgTypography.bodyM)),
      );
    }
  }
}

class _QuantitySheet extends StatefulWidget {
  const _QuantitySheet({
    required this.spec,
    required this.quote,
    required this.maxShares,
    required this.buy,
  });
  final EtfSpec spec;
  final EtfQuote quote;
  final int? maxShares;
  final bool buy;

  @override
  State<_QuantitySheet> createState() => _QuantitySheetState();
}

class _QuantitySheetState extends State<_QuantitySheet> {
  int _qty = 1;
  final _budgetCtrl = TextEditingController();
  String? _budgetError;

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _set(int v) {
    final max = widget.maxShares;
    setState(() {
      _qty = v.clamp(1, max ?? 999999);
      _budgetError = null;
    });
  }

  void _applyBudget() {
    final raw = _budgetCtrl.text.trim().replaceAll(',', '.');
    final eur = double.tryParse(raw);
    if (eur == null || eur <= 0) {
      setState(() => _budgetError = 'Bitte Betrag in € eingeben');
      return;
    }
    final cents = (eur * 100).round();
    final qty = cents ~/ widget.quote.pricePerShare.cents;
    if (qty <= 0) {
      setState(() => _budgetError =
          'Budget reicht nicht für 1 Anteil (Kurs ${widget.quote.pricePerShare.formatEur()})');
      return;
    }
    _set(qty);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.quote.pricePerShare * _qty;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: PixelPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.buy ? 'Kaufen' : 'Verkaufen',
                style: FgTypography.display,
              ),
              Text(widget.spec.name, style: FgTypography.bodyM),
              const SizedBox(height: FgSpacing.m),
              // Bug-fix v26: Wrap + Alles-verkaufen-Button.
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: FgSpacing.s,
                runSpacing: FgSpacing.xs,
                children: [
                  PixelButton(label: '−10', onPressed: () => _set(_qty - 10)),
                  PixelButton(label: '−1', onPressed: () => _set(_qty - 1)),
                  Text('$_qty', style: FgTypography.displayLarge),
                  PixelButton(label: '+1', onPressed: () => _set(_qty + 1)),
                  PixelButton(label: '+10', onPressed: () => _set(_qty + 10)),
                  if (widget.maxShares != null)
                    PixelButton(
                      label: 'Alle (${widget.maxShares})',
                      background: FgColors.primary,
                      foreground: FgColors.onPrimary,
                      onPressed: () => _set(widget.maxShares!),
                    ),
                ],
              ),
              const SizedBox(height: FgSpacing.xs),
              const Text('Stück', style: FgTypography.bodyS),
              const SizedBox(height: FgSpacing.s),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _budgetCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: FgTypography.bodyM,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Für € (max)',
                        suffixText: '€',
                        border: const OutlineInputBorder(),
                        errorText: _budgetError,
                      ),
                      onSubmitted: (_) => _applyBudget(),
                    ),
                  ),
                  const SizedBox(width: FgSpacing.s),
                  PixelButton(label: 'Berechnen', onPressed: _applyBudget),
                ],
              ),
              const SizedBox(height: FgSpacing.m),
              Container(
                padding: const EdgeInsets.all(FgSpacing.s),
                decoration: BoxDecoration(
                  color: FgColors.backgroundDeep,
                  border: Border.all(color: FgColors.primary, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      '$_qty Stück  ×  '
                      '${widget.quote.pricePerShare.formatEur()}',
                      style: FgTypography.bodyM,
                    ),
                    const SizedBox(height: FgSpacing.xs),
                    Text(
                      '= ${total.formatEur()}',
                      style: FgTypography.bodyL.copyWith(
                        color: FgColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FgSpacing.l),
              PixelButton(
                label: widget.buy ? 'Kaufen' : 'Verkaufen',
                onPressed: () => Navigator.of(context).pop(_qty),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
