import 'package:freezed_annotation/freezed_annotation.dart';

part 'highscore_entry.freezed.dart';
part 'highscore_entry.g.dart';

/// Ein eingetragener Highscore-Rekord nach Erreichen von Alter 80.
///
/// Persistiert als JSON-Array via [HighscoreRepository] in der App-
/// Documents-Directory — bewusst NICHT in Drift, damit kein Schema-
/// Change nötig ist.
@freezed
abstract class HighscoreEntry with _$HighscoreEntry {
  const factory HighscoreEntry({
    required String playerName,
    required DateTime startedAt,
    required DateTime endedAt,
    required int finalNetWorthCents,
    required int finalAgeYears,

    /// Alter (in Jahren), bei dem Spieler erstmals Millionär wurde.
    /// `null`, wenn nie erreicht.
    int? firstMillionaireAgeYears,

    /// `null`, wenn nie erreicht.
    int? firstMillionaireDayIndex,

    /// Welle-8 Round 20: Vermögen in Cents zum Zeitpunkt des
    /// Millionär-Werdens (erste Überschreitung 1 Mio €). Null wenn nie.
    int? firstMillionaireNetWorthCents,
  }) = _HighscoreEntry;

  factory HighscoreEntry.fromJson(Map<String, dynamic> json) =>
      _$HighscoreEntryFromJson(json);
}
