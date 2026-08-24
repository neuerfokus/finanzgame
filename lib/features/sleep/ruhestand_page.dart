import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_balance.dart';
import '../../domain/economy/money.dart';
import '../../domain/forest/tree.dart';
import '../../domain/highscore/highscore_entry.dart';
import '../../ui/widgets/confetti.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../bank/savings_repository.dart';
import '../collectibles/collectible_repository.dart';
import '../crypto/crypto_repository.dart';
import '../economy/cash_state.dart';
import '../etf/etf_repository.dart';
import '../forest/tree_repository.dart';
import '../../data/db/app_database_provider.dart';
import '../highscore/highscore_repository.dart';
import '../highscore/net_worth.dart';
import '../highscore/realworld_benchmark.dart';
import '../lucky_events/lucky_event_history_repository.dart';
import '../newgame/legacy.dart';
import '../newgame/new_game_state.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../settings/settings_repository.dart';
import '../stock/stock_repository.dart';
import '../vorsorge/vorsorge_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';

/// Spec-38 P3-1: Lebens-Resümee bei Alter 80.
///
/// Polished Endbildschirm: zeigt Netto-Vermögen, Asset-Verteilung, Level/Titel
/// und einen reflektierenden Schlussspruch. Kein Game-Over — Spieler kann den
/// Bildschirm beliebig oft erneut öffnen, der Spielstand bleibt erhalten.
class RuhestandPage extends ConsumerStatefulWidget {
  const RuhestandPage({super.key});

  @override
  ConsumerState<RuhestandPage> createState() => _RuhestandPageState();
}

class _RuhestandPageState extends ConsumerState<RuhestandPage> {
  bool _recordedEntry = false;

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final cash = ref.watch(cashStateProvider);
    final savings = ref.watch(savingsRepositoryProvider);
    final etf = ref.watch(etfRepositoryProvider);
    final stock = ref.watch(stockRepositoryProvider);
    final crypto = ref.watch(cryptoRepositoryProvider);
    final metal = ref.watch(metalRepositoryProvider);
    final realestate = ref.watch(realEstateRepositoryProvider);
    final vorsorge = ref.watch(vorsorgeRepositoryProvider);
    final xp = ref.watch(xpRepositoryProvider);
    final level = LevelSystem.levelFor(xp);
    final title = LevelSystem.titleFor(level);

