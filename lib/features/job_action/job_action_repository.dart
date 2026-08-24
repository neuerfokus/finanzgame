import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';

part 'job_action_repository.g.dart';

/// Anti-Glitch-Cooldown zwischen zwei Job-Wechseln: zufällig 3-5 Jahre.
/// Verhindert das Farmen von +5 %-Boni (vor allem per Zeitsprung).
const int kMinSwitchCooldownDays = 1095; // 3 Jahre
const int kMaxSwitchCooldownDays = 1825; // 5 Jahre

/// Spec-45 C5: Spieler-Aktionen rund um den Job.
///
/// Aktionen geben dem Spieler Agency statt nur Auto-Promotion durchs
/// Alter. Drei Optionen:
///
/// 1. **Job-Wechsel** — Reset yearsInLevel + 5 % Brutto-Bonus
///    (Markt-Wechsel zahlt sich aus). 30 Tage Übergangs-Pause ohne
///    Gehalt.
/// 2. **Sabbatical** — 90 Tage komplett raus, keine Einnahmen, Living
///    Cost läuft weiter (eigenes Geld verbrennt).
/// 3. **Reset** — zurück zur Standard-Karriere.
///
/// In-Memory bis nächste Drift-Sammelmigration (v15). Akzeptabel
/// weil Lern-Aktion, nicht spielentscheidend bei App-Restart.
@Riverpod(keepAlive: true)
class JobActionRepository extends _$JobActionRepository {
  /// Zufallsquelle für den Cooldown. In Tests überschreibbar.
  @visibleForTesting
  Random rng = Random();

  @override
  JobActionState build() {
    // Drift v16: persistente Hydrate.
    Future<void>.microtask(_hydrate);
    return const JobActionState();
  }

  Future<void> _hydrate() async {
    if (!ref.mounted) return;
    final db = ref.read(appDatabaseProvider);
    final row = await db.jobActionDao.load();
    if (!ref.mounted || row == null) return;
    state = JobActionState(
      careerBonusPct: row.careerBonusPct,
      pauseUntilDay: row.pauseUntilDay,
      nextSwitchAllowedDay: row.nextSwitchAllowedDay,
      jobVariantIndex: row.jobVariantIndex,
    );
  }

  void _persist() {
    final db = ref.read(appDatabaseProvider);
    final s = state;
    unawaited(db.jobActionDao
        .upsert(
          careerBonusPct: s.careerBonusPct,
          pauseUntilDay: s.pauseUntilDay,
          nextSwitchAllowedDay: s.nextSwitchAllowedDay,
          jobVariantIndex: s.jobVariantIndex,
        )
        .catchError((Object _) {}));
  }

  /// Spec-45 C5: Job-Wechsel. +5 % Brutto, 30 Tage Pause, neue
  /// Berufsbezeichnung (Variante rotiert).
  ///
  /// Anti-Glitch (v35): nur erlaubt wenn der Cooldown abgelaufen ist —
  /// danach 3-5 Spieljahre Sperre (zufällig). Bonus stackt bis +50 %.
  /// No-op (returnt false) wenn der Wechsel noch gesperrt ist.
  bool switchJob(int currentDayIndex) {
    if (!state.canSwitch(currentDayIndex)) return false;
    const span = kMaxSwitchCooldownDays - kMinSwitchCooldownDays;
    final cooldownDays = kMinSwitchCooldownDays + rng.nextInt(span + 1);
    state = JobActionState(
      careerBonusPct: (state.careerBonusPct + 5).clamp(0, 50),
      pauseUntilDay: currentDayIndex + 30,
      nextSwitchAllowedDay: currentDayIndex + cooldownDays,
      jobVariantIndex: state.jobVariantIndex + 1,
    );
    _persist();
    return true;
  }

  /// Spec-45 C5: Sabbatical. 90 Tage kein Gehalt, Living Cost läuft.
  /// Bonus + Cooldown + Titel bleiben unverändert.
  void takeSabbatical(int currentDayIndex) {
    state = JobActionState(
      careerBonusPct: state.careerBonusPct,
      pauseUntilDay: currentDayIndex + 90,
      nextSwitchAllowedDay: state.nextSwitchAllowedDay,
      jobVariantIndex: state.jobVariantIndex,
    );
    _persist();
  }

  /// Reset aller Aktionen.
  void reset() {
    state = const JobActionState();
    _persist();
  }
}

class JobActionState {
  const JobActionState({
    this.careerBonusPct = 0,
    this.pauseUntilDay = -1,
    this.nextSwitchAllowedDay = -1,
    this.jobVariantIndex = 0,
  });

  /// Akkumulierter Bonus durch Job-Wechsel (Prozent auf Brutto).
  final int careerBonusPct;

  /// Bis zu diesem Tag (exklusiv) kein Gehalt. -1 = keine Pause aktiv.
  final int pauseUntilDay;

  /// Frühester Tag für den nächsten Job-Wechsel (Cooldown-Gate).
  /// -1 = noch nie gewechselt → sofort erlaubt.
  final int nextSwitchAllowedDay;

  /// Index in den fiktiven Titel-Pool (siehe JobConfig.jobTitle).
  /// Steigt mit jedem Wechsel → andere Berufsbezeichnung.
  final int jobVariantIndex;

  bool isPaused(int dayIndex) => dayIndex < pauseUntilDay;

  /// Cooldown abgelaufen? (erstmaliger Wechsel immer erlaubt).
  bool canSwitch(int dayIndex) => dayIndex >= nextSwitchAllowedDay;

  /// Verbleibende Sperr-Tage bis zum nächsten möglichen Wechsel.
  int daysUntilSwitch(int dayIndex) {
    final d = nextSwitchAllowedDay - dayIndex;
    return d < 0 ? 0 : d;
  }
}
