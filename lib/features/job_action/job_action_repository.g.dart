// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_action_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(JobActionRepository)
final jobActionRepositoryProvider = JobActionRepositoryProvider._();

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
final class JobActionRepositoryProvider
    extends $NotifierProvider<JobActionRepository, JobActionState> {
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
  JobActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobActionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobActionRepositoryHash();

  @$internal
  @override
  JobActionRepository create() => JobActionRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobActionState>(value),
    );
  }
}

String _$jobActionRepositoryHash() =>
    r'b799dbb30a488173d82233652ca21c554502c1c4';

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

abstract class _$JobActionRepository extends $Notifier<JobActionState> {
  JobActionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<JobActionState, JobActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobActionState, JobActionState>,
              JobActionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
