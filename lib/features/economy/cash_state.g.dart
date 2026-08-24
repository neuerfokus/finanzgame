// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Player cash balance.
///
/// Backed by Drift: seed = 2500¢ on first run; loaded from DB during
/// pre-warm; mutators write through fire-and-forget so the public API
/// stays synchronous.

@ProviderFor(CashState)
final cashStateProvider = CashStateProvider._();

/// Player cash balance.
///
/// Backed by Drift: seed = 2500¢ on first run; loaded from DB during
/// pre-warm; mutators write through fire-and-forget so the public API
/// stays synchronous.
final class CashStateProvider extends $NotifierProvider<CashState, Money> {
  /// Player cash balance.
  ///
  /// Backed by Drift: seed = 2500¢ on first run; loaded from DB during
  /// pre-warm; mutators write through fire-and-forget so the public API
  /// stays synchronous.
  CashStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashStateHash();

  @$internal
  @override
  CashState create() => CashState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Money value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Money>(value),
    );
  }
}

String _$cashStateHash() => r'd17086f257efd1c33959094cfab2fe5efb617541';

/// Player cash balance.
///
/// Backed by Drift: seed = 2500¢ on first run; loaded from DB during
/// pre-warm; mutators write through fire-and-forget so the public API
/// stays synchronous.

abstract class _$CashState extends $Notifier<Money> {
  Money build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Money, Money>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Money, Money>,
              Money,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
