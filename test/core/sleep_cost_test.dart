import 'package:finanzgame/core/game_balance.dart';
import 'package:finanzgame/core/game_clock.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/day_event_listener.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records calls — used to verify the Hunger-Pfad skips Plant + Allowance.
class _Recorder implements DayEventListener {
  final List<int> calls = [];

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    calls.add(newDay.dayIndex);
    return const [];
  }
}

ProviderContainer _bareContainer() {
  return ProviderContainer(
    overrides: [
      allowanceListenersProvider.overrideWithValue(const []),
      interestListenersProvider.overrideWithValue(const []),
      plantListenersProvider.overrideWithValue(const []),
      inflationListenersProvider.overrideWithValue(const []),
      weatherListenersProvider.overrideWithValue(const []),
      etfPriceListenersProvider.overrideWithValue(const []),
      stockPriceListenersProvider.overrideWithValue(const []),
      marketPhaseListenersProvider.overrideWithValue(const []),
      birthdayListenersProvider.overrideWithValue(const []),
      temptationListenersProvider.overrideWithValue(const []),
    ],
  );
}

void main() {
  group('Spec-20: sleep cost', () {
    test('advanceDay deducts 10ct from cash', () async {
      final c = _bareContainer();
      addTearDown(c.dispose);

      final cashBefore = c.read(cashStateProvider);
      await c.read(gameClockProvider.notifier).advanceDay();
      final cashAfter = c.read(cashStateProvider);

      expect(
        cashBefore - cashAfter,
        const Money.cents(GameBalance.sleepCostCents),
      );
    });

    test('advanceDay emits SleepCostEvent (hunger=false) when cash >= cost',
        () async {
      final c = _bareContainer();
      addTearDown(c.dispose);

      final summary = await c.read(gameClockProvider.notifier).advanceDay();

      final sleepCosts = summary.events.whereType<SleepCostEvent>().toList();
      expect(sleepCosts, hasLength(1));
      expect(sleepCosts.single.hunger, isFalse);
      expect(sleepCosts.single.amount,
          const Money.cents(GameBalance.sleepCostCents));
    });

    test('SleepCostEvent appears first in events list', () async {
      final c = _bareContainer();
      addTearDown(c.dispose);
      final summary = await c.read(gameClockProvider.notifier).advanceDay();
      expect(summary.events.first, isA<SleepCostEvent>());
    });

    test('cash=0 → Hunger event, Plant + Einkommen weg, Kosten laufen weiter',
        () async {
      final allowanceRec = _Recorder();
      final plantRec = _Recorder();
      final interestRec = _Recorder();

      final c = ProviderContainer(
        overrides: [
          allowanceListenersProvider.overrideWithValue([allowanceRec]),
          interestListenersProvider.overrideWithValue([interestRec]),
          plantListenersProvider.overrideWithValue([plantRec]),
          inflationListenersProvider.overrideWithValue(const []),
          weatherListenersProvider.overrideWithValue(const []),
          etfPriceListenersProvider.overrideWithValue(const []),
          stockPriceListenersProvider.overrideWithValue(const []),
          marketPhaseListenersProvider.overrideWithValue(const []),
          birthdayListenersProvider.overrideWithValue(const []),
          temptationListenersProvider.overrideWithValue(const []),
        ],
      );
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).state = Money.zero;

      final summary = await c.read(gameClockProvider.notifier).advanceDay();

      final sleepCost = summary.events.whereType<SleepCostEvent>().single;
      expect(sleepCost.hunger, isTrue);
      expect(sleepCost.amount, Money.zero);

      // Hunger-Pfad: nur der AllowanceListener (Taschengeld/Lohn) entfällt +
      // Plant; Interest läuft weiter. Die KOSTEN-Listener derselben Stage
      // (Insurance/LivingCost/Vorsorge/Sparplan/Hypothek — hier durch den
      // Recorder vertreten) laufen ebenfalls weiter, sonst wäre pleite sein
      // profitabel gewesen.
      expect(allowanceRec.calls, hasLength(1));
      expect(summary.events.whereType<AllowanceEvent>(), isEmpty);
      expect(plantRec.calls, isEmpty);
      expect(interestRec.calls, hasLength(1));
      // Cash stays at zero (no negative).
      expect(c.read(cashStateProvider), Money.zero);
    });

    test('Hunger-Pfad does not produce harvest events', () async {
      // No plant listener output means no PlantGrowthEvent / PlantReadyEvent.
      // Verified by checking the summary.events doesn't contain any of those.
      final c = ProviderContainer(
        overrides: [
          allowanceListenersProvider.overrideWithValue(const []),
          interestListenersProvider.overrideWithValue(const []),
          plantListenersProvider.overrideWithValue(const []),
          inflationListenersProvider.overrideWithValue(const []),
          weatherListenersProvider.overrideWithValue(const []),
          etfPriceListenersProvider.overrideWithValue(const []),
          stockPriceListenersProvider.overrideWithValue(const []),
          marketPhaseListenersProvider.overrideWithValue(const []),
          birthdayListenersProvider.overrideWithValue(const []),
          temptationListenersProvider.overrideWithValue(const []),
        ],
      );
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).state = Money.zero;

      final summary = await c.read(gameClockProvider.notifier).advanceDay();
      expect(summary.events.whereType<HarvestEvent>(), isEmpty);
    });
  });

  group('Spec-20: fastForward', () {
    test('fastForward(7) calls advanceDay 7 times', () async {
      final c = _bareContainer();
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).state = const Money.cents(100000);

      final dayBefore = c.read(gameClockProvider).dayIndex;
      final result = await c.read(gameClockProvider.notifier).fastForward(7);

      expect(result.summaries, hasLength(7));
      expect(result.totalDays, 7);
      expect(c.read(gameClockProvider).dayIndex, dayBefore + 7);
    });

    test('spec-33: fastForward skips per-day sleep cost', () async {
      final c = _bareContainer();
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).state = const Money.cents(100000);

      final cashBefore = c.read(cashStateProvider);
      final result = await c.read(gameClockProvider.notifier).fastForward(7);
      final cashAfter = c.read(cashStateProvider);

      // B3a: Inflation auf Cash drained ein paar Cent pro Tag — Sleep-
      // Cost (70¢ über 7 Tage) muss aber weiterhin geskippt sein.
      final drain = (cashBefore - cashAfter).cents;
      expect(drain, lessThan(70),
          reason: 'Sleep-Cost darf in FastForward nicht greifen.');
      expect(result.cashDeltaCents, equals(-drain));
    });

    test('fastForward(30) aggregates monthly allowance (spec-32)', () async {
      // spec-32 monthly cadence: only one allowance hit on day 30.
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).state = const Money.cents(100000);

      final result = await c.read(gameClockProvider.notifier).fastForward(30);

      expect(result.allowanceTotalCents, 8000);
    });

    test('fastForward summary tracks crash count across days', () async {
      final c = _bareContainer();
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).state = const Money.cents(100000);

      final result = await c.read(gameClockProvider.notifier).fastForward(5);
      // No crash listener installed → crashCount must be 0.
      expect(result.crashCount, 0);
    });
  });
}
