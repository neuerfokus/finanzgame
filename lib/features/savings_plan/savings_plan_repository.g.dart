// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_plan_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SavingsPlanRepository)
final savingsPlanRepositoryProvider = SavingsPlanRepositoryProvider._();

final class SavingsPlanRepositoryProvider
    extends $NotifierProvider<SavingsPlanRepository, List<SavingsPlan>> {
  SavingsPlanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingsPlanRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingsPlanRepositoryHash();

  @$internal
  @override
  SavingsPlanRepository create() => SavingsPlanRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SavingsPlan> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SavingsPlan>>(value),
    );
  }
}

String _$savingsPlanRepositoryHash() =>
    r'401a98569bcc5bb07eb24336ccaf16431405f1e8';

abstract class _$SavingsPlanRepository extends $Notifier<List<SavingsPlan>> {
  List<SavingsPlan> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<SavingsPlan>, List<SavingsPlan>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SavingsPlan>, List<SavingsPlan>>,
              List<SavingsPlan>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
