import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/metal/metal.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/metal_price_listener.dart';

class _FakeSource implements MetalPriceSource {
  _FakeSource() {
    for (final spec in MetalCatalog.all) {
      _quotes[spec.id] = MetalQuote(
        assetId: spec.id,
        pricePerShare: spec.basePrice,
        onDayIndex: 0,
      );
    }
  }
  final Map<String, MetalQuote> _quotes = {};

  @override
  MetalQuote quoteFor(String assetId) => _quotes[assetId]!;

  @override
  void updateQuote(MetalQuote quote) => _quotes[quote.assetId] = quote;
}

void main() {
  group('MetalPriceListener', () {
    test('emits one metalPriceUpdate per metal per day', () async {
      final src = _FakeSource();
      final listener = MetalPriceListener(
        source: src,
        seed: 1,
        inflationEventsToday: const [],
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events.length, MetalCatalog.all.length);
      expect(events.every((e) => e is MetalPriceUpdateEvent), isTrue);
    });

    test('deterministic per (seed, assetId, dayIndex)', () async {
      final a = _FakeSource();
      final b = _FakeSource();
      final la = MetalPriceListener(
        source: a,
        seed: 99,
        inflationEventsToday: const [],
      );
      final lb = MetalPriceListener(
        source: b,
        seed: 99,
        inflationEventsToday: const [],
      );
      expect(
        await la.onDayAdvance(GameDay.fromIndex(3)),
        await lb.onDayAdvance(GameDay.fromIndex(3)),
      );
    });

    test('positive inflation pulls Silber up more than Gold', () async {
      // Spec-balance-didaktik A.2: neue Ziele Gold 4 %/J < Silber 5 %/J,
      // factor Gold 0.047 < Silber 0.058.
      const inflation = InflationEvent(rate: 0.10, affectedItemIds: []);
      final src = _FakeSource();
      final listener = MetalPriceListener(
        source: src,
        seed: 1,
        inflationEventsToday: const [inflation],
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      final byId = {
        for (final e in events) (e as MetalPriceUpdateEvent).assetId: e,
      };
      final gold = byId['metal_gold']!;
      final silver = byId['metal_silver']!;
      expect(
        silver.deltaPct > gold.deltaPct,
        isTrue,
        reason: 'silver=${silver.deltaPct} gold=${gold.deltaPct}',
      );
    });

    test('zero inflation leaves return inside ±dailyVolatility', () async {
      final src = _FakeSource();
      final listener = MetalPriceListener(
        source: src,
        seed: 2,
        inflationEventsToday: const [],
        // Ohne Events greift sonst die Basis-Inflation (Default) — hier
        // wollen wir explizit den reinen Rausch-Anteil messen.
        baseInflationRate: 0,
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      for (final raw in events) {
        final e = raw as MetalPriceUpdateEvent;
        final spec = MetalCatalog.byId(e.assetId);
        expect(
          e.deltaPct.abs() <= spec.dailyVolatility + 1e-9,
          isTrue,
          reason: '${e.assetId} delta=${e.deltaPct}',
        );
      }
    });

    test('price floors at 1¢', () async {
      final src = _FakeSource();
      // Big negative inflation forces the price down hard.
      const inflation = InflationEvent(rate: -0.50, affectedItemIds: []);
      final listener = MetalPriceListener(
        source: src,
        seed: 3,
        inflationEventsToday: const [inflation],
      );
      for (var d = 1; d <= 50; d++) {
        await listener.onDayAdvance(GameDay.fromIndex(d));
      }
      for (final spec in MetalCatalog.all) {
        expect(
          src.quoteFor(spec.id).pricePerShare >= const Money.cents(1),
          isTrue,
        );
      }
    });
  });
}
