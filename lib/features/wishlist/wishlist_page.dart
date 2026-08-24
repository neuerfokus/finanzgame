import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../domain/wishlist/wish_item.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/purchasing_power_chart.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import 'wish_photo_service.dart';
import 'wishlist_repository.dart';

/// Wunschliste auf der Inflations-Atoll Insel.
///
/// Kategorien gruppieren Items. Owned-Sektion unten. Buy-Confirm-Modal.
class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wishlistRepositoryProvider);
    final cash = ref.watch(cashStateProvider);

    final active = items.where((i) => i.ownedOnDayIndex == null).toList();
    final owned = items.where((i) => i.ownedOnDayIndex != null).toList();

    return PhoneFrame(
      appName: 'Markt',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          Text(
            'Cash ${cash.formatEur()}',
            style: FgTypography.bodyL,
          ),
          const SizedBox(height: FgSpacing.s),
          // spec-33: short explainer for the % values below.
          Container(
            padding: const EdgeInsets.all(FgSpacing.s),
            decoration: BoxDecoration(
              color: FgColors.info.withValues(alpha: 0.15),
              border: Border.all(color: FgColors.info, width: 1),
              borderRadius:
                  const BorderRadius.all(Radius.circular(FgRadius.tight)),
            ),
            child: const Text(
              '📈 Inflation = Preise steigen mit der Zeit. Beispiel:\n'
              '• Tag 1: Sneaker kostet 80 €.\n'
              '• Tag 100: Sneaker kostet 84 € → +5 % teurer.\n'
              'Lerne daraus: Geld liegen lassen verliert an Wert. Wer '
              'investiert (ETF/Aktien), kann die Inflation schlagen.\n'
              'Rote Zahl = teurer geworden, grüne = günstiger.',
              style: FgTypography.bodyS,
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          // Welle-8 Round 23 v4: Kaufkraft-Verlust-Chart.
          const PurchasingPowerChart(),
          const SizedBox(height: FgSpacing.m),
          for (final c in WishCategory.values) ...[
            _CategoryHeader(category: c),
            for (final item in active.where((i) => i.category == c))
              _ItemRow(item: item),
            const SizedBox(height: FgSpacing.m),
          ],
          if (owned.isNotEmpty) ...[
            const SizedBox(height: FgSpacing.l),
            const Text('Deine Sachen', style: FgTypography.display),
            const SizedBox(height: FgSpacing.s),
            for (final item in owned) _OwnedRow(item: item),
          ],
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});
  final WishCategory category;

  String get _label => switch (category) {
        WishCategory.sneaker => 'Sneaker',
        WishCategory.social => 'Social',
        WishCategory.snack => 'Snacks',
        WishCategory.game => 'Games',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.xs),
      child: Text(_label, style: FgTypography.bodyL),
    );
  }
}

class _ItemRow extends ConsumerWidget {
  const _ItemRow({required this.item});
  final WishItem item;

  /// Annualisierte Inflations-Rate für diese Kategorie. Konstant pro
  /// Kategorie via InflationConfig.dailyDriftFor.
  double get _annualPct {
    final drift = InflationConfig.dailyDriftFor(item.category);
    return math.pow(1 + drift, 365).toDouble() - 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cash = ref.watch(cashStateProvider);
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final affordable = cash >= item.currentPrice;
    final owned = item.ownedOnDayIndex != null;

    // Welle-8 Round 22: Inflations-Anzeige bezieht sich auf Kauf-Zeitpunkt
    // (User-Feedback). Für owned Items: was hätte der Artikel HEUTE
    // gekostet vs Kaufpreis → Spar-Effekt durch frühen Kauf.
    String inflationLine = '';
    Color inflationColor = FgColors.alert;
    if (owned) {
      final daysSincePurchase = dayIndex - item.ownedOnDayIndex!;
      if (daysSincePurchase > 0) {
        final drift = InflationConfig.dailyDriftFor(item.category);
        final factor = math.pow(1 + drift, daysSincePurchase).toDouble();
        final marketToday = Money.cents(
          (item.currentPrice.cents * factor).round(),
        );
        final saved = marketToday - item.currentPrice;
        final yrs = daysSincePurchase / 365.0;
        inflationLine =
            'Heute wäre es: ${marketToday.formatEur()}  '
            '(${(_annualPct * 100).toStringAsFixed(1)} %/Jahr · '
            '${yrs < 1 ? '$daysSincePurchase Tage' : '${yrs.toStringAsFixed(1)} J'} her · '
            'gespart ${saved.formatEur()})';
        inflationColor = FgColors.success;
      }
    } else {
      inflationLine =
          'Inflation: ${(_annualPct * 100).toStringAsFixed(1)} %/Jahr — '
          'kostet jedes Jahr etwas mehr.';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.s),
      child: PixelPanel(
        child: Row(
          children: [
            _WishThumb(item: item, onPick: () => _pickPhoto(context, ref)),
            const SizedBox(width: FgSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: FgTypography.bodyL),
                  Text(
                    owned
                        ? 'Bezahlt: ${item.currentPrice.formatEur()}'
                        : 'Jetzt: ${item.currentPrice.formatEur()}  '
                            '(Start: ${item.basePrice.formatEur()})',
                    style: FgTypography.bodyS,
                  ),
                  if (inflationLine.isNotEmpty)
                    Text(
                      inflationLine,
                      style: FgTypography.bodyS.copyWith(color: inflationColor),
                    ),
                ],
              ),
            ),
            if (!owned)
              PixelButton(
                label: 'Kaufen',
                onPressed: affordable ? () => _confirm(context, ref) : null,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(wishlistRepositoryProvider.notifier);
    // Bereits Foto? Zeige Optionen: Neu wählen / Entfernen / Abbrechen.
    if (item.photoPath != null) {
      final choice = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: FgColors.backgroundElevated,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: FgColors.primary),
                title: const Text('Neues Foto wählen',
                    style: FgTypography.bodyM),
                onTap: () => Navigator.of(ctx).pop('pick'),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: FgColors.alert),
                title: const Text('Foto entfernen',
                    style: FgTypography.bodyM),
                onTap: () => Navigator.of(ctx).pop('remove'),
              ),
            ],
          ),
        ),
      );
      if (choice == 'remove') {
        final old = item.photoPath!;
        repo.setPhotoPath(item.id, null);
        await WishPhotoService.instance.delete(old);
        return;
      }
      if (choice != 'pick') return;
    }
    final path = await WishPhotoService.instance.pickAndStore(item.id);
    if (path != null) {
      repo.setPhotoPath(item.id, path);
    }
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConfirmSheet(item: item),
    );
    if (ok != true) return;
    try {
      ref.read(wishlistRepositoryProvider.notifier).buy(item.id);
    } on WishlistError catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message, style: FgTypography.bodyM)),
      );
    }
  }
}

