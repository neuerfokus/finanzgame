import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../settings/settings_repository.dart';
import '../skills/skill_tree_data.dart';
import '../../domain/economy/money.dart';
import '../../domain/stock/stock.dart';
import '../../ui/widgets/phone_frame.dart';
import '../coaching/panic_sell_guard.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import 'stock_repository.dart';

/// Buy/sell page for fictive single stocks. Mirrors [EtfTradePage].
class StockTradePage extends ConsumerWidget {
  const StockTradePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(stockRepositoryProvider);
    final cash = ref.watch(cashStateProvider);

    return PhoneFrame(
      appName: 'Aktien-Archipel',
      coachId: 'stock',
      coachTitle: 'Einzelaktien',
      coachMessage:
          'Hier kaufst du EINE Firma — riskanter als ETF. Geht die Firma '
          'pleite, ist dein Geld weg. Nur kleinen Teil pro Aktie + nicht '
          'alles in eine setzen. Lieber breit über ETF starten.',
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(FgSpacing.l),
            child: Text('Cash ${cash.formatEur()}', style: FgTypography.bodyL),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: FgSpacing.l),
              children: [
                for (final spec in StockCatalog.all)
                  _StockRow(
                    spec: spec,
                    quote: portfolio.quotes[spec.id]!,
                    holding: portfolio.holdings.firstWhere(
                      (h) => h.stockId == spec.id,
                      orElse: () => StockHolding(
                        stockId: spec.id,
                        shares: 0,
                        averageBuyPrice: Money.zero,
                      ),
                    ),
                    bankrupt: portfolio.bankruptStockIds.contains(spec.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockRow extends ConsumerWidget {
  const _StockRow({
    required this.spec,
    required this.quote,
    required this.holding,
    this.bankrupt = false,
  });
  final StockSpec spec;
  final StockQuote quote;
  final StockHolding holding;

  /// Spec-44 A.1: pleite-gegangene Firma — Kauf gesperrt, Verkauf nur
  /// für ~1¢/Aktie (Notverkauf).
  final bool bankrupt;

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
            Row(
              children: [
                Expanded(child: Text(spec.name, style: FgTypography.bodyL)),
                if (bankrupt)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FgSpacing.xs,
                      vertical: 2,
                    ),
                    color: FgColors.alert,
                    child: const Text(
                      '💀 PLEITE',
                      style: FgTypography.bodyS,
                    ),
                  ),
              ],
            ),
            Text(
              bankrupt
                  ? '💀 Pleite — Aktie ist wertlos und erholt sich nicht'
                  : 'Aktueller Preis: ${quote.pricePerShare.formatEur()}',
              style: FgTypography.bodyM,
            ),
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
                  onPressed:
                      bankrupt ? null : () => _trade(context, ref, buy: true),
                ),
                const SizedBox(width: FgSpacing.s),
                PixelButton(
                  label: 'Verkaufen',
                  onPressed: holding.shares > 0
                      ? () => _trade(context, ref, buy: false)
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

  Future<void> _trade(
    BuildContext context,
    WidgetRef ref, {
    required bool buy,
  }) async {
    final qty = await _askQty(
      context,
      max: buy ? null : holding.shares,
      pricePerShare: quote.pricePerShare,
      label: buy ? 'Kaufen' : 'Verkaufen',
      stockName: spec.name,
    );
    if (qty == null || qty <= 0) return;
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
    final repo = ref.read(stockRepositoryProvider.notifier);
    try {
      if (buy) {
        repo.buy(stockId: spec.id, shares: qty);
      } else {
        repo.sell(stockId: spec.id, shares: qty);
      }
    } on StockError catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message, style: FgTypography.bodyM)),
      );
    }
  }

  Future<int?> _askQty(
    BuildContext context, {
    required Money pricePerShare,
    required int? max,
    required String label,
    required String stockName,
  }) =>
      showModalBottomSheet<int>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _QtySheet(
            pricePerShare: pricePerShare,
            max: max,
            label: label,
            stockName: stockName,
          ),
        ),
      );
}

class _QtySheet extends StatefulWidget {
  const _QtySheet({
    required this.pricePerShare,
    required this.max,
    required this.label,
    required this.stockName,
  });
  final Money pricePerShare;
  final int? max;
  final String label;
  final String stockName;

  @override
  State<_QtySheet> createState() => _QtySheetState();
}

class _QtySheetState extends State<_QtySheet> {
  int _qty = 1;
  final _budgetCtrl = TextEditingController();
  String? _budgetError;

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

  void _set(int v) => setState(() {
        _qty = v.clamp(1, widget.max ?? 999999);
        _budgetError = null;
      });

  void _applyBudget() {
    final raw = _budgetCtrl.text.trim().replaceAll(',', '.');
    final eur = double.tryParse(raw);
    if (eur == null || eur <= 0) {
      setState(() => _budgetError = 'Bitte Betrag in € eingeben');
      return;
    }
    final cents = (eur * 100).round();
    final qty = cents ~/ widget.pricePerShare.cents;
    if (qty <= 0) {
      setState(() => _budgetError =
          'Budget reicht nicht für 1 Anteil (Kurs ${widget.pricePerShare.formatEur()})');
      return;
    }
    _set(qty);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.pricePerShare * _qty;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: PixelPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label, style: FgTypography.display),
              Text(widget.stockName, style: FgTypography.bodyM),
              const SizedBox(height: FgSpacing.m),
              // Bug-fix v26: Wrap statt Row → Buttons brechen sauber um.
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: FgSpacing.s,
                runSpacing: FgSpacing.xs,
                children: [
                  PixelButton(
                      label: '−10', onPressed: () => _set(_qty - 10)),
                  PixelButton(
                      label: '−1', onPressed: () => _set(_qty - 1)),
                  Text('$_qty', style: FgTypography.displayLarge),
                  PixelButton(
                      label: '+1', onPressed: () => _set(_qty + 1)),
                  PixelButton(
                      label: '+10', onPressed: () => _set(_qty + 10)),
                  if (widget.max != null)
                    PixelButton(
                      label: 'Alle (${widget.max})',
                      background: FgColors.primary,
                      foreground: FgColors.onPrimary,
                      onPressed: () => _set(widget.max!),
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
                      '$_qty Stück  ×  ${widget.pricePerShare.formatEur()}',
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
                label: widget.label,
                onPressed: () => Navigator.of(context).pop(_qty),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
