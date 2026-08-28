import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/etf/etf.dart';
import 'package:finanzgame/domain/metal/metal.dart';
import 'package:finanzgame/features/etf/etf_repository.dart';
import 'package:finanzgame/features/metal/metal_repository.dart';

/// Gibt den anhaengigen fire-and-forget-Schreibvorgaengen Zeit.
Future<void> _flush() async {
  for (var i = 0; i < 4; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  // Die taegliche Kursaktualisierung schrieb frueher pro Anlage eine eigene
  // Zeile: sechs ETFs, vier Aktien, sieben Krypto-Stueckelungen und zehn
  // Metalle ergaben gut zwei Dutzend Einzelschreibvorgaenge pro Spieltag und
  // rund 42.000 bei einem Fuenf-Jahres-Sprung. Die Quote-Zeile haelt aber nur
  // den AKTUELLEN Kurs — die Zwischenstaende uebersprungener Tage braucht
  // niemand, die Kurshistorie liegt getrennt in `price_history`.
  //
  // Geprueft wird die Eigenschaft, nicht die Anzahl: egal wie oft und in
  // welcher Reihenfolge aktualisiert wurde, nach dem naechsten Await-Punkt
  // steht in der DB fuer JEDE Anlage der zuletzt gesetzte Kurs.
  group('Kurs-Schreibvorgaenge werden gebuendelt', () {
    test('ETF: viele Aktualisierungen, am Ende ueberall der letzte Wert',
        () async {
      final db = AppDatabase.memory();
      final c = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(() async {
        c.dispose();
        await db.close();
      });

      final repo = c.read(etfRepositoryProvider.notifier);
      for (var tag = 1; tag <= 10; tag++) {
        for (final spec in EtfCatalog.all) {
          repo.updateQuote(
            EtfQuote(
              etfId: spec.id,
              pricePerShare: Money.cents(10000 + tag),
              onDayIndex: tag,
            ),
          );
        }
      }
      await _flush();

      final zeilen = await db.etfDao.loadQuotes();
      expect(zeilen.length, EtfCatalog.all.length);
      for (final z in zeilen) {
        expect(
          z.pricePerShareCents,
          10010,
          reason: 'Der Kurs des letzten Tages, kein Zwischenstand.',
        );
        expect(z.onDayIndex, 10);
      }
    });

    test('Metall: eigener Batch-Pfad, gleiches Verhalten', () async {
      final db = AppDatabase.memory();
      final c = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(() async {
        c.dispose();
        await db.close();
      });

      final repo = c.read(metalRepositoryProvider.notifier);
      for (var tag = 1; tag <= 5; tag++) {
        for (final spec in MetalCatalog.all) {
          repo.updateQuote(
            MetalQuote(
              assetId: spec.id,
              pricePerShare: Money.cents(5000 + tag),
              onDayIndex: tag,
            ),
          );
        }
      }
      await _flush();

      final zeilen = await db.metalDao.loadQuotes();
      expect(zeilen.length, MetalCatalog.all.length);
      for (final z in zeilen) {
        expect(z.pricePerShareCents, 5005);
        expect(z.onDayIndex, 5);
      }
    });

    test('synchron direkt danach steht noch nichts in der DB', () async {
      final db = AppDatabase.memory();
      final c = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(() async {
        c.dispose();
        await db.close();
      });

      final ersteId = EtfCatalog.all.first.id;
      c.read(etfRepositoryProvider.notifier).updateQuote(
            EtfQuote(
              etfId: ersteId,
              pricePerShare: const Money.cents(12345),
              onDayIndex: 3,
            ),
          );
      // Genau hier werden die Schreibvorgaenge im Zeitsprung eingespart.
      expect(await db.etfDao.loadQuotes(), isEmpty);

      await _flush();
      final zeilen = await db.etfDao.loadQuotes();
      expect(
        zeilen.firstWhere((z) => z.etfId == ersteId).pricePerShareCents,
        12345,
      );
    });
  });
}
