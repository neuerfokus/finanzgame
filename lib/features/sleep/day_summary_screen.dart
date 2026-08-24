import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/sim/day_event.dart';
import '../../domain/sim/day_summary.dart';
import '../../domain/sim/weather.dart';
import '../../domain/sim/weekday.dart';
import '../../domain/economy/money.dart';
import '../audio/sound_service.dart';
import '../crypto/crypto_repository.dart';
import '../etf/etf_repository.dart';
import '../market_phase/peak_tracker.dart';
import '../metal/metal_repository.dart';
import '../stock/stock_repository.dart';

/// Screen shown after the sleep cutscene, listing all events of the day.
///
/// Each event row pops in with a 60ms stagger via [flutter_animate].
/// The list scrolls if there are more than ~8 events.
class DaySummaryScreen extends ConsumerStatefulWidget {
  const DaySummaryScreen({
    required this.summary,
    required this.onContinue,
    super.key,
  });

  final DaySummary summary;
  final VoidCallback onContinue;

  @override
  ConsumerState<DaySummaryScreen> createState() => _DaySummaryScreenState();
}

class _DaySummaryScreenState extends ConsumerState<DaySummaryScreen> {
  // CrashEvent = Zeitsprung-Krisenwurf, CrashStartedEvent = Crash-Start aus
  // dem Phasen-System (seit dem Wegfall der alten Crash-Stage die reguläre
  // Quelle). Beide lösen Rumble + rotes Overlay aus.
  bool get _hasCrash => widget.summary.events
      .any((e) => e is CrashEvent || e is CrashStartedEvent);

  @override
  void initState() {
    super.initState();
    if (_hasCrash) {
      SoundService.instance.playSfx(AudioKey.crash);
    }
  }

  /// spec-32: keep only the price events the player is actually holding;
  /// everything else (weather, allowance, interest, crash, etc.) passes
  /// through unchanged.
  List<DayEvent> _filterRelevant(List<DayEvent> events) {
    final etf = ref.read(etfRepositoryProvider);
    final stock = ref.read(stockRepositoryProvider);
    final crypto = ref.read(cryptoRepositoryProvider);
    final metal = ref.read(metalRepositoryProvider);
    final etfIds = etf.holdings.map((h) => h.etfId).toSet();
    final stockIds = stock.holdings.map((h) => h.stockId).toSet();
    final cryptoIds = crypto.holdings.map((h) => h.assetId).toSet();
    final metalIds = metal.holdings.map((h) => h.assetId).toSet();
    return [
      for (final e in events)
        if (switch (e) {
          EtfPriceUpdateEvent(:final etfId) => etfIds.contains(etfId),
          StockPriceUpdateEvent(:final stockId) =>
            stockIds.contains(stockId),
          CryptoPriceUpdateEvent(:final assetId) =>
            cryptoIds.contains(assetId),
          MetalPriceUpdateEvent(:final assetId) =>
            metalIds.contains(assetId),
          _ => true,
        })
          e,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.summary.day;
    final events = _filterRelevant(widget.summary.events);

    final body = Scaffold(
      backgroundColor: FgColors.backgroundDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FgSpacing.l,
            vertical: FgSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tag ${day.dayIndex + 1} — ${day.weekday.fullNameDe}',
                style: FgTypography.display,
              ),
              const SizedBox(height: FgSpacing.m),
              const Divider(color: FgColors.secondary, thickness: 1),
              const SizedBox(height: FgSpacing.m),
              Expanded(
                child: events.isEmpty
                    ? const _EmptyEventsPlaceholder()
                    : ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _EventRow(event: event, index: index);
                        },
                      ),
              ),
              const SizedBox(height: FgSpacing.m),
              // Sprint C1: Beitrag pro Asset-Klasse + Buchverlust-Hinweis.
              const _AssetClassBreakdown(),
              const SizedBox(height: FgSpacing.m),
              const Divider(color: FgColors.secondary, thickness: 1),
              const SizedBox(height: FgSpacing.m),
              _ContinueButton(onContinue: widget.onContinue),
            ],
          ),
        ),
      ),
    );

    if (!_hasCrash) return body;

    // Spec-40 F: Eruption-Cutscene = roter Flash + Bildschirm-Shake.
    return Stack(
      children: [
        body
            .animate()
            .shake(
              hz: 8,
              offset: const Offset(8, 0),
              duration: 600.ms,
            ),
        IgnorePointer(
          child: Container(color: FgColors.alert)
              .animate()
              .fadeOut(duration: 800.ms, curve: Curves.easeOut),
        ),
      ],
    );
  }
}

