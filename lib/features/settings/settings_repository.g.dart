// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends $NotifierProvider<SettingsRepository, GameSettings> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  SettingsRepository create() => SettingsRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameSettings>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'adc89a5e0cf5a1d8c957fd515fc286d764715a68';

abstract class _$SettingsRepository extends $Notifier<GameSettings> {
  GameSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameSettings, GameSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameSettings, GameSettings>,
              GameSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Altersstatus der echten Person am Gerät, abgeleitet aus dem gespeicherten
/// Geburtsjahr und dem HEUTIGEN Jahr — nicht eingefroren. Wer als
/// minderjährig eingetragen ist, wird mit der Zeit von selbst volljährig.
///
/// Steuert einzig die Sichtbarkeit des Unterstützen-Bereichs. Auf das Spiel
/// selbst hat der Status keinerlei Einfluss: es ist in jedem Zustand
/// vollständig spielbar, auch wenn die Frage übersprungen wurde.

@ProviderFor(ageState)
final ageStateProvider = AgeStateProvider._();

/// Altersstatus der echten Person am Gerät, abgeleitet aus dem gespeicherten
/// Geburtsjahr und dem HEUTIGEN Jahr — nicht eingefroren. Wer als
/// minderjährig eingetragen ist, wird mit der Zeit von selbst volljährig.
///
/// Steuert einzig die Sichtbarkeit des Unterstützen-Bereichs. Auf das Spiel
/// selbst hat der Status keinerlei Einfluss: es ist in jedem Zustand
/// vollständig spielbar, auch wenn die Frage übersprungen wurde.

final class AgeStateProvider
    extends $FunctionalProvider<AgeState, AgeState, AgeState>
    with $Provider<AgeState> {
  /// Altersstatus der echten Person am Gerät, abgeleitet aus dem gespeicherten
  /// Geburtsjahr und dem HEUTIGEN Jahr — nicht eingefroren. Wer als
  /// minderjährig eingetragen ist, wird mit der Zeit von selbst volljährig.
  ///
  /// Steuert einzig die Sichtbarkeit des Unterstützen-Bereichs. Auf das Spiel
  /// selbst hat der Status keinerlei Einfluss: es ist in jedem Zustand
  /// vollständig spielbar, auch wenn die Frage übersprungen wurde.
  AgeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ageStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ageStateHash();

  @$internal
  @override
  $ProviderElement<AgeState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AgeState create(Ref ref) {
    return ageState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AgeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AgeState>(value),
    );
  }
}

String _$ageStateHash() => r'369d063a10d813be103524c53cead32420ed81d8';
