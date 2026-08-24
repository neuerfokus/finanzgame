import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/weekday.dart';
import 'package:finanzgame/features/audio/sound_service.dart';
import 'package:finanzgame/features/settings/settings_repository.dart';

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

  group('SettingsRepository', () {
    test('defaults match hard-coded fall-back', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final s = c.read(settingsRepositoryProvider);
      expect(s.allowance, const Money.cents(8000));
      expect(s.allowanceWeekday, Weekday.mon);
      expect(s.playerName, 'Spieler');
      expect(s.soundEnabled, isTrue);
    });

    test('auto-save default AN; ausschalten → reopen → bleibt AUS', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      // Default: AN (autoSaveDisabled=false).
      expect(c1.read(settingsRepositoryProvider).autoSaveEnabled, isTrue);
      c1.read(settingsRepositoryProvider.notifier).setAutoSaveEnabled(false);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      // Persistiert über DB-Reopen (sonst genau der in-memory-Bug).
      expect(c2.read(settingsRepositoryProvider).autoSaveEnabled, isFalse);

      // Wieder einschalten → persistiert ebenfalls.
      c2.read(settingsRepositoryProvider.notifier).setAutoSaveEnabled(true);
      await _flushWrites();
      final snap2 = await loadDbSnapshot(db);
      expect(snap2.settings.autoSaveDisabled, isFalse);
    });

    test('backup-folder-URI (SAF, Drift v37) → reopen → persisted', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      // Default: kein Ordner gewählt.
      expect(c1.read(settingsRepositoryProvider).backupFolderUri, isNull);
      c1.read(settingsRepositoryProvider.notifier).setBackupFolderUri(
            'content://com.android.externalstorage.documents/tree/primary%3ADownload',
          );
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(
        c2.read(settingsRepositoryProvider).backupFolderUri,
        'content://com.android.externalstorage.documents/tree/primary%3ADownload',
      );
    });

    test('Geburtsjahr + Gate-Sperre (Drift v38) → reopen → persisted',
        () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      final s0 = c1.read(settingsRepositoryProvider);
      expect(s0.birthYear, isNull);
      expect(s0.birthYearAsked, isFalse);
      expect(s0.parentGateLockedUntilMs, 0);

      final repo = c1.read(settingsRepositoryProvider.notifier);
      expect(repo.setBirthYear(1985, currentYear: 2026), isTrue);
      repo.setParentGateLockedUntil(1234567890);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final s1 = c2.read(settingsRepositoryProvider);
      expect(s1.birthYear, 1985);
      // Die Sperre MUSS einen Neustart überstehen — sonst wäre sie mit
      // einem Wisch aus dem Task-Switcher weg.
      expect(s1.parentGateLockedUntilMs, 1234567890);
      // Eine Angabe zählt automatisch als „gefragt": der Dialog kommt nicht
      // bei jedem Start wieder.
      expect(s1.birthYearAsked, isTrue);
    });

    test('set allowance → reopen DB → persisted', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1
          .read(settingsRepositoryProvider.notifier)
          .setAllowance(const Money.cents(3000));
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(
        c2.read(settingsRepositoryProvider).allowance,
        const Money.cents(3000),
      );
    });

    test('set weekday + name + sound → reopen → all preserved', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      final notifier = c1.read(settingsRepositoryProvider.notifier);
      notifier.setAllowanceWeekday(Weekday.fri);
      notifier.setPlayerName('Leon');
      notifier.setSoundEnabled(false);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      final s = c2.read(settingsRepositoryProvider);
      expect(s.allowanceWeekday, Weekday.fri);
      expect(s.playerName, 'Leon');
      expect(s.soundEnabled, isFalse);
    });

    test('setSoundEnabled(false) mirrors onto SoundService.muted', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);

      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(settingsRepositoryProvider.notifier).setSoundEnabled(false);
      expect(rec.muted, isTrue);

      c.read(settingsRepositoryProvider.notifier).setSoundEnabled(true);
      expect(rec.muted, isFalse);
    });

    test('zeitreiseTutorialSeen round-trips (spec-19)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      // Default is false.
      expect(
        c1.read(settingsRepositoryProvider).zeitreiseTutorialSeen,
        isFalse,
      );
      c1
          .read(settingsRepositoryProvider.notifier)
          .setZeitreiseTutorialSeen(true);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(
        c2.read(settingsRepositoryProvider).zeitreiseTutorialSeen,
        isTrue,
      );
    });

    test('muted=true blocks RecordingSoundService.playSfx', () async {
      final rec = RecordingSoundService()..muted = true;
      SoundService.use(rec);
      await SoundService.instance.playSfx(AudioKey.coin);
      expect(rec.played, isEmpty);
    });

    test('musicVolume defaults to 0 (spec-32 — opt-in)', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(settingsRepositoryProvider).musicVolume, 0);
    });

    test('setMusicVolume round-trips through DB (spec-23)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(settingsRepositoryProvider.notifier).setMusicVolume(50);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(settingsRepositoryProvider).musicVolume, 50);
    });

    test('spec-37: setMusicVolume always forwards 0 to SoundService', () {
      // Music has been removed; the slider value is still persisted
      // (for future reactivation) but the audio backend gets 0.
      final rec = RecordingSoundService();
      SoundService.use(rec);

      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(settingsRepositoryProvider.notifier).setMusicVolume(40);
      expect(rec.musicVolume, 0.0);
    });

    test('startAgeYears round-trips through DB (Drift v21 regression)',
        () async {
      // Welle-8 Bug: startAge war in-memory-only → fiel bei App-Neustart
      // auf 13 zurück. Verfälschte Job/Lebenskosten + versteckte
      // age-gated Vorsorge (Bausparvertrag verschwand). Muss persistieren.
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final c1 = _containerForDb(db);
      c1.read(settingsRepositoryProvider.notifier).setStartAgeYears(14);
      await _flushWrites();
      c1.dispose();

      final snap = await loadDbSnapshot(db);
      final c2 = _containerForDb(db, snap: snap);
      addTearDown(c2.dispose);
      expect(c2.read(settingsRepositoryProvider).startAgeYears, 14);
    });

    test('setMusicVolume clamps out-of-range percent input (state only)',
        () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(settingsRepositoryProvider.notifier).setMusicVolume(-20);
      expect(c.read(settingsRepositoryProvider).musicVolume, 0);
      c.read(settingsRepositoryProvider.notifier).setMusicVolume(250);
      expect(c.read(settingsRepositoryProvider).musicVolume, 100);
    });

    // Der PIN lag als Klartext in der DB — und die DB steckt als SQLite in
    // der .fgsave im öffentlichen Download-Ordner, also mit jedem
    // Datei-Manager auslesbar. Jetzt nur noch der SHA-256-Hash.
    group('Eltern-PIN', () {
      test('setParentPin speichert Hash, nicht den Klartext', () {
        final c = ProviderContainer();
        addTearDown(c.dispose);
        final repo = c.read(settingsRepositoryProvider.notifier);
        repo.setParentPin('1234');

        final stored = c.read(settingsRepositoryProvider).parentPin;
        expect(stored, isNot('1234'));
        expect(stored, hasLength(64));
        expect(stored, hashParentPin('1234'));
      });

      test('parentPinMatches prüft richtig + falsch', () {
        final c = ProviderContainer();
        addTearDown(c.dispose);
        final repo = c.read(settingsRepositoryProvider.notifier);
        repo.setParentPin('4711');

        expect(repo.parentPinMatches('4711'), isTrue);
        expect(repo.parentPinMatches('0000'), isFalse);
      });

      test('kein PIN gesetzt → jede Eingabe passt (Lock aus)', () {
        final c = ProviderContainer();
        addTearDown(c.dispose);
        final repo = c.read(settingsRepositoryProvider.notifier);
        expect(repo.parentPinMatches(''), isTrue);
        expect(repo.parentPinMatches('9999'), isTrue);
      });

      test('Alt-Save mit Klartext-PIN wird bei Erfolg auf Hash migriert', () {
        final c = ProviderContainer();
        addTearDown(c.dispose);
        final repo = c.read(settingsRepositoryProvider.notifier);
        // Simuliert einen Save von vor der Hash-Umstellung.
        repo.state = repo.state.copyWith(parentPin: '5678');

        expect(repo.parentPinMatches('1111'), isFalse);
        expect(c.read(settingsRepositoryProvider).parentPin, '5678');

        expect(repo.parentPinMatches('5678'), isTrue);
        expect(c.read(settingsRepositoryProvider).parentPin,
            hashParentPin('5678'));
        // Nach der Migration weiter prüfbar.
        expect(repo.parentPinMatches('5678'), isTrue);
      });
    });
  });
}