/// Single event row with staggered pop-in animation.
class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.event,
    required this.index,
  });

  final DayEvent event;
  final int index;

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = _eventDisplay(event);
    // Welle-8 Round 25 (#6): Coin-Drop wieder rein. Der damals (Round 19 v2)
    // vermutete Crash war NICHT die Animation, sondern VorsorgeSpec.byType
    // ohne orElse (Round 19 v2-v4/20 gefixt). Jetzt nur für Zins-Zeilen:
    // eigenständiges Widget mit eigener Animation, greift nicht in die
    // staggered Row-animate-Kette ein. Fixe Größe → Zeile bleibt sichtbar
    // auch wenn Animation nicht läuft.
    final iconWidget = event is InterestEvent
        ? const _CoinDropIcon()
        : Text(icon, style: const TextStyle(fontSize: 20));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: FgSpacing.s),
          Expanded(
            child: Text(
              label,
              style: FgTypography.bodyM.copyWith(color: color),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 250.ms,
          delay: (index * 60).ms,
        )
        .slide(
          begin: const Offset(0.0, 0.2),
          end: Offset.zero,
          curve: Curves.easeOutBack,
          delay: (index * 60).ms,
        );
  }

  /// Maps a [DayEvent] to (icon, label, color) for display.
  (String, String, Color) _eventDisplay(DayEvent event) {
    return switch (event) {
      AllowanceEvent(:final amount) => (
          '💰',
          '+ ${amount.formatEur()}  Taschengeld',
          FgColors.success,
        ),
      InterestEvent(:final amount, :final accountId) => (
          '💱',
          '+ ${amount.formatEur()}  Zinsen ($accountId)',
          FgColors.success,
        ),
      BirthdayEvent(:final giftAmount) => (
          '🎂',
          '+ ${giftAmount.formatEur()}  Geburtstag',
          FgColors.primary,
        ),
      TemptationEvent(:final itemId, :final price) => (
          '🛍',
          'Versuchung: $itemId (${price.formatEur()})',
          FgColors.neutral,
        ),
      PlantGrowthEvent(:final plantId, :final newStage) => (
          '🌱',
          '$plantId wächst (Stufe $newStage)',
          FgColors.success,
        ),
      PlantReadyEvent(:final plantId) => (
          '🌾',
          '$plantId erntereif',
          FgColors.primary,
        ),
      PlantWitherEvent(:final plantId) => (
          '💀',
          'Sturm hat Pflanze $plantId zerstört',
          FgColors.alert,
        ),
      HarvestEvent(:final plantId, :final harvestYield) => (
          '🌾',
          '+ ${harvestYield.formatEur()}  Ernte $plantId',
          FgColors.success,
        ),
      InflationEvent(:final rate) => (
          '📈',
          'Inflation +${(rate * 100).toStringAsFixed(2)}%',
          FgColors.alert,
        ),
      WeatherEvent(:final kind) => (
          weatherEmoji(kind),
          'Wetter: ${weatherLabel(kind)} — ${describePlantImpact(kind)}, '
              '${describeEtfImpact(kind)}',
          FgColors.info,
        ),
      EtfPriceUpdateEvent(:final etfId, :final newPrice, :final deltaPct) => (
          deltaPct >= 0 ? '📈' : '📉',
          '$etfId  ${newPrice.formatEur()}  ${(deltaPct * 100).toStringAsFixed(2)}%',
          deltaPct >= 0 ? FgChart.up : FgChart.down,
        ),
      StockPriceUpdateEvent(:final stockId, :final newPrice, :final deltaPct) => (
          deltaPct >= 0 ? '📈' : '📉',
          '$stockId  ${newPrice.formatEur()}  ${(deltaPct * 100).toStringAsFixed(2)}%',
          deltaPct >= 0 ? FgChart.up : FgChart.down,
        ),
      CryptoPriceUpdateEvent(:final assetId, :final newPrice, :final deltaPct) => (
          deltaPct >= 0 ? '🚀' : '💩',
          '$assetId  ${newPrice.formatEur()}  ${(deltaPct * 100).toStringAsFixed(2)}%',
          deltaPct >= 0 ? FgChart.up : FgChart.down,
        ),
      MetalPriceUpdateEvent(:final assetId, :final newPrice, :final deltaPct) => (
          deltaPct >= 0 ? '🥇' : '🥈',
          '$assetId  ${newPrice.formatEur()}  ${(deltaPct * 100).toStringAsFixed(2)}%',
          deltaPct >= 0 ? FgChart.up : FgChart.down,
        ),
      CrashEvent(:final dropPct) => (
          '💥',
          'CRASH! −${(dropPct * 100).toStringAsFixed(0)}% auf alle Märkte',
          FgColors.alert,
        ),
      SleepCostEvent(:final hunger, :final amount) => hunger
          ? (
              '😴',
              'Hunger! Du hast nichts gegessen — Erträge heute null.',
              FgColors.alert,
            )
          : (
              '🍽',
              'Essen + Snacks: ${amount.formatEur()}',
              FgColors.neutral,
            ),
      LifetimeEndEvent() => (
          '⌛',
          'Lebensresümee — du hast 80 Jahre erreicht',
          FgColors.primary,
        ),
      RentIncomeEvent(:final amount, :final propertyId) => (
          '🏠',
          '+ ${amount.formatEur()}  Miete ($propertyId)',
          FgColors.success,
        ),
      SalaryEvent(
        :final amount,
        :final jobLevel,
        :final grossAmount,
        :final taxAmount,
        :final socialAmount,
        :final soliAmount,
        :final kircheAmount,
      ) =>
        grossAmount.cents > 0
            ? (
                '💼',
                '+ ${amount.formatEur()}  Netto-Lohn ($jobLevel)\n'
                    '   Brutto ${grossAmount.formatEur()} '
                    '− Steuer ${taxAmount.formatEur()} '
                    '− Soli ${soliAmount.formatEur()}\n'
                    '   − Kirche ${kircheAmount.formatEur()} '
                    '− Renten/Kranken ${socialAmount.formatEur()}',
                FgColors.success,
              )
            : (
                '💼',
                '+ ${amount.formatEur()}  Lohn ($jobLevel)',
                FgColors.success,
              ),
      SavingsPlanExecutedEvent(:final amount, :final targetAssetId) => (
          '🔁',
          '+ ${amount.formatEur()} → $targetAssetId  (Sparplan)',
          FgColors.info,
        ),
      DebtInterestEvent(:final amount) => (
          '⚠',
          '− ${amount.formatEur()}  Dispo-Zinsen',
          FgColors.alert,
        ),
      InsuranceFeeEvent(:final amount, :final kind) => (
          '🛡',
          '− ${amount.formatEur()}  $kind',
          FgColors.neutral,
        ),
      LuckyEvent(:final title, :final description, :final amount) => (
          title.substring(0, title.indexOf(' ').clamp(1, title.length)),
          '${amount.cents >= 0 ? '+' : ''}${amount.formatEur()}  '
              '${title.substring(title.indexOf(' ') + 1)} · $description',
          amount.cents >= 0 ? FgColors.success : FgColors.alert,
        ),
      // Sprint B: Markt-Phase-Transitions.
      CrashStartedEvent(:final assetClassId, :final depthPct) => (
          '⚠',
          'Crash gestartet: $assetClassId — Drop bis −${(depthPct * 100).toStringAsFixed(0)}%',
          FgColors.alert,
        ),
      RecoveryCompleteEvent(:final assetClassId) => (
          '✅',
          'Erholung abgeschlossen: $assetClassId',
          FgColors.success,
        ),
      MillionaireReachedEvent(:final ageYears, :final netWorth) => (
          '🏆',
          '💰 GLÜCKWUNSCH! Du bist Millionär! Mit $ageYears Jahren — '
              'Netto-Vermögen ${netWorth.formatEur()}. Eintrag im Highscore.',
          FgColors.primary,
        ),
      LevelUpEvent(:final newLevel, :final title, :final titleChanged) => (
          '⭐',
          titleChanged
              ? 'Level $newLevel — neuer Titel: $title!'
              : 'Level $newLevel erreicht!',
          FgColors.primary,
        ),
      BankruptcyEvent(:final netWorth) => (
          '💀',
          'PLEITE! Vermögen ${netWorth.formatEur()}. '
              'Spiel neu starten (Settings → Reset).',
          FgColors.alert,
        ),
      // Sprint C4: Panic-Sell realisiert (Markt zurück über
      // Verkaufs-Niveau).
      PanicSellRealizedEvent(
        :final assetClassId,
        :final lossCents,
        :final soldAtPct,
        :final daysSinceSell,
      ) =>
        (
          '😬',
          'Panic-Sell $assetClassId: vor $daysSinceSell Tagen bei '
              '−${(soldAtPct * 100).toStringAsFixed(0)} % verkauft — '
              'wäre heute +${Money.cents(lossCents).formatEur()} mehr wert',
          FgColors.alert,
        ),
      // Sprint C4: durch den Crash gehalten — Lob.
      HeldThroughCrashEvent(:final assetClassId) => (
          '💪',
          'Durchgehalten ($assetClassId) — das machen die wenigsten',
          FgColors.success,
        ),
      // Spec-44 A.1: Einzelaktie pleite — dauerhafter Totalverlust.
      StockBankruptEvent(:final name) => (
          '💀',
          '$name ist pleite — Aktien wertlos',
          FgColors.alert,
        ),
      // Round 28: Saisonale Lehr-Karte (Black Friday, Weihnachtsgeld).
      SeasonalEvent(:final title, :final message) => (
          title.substring(0, title.indexOf(' ').clamp(1, title.length)),
          '${title.substring(title.indexOf(' ') + 1)} — $message',
          FgColors.info,
        ),
    };
  }

}

