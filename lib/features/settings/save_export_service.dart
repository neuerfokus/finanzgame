import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/db/app_database.dart';
import 'saf_backup_channel.dart';

/// Welle-8 Round 20: manueller Spielstand-Export/Import.
///
/// Bleibt offline-first — User entscheidet selbst wo die Datei
/// liegt (WhatsApp, Drive, eigene Dateien). Kein automatisches
/// Cloud-Backup (CLAUDE.md Hardregel).
///
/// **Format ab Round 28 v3:** ZIP-Bündel `finanzgame.fgsave` mit
/// - `finanzgame.sqlite` (= komplette Drift-DB), und
/// - `wish_photos/<datei>` (Wunschlisten-Fotos aus dem app-support-dir).
///
/// Vorher war `.fgsave` eine rohe SQLite-Datei — die eigenen Fotos
/// fehlten nach Restore (nur der absolute Pfad stand in der DB). Beim
/// Import werden die Bilder extrahiert UND die Foto-Pfade in der DB auf
/// das Foto-Verzeichnis DIESES Geräts umgeschrieben (der absolute
/// app-support-Pfad unterscheidet sich pro Installation/Gerät — nur der
/// Dateiname `<itemId>.<ext>` ist stabil).
///
/// **Abwärtskompatibel:** alte rohe SQLite-`.fgsave` importieren weiter
/// (Magic-Byte-Erkennung ZIP `PK␃␄` vs `SQLite format 3`).
class SaveExportService {
  SaveExportService._();
  static final instance = SaveExportService._();

  static const String _dbFileName = 'finanzgame.sqlite';
  static const String _exportExtension = 'fgsave';

  /// Unterordner im ZIP + im app-support-dir für Wunschlisten-Fotos.
  /// Muss mit [WishPhotoService]'s `wish_photos` übereinstimmen.
  static const String _photoDirName = 'wish_photos';

  /// Welle-8 Round 23: persistente Auto-Save-Datei. Liegt in
  /// `/storage/emulated/0/Download/Finanzgame/` — überlebt Deinstall
  /// (App-private Pfade werden bei Uninstall gelöscht).
  static const String _autoSaveDirName = 'Finanzgame';
  static const String _autoSaveFileName = 'autosave.fgsave';
  static const String _publicDownloadRoot = '/storage/emulated/0/Download';

