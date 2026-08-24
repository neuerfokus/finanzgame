/// Welle-8 Round 23 v4: Kaufkraft-Verlust-Chart für Inflations-Insel.
///
/// Zeigt wie 100 € Cash über 10 Jahre an Kaufkraft verlieren bei
/// Basis-Inflation (~2 %/J). Didaktik: Geld liegen lassen = Wert
/// schrumpft. Vergleich: 5 % ETF schlägt Inflation.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../domain/wishlist/wish_item.dart';

class PurchasingPowerChart extends StatelessWidget {
  const PurchasingPowerChart({
    super.key,
    this.startEuro = 100,
    this.years = 10,
    this.height = 220,
  });

  final double startEuro;
  final int years;
  final double height;

  @override
  Widget build(BuildContext context) {
    const dailyRate = InflationConfig.dailyRate;
    final yearlyFactor = math.pow(1 + dailyRate, 365);
    final cashSeries = <double>[];
    final etfSeries = <double>[];
    for (var y = 0; y <= years; y++) {
      // Kaufkraft Cash: 100 € geteilt durch (1+inflation)^y
      final cashPower = startEuro / math.pow(yearlyFactor, y);
      cashSeries.add(cashPower);
      // ETF 5 % real-Rendite (nach Inflation). Nominal 7 %, Inflation 2 %.
      final etfReal = startEuro * math.pow(1.05, y);
      etfSeries.add(etfReal);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // L3 (Analyse 2026-08): stand hier als Konstante `_kYears = '10'`,
        // während Achse, Fußzeile und Semantics `years` nutzen. Ein
        // `PurchasingPowerChart(years: 20)` behauptete im Titel „über 10
        // Jahre" über einer 20-Jahres-Kurve. Der Default 10 verdeckt es.
        Text(
          '💸 Kaufkraft-Verlust von 100 € Cash über $years Jahre',
          style: FgTypography.bodyL,
        ),
        const SizedBox(height: FgSpacing.xs),
        const Text(
          'Geld liegen lassen → Kaufkraft schrumpft (rot).\n'
          'In ETF investieren → schlägt Inflation (grün).',
          style: FgTypography.bodyS,
        ),
        const SizedBox(height: FgSpacing.s),
        const Wrap(
          spacing: 12,
          children: [
            _LegendItem(color: FgColors.alert, text: 'Cash (Kaufkraft)'),
            _LegendItem(color: FgColors.success, text: 'ETF 5 %/J real'),
          ],
        ),
        const SizedBox(height: FgSpacing.s),
        SizedBox(
          height: height,
          // Barrierefreiheit: Diagramm hat keine Canvas-Semantik → für
          // TalkBack als Bild mit Daten-Zusammenfassung beschreiben.
          child: Semantics(
            image: true,
            label: 'Diagramm: Nach $years Jahren ist Cash noch '
                '${cashSeries.last.toStringAsFixed(0)} € wert, '
                'ETF wäre ${etfSeries.last.toStringAsFixed(0)} € real.',
            child: ExcludeSemantics(
              child: CustomPaint(
                painter: _Painter(
                  cashSeries: cashSeries,
                  etfSeries: etfSeries,
                  years: years,
                ),
                size: const Size(double.infinity, double.infinity),
              ),
            ),
          ),
        ),
        const SizedBox(height: FgSpacing.xs),
        Text(
          'Nach $years Jahren: Cash noch '
          '${cashSeries.last.toStringAsFixed(0)} € wert · '
          'ETF wäre ${etfSeries.last.toStringAsFixed(0)} € real.',
          style: FgTypography.bodyS.copyWith(color: FgColors.info),
        ),
      ],
    );
  }

}

class _Painter extends CustomPainter {
  _Painter({
    required this.cashSeries,
    required this.etfSeries,
    required this.years,
  });

  final List<double> cashSeries;
  final List<double> etfSeries;
  final int years;

  @override
  void paint(Canvas canvas, Size size) {
    final all = [...cashSeries, ...etfSeries];
    final maxV = all.reduce(math.max);
    const minV = 0.0;
    final w = size.width;
    final h = size.height - 24;
    const padL = 32.0;

    // Achsen
    final axis = Paint()
      ..color = FgColors.onSurfaceMuted
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(padL, 0), Offset(padL, h), axis);
    canvas.drawLine(Offset(padL, h), Offset(w, h), axis);

    void drawSeries(List<double> series, Color color) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      final path = Path();
      for (var i = 0; i < series.length; i++) {
        final x = padL + (w - padL) * i / (series.length - 1);
        final y = h - h * (series[i] - minV) / (maxV - minV);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    drawSeries(cashSeries, FgColors.alert);
    drawSeries(etfSeries, FgColors.success);

    // Y-Achsen-Label (Start + Max)
    void tp(String text, double y) {
      TextPainter(
        text: TextSpan(
          text: text,
          style: FgTypography.bodyS.copyWith(color: FgColors.onSurface),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, Offset(0, y));
    }
    tp('${maxV.toStringAsFixed(0)} €', 0);
    tp('0', h - 8);
    // X-Achse Jahre
    final yearTp = TextPainter(
      text: TextSpan(
        text: 'Jahr 0',
        // A11y: outline (#000) ist auf dunklem BG unsichtbar — nie Textfarbe.
        style: FgTypography.bodyS.copyWith(color: FgColors.onSurfaceMuted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    yearTp.paint(canvas, Offset(padL, h + 4));
    final endTp = TextPainter(
      text: TextSpan(
        text: 'Jahr $years',
        // A11y: outline (#000) ist auf dunklem BG unsichtbar — nie Textfarbe.
        style: FgTypography.bodyS.copyWith(color: FgColors.onSurfaceMuted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    endTp.paint(canvas, Offset(w - endTp.width, h + 4));
  }

  @override
  bool shouldRepaint(covariant _Painter old) =>
      old.cashSeries != cashSeries || old.etfSeries != etfSeries;
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 3, color: color),
        const SizedBox(width: 4),
        Text(text, style: FgTypography.bodyS),
      ],
    );
  }
}