/// Sprint C1: neutraler Breakdown — Beitrag pro Asset-Klasse heute
/// (aus Preis-Updates × Holdings) + Hinweis auf Buchverlust gegenüber
/// dem letzten Hochstand (aus [PeakTracker]).
///
/// Bewusst ohne Wertung ("Gold hat dich gerettet" → nein). Zeilen
/// werden nur angezeigt, wenn entweder Holdings da sind oder ein
/// Buchverlust > 0 € existiert.
class _AssetClassBreakdown extends ConsumerWidget {
  const _AssetClassBreakdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary =
        context.findAncestorStateOfType<_DaySummaryScreenState>()?.widget.summary;
    if (summary == null) return const SizedBox.shrink();

    final etf = ref.watch(etfRepositoryProvider);
    final stock = ref.watch(stockRepositoryProvider);
    final crypto = ref.watch(cryptoRepositoryProvider);
    final metal = ref.watch(metalRepositoryProvider);

    // Beitrag heute pro Klasse: Σ shares × Δ price aus Preis-Events.
    var etfContrib = 0;
    var stockContrib = 0;
    var cryptoContrib = 0;
    var metalContrib = 0;
    for (final e in summary.events) {
      switch (e) {
        case EtfPriceUpdateEvent(:final etfId, :final newPrice, :final deltaPct):
          final shares = etf.holdings
              .firstWhereOrNullById((h) => h.etfId == etfId)
              ?.shares;
          if (shares == null || shares == 0) break;
          if (deltaPct == 0) break;
          final prev = newPrice.cents / (1 + deltaPct);
          etfContrib += ((newPrice.cents - prev) * shares).round();
        case StockPriceUpdateEvent(
            :final stockId,
            :final newPrice,
            :final deltaPct,
          ):
          final shares = stock.holdings
              .firstWhereOrNullById((h) => h.stockId == stockId)
              ?.shares;
          if (shares == null || shares == 0) break;
          if (deltaPct == 0) break;
          final prev = newPrice.cents / (1 + deltaPct);
          stockContrib += ((newPrice.cents - prev) * shares).round();
        case CryptoPriceUpdateEvent(
            :final assetId,
            :final newPrice,
            :final deltaPct,
          ):
          final shares = crypto.holdings
              .firstWhereOrNullById((h) => h.assetId == assetId)
              ?.shares;
          if (shares == null || shares == 0) break;
          if (deltaPct == 0) break;
          final prev = newPrice.cents / (1 + deltaPct);
          cryptoContrib += ((newPrice.cents - prev) * shares).round();
        case MetalPriceUpdateEvent(
            :final assetId,
            :final newPrice,
            :final deltaPct,
          ):
          final shares = metal.holdings
              .firstWhereOrNullById((h) => h.assetId == assetId)
              ?.shares;
          if (shares == null || shares == 0) break;
          if (deltaPct == 0) break;
          final prev = newPrice.cents / (1 + deltaPct);
          metalContrib += ((newPrice.cents - prev) * shares).round();
        default:
          break;
      }
    }

