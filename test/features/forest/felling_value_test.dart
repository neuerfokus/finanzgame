import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/forest/tree.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/forest/tree_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fällen zahlt den Verkehrswert statt Schrottwert.
///
/// **Der Fehler (User-Fund 2026-08):** `fellTree` zahlte nur
/// `30 × Tagesertrag` — eine Eiche für 500 € brachte 2,40 €, eine Birke für
/// 50 € brachte 0,30 €. Das Kapital war weg, und weil Bäume im Vermögen zum
/// Anschaffungswert zählen, sackte das Vermögen beim Fällen um fast den
/// vollen Kaufpreis ab. Der Wald war eine Einbahnstraße.
void main() {
  group('Verkehrswert beim Fällen', () {
    test('ein ausgewachsener Baum bringt ungefähr sein Geld zurück', () {
      for (final spec in TreeCatalog.all) {
        final tree = PlantedTree(
          id: 't',
          kind: spec.kind,
          plantedOnDayIndex: 0,
        );
        final value = tree.fellingValue(spec.maturityDays);
        // Anschaffungswert + ein Monat Holz.
        expect(value.cents, spec.cost.cents + spec.dailyYield.cents * 30);
        // Und damit um Größenordnungen über dem alten Schrottwert.
        expect(value.cents, greaterThan(spec.dailyYield.cents * 30 * 10));
      }
    });

    test('halb gewachsen bringt etwa die Hälfte', () {
      const spec = TreeCatalog.eiche;
      const tree = PlantedTree(
        id: 't',
        kind: TreeKind.eiche,
        plantedOnDayIndex: 0,
      );
      final value = tree.fellingValue(spec.maturityDays ~/ 2);
      expect(value.cents,
          closeTo(spec.cost.cents / 2 + spec.dailyYield.cents * 30, 100));
    });

    test('frisch gepflanzt bringt fast nichts zurück — zu früh fällen tut weh',
        () {
      const tree = PlantedTree(
        id: 't',
        kind: TreeKind.eiche,
        plantedOnDayIndex: 0,
      );
      // Geduld ist weiterhin die Lektion: wer sofort fällt, verliert echtes
      // Geld — nur eben nicht mehr alles.
      expect(tree.fellingValue(0).cents, TreeCatalog.eiche.dailyYield.cents * 30);
      expect(tree.growthRatio(0), 0.0);
      expect(tree.growthRatio(TreeCatalog.eiche.maturityDays * 2), 1.0);
    });

    test('Fällen zahlt aufs Konto und entfernt den Baum', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(const DbSnapshot()),
      ]);
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(100000));
      final repo = c.read(treeRepositoryProvider.notifier);

      repo.plant(TreeKind.birke, 0);
      final tree = c.read(treeRepositoryProvider).single;
      final cashAfterPlant = c.read(cashStateProvider).cents;

      const mature = 365; // Birke reif nach einem Spieljahr
      final payout = repo.fellTree(tree.id, mature);

      expect(payout.cents,
          TreeCatalog.birke.cost.cents + TreeCatalog.birke.dailyYield.cents * 30);
      expect(c.read(cashStateProvider).cents, cashAfterPlant + payout.cents);
      expect(c.read(treeRepositoryProvider), isEmpty);
      // Unterm Strich: ein reifer Baum ist kein Verlustgeschäft mehr.
      expect(payout.cents, greaterThanOrEqualTo(TreeCatalog.birke.cost.cents));
    });

    test('unreife Bäume lassen sich weiterhin nicht fällen', () {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final c = ProviderContainer(overrides: [
        appDatabaseProvider.overrideWithValue(db),
        dbSnapshotProvider.overrideWithValue(const DbSnapshot()),
      ]);
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(100000));
      final repo = c.read(treeRepositoryProvider.notifier);
      repo.plant(TreeKind.eiche, 0);
      final tree = c.read(treeRepositoryProvider).single;

      expect(() => repo.fellTree(tree.id, 10), throwsA(isA<TreeError>()));
    });
  });
}
