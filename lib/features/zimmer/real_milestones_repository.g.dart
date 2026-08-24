// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_milestones_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Echte Erfolge des Kindes, die der Vater im Eltern-Modus (PIN-geschützt)
/// einträgt. Reine Eltern-kuratierte Liste — keine Spiel-Mechanik, nur
/// Anzeige in der Zimmer-Trophäenwand. Persistent via [RealMilestonesTable]
/// (Drift v26). Neueste zuerst.

@ProviderFor(RealMilestonesRepository)
final realMilestonesRepositoryProvider = RealMilestonesRepositoryProvider._();

/// Echte Erfolge des Kindes, die der Vater im Eltern-Modus (PIN-geschützt)
/// einträgt. Reine Eltern-kuratierte Liste — keine Spiel-Mechanik, nur
/// Anzeige in der Zimmer-Trophäenwand. Persistent via [RealMilestonesTable]
/// (Drift v26). Neueste zuerst.
final class RealMilestonesRepositoryProvider
    extends $NotifierProvider<RealMilestonesRepository, List<RealMilestone>> {
  /// Echte Erfolge des Kindes, die der Vater im Eltern-Modus (PIN-geschützt)
  /// einträgt. Reine Eltern-kuratierte Liste — keine Spiel-Mechanik, nur
  /// Anzeige in der Zimmer-Trophäenwand. Persistent via [RealMilestonesTable]
  /// (Drift v26). Neueste zuerst.
  RealMilestonesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realMilestonesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realMilestonesRepositoryHash();

  @$internal
  @override
  RealMilestonesRepository create() => RealMilestonesRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RealMilestone> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RealMilestone>>(value),
    );
  }
}

String _$realMilestonesRepositoryHash() =>
    r'd723659d45989c365261ecf1196482d52395856e';

/// Echte Erfolge des Kindes, die der Vater im Eltern-Modus (PIN-geschützt)
/// einträgt. Reine Eltern-kuratierte Liste — keine Spiel-Mechanik, nur
/// Anzeige in der Zimmer-Trophäenwand. Persistent via [RealMilestonesTable]
/// (Drift v26). Neueste zuerst.

abstract class _$RealMilestonesRepository
    extends $Notifier<List<RealMilestone>> {
  List<RealMilestone> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<RealMilestone>, List<RealMilestone>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<RealMilestone>, List<RealMilestone>>,
              List<RealMilestone>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