    // PeakTracker: vs. Höchststand (nur ETF + Stock werden getrackt).
    final tracker = ref.watch(peakTrackerProvider);
    int drawdownLossCents(String classId, int currentValue) {
      final peak = tracker[classId];
      if (peak == null) return 0;
      if (currentValue >= peak.peakValueCents) return 0;
      return peak.peakValueCents - currentValue;
    }

    var etfValue = 0;
    for (final h in etf.holdings) {
      final q = etf.quotes[h.etfId];
      if (q != null) etfValue += q.pricePerShare.cents * h.shares;
    }
    var stockValue = 0;
    for (final h in stock.holdings) {
      final q = stock.quotes[h.stockId];
      if (q != null) stockValue += q.pricePerShare.cents * h.shares;
    }
    final etfLoss = drawdownLossCents('etf', etfValue);
    final stockLoss = drawdownLossCents('stock', stockValue);

    final rows = <Widget>[];
    void addLine(String label, int cents) {
      if (cents == 0) return;
      final sign = cents > 0 ? '+' : '−';
      final color = cents > 0 ? FgChart.up : FgChart.down;
      rows.add(Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          children: [
            Expanded(child: Text(label, style: FgTypography.bodyS)),
            Text(
              '$sign ${Money.cents(cents.abs()).formatEur()}',
              style: FgTypography.bodyS.copyWith(color: color),
            ),
          ],
        ),
      ));
    }

    addLine('ETF', etfContrib);
    addLine('Aktien', stockContrib);
    addLine('Krypto', cryptoContrib);
    addLine('Edelmetalle', metalContrib);

    if (rows.isEmpty && etfLoss == 0 && stockLoss == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(FgSpacing.s),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Beitrag heute', style: FgTypography.bodyM),
          ...rows,
          if (etfLoss > 0 || stockLoss > 0) ...[
            const SizedBox(height: FgSpacing.xs),
            Text(
              'vs. letztem Höchststand: −${Money.cents(etfLoss + stockLoss).formatEur()}',
              style: FgTypography.bodyS.copyWith(color: FgChart.down),
            ),
            Text(
              'noch nicht real — erst beim Verkaufen',
              style: FgTypography.bodyS.copyWith(color: FgColors.neutral),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tiny helper for `firstWhereOrNull`-like lookup without dragging in
/// `collection`. Local extension keeps the breakdown widget self-contained.
extension _ListFirstOrNull<T> on List<T> {
  T? firstWhereOrNullById(bool Function(T) test) {
    for (final t in this) {
      if (test(t)) return t;
    }
    return null;
  }
}

/// Shown when the day had no events.
class _EmptyEventsPlaceholder extends StatelessWidget {
  const _EmptyEventsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Heute ist nichts passiert.',
        style: FgTypography.bodyM,
      ),
    );
  }
}

