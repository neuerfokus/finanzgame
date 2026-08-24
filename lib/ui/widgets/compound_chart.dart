import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Spec-42: Zinseszins-Vergleich-Chart.
/// 100 € Start, 40 Jahre, 4 Linien:
/// - 5 % jährlich AUSGEZAHLT (linear, grau gestrichelt)
/// - 3 % Zinseszins (blau)
/// - 5 % Zinseszins (grün)
/// - 7 % Zinseszins (orange)
class CompoundChart extends StatelessWidget {
  const CompoundChart({
    super.key,
    this.start = 100,
    this.years = 40,
    this.height = 280,
  });

  final double start;
  final int years;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legende
        const Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            // Analyse-Runde 2026-08: hieß „(real)" bzw. „(real-Schnitt)" —
            // beide Kurven sind aber NOMINAL gerechnet. In einer
            // Finanzbildungs-App ist das die falsche Lektion: 0,5 % sind bei
            // 2 % Inflation real NEGATIV, und der reale ETF-Schnitt liegt bei
            // ~5 %, nicht 7 %. Der Kaufkraft-Chart daneben macht die
            // real/nominal-Unterscheidung korrekt.
            _LegendItem(
              color: Color(0xFFFF6B9D),
              text: '0,5 % Sparkonto',
            ),
            _LegendItem(
              color: Color(0xFF888780),
              dashed: true,
              text: '5 % jährlich AUSGEZAHLT',
            ),
            _LegendItem(
              color: Color(0xFF378ADD),
              text: '3 % Zinseszins',
            ),
            _LegendItem(
              color: Color(0xFF1D9E75),
              text: '5 % Zinseszins',
            ),
            _LegendItem(
              color: Color(0xFFD85A30),
              text: '7 % ETF (Schnitt vor Inflation)',
            ),
          ],
        ),
        const SizedBox(height: FgSpacing.s),
        SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _CompoundPainter(start: start, years: years),
          ),
        ),
        const SizedBox(height: FgSpacing.xs),
        Text(
          'Aus ${start.round()} € nach $years Jahren: '
          '0,5 % Sparkonto → ${(start * math.pow(1.005, years)).round()} €  ·  '
          '3 % → ${(start * math.pow(1.03, years)).round()} €  ·  '
          '5 % → ${(start * math.pow(1.05, years)).round()} €  ·  '
          '7 % ETF → ${(start * math.pow(1.07, years)).round()} €. '
          'Alle Zahlen ohne Inflation gerechnet — was du dir davon kaufen '
          'kannst, ist weniger.',
          style: FgTypography.bodyS,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.text,
    this.dashed = false,
  });
  final Color color;
  final String text;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22,
          height: 4,
          child: CustomPaint(
            painter: _LegendLinePainter(color: color, dashed: dashed),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: FgTypography.bodyS),
      ],
    );
  }
}

class _LegendLinePainter extends CustomPainter {
  const _LegendLinePainter({required this.color, required this.dashed});
  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    if (dashed) {
      const dash = 4.0;
      const gap = 3.0;
      var x = 0.0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, size.height / 2),
          Offset(math.min(x + dash, size.width), size.height / 2),
          p,
        );
        x += dash + gap;
      }
    } else {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_LegendLinePainter old) => false;
}

class _CompoundPainter extends CustomPainter {
  const _CompoundPainter({required this.start, required this.years});
  final double start;
  final int years;

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 44.0;
    const padR = 8.0;
    const padT = 8.0;
    const padB = 24.0;
    final w = size.width - padL - padR;
    final h = size.height - padT - padB;

    // Series
    final spar = <double>[];
    final simple = <double>[];
    final c3 = <double>[];
    final c5 = <double>[];
    final c7 = <double>[];
    for (var y = 0; y <= years; y++) {
      spar.add(start * math.pow(1.005, y).toDouble());
      simple.add(start + start * 0.05 * y);
      c3.add(start * math.pow(1.03, y).toDouble());
      c5.add(start * math.pow(1.05, y).toDouble());
      c7.add(start * math.pow(1.07, y).toDouble());
    }
    final maxV = c7.last;

    // Grid + axes (Barrierefreiheit: sichtbarer Grauton statt Schwarz auf
    // dunklem BG).
    final axisPaint = Paint()
      ..color = FgColors.onSurfaceMuted
      ..strokeWidth = 1;
    final gridPaint = Paint()
      ..color = FgColors.onSurfaceMuted.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    final textStyle = FgTypography.bodyS.copyWith(fontSize: 11);

    // Y-axis ticks (5 steps)
    for (var i = 0; i <= 4; i++) {
      final v = maxV * i / 4;
      final y = padT + h - (v / maxV) * h;
      canvas.drawLine(
        Offset(padL, y),
        Offset(padL + w, y),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: '${v.round()} €', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(padL - tp.width - 4, y - tp.height / 2));
    }

    // X-axis ticks (jeder 10. Year)
    for (var yr = 0; yr <= years; yr += 10) {
      final x = padL + (yr / years) * w;
      canvas.drawLine(
        Offset(x, padT + h),
        Offset(x, padT + h + 4),
        axisPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: '$yr', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, padT + h + 6));
    }

    // Frame
    canvas.drawLine(
      const Offset(padL, padT),
      Offset(padL, padT + h),
      axisPaint,
    );
    canvas.drawLine(
      Offset(padL, padT + h),
      Offset(padL + w, padT + h),
      axisPaint,
    );

    // Plot lines
    void plot(List<double> data, Color color, {bool dashed = false}) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = dashed ? 2 : 2.5
        ..style = PaintingStyle.stroke;
      if (!dashed) {
        final path = Path();
        for (var i = 0; i < data.length; i++) {
          final x = padL + (i / years) * w;
          final y = padT + h - (data[i] / maxV) * h;
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        canvas.drawPath(path, paint);
      } else {
        // dashed
        for (var i = 0; i < data.length - 1; i += 2) {
          final x1 = padL + (i / years) * w;
          final y1 = padT + h - (data[i] / maxV) * h;
          final i2 = math.min(i + 1, data.length - 1);
          final x2 = padL + (i2 / years) * w;
          final y2 = padT + h - (data[i2] / maxV) * h;
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
        }
      }
    }

    plot(spar, const Color(0xFFFF6B9D));
    plot(simple, const Color(0xFF888780), dashed: true);
    plot(c3, const Color(0xFF378ADD));
    plot(c5, const Color(0xFF1D9E75));
    plot(c7, const Color(0xFFD85A30));

    // Axis-labels
    final xLabel = TextPainter(
      text: TextSpan(text: 'Jahre', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    xLabel.paint(
      canvas,
      Offset(padL + w / 2 - xLabel.width / 2, padT + h + 16),
    );
  }

  @override
  bool shouldRepaint(_CompoundPainter old) =>
      old.start != start || old.years != years;
}
