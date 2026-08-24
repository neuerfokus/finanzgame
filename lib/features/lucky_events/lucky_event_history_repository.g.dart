// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_event_history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-45 A2 + G4: persistente Lucky-Event-Historie. Wird im
/// GameClock-Listener-Hook befüllt sobald ein [LuckyEvent] in der
/// Pipeline auftaucht. Konsumenten:
/// - Bank-App "Glücks-Events"-Tab
/// - RuhestandPage Top-3-Recap

@ProviderFor(LuckyEventHistoryRepository)
final luckyEventHistoryRepositoryProvider =
    LuckyEventHistoryRepositoryProvider._();

/// Spec-45 A2 + G4: persistente Lucky-Event-Historie. Wird im
/// GameClock-Listener-Hook befüllt sobald ein [LuckyEvent] in der
/// Pipeline auftaucht. Konsumenten:
/// - Bank-App "Glücks-Events"-Tab
/// - RuhestandPage Top-3-Recap
final class LuckyEventHistoryRepositoryProvider
    extends
        $NotifierProvider<LuckyEventHistoryRepository, List<LuckyEventEntry>> {
  /// Spec-45 A2 + G4: persistente Lucky-Event-Historie. Wird im
  /// GameClock-Listener-Hook befüllt sobald ein [LuckyEvent] in der
  /// Pipeline auftaucht. Konsumenten:
  /// - Bank-App "Glücks-Events"-Tab
  /// - RuhestandPage Top-3-Recap
  LuckyEventHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'luckyEventHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$luckyEventHistoryRepositoryHash();

  @$internal
  @override
  LuckyEventHistoryRepository create() => LuckyEventHistoryRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LuckyEventEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LuckyEventEntry>>(value),
    );
  }
}

String _$luckyEventHistoryRepositoryHash() =>
    r'9f7917d6761d2e86e8f829058fda4deaa701b85c';

/// Spec-45 A2 + G4: persistente Lucky-Event-Historie. Wird im
/// GameClock-Listener-Hook befüllt sobald ein [LuckyEvent] in der
/// Pipeline auftaucht. Konsumenten:
/// - Bank-App "Glücks-Events"-Tab
/// - RuhestandPage Top-3-Recap

abstract class _$LuckyEventHistoryRepository
    extends $Notifier<List<LuckyEventEntry>> {
  List<LuckyEventEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<LuckyEventEntry>, List<LuckyEventEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<LuckyEventEntry>, List<LuckyEventEntry>>,
              List<LuckyEventEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
