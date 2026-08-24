import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/vorsorge/vorsorge.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../daily_quiz/daily_quiz_state.dart';
import '../settings/settings_repository.dart';
import '../xp/xp_repository.dart';
import 'vorsorge_repository.dart';

/// spec-36: Vorsorge + Versicherungs-Übersicht.
class VorsorgePage extends ConsumerWidget {
  const VorsorgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contracts = ref.watch(vorsorgeRepositoryProvider);
    final repo = ref.read(vorsorgeRepositoryProvider.notifier);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;

    // Welle-8: Gate = Alter + XP-Schwelle + passende Quest/Quiz-Topic.
    // (Vorher nur Alter — spec-37.) Respektiert startAgeYears.
    final startAge = ref.watch(settingsRepositoryProvider).startAgeYears;
    final ageYears = startAge + dayIndex ~/ 365;
    final ageMonths = (dayIndex % 365) ~/ 30;
    final ageDays = (dayIndex % 365) % 30;
    final xp = ref.watch(xpRepositoryProvider);
    final learnedTopics = ref.watch(learnedTopicsProvider);

    bool meetsGate(VorsorgeSpec s) =>
        ageYears >= s.minAgeYears &&
        xp >= s.requiredXp &&
        (s.requiredTopic == null || learnedTopics.contains(s.requiredTopic));

    // Bereits abgeschlossene Verträge bleiben IMMER in der aktiven Liste
    // sichtbar — auch wenn das Gate (noch) nicht erfüllt ist. Sonst
    // verschwindet ein laufender Vertrag aus der Sicht (Welle-8 Bug).
    final ownedTypes = {for (final c in contracts) c.type};
    final eligible = VorsorgeCatalog.all
        .where((s) => meetsGate(s) || ownedTypes.contains(s.type))
        .toList();
    final locked = VorsorgeCatalog.all
        .where((s) => !meetsGate(s) && !ownedTypes.contains(s.type))
        .toList();

    return PhoneFrame(
      appName: 'Vorsorge',
      coachId: 'vorsorge',
      coachTitle: 'Vorsorge',
      coachMessage:
          'Schutz für Unerwartetes: Haftpflicht (wenn du was kaputt '
          'machst), Berufsunfähigkeit (wenn du nicht arbeiten kannst). '
          'Klein-Geld jetzt — große Sicherheit später.',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alter: $ageYears Jahre $ageMonths Monate '
                  '$ageDays Tage  •  Spieltag ${dayIndex + 1}',
                  style: FgTypography.bodyL,
                ),
                const SizedBox(height: FgSpacing.xs),
                const Text(
                  'ℹ️ Versicherungen kosten Monat für Monat Geld. Die '
                  'meisten sind als Spar-Form schlecht — Tipp: erst '
                  'ETF-Sparplan aufbauen, dann Versicherungen. '
                  '"Mindestlaufzeit" = wie lange du mindestens '
                  'einzahlen musst, bevor du wieder raus kannst.',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final spec in eligible) ...[
            _ContractCard(
              spec: spec,
              contract: contracts
                  .cast<VorsorgeContract?>()
                  .firstWhere(
                    (c) => c?.type == spec.type,
                    orElse: () => null,
                  ),
              dayIndex: dayIndex,
              currentAgeYears: ageYears,
              tooYoung: !meetsGate(spec),
              onSign: () {
                try {
                  repo.sign(spec.type, dayIndex);
                  showFgSnack(context, '${spec.name} abgeschlossen ✓');
                } on VorsorgeError catch (e) {
                  showFgSnack(context, 'Fehler: ${e.message}',
                      isError: true);
                }
              },
              onCancel: () {
                repo.cancel(spec.type);
                showFgSnack(context, '${spec.name} gekündigt');
              },
              onSettle: () {
                try {
                  repo.settle(spec.type, dayIndex);
                  showFgSnack(context, '${spec.name} ausgezahlt ✓');
                } on VorsorgeError catch (e) {
                  showFgSnack(context, e.message, isError: true);
                }
              },
            ),
            const SizedBox(height: FgSpacing.s),
          ],
          if (locked.isNotEmpty) ...[
            const SizedBox(height: FgSpacing.m),
            Text(
              'Später freigeschaltet:',
              style: FgTypography.bodyL.copyWith(color: FgColors.neutral),
            ),
            const SizedBox(height: FgSpacing.s),
            for (final spec in locked) ...[
              _LockedCard(
                spec: spec,
                currentAge: ageYears,
                currentXp: xp,
                hasTopic: spec.requiredTopic == null ||
                    learnedTopics.contains(spec.requiredTopic),
              ),
              const SizedBox(height: FgSpacing.s),
            ],
          ],
        ],
      ),
    );
  }
}

class _LockedCard extends StatelessWidget {
  const _LockedCard({
    required this.spec,
    required this.currentAge,
    required this.currentXp,
    required this.hasTopic,
  });
  final VorsorgeSpec spec;
  final int currentAge;
  final int currentXp;
  final bool hasTopic;