    final etfValue = etf.holdings.fold<int>(
      0,
      (s, h) =>
          s + (etf.quotes[h.etfId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    final stockValue = stock.holdings.fold<int>(
      0,
      (s, h) =>
          s + (stock.quotes[h.stockId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    final cryptoValue = crypto.holdings.fold<int>(
      0,
      (s, h) =>
          s + (crypto.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    final metalValue = metal.holdings.fold<int>(
      0,
      (s, h) =>
          s + (metal.quotes[h.assetId]?.pricePerShare.cents ?? 0) * h.shares,
    );
    final reRepo = ref.read(realEstateRepositoryProvider.notifier);
    // Netto: Marktwert minus Restschuld (siehe NetWorth.compute).
    final reValue = realestate.fold<int>(
      0,
      (s, h) =>
          s +
          reRepo.currentValueOf(h, GameBalance.maxDayIndex).cents -
          reRepo.mortgageRemaining(h, GameBalance.maxDayIndex).cents,
    );
    final vorsorgeValue = vorsorge.fold<int>(
      0,
      (s, c) => s + c.totalContributed.cents + c.totalSubsidy.cents,
    );

    // Sammlerobjekte + Bäume für die Aufschlüsselung unten. Die SUMME kommt
    // bewusst aus [NetWorth.compute] — diese Seite speist Highscore, 1-%-Erbe
    // und die Reflexions-Schwellen und hatte vorher eine eigene Summe OHNE
    // Sammlerobjekte (Stats zählte sie), was zu zwei verschiedenen
    // „Vermögen"-Zahlen im selben Spielstand führte.
    final collectibleRepo = ref.read(collectibleRepositoryProvider.notifier);
    final collectibleValue =
        ref.watch(collectibleRepositoryProvider).fold<int>(
              0,
              (s, h) => s +
                  collectibleRepo
                      .currentValueOf(h, GameBalance.maxDayIndex)
                      .cents,
            );
    final treeValue = ref.watch(treeRepositoryProvider).fold<int>(
          0,
          (s, t) => s + TreeCatalog.spec(t.kind).cost.cents,
        );
    final netWorth = ref.watch(netWorthProvider(GameBalance.maxDayIndex));

    final reflection = _reflectionFor(netWorth, level);

    // Highscore-Eintrag bei erstem Aufruf (idempotent durch _recordedEntry).
    if (!_recordedEntry) {
      _recordedEntry = true;
      final settings = ref.read(settingsRepositoryProvider);
      final highscoreRepo = ref.read(highscoreRepositoryProvider.notifier);
      final highscoreAsync = ref.read(highscoreRepositoryProvider);
      final HighscoreData? highscoreData = highscoreAsync.maybeWhen(
        data: (d) => d,
        orElse: () => null,
      );
      final firstMillDay = highscoreData?.firstMillionaireDayIndex;
      // ageYears = startAge + dayIndex/365. Da Spieler hier am maxDay
      // ist, fix = maxAgeYears.
      const finalAge = GameBalance.maxAgeYears;
      final startAge = settings.startAgeYears;
      final int? millAgeYears = firstMillDay == null
          ? null
          : startAge + (firstMillDay ~/ 365);
      final entry = HighscoreEntry(
        playerName: settings.playerName,
        // Start-/End-Datum sind nur Anzeige-Metadaten; ohne echtes Run-
        // Start-Datum nehmen wir "jetzt" für endedAt und schätzen den
        // Anfang über maxDayIndex Tage zurück. Wer im Echtleben drei
        // Wochen für 80 Lebensjahre braucht, sieht damit was Sinnvolles.
        startedAt: DateTime.now().subtract(
          Duration(days: GameBalance.maxAgeYears - startAge),
        ),
        endedAt: DateTime.now(),
        finalNetWorthCents: netWorth,
        finalAgeYears: finalAge,
        firstMillionaireAgeYears: millAgeYears,
        firstMillionaireDayIndex: firstMillDay,
      );
      // Fire-and-forget — UI muss nicht warten.
      highscoreRepo.addEntry(entry);
    }

    return PhoneFrame(
      appName: 'Lebensresümee · 80 Jahre',
      onHome: null,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(FgSpacing.l),
            children: [
              PixelPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⌛', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: FgSpacing.s),
                    const Text(
                      'Du hast 80 Jahre gelebt.',
                      style: FgTypography.display,
                    ),
                    const SizedBox(height: FgSpacing.s),
                    Text(reflection, style: FgTypography.bodyM),
                  ],
                ),
              ),
              const SizedBox(height: FgSpacing.m),
              PixelPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Dein Vermögen am Lebensende',
                        style: FgTypography.bodyM),
                    Text(
                      Money.cents(netWorth).formatEur(),
                      style: FgTypography.displayLarge.copyWith(
                        color: netWorth >= 0
                            ? FgColors.success
                            : FgColors.alert,
                      ),
                    ),
                    const SizedBox(height: FgSpacing.s),
                    Text('Level $level — $title',
                        style: FgTypography.bodyL),
                    Text('XP: $xp', style: FgTypography.bodyS),
                  ],
                ),
              ),
              const SizedBox(height: FgSpacing.m),
              PixelPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Wo dein Geld liegt',
                        style: FgTypography.bodyL),
                    const SizedBox(height: FgSpacing.s),
                    _Row('💰 Cash', cash.cents),
                    _Row('🏦 Spar', savings.cents),
                    _Row('📈 ETF', etfValue),
                    _Row('📊 Aktien', stockValue),
                    _Row('🪙 Krypto', cryptoValue),
                    _Row('🥇 Metall', metalValue),
                    _Row('🏠 Immobilien', reValue),
                    _Row('🛡 Vorsorge', vorsorgeValue),
                    _Row('💎 Sammlerobjekte', collectibleValue),
                    _Row('🌳 Bäume', treeValue),
                  ],
                ),
              ),
              const SizedBox(height: FgSpacing.m),
              _RealworldBenchmarkCard(netWorthCents: netWorth),
              const SizedBox(height: FgSpacing.m),
              const _Top3LuckyRecap(),
              const SizedBox(height: FgSpacing.l),
              PixelButton(
                label: 'Weiter spielen',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: FgSpacing.s),
              // Spec-45 G3: NewGame+ Reset mit Erbschaft.
              PixelButton(
                label: '🔄 Neues Leben mit Erbschaft',
                background: FgColors.secondary,
                foreground: FgColors.onSurface,
                onPressed: () => _startNewGamePlus(context, ref, netWorth, xp),
              ),
            ],
          ),
          const IgnorePointer(child: ConfettiBurst()),
        ],
      ),
    );
  }

  String _reflectionFor(int netWorthCents, int level) {
    if (netWorthCents >= 100000000) {
      return 'Du hast früh investiert, breit gestreut und Disziplin gezeigt. '
          'Ein Lebensvermögen, das mehrere Generationen tragen kann.';
    }
    if (netWorthCents >= 10000000) {
      return 'Solide finanziell aufgestellt. Mit Geduld und ETFs hast du '
          'die Inflation geschlagen.';
    }
    if (netWorthCents >= 1000000) {
      return 'Ordentliches Polster. Hättest noch mehr investieren statt '
          'sparen können — Zinseszins liebt Zeit.';
    }
    if (netWorthCents >= 0) {
      return 'Über Wasser geblieben. Lehre für den nächsten Lauf: früher '
          'anfangen zu investieren.';
    }
    return 'Schuldenfalle. Tipp für den nächsten Lauf: nie auf Pump '
        'konsumieren, Dispo-Zinsen sind brutal.';
  }

  /// Spec-45 G3: NewGame+ — snapshot Boni, wipe DB, App-Restart-Hinweis.
  Future<void> _startNewGamePlus(
    BuildContext context,
    WidgetRef ref,
    int netWorth,
    int xp,
  ) async {
    final ngNotifier = ref.read(newGameStateProvider.notifier);
    final legacy = ref.read(newGameStateProvider);
    final cap = legacyInheritanceCapCents(legacy.legacyUpgrades);
    final inheritance = (netWorth * 0.01).round().clamp(0, cap);
    final bonusXp = (xp * 0.10).round().clamp(0, 500);
    final lpEarned =
        ngNotifier.previewLegacyPoints(netWorthCents: netWorth, finalXp: xp);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('🔄 Neues Leben starten?',
            style: FgTypography.bodyL),
        content: Text(
          'Du startest einen frischen Run.\n\n'
          'Was du behältst:\n'
          '✓ Highscore-Liste + Trophäen\n'
          '✓ Erbschaft: '
          '${(Money.cents(inheritance)).formatEur()} Cash\n'
          '✓ Bonus-XP: $bonusXp (für schnelleres Unlocken)\n'
          '👑 Vermächtnis: +$lpEarned Punkt${lpEarned == 1 ? '' : 'e'} '
          '(für dauerhafte Start-Boni)\n\n'
          'Was verloren geht:\n'
          '✗ Cash, Spar, Investments\n'
          '✗ Pflanzen, Möbel, Wünsche\n'
          '✗ Quest-Fortschritt\n\n'
          'Reset = sofort, kein zurück.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Ja, neues Leben',
                style: FgTypography.bodyM
                    .copyWith(color: FgColors.success)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    // 1) Snapshot fixieren bevor DB gewiped wird.
    ref.read(newGameStateProvider.notifier).recordEndOfRun(
          netWorthCents: netWorth,
          finalXp: xp,
        );
    // 2) DB komplett wipen (Highscore-Lifetime bleibt durch DAO-Logik).
    final db = ref.read(appDatabaseProvider);
    await db.wipeAll();
    if (!context.mounted) return;
    // 3) User-Hinweis: App neu starten damit Onboarding lädt + Erbschaft
    //    in cash_state picks-up.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '✓ Neues Leben vorbereitet. Bitte App neu starten — Erbschaft '
          'wird beim Onboarding aufs Konto gebucht.',
          style: FgTypography.bodyM,
        ),
        duration: Duration(seconds: 10),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.cents);
  final String label;
  final int cents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: FgTypography.bodyM)),
          Text(Money.cents(cents).formatEur(),
              style: FgTypography.bodyM),
        ],
      ),
    );
  }
}

