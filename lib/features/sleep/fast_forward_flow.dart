import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../data/db/app_database_provider.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/day_event.dart';
import '../../ui/widgets/coach_overlay.dart';
import '../../ui/widgets/pixel_button.dart';
import '../settings/save_export_service.dart';
import '../settings/settings_repository.dart';

/// Spec-20: pick a jump length, watch the days fly by, see the aggregate.
///
/// Phases: [_Phase.pick] (3 buttons) → [_Phase.running] (loop +
/// progress text) → [_Phase.summary] (totals + Weiter).
class FastForwardFlow extends ConsumerStatefulWidget {
  const FastForwardFlow({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  ConsumerState<FastForwardFlow> createState() => _FastForwardFlowState();
}

enum _Phase { pick, running, summary }

class _FastForwardFlowState extends ConsumerState<FastForwardFlow> {
  _Phase _phase = _Phase.pick;
  FastForwardSummary? _summary;
  int _currentDay = 0;
  int _totalDays = 0;

  Future<void> _start(int days) async {
    // Welle-8: Bestätigung vor jedem Zeitsprung — User-Wunsch
    // "ich möchte einen Hinweis dass man nicht zurück kann".
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('⏩ Zeitsprung bestätigen',
            style: FgTypography.bodyL),
        content: Text(
          '$days Tage in einem Rutsch durchspielen?\n\n'
          '⚠ Achtung: Du kannst nicht zurück! Alle Tage werden '
          'durchgerechnet (Lohn, Crash, Inflation, Pflanzen…). '
          'Cash-Bestand + Vermögen ändern sich entsprechend.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Ja, los',
                style: FgTypography.bodyM
                    .copyWith(color: FgColors.success)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() {
      _phase = _Phase.running;
      _currentDay = 0;
      _totalDays = days;
    });
    try {
      final summary =
          await ref.read(gameClockProvider.notifier).fastForward(
        days,
        onProgress: (i) {
          if (!mounted) return;
          setState(() => _currentDay = i);
        },
      );
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _phase = _Phase.summary;
      });
      // Welle-8 Round 23: Auto-Save nach Zeitsprung — User-Bugreport.
      // Fire-and-forget, silent failure. Default AN (Drift v36 Aus-Schalter).
      final ffSettings = ref.read(settingsRepositoryProvider);
      if (ffSettings.autoSaveEnabled) {
        unawaited(
          SaveExportService.instance.writeAutoSave(
            safFolderUri: ffSettings.backupFolderUri,
            // M7: konsistente Momentaufnahme über die Live-Verbindung. Nach
            // einem Zeitsprung sind hier zehntausende `unawaited`-Commits
            // unterwegs — eine Rohkopie der Datei träfe mitten hinein.
            live: ref.read(appDatabaseProvider),
          ),
        );
      }
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Zeitsprung-Fehler: $e')),
      );
      setState(() => _phase = _Phase.pick);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FgColors.backgroundDeep,
      body: SafeArea(
        child: switch (_phase) {
          _Phase.pick => CoachOverlay(
              coachId: 'zeitsprung',
              title: '⏩ Zeitsprung — Risiko-Hinweis',
              message:
                  'Du kannst Tage, Monate oder Jahre überspringen. '
                  'Aber Achtung: Je weiter du springst, desto höher '
                  'die Chance auf ein "Krisenjahr" — Wirtschaftskrise '
                  'oder Bankenkrach. Dann verlieren Cash, Spar, '
                  'Aktien, ETF, Krypto und Gold gleichzeitig stark '
                  'an Wert.\n\n'
                  'Wie heftig und ob überhaupt — reiner Zufall. '
                  'Auch ein kurzer Sprung kann mal knallen, ein langer '
                  'mal glimpflich enden.\n\n'
                  'Kleiner springen = im Schnitt sicherer.',
              child: _PickPanel(onPick: _start),
            ),
          _Phase.running => _RunningPanel(
              currentDay: _currentDay,
              totalDays: _totalDays,
            ),
          _Phase.summary => _SummaryPanel(
              summary: _summary!,
              onDone: widget.onDone,
            ),
        },
      ),
    );
  }
}

