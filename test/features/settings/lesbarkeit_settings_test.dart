import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/audio/sound_service.dart';
import 'package:finanzgame/features/settings/save_export_service.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';
import 'package:finanzgame/features/settings/text_scale.dart';

ProviderContainer _containerForDb(AppDatabase db, {DbSnapshot? snap}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
}

Future<void> _flushWrites() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  tearDown(SoundService.reset);

  group('Lesbarkeit: Einstellungen', () {
    test('Defaults: lesbare Schrift AN, Größe Normal (100 %)', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final s = c.read(settingsRepositoryProvider);
      expect(s.readableFont, isTrue);
      expect(s.textScalePct, 100);
      expect(s.textScale, TextScaleStufe.normal);
    });

    test('Stufen: Klein 0,9 · Normal 1,0 · Groß 1,2', () {
      expect(TextScaleStufe.klein.faktor, 0.9);
      expect(TextScaleStufe.normal.faktor, 1.0);
      expect(TextScaleStufe.gross.faktor, 1.2);
      expect(TextScaleStufe.fromPct(120), TextScaleStufe.gross);
      // Unbekannte Werte (manipulierte/zukünftige Saves) → Normal.
      expect(TextScaleStufe.fromPct(137), TextScaleStufe.normal);
    });

    test('setzen → DB neu laden → Werte bleiben', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(settingsRepositoryProvider.notifier)
        ..setReadableFont(false)
        ..setTextScale(TextScaleStufe.gross);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      expect(snap.settings.readableFont, isFalse);
      expect(snap.settings.textScalePct, 120);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final s = c2.read(settingsRepositoryProvider);
      expect(s.readableFont, isFalse);
      expect(s.textScale, TextScaleStufe.gross);
    });

    test('andere Setter überschreiben die Lesbarkeits-Werte nicht', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c1 = _containerForDb(db);
      c1.read(settingsRepositoryProvider.notifier)
        ..setTextScale(TextScaleStufe.klein)
        ..setAutoSaveEnabled(false);
      await _flushWrites();
      c1.dispose();
      final snap = await loadDbSnapshot(db);
      expect(snap.settings.textScalePct, 90);
    });
  });

  group('Lesbarkeit: Spielstand-Export/-Import', () {
    late Directory dir;
    setUp(() async {
      dir = await Directory.systemTemp.createTemp('fg_lesbarkeit');
    });
    tearDown(() async {
      try {
        await dir.delete(recursive: true);
      } catch (_) {/* silent */}
    });

    test('Export (VACUUM INTO) + Import tragen beide Werte mit', () async {
      final live = AppDatabase(NativeDatabase(File(p.join(dir.path, 'a.db'))));
      final c = _containerForDb(live);
      c.read(settingsRepositoryProvider.notifier)
        ..setReadableFont(false)
        ..setTextScale(TextScaleStufe.gross);
      await _flushWrites();
      c.dispose();

      final export =
          await SaveExportService.instance.consistentSnapshot(live, dir);
      expect(export, isNotNull);
      await live.close();

      final prod = File(p.join(dir.path, 'ziel.sqlite'));
      final zielLive = AppDatabase(NativeDatabase(prod));
      await zielLive.customSelect('SELECT 1').get();
      final res = await SaveExportService.instance.applySaveFileTo(
        export!,
        prod: prod,
        photoDir: Directory(p.join(dir.path, 'photos')),
        live: zielLive,
      );
      expect(res.success, isTrue);

      final after = AppDatabase(NativeDatabase(prod));
      addTearDown(after.close);
      final snap = await loadDbSnapshot(after);
      expect(snap.settings.readableFont, isFalse);
      expect(snap.settings.textScalePct, 120);
    });

    test('alter Spielstand (v39, ohne Spalten) → Import → Defaults',
        () async {
      final old = File(p.join(dir.path, 'alt.sqlite'));
      final src = AppDatabase(NativeDatabase(old));
      await src.customSelect('SELECT 1').get();
      await src.customStatement(
          'ALTER TABLE settings_table DROP COLUMN readable_font');
      await src.customStatement(
          'ALTER TABLE settings_table DROP COLUMN text_scale_pct');
      await src.customStatement('PRAGMA user_version = 39');
      await src.close();

      final prod = File(p.join(dir.path, 'ziel2.sqlite'));
      final zielLive = AppDatabase(NativeDatabase(prod));
      await zielLive.customSelect('SELECT 1').get();
      final res = await SaveExportService.instance.applySaveFileTo(
        old,
        prod: prod,
        photoDir: Directory(p.join(dir.path, 'photos2')),
        live: zielLive,
      );
      expect(res.success, isTrue);

      final after = AppDatabase(NativeDatabase(prod));
      addTearDown(after.close);
      final snap = await loadDbSnapshot(after);
      expect(snap.settings.readableFont, isTrue);
      expect(snap.settings.textScalePct, 100);
    });
  });
}
