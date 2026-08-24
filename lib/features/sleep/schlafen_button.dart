import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../data/db/app_database_provider.dart';
import '../../core/game_clock.dart';
import '../../domain/sim/day_summary.dart';
import '../../ui/widgets/fg_snack.dart';
import '../economy/cash_state.dart';
import '../highscore/net_worth.dart';
import '../quest_runner/event_triggered_quests.dart';
import '../settings/save_export_service.dart';
import '../settings/settings_repository.dart';
import '../../domain/sim/day_event.dart';
import '../xp/xp_repository.dart';
import '../zimmer/achievements_repository.dart';
import 'ruhestand_page.dart';
import '../../domain/economy/money.dart' as econ;
import 'sleep_flow.dart';
import 'streak_milestones.dart';
import 'sleep_gate.dart';
import 'weekly_review_page.dart';

/// Button that triggers the sleep flow: advances the day and plays the cutscene.
///
/// Calls [onDone] after the player taps "Weiter →" on the day-summary screen.
class SchlafenButton extends ConsumerStatefulWidget {
  const SchlafenButton({
    this.onDone,
    this.label = 'Schlafen 😴',
    super.key,
  });

  final VoidCallback? onDone;
  final String label;

  @override
  ConsumerState<SchlafenButton> createState() => _SchlafenButtonState();
}

class _SchlafenButtonState extends ConsumerState<SchlafenButton> {
  bool _isLoading = false;