/// Welle-8 Round 16: Thumbnail mit Foto oder Emoji + Camera-Overlay.
class _WishThumb extends StatelessWidget {
  const _WishThumb({required this.item, required this.onPick});

  final WishItem item;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = item.photoPath != null &&
        File(item.photoPath!).existsSync();
    return GestureDetector(
      onTap: onPick,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          children: [
            Positioned.fill(
              child: hasPhoto
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(FgRadius.tight),
                      child: Image.file(
                        File(item.photoPath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: FgColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnedRow extends ConsumerWidget {
  const _OwnedRow({required this.item});
  final WishItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final ownedDay = item.ownedOnDayIndex ?? dayIndex;
    final daysSincePurchase = dayIndex - ownedDay;
    final drift = InflationConfig.dailyDriftFor(item.category);
    final annualPct = math.pow(1 + drift, 365).toDouble() - 1;

    String detail;
    if (daysSincePurchase > 0) {
      final factor = math.pow(1 + drift, daysSincePurchase).toDouble();
      // Welle-8 Round 22 v4: 2 Werte für owned items.
      // 1) Markt-Heute: was dasselbe Ding heute neu kosten würde.
      // 2) Realwert deiner Zahlung: was deine damals X € heute noch
      //    an Kaufkraft hätten (inflations-bereinigt).
      final marketToday = Money.cents(
        (item.currentPrice.cents * factor).round(),
      );
      final realValueOfPayment = Money.cents(
        (item.currentPrice.cents / factor).round(),
      );
      final saved = marketToday - item.currentPrice;
      final lostBuyingPower = item.currentPrice - realValueOfPayment;
      final yrs = daysSincePurchase / 365.0;
      detail =
          'Bezahlt: ${item.currentPrice.formatEur()}\n'
          'Heute kostet sowas: ${marketToday.formatEur()} '
          '(gespart ${saved.formatEur()})\n'
          'Dein damals gezahlter Betrag hätte heute nur noch '
          '${realValueOfPayment.formatEur()} Kaufkraft '
          '(Inflations-Verlust ${lostBuyingPower.formatEur()})\n'
          '${(annualPct * 100).toStringAsFixed(1)} %/Jahr · '
          '${yrs < 1 ? '$daysSincePurchase Tage' : '${yrs.toStringAsFixed(1)} J'} her';
    } else {
      detail = 'Bezahlt: ${item.currentPrice.formatEur()} · '
          'Inflation ${(annualPct * 100).toStringAsFixed(1)} %/Jahr';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.s),
      child: PixelPanel(
        background: FgColors.backgroundDeep,
        child: Row(
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: FgSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: FgTypography.bodyL),
                  const SizedBox(height: FgSpacing.xs),
                  Text(
                    detail,
                    style: FgTypography.bodyS
                        .copyWith(color: FgColors.success),
                  ),
                ],
              ),
            ),
            const Text('✓', style: FgTypography.bodyL),
          ],
        ),
      ),
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({required this.item});
  final WishItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: PixelPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: FgSpacing.s),
              Text(item.name, style: FgTypography.display),
              const SizedBox(height: FgSpacing.s),
              Text(
                'Für ${item.currentPrice.formatEur()} kaufen?',
                style: FgTypography.bodyM,
              ),
              const SizedBox(height: FgSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PixelButton(
                    label: 'Abbrechen',
                    background: FgColors.neutral,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  PixelButton(
                    label: 'Kaufen',
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
