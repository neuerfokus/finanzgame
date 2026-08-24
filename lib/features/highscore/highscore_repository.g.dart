// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highscore_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persistenz-Layer für Highscores + Run-Statistik.
///
/// Schreibt JSON-File in `getApplicationDocumentsDirectory()/highscores.json`.
/// Bewusst KEIN Drift (kein Schema-Change in diesem Sprint nötig).
///
/// JSON-Format:
/// ```json
/// {
///   "firstMillionaireDayIndex": 1234,
///   "entries": [
///     { "playerName": "Max", "startedAt": "...", ... }
///   ]
/// }
/// ```

@ProviderFor(HighscoreRepository)
final highscoreRepositoryProvider = HighscoreRepositoryProvider._();

/// Persistenz-Layer für Highscores + Run-Statistik.
///
/// Schreibt JSON-File in `getApplicationDocumentsDirectory()/highscores.json`.
/// Bewusst KEIN Drift (kein Schema-Change in diesem Sprint nötig).
///
/// JSON-Format:
/// ```json
/// {
///   "firstMillionaireDayIndex": 1234,
///   "entries": [
///     { "playerName": "Max", "startedAt": "...", ... }
///   ]
/// }
/// ```
final class HighscoreRepositoryProvider
    extends $AsyncNotifierProvider<HighscoreRepository, HighscoreData> {
  /// Persistenz-Layer für Highscores + Run-Statistik.
  ///
  /// Schreibt JSON-File in `getApplicationDocumentsDirectory()/highscores.json`.
  /// Bewusst KEIN Drift (kein Schema-Change in diesem Sprint nötig).
  ///
  /// JSON-Format:
  /// ```json
  /// {
  ///   "firstMillionaireDayIndex": 1234,
  ///   "entries": [
  ///     { "playerName": "Max", "startedAt": "...", ... }
  ///   ]
  /// }
  /// ```
  HighscoreRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'highscoreRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$highscoreRepositoryHash();

  @$internal
  @override
  HighscoreRepository create() => HighscoreRepository();
}

String _$highscoreRepositoryHash() =>
    r'642e6c88aa893b281636c43b43484fa0a35bbc33';

/// Persistenz-Layer für Highscores + Run-Statistik.
///
/// Schreibt JSON-File in `getApplicationDocumentsDirectory()/highscores.json`.
/// Bewusst KEIN Drift (kein Schema-Change in diesem Sprint nötig).
///
/// JSON-Format:
/// ```json
/// {
///   "firstMillionaireDayIndex": 1234,
///   "entries": [
///     { "playerName": "Max", "startedAt": "...", ... }
///   ]
/// }
/// ```

abstract class _$HighscoreRepository extends $AsyncNotifier<HighscoreData> {
  FutureOr<HighscoreData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HighscoreData>, HighscoreData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HighscoreData>, HighscoreData>,
              AsyncValue<HighscoreData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
