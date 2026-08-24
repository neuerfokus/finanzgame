import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/economy/money.dart';
import '../../game/monetaria/state/monetaria_state.dart';
import '../bank/savings_repository.dart';
import '../crypto/crypto_repository.dart';
import '../economy/cash_state.dart';
import '../etf/etf_repository.dart';
import '../forest/tree_repository.dart';
import '../highscore/net_worth.dart';
import '../metal/metal_repository.dart';
import '../plant/harvest_counter.dart';
import '../realestate/real_estate_repository.dart';
import '../settings/settings_repository.dart';
import '../stock/stock_repository.dart';
import '../wishlist/wishlist_repository.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import '../../core/game_clock.dart';

part 'daily_goal.g.dart';

/// Spec-41 follow-up: tägliches Mini-Ziel, rotiert per dayIndex.
class DailyGoal {
  const DailyGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardCents,
    required this.rewardXp,
    this.requiredIsland,
  });

  final String id;
  final String title;
  final String description;
  final int rewardCents;
  final int rewardXp;
  /// Wenn gesetzt, nur sichtbar wenn diese Insel freigeschaltet ist.
  final String? requiredIsland;
}

// Welle-8 Round 17: 5 → 17 Goals. Variation für jeden Spielstand +
// jede freigeschaltete Insel. Reward-Cents = Basis vor Level-Multiplikator
// (rewardFor in Notifier — siehe unten).
const _goals = <DailyGoal>[
  DailyGoal(
    id: 'save_5',
    title: '💰 5 € sparen',
    description: 'Hab heute mindestens 5 € auf dem Sparkonto.',
    rewardCents: 300,
    rewardXp: 30,
  ),
  DailyGoal(
    id: 'harvest_3',
    title: '🌾 3× ernten',
    description: 'Ernte insgesamt 3 reife Pflanzen.',
    rewardCents: 500,
    rewardXp: 50,
    requiredIsland: IslandId.sparInsel,
  ),
  DailyGoal(
    id: 'buy_etf',
    title: '📈 1 ETF kaufen',
    description: 'Kauf mindestens 1 ETF-Anteil.',
    rewardCents: 400,
    rewardXp: 40,
    requiredIsland: IslandId.etfInsel,
  ),
  DailyGoal(
    id: 'cash_10',
    title: '💸 10 € haben',
    description: 'Hab 10 € auf dem Giro-Konto.',
    rewardCents: 300,
    rewardXp: 30,
  ),
  DailyGoal(
    id: 'level_up',
    title: '⭐ 100 XP sammeln',
    description: 'Bekomm 100 XP über Quiz + Quests.',
    rewardCents: 200,
    rewardXp: 100,
  ),
  // Welle-8 Round 17 — neue Goals:
  DailyGoal(
    id: 'save_50',
    title: '💎 50 € auf Spar',
    description: 'Hab 50 € auf dem Sparkonto — solider Notgroschen-Start.',
    rewardCents: 600,
    rewardXp: 50,
  ),
  DailyGoal(
    id: 'buy_stock',
    title: '🏛 1 Aktie kaufen',
    description: 'Kauf mindestens eine Einzelaktie.',
    rewardCents: 500,
    rewardXp: 50,
    requiredIsland: IslandId.aktienArchipel,
  ),
  DailyGoal(
    id: 'buy_crypto',
    title: '🚀 Bitcoin angefasst',
    description: 'Halte Bitcoin oder Krypto-Coin (egal welcher Wert).',
    rewardCents: 500,
    rewardXp: 50,
    requiredIsland: IslandId.vulkan,
  ),
  DailyGoal(
    id: 'buy_gold',
    title: '🪙 1 g Gold',
    description: 'Halte mindestens 1 Gramm Gold oder Silber.',
    rewardCents: 500,
    rewardXp: 50,
    requiredIsland: IslandId.goldmine,
  ),
  DailyGoal(
    id: 'buy_tree',
    title: '🌳 Baum pflanzen',
    description: 'Pflanze mindestens einen Baum im Mischwald.',
    rewardCents: 400,
    rewardXp: 40,
    requiredIsland: IslandId.mischwald,
  ),
  DailyGoal(
    id: 'buy_realestate',
    title: '🏠 Erste Immobilie',
    description: 'Kauf dir eine Wohnung oder ein Haus.',
    rewardCents: 1000,
    rewardXp: 80,
    requiredIsland: IslandId.wohnviertel,
  ),
  DailyGoal(
    id: 'net_worth_100',
    title: '💼 100 € Vermögen',
    description: 'Dein Gesamt-Vermögen liegt bei 100 € oder mehr.',
    rewardCents: 400,
    rewardXp: 40,
  ),
  DailyGoal(
    id: 'net_worth_1000',
    title: '🏆 1000 € Vermögen',
    description: 'Erreiche 1000 € Gesamt-Vermögen.',
    rewardCents: 800,
    rewardXp: 60,
  ),
  DailyGoal(
    id: 'wish_buy',
    title: '🎁 Wunsch erfüllt',
    description: 'Kauf dir einen Wunsch von deiner Wunschliste.',
    rewardCents: 300,
    rewardXp: 40,
  ),
  DailyGoal(
    id: 'savings_rate',
    title: '🎯 Pay-yourself-first',
    description:
        'Stell die automatische Spar-Rate auf 10 % oder mehr (Bank-App).',
    rewardCents: 400,
    rewardXp: 50,
  ),
  DailyGoal(
    id: 'streak_3',
    title: '🔥 3-Tage-Streak',
    description: '3 Real-Tage in Folge "Schlafen" gedrückt.',
    rewardCents: 500,
    rewardXp: 50,
  ),
  DailyGoal(
    id: 'plot_5',
    title: '🌱 5 Felder',
    description: 'Hab 5 Pflanz-Felder freigeschaltet.',
    rewardCents: 400,
    rewardXp: 40,
    requiredIsland: IslandId.sparInsel,
  ),
];

