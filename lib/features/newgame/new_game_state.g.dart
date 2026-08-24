// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_game_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Spec-45 G3: NewGame+ Boni über Spiel-Runs.
///
/// Konzept: nach Lebens-Ende (Alter 80) startet Spieler neuen Run mit
/// "Erbschaft" — Cash + XP Boni basierend auf vorigem Erfolg.
/// Highscore-Liste bleibt erhalten, alles andere wird zurückgesetzt.
///
/// Boni:
/// - Erbschaft: 1 % vom vorigen Netto-Vermögen, Cap 1.000 €
/// - Bonus-XP: 10 % vom vorigen XP, Cap 500
///
/// In-memory KeepAlive — überlebt DB-Wipe (Reset-Flow ohne App-Kill).
/// Verliert sich bei vollem App-Restart — User-Hinweis: direkt nach
/// Reset weiterspielen.

@ProviderFor(NewGameState)
final newGameStateProvider = NewGameStateProvider._();

/// Spec-45 G3: NewGame+ Boni über Spiel-Runs.
///
/// Konzept: nach Lebens-Ende (Alter 80) startet Spieler neuen Run mit
/// "Erbschaft" — Cash + XP Boni basierend auf vorigem Erfolg.
/// Highscore-Liste bleibt erhalten, alles andere wird zurückgesetzt.
///
/// Boni:
/// - Erbschaft: 1 % vom vorigen Netto-Vermögen, Cap 1.000 €
/// - Bonus-XP: 10 % vom vorigen XP, Cap 500
///
/// In-memory KeepAlive — überlebt DB-Wipe (Reset-Flow ohne App-Kill).
/// Verliert sich bei vollem App-Restart — User-Hinweis: direkt nach
/// Reset weiterspielen.
final class NewGameStateProvider
    extends $NotifierProvider<NewGameState, NewGameData> {
  /// Spec-45 G3: NewGame+ Boni über Spiel-Runs.
  ///
  /// Konzept: nach Lebens-Ende (Alter 80) startet Spieler neuen Run mit
  /// "Erbschaft" — Cash + XP Boni basierend auf vorigem Erfolg.
  /// Highscore-Liste bleibt erhalten, alles andere wird zurückgesetzt.
  ///
  /// Boni:
  /// - Erbschaft: 1 % vom vorigen Netto-Vermögen, Cap 1.000 €
  /// - Bonus-XP: 10 % vom vorigen XP, Cap 500
  ///
  /// In-memory KeepAlive — überlebt DB-Wipe (Reset-Flow ohne App-Kill).
  /// Verliert sich bei vollem App-Restart — User-Hinweis: direkt nach
  /// Reset weiterspielen.
  NewGameStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newGameStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newGameStateHash();

  @$internal
  @override
  NewGameState create() => NewGameState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewGameData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewGameData>(value),
    );
  }
}

String _$newGameStateHash() => r'7288c470714c558400229f1ce36e92644ab68c47';

/// Spec-45 G3: NewGame+ Boni über Spiel-Runs.
///
/// Konzept: nach Lebens-Ende (Alter 80) startet Spieler neuen Run mit
/// "Erbschaft" — Cash + XP Boni basierend auf vorigem Erfolg.
/// Highscore-Liste bleibt erhalten, alles andere wird zurückgesetzt.
///
/// Boni:
/// - Erbschaft: 1 % vom vorigen Netto-Vermögen, Cap 1.000 €
/// - Bonus-XP: 10 % vom vorigen XP, Cap 500
///
/// In-memory KeepAlive — überlebt DB-Wipe (Reset-Flow ohne App-Kill).
/// Verliert sich bei vollem App-Restart — User-Hinweis: direkt nach
/// Reset weiterspielen.

abstract class _$NewGameState extends $Notifier<NewGameData> {
  NewGameData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NewGameData, NewGameData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewGameData, NewGameData>,
              NewGameData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
