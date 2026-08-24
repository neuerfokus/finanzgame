import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';

/// Regression für den „duplicate column"-Migrations-Crash (der v25→v36-Fall eines Testers):
/// `createTable` in einer Migration nutzt die AKTUELLE Tabellendefinition
/// (inkl. Spalten, die erst eine SPÄTERE `addColumn`-Migration ergänzt) →
/// springt ein Save über beide Versionen, würde der spätere `addColumn` mit
/// „duplicate column" werfen und die ganze Migration abbrechen. Der Guard
/// `_addColumnIfMissing` (über [AppDatabase.hasColumn]) verhindert das.
void main() {
  test('hasColumn erkennt vorhandene + fehlende Spalten', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await db.customStatement('CREATE TABLE probe (a INTEGER, category TEXT)');

    expect(await db.hasColumn('probe', 'a'), isTrue);
    expect(await db.hasColumn('probe', 'category'), isTrue);
    // Genau der Fall, der den Crash auslöste: Spalte existiert schon →
    // Guard MUSS sie als vorhanden melden (→ addColumn wird übersprungen).
    expect(await db.hasColumn('probe', 'fehlt_nicht_da'), isFalse);
  });

  test('hasColumn auf nicht existenter Tabelle wirft nicht / false', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    expect(await db.hasColumn('gibt_es_nicht', 'x'), isFalse);
  });

  test('frische DB öffnet auf aktueller schemaVersion ohne Migration', () async {
    // Sanity: onCreate-Pfad legt alle Tabellen an, keine onUpgrade-Kollision.
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final v = (await db.customSelect('PRAGMA user_version').getSingle())
        .read<int>('user_version');
    expect(v, db.schemaVersion);
  });

  // Kill-Retry: Drift wrappt onUpgrade NICHT in eine Transaktion und setzt
  // user_version erst NACH Erfolg. Wird die App mitten im Update-Sprung
  // gekillt, läuft beim nächsten Start die GANZE Kette erneut über eine DB,
  // die die Spalten teilweise (hier: vollständig) schon hat. Ohne Guard an
  // JEDEM addColumn wirft das „duplicate column" → Crash-Loop → der
  // Crash-Guard quarantänt einen intakten Save (Tester-Lektion).
  test('onUpgrade ist idempotent: Kette über bereits migrierte DB wirft nicht',
      () async {
    final dir = await Directory.systemTemp.createTemp('fg_migration_retry');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/retry.sqlite');

    // 1. Volles aktuelles Schema anlegen (alle Spalten vorhanden).
    final fresh = AppDatabase(NativeDatabase(file));
    await fresh.customSelect('SELECT 1').get();
    // 2. user_version künstlich weit zurück — simuliert den abgebrochenen
    //    Lauf, bei dem die DDL-Schritte committet, die Version aber nicht.
    await fresh.customStatement('PRAGMA user_version = 2');
    await fresh.close();

    // 3. Neu öffnen → onUpgrade läuft von 2 bis zur aktuellen Version über
    //    Tabellen, die alle Spalten längst haben.
    final retried = AppDatabase(NativeDatabase(file));
    addTearDown(retried.close);
    await retried.customSelect('SELECT 1').get();

    final v = (await retried.customSelect('PRAGMA user_version').getSingle())
        .read<int>('user_version');
    expect(v, retried.schemaVersion,
        reason: 'Migration muss durchlaufen und die Version setzen');
  });
}
