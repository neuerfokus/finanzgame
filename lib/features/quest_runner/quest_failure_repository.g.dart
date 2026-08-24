// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_failure_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-45 Welle-8 Round 3: Quest-Fail-Cooldown.
///
/// Wenn Spieler im Quest-Quiz 2× falsch antwortet, ist die Quest für
/// [cooldownDays] Tage gesperrt. Danach kann er sie neu versuchen.
///
/// In-memory KeepAlive — überlebt App-Restart nicht, akzeptabel weil
/// Cooldown nur kurz (2 Tage = wenige Schlafen-Aktionen).

@ProviderFor(QuestFailureRepository)
final questFailureRepositoryProvider = QuestFailureRepositoryProvider._();

/// Spec-45 Welle-8 Round 3: Quest-Fail-Cooldown.
///
/// Wenn Spieler im Quest-Quiz 2× falsch antwortet, ist die Quest für
/// [cooldownDays] Tage gesperrt. Danach kann er sie neu versuchen.
///
/// In-memory KeepAlive — überlebt App-Restart nicht, akzeptabel weil
/// Cooldown nur kurz (2 Tage = wenige Schlafen-Aktionen).
final class QuestFailureRepositoryProvider
    extends $NotifierProvider<QuestFailureRepository, Map<String, int>> {
  /// Spec-45 Welle-8 Round 3: Quest-Fail-Cooldown.
  ///
  /// Wenn Spieler im Quest-Quiz 2× falsch antwortet, ist die Quest für
  /// [cooldownDays] Tage gesperrt. Danach kann er sie neu versuchen.
  ///
  /// In-memory KeepAlive — überlebt App-Restart nicht, akzeptabel weil
  /// Cooldown nur kurz (2 Tage = wenige Schlafen-Aktionen).
  QuestFailureRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questFailureRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questFailureRepositoryHash();

  @$internal
  @override
  QuestFailureRepository create() => QuestFailureRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$questFailureRepositoryHash() =>
    r'c1e5a9f8915bff14406a839da82a429fcd41f516';

/// Spec-45 Welle-8 Round 3: Quest-Fail-Cooldown.
///
/// Wenn Spieler im Quest-Quiz 2× falsch antwortet, ist die Quest für
/// [cooldownDays] Tage gesperrt. Danach kann er sie neu versuchen.
///
/// In-memory KeepAlive — überlebt App-Restart nicht, akzeptabel weil
/// Cooldown nur kurz (2 Tage = wenige Schlafen-Aktionen).

abstract class _$QuestFailureRepository extends $Notifier<Map<String, int>> {
  Map<String, int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, int>, Map<String, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, int>, Map<String, int>>,
              Map<String, int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
