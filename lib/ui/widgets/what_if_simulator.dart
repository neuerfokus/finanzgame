import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Welle-8 Round 24 (#3): „Was wäre wenn?"-Simulator für den Wissens-Bereich.
///
/// Zwei Regler — Start-Alter (14-40) + monatlicher Sparbetrag (25-200 €) —
/// und rechnet mit 7 % ETF-Schnitt (Zinseszins, monatliche Einzahlung) bis
/// zum Alter 65. Macht den persönlichen Zinseszins-Effekt greifbar: früh
/// anfangen schlägt viel-aber-spät.
class WhatIfSimulator extends StatefulWidget {
  const WhatIfSimulator({super.key});

  @override
  State<WhatIfSimulator> createState() => _WhatIfSimulatorState();
}

class _WhatIfSimulatorState extends State<WhatIfSimulator> {
  static const int _retireAge = 65;
  static const double _annualReturn = 0.07;

  double _startAge = 14;
  double _monthly = 50;

  /// Endwert einer monatlich eingezahlten Sparrate bei [_annualReturn] bis 65.
  ({int paid, int endValue}) _compute() {
    final months = (_retireAge - _startAge.round()) * 12;
    if (months <= 0) {
      final paid = (_monthly.round()).toDouble();
      return (paid: paid.round(), endValue: paid.round());
    }
    const r = _annualReturn / 12;
    final fv = _monthly * ((math.pow(1 + r, months) - 1) / r);
    final paid = _monthly * months;
    return (paid: paid.round(), endValue: fv.round());
  }

  static String _eur(int v) {
    final s = v.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${v < 0 ? '-' : ''}${buf.toString()} €';
  }

  @override
  Widget build(BuildContext context) {
    final res = _compute();
    final gain = res.endValue - res.paid;
    final age = _startAge.round();
    final monthly = _monthly.round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stell die Regler ein und sieh, was bis zum Alter 65 daraus wird '
          '(7 % ETF-Schnitt, Zinseszins).',
          style: FgTypography.bodyS,
        ),
        const SizedBox(height: FgSpacing.s),
        _LabeledSlider(
          label: 'Start-Alter: $age Jahre',
          value: _startAge,
          min: 14,
          max: 40,
          divisions: 26,
          onChanged: (v) => setState(() => _startAge = v),
        ),
        _LabeledSlider(
          label: 'Sparen pro Monat: $monthly €',
          value: _monthly,
          min: 25,
          max: 200,
          divisions: 35,
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
                'Mit $age anfangen → bei 65:',
                style: FgTypography.bodyM,
              ),
              const SizedBox(height: FgSpacing.xs),
              _ResultRow(label: 'Selbst eingezahlt', value: _eur(res.paid)),
              _ResultRow(
                label: 'Endwert',
                value: _eur(res.endValue),
                color: FgColors.success,
                bold: true,
              ),
              _ResultRow(
                label: 'davon Zinsen-Gewinn',
                value: _eur(gain),
                color: FgColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: FgSpacing.xs),
        Text(
          'Tipp: Schieb das Start-Alter mal höher — du siehst, wie viel '
          'jedes Jahr früher ausmacht. Das ist die Macht des Zinseszins.',
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = (bold ? FgTypography.bodyL : FgTypography.bodyM)
        .copyWith(color: color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: FgTypography.bodyS),
          Text(value, style: style),
        ],
      ),
    );
  }
}
