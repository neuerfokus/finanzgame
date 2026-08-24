import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Welle-8 Round 26: Sparziel-Rechner. „Ich will X € für etwas und spare
/// Y €/Monat → in N Monaten hab ich's." Brücke real↔Spiel: macht große
/// Wünsche planbar statt abstrakt.
class BudgetPlanner extends StatefulWidget {
  const BudgetPlanner({super.key});

  @override
  State<BudgetPlanner> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner> {
  double _goal = 240;
  double _monthly = 20;

  int get _months => math.max(1, (_goal / _monthly).ceil());

  static String _eur(num v) => '${v.round()} €';

  String get _durationText {
    final m = _months;
    if (m < 12) return '$m Monate';
    final years = m ~/ 12;
    final rest = m % 12;
    final yLabel = years == 1 ? '1 Jahr' : '$years Jahre';
    if (rest == 0) return '$m Monate (≈ $yLabel)';
    return '$m Monate (≈ $yLabel, $rest Mon.)';
  }

  @override
  Widget build(BuildContext context) {
    final goal = _goal.round();
    final monthly = _monthly.round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Du willst dir etwas leisten? Stell Ziel + Sparrate ein und sieh, '
          'wie lange es dauert.',
          style: FgTypography.bodyS,
        ),
        const SizedBox(height: FgSpacing.s),
        _LabeledSlider(
          label: 'Ziel: ${_eur(goal)}',
          value: _goal,
          min: 20,
          max: 1000,
          divisions: 49, // 20er-Schritte
          onChanged: (v) => setState(() => _goal = v),
        ),
        _LabeledSlider(
          label: 'Sparen pro Monat: ${_eur(monthly)}',
          value: _monthly,
          min: 5,
          max: 200,
          divisions: 39, // 5er-Schritte
          onChanged: (v) => setState(() => _monthly = v),
        ),
        const SizedBox(height: FgSpacing.s),
        Container(
          padding: const EdgeInsets.all(FgSpacing.s),
          decoration: BoxDecoration(
            color: FgColors.backgroundDeep,
            border: Border.all(color: FgColors.primary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mit ${_eur(monthly)}/Monat hast du ${_eur(goal)} in:',
                style: FgTypography.bodyM,
              ),
              const SizedBox(height: FgSpacing.xs),
              Text(
                _durationText,
                style: FgTypography.bodyL.copyWith(color: FgColors.success),
              ),
            ],
          ),
        ),
        const SizedBox(height: FgSpacing.xs),
        Text(
          'Tipp: Doppelte Sparrate = halbe Wartezeit. Und ein klares Ziel '
          'hält dich dran.',
          style: FgTypography.bodyS.copyWith(color: FgColors.info),
        ),
      ],
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FgTypography.bodyM),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: FgColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
