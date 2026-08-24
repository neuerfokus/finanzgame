// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_log.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ConsumptionLog)
final consumptionLogProvider = ConsumptionLogProvider._();

final class ConsumptionLogProvider
    extends $NotifierProvider<ConsumptionLog, List<ConsumptionEntry>> {
  ConsumptionLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consumptionLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consumptionLogHash();

  @$internal
  @override
  ConsumptionLog create() => ConsumptionLog();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ConsumptionEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ConsumptionEntry>>(value),
    );
  }
}

String _$consumptionLogHash() => r'6f55b9cdf0836a329195d14a761b65522d5127da';

abstract class _$ConsumptionLog extends $Notifier<List<ConsumptionEntry>> {
  List<ConsumptionEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<ConsumptionEntry>, List<ConsumptionEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ConsumptionEntry>, List<ConsumptionEntry>>,
              List<ConsumptionEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
