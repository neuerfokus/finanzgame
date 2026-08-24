import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/pixel_panel.dart';

/// Bug-fix v26 / didaktisches Tool: Magisches Dreieck der Geldanlage.
///
/// Drei Slider (Sicherheit / Performance / Liquidität), Summe = 100. Wenn
/// der Spieler einen Slider bewegt, justieren sich die anderen zwei
/// proportional gegen. Output: empfohlener Asset-Mix.
///
/// Lehr-Botschaft: *Alle drei gleichzeitig hoch geht nicht — du musst
/// ein Eck opfern.*
class TriangleAdvisor extends StatefulWidget {
  const TriangleAdvisor({super.key});

  @override
  State<TriangleAdvisor> createState() => _TriangleAdvisorState();
}

class _TriangleAdvisorState extends State<TriangleAdvisor> {
  int _sicherheit = 50;
  int _rendite = 30;
  int _liquiditaet = 20;

  static const int _total = 100;

  void _rebalance(String which, int newVal) {
    newVal = newVal.clamp(0, _total);
    final old = switch (which) {
      'sicherheit' => _sicherheit,
      'rendite' => _rendite,
      _ => _liquiditaet,
    };
    final delta = newVal - old;
    if (delta == 0) return;
    final pool = _total - old; // Summe der anderen beiden
    setState(() {
      if (which == 'sicherheit') {
        _sicherheit = newVal;
        _distributeRest(pool, delta, ['rendite', 'liquiditaet']);
      } else if (which == 'rendite') {
        _rendite = newVal;
        _distributeRest(pool, delta, ['sicherheit', 'liquiditaet']);
      } else {
        _liquiditaet = newVal;
        _distributeRest(pool, delta, ['sicherheit', 'rendite']);
      }
      _normalize();
    });
  }

  void _distributeRest(int oldPool, int delta, List<String> others) {
    final a = others[0];
    final b = others[1];
    final aOld = _get(a);
    final bOld = _get(b);
    if (oldPool == 0) {
      final half = (-delta) ~/ 2;
      _set(a, half);
      _set(b, (-delta) - half);
      return;
    }
    final aShare = aOld / oldPool;
    final aNew = (aOld - delta * aShare).round();
    final bNew = (bOld - delta * (1 - aShare)).round();
    _set(a, aNew.clamp(0, _total));
    _set(b, bNew.clamp(0, _total));
  }

  int _get(String n) => switch (n) {
        'sicherheit' => _sicherheit,
        'rendite' => _rendite,
        _ => _liquiditaet,
      };

  void _set(String n, int v) {
    switch (n) {
      case 'sicherheit':
        _sicherheit = v;
      case 'rendite':
        _rendite = v;
      case 'liquiditaet':
        _liquiditaet = v;
    }
  }

  void _normalize() {
    final s = _sicherheit + _rendite + _liquiditaet;
    if (s == _total) return;
    final diff = _total - s;
    // Diff zum größten Eck adden.
    if (_sicherheit >= _rendite && _sicherheit >= _liquiditaet) {
      _sicherheit += diff;
    } else if (_rendite >= _liquiditaet) {
      _rendite += diff;
    } else {
      _liquiditaet += diff;
    }
  }