/// Tagesziel = dayIndex % verfügbare-goals.length. Deterministisch.
/// Filtert Ziele die eine nicht-freigeschaltete Insel voraussetzen.
/// [currentAgeYears] filtert zusätzlich Ziele die laut Spec-45 age-gated
/// sind (Immobilien + Krypto erst ab 18) — sonst wäre das Ziel
/// unerreichbar (Sohn-Bug "Tagesziel erste Immobilie" mit 13).
DailyGoal dailyGoalFor(
  int dayIndex,
  Set<String> unlockedIslands, {
  int currentAgeYears = 99,
}) {
  bool ageOk(String id) {
    if (currentAgeYears >= 18) return true;
    return id != 'buy_realestate' && id != 'buy_crypto';
  }

  final available = _goals
      .where((g) =>
          (g.requiredIsland == null ||
              unlockedIslands.contains(g.requiredIsland)) &&
          ageOk(g.id))
      .toList();
  return available[dayIndex % available.length];
}

/// Spec-41 + B7: claimed-state pro dayIndex. B7: jetzt persistent via
/// SettingsRepository.lastClaimedGoalDay — Banner kommt nach App-
/// Restart nicht wieder. Nur der zuletzt geclaimte Tag wird gehalten
/// (alte Tage interessieren nicht, Banner zeigt nur aktuelles dayIndex).
@Riverpod(keepAlive: true)
class DailyGoalClaimed extends _$DailyGoalClaimed {
  @override
  Set<int> build() {
    final last = ref.watch(settingsRepositoryProvider).lastClaimedGoalDay;
    return last >= 0 ? {last} : <int>{};
  }

  bool isClaimed(int dayIndex) => state.contains(dayIndex);