class _PickPanel extends StatelessWidget {
  const _PickPanel({required this.onPick});

  final void Function(int days) onPick;

  /// Welle-8 Round 13: vorher zwei Confirms bei 90+ Tagen (spec-30
  /// Long-Jump + Welle-8 generischer Confirm). Jetzt nur _start() in
  /// FastForwardFlow zeigt EIN Bestätigungs-Dialog mit "kein zurück"-
  /// Hinweis. Hier nur weiterreichen.
  void _confirmAndPick(BuildContext context, int days) => onPick(days);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(FgSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('⏩ Zeitsprung', style: FgTypography.display),
          const SizedBox(height: FgSpacing.s),
          const Text(
            'Wie weit willst du spulen?\n'
            'Achtung: Tage werden echt simuliert — kein Zurück.',
            style: FgTypography.bodyM,
          ),
          const SizedBox(height: FgSpacing.xl),
          PixelButton(
            label: '7 Tage',
            background: FgColors.secondary,
            foreground: FgColors.onSurface,
            onPressed: () => _confirmAndPick(context, 7),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelButton(
            label: '30 Tage',
            background: FgColors.info,
            foreground: FgColors.onSurface,
            onPressed: () => _confirmAndPick(context, 30),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelButton(
            label: '3 Monate (90)',
            background: FgColors.info,
            foreground: FgColors.onSurface,
            onPressed: () => _confirmAndPick(context, 90),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelButton(
            label: '1 Jahr (365)',
            background: FgColors.alert,
            foreground: FgColors.onSurface,
            onPressed: () => _confirmAndPick(context, 365),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelButton(
            label: '5 Jahre (1825)',
            background: FgColors.alert,
            foreground: FgColors.onSurface,
            onPressed: () => _confirmAndPick(context, 1825),
          ),
          const SizedBox(height: FgSpacing.xl),
          PixelButton(
            label: 'Abbrechen',
            background: FgColors.neutral,
            foreground: FgColors.onSurface,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _RunningPanel extends StatelessWidget {
  const _RunningPanel({required this.currentDay, required this.totalDays});

  final int currentDay;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    final pct = totalDays == 0 ? 0.0 : (currentDay / totalDays).clamp(0.0, 1.0);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⏩', style: TextStyle(fontSize: 48)),
          const SizedBox(height: FgSpacing.m),
          const Text('Tage vergehen…', style: FgTypography.display),
          const SizedBox(height: FgSpacing.s),
          Text(
            'Tag ${currentDay + 1} von $totalDays',
            style: FgTypography.bodyM,
          ),
          const SizedBox(height: FgSpacing.l),
          SizedBox(
            width: 220,
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: FgColors.backgroundElevated,
              color: FgColors.primary,
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          Text('${(pct * 100).round()} %', style: FgTypography.bodyS),
        ],
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.summary, required this.onDone});

  final FastForwardSummary summary;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FgSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${summary.totalDays} Tage später…',
            style: FgTypography.display,
          ),
          // B6: Krisenjahr-Banner — falls Risiko-Roll getroffen hat.
          if (summary.crisisDropPct > 0)
            Container(
              margin: const EdgeInsets.only(top: FgSpacing.s),
              padding: const EdgeInsets.all(FgSpacing.s),
              decoration: BoxDecoration(
                color: FgColors.alert.withValues(alpha: 0.25),
                border: Border.all(color: FgColors.alert, width: 2),
              ),
              child: Text(
                '💥 KRISENJAHR — Wirtschaftskrise traf alle Märkte. '
                'Cash, Spar, Aktien, ETF, Krypto und Gold verloren '
                '${(summary.crisisDropPct * 100).round()} % Wert.',
                style: FgTypography.bodyM,
              ),
            ),
          // v29: Game-End-Hinweis falls Sprung 80-Jahre-Cap erreicht.
          if (summary.summaries
              .any((s) => s.events.any((e) => e is LifetimeEndEvent)))
            Container(
              margin: const EdgeInsets.only(top: FgSpacing.s),
              padding: const EdgeInsets.all(FgSpacing.s),
              decoration: BoxDecoration(
                color: FgColors.primary.withValues(alpha: 0.25),
                border: Border.all(color: FgColors.primary, width: 2),
              ),
              child: const Text(
                '🏁 SPIEL ZU ENDE — 80 Jahre erreicht. Highscore '
                'wurde eingetragen. Settings → "Reset" für neuen Versuch.',
                style: FgTypography.bodyM,
              ),
            ),
          const SizedBox(height: FgSpacing.m),
          const Divider(color: FgColors.secondary, thickness: 1),
          const SizedBox(height: FgSpacing.m),
          Expanded(
            child: ListView(
              children: [
                _StatRow(
                  icon: '💰',
                  label: 'Taschengeld gesamt',
                  value: Money.cents(summary.allowanceTotalCents).formatEur(),
                  color: FgColors.success,
                ),
                _StatRow(
                  icon: '🏦',
                  label: 'Giro (Cash)-Delta',
                  value: Money.cents(summary.cashDeltaCents).formatEur(),
                  color: summary.cashDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '💵',
                  label: 'Spar-Zinsen',
                  value: Money.cents(summary.savingsDeltaCents).formatEur(),
                  color: summary.savingsDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '📈',
                  label: 'ETF-Delta',
                  value: Money.cents(summary.etfDeltaCents).formatEur(),
                  color: summary.etfDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '📊',
                  label: 'Aktien-Delta',
                  value: Money.cents(summary.stockDeltaCents).formatEur(),
                  color: summary.stockDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '🪙',
                  label: 'Krypto-Delta',
                  value: Money.cents(summary.cryptoDeltaCents).formatEur(),
                  color: summary.cryptoDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '🥇',
                  label: 'Edelmetalle-Delta',
                  value: Money.cents(summary.metalDeltaCents).formatEur(),
                  color: summary.metalDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '🏠',
                  label: 'Immobilien-Delta',
                  value: Money.cents(summary.realEstateDeltaCents).formatEur(),
                  color: summary.realEstateDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '🖼️',
                  label: 'Sammlerobjekte-Delta',
                  value: Money.cents(summary.collectibleDeltaCents).formatEur(),
                  color: summary.collectibleDeltaCents >= 0
                      ? FgChart.up
                      : FgChart.down,
                ),
                _StatRow(
                  icon: '💥',
                  label: 'Crashs',
                  value: '${summary.crashCount}',
                  color: summary.crashCount > 0
                      ? FgColors.alert
                      : FgColors.neutral,
                ),
                if (summary.luckyEvents.isNotEmpty) ...[
                  const SizedBox(height: FgSpacing.m),
                  const Divider(color: FgColors.secondary, thickness: 1),
                  const SizedBox(height: FgSpacing.xs),
                  const Text(
                    'Besondere Ereignisse:',
                    style: FgTypography.bodyL,
                  ),
                  const SizedBox(height: FgSpacing.xs),
                  for (final e in summary.luckyEvents)
                    _StatRow(
                      icon: e.amountCents >= 0 ? '✨' : '⚠',
                      label: 'Tag ${e.dayIndex + 1}: ${e.title}',
                      value:
                          '${e.amountCents >= 0 ? "+" : ""}${Money.cents(e.amountCents).formatEur()}',
                      color: e.amountCents >= 0
                          ? FgChart.up
                          : FgChart.down,
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelButton(
            label: 'Weiter →',
            background: FgColors.primary,
            foreground: FgColors.onPrimary,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final String icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.s),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: FgSpacing.s),
          Expanded(
            child: Text(label, style: FgTypography.bodyM),
          ),
          Text(
            value,
            style: FgTypography.bodyM.copyWith(color: color),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
