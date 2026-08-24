import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/realestate/real_estate.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../../domain/sim/job_level.dart';
import '../settings/settings_repository.dart';
import 'real_estate_repository.dart';

/// spec-35 phase B + spec-44 sprint D: Trade-Page fuer Immobilien.
/// Zeigt die volle Wohnungs-Leiter (Eigentumswohnung -> MFH) mit
/// Anzahlung, Kaufnebenkosten, Hypothek + Monatsrate und ggf. Miete.
class RealEstateTradePage extends ConsumerWidget {
  const RealEstateTradePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final holdings = ref.watch(realEstateRepositoryProvider);
    final repo = ref.read(realEstateRepositoryProvider.notifier);
    // Miet-Anteil der aktuellen Lebenskosten — genau das spart, wer selbst
    // in seiner Immobilie wohnt.
    final job = JobConfig.forDay(
      dayIndex,
      startAgeYears:
          ref.watch(settingsRepositoryProvider.select((s) => s.startAgeYears)),
    );
    // Der Deckel: mehr als den Miet-Anteil der Lebenskosten kann keine
    // Immobilie sparen. Pro Objekt wird gleich noch mit dessen Marktmiete
    // verglichen — sonst spart die billigste Wohnung am meisten.
    final rentShare = JobConfig.monthlyRentShare(job);

    return PhoneFrame(
      appName: 'Wohnviertel',
      coachId: 'immobilie',
      coachTitle: 'Immobilien',
      coachMessage:
          'Du kaufst eine Wohnung oder ein Haus. Mieter zahlen dir jeden '
          'Monat Miete, der Wert wächst meist langsam. Aber: teuer im '
          'Einstieg + dein Geld ist lange gebunden.',
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cash: ${cash.formatEur()}', style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                Text(
                  'Wohnung kaufen: 20 % Anzahlung + 11 % Nebenkosten '
                  '(Notar, Grunderwerb) sofort. Der Rest läuft als Kredit '
                  '(Hypothek) über 30 Jahre.\n\n'
                  'Nach dem Kauf entscheidest du bei jeder Immobilie: '
                  'selbst einziehen oder vermieten. Selbst wohnen bringt '
                  'kein Geld aufs Konto, spart dir aber die Miete in den '
                  'Lebenskosten — höchstens ${rentShare.formatEur()}/Monat, '
                  'und nie mehr als die Wohnung selbst an Miete brächte. '
                  'Vermieten bringt Miete, aber du zahlst weiter deine '
                  'eigene Miete. Wohnen kannst du immer nur in einer.\n\n'
                  'Von der Miete gehen 25 % Steuer ab. Verkauf einer '
                  'vermieteten Immobilie vor 10 Jahren → nochmal 25 % '
                  'Steuer auf den Gewinn.',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          for (final spec in RealEstateCatalog.buyable) ...[
            _PropertyRow(
              spec: spec,
              holding: holdings.cast<RealEstateHolding?>().firstWhere(
                    (h) => h?.specId == spec.id,
                    orElse: () => null,
                  ),
              currentDayIndex: dayIndex,
              affordable: cash >= spec.cashAtPurchase,
              mortgageRemaining: (h) => repo.mortgageRemaining(h, dayIndex),
              monthlyPayment: (h) =>
                  repo.monthlyMortgagePayment(h, dayIndex),
              currentValue: (h) => repo.currentValueOf(h, dayIndex),
              onBuy: () {
                try {
                  repo.buy(spec.id, dayIndex);
                  showFgSnack(context, '${spec.name} gekauft');
                } on RealEstateError catch (e) {
                  showFgSnack(context, 'Fehler: ${e.message}',
                      isError: true);
                }
              },
              savedRent: JobConfig.savedRentFor(job, spec.monthlyRent),
              onChangeUsage: (usage) {
                try {
                  repo.setUsage(spec.id, usage);
                  showFgSnack(
                    context,
                    usage == RealEstateUsage.selfOccupied
                        ? 'Eingezogen — die Miete in deinen Lebenskosten '
                            'entfällt ab dem nächsten Monat.'
                        : 'Vermietet — Miete kommt monatlich, deine '
                            'Lebenskosten enthalten wieder Miete.',
                  );
                } on RealEstateError catch (e) {
                  showFgSnack(context, 'Geht nicht: ${e.message}',
                      isError: true);
                }
              },
              onSell: () {
                final result = repo.sell(spec.id, dayIndex);
                final msg = result.speculationTax.cents > 0
                    ? '${spec.name} verkauft — Spekulationssteuer '
                        '${result.speculationTax.formatEur()} faellig'
                    : '${spec.name} verkauft '
                        '(${result.netProceeds.formatEur()})';
                showFgSnack(context, msg);
              },
            ),
            const SizedBox(height: FgSpacing.s),
          ],
        ],
      ),
    );
  }
}

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.spec,
    required this.holding,
    required this.currentDayIndex,
    required this.affordable,
    required this.mortgageRemaining,
    required this.monthlyPayment,
    required this.currentValue,
    required this.onBuy,
    required this.onSell,
    required this.savedRent,
    required this.onChangeUsage,
  });

  final RealEstateSpec spec;
  final RealEstateHolding? holding;
  final int currentDayIndex;
  final bool affordable;
  final Money Function(RealEstateHolding) mortgageRemaining;
  final Money Function(RealEstateHolding) monthlyPayment;
  final Money Function(RealEstateHolding) currentValue;
  final VoidCallback onBuy;
  final VoidCallback onSell;

  /// Was DIESE Immobilie beim Selbstbewohnen spart: ihre Marktmiete,
  /// gedeckelt auf den Miet-Anteil der Lebenskosten.
  final Money savedRent;
  final void Function(RealEstateUsage) onChangeUsage;

  @override
  Widget build(BuildContext context) {
    final owned = holding != null;
    final ageYears = owned
        ? (currentDayIndex - holding!.ownedSinceDayIndex) / 365.0
        : 0.0;
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(spec.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(spec.name, style: FgTypography.bodyL),
              ),
              if (owned)
                const Text('OK', style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text('Kaufpreis: ${spec.basePrice.formatEur()}',
              style: FgTypography.bodyS),
          Text(
            'Anzahlung: ${spec.downPayment.formatEur()} - Nebenkosten: '
            '${spec.kaufnebenkosten.formatEur()} -> Sofort faellig: '
            '${spec.cashAtPurchase.formatEur()}',
            style: FgTypography.bodyS,
          ),
          Text(
            'Hypothek: ${spec.initialMortgage.formatEur()} über '
            '${spec.mortgageTermYears} Jahre · Zins '
            '${(spec.mortgageRateBpsPerYear / 100).toStringAsFixed(1)} %/J',
            style: FgTypography.bodyS,
          ),
          Text(
            'Instandhaltung: ${spec.monthlyMaintenance.formatEur()}/Monat',
            style: FgTypography.bodyS,
          ),
          if (spec.monthlyRent != null)
            Text(
              'Wenn vermietet: ${rentAfterTax(spec.monthlyRent!).formatEur()}'
              '/Monat (${spec.monthlyRent!.formatEur()} minus 25 % Steuer, '
              '${(spec.vacancyChancePerMonth * 100).toStringAsFixed(0)} % '
              'Leerstands-Risiko)',
              style: FgTypography.bodyS.copyWith(color: FgColors.success),
            ),
          Text(
            'Wertsteigerung: '
            '${(spec.appreciationPerYear * 100).toStringAsFixed(1)} %/Jahr',
            style: FgTypography.bodyS,
          ),
          if (owned) ...[
            const SizedBox(height: FgSpacing.xs),
            Text(
              'Im Besitz seit ${ageYears.toStringAsFixed(1)} Jahren - Wert '
              '${currentValue(holding!).formatEur()}',
              style: FgTypography.bodyS.copyWith(color: FgColors.success),
            ),
            Text(
              'Restschuld: ${mortgageRemaining(holding!).formatEur()}',
              style: FgTypography.bodyS,
              softWrap: true,
            ),
            Text(
              'Nächste Rate: ${monthlyPayment(holding!).formatEur()}',
              style: FgTypography.bodyS,
              softWrap: true,
            ),
            const SizedBox(height: FgSpacing.s),
            _UsageSwitch(
              spec: spec,
              usage: holding!.usage,
              savedRent: savedRent,
              onChange: onChangeUsage,
            ),
          ],
          const SizedBox(height: FgSpacing.s),
          if (owned)
            PixelButton(
              // v29: kürzeres Label damit Button-Text nicht überläuft.
              label: 'Verkaufen',
              background: FgColors.alert,
              foreground: FgColors.onSurface,
              onPressed: onSell,
            )
          else
            PixelButton(
              label: 'Kaufen (${spec.cashAtPurchase.formatEur()} cash)',
              background: FgColors.primary,
              foreground: FgColors.onPrimary,
              onPressed: affordable ? onBuy : null,
            ),
        ],
      ),
    );
  }
}