  Future<File> _dbFile() async {
    final dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, _dbFileName));
  }

  /// Konsistente Momentaufnahme der DB über die LIVE-Verbindung.
  ///
  /// **M7 (Analyse 2026-08).** Vorher las der Bündel-Bau die Datei
  /// `finanzgame.sqlite` roh vom Dateisystem — an der offenen Drift-Verbindung
  /// vorbei, die auf einem eigenen Isolate läuft und jederzeit mitten in einer
  /// Schreib-Transaktion stecken kann. Genau das ist beim Auto-Save der
  /// Normalfall: er feuert fire-and-forget direkt nach `advanceDay()`, während
  /// die Repositories ihre `unawaited`-Commits noch abarbeiten (bei einem
  /// Zeitsprung sind das Zehntausende). Eine Rohkopie in diesem Moment enthält
  /// halb geschriebene Seiten ohne das zugehörige Rollback-Journal — sie ist
  /// nicht „ein paar Sekunden alt", sondern potenziell defekt. Und diese Kopie
  /// ist die EINZIGE Sicherung, die eine Deinstallation überlebt.
  ///
  /// `VACUUM INTO` lässt SQLite die Kopie selbst schreiben, durch dieselbe
  /// Verbindung: das Ergebnis ist immer ein transaktionskonsistenter Stand,
  /// nebenbei defragmentiert. Läuft auf dem Drift-Hintergrund-Isolate
  /// (`NativeDatabase.createInBackground`), blockiert also die UI nicht.
  ///
  /// Liefert `null`, wenn kein Live-Handle vorliegt oder das Statement
  /// scheitert — der Aufrufer fällt dann auf die Rohkopie zurück (immer noch
  /// besser als gar keine Sicherung).
  Future<File?> consistentSnapshot(AppDatabase? live, Directory targetDir) async {
    if (live == null) return null;
    try {
      final out = File(p.join(targetDir.path, 'fg_snapshot.sqlite'));
      // VACUUM INTO verlangt eine NICHT existierende Zieldatei.
      if (out.existsSync()) await out.delete();
      await live.customStatement('VACUUM INTO ?', [out.path]);
      return out.existsSync() ? out : null;
    } catch (_) {
      return null;
    }
  }

  Future<Directory> _wishPhotoDir() async {
    final dir = await getApplicationSupportDirectory();
    return Directory(p.join(dir.path, _photoDirName));
  }

  // ---------------------------------------------------------------------------
  // Bundle-Bau + -Extraktion (rein über Pfade → testbar)
  // ---------------------------------------------------------------------------

  static bool isZipBytes(List<int> b) =>
      b.length >= 4 &&
      b[0] == 0x50 &&
      b[1] == 0x4B &&
      b[2] == 0x03 &&
      b[3] == 0x04;

  static bool isSqliteBytes(List<int> b) =>
      b.length >= 15 && String.fromCharCodes(b.take(15)) == 'SQLite format 3';

  /// Packt `dbFile` + alle Dateien aus `photoDir` (falls vorhanden) in ein
  /// ZIP und liefert die Bytes. Reine Funktion über Pfade.
  ///
  /// Lese + DEFLATE-Encode (synchron, CPU-schwer über die ganze DB + Fotos)
  /// laufen in einem **Hintergrund-Isolate** — `writeAutoSave` feuert
  /// fire-and-forget nach jedem Schlafen/Zeitsprung; auf dem UI-Isolate
  /// würde das auf schwachen Geräten (Mi A3) die Day-Summary-Animation
  /// ruckeln lassen.
  Future<Uint8List> buildBundleBytes(File dbFile, Directory photoDir) {
    final dbPath = dbFile.path;
    final photoDirPath = photoDir.path;
    return Isolate.run(() => _buildBundleSync(dbPath, photoDirPath));
  }

  static Uint8List _buildBundleSync(String dbPath, String photoDirPath) {
    final archive = Archive();
    final dbBytes = File(dbPath).readAsBytesSync();
    archive.addFile(ArchiveFile(_dbFileName, dbBytes.length, dbBytes));
    final photoDir = Directory(photoDirPath);
    if (photoDir.existsSync()) {
      for (final entity in photoDir.listSync()) {
        if (entity is! File) continue;
        final bytes = entity.readAsBytesSync();
        archive.addFile(
          ArchiveFile(
            '$_photoDirName/${p.basename(entity.path)}',
            bytes.length,
            bytes,
          )
            // JPEG/PNG sind schon komprimiert — DEFLATE darüber kostet CPU
            // (Akku bei jedem Schlafen/Zeitsprung) und bringt ~0 % Ersparnis.
            ..compress = false,
        );
      }
    }
    final encoded = ZipEncoder().encode(archive);
    if (encoded == null) {
      throw const FileSystemException('ZIP-Encoding fehlgeschlagen');
    }
    return Uint8List.fromList(encoded);
  }

  /// Entpackt ein ZIP-Bündel: schreibt die DB nach `dbDest` und die Fotos
  /// nach `photoDir`. Liefert true bei Erfolg (DB-Eintrag gefunden + valide).
  Future<bool> extractBundle({
    required File source,
    required File dbDest,
    required Directory photoDir,
  }) async {
    try {
      final bytes = await source.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      ArchiveFile? dbEntry;
      final photoEntries = <ArchiveFile>[];
      for (final f in archive) {
        if (!f.isFile) continue;
        final name = f.name.replaceAll('\\', '/');
        if (p.basename(name) == _dbFileName) {
          dbEntry = f;
        } else if (name.startsWith('$_photoDirName/')) {
          photoEntries.add(f);
        }
      }
      if (dbEntry == null) return false;
      final dbContent = dbEntry.content as List<int>;
      if (!isSqliteBytes(dbContent)) return false; // korruptes Bündel
      // Fotos ZUERST (unkritisch), DB als LETZTES schreiben: scheitert ein
      // Foto-Write (Disk voll/Permission), bleibt die alte DB unberührt
      // statt halb-überschrieben.
      if (photoEntries.isNotEmpty && !photoDir.existsSync()) {
        photoDir.createSync(recursive: true);
      }
      for (final f in photoEntries) {
        final out = File(p.join(photoDir.path, p.basename(f.name)));
        await out.writeAsBytes(f.content as List<int>, flush: true);
      }
      await dbDest.writeAsBytes(dbContent, flush: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Schreibt alle Foto-Pfade in der DB auf `photoDir` dieses Geräts um
  /// (Dateiname bleibt, Verzeichnis-Prefix neu). Reine Funktion über eine
  /// bereits geöffnete DB → testbar mit `AppDatabase.memory()`.
  static Future<void> remapPhotoPaths(
    AppDatabase db,
    Directory photoDir,
  ) async {
    final rows = await db.wishItemsDao.loadAll();
    for (final r in rows) {
      final pp = r.photoPath;
      if (pp == null || pp.isEmpty) continue;
      final newPath = p.join(photoDir.path, p.basename(pp));
      if (newPath == pp) continue;
      // L12 (Analyse 2026-08): nur umschreiben, wenn dort auch wirklich ein
      // Bild liegt. Ein Legacy-Save (rohe SQLite, ohne Foto-Bündel) brachte
      // keine Dateien mit — der Pfad wurde trotzdem auf das lokale
      // Verzeichnis gebogen und zeigte damit garantiert ins Leere. Der alte
      // Pfad ist zwar auch tot, aber er bleibt wenigstens ein ehrlicher
      // Hinweis darauf, wo das Bild einmal lag; und wandert später doch noch
      // ein Foto-Bündel ein, greift der Remap dann korrekt.
      if (!File(newPath).existsSync()) continue;
      await db.wishItemsDao.upsert(r.copyWith(photoPath: Value(newPath)));
    }
  }

  /// Öffnet die **Staging-Datei** einmal: erzwingt Drift-`onUpgrade` für
  /// ältere `.fgsave` + schreibt die Foto-Pfade auf dieses Gerät um.
  ///
  /// **M8 (Analyse 2026-08).** Vorher lief das auf der Produktions-DB, und
  /// zwar über eine ZWEITE `NativeDatabase`-Verbindung, während die erste
  /// (die der laufenden App) noch offen war — auf eine Datei, die gerade
  /// unter ihr ausgetauscht worden war. Zwei Fehlerbilder: die alte
  /// Verbindung konnte ihren veralteten Seiten-Cache über die frische Datei
  /// zurückschreiben (echte Korruption), oder die zweite Verbindung lief in
  /// `SQLITE_BUSY` — was hier still verschluckt wurde, sodass Foto-Remap und
  /// Backup-Ordner-URI kommentarlos verloren gingen. Abgesichert war das
  /// allein durch den erzwungenen Neustart danach.
  ///
  /// Jetzt bekommt die Funktion die Staging-Datei: die Produktions-DB wird
  /// erst angefasst, wenn hier alles fertig ist.
  Future<void> _migrateAndRemap(
    File stagingDb,
    Directory photoDir, {
    String? backupFolderUri,
  }) async {
    try {
      final db = AppDatabase(NativeDatabase(stagingDb));
      await db.customSelect('SELECT 1').get(); // erzwingt Migration
      await remapPhotoPaths(db, photoDir);
      if (backupFolderUri != null && backupFolderUri.isNotEmpty) {
        // Der wiederhergestellte Spielstand trägt entweder keine Ordner-URI
        // (Save von ≤ v36) oder die der ALTEN Installation — beide sind auf
        // diesem Gerät wertlos. Ohne dieses Update liefe die Auto-Sicherung
        // nach dem Pflicht-Neustart wieder in den Legacy-Silent-Fail, also
        // genau in den Save-Verlust, den der Restore gerade behoben hat.
        try {
          await db.customStatement(
            'UPDATE settings_table SET backup_folder_uri = ?',
            [backupFolderUri],
          );
        } catch (_) {/* Spalte fehlt (sehr alter Save) → egal */}
      }
      await db.close();
    } catch (_) {/* silent */}
  }

  /// Liest die ersten 16 Bytes deterministisch (nicht nur den ersten
  /// Stream-Chunk). Liefert `[]` bei leerer/unlesbarer Datei → die
  /// Magic-Byte-Checks schlagen sauber fehl statt `StateError` zu werfen
  /// (eine 0-Byte-Datei lieferte sonst aus `Stream.first` ein
  /// `StateError: No element`).
  static Future<List<int>> readHeadBytes(File source) async {
    try {
      return await source
          .openRead(0, 16)
          .fold<List<int>>(<int>[], (acc, chunk) => acc..addAll(chunk));
    } catch (_) {
      return const <int>[];
    }
  }

  /// Räumt verwaiste SQLite-Sidecars (`-wal`/`-shm`/`-journal`) der alten DB
  /// weg, nachdem die Haupt-Datei überschrieben wurde — sonst könnte ein
  /// stehengebliebenes Journal beim nächsten Open über die neue DB
  /// zurückgespielt werden.
  Future<void> _deleteDbSidecars(File db) async {
    for (final suffix in const ['-wal', '-shm', '-journal']) {
      final f = File('${db.path}$suffix');
      try {
        if (f.existsSync()) await f.delete();
      } catch (_) {/* silent */}
    }
  }

  /// Verschiebt eine beschädigte DB beiseite (`.corrupt.bak`) + löscht ihre
  /// Sidecars, sodass beim nächsten `openProductionDatabase()` eine frische
  /// leere DB entsteht statt erneut zu crashen. Genutzt vom Crash-Guard in
  /// `main()`: ohne diesen Schritt hängt die App für immer auf dem nativen
  /// Splash (Baum-Icon), weil `runApp` nie läuft.
  ///
  /// Reine Funktion über die DB-Datei (keine path_provider-Abhängigkeit) →
  /// testbar mit einer Temp-Datei. Liefert true bei Erfolg.
  static Future<bool> quarantineCorruptDb(File db) async {
    try {
      if (db.existsSync()) {
        final bak = File('${db.path}.corrupt.bak');
        try {
          // Vorige Quarantäne NICHT wegwerfen, sondern eine Generation
          // zurückschieben: hat der Guard einmal einen GUTEN Save
          // fehl-quarantänt (Migrationsfehler ≠ Korruption, Tester-Fall) und
          // quarantänt später erneut, war das sonst die einzige Kopie.
          if (bak.existsSync()) {
            final prev = File('${db.path}.corrupt.prev.bak');
            if (prev.existsSync()) await prev.delete();
            await bak.rename(prev.path);
          }
        } catch (_) {/* silent */}
        // Verschieben statt kopieren-und-löschen. Vorher stand hier
        // `try { db.copy(bak) } catch (_) {}` gefolgt von `db.delete()` —
        // scheiterte die Kopie am vollen Speicher (auf dem Zielgerät der
        // Normalfall), gelang das Löschen trotzdem: der Spielstand war
        // endgültig weg, es gab keine `.corrupt.bak`, und der Recovery-Dialog
        // verwies auf eine Datei, die nie geschrieben wurde. Der Kommentar
        // „Hauptsache die kaputte DB ist gleich weg" setzte voraus, dass sie
        // wirklich kaputt ist — die Projekthistorie kennt genau den Gegenfall
        // (Migrationsfehler ≠ Korruption).
        //
        // `rename` ist atomar, braucht keinen freien Speicher und lässt die
        // Datei liegen, wenn es scheitert. Nur wenn das Verschieben auf einem
        // fremden Dateisystem nicht geht, wird kopiert — und dann auch nur
        // gelöscht, wenn die Kopie nachweislich steht.
        try {
          await db.rename(bak.path);
        } catch (_) {
          var kopiert = false;
          try {
            await db.copy(bak.path);
            kopiert = bak.existsSync() && await bak.length() > 0;
          } catch (_) {/* silent */}
          if (kopiert) await db.delete();
        }
      }
      for (final suffix in const ['-wal', '-shm', '-journal']) {
        final f = File('${db.path}$suffix');
        try {
          if (f.existsSync()) await f.delete();
        } catch (_) {/* silent */}
      }
      // Liegt die Datei noch da, ist NICHTS quarantänt worden — dann darf hier
      // auch kein Erfolg gemeldet werden. `main()` würde sonst den
      // Recovery-Hinweis zeigen („dein Spielstand war beschädigt") und beim
      // Retry-Open erneut über dieselbe Datei stolpern; richtig ist in dem
      // Fall der lesbare Fehlerscreen der zweiten Ebene.
      return !db.existsSync();
    } catch (_) {
      return false;
    }
  }

  /// Probt einen Kandidaten-Spielstand auf einer KOPIE, bevor er die aktive
  /// DB überschreibt: öffnen (das lässt Drift die komplette Migration
  /// fahren) + `PRAGMA quick_check`. Liefert null wenn alles ok, sonst eine
  /// Fehlermeldung für den Dialog.
  ///
  /// Vorher wurden nur 16 Magic-Bytes geprüft — eine abgeschnittene oder
  /// von einer neueren App-Version stammende `.fgsave` landete damit über
  /// der Produktions-DB, die Migration crashte beim nächsten Start, und der
  /// Crash-Guard quarantänte den Spielstand. Genau diese Schleife (Tester-Fall)
  /// bricht die Vorab-Probe.
  static Future<String?> validateCandidateDb(File candidate) async {
    Directory? probeDir;
    try {
      probeDir = await Directory.systemTemp.createTemp('fg_save_probe');
      final probe = File(p.join(probeDir.path, 'probe.sqlite'));
      await candidate.copy(probe.path);
      final db = AppDatabase(NativeDatabase(probe));
      try {
        // `user_version` steht als 4-Byte-Big-Endian an Offset 60 im
        // SQLite-Header — lesbar OHNE die Datei zu öffnen. Drift „downgradet"
        // nicht und wirft dabei auch nicht: eine DB aus einer neueren
        // App-Version würde stillschweigend mit fehlenden Spalten laufen.
        final header = await probe.openRead(0, 64).fold<List<int>>(
              <int>[],
              (acc, chunk) => acc..addAll(chunk),
            );
        if (header.length >= 64) {
          final fileVersion = (header[60] << 24) |
              (header[61] << 16) |
              (header[62] << 8) |
              header[63];
          if (fileVersion > db.schemaVersion) {
            return 'Diese Sicherung stammt aus einer neueren Version von '
                'Finanzgame. Bitte zuerst die App aktualisieren.';
          }
        }
        // Erste Query triggert beforeOpen/onUpgrade → wirft bei kaputter
        // Datei oder bei einer Migration, die nicht durchläuft.
        final rows = await db.customSelect('PRAGMA quick_check').get();
        final verdict = rows.isEmpty
            ? 'ok'
            : (rows.first.data.values.first?.toString() ?? 'ok');
        if (verdict.toLowerCase() != 'ok') {
          return 'Die Spielstand-Datei ist beschädigt.';
        }
      } finally {
        await db.close();
      }
      return null;
    } catch (e) {
      return 'Die Spielstand-Datei lässt sich nicht öffnen — sie ist '
          'beschädigt oder stammt aus einer neueren App-Version.';
    } finally {
      try {
        await probeDir?.delete(recursive: true);
      } catch (_) {/* silent */}
    }
  }

  /// Erkennt Format (ZIP-Bündel oder rohe SQLite) + spielt es über die
  /// aktive DB + das Foto-Verzeichnis ein. Backup der alten DB als `.bak`.
  /// **M8 (Analyse 2026-08) — die Produktions-DB wird genau einmal angefasst,
  /// ganz am Ende.**
  ///
  /// Vorher wurde `finanzgame.sqlite` sofort überschrieben, dann geprüft, dann
  /// über eine zweite Verbindung migriert und umgeschrieben — alles unter der
  /// noch offenen Verbindung der laufenden App. Schlug die Prüfung fehl, war
  /// der gute Spielstand bereits weg und musste aus dem `.bak` zurückgeholt
  /// werden; ging dabei etwas schief, war er endgültig verloren.
  ///
  /// Jetzt: entpacken, prüfen, migrieren und Foto-Pfade umschreiben passiert
  /// alles an einer **Staging-Kopie** im Temp-Verzeichnis. Erst wenn die
  /// vollständig fertig und geprüft ist, wird die Live-Verbindung geschlossen
  /// und die Datei ersetzt. Scheitert irgendetwas davor, bleibt die laufende
  /// Installation unberührt — es gibt nichts zurückzurollen.
  /// Test-Einstieg: dieselbe Logik, aber mit injizierbarem Ziel. Ohne das
  /// wäre der Ablauf nur am Gerät prüfbar (`getApplicationSupportDirectory`).
  Future<({bool success, String? error, bool dbClosed})> applySaveFileTo(
    File source, {
    required File prod,
    required Directory photoDir,
    String? backupFolderUri,
    AppDatabase? live,
  }) =>
      _applySaveFile(
        source,
        backupFolderUri: backupFolderUri,
        live: live,
        prodOverride: prod,
        photoDirOverride: photoDir,
      );

  Future<({bool success, String? error, bool dbClosed})> _applySaveFile(
    File source, {
    String? backupFolderUri,
    AppDatabase? live,
    File? prodOverride,
    Directory? photoDirOverride,
  }) async {
    if (!source.existsSync()) {
      return (success: false, error: 'Datei nicht gefunden', dbClosed: false);
    }
    final head = await readHeadBytes(source);
    if (!isZipBytes(head) && !isSqliteBytes(head)) {
      return (
        success: false,
        error: 'Keine gültige Spielstand-Datei (weder ZIP noch SQLite).',
        dbClosed: false,
      );
    }

    final prod = prodOverride ?? await _dbFile();
    final photoDir = photoDirOverride ?? await _wishPhotoDir();
    Directory? staging;
    // Wird true, sobald die Live-Verbindung zu ist. Scheitert danach noch
    // etwas, MUSS der Aufrufer einen Neustart erzwingen: jede weitere
    // Schreiboperation liefe gegen eine geschlossene Verbindung und wird von
    // den `catchError`-Handlern der Repositories still verschluckt — die App
    // sähe heil aus und würde nichts mehr speichern.
    var dbClosed = false;
    try {
      staging = await Directory.systemTemp.createTemp('fg_save_staging');
      final stagingDb = File(p.join(staging.path, _dbFileName));

      if (isZipBytes(head)) {
        // Fotos gehen direkt ins echte Verzeichnis (unkritisch: sie liegen
        // neben der DB, nicht in ihr, und ein Teil-Update davon macht keinen
        // Spielstand kaputt). Die DB landet im Staging.
        final ok = await extractBundle(
          source: source,
          dbDest: stagingDb,
          photoDir: photoDir,
        );
        if (!ok) {
          return (
            success: false,
            error: 'Spielstand-Datei beschädigt (ZIP konnte nicht gelesen '
                'werden).',
            dbClosed: false,
          );
        }
      } else {
        // Legacy: rohe SQLite-Datei (keine Fotos enthalten).
        await source.copy(stagingDb.path);
      }

      // Probe auf einer Kopie der Staging-Datei: ist sie beschädigt oder
      // stammt sie aus einer neueren App-Version, brechen wir ab — die
      // laufende Installation hat davon nichts gemerkt.
      final problem = await validateCandidateDb(stagingDb);
      if (problem != null) {
        return (success: false, error: problem, dbClosed: false);
      }

      // Migration + Foto-Remap + Backup-URI: alles auf dem Staging.
      await _migrateAndRemap(
        stagingDb,
        photoDir,
        backupFolderUri: backupFolderUri,
      );

      // Ab hier wird ersetzt. Die Reihenfolge IST der Schutz: solange die
      // Live-Verbindung offen ist, darf nichts laufen, was sich nicht
      // folgenlos abbrechen lässt.
      //
      // Vorher stand `close()` an ERSTER Stelle und danach zwei
      // Kopiervorgänge. Scheiterte einer davon — voller Speicher, auf dem
      // Zielgerät der dokumentierte Normalfall —, war die Verbindung zu, der
      // Aufrufer zeigte nur eine Fehlermeldung, und die App speicherte ab
      // diesem Moment stillschweigend nicht mehr.
      final incoming = File('${prod.path}.incoming');
      try {
        if (incoming.existsSync()) await incoming.delete();
      } catch (_) {/* silent — der copy unten würde sonst ohnehin werfen */}

      // 1. Teuerster Schritt zuerst: die neue Datei vollständig daneben
      //    legen. Braucht Platz, kann scheitern — Verbindung noch offen.
      await stagingDb.copy(incoming.path);
      // 2. Sicherung der alten Datei, ebenfalls noch mit offener Verbindung.
      if (prod.existsSync()) {
        await prod.copy('${prod.path}.bak');
      }
      // 3. Erst jetzt schließen ...
      if (live != null) {
        try {
          await live.close();
        } catch (_) {/* silent — Hauptsache sie schreibt nicht mehr */}
        dbClosed = true;
      }
      // 4. ... und tauschen. `rename` ist atomar und braucht keinen freien
      //    Speicher; das Zeitfenster für einen Fehlschlag ist damit winzig.
      try {
        await incoming.rename(prod.path);
      } catch (_) {
        // Manche Dateisysteme benennen nicht über ein bestehendes Ziel.
        // Die Sicherung aus Schritt 2 liegt vor, der Moment ohne Zieldatei
        // ist deshalb vertretbar.
        if (prod.existsSync()) await prod.delete();
        await incoming.rename(prod.path);
      }
      await _deleteDbSidecars(prod);
      return (success: true, error: null, dbClosed: dbClosed);
    } catch (e) {
      return (
        success: false,
        error: 'Spielstand konnte nicht eingespielt werden ($e).',
        dbClosed: dbClosed,
      );
    } finally {
      try {
        await staging?.delete(recursive: true);
      } catch (_) {/* silent */}
      // Halbfertige `.incoming` nicht liegen lassen: sie ist so groß wie der
      // ganze Spielstand und der nächste Versuch braucht den Platz.
      try {
        final rest = File('${prod.path}.incoming');
        if (rest.existsSync()) await rest.delete();
      } catch (_) {/* silent */}
    }
  }

  // ---------------------------------------------------------------------------
  // Öffentliche API (unverändert für Aufrufer)
  // ---------------------------------------------------------------------------

  /// Baut das ZIP-Bündel ins Temp-Verzeichnis + öffnet Share-Sheet.
  /// Liefert true bei Erfolg, false wenn keine DB existiert (Onboarding
  /// noch nicht abgeschlossen).
  Future<bool> exportToShareSheet({AppDatabase? live}) async {
    final db = await _dbFile();
    if (!db.existsSync()) return false;
    final tmpDir = await getTemporaryDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .substring(0, 19);
    final exportFile = File(
      p.join(tmpDir.path, 'finanzgame-$timestamp.$_exportExtension'),
    );
    // M7: über die Live-Verbindung schnappschussen, sonst kann der Export
    // eine halb geschriebene Datei enthalten.
    final snapshot = await consistentSnapshot(live, tmpDir);
    final bytes = await buildBundleBytes(snapshot ?? db, await _wishPhotoDir());
    try {
      if (snapshot != null && snapshot.existsSync()) await snapshot.delete();
    } catch (_) {/* silent */}
    await exportFile.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(
      [XFile(exportFile.path, mimeType: 'application/octet-stream')],
      subject: 'Finanzgame Spielstand $timestamp',
      text: 'Mein Finanzgame-Spielstand (inkl. Wunschlisten-Fotos). '
          'In der App über Einstellungen → Spielstand importieren.',
    );
    return true;
  }

  /// Diagnose: kopiert alle vorhandenen Spielstand-Artefakte (kaputte
  /// `.corrupt.bak`, aktuelle DB, externer Auto-Save) ins Temp-Verzeichnis
  /// und öffnet das Share-Sheet — damit der Nutzer sie z.B. per WhatsApp zur
  /// Analyse verschicken kann. Über Temp geteilt (statt direkt aus dem
  /// app-private Ordner), weil das share_plus-FileProvider Temp/Cache sicher
  /// abdeckt, app-support nicht überall.
  ///
  /// Liefert die Anzahl tatsächlich geteilter Dateien (0 = nichts gefunden).
  Future<int> shareDiagnostics() async {
    final tmp = await getTemporaryDirectory();
    final out = <XFile>[];
    Future<void> stage(File src, String name) async {
      try {
        if (!src.existsSync()) return;
        final dst = File(p.join(tmp.path, name));
        await src.copy(dst.path);
        out.add(XFile(dst.path, mimeType: 'application/octet-stream'));
      } catch (_) {/* einzelne Datei überspringen */}
    }

    final db = await _dbFile();
    await stage(File('${db.path}.corrupt.bak'), 'finanzgame_corrupt.fgsave');
    await stage(db, 'finanzgame_current.fgsave');
    final auto = autoSaveFile();
    if (auto != null) await stage(auto, 'finanzgame_autosave.fgsave');

    if (out.isEmpty) return 0;
    await Share.shareXFiles(
      out,
      subject: 'Finanzgame Diagnose-Dateien',
      text: 'Finanzgame Spielstand-Diagnose (kaputte Datei + aktueller Stand '
          '+ Auto-Save) zum Analysieren.',
    );
    return out.length;
  }

  /// File-Picker → spielt ausgewähltes `.fgsave` (ZIP oder Legacy-SQLite)
  /// über die aktive DB. App muss danach manuell neugestartet werden damit
  /// alle Repos die neue DB lesen.
  ///
  /// Liefert (success, error): success=false+error=null bei Abbruch,
  /// error!=null bei Validierungs-Fehler.
  Future<({bool success, String? error, bool dbClosed})> importFromFilePicker({
    AppDatabase? live,
  }) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (picked == null || picked.files.isEmpty) {
      return (success: false, error: null, dbClosed: false); // Cancelled.
    }
    final path = picked.files.single.path;
    if (path == null) {
      return (success: false, error: 'Keine Datei ausgewählt', dbClosed: false);
    }
    return _applySaveFile(File(path), live: live);
  }

  /// Spielt eine `.fgsave`-Datei von einem konkreten Pfad ein (ZIP oder
  /// Legacy-SQLite). Genutzt vom Datei-Öffnen-Intent (WhatsApp → "Öffnen"):
  /// MainActivity kopiert den content://-Stream in den Cache + reicht den
  /// Pfad hier herein. App muss danach neu gestartet werden.
  Future<({bool success, String? error, bool dbClosed})> importFromPath(
    String path, {
    AppDatabase? live,
  }) {
    return _applySaveFile(File(path), live: live);
  }

  /// Welle-8 Round 23: Pfad zur Auto-Save-Datei im öffentlichen
  /// Download-Verzeichnis. Plattform-spezifisch — auf Nicht-Android
  /// liefert null.
  File? autoSaveFile() {
    if (!Platform.isAndroid) return null;
    return File(
      p.join(_publicDownloadRoot, _autoSaveDirName, _autoSaveFileName),
    );
  }

  /// Reiner Status-Check OHNE Request.
  ///
  /// Seit die App MANAGE_EXTERNAL_STORAGE nicht mehr deklariert, kann das auf
  /// Android 11+ nur noch `false` liefern. Übrig bleibt genau ein Zweck: auf
  /// Alt-Installationen, die die Berechtigung früher einmal erteilt haben,
  /// darf der Legacy-Schreibpfad in [writeAutoSave] weiterlaufen, statt deren
  /// gewohnte Sicherung kommentarlos einzustellen. Für Neuinstallationen ist
  /// der SAF-Ordner der einzige Weg — und der braucht das hier nicht.
  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) return false;
    try {
      return (await Permission.manageExternalStorage.status).isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Fire-and-forget ZIP-Bündel.
  ///
  /// Der SAF-Ordner [safFolderUri] ist der reguläre Weg — und seit die App
  /// MANAGE_EXTERNAL_STORAGE nicht mehr deklariert, auf Android 11+ der
  /// einzige. Der Legacy-Pfad `Download/Finanzgame/` bleibt nur noch als
  /// Rückfall für Alt-Installationen stehen, die die Berechtigung früher
  /// einmal erteilt haben; dort schreibt er weiter wie gewohnt.
  ///
  /// Silent failure, wenn weder SAF-Ordner noch Alt-Berechtigung greifen —
  /// der Aufrufer feuert fire-and-forget nach jedem Schlafen.
  Future<bool> writeAutoSave({String? safFolderUri, AppDatabase? live}) async {
    File? snapshot;
    try {
      if (!Platform.isAndroid) return false;
      final db = await _dbFile();
      if (!db.existsSync()) return false;
      // M7: konsistente Momentaufnahme statt Rohkopie der laufenden DB.
      snapshot = await consistentSnapshot(live, await getTemporaryDirectory());
      final sourceDb = snapshot ?? db;
      // Bevorzugter Pfad: SAF-Ordner.
      if (safFolderUri != null && safFolderUri.isNotEmpty) {
        final bytes = await buildBundleBytes(sourceDb, await _wishPhotoDir());
        final ok = await SafBackupChannel.write(
          safFolderUri,
          _autoSaveFileName,
          bytes,
        );
        if (ok) return true;
        // SAF fehlgeschlagen (Ordner gelöscht/Recht entzogen) → Legacy
        // versuchen.
      }
      // Legacy-Fallback: NUR schreiben wenn die Berechtigung schon erteilt
      // ist. Kein `request()` — der lief hier nach jedem Schlafen und hätte
      // das Kind mitten im Spiel in die System-Einstellungen geschickt.
      if (!await hasStoragePermission()) return false;
      final dir = Directory(p.join(_publicDownloadRoot, _autoSaveDirName));
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final bytes = await buildBundleBytes(sourceDb, await _wishPhotoDir());
      // Atomar: erst in .tmp schreiben, dann über die Ziel-Datei umbenennen.
      // Wird der Prozess mitten im Schreiben gekillt (häufig direkt nach
      // einem langen Zeitsprung), bleibt der vorige gültige Auto-Save heil
      // statt auf 0 Byte gekürzt — sonst gäbe es nach Deinstall keinen
      // Restore mehr (findExternalAutoSave würde die leere Datei verwerfen).
      final out = File(p.join(dir.path, _autoSaveFileName));
      final tmp = File('${out.path}.tmp');
      await tmp.writeAsBytes(bytes, flush: true);
      await tmp.rename(out.path);
      return true;
    } catch (_) {
      return false;
    } finally {
      try {
        if (snapshot != null && snapshot.existsSync()) await snapshot.delete();
      } catch (_) {/* silent */}
    }
  }

  /// Prüft ob ein gültiger externer Auto-Save existiert (ZIP-Bündel ODER
  /// Legacy-SQLite). Permission nicht zwingend — File-API auf
  /// `/storage/emulated/0/Download/` lesbar für Apps mit Legacy-
  /// Storage-Flag auf vielen Geräten auch ohne Berechtigung.
  Future<({File file, DateTime modified})?> findExternalAutoSave() async {
    try {
      if (!Platform.isAndroid) return null;
      final f = autoSaveFile();
      if (f == null || !f.existsSync()) return null;
      final head = await readHeadBytes(f);
      if (!isZipBytes(head) && !isSqliteBytes(head)) return null;
      return (file: f, modified: f.lastModifiedSync());
    } catch (_) {
      return null;
    }
  }

  /// Spielt die externe Auto-Save-Datei über die aktuelle DB ein. App muss
  /// danach neu gestartet werden (analog manuellem Import).
  Future<bool> restoreFromAutoSave({AppDatabase? live}) async {
    try {
      final found = await findExternalAutoSave();
      if (found == null) return false;
      final res = await _applySaveFile(found.file, live: live);
      return res.success;
    } catch (_) {
      return false;
    }
  }

  /// "Alles versuchen": durchsucht mehrere bekannte Orte nach der NEUESTEN
  /// gültigen Spielstand-Datei (ZIP-Bündel ODER Legacy-SQLite) und liefert
  /// sie. Gescannte Orte:
  ///  1. die kanonische Auto-Save-Datei (`Download/Finanzgame/autosave.fgsave`),
  ///  2. alle `*.fgsave` in `Download/Finanzgame/`,
  ///  3. alle `*.fgsave` direkt in `Download/` (manuell hinkopierte Exporte
  ///     oder von WhatsApp/Drive gespeicherte Sicherungen).
  ///
  /// Pickt über alle Kandidaten den mit der jüngsten `lastModified`.
  ///
  /// Fragt die Storage-Permission NICHT an — inzwischen tut das nirgends mehr
  /// etwas: MANAGE_EXTERNAL_STORAGE ist nicht mehr deklariert. Auf Android 11+
  /// findet dieser Scan deshalb regulär nichts und der Reinstall-Fall läuft
  /// über das SAF-Ordner-Restore-Angebot (`_offerSafRestore` in main.dart).
  /// Auf Android ≤ 10 greift weiterhin das Legacy-Storage-Flag, dort findet er
  /// Alt-Sicherungen wie bisher.
  Future<({File file, DateTime modified})?> findAnyRestoreCandidate() async {
    try {
      if (!Platform.isAndroid) return null;
      final candidates = <File>[];
      final canonical = autoSaveFile();
      if (canonical != null) candidates.add(canonical);
      final dirs = <Directory>[
        Directory(p.join(_publicDownloadRoot, _autoSaveDirName)),
        Directory(_publicDownloadRoot),
      ];
      for (final dir in dirs) {
        try {
          if (!dir.existsSync()) continue;
          for (final e in dir.listSync()) {
            if (e is File &&
                e.path.toLowerCase().endsWith('.$_exportExtension')) {
              candidates.add(e);
            }
          }
        } catch (_) {/* Verzeichnis nicht lesbar → nächstes */}
      }
      ({File file, DateTime modified})? best;
      final seen = <String>{};
      for (final f in candidates) {
        if (!seen.add(f.path)) continue; // canonical kann doppelt auftauchen
        try {
          if (!f.existsSync()) continue;
          final head = await readHeadBytes(f);
          if (!isZipBytes(head) && !isSqliteBytes(head)) continue;
          final mod = f.lastModifiedSync();
          if (best == null || mod.isAfter(best.modified)) {
            best = (file: f, modified: mod);
          }
        } catch (_) {/* Datei überspringen */}
      }
      return best;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // SAF-Backup-Ordner (Drift v37): kein MANAGE_EXTERNAL_STORAGE nötig
  // ---------------------------------------------------------------------------

  /// Öffnet den System-Ordner-Picker. Liefert die persistierte Tree-URI oder
  /// null bei Abbruch. Der Aufrufer persistiert sie via
  /// `SettingsRepository.setBackupFolderUri`.
  Future<String?> pickBackupFolder() => SafBackupChannel.pickFolder();

  /// True wenn die App weiterhin Lese+Schreibrecht auf [treeUri] hat.
  Future<bool> hasBackupFolderAccess(String treeUri) =>
      SafBackupChannel.hasAccess(treeUri);

  /// Info zur `autosave.fgsave` im SAF-Ordner (modified/size) oder null.
  Future<({DateTime modified, int size})?> safBackupInfo(String treeUri) async {
    final info = await SafBackupChannel.info(treeUri, _autoSaveFileName);
    if (info == null) return null;
    return (
      modified: DateTime.fromMillisecondsSinceEpoch(info.modified),
      size: info.size,
    );
  }

  /// Liest die `autosave.fgsave` aus dem SAF-Ordner [treeUri] + spielt sie über
  /// die aktive DB ein. App muss danach neu gestartet werden. Genutzt für
  /// Restore nach Reinstall (Nutzer wählt seinen Backup-Ordner erneut).
  Future<({bool success, String? error, bool dbClosed})> restoreFromSafFolder(
    String treeUri, {
    AppDatabase? live,
  }) async {
    try {
      final bytes = await SafBackupChannel.read(treeUri, _autoSaveFileName);
      if (bytes == null) {
        return (
          success: false,
          error: 'Im gewählten Ordner liegt keine Sicherung '
              '($_autoSaveFileName).',
          dbClosed: false,
        );
      }
      final tmp = await getTemporaryDirectory();
      final f = File(p.join(tmp.path, 'saf_restore.$_exportExtension'));
      await f.writeAsBytes(bytes, flush: true);
      return _applySaveFile(f, backupFolderUri: treeUri, live: live);
    } catch (_) {
      return (
        success: false,
        error: 'Sicherung konnte nicht aus dem Ordner gelesen werden.',
        dbClosed: false,
      );
    }
  }
}
