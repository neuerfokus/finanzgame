import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/budget_planner.dart';
import '../../ui/widgets/compound_chart.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../history/history_repository.dart';
import '../lucky_events/lucky_event_history_repository.dart';
import '../market_phase/diversification.dart';
import '../settings/settings_repository.dart';
import '../skills/skill_tree_data.dart';
import 'advisor_widget.dart';
import 'savings_repository.dart';

/// Bank-App page (spec-21).
///
/// Two accounts side-by-side (Giro = [CashState], Spar = [SavingsRepository])
/// with three preset transfer amounts in each direction. A daily 0.1 %
/// interest accrues via [SavingsInterestListener]; the history list reads
/// from the price-history table (assetId == 'savings'), populated only
/// once the listener-driven savings snapshot lands there in a future
/// sprint — for now we just show the current totals.
class BankPage extends ConsumerWidget {
  const BankPage({super.key});

  static const _transferAmounts = <Money>[
    Money.cents(1000),
    Money.cents(5000),
    Money.cents(10000),
    Money.cents(100000), // Spec-43 v9: 1000 € Schnellwahl
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    final savings = ref.watch(savingsRepositoryProvider);
    final total = cash + savings;
    ref.watch(historyRepositoryProvider);
    final savingsHistory = ref
        .read(historyRepositoryProvider.notifier)
        .seriesFor('savings');

    return PhoneFrame(
      appName: 'Bank',
      coachId: 'bank',
      coachTitle: 'Bank',
      coachMessage:
          'Hier hast du zwei Konten: Giro für tägliche Ausgaben + Spar '
          'für deinen Notgroschen. Spar bringt kleine Zinsen — sicher, '
          'aber langsam. Investieren später über Inseln.',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: FgSpacing.l,
          vertical: FgSpacing.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OverviewSection(cash: cash, savings: savings, total: total),
            const SizedBox(height: FgSpacing.l),
            _TransferSection(
              title: 'Auf Spar überweisen',
              icon: Icons.arrow_upward,
              amounts: _transferAmounts,
              enabled: (amt) => cash >= amt,
              onPick: (amt) => _onDeposit(context, ref, amt),
            ),
            const SizedBox(height: FgSpacing.s),
            // spec-33: free-form Cent-precise transfer for plant yields.
            _CustomTransferRow(
              label: '➜ Spar (eigener Betrag)',
              onSubmit: (amt) => _onDeposit(context, ref, amt),
              maxCents: cash.cents,
            ),
            const SizedBox(height: FgSpacing.l),
            _TransferSection(
              title: 'Vom Spar abheben',
              icon: Icons.arrow_downward,
              amounts: _transferAmounts,
              enabled: (amt) => savings >= amt,
              onPick: (amt) => _onWithdraw(context, ref, amt),
            ),
            const SizedBox(height: FgSpacing.s),
            _CustomTransferRow(
              label: '⬅ Giro (eigener Betrag)',
              onSubmit: (amt) => _onWithdraw(context, ref, amt),
              maxCents: savings.cents,
            ),
            const SizedBox(height: FgSpacing.l),
            _HistorySection(savingsHistory: savingsHistory),
            const SizedBox(height: FgSpacing.l),
            const _LuckyEventHistorySection(),
            const SizedBox(height: FgSpacing.l),
            const _DiversificationCard(),
            const SizedBox(height: FgSpacing.l),
            // Spec-42: Zinseszins-Vergleich-Chart sichtbar im Bank-App,
            // damit Spieler den Effekt vom Sparen + Compound sieht.
            const PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💡 Zinseszins-Magie',
                      style: FgTypography.bodyL),
                  SizedBox(height: FgSpacing.xs),
                  Text(
                    'Was passiert mit 100 €, wenn man sie 40 Jahre lang '
                    'anlegt? Vergleich: Zinsen ausgezahlt vs reinvestiert.',
                    style: FgTypography.bodyS,
                  ),
                  SizedBox(height: FgSpacing.s),
                  CompoundChart(),
                ],
              ),
            ),
            const SizedBox(height: FgSpacing.l),
            // Welle-8 Round 26: Sparziel-Rechner — macht große Wünsche
            // planbar (Ziel + Sparrate → Dauer).
            const PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎯 Sparziel-Rechner', style: FgTypography.bodyL),
                  SizedBox(height: FgSpacing.s),
                  BudgetPlanner(),
                ],
              ),
            ),
            const SizedBox(height: FgSpacing.l),
            const _SavingsRateSection(),
            const SizedBox(height: FgSpacing.l),
            const TriangleAdvisor(),
            const SizedBox(height: FgSpacing.xl),
          ],
        ),
      ),
    );
  }

  // Spec-43 v8: Snackbars bei Cash-Move entfernt (User-Feedback).
  // Balance-Update sichtbar im Header.
  void _onDeposit(BuildContext context, WidgetRef ref, Money amount) {
    final ok = ref.read(savingsRepositoryProvider.notifier).deposit(amount);
    if (!ok) _showSnack(context, 'Zu wenig Cash', isError: true);
  }

  void _onWithdraw(BuildContext context, WidgetRef ref, Money amount) {
    final ok = ref.read(savingsRepositoryProvider.notifier).withdraw(amount);
    if (!ok) _showSnack(context, 'Zu wenig Sparguthaben', isError: true);
  }

  void _showSnack(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: FgTypography.bodyM),
        duration: const Duration(seconds: 1),
        backgroundColor: isError ? FgColors.alert : null,
      ),
    );
  }
}

