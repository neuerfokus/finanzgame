// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current day's weather. Updated by [WeatherListener] on each
/// `advanceDay()`. Defaults to sunny on day 0.

@ProviderFor(WeatherState)
final weatherStateProvider = WeatherStateProvider._();

/// Current day's weather. Updated by [WeatherListener] on each
/// `advanceDay()`. Defaults to sunny on day 0.
final class WeatherStateProvider
    extends $NotifierProvider<WeatherState, Weather> {
  /// Current day's weather. Updated by [WeatherListener] on each
  /// `advanceDay()`. Defaults to sunny on day 0.
  WeatherStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherStateHash();

  @$internal
  @override
  WeatherState create() => WeatherState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Weather value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Weather>(value),
    );
  }
}

String _$weatherStateHash() => r'7f57089bfded18beb6128d160e90852284ad1a6f';

/// Current day's weather. Updated by [WeatherListener] on each
/// `advanceDay()`. Defaults to sunny on day 0.

abstract class _$WeatherState extends $Notifier<Weather> {
  Weather build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Weather, Weather>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Weather, Weather>,
              Weather,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
