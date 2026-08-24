import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../bank/savings_repository.dart';

part 'quest_passive_income.g.dart';

/// Spec-42 Welle-6: Quest-Belohnung erweitert um monatliche Auszahlung.
/// Nach Quest-Complete bekommt Spieler zusätzlich zur Sofort-Cash 12x
/// `cashReward × 0.10` auf das Sparkonto — alle 30 Spieltage.
class QuestPassivePayment {
  const QuestPassivePayment({
    required this.rowId,
    required this.questId,
    required this.monthsRemaining,
    required this.monthlyCents,
    required this.lastPaidDayIndex,
  });

  /// Drift auto-increment row-id. -1 = pending insert (sollte selten sein).
  final int rowId;
  final String questId;
  final int monthsRemaining;
  final int monthlyCents;
  final int lastPaidDayIndex;

  QuestPassivePayment copyWith({
    int? rowId,
    int? monthsRemaining,
    int? lastPaidDayIndex,
  }) =>
      QuestPassivePayment(
        rowId: rowId ?? this.rowId,
        questId: questId,
        monthsRemaining: monthsRemaining ?? this.monthsRemaining,
        monthlyCents: monthlyCents,
        lastPaidDayIndex: lastPaidDayIndex ?? this.lastPaidDayIndex,
      );
}

/// Persistente Queue aller laufenden Quest-Passiv-Zahlungen via Drift.
@Riverpod(keepAlive: true)
class QuestPassiveIncome extends _$QuestPassiveIncome {
  @override
  List<QuestPassivePayment> build() {
    final snap = ref.watch(dbSnapshotProvider);
    return [
      for (final r in snap.questPassivePayments)
        QuestPassivePayment(
          rowId: r.rowId,
          questId: r.questId,
          monthsRemaining: r.monthsRemaining,
          monthlyCents: r.monthlyCents,
          lastPaidDayIndex: r.lastPaidDayIndex,
        ),
    ];
  }

  /// Registriere eine neue 12-Monats-Zahlung. Persistiert via Drift.
  Future<void> register({
    required String questId,
    required Money cashReward,
    required int currentDayIndex,
  }) async {
    // Spec-44 G: Quest-Belohnungen vorsichtiger dosieren. Quests sollen
    // Startkapital + Wissen sein, nicht Haupt-Income. Monthly-Faktor
    // 20 % → 10 % über 12 Monate (= 1,2× Einmal-Belohnung gesamt, der
    // große Brocken bleibt die Sofort-Cash).
    final monthly = (cashReward.cents * 0.10).round();
    if (monthly <= 0) return;
    final db = ref.read(appDatabaseProvider);
    final rowId = await db.questPassiveDao.insertRow(
      questId: questId,
      monthsRemaining: 12,
      monthlyCents: monthly,
      lastPaidDayIndex: currentDayIndex,
    );
    // Round 28 (Flaky-Fix): Nach dem async-Gap kann der Provider/Container
    // bereits disposed sein (z.B. Test-Teardown oder Quest-Reset während
    // des Finish). Ohne diesen Guard wirft `state =` „Cannot use Ref after
    // it has been disposed" — der order-abhängige Full-Suite-Flake.
    if (!ref.mounted) return;
    state = [
      ...state,
      QuestPassivePayment(
        rowId: rowId,
        questId: questId,
        monthsRemaining: 12,
        monthlyCents: monthly,
        lastPaidDayIndex: currentDayIndex,
      ),
    ];
  }

  /// Pro Tag aufgerufen — dispenst monatlich. Returns Sum der heute
  /// gezahlten Cents.
  int tick(int dayIndex) {
    var paid = 0;
    final next = <QuestPassivePayment>[];
    final db = ref.read(appDatabaseProvider);
    for (final p in state) {
      final delta = dayIndex - p.lastPaidDayIndex;
      if (delta >= 30 && p.monthsRemaining > 0) {
        paid += p.monthlyCents;
        final remaining = p.monthsRemaining - 1;
        if (remaining > 0) {
          next.add(p.copyWith(
            monthsRemaining: remaining,
            lastPaidDayIndex: dayIndex,
          ));
          unawaited(db.questPassiveDao
              .updateRow(
                rowId: p.rowId,
                monthsRemaining: remaining,
                lastPaidDayIndex: dayIndex,
              )
              .catchError((Object _) {}));
        } else {
          unawaited(db.questPassiveDao
              .deleteRow(p.rowId)
              .catchError((Object _) {}));
        }
      } else {
        next.add(p);
      }
    }
    if (paid > 0) {
      ref
          .read(savingsRepositoryProvider.notifier)
          .deposit(Money.cents(paid));
    }
    state = next;
    return paid;
  }
}