/// Spec-44 E3: Pay-yourself-first Slider. Anteil des Allowance + Salary,
/// der ZUERST aufs Spar geschoben wird statt aufs Giro.
/// Welle-8 Round 22 fix: Slider war ConsumerWidget mit onChanged direkt
/// auf setSavingsRatePct — feuerte 100×/Drag. Persist als
/// unawaited-Fire-and-forget hat User-Kill nicht überlebt.
/// Jetzt ConsumerStatefulWidget mit lokalem Drag-Wert + Persist nur
/// onChangeEnd (1× pro Drag) → sicher persistent.
class _SavingsRateSection extends ConsumerStatefulWidget {
  const _SavingsRateSection();

  @override
  ConsumerState<_SavingsRateSection> createState() =>
      _SavingsRateSectionState();
}

class _SavingsRateSectionState extends ConsumerState<_SavingsRateSection> {
  double? _drag;

  @override
  Widget build(BuildContext context) {
    final persistedPct = ref.watch(settingsRepositoryProvider).savingsRatePct;
    // Round 28: Skill „Sparroutine" hebt das Spar-zuerst-Limit von 50 %
    // auf 100 %. Ohne Skill bleibt es bei 50 % (additiver Anreiz, kein
    // Rendite-Boost).
    final hasHighCap = ref
        .read(settingsRepositoryProvider.notifier)
        .hasSkill(SkillEffects.paySliderHighCap);
    final cap = hasHighCap ? 100 : 50;
    final rawPct = (_drag ?? persistedPct.toDouble()).round();
    final pct = rawPct > cap ? cap : rawPct;
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡 Zuerst dich bezahlen',
              style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.xs),
          const Text(
            'Wieviel Prozent vom Taschengeld + Lohn soll automatisch '
            'aufs Spar-Konto wandern — bevor du was ausgeben kannst? '
            'Wer zuerst spart, hat am Monatsende noch was übrig.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          Row(
            children: [
              Text('$pct %', style: FgTypography.displayLarge),
              Expanded(
                child: Slider(
                  value: pct.toDouble(),
                  min: 0,
                  max: cap.toDouble(),
                  divisions: cap ~/ 5,
                  onChanged: (v) => setState(() => _drag = v),
                  onChangeEnd: (v) {
                    ref
                        .read(settingsRepositoryProvider.notifier)
                        .setSavingsRatePct(v.round());
                    setState(() => _drag = null);
                  },
                ),
              ),
            ],
          ),
          if (!hasHighCap) ...[
            const SizedBox(height: FgSpacing.xs),
            Text(
              '🌟 Skill „Sparroutine" hebt das Limit auf 100 %.',
              style:
                  FgTypography.bodyS.copyWith(color: FgColors.onSurfaceMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({
    required this.cash,
    required this.savings,
    required this.total,
  });

  final Money cash;
  final Money savings;
  final Money total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Übersicht', style: FgTypography.display.copyWith(fontSize: 20)),
          const SizedBox(height: FgSpacing.m),
          _AccountRow(label: 'Giro', amount: cash, emoji: '💳'),
          const SizedBox(height: FgSpacing.s),
          _AccountRow(label: 'Spar', amount: savings, emoji: '🏦'),
          const Divider(color: FgColors.neutral, height: FgSpacing.l),
          _AccountRow(label: 'Total', amount: total, emoji: '💰'),
          const SizedBox(height: FgSpacing.s),
          const Text(
            'Sparkonto: 0,15 % / Monat  (≈ 1,8 % / Jahr)',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.label,
    required this.amount,
    required this.emoji,
  });

  final String label;
  final Money amount;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: FgTypography.bodyL),
        const SizedBox(width: FgSpacing.s),
        Expanded(child: Text(label, style: FgTypography.bodyL)),
        Text(amount.formatEur(), style: FgTypography.bodyL),
      ],
    );
  }
}

/// spec-33: Cent-precise free-form transfer. Accepts comma or dot decimal
/// separators and silently clamps to [maxCents] so plant yields ending in
/// non-round cents don't strand on the cash account.
class _CustomTransferRow extends StatefulWidget {
  const _CustomTransferRow({
    required this.label,
    required this.onSubmit,
    required this.maxCents,
  });

  final String label;
  final void Function(Money) onSubmit;
  final int maxCents;

  @override
  State<_CustomTransferRow> createState() => _CustomTransferRowState();
}

