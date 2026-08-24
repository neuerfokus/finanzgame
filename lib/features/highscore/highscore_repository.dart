import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/highscore/highscore_entry.dart';

part 'highscore_repository.g.dart';

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
@Riverpod(keepAlive: true)
class HighscoreRepository extends _$HighscoreRepository {
  static const _fileName = 'highscores.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _fileName));
  }

  @override
  Future<HighscoreData> build() async {
    try {
      final f = await _file();
      if (!await f.exists()) return const HighscoreData();
      final raw = await f.readAsString();
      if (raw.trim().isEmpty) return const HighscoreData();
      return HighscoreData.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // Robust gegen korrupte/locked Files — wir starten leer statt zu
      // crashen (offline-first).
      return const HighscoreData();
    }
  }

  Future<void> _persist(HighscoreData data) async {
    try {
      final f = await _file();
      await f.writeAsString(jsonEncode(data.toJson()));
    } on Object {
      // Best-effort.
    }
  }

  /// B8: pro Spielername wird nur der beste Lauf gehalten — kleinstes
  /// Millionärs-Alter zuerst, bei Gleichstand höchster End-Vermögen.
  /// Bestehender Eintrag wird ersetzt, falls neuer Lauf besser ist.
  Future<void> addEntry(HighscoreEntry entry) async {
    final current = await future;
    final byName = <String, HighscoreEntry>{};
    for (final e in current.entries) {
      byName[e.playerName] = e;
    }
    final existing = byName[entry.playerName];
    if (existing == null || _isBetter(entry, existing)) {
      byName[entry.playerName] = entry;
    }
    final next = current.copyWith(
      entries: byName.values.toList()..sort(_cmp),
    );
    state = AsyncData(next);
    await _persist(next);
  }

  /// B8: "Besser" = jünger Millionär (oder überhaupt) erreicht. Bei
  /// gleichem Alter zählt höheres End-Vermögen.
  static bool _isBetter(HighscoreEntry a, HighscoreEntry b) =>
      _cmp(a, b) < 0;

  static int _cmp(HighscoreEntry a, HighscoreEntry b) {
    final ageA = a.firstMillionaireAgeYears ?? 999;
    final ageB = b.firstMillionaireAgeYears ?? 999;
    if (ageA != ageB) return ageA.compareTo(ageB);
    return b.finalNetWorthCents.compareTo(a.finalNetWorthCents);
  }

  /// Setzt das First-Millionaire-Day-Flag für den aktuellen Run.
  /// Idempotent — falls schon gesetzt, no-op.
  /// Welle-8 Round 20: nimmt zusätzlich das Net-Worth-Cents zum
  /// Zeitpunkt mit.
  Future<void> setFirstMillionaireDay(int dayIndex,
      {int? netWorthCents}) async {
    final current = await future;
    if (current.firstMillionaireDayIndex != null) return;
    final next = current.copyWith(
      firstMillionaireDayIndex: dayIndex,
      firstMillionaireNetWorthCents: netWorthCents,
    );
    state = AsyncData(next);
    await _persist(next);
  }

  /// Setzt den Run zurück (nach Game-End / Reset).
  Future<void> clearCurrentRun() async {
    final current = await future;
    final next = current.copyWith(
      firstMillionaireDayIndex: null,
      firstMillionaireNetWorthCents: null,
    );
    state = AsyncData(next);
    await _persist(next);
  }
}

/// Container für den Repository-State: Entries + aktueller Run.
class HighscoreData {
  const HighscoreData({
    this.firstMillionaireDayIndex,
    this.firstMillionaireNetWorthCents,
    this.entries = const [],
  });

  factory HighscoreData.fromJson(Map<String, dynamic> json) => HighscoreData(
        firstMillionaireDayIndex: json['firstMillionaireDayIndex'] as int?,
        firstMillionaireNetWorthCents:
            json['firstMillionaireNetWorthCents'] as int?,
        entries: (json['entries'] as List<dynamic>? ?? const [])
            .map((e) => HighscoreEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Tag-Index, an dem im aktuellen Run erstmals Millionär (1 Mio €)
  /// erreicht wurde. `null` = noch nie.
  final int? firstMillionaireDayIndex;

  /// Welle-8 Round 20: Vermögen in Cents zum Zeitpunkt des
  /// Millionär-Werdens.
  final int? firstMillionaireNetWorthCents;

  /// Alle abgeschlossenen Runs, sortiert nach `finalNetWorthCents` desc.
  final List<HighscoreEntry> entries;

  HighscoreData copyWith({
    Object? firstMillionaireDayIndex = _sentinel,
    Object? firstMillionaireNetWorthCents = _sentinel,
    List<HighscoreEntry>? entries,
  }) =>
      HighscoreData(
        firstMillionaireDayIndex:
            identical(firstMillionaireDayIndex, _sentinel)
                ? this.firstMillionaireDayIndex
                : firstMillionaireDayIndex as int?,
        firstMillionaireNetWorthCents:
            identical(firstMillionaireNetWorthCents, _sentinel)
                ? this.firstMillionaireNetWorthCents
                : firstMillionaireNetWorthCents as int?,
        entries: entries ?? this.entries,
      );

  Map<String, dynamic> toJson() => {
        'firstMillionaireDayIndex': firstMillionaireDayIndex,
        'firstMillionaireNetWorthCents': firstMillionaireNetWorthCents,
        'entries': entries.map((e) => e.toJson()).toList(),
      };

  static const _sentinel = Object();
}