/// Footer "Weiter →" button.
class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onContinue,
        style: TextButton.styleFrom(
          foregroundColor: FgColors.primary,
          textStyle: FgTypography.bodyL,
        ),
        child: const Text('Weiter →'),
      ),
    );
  }
}

/// Welle-8 Round 25 (#6): Münz-Tropf für Zins-Zeilen in der Day-Summary.
/// 🏦 steht fest, 🪙 fällt von oben rein + faded — wiederholt sanft.
/// Eigener AnimationController (self-contained), damit es die staggered
/// `.animate()`-Kette der Event-Rows nicht stört. Feste 20×24-Box →
/// Layout stabil, Zeile immer sichtbar.
class _CoinDropIcon extends StatefulWidget {
  const _CoinDropIcon();

  @override
  State<_CoinDropIcon> createState() => _CoinDropIconState();
}

class _CoinDropIconState extends State<_CoinDropIcon>
    with SingleTickerProviderStateMixin {
  // One-shot statt repeat(): spielt einmal beim Erscheinen ab. Infinite
  // repeat() würde pumpAndSettle (Golden-Tests) ins Timeout laufen lassen
  // und Golden-Pixel nicht-deterministisch machen. Endzustand = nur 🏦.
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 24,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          // t: 0..1. Münze fällt von y=-8 auf y=+4 und faded am Ende aus.
          final t = _ctrl.value;
          final dy = -8.0 + t * 12.0;
          final coinOpacity = t < 0.8 ? 1.0 : (1.0 - (t - 0.8) / 0.2);
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Align(
                alignment: Alignment.bottomCenter,
                child: Text('🏦', style: TextStyle(fontSize: 16)),
              ),
              Positioned(
                top: 0,
                child: Transform.translate(
                  offset: Offset(0, dy),
                  child: Opacity(
                    opacity: coinOpacity.clamp(0.0, 1.0),
                    child: const Text('🪙', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