  Future<void> _onPressed() async {
    if (_isLoading) return;

    // spec-33: anti-glitch gate. Block sleep-spam to abuse plant growth.
    final settings = ref.read(settingsRepositoryProvider);
    const gate = SleepGate();
    final (epoch, count, cost, allowed) = gate.tryAdvance(
      lastEpochMs: settings.lastSleepEpochMs,
      count: settings.sleepCountInWindow,
    );
    if (!allowed) {
      showFgSnack(
        context,
        '😴 Schon ${SleepGate.maxSleepsInWindow}× in 8 Stunden geschlafen. '
        'Mach erstmal was anderes — Quest, Pflanzen, ETF kaufen.',
        isError: true,
      );
      return;
    }
    // Charge the escalating sleep cost up front. If the player is broke
    // we let it through (Hunger-Pfad in advanceDay still handles that).
    ref.read(cashStateProvider.notifier).spend(cost);
    ref.read(settingsRepositoryProvider.notifier).setSleepState(
          epochMs: epoch,
          count: count,
        );

    // Spec-40 C: Daily-Streak registrieren + Reward bei 3/7/30 Tagen.
    final newStreak = ref
        .read(settingsRepositoryProvider.notifier)
        .registerSleep(DateTime.now());
    _payStreakReward(newStreak);

    setState(() => _isLoading = true);

    final DaySummary summary;
    try {
      summary = await ref.read(gameClockProvider.notifier).advanceDay();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    // Sprint C4: Event-getriggerte Quests sichtbar machen.
    ref
        .read(eventTriggeredQuestsProvider.notifier)
        .registerFromEvents(summary.events);

    // Welle-8 Round 23: Auto-Save in Download/Finanzgame/ — fire-and-
    // forget. Überlebt Deinstall, beim Re-Install fragt App nach
    // Wiederherstellung. Silent failure wenn keine Storage-Perm.
    // Default AN — respektiert manuellen Aus-Schalter (Drift v36).
    final autoSaveSettings = ref.read(settingsRepositoryProvider);
    if (autoSaveSettings.autoSaveEnabled) {
      unawaited(
        SaveExportService.instance.writeAutoSave(
          safFolderUri: autoSaveSettings.backupFolderUri,
          // M7: die Sicherung wird über die Live-Verbindung gezogen
          // (`VACUUM INTO`), nicht als Rohkopie der Datei — sonst kann sie
          // mitten in den noch laufenden Commits dieses Spieltags entstehen.
          live: ref.read(appDatabaseProvider),
        ),
      );
    }

    if (!mounted) return;

    // Barrierefreiheit (WCAG 4.1.3): TalkBack-Ansage des Tagesergebnisses,
    // da die Cutscene rein visuell ist. Kurz + zahlenklar.
    final deltaCents = summary.cashAfter.cents - summary.cashBefore.cents;
    final vorzeichen = deltaCents >= 0 ? 'plus' : 'minus';
    final betrag = econ.Money.cents(deltaCents.abs()).formatEur();
    // announce() funktioniert auf Android weiterhin; sendAnnouncement-API
    // ist erst in neueren Flutter-Versionen stabil. TalkBack-Ansage.
    // ignore: deprecated_member_use
    SemanticsService.announce(
      'Neuer Tag. Konto $vorzeichen $betrag, '
      'jetzt ${summary.cashAfter.formatEur()}.',
      TextDirection.ltr,
    );

    // Spec-38 P3-1 + v29: bei LifetimeEnd ZUERST normale Sleep-Cutscene
    // + DaySummary laufen lassen (mit "⌛ 80 Jahre erreicht"-Event),
    // DANN RuhestandPage als finalen Bildschirm öffnen. Vorher sprang
    // er direkt — Übergang war abrupt + unsauber.
    final isLifetimeEnd =
        summary.events.any((e) => e is LifetimeEndEvent);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => SleepFlow(
          summary: summary,
          onDone: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
    if (!mounted) return;
    // Welle-8 Round 15: alle 7 Spieltage Wochen-Rückblick anzeigen.
    if (!isLifetimeEnd) {
      await _maybeShowWeeklyReview();
      if (!mounted) return;
    }
    if (isLifetimeEnd) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => const RuhestandPage(),
        ),
      );
    }
    widget.onDone?.call();
  }

  Future<void> _maybeShowWeeklyReview() async {
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final settings = ref.read(settingsRepositoryProvider);
    final lastReview = settings.lastWeeklyReviewDay;
    // Ersten Reviews bei dayIndex >= 7. Danach jeweils 7 Tage nach
    // letztem Review.
    if (dayIndex < 7) return;
    if (lastReview >= 0 && dayIndex - lastReview < 7) return;
    final currentNetWorth = ref.read(netWorthProvider(dayIndex));
    // Vorher-Wert: bei erstem Review = aktueller Wert minus 0 (kein
    // sinnvoller Vergleich). Setze 0 als Baseline-Indikator.
    final before = lastReview < 0 ? 0 : settings.lastWeekNetWorthCents;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => WeeklyReviewPage(
          netWorthBeforeCents: before,
          netWorthNowCents: currentNetWorth,
          onDone: () => Navigator.of(context).pop(),
        ),
      ),
    );
    ref.read(settingsRepositoryProvider.notifier).setWeeklyReviewSnapshot(
          netWorthCents: currentNetWorth,
          dayIndex: dayIndex,
        );
  }

  /// Optionen-Backlog #2: eskalierende, EINMALIGE Streak-Meilenstein-
  /// Belohnungen (7/14/30/100). Anti-Farm via claimedStreakMilestone —
  /// ersetzt den alten farmbaren 3/7/30-Switch.
  void _payStreakReward(int streak) {
    final settingsRepo = ref.read(settingsRepositoryProvider.notifier);
    final result = applyStreakMilestones(
      streakCount: streak,
      alreadyClaimed: settingsRepo.claimedStreakMilestone(),
      dayIndex: ref.read(gameClockProvider).dayIndex,
      unlock: (id, day) =>
          ref.read(achievementsRepositoryProvider.notifier).unlock(id, day),
      addXp: ref.read(xpRepositoryProvider.notifier).add,
      earnCents: (cents) =>
          ref.read(cashStateProvider.notifier).earn(econ.Money.cents(cents)),
      persistClaimed: settingsRepo.setClaimedStreakMilestone,
    );
    if (!result.hasReward || !mounted) return;
    final top = result.granted.last;
    showFgSnack(
      context,
      '${top.emoji} ${top.days}-Tage-Streak! Durchhalten lohnt sich: '
      '+${econ.Money.cents(result.totalCents).formatEur()} '
      '+${result.totalXp} XP',
      duration: const Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: FgColors.secondary,
          foregroundColor: FgColors.onSurface,
          disabledBackgroundColor: FgColors.backgroundElevated,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: FgColors.onSurface,
                ),
              )
            : Text(widget.label),
      ),
    );
  }
}
