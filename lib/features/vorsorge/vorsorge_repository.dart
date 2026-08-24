import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/listeners/vorsorge_listener.dart';
import '../../domain/vorsorge/vorsorge.dart';
import '../daily_quiz/daily_quiz_state.dart';
import '../economy/cash_state.dart';
import '../settings/settings_repository.dart';
import '../xp/xp_repository.dart';

part 'vorsorge_repository.g.dart';

class VorsorgeError implements Exception {
  const VorsorgeError(this.message);
  final String message;
}

VorsorgeType? _typeFromName(String name) {
  for (final t in VorsorgeType.values) {
    if (t.name == name) return t;
  }
  return null;
}

@Riverpod(keepAlive: true)
class VorsorgeRepository extends _$VorsorgeRepository
    implements VorsorgeSource {
  @override
  List<VorsorgeContract> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return [
      for (final r in snap.vorsorgeContracts)
        if (_typeFromName(r.type) != null)
          VorsorgeContract(
            type: _typeFromName(r.type)!,
            startedOnDayIndex: r.startedOnDayIndex,
            totalContributed: Money.cents(r.totalContributedCents),
            totalSubsidy: Money.cents(r.totalSubsidyCents),
          ),
    ];
  }

  @override
  List<VorsorgeContract> currentContracts() => state;

  bool has(VorsorgeType t) => state.any((c) => c.type == t);

  VorsorgeContract? contractFor(VorsorgeType t) {
    for (final c in state) {
      if (c.type == t) return c;
    }
    return null;
  }

  void sign(VorsorgeType t, int dayIndex) {
    if (has(t)) throw const VorsorgeError('schon abgeschlossen');
    final spec = VorsorgeCatalog.byType(t);
    final startAge = ref.read(settingsRepositoryProvider).startAgeYears;
    final ageYears = startAge + dayIndex ~/ 365;
    if (ageYears < spec.minAgeYears) {
      throw const VorsorgeError('zu jung für diesen Vertrag');
    }
    // Welle-8: zusätzlich XP-Schwelle + Quest/Quiz-Topic nötig, damit
    // Verträge nicht sofort zu Spielbeginn verfügbar sind.
    if (spec.requiredXp > 0 && ref.read(xpRepositoryProvider) < spec.requiredXp) {
      throw const VorsorgeError('noch nicht genug XP — spiel weiter');
    }
    final topic = spec.requiredTopic;
    if (topic != null && !ref.read(learnedTopicsProvider).contains(topic)) {
      throw const VorsorgeError('erst passende Quest/Quiz abschließen');
    }
    final contract = VorsorgeContract(
      type: t,
      startedOnDayIndex: dayIndex,
      totalContributed: Money.zero,
      totalSubsidy: Money.zero,
    );
    state = [...state, contract];
    _persist(contract);
  }

  void cancel(VorsorgeType t) {
    state = state.where((c) => c.type != t).toList();
    final db = ref.read(appDatabaseProvider);
    unawaited(
        db.vorsorgeDao.deleteContract(t.name).catchError((Object _) {}));
  }

  /// Adds [premium] to the contract's total-contributed counter.
  /// Used by the VorsorgeListener after debiting cash.
  @override
  void recordPremium(VorsorgeType t, Money premium) {
    final c = contractFor(t);
    if (c == null) return;
    final updated = c.copyWith(
      totalContributed: c.totalContributed + premium,
    );
    state = [
      for (final x in state) x.type == t ? updated : x,
    ];
    _persist(updated);
  }

  @override
  void recordSubsidy(VorsorgeType t, Money subsidy) {
    final c = contractFor(t);
    if (c == null) return;
    final updated = c.copyWith(
      totalSubsidy: c.totalSubsidy + subsidy,
    );
    state = [
      for (final x in state) x.type == t ? updated : x,
    ];
    _persist(updated);
  }

  /// Settles the contract: cash gets all paid-in + bonus + subsidy.
  /// Only allowed once lockDays elapsed since [startedOnDayIndex].
  void settle(VorsorgeType t, int dayIndex) {
    final c = contractFor(t);
    if (c == null) throw const VorsorgeError('kein Vertrag');
    final spec = VorsorgeCatalog.byType(t);
    final age = dayIndex - c.startedOnDayIndex;
    if (age < spec.lockDays) {
      throw const VorsorgeError('noch in Lock-Periode');
    }
    final bonus = Money.cents(
      (c.totalContributed.cents * spec.bonusOnMaturityPct).round(),
    );
    final payout = c.totalContributed + c.totalSubsidy + bonus;
    ref.read(cashStateProvider.notifier).earn(payout);
    cancel(t);
  }

  void _persist(VorsorgeContract c) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.vorsorgeDao
          .upsert(VorsorgeContractRow(
            type: c.type.name,
            startedOnDayIndex: c.startedOnDayIndex,
            totalContributedCents: c.totalContributed.cents,
            totalSubsidyCents: c.totalSubsidy.cents,
          ))
          .catchError((Object _) {}),
    );
  }
}
