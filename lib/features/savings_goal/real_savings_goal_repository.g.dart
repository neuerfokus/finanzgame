// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_savings_goal_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Welle C: echte Sparziele des Kindes. Erstellen + Fortschritt eintragen
/// sind kind-zugänglich; das Bestätigen (Belohnung) ist Eltern-PIN-gated
/// (in der UI). Persistent via [RealSavingsGoalsTable] (Drift v33).

@ProviderFor(RealSavingsGoalRepository)
final realSavingsGoalRepositoryProvider = RealSavingsGoalRepositoryProvider._();

/// Welle C: echte Sparziele des Kindes. Erstellen + Fortschritt eintragen
/// sind kind-zugänglich; das Bestätigen (Belohnung) ist Eltern-PIN-gated
/// (in der UI). Persistent via [RealSavingsGoalsTable] (Drift v33).
final class RealSavingsGoalRepositoryProvider
    extends
        $NotifierProvider<RealSavingsGoalRepository, List<RealSavingsGoal>> {
  /// Welle C: echte Sparziele des Kindes. Erstellen + Fortschritt eintragen
  /// sind kind-zugänglich; das Bestätigen (Belohnung) ist Eltern-PIN-gated
  /// (in der UI). Persistent via [RealSavingsGoalsTable] (Drift v33).
  RealSavingsGoalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realSavingsGoalRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realSavingsGoalRepositoryHash();

  @$internal
  @override
  RealSavingsGoalRepository create() => RealSavingsGoalRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RealSavingsGoal> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RealSavingsGoal>>(value),
    );
  }
}

String _$realSavingsGoalRepositoryHash() =>
    r'd5a313c7c992e1b71d7a4db664d4437a129dbde6';

/// Welle C: echte Sparziele des Kindes. Erstellen + Fortschritt eintragen
/// sind kind-zugänglich; das Bestätigen (Belohnung) ist Eltern-PIN-gated
/// (in der UI). Persistent via [RealSavingsGoalsTable] (Drift v33).

abstract class _$RealSavingsGoalRepository
    extends $Notifier<List<RealSavingsGoal>> {
  List<RealSavingsGoal> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<RealSavingsGoal>, List<RealSavingsGoal>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<RealSavingsGoal>, List<RealSavingsGoal>>,
              List<RealSavingsGoal>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
