// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_asset_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(questAssetRepository)
final questAssetRepositoryProvider = QuestAssetRepositoryProvider._();

final class QuestAssetRepositoryProvider
    extends
        $FunctionalProvider<
          QuestAssetRepository,
          QuestAssetRepository,
          QuestAssetRepository
        >
    with $Provider<QuestAssetRepository> {
  QuestAssetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questAssetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questAssetRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuestAssetRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuestAssetRepository create(Ref ref) {
    return questAssetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuestAssetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuestAssetRepository>(value),
    );
  }
}

String _$questAssetRepositoryHash() =>
    r'7c9429d719dd834707faa20b0229ca9a9975975e';

@ProviderFor(quests)
final questsProvider = QuestsProvider._();

final class QuestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quest>>,
          List<Quest>,
          FutureOr<List<Quest>>
        >
    with $FutureModifier<List<Quest>>, $FutureProvider<List<Quest>> {
  QuestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questsHash();

  @$internal
  @override
  $FutureProviderElement<List<Quest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Quest>> create(Ref ref) {
    return quests(ref);
  }
}

String _$questsHash() => r'8d87f7664a5867db549b57b99c90bf7092100b8c';
