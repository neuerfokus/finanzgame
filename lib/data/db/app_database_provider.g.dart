// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// In-memory DB by default. Production overrides this with a file-backed DB
/// in `main.dart`. The provider owns the connection lifecycle.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// In-memory DB by default. Production overrides this with a file-backed DB
/// in `main.dart`. The provider owns the connection lifecycle.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// In-memory DB by default. Production overrides this with a file-backed DB
  /// in `main.dart`. The provider owns the connection lifecycle.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'c7960ae205bde8cde971a39197da06d2f5e83c40';

/// DB snapshot loaded once at startup. Default = empty (tests + cold start).
/// Production main pre-warms and overrides this with real values before
/// runApp.

@ProviderFor(dbSnapshot)
final dbSnapshotProvider = DbSnapshotProvider._();

/// DB snapshot loaded once at startup. Default = empty (tests + cold start).
/// Production main pre-warms and overrides this with real values before
/// runApp.

final class DbSnapshotProvider
    extends $FunctionalProvider<DbSnapshot, DbSnapshot, DbSnapshot>
    with $Provider<DbSnapshot> {
  /// DB snapshot loaded once at startup. Default = empty (tests + cold start).
  /// Production main pre-warms and overrides this with real values before
  /// runApp.
  DbSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbSnapshotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dbSnapshotHash();

  @$internal
  @override
  $ProviderElement<DbSnapshot> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DbSnapshot create(Ref ref) {
    return dbSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DbSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DbSnapshot>(value),
    );
  }
}

String _$dbSnapshotHash() => r'dee5ad724b137eed85274c8b66a467ce37b7e775';