/// Umschalter „selbst bewohnen" ⇄ „vermieten" für eine gekaufte Immobilie.
///
/// Zeigt bewusst beide Seiten der Rechnung, statt nur einen Schalter: die
/// gesparte Miete ist unsichtbares Geld — sie taucht nirgends als Einnahme
/// auf, sie fehlt nur bei den Ausgaben. Genau das muss man an einem Eigenheim
/// verstehen.
class _UsageSwitch extends StatelessWidget {
  const _UsageSwitch({
    required this.spec,
    required this.usage,
    required this.savedRent,
    required this.onChange,
  });

  final RealEstateSpec spec;
  final RealEstateUsage usage;
  final Money savedRent;
  final void Function(RealEstateUsage) onChange;

  @override
  Widget build(BuildContext context) {
    if (!spec.canBeSelfOccupied) {
      return const Text(
        'Reines Anlageobjekt — hier wohnst du nicht selbst, es bleibt '
        'vermietet.',
        style: FgTypography.bodyS,
      );
    }
    final selfOccupied = usage == RealEstateUsage.selfOccupied;
    final rent = spec.monthlyRent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selfOccupied ? '🏠 Du wohnst hier selbst' : '🔑 Vermietet',
          style: FgTypography.bodyM.copyWith(
            color: selfOccupied ? FgColors.info : FgColors.success,
          ),
        ),
        const SizedBox(height: FgSpacing.xs),
        Text(
          selfOccupied
              ? 'Keine Mieteinnahme — dafür sparst du die Miete in deinen '
                  'Lebenskosten: ${savedRent.formatEur()}/Monat. Beim '
                  'Verkauf keine Spekulationssteuer.'
              : 'Bringt Miete, aber du zahlst weiter deine eigene Miete in '
                  'den Lebenskosten. Verkauf vor 10 Jahren: 25 % Steuer auf '
                  'den Gewinn.',
          style: FgTypography.bodyS,
        ),
        const SizedBox(height: FgSpacing.xs),
        PixelButton(
          label: selfOccupied
              ? (rent == null
                  ? 'Vermieten'
                  : 'Vermieten (+${rentAfterTax(rent).formatEur()}/Monat)')
              : 'Selbst einziehen (spart ${savedRent.formatEur()}/Monat)',
          background: FgColors.secondary,
          foreground: FgColors.onPrimary,
          onPressed: () => onChange(
            selfOccupied
                ? RealEstateUsage.rented
                : RealEstateUsage.selfOccupied,
          ),
        ),
      ],
    );
  }
}