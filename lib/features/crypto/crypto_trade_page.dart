import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../settings/settings_repository.dart';
import '../skills/skill_tree_data.dart';
import '../../domain/crypto/crypto.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../coaching/panic_sell_guard.dart';
import '../economy/cash_state.dart';
import 'crypto_repository.dart';

/// Spec-22: Trade-Insel auf dem Vulkan. Listet alle [CryptoCatalog]-Coins
/// mit aktuellem Kurs + 24h-Change-Prozent groß rot/grün + "hätte ich
/// gestern gekauft..."-Hint. Darunter eine ausklappbare Eruption-History
/// als Erinnerung an die alte Vulkan-Insel.
class CryptoTradePage extends ConsumerWidget {
  const CryptoTradePage({required this.currentDayIndex, super.key});

  final int currentDayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(cryptoRepositoryProvider);
    final cash = ref.watch(cashStateProvider);

    return PhoneFrame(
      appName: 'Vulkan-Insel: Krypto',
      coachId: 'krypto',
      coachTitle: 'Krypto',
      coachMessage:
          'Bitcoin schwankt extrem — heute +20 %, morgen -30 %. Hohe '
          'Chance, hohes Risiko. Höchstens einen kleinen Teil deines '
          'Geldes hier rein. Nicht panisch verkaufen, wenn es fällt.',
      onBack: () => Navigator.of(context).pop(),
      // Welle-8 Round 28 v5: ALLE Header (Cash/Warnung/Live-Preis/Info/
      // Summe) wandern in die ListView — vorher fix über `Expanded` und
      // fraßen permanent die halbe Höhe. Jetzt scrollen sie mit, Coin-
      // Rows kriegen volle Höhe. Keine Info entfernt, nur entpinnt.
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: FgSpacing.l,
          vertical: FgSpacing.s,
        ),
        children: [
          // Freies Bargeld — was noch zum Ausgeben/Investieren da ist.
          // NICHT der investierte Betrag (der steht pro Coin + im
          // ₿-Summen-Header).
          Text(
            '💰 Verfügbares Geld: ${cash.formatEur()}',
            style: FgTypography.bodyL,
          ),
          const SizedBox(height: FgSpacing.s),
          // spec-26: kurze Casino-Risiko-Warnung — eigene rote Box.
          Container(
            padding: const EdgeInsets.all(FgSpacing.s),
            decoration: BoxDecoration(
              color: FgColors.alert.withValues(alpha: 0.18),
              border: Border.all(color: FgColors.alert, width: 2),
              borderRadius:
                  const BorderRadius.all(Radius.circular(FgRadius.card)),
            ),
            child: const Text(
              '⚠ Sehr riskant — kann auf null fallen. Nur Geld rein, '
              'das du verlieren kannst.',
              style: FgTypography.bodyS,
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          // Welle-8 Round 22 v4: prominent Live-Kurs "1 BTC = X €".
          _BitcoinLivePriceHeader(portfolio: portfolio),
          const SizedBox(height: FgSpacing.s),
          // Welle-8 Round 26: Erklär-Texte (Age-Gate + Satoshi) in
          // collapsed Tile — Standard zugeklappt.
          const _CryptoInfoTile(),
          const SizedBox(height: FgSpacing.s),
          // Bug-fix v26: Summen-Header über alle BTC-Stückelungen.
          _BitcoinSummaryHeader(portfolio: portfolio),
          const SizedBox(height: FgSpacing.s),
          for (final spec in CryptoCatalog.all)
            _CryptoRow(
              spec: spec,
              quote: portfolio.quotes[spec.id]!,
              holding: portfolio.holdings.firstWhere(
                (h) => h.assetId == spec.id,
                orElse: () => CryptoHolding(
                  assetId: spec.id,
                  shares: 0,
                  averageBuyPrice: Money.zero,
                ),
              ),
            ),
          const SizedBox(height: FgSpacing.m),
          _VulkanHistorySection(currentDayIndex: currentDayIndex),
          const SizedBox(height: FgSpacing.l),
        ],
      ),
    );
  }
}

/// Welle-8 Round 22 v4: zeigt aktuellen 1-BTC-Kurs prominent. Damit
/// User sofort sieht "1 BTC = 63.000 €, 0,1 BTC = 6.300 €" usw.
/// Hochgerechnet aus der 0,001-BTC-Quote × 1000.
class _BitcoinLivePriceHeader extends StatelessWidget {
  const _BitcoinLivePriceHeader({required this.portfolio});
  final CryptoPortfolio portfolio;