  /// Asset-Mix-Empfehlung aus Slidern. Heuristik je Asset:
  /// - Sparkonto: viel Sicherheit + etwas Liquidität
  /// - Cash/Giro: rein Liquidität
  /// - Vorsorge (Bausparer/Riester): rein Sicherheit (langfristig)
  /// - ETF: Hauptträger Rendite + Streuung gibt Sicherheit
  /// - Einzelaktien: rein Rendite (Klumpenrisiko)
  /// - Gold: Sicherheit, illiquide (kein L)
  /// - Silber/Platin: bisschen R + S
  /// - Bitcoin/Crypto: rein Rendite, sehr riskant
  /// - Immobilien: Rendite + bisschen Sicherheit, illiquide
  /// - Sammlerwerte: Rendite, illiquide, langfristig
  // Bug-fix v28: BTC bei reinem Performance-Slider auf Platz 1 — User-
  // Argument: historisch alles outperformt. Wenn Sicherheit dazu kommt,
  // sinkt BTC-Anteil zugunsten ETF + Spar.
  static Map<String, double> _rawMix(int s, int r, int l) => {
        'Sparkonto': s * 0.6 + l * 0.2,
        'Cash/Giro': l * 0.6,
        'Bitcoin/Crypto': r * 0.5,
        'ETF (breit)': r * 0.4 + s * 0.2,
        'Einzelaktien': r * 0.3,
        'Immobilien': r * 0.15 + s * 0.1,
        'Gold': s * 0.2,
        'Silber/Platin': r * 0.05 + s * 0.05,
      };

  List<({String label, int pct})> _mix() {
    final raw = _rawMix(_sicherheit, _rendite, _liquiditaet);
    final sum = raw.values.fold<double>(0, (a, b) => a + b);
    if (sum == 0) {
      return raw.keys.map((k) => (label: k, pct: 0)).toList();
    }
    final list = raw.entries
        .map((e) => (label: e.key, pct: (e.value / sum * 100).round()))
        .toList();
    // Rundungs-Drift aufs größte Eck adden.
    final total = list.fold<int>(0, (a, b) => a + b.pct);
    final fix = 100 - total;
    if (fix != 0) {
      list.sort((a, b) => b.pct.compareTo(a.pct));
      list[0] = (label: list[0].label, pct: list[0].pct + fix);
    }
    return list;
  }

  static String _glyphFor(String label) => switch (label) {
        'Sparkonto' => '🏦 ',
        'Cash/Giro' => '💵 ',
        'Vorsorge' => '🛡 ',
        'ETF (breit)' => '📊 ',
        'Einzelaktien' => '🏢 ',
        'Gold' => '🥇 ',
        'Silber/Platin' => '🥈 ',
        'Bitcoin/Crypto' => '₿ ',
        'Immobilien' => '🏠 ',
        'Sammlerwerte' => '🖼 ',
        _ => '• ',
      };

  @override
  Widget build(BuildContext context) {
    final mix = _mix();
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📐 Magisches Dreieck der Geldanlage',
              style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.xs),
          const Text(
            'Sicher, gute Rendite, schnell verfügbar — alle drei gleichzeitig '
            'hoch geht nicht. Du musst dich für 1–2 entscheiden.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          _Slider(
            label: '🛡 Sicherheit (kein Verlust-Risiko)',
            value: _sicherheit,
            onChanged: (v) => _rebalance('sicherheit', v),
          ),
          _Slider(
            label: '📈 Rendite (Geld wächst stark)',
            value: _rendite,
            onChanged: (v) => _rebalance('rendite', v),
          ),
          _Slider(
            label: '💧 Schnell verfügbar (kommt sofort aufs Konto)',
            value: _liquiditaet,
            onChanged: (v) => _rebalance('liquiditaet', v),
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
                const Text('Empfohlener Asset-Mix:',
                    style: FgTypography.bodyM),
                const SizedBox(height: FgSpacing.xs),
                for (final row in mix.where((m) => m.pct > 0))
                  _MixRow(
                    label: _glyphFor(row.label) + row.label,
                    pct: row.pct,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: FgTypography.bodyM)),
              Text('$value %', style: FgTypography.bodyM),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

class _MixRow extends StatelessWidget {
  const _MixRow({required this.label, required this.pct});
  final String label;
  final int pct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: FgTypography.bodyS)),
          SizedBox(
            width: 50,
            child: Text('$pct %',
                style: FgTypography.bodyS, textAlign: TextAlign.right),
          ),
          const SizedBox(width: FgSpacing.s),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 6,
                backgroundColor: FgColors.backgroundElevated,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(FgColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
