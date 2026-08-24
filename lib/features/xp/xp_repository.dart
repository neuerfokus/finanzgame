import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../data/quest/quest_asset_repository.dart';
import '../../domain/economy/money.dart';
import '../economy/cash_state.dart';
import '../quest_runner/quest_availability.dart';
import '../quest_runner/quest_progress_repository.dart';
import 'level_titles.dart';

part 'xp_repository.g.dart';

/// Lifetime XP total (spec-21).
///
/// State = total earned XP. Mutator [add] bumps the counter synchronously
/// and persists fire-and-forget so callers (listeners, controllers, repos)
/// stay sync.
///
/// XP sources (each adds via [add]):
/// - quest complete: +10
/// - daily quiz correct: +5 (hook reserved for spec-17)
/// - plant harvest: +2
/// - ETF buy: +3, ETF sell: +1
/// - stock buy: +5
/// - sleep (per advanceDay): +1
@Riverpod(keepAlive: true)
class XpRepository extends _$XpRepository {
  @override
  int build() {
    final snap = ref.watch(dbSnapshotProvider);
    return snap.xpTotal ?? 0;
  }

  /// Round 27 v7: „Meister-Bonus" — wenn (fast) alle Quests durch sind,
  /// gibt es ×2 XP auf ALLE weiteren Quellen (Quiz, Schlafen, Ernten,
  /// Trades, Echte Erfolge). Der einmalige Quest-XP-Strom versiegt sonst
  /// und das Endgame fühlt sich karg an. Schwelle 90 % statt 100 %, weil
  /// einige Quests event-gated sind und „alle 100 %" evtl. nie erreichbar.
  static const double _masterBonusThreshold = 0.9;
  static const int masterBonusFactor = 2;

  /// True wenn der Meister-Bonus aktiv ist (≥ 90 % der Quests gelöst).
  bool get masterBonusActive {
    final progress = ref.read(questProgressRepositoryProvider);
    final completed = progress.values
        .where((p) => p.status == questStatusCompleted)
        .length;
    final total = kQuestAssetPaths.length;
    if (total == 0) return false;
    return completed >= (total * _masterBonusThreshold).floor();
  }

  /// Cash-Belohnung pro erreichtem Level: Level × 5 € (= Level × 500 ¢).
  /// Gibt dem Leveln einen spürbaren, sofortigen Anreiz ohne den Markt zu
  /// verfälschen (reiner Bonus-Cash, kein Rendite-Multiplikator).
  static const int levelUpRewardCentsPerLevel = 500;

  void add(int delta) {
    if (delta <= 0) return;
    final factor = masterBonusActive ? masterBonusFactor : 1;
    final before = state;
    state = state + delta * factor;
    _persist();
    _grantLevelUpRewards(before, state);
  }

  /// Round 28: Bei jedem überschrittenen Level Cash gutschreiben.
  /// Mehrere Level in einem [add] (z.B. großer Quest-Batch) zahlen pro
  /// Stufe — Σ Level × 5 €.
  void _grantLevelUpRewards(int before, int after) {
    final oldLevel = LevelSystem.levelFor(before);
    final newLevel = LevelSystem.levelFor(after);
    if (newLevel <= oldLevel) return;
    var rewardCents = 0;
    for (var l = oldLevel + 1; l <= newLevel; l++) {
      rewardCents += l * levelUpRewardCentsPerLevel;
    }
    if (rewardCents > 0) {
      ref.read(cashStateProvider.notifier).earn(Money.cents(rewardCents));
    }
    ref.read(lastLevelUpProvider.notifier).fire(newLevel, rewardCents);
  }

  void _persist() {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.xpDao.setTotal(state).catchError((Object _) {}));
  }
}

/// Round 28: meldet UI-Listener wenn ein neues Level erreicht wurde.
/// Analog zu [LastAchievementUnlock] — `tick` zählt hoch damit
/// `ref.listen` auch bei mehreren Level-Ups hintereinander feuert.
@Riverpod(keepAlive: true)
class LastLevelUp extends _$LastLevelUp {
  @override
  ({int? level, int rewardCents, int tick}) build() =>
      (level: null, rewardCents: 0, tick: 0);

  void fire(int level, int rewardCents) {
    state = (level: level, rewardCents: rewardCents, tick: state.tick + 1);
  }
}

/// Canonical XP amounts per source — referenced from feature hooks so the
/// numbers stay in one place (spec-21).
abstract final class XpRewards {
  // Round 27 v6: Rewards modest hoch fürs Long-Game (Level 60 erreichbar).
  static const int questCompleted = 15; // war 10
  static const int dailyQuizCorrect = 8; // war 5
  static const int plantHarvested = 2;
  static const int etfBought = 3;
  static const int etfSold = 1;
  static const int stockBought = 5;
  static const int sleep = 2; // war 1
  // Spec-22: crypto + metal trades use the same tier as stocks.
  // Round 27 v7: jede frisch freigeschaltete Trophäe gibt XP — belohnt
  // Portfolio-Stufen + Sammeln, hält XP-Fluss auch nach allen Quests.
  static const int achievementUnlocked = 50;
  static const int cryptoBought = 5;
  static const int cryptoSold = 1;
  static const int metalBought = 5;
  static const int metalSold = 1;
}
