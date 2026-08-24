import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/etf/etf.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'savings_plan.dart';
import 'savings_plan_repository.dart';

/// spec-36 phase C: ETF-Sparplan-Editor.
class SavingsPlanPage extends ConsumerWidget {
  const SavingsPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(savingsPlanRepositoryProvider);
    final repo = ref.read(savingsPlanRepositoryProvider.notifier);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;

    return PhoneFrame(
      appName: 'Sparplan',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          const PixelPanel(
            child: Text(
              'ETF-Sparplan = jeden Monat automatisch denselben Betrag. '
              'Mal kaufst du teuer, mal günstig — gleicht sich aus '
              '(Dollar-Cost-Averaging).',
              style: FgTypography.bodyS,
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final p in plans) ...[
            _PlanRow(
              plan: p,
              onDelete: () {
                repo.remove(p.id);
                showFgSnack(context, 'Sparplan gelöscht');
              },
            ),
            const SizedBox(height: FgSpacing.s),
          ],
          const SizedBox(height: FgSpacing.m),
          _AddPlanForm(
            onSubmit: (assetId, monthly) {
              final id = DateTime.now().microsecondsSinceEpoch.toString();
              repo.add(SavingsPlan(
                id: id,
                assetClass: 'etf',
                assetId: assetId,
                monthly: monthly,
                startedOnDayIndex: dayIndex,
              ));
              showFgSnack(context, 'Sparplan angelegt ✓');
            },
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.plan, required this.onDelete});

  final SavingsPlan plan;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final spec = EtfCatalog.byId(plan.assetId);
    return PixelPanel(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spec.name, style: FgTypography.bodyL),
                Text(
                  '${plan.monthly.formatEur()} / Monat',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          PixelButton(
            label: 'Löschen',
            background: FgColors.alert,
            foreground: FgColors.onSurface,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _AddPlanForm extends StatefulWidget {
  const _AddPlanForm({required this.onSubmit});

  final void Function(String assetId, Money monthly) onSubmit;

  @override
  State<_AddPlanForm> createState() => _AddPlanFormState();
}

class _AddPlanFormState extends State<_AddPlanForm> {
  String? _assetId = EtfCatalog.all.first.id;
  final _amountCtrl = TextEditingController(text: '50');

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final eur = int.tryParse(_amountCtrl.text.trim());
    if (eur == null || eur <= 0) return;
    final id = _assetId;
    if (id == null) return;
    widget.onSubmit(id, Money.cents(eur * 100));
  }

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Neuer Sparplan', style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.s),
          DropdownButton<String>(
            value: _assetId,
            isExpanded: true,
            items: [
              for (final s in EtfCatalog.all)
                DropdownMenuItem(value: s.id, child: Text(s.name)),
            ],
            onChanged: (v) => setState(() => _assetId = v),
          ),
          const SizedBox(height: FgSpacing.s),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Monatlicher Betrag',
              suffixText: '€',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: 'Sparplan anlegen',
            background: FgColors.primary,
            foreground: FgColors.onPrimary,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