class _CustomTransferRowState extends State<_CustomTransferRow> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _ctrl.text.trim().replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return;
    final cents = (value * 100).round().clamp(1, widget.maxCents);
    if (cents <= 0) return;
    widget.onSubmit(Money.cents(cents));
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            style: FgTypography.bodyM,
            decoration: InputDecoration(
              isDense: true,
              labelText: widget.label,
              labelStyle: FgTypography.bodyS,
              suffixText: '€',
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: FgSpacing.s),
        PixelButton(
          label: 'OK',
          background: FgColors.primary,
          foreground: FgColors.onPrimary,
          onPressed: _submit,
        ),
      ],
    );
  }
}

class _TransferSection extends StatelessWidget {
  const _TransferSection({
    required this.title,
    required this.icon,
    required this.amounts,
    required this.enabled,
    required this.onPick,
  });

  final String title;
  final IconData icon;
  final List<Money> amounts;
  final bool Function(Money) enabled;
  final void Function(Money) onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: FgColors.primary, size: 18),
            const SizedBox(width: FgSpacing.s),
            Text(title, style: FgTypography.bodyL),
          ],
        ),
        const SizedBox(height: FgSpacing.s),
        Wrap(
          spacing: FgSpacing.s,
          runSpacing: FgSpacing.s,
          children: [
            for (final amt in amounts)
              PixelButton(
                label: amt.formatEur(),
                background: FgColors.success,
                foreground: FgColors.onSurface,
                onPressed: enabled(amt) ? () => onPick(amt) : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.savingsHistory});

  final List<Money> savingsHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spar-Verlauf', style: FgTypography.display.copyWith(fontSize: 20)),
          const SizedBox(height: FgSpacing.xs),
          const Text(
            'Stand des Sparkontos pro Spieltag (max. letzte 10 Tage).',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          if (savingsHistory.isEmpty)
            const Text(
              'Noch keine Tage gespielt — schlafe und der Verlauf füllt sich.',
              style: FgTypography.bodyS,
            )
          else
            for (var i = savingsHistory.length - 1;
                i >= 0 && i > savingsHistory.length - 11;
                i--)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Tag ${i + 1}', style: FgTypography.bodyS),
                    ),
                    Text(
                      savingsHistory[i].formatEur(),
                      style: FgTypography.bodyS,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

/// Spec-45 F4: Diversifikations-Score zeigt wie viele Asset-Klassen
/// der Spieler hält und wie stark Schwankungen gedämpft sind.
class _DiversificationCard extends ConsumerWidget {
  const _DiversificationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(diversificationClassCountProvider);
    final damp = volatilityDampening(classes);
    final pct = ((1 - damp) * 100).round();
    final color = classes >= 3 ? FgColors.success : FgColors.alert;
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 22)),
              const SizedBox(width: FgSpacing.s),
              const Text('Streuung deines Geldes',
                  style: FgTypography.bodyL),
              const Spacer(),
              Text('$classes / 6 Sorten',
                  style: FgTypography.bodyM.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            classes <= 1
                ? '⚠ Nur 1 Sorte — wenn die fällt, fällt alles.'
                : '✓ Schwankungen $pct % geringer als wenn du nur '
                  '1 Sorte hättest.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.xs),
          const Text(
            'Sorten: Spar-Konto · ETF · Aktien · Krypto · Gold/Silber · '
            'Immobilien',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

/// Spec-45 A2: Zufalls-Ereignis-Historie in Bank-App. Zeigt die letzten
/// 20 Events, sauber in Glück (positiv) und Pech (negativ) unterteilt —
/// jeweils in Auftritts-Reihenfolge.
class _LuckyEventHistorySection extends ConsumerWidget {
  const _LuckyEventHistorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(luckyEventHistoryRepositoryProvider);
    final entries = history.take(20).toList(growable: false);
    final gluck = entries.where((e) => e.amountCents >= 0).toList();
    final pech = entries.where((e) => e.amountCents < 0).toList();
    return PixelPanel(
      padding: const EdgeInsets.all(FgSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎲 Zufalls-Ereignisse',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: FgColors.primary,
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          if (entries.isEmpty)
            const Text(
              'Noch keine Events. Spiel ein paar Tage und schlafe — '
              'mit etwas Glück (oder Pech) kommt was rein.',
              style: TextStyle(fontSize: 14, color: FgColors.onSurface),
            )
          else ...[
            if (gluck.isNotEmpty) ...[
              const _EventGroupHeader('✨ Glück', FgColors.success),
              for (final e in gluck) _EventRow(e),
            ],
            if (gluck.isNotEmpty && pech.isNotEmpty)
              const SizedBox(height: FgSpacing.s),
            if (pech.isNotEmpty) ...[
              const _EventGroupHeader('⚠ Pech', FgColors.alert),
              for (final e in pech) _EventRow(e),
            ],
          ],
        ],
      ),
    );
  }
}

class _EventGroupHeader extends StatelessWidget {
  const _EventGroupHeader(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow(this.e);
  final LuckyEventEntry e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tag ${e.dayIndex}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: FgColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            (e.amountCents >= 0 ? '+' : '') +
                Money.cents(e.amountCents).formatEur(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: e.amountCents >= 0 ? FgColors.success : FgColors.alert,
            ),
          ),
        ],
      ),
    );
  }
}
