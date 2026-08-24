// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wissens_quiz_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WissensQuizStatsRepo)
final wissensQuizStatsRepoProvider = WissensQuizStatsRepoProvider._();

final class WissensQuizStatsRepoProvider
    extends $NotifierProvider<WissensQuizStatsRepo, WissensQuizStats> {
  WissensQuizStatsRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wissensQuizStatsRepoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wissensQuizStatsRepoHash();

  @$internal
  @override
  WissensQuizStatsRepo create() => WissensQuizStatsRepo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WissensQuizStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WissensQuizStats>(value),
    );
  }
}

String _$wissensQuizStatsRepoHash() =>
    r'18fa11b37abaa0dc558c8c386bfe48008e107a39';

abstract class _$WissensQuizStatsRepo extends $Notifier<WissensQuizStats> {
  WissensQuizStats build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WissensQuizStats, WissensQuizStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WissensQuizStats, WissensQuizStats>,
              WissensQuizStats,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
