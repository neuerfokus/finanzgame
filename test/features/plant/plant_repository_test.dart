import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/plant/plant.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/plant/plant_repository.dart';

ProviderContainer _container({Money cash = const Money.cents(2500)}) {
  final c = ProviderContainer();
  // Force the cash provider to a known starting balance.
  c.read(cashStateProvider.notifier).state = cash;
  return c;
}

void main() {
  group('PlantRepository.plant', () {
    test('creates plant, deducts cost', () {
      final c = _container();
      addTearDown(c.dispose);

      final repo = c.read(plantRepositoryProvider.notifier);
      final plant = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 5,
      );

      expect(plant.kind, PlantKind.elephantsfoot);
      expect(plant.status, PlantStatus.growing);
      expect(plant.plantedOnDayIndex, 5);
      expect(c.read(cashStateProvider), const Money.cents(2450));
    });

    test('throws on duplicate plot', () {
      final c = _container();
      addTearDown(c.dispose);

      final repo = c.read(plantRepositoryProvider.notifier);
      repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      expect(
        () => repo.plant(
          islandId: 'spar_insel',
          plotIndex: 0,
          kind: PlantKind.elephantsfoot,
          dayIndex: 1,
        ),
        throwsA(isA<PlantingError>()),
      );
    });

    test('throws when broke', () {
      final c = _container(cash: const Money.cents(10));
      addTearDown(c.dispose);

      final repo = c.read(plantRepositoryProvider.notifier);
      expect(
        () => repo.plant(
          islandId: 'spar_insel',
          plotIndex: 0,
          kind: PlantKind.elephantsfoot,
          dayIndex: 0,
        ),
        throwsA(isA<PlantingError>()),
      );
    });
  });

  group('PlantRepository.harvest', () {
    test('returns yield, credits cash, status = harvested', () {
      final c = _container();
      addTearDown(c.dispose);

      final repo = c.read(plantRepositoryProvider.notifier);
      final p = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      repo.update(p.copyWith(
        currentStage: 4,
        status: PlantStatus.ready,
      ));

      final cashBefore = c.read(cashStateProvider);
      final result = repo.harvest(p.id);

      // Spec-18: der Ertrag wird mit dem Tageswetter multipliziert. Tag 0 war
      // sonnig (× 1,1 → 57 ¢); seit der Balance-Analyse 2026-08 teilt
      // `rollWeather` ein Jahresdeck aus statt pro Tag unabhängig zu würfeln,
      // und auf Tag 0 liegt jetzt Sturm (× 0,7 → 36 ¢).
      expect(result.yield_, const Money.cents(36));
      expect(result.plant.status, PlantStatus.harvested);
      expect(c.read(cashStateProvider), cashBefore + const Money.cents(36));
    });

    test('throws on not-ready plant', () {
      final c = _container();
      addTearDown(c.dispose);

      final repo = c.read(plantRepositoryProvider.notifier);
      final p = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      expect(() => repo.harvest(p.id), throwsA(isA<PlantingError>()));
    });
  });

  group('PlantRepository.clearWithered (2026-06-04)', () {
    test('entfernt nur verdorrte, behält wachsende/reife', () async {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(plantRepositoryProvider.notifier);

      final growing = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      final ripe = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 1,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      repo.update(ripe.copyWith(status: PlantStatus.ready));
      final dead = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 2,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      repo.update(dead.copyWith(status: PlantStatus.withered));

      expect(c.read(plantRepositoryProvider).length, 3);

      final removed = await repo.clearWithered('spar_insel');

      expect(removed, 1);
      final remaining = c.read(plantRepositoryProvider);
      expect(remaining.length, 2);
      expect(
        remaining.map((p) => p.id).toSet(),
        {growing.id, ripe.id},
        reason: 'wachsende + reife bleiben, nur verdorrte weg',
      );
      expect(
        remaining.any((p) => p.status == PlantStatus.withered),
        isFalse,
      );
    });

    test('no-op + 0 wenn nichts verdorrt', () async {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(plantRepositoryProvider.notifier);
      repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );

      final removed = await repo.clearWithered('spar_insel');

      expect(removed, 0);
      expect(c.read(plantRepositoryProvider).length, 1);
    });

    test('rührt verdorrte anderer Inseln nicht an', () async {
      final c = _container();
      addTearDown(c.dispose);
      final repo = c.read(plantRepositoryProvider.notifier);

      final sparDead = repo.plant(
        islandId: 'spar_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      repo.update(sparDead.copyWith(status: PlantStatus.withered));
      final otherDead = repo.plant(
        islandId: 'andere_insel',
        plotIndex: 0,
        kind: PlantKind.elephantsfoot,
        dayIndex: 0,
      );
      repo.update(otherDead.copyWith(status: PlantStatus.withered));

      final removed = await repo.clearWithered('spar_insel');

      expect(removed, 1);
      final remaining = c.read(plantRepositoryProvider);
      expect(remaining.single.id, otherDead.id,
          reason: 'andere Insel bleibt unangetastet');
    });
  });
}
