import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../domain/metal/metal.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import 'metal_repository.dart';

/// Spec-22: Trade-Insel für Edelmetalle (Gold/Silber/Platin). Layout
/// identisch zur Stock-Trade-Seite — keine dramatischen 24h-Farben,
/// Edelmetalle sind absichtlich "boring stable".
class MetalTradePage extends ConsumerWidget {
  const MetalTradePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(metalRepositoryProvider);
    final cash = ref.watch(cashStateProvider);

    return PhoneFrame(
      appName: 'Goldminen-Insel',
      coachId: 'metal',
      coachTitle: 'Gold + Silber',
      coachMessage:
          'Edelmetalle bringen keine Zinsen + keine Dividende — aber '
          'sie halten oft ihren Wert, wenn Geld unsicher wird. Gilt als '
          'Versicherung gegen Krisen. Kleiner Anteil im Portfolio reicht.',
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
                for (final spec in MetalCatalog.all)
                  _MetalRow(
                    spec: spec,
                    quote: portfolio.quotes[spec.id]!,
                    holding: portfolio.holdings.firstWhere(
                      (h) => h.assetId == spec.id,
                      orElse: () => MetalHolding(
                        assetId: spec.id,
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

class _MetalRow extends ConsumerWidget {
  const _MetalRow({
    required this.spec,
    required this.quote,
    required this.holding,
  });
  final MetalSpec spec;
  final MetalQuote quote;
  final MetalHolding holding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = quote.pricePerShare * holding.shares;
    final cost = holding.averageBuyPrice * holding.shares;
    final pnl = value - cost;
    // Bug-fix v26: vorher cumulative %-Abweichung von basePrice
    // (kann nach 30 Jahren +400 % sein), verwirrend wenn Spec
    // einstellige %/Jahr suggeriert. Jetzt: annualisiert auf Basis
    // dayIndex (CAGR über Spieltage).
    final daysSinceBase = quote.onDayIndex.clamp(1, 999999);
    final ratio = spec.basePrice.cents == 0
        ? 1.0
        : quote.pricePerShare.cents / spec.basePrice.cents;
    final years = daysSinceBase / 365.0;
    final cagr = years > 0 ? (math.pow(ratio, 1 / years) - 1) : 0.0;
    final deltaPct = cagr.toDouble() * 100;
    final deltaColor =
        ratio < 1.0 ? FgColors.alert : FgColors.success;

    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(spec.glyph, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: Text(spec.name, style: FgTypography.bodyL),
                ),
                Text(
                  '${deltaPct >= 0 ? '+' : ''}${deltaPct.toStringAsFixed(1)} %/J',
                  style: FgTypography.bodyM.copyWith(color: deltaColor),
                ),
              ],
            ),
            Text(
              'Aktueller Preis: ${quote.pricePerShare.formatEur()}',
              style: FgTypography.bodyM,
            ),
            // Spec-balance-didaktik A.2: Gold 4 %, Silber/Platin 5 %.
            // Inflation-Annahme 0.0023/Tag (post-jitter-halbierung).
            Text(
              'Wertsteigerung ca. '
              '${(spec.inflationFactor * 0.0023 * 365 * 100).toStringAsFixed(1)} % pro Jahr',
              style: FgTypography.bodyS,
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
                  onPressed: () => _trade(context, ref, buy: true),
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
      metalName: spec.name,
    );
    if (qty == null || qty <= 0) return;
    final repo = ref.read(metalRepositoryProvider.notifier);
    try {
      if (buy) {
        repo.buy(assetId: spec.id, shares: qty);
      } else {
        repo.sell(assetId: spec.id, shares: qty);
      }
    } on MetalError catch (e) {
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
    required String metalName,
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
            assetName: metalName,
          ),
        ),
      );
}

class _QtySheet extends StatefulWidget {
  const _QtySheet({
    required this.pricePerShare,
    required this.max,
    required this.label,
    required this.assetName,
  });
  final Money pricePerShare;
  final int? max;
  final String label;
  final String assetName;

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

  // Bug-fix v26: zeigt inline-Fehler statt silent zu droppen.
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
              Text(widget.assetName, style: FgTypography.bodyM),
              const SizedBox(height: FgSpacing.m),
              // Bug-fix v26: Wrap + ±1/±10 + Alle.
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
                  if (widget.max != null)
                    PixelButton(
                      label: 'Alle (${widget.max})',
                      background: FgColors.primary,
                      foreground: FgColors.onPrimary,
                      onPressed: () => _set(widget.max!),
                    ),
                ],
              ),
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