  @override
  Widget build(BuildContext context) {
    final q = portfolio.quotes['crypto_bitcoin'];
    if (q == null) return const SizedBox.shrink();
    // 0,001 BTC × 1000 = 1 BTC Wert.
    final fullBtc = Money.cents(q.pricePerShare.cents * 1000);
    return Container(
      padding: const EdgeInsets.all(FgSpacing.s),
      decoration: BoxDecoration(
        color: FgColors.success.withValues(alpha: 0.15),
        border: Border.all(color: FgColors.success, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('₿', style: TextStyle(fontSize: 22)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(
                  '1 BTC = ${fullBtc.formatEur()}',
                  style: FgTypography.bodyL.copyWith(
                    color: FgColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            '0,1 BTC = ${Money.cents(q.pricePerShare.cents * 100).formatEur()}  ·  '
            '0,01 BTC = ${Money.cents(q.pricePerShare.cents * 10).formatEur()}  ·  '
            '0,001 BTC = ${q.pricePerShare.formatEur()}',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

/// Welle-8 Round 26: ausklappbare Erklär-Box (Age-Gate + Satoshi). Standard
/// zugeklappt, damit die Kauf-Optionen oben sichtbar bleiben.
class _CryptoInfoTile extends StatelessWidget {
  const _CryptoInfoTile();

  @override
  Widget build(BuildContext context) {
    return const PixelPanel(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.only(bottom: FgSpacing.s),
        iconColor: FgColors.primary,
        collapsedIconColor: FgColors.onSurface,
        title: Text(
          'ℹ Wie funktioniert Krypto? (tippen)',
          style: FgTypography.bodyM,
        ),
        children: [
          Text(
            'In echt darfst du Krypto erst ab 18 kaufen — Börsen wollen '
            'deinen Ausweis sehen. Hier kannst du gefahrlos üben.',
            style: FgTypography.bodyS,
          ),
          SizedBox(height: FgSpacing.xs),
          Text(
            'Kleinste Einheit (Protokoll): 1 Satoshi = 0,00000001 BTC = '
            '100 Mio-tel eines Bitcoin.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _BitcoinSummaryHeader extends StatelessWidget {
  const _BitcoinSummaryHeader({required this.portfolio});
  final CryptoPortfolio portfolio;

  @override
  Widget build(BuildContext context) {
    double totalBtc = 0;
    var totalValueCents = 0;
    var totalCostCents = 0;
    for (final h in portfolio.holdings) {
      final per = CryptoCatalog.btcPerShare(h.assetId);
      if (per <= 0) continue;
      totalBtc += per * h.shares;
      totalCostCents += h.averageBuyPrice.cents * h.shares;
      final q = portfolio.quotes[h.assetId];
      if (q != null) totalValueCents += q.pricePerShare.cents * h.shares;
    }
    if (totalBtc == 0) return const SizedBox.shrink();
    final pnlCents = totalValueCents - totalCostCents;
    final pnlColor = pnlCents < 0 ? FgColors.alert : FgColors.success;
    final sign = pnlCents >= 0 ? '+' : '';
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('₿', style: TextStyle(fontSize: 24)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(
                  'Gesamt: ${totalBtc.toStringAsFixed(4)} BTC',
                  style: FgTypography.bodyL,
                ),
              ),
              Text(
                Money.cents(totalValueCents).formatEur(),
                style: FgTypography.bodyL,
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            'Investiert ${Money.cents(totalCostCents).formatEur()}  ·  '
            'G/V $sign${Money.cents(pnlCents).formatEur()}',
            style: FgTypography.bodyS.copyWith(color: pnlColor),
          ),
        ],
      ),
    );
  }
}

class _CryptoRow extends ConsumerWidget {
  const _CryptoRow({
    required this.spec,
    required this.quote,
    required this.holding,
  });
  final CryptoSpec spec;
  final CryptoQuote quote;
  final CryptoHolding holding;

  /// Pure replay of yesterday's quote roll: applies the *inverse* of one
  /// day of `(1 + uniform[-vola, +vola])` motion. Because the listener
  /// is deterministic per (seed, id, dayIndex), we can compute the
  /// previous-day price by reversing the move using the same RNG seed
  /// the listener used.
  Money _yesterdayPrice(int currentDayIndex) {
    if (currentDayIndex <= 0) return spec.basePrice;
    // Re-derive the move the listener applied on advancing from
    // (currentDayIndex - 1) → currentDayIndex. We can't tell whether a
    // crash happened without DB access, so we treat the change as the
    // raw (current/prev) ratio — approximate by sampling the same RNG.
    // Simpler + safer: just expose the swing the LIVE roll would have
    // used and divide by it. The crash multiplier is captured in
    // `quote.pricePerShare` already.
    // Bug-fix v26: groupId statt id für Bitcoin-Konsistenz.
    final rngSeed = 0xC0FFEE ^ spec.groupId.hashCode ^ (currentDayIndex * 41);
    final rng = math.Random(rngSeed);
    final swing = (rng.nextDouble() * 2 - 1) * spec.volatility;
    final factor = 1 + swing;
    if (factor <= 0) return quote.pricePerShare;
    return Money.cents((quote.pricePerShare.cents / factor).round());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = quote.pricePerShare * holding.shares;
    final cost = holding.averageBuyPrice * holding.shares;
    final pnl = value - cost;

    // 24h-Change (approximate): compare current to derived yesterday.
    final yesterday = _yesterdayPrice(quote.onDayIndex);
    final deltaCents = quote.pricePerShare.cents - yesterday.cents;
    final deltaPct = yesterday.cents == 0
        ? 0.0
        : (deltaCents / yesterday.cents) * 100;
    final deltaColor =
        deltaCents < 0 ? FgColors.alert : FgColors.success;
    final hadGains = yesterday.cents < quote.pricePerShare.cents;
    final hypoteticalGain =
        Money.cents(quote.pricePerShare.cents - yesterday.cents);

    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      child: PixelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(spec.glyph, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: Text(spec.name, style: FgTypography.bodyL),
                ),
                Text(
                  '${deltaPct >= 0 ? '+' : ''}${deltaPct.toStringAsFixed(1)}%',
                  style: FgTypography.displayLarge.copyWith(color: deltaColor),
                ),
              ],
            ),
            const SizedBox(height: FgSpacing.xs),
            Text(
              'Aktueller Preis: ${quote.pricePerShare.formatEur()}',
              style: FgTypography.bodyM,
            ),
            const SizedBox(height: FgSpacing.xs),
            Text(
              hadGains
                  ? 'Wenn du gestern gekauft hättest: +${hypoteticalGain.formatEur()} pro Anteil.'
                  : 'Wenn du gestern gekauft hättest: ${hypoteticalGain.formatEur()} pro Anteil.',
              style: FgTypography.bodyS.copyWith(color: deltaColor),
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
      coinName: spec.name,
    );
    if (qty == null || qty <= 0) return;
    // Welle-8 Round 23: Panik-Sell-Coach bei ≥ -20 % vs Kaufpreis.
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
    final repo = ref.read(cryptoRepositoryProvider.notifier);
    try {
      if (buy) {
        repo.buy(assetId: spec.id, shares: qty);
      } else {
        repo.sell(assetId: spec.id, shares: qty);
      }
    } on CryptoError catch (e) {
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
    required String coinName,
  }) =>
      showModalBottomSheet<int>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true, // keyboard-overlap-fix
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _QtySheet(
            pricePerShare: pricePerShare,
            max: max,
            label: label,
            assetName: coinName,
          ),
        ),
      );
}

class _VulkanHistorySection extends StatelessWidget {
  const _VulkanHistorySection({required this.currentDayIndex});
  final int currentDayIndex;

  List<({int dayIndex, double dropPct})> _replayEruptions() {
    const probability = 0.02;
    const probSeed = 0xC4A5E1;
    const dropSeed = 0xD20F;
    final out = <({int dayIndex, double dropPct})>[];
    for (var d = 1; d <= currentDayIndex; d++) {
      final gate = math.Random(probSeed ^ (d * 2654435761));
      if (gate.nextDouble() >= probability) continue;
      final size = math.Random(dropSeed ^ (d * 2654435761));
      out.add((dayIndex: d, dropPct: 0.20 + size.nextDouble() * 0.30));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final eruptions = _replayEruptions();
    return PixelPanel(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          'Vulkan-Geschichte: vergangene Ausbrüche (${eruptions.length})',
          style: FgTypography.bodyM,
        ),
        children: [
          if (eruptions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(FgSpacing.s),
              child: Text(
                'Noch nie ausgebrochen.',
                style: FgTypography.bodyS,
              ),
            )
          else
            for (final e in eruptions.reversed)
              Padding(
                padding: const EdgeInsets.only(bottom: FgSpacing.xs),
                child: Text(
                  'Tag ${e.dayIndex}  −${(e.dropPct * 100).toStringAsFixed(0)}%',
                  style: FgTypography.bodyS.copyWith(color: FgColors.alert),
                ),
              ),
        ],
      ),
    );
  }
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
              Text('Summe ${total.formatEur()}', style: FgTypography.bodyL),
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