/// Spec-45 G4: Top-3 Lucky-Events (Magnitude) im Ruhestand-Recap.
/// Liest aus [LuckyEventHistoryRepository]. Zeigt nichts wenn leer.
class _Top3LuckyRecap extends ConsumerWidget {
  const _Top3LuckyRecap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top = ref
        .read(luckyEventHistoryRepositoryProvider.notifier)
        .topByMagnitude(3);
    if (top.isEmpty) return const SizedBox.shrink();
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✨ Größte Glücks- und Pech-Momente',
              style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.s),
          for (final e in top)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title, style: FgTypography.bodyM),
                        Text('Tag ${e.dayIndex}',
                            style: FgTypography.bodyS.copyWith(
                              color: FgColors.onSurfaceMuted,
                            )),
                      ],
                    ),
                  ),
                  Text(
                    (e.amountCents >= 0 ? '+' : '') +
                        Money.cents(e.amountCents).formatEur(),
                    style: FgTypography.bodyL.copyWith(
                      color: e.amountCents >= 0
                          ? FgColors.success
                          : FgColors.alert,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Spec-45 G2: zeigt Perzentil + Anker-Vergleichswerte (Median /
/// Top 10 % / Top 1 %) der echten DE-Vermögensverteilung.
class _RealworldBenchmarkCard extends StatelessWidget {
  const _RealworldBenchmarkCard({required this.netWorthCents});

  final int netWorthCents;

  @override
  Widget build(BuildContext context) {
    final p = RealworldBenchmark.percentileFor(netWorthCents);
    final label = RealworldBenchmark.labelFor(netWorthCents);
    final percentText = p >= 999 ? '> 99,9 %' : '≥ $p %';
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🇩🇪 Vergleich mit Deutschland',
              style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.s),
          Text(
            'Du schlägst $percentText der Deutschen im Ruhestand.',
            style: FgTypography.bodyM.copyWith(
              color: p >= 50 ? FgColors.success : FgColors.alert,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(label, style: FgTypography.bodyM),
          const SizedBox(height: FgSpacing.m),
          _BenchmarkRow(
            label: 'Median DE',
            cents: RealworldBenchmark.medianCents,
            youCents: netWorthCents,
          ),
          _BenchmarkRow(
            label: 'Top 10 %',
            cents: RealworldBenchmark.top10Cents,
            youCents: netWorthCents,
          ),
          _BenchmarkRow(
            label: 'Top 1 %',
            cents: RealworldBenchmark.top1Cents,
            youCents: netWorthCents,
          ),
          const SizedBox(height: FgSpacing.xs),
          const Text(
            'Quelle: Bundesbank PHF 2023, DIW SOEP. Werte gerundet.',
            style: FgTypography.bodyS,
          ),
        ],
      ),
    );
  }
}

class _BenchmarkRow extends StatelessWidget {
  const _BenchmarkRow({
    required this.label,
    required this.cents,
    required this.youCents,
  });
  final String label;
  final int cents;
  final int youCents;

  @override
  Widget build(BuildContext context) {
    final hit = youCents >= cents;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(hit ? '✅' : '⚪',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(width: FgSpacing.xs),
          Expanded(child: Text(label, style: FgTypography.bodyS)),
          Text(Money.cents(cents).formatEur(),
              style: FgTypography.bodyS.copyWith(
                color: hit ? FgColors.success : FgColors.onSurfaceMuted,
              )),
        ],
      ),
    );
  }
}