  /// True wenn das Ziel für [dayIndex] aktuell erfüllt ist (Predicate).
  bool isEligible(int dayIndex) {
    final settings = ref.read(settingsRepositoryProvider);
    final age = settings.startAgeYears + (dayIndex ~/ 365);
    final goal = dailyGoalFor(
      dayIndex,
      ref.read(monetariaStateProvider),
      currentAgeYears: age,
    );
    switch (goal.id) {
      case 'save_5':
        return ref.read(savingsRepositoryProvider).cents >= 500;
      case 'harvest_3':
        // Analyse-Runde 2026-08: prüfte vorher `lifetimeHarvestState >= 100`
        // (= „jemals ≥ 1 € geerntet") — nach der ersten Ernte war das Ziel an
        // JEDEM weiteren Tag automatisch erfüllt. Jetzt echte 3 Ernten heute.
        return ref.read(harvestCounterProvider.notifier).countFor(dayIndex) >=
            3;
      case 'buy_etf':
        return ref.read(etfRepositoryProvider).holdings.isNotEmpty;
      case 'cash_10':
        return ref.read(cashStateProvider).cents >= 1000;
      case 'level_up':
        return ref.read(xpRepositoryProvider) >= 100;
      case 'save_50':
        return ref.read(savingsRepositoryProvider).cents >= 5000;
      case 'buy_stock':
        return ref.read(stockRepositoryProvider).holdings.isNotEmpty;
      case 'buy_crypto':
        return ref.read(cryptoRepositoryProvider).holdings.isNotEmpty;
      case 'buy_gold':
        return ref.read(metalRepositoryProvider).holdings.isNotEmpty;
      case 'buy_tree':
        return ref.read(treeRepositoryProvider).isNotEmpty;
      case 'buy_realestate':
        return ref.read(realEstateRepositoryProvider).isNotEmpty;
      case 'net_worth_100':
        final dayIdx = ref.read(gameClockProvider).dayIndex;
        return ref.read(netWorthProvider(dayIdx)) >= 10000;
      case 'net_worth_1000':
        final dayIdx = ref.read(gameClockProvider).dayIndex;
        return ref.read(netWorthProvider(dayIdx)) >= 100000;
      case 'wish_buy':
        return ref
            .read(wishlistRepositoryProvider)
            .any((w) => w.ownedOnDayIndex != null);
      case 'savings_rate':
        return ref.read(settingsRepositoryProvider).savingsRatePct >= 10;
      case 'streak_3':
        return ref.read(settingsRepositoryProvider).streakCount >= 3;
      case 'plot_5':
        return ref.read(settingsRepositoryProvider).sparPlotCount >= 5;
    }
    return false;
  }

  /// Welle-8 Round 17: Reward skaliert mit Level — Multiplikator
  /// (1 + level / 5), gedeckelt bei 5×. Level 5 = 2×, Level 20 = 5×.
  /// Damit passt sich der Cash-Reward dem Spielstand an.
  Money rewardFor(DailyGoal goal) {
    final level = LevelSystem.levelFor(ref.read(xpRepositoryProvider));
    final mult = (1.0 + level / 5.0).clamp(1.0, 5.0);
    return Money.cents((goal.rewardCents * mult).round());
  }

  /// Versucht das Ziel zu claimen. False wenn nicht erfüllt oder schon
  /// abgeholt. Bei Erfolg: Cash + XP gutschreiben.
  bool claim(int dayIndex) {
    if (state.contains(dayIndex)) return false;
    if (!isEligible(dayIndex)) return false;
    final settings = ref.read(settingsRepositoryProvider);
    final age = settings.startAgeYears + (dayIndex ~/ 365);
    final goal = dailyGoalFor(
      dayIndex,
      ref.read(monetariaStateProvider),
      currentAgeYears: age,
    );
    ref.read(cashStateProvider.notifier).earn(rewardFor(goal));
    ref.read(xpRepositoryProvider.notifier).add(goal.rewardXp);
    ref
        .read(settingsRepositoryProvider.notifier)
        .setLastClaimedGoalDay(dayIndex);
    state = {...state, dayIndex};
    return true;
  }
}
