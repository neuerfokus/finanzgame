// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_passive_income.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persistente Queue aller laufenden Quest-Passiv-Zahlungen via Drift.

@ProviderFor(QuestPassiveIncome)
final questPassiveIncomeProvider = QuestPassiveIncomeProvider._();

/// Persistente Queue aller laufenden Quest-Passiv-Zahlungen via Drift.
final class QuestPassiveIncomeProvider
    extends $NotifierProvider<QuestPassiveIncome, List<QuestPassivePayment>> {
  /// Persistente Queue aller laufenden Quest-Passiv-Zahlungen via Drift.
  QuestPassiveIncomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'questPassiveIncomeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$questPassiveIncomeHash();

  @$internal
  @override
  QuestPassiveIncome create() => QuestPassiveIncome();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<QuestPassivePayment> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<QuestPassivePayment>>(value),
    );
  }
}

String _$questPassiveIncomeHash() =>
    r'07643a919ea53c0a00d9eca473686614101ae1ad';

/// Persistente Queue aller laufenden Quest-Passiv-Zahlungen via Drift.

abstract class _$QuestPassiveIncome
    extends $Notifier<List<QuestPassivePayment>> {
  List<QuestPassivePayment> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<QuestPassivePayment>, List<QuestPassivePayment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<QuestPassivePayment>, List<QuestPassivePayment>>,
              List<QuestPassivePayment>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
