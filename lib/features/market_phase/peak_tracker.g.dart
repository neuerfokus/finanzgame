// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peak_tracker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PeakTracker)
final peakTrackerProvider = PeakTrackerProvider._();

final class PeakTrackerProvider
    extends $NotifierProvider<PeakTracker, Map<String, PeakState>> {
  PeakTrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'peakTrackerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$peakTrackerHash();

  @$internal
  @override
  PeakTracker create() => PeakTracker();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, PeakState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, PeakState>>(value),
    );
  }
}

String _$peakTrackerHash() => r'3a1a15d2c66526235b795f0e8c6b9cc537ff0bd1';

abstract class _$PeakTracker extends $Notifier<Map<String, PeakState>> {
  Map<String, PeakState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, PeakState>, Map<String, PeakState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, PeakState>, Map<String, PeakState>>,
              Map<String, PeakState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
