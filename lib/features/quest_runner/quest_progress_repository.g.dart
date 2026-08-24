// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_progress_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted quest-progress state. The repository exposes:
/// - sync read of progress entries (hydrated from [DbSnapshot] at boot)
/// - async per-quest chat-history read (lazy, not preloaded)
/// - mutators that update the in-memory map AND fire-and-forget the DB write
///
/// State == `Map<String, QuestProgress>` (pure Dart) so widgets can rebuild
/// on any progress change (e.g. `QuestListPage` re-bucketing after
/// `markCompleted`). The Drift [QuestProgressRow] is mapped at the
/// boundary.

@ProviderFor(QuestProgressRepository)
final questProgressRepositoryProvider = QuestProgressRepositoryProvider._();

/// Persisted quest-progress state. The repository exposes:
/// - sync read of progress entries (hydrated from [DbSnapshot] at boot)
/// - async per-quest chat-history read (lazy, not preloaded)
/// - mutators that update the in-memory map AND fire-and-forget the DB write
///
/// State == `Map<String, QuestProgress>` (pure Dart) so widgets can rebuild
/// on any progress change (e.g. `QuestListPage` re-bucketing after
/// `markCompleted`). The Drift [QuestProgressRow] is mapped at the
/// boundary.
final class QuestProgressRepositoryProvider
    extends
        $NotifierProvider<QuestProgressRepository, Map<String, QuestProgress>> {
  /// Persisted quest-progress state. The repository exposes:
  /// - sync read of progress entries (hydrated from [DbSnapshot] at boot)
  /// - async per-quest chat-history read (lazy, not preloaded)
  /// - mutators that update the in-memory map AND fire-and-forget the DB write
  ///
  /// State == `Map<String, QuestProgress>` (pure Dart) so widgets can rebuild
  /// on any progress change (e.g. `QuestListPage` re-bucketing after
  /// `markCompleted`). The Drift [QuestProgressRow] is mapped at the
  /// boundary.
  QuestProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questProgressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questProgressRepositoryHash();

  @$internal
  @override
  QuestProgressRepository create() => QuestProgressRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, QuestProgress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, QuestProgress>>(value),
    );
  }
}

String _$questProgressRepositoryHash() =>
    r'7da8c5d0a5558f83df296e50dd8a26d07d98117d';

/// Persisted quest-progress state. The repository exposes:
/// - sync read of progress entries (hydrated from [DbSnapshot] at boot)
/// - async per-quest chat-history read (lazy, not preloaded)
/// - mutators that update the in-memory map AND fire-and-forget the DB write
///
/// State == `Map<String, QuestProgress>` (pure Dart) so widgets can rebuild
/// on any progress change (e.g. `QuestListPage` re-bucketing after
/// `markCompleted`). The Drift [QuestProgressRow] is mapped at the
/// boundary.

abstract class _$QuestProgressRepository
    extends $Notifier<Map<String, QuestProgress>> {
  Map<String, QuestProgress> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, QuestProgress>, Map<String, QuestProgress>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, QuestProgress>,
                Map<String, QuestProgress>
              >,
              Map<String, QuestProgress>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