  @override
  Widget build(BuildContext context) {
    // Alle noch offenen Bedingungen auflisten — Spieler sieht genau was
    // fehlt (Alter / XP / Quest), nicht nur das Alter.
    final missing = <String>[];
    if (currentAge < spec.minAgeYears) {
      missing.add('Alter ${spec.minAgeYears} (du bist $currentAge)');
    }
    if (currentXp < spec.requiredXp) {
      missing.add('${spec.requiredXp} XP (du hast $currentXp)');
    }
    if (!hasTopic && spec.requiredTopic != null) {
      missing.add('eine Quest/Quiz zum Thema "${spec.requiredTopic}"');
    }
    final reason = missing.isEmpty
        ? 'Bald freigeschaltet'
        : 'Brauchst noch: ${missing.join(' · ')}';
    return Opacity(
      opacity: 0.6,
      child: PixelPanel(
        child: Row(
          children: [
            const Text('🔒', style: TextStyle(fontSize: 22)),
            const SizedBox(width: FgSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${spec.emoji} ${spec.name}',
                    style: FgTypography.bodyL,
                  ),
                  Text(reason, style: FgTypography.bodyS),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard({
    required this.spec,
    required this.contract,
    required this.dayIndex,
    required this.currentAgeYears,
    required this.tooYoung,
    required this.onSign,
    required this.onCancel,
    required this.onSettle,
  });

  final VorsorgeSpec spec;
  final VorsorgeContract? contract;
  final int dayIndex;
  final int currentAgeYears;
  final bool tooYoung;
  final VoidCallback onSign;
  final VoidCallback onCancel;
  final VoidCallback onSettle;

  @override
  Widget build(BuildContext context) {
    final owned = contract != null;
    final age = owned ? dayIndex - contract!.startedOnDayIndex : 0;
    final maturityReached = owned && age >= spec.lockDays;
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(spec.emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(spec.name, style: FgTypography.bodyL),
              ),
              if (owned)
                const Text('✔', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(spec.lessonShort, style: FgTypography.bodyS),
          const SizedBox(height: FgSpacing.xs),
          // Welle-8 Round 22 v3: BU/Hausrat/Lebensvers teurer je
          // später abgeschlossen. Zeige aktuelle Prämie für sign-Age.
          Builder(builder: (_) {
            final premiumNow = owned
                ? spec.monthlyPremiumAt(
                    currentAgeYears - (dayIndex - contract!.startedOnDayIndex) ~/ 365)
                : spec.monthlyPremiumAt(currentAgeYears);
            if (spec.ageFactorPerYear > 0 && !owned) {
              return Text(
                'Kostet jetzt: ${premiumNow.formatEur()} pro Monat\n'
                '(${spec.monthlyPremium.formatEur()} Basis mit 18 — '
                'wird mit jedem Jahr teurer)',
                style: FgTypography.bodyS.copyWith(color: FgColors.alert),
              );
            }
            return Text(
              'Kostet: ${premiumNow.formatEur()} pro Monat',
              style: FgTypography.bodyS,
            );
          }),
          if (spec.yearlyStateSubsidy.cents > 0)
            Text(
              'Staat zahlt dazu: '
              '${spec.yearlyStateSubsidy.formatEur()} pro Jahr',
              style:
                  FgTypography.bodyS.copyWith(color: FgColors.success),
            ),
          if (spec.lockDays > 0)
            Text(
              'Bindung: '
              '${(spec.lockDays / 365).toStringAsFixed(0)} Jahre '
              '(früher kündigen = Geld weg)',
              style: FgTypography.bodyS,
            ),
          if (spec.bonusOnMaturityPct > 0)
            Text(
              'Extra-Bonus am Ende: '
              '+${(spec.bonusOnMaturityPct * 100).toStringAsFixed(0)} %',
              style: FgTypography.bodyS,
            ),
          if (owned) ...[
            const SizedBox(height: FgSpacing.xs),
            Text(
              'Bisher eingezahlt: '
              '${contract!.totalContributed.formatEur()}',
              style: FgTypography.bodyS.copyWith(color: FgColors.info),
            ),
            if (contract!.totalSubsidy.cents > 0)
              Text(
                'Zulage gesamt: ${contract!.totalSubsidy.formatEur()}',
                style:
                    FgTypography.bodyS.copyWith(color: FgColors.success),
              ),
          ],
          const SizedBox(height: FgSpacing.s),
          if (tooYoung && !owned)
            const Text(
              'Du bist noch zu jung dafür.',
              style: FgTypography.bodyS,
            )
          else if (!owned)
            PixelButton(
              label: 'Abschließen',
              background: FgColors.primary,
              foreground: FgColors.onPrimary,
              onPressed: onSign,
            )
          else if (spec.lockDays > 0 || spec.bonusOnMaturityPct > 0)
            // Sparprodukt (Bausparer/Riester/Lebensvers): zwei Optionen.
            Row(
              children: [
                Expanded(
                  child: PixelButton(
                    label: 'Kündigen (Geld weg)',
                    background: FgColors.alert,
                    foreground: FgColors.onSurface,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: FgSpacing.s),
                Expanded(
                  child: PixelButton(
                    label: 'Auszahlen',
                    background: FgColors.success,
                    foreground: FgColors.onSurface,
                    onPressed: maturityReached ? onSettle : null,
                  ),
                ),
              ],
            )
          else
            // Welle-8 Round 22 v3: Risikoversicherung (BU/Hausrat) —
            // kein Vermögensaufbau, nur Schutz. Auszahlen unmöglich.
            // Kündigen = Schutz endet, kein Geld retour.
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Reine Versicherung — kein Sparbatzen, nur Schutz. '
                  'Beim Kündigen gibt es kein Geld zurück, der Schutz '
                  'endet einfach.',
                  style: FgTypography.bodyS,
                ),
                const SizedBox(height: FgSpacing.xs),
                PixelButton(
                  label: 'Kündigen (Schutz endet)',
                  background: FgColors.alert,
                  foreground: FgColors.onSurface,
                  onPressed: onCancel,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
