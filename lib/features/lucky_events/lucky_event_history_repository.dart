import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';

part 'lucky_event_history_repository.g.dart';

/// Spec-45 A2 + G4: persistente Lucky-Event-Historie. Wird im
/// GameClock-Listener-Hook befüllt sobald ein [LuckyEvent] in der
/// Pipeline auftaucht. Konsumenten:
/// - Bank-App "Glücks-Events"-Tab
/// - RuhestandPage Top-3-Recap
@Riverpod(keepAlive: true)
class LuckyEventHistoryRepository extends _$LuckyEventHistoryRepository {
  @override
  List<LuckyEventEntry> build() {
    // Initial leerer State — async hydrate startet sofort.
    Future<void>.microtask(_hydrate);
    return const [];
  }

  Future<void> _hydrate() async {
    if (!ref.mounted) return;
    final db = ref.read(appDatabaseProvider);
    final rows = await db.luckyEventHistoryDao.loadAll();
    if (!ref.mounted) return;
    state = List.unmodifiable([
      for (final r in rows)
        LuckyEventEntry(
          dayIndex: r.dayIndex,
          title: r.title,
          description: r.description,
          amountCents: r.amountCents,
          taxDeductedCents: r.taxDeductedCents,
        ),
    ]);
  }

  /// Persistiert Event + updated In-Memory-State (vorne einsortiert,
  /// damit Bank-Tab neueste zuerst zeigt).
  void record({
    required int dayIndex,
    required String title,
    required String description,
    required int amountCents,
    required int taxDeductedCents,
  }) {
    final entry = LuckyEventEntry(
      dayIndex: dayIndex,
      title: title,
      description: description,
      amountCents: amountCents,
      taxDeductedCents: taxDeductedCents,
    );
    state = List.unmodifiable([entry, ...state]);
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.luckyEventHistoryDao
          .insertRow(
            dayIndex: dayIndex,
            title: title,
            description: description,
            amountCents: amountCents,
            taxDeductedCents: taxDeductedCents,
          )
          .catchError((Object _) => 0),
    );
  }

  /// Spec-45 G4: Top-3 Events nach Betrag-Magnitude. Mischt positive
  /// und negative — größter Glücksfall + größter Pechfall stehen so
  /// nebeneinander.
  List<LuckyEventEntry> topByMagnitude(int n) {
    final sorted = [...state]
      ..sort((a, b) => b.amountCents.abs().compareTo(a.amountCents.abs()));
    return sorted.take(n).toList(growable: false);
  }
}

class LuckyEventEntry {
  const LuckyEventEntry({
    required this.dayIndex,
    required this.title,
    required this.description,
    required this.amountCents,
    required this.taxDeductedCents,
  });

  final int dayIndex;
  final String title;
  final String description;
  final int amountCents;
  final int taxDeductedCents;
}
