// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Savings (Spar) account balance in cents (spec-21).
///
/// Backed by Drift; seed = 0 on first run.
/// `keepAlive: true` so transfers persist through nav pops.

@ProviderFor(SavingsRepository)
final savingsRepositoryProvider = SavingsRepositoryProvider._();

/// Savings (Spar) account balance in cents (spec-21).
///
/// Backed by Drift; seed = 0 on first run.
/// `keepAlive: true` so transfers persist through nav pops.
final class SavingsRepositoryProvider
    extends $NotifierProvider<SavingsRepository, Money> {
  /// Savings (Spar) account balance in cents (spec-21).
  ///
  /// Backed by Drift; seed = 0 on first run.
  /// `keepAlive: true` so transfers persist through nav pops.
  SavingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingsRepositoryHash();

  @$internal
  @override
  SavingsRepository create() => SavingsRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Money value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Money>(value),
    );
  }
}

String _$savingsRepositoryHash() => r'eea61cbfdaa7b742422107ffeaf349e60db1fc4d';

/// Savings (Spar) account balance in cents (spec-21).
///
/// Backed by Drift; seed = 0 on first run.
/// `keepAlive: true` so transfers persist through nav pops.

abstract class _$SavingsRepository extends $Notifier<Money> {
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
