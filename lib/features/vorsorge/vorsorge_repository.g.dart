// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vorsorge_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VorsorgeRepository)
final vorsorgeRepositoryProvider = VorsorgeRepositoryProvider._();

final class VorsorgeRepositoryProvider
    extends $NotifierProvider<VorsorgeRepository, List<VorsorgeContract>> {
  VorsorgeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vorsorgeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vorsorgeRepositoryHash();

  @$internal
  @override
  VorsorgeRepository create() => VorsorgeRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<VorsorgeContract> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<VorsorgeContract>>(value),
    );
  }
}

String _$vorsorgeRepositoryHash() =>
    r'3e05284f52d0dcb865f269b13a66dc529dd740ed';

abstract class _$VorsorgeRepository extends $Notifier<List<VorsorgeContract>> {
  List<VorsorgeContract> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<VorsorgeContract>, List<VorsorgeContract>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<VorsorgeContract>, List<VorsorgeContract>>,
              List<VorsorgeContract>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
