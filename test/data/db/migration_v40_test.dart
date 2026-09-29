import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';

/// Drift v40: Lesbarkeits-Einstellungen (`readable_font`, `text_scale_pct`).
///
/// Ein Spielstand aus v39 hat beide Spalten nicht. Nach der Migration müssen
/// sie da sein und die Defaults liefern: lesbare Schrift AN, Größe 100 %.
void main() {
  test('v39 → v40 ergänzt readable_font + text_scale_pct mit Defaults',
      () async {
    final dir = await Directory.systemTemp.createTemp('fg_migration_v40');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/v39.sqlite');

    // 1. Aktuelles Schema anlegen, Einstellungszeile schreiben.
    final fresh = AppDatabase(NativeDatabase(file));
    await fresh.settingsDao.upsert(
      allowanceCents: 8000,
      allowanceWeekday: 'mon',
      playerName: 'Alt',
      soundEnabled: true,
      lastQuizDayIndex: -1,
      zeitreiseTutorialSeen: false,
      musicVolume: 0,
      masterVolume: 60,
      sfxVolume: 40,
      lastSleepEpochMs: 0,
      sleepCountInWindow: 0,
      onboardingComplete: true,
      avatarEmoji: '🧒',
    );
    // 2. Auf den v39-Stand zurückbauen: die zwei neuen Spalten entfernen.
    await fresh.customStatement(
        'ALTER TABLE settings_table DROP COLUMN readable_font');
    await fresh.customStatement(
        'ALTER TABLE settings_table DROP COLUMN text_scale_pct');
    await fresh.customStatement('PRAGMA user_version = 39');
    expect(await fresh.hasColumn('settings_table', 'readable_font'), isFalse);
    await fresh.close();

    // 3. Neu öffnen → onUpgrade 39 → 40.
    final migrated = AppDatabase(NativeDatabase(file));
    addTearDown(migrated.close);
    final v = (await migrated.customSelect('PRAGMA user_version').getSingle())
        .read<int>('user_version');
    expect(v, 40);
    expect(await migrated.hasColumn('settings_table', 'readable_font'), isTrue);
    expect(
        await migrated.hasColumn('settings_table', 'text_scale_pct'), isTrue);

    final snap = await loadDbSnapshot(migrated);
    expect(snap.settings.playerName, 'Alt', reason: 'Spielstand bleibt');
    expect(snap.settings.readableFont, isTrue);
    expect(snap.settings.textScalePct, 100);
  });
}
