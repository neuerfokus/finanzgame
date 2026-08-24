import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/etf/etf.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/etf_price_listener.dart';
import 'package:finanzgame/domain/sim/weather.dart';

class _FakeSource implements EtfPriceSource {
  /// [w] gilt für den abgefragten Tag; alle anderen Tage bleiben bewölkt.
  ///
  /// Balance-Analyse 2026-08: der Wetter-Beitrag zum Kurs wird über den
  /// Jahresblock auf Mittel 0 zentriert (`weatherDriftFor`) — Dauer-Sonne ist
  /// damit korrekterweise KEIN Dauer-Bullenmarkt. Eine Fake-Quelle, die jeden
  /// Tag dasselbe Wetter liefert, bekommt deshalb überall exakt 0 und kann
  /// den Effekt nicht mehr zeigen. Der Unterschied zwischen einem sonnigen
  /// und einem stürmischen EINZELTAG bleibt unverändert.
  _FakeSource({Weather w = Weather.cloudy, this.specialDay}) : weather = w {
    for (final spec in EtfCatalog.all) {
      _quotes[spec.id] = EtfQuote(
        etfId: spec.id,
        pricePerShare: spec.initialPrice,
        onDayIndex: 0,
      );
    }
  }
  final Map<String, EtfQuote> _quotes = {};
  final Weather weather;
  final int? specialDay;

  @override
  EtfQuote quoteFor(String etfId) => _quotes[etfId]!;
  @override
  Weather weatherForDay(int dayIndex) =>
      specialDay == null || dayIndex == specialDay
          ? weather
          : Weather.cloudy;
  @override
  void updateQuote(EtfQuote quote) => _quotes[quote.etfId] = quote;
}

void main() {
  group('EtfPriceListener', () {
    test('emits one update per ETF per day', () async {
      final source = _FakeSource();
      final listener = EtfPriceListener(source: source, seed: 1);
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events.length, EtfCatalog.all.length);
      expect(events.every((e) => e is EtfPriceUpdateEvent), isTrue);
    });

    test('deterministic per (seed, etfId, dayIndex)', () async {
      final a = _FakeSource();
      final b = _FakeSource();
      final la = EtfPriceListener(source: a, seed: 42);
      final lb = EtfPriceListener(source: b, seed: 42);
      final ea = await la.onDayAdvance(GameDay.fromIndex(5));
      final eb = await lb.onDayAdvance(GameDay.fromIndex(5));
      expect(ea, eb);
    });

    test('weather delta shifts return distribution', () async {
      // Sunny vs storm with identical other inputs should produce different
      // prices because weatherDelta(sunny) - weatherDelta(storm) = +0.02.
      final sunnySrc = _FakeSource(w: Weather.sunny, specialDay: 3);
      final stormSrc = _FakeSource(w: Weather.storm, specialDay: 3);
      final ls = EtfPriceListener(source: sunnySrc, seed: 7);
      final lt = EtfPriceListener(source: stormSrc, seed: 7);
      await ls.onDayAdvance(GameDay.fromIndex(3));
      await lt.onDayAdvance(GameDay.fromIndex(3));
      expect(
        sunnySrc.quoteFor('welt_korb').pricePerShare >
            stormSrc.quoteFor('welt_korb').pricePerShare,
        isTrue,
      );
    });

    test('price never goes below 1¢', () async {
      // Hammer with storm 50 times — sanity check floor.
      final src = _FakeSource(w: Weather.storm);
      final l = EtfPriceListener(source: src, seed: 999);
      for (var d = 1; d <= 50; d++) {
        await l.onDayAdvance(GameDay.fromIndex(d));
      }
      for (final spec in EtfCatalog.all) {
        expect(
          src.quoteFor(spec.id).pricePerShare >= const Money.cents(1),
          isTrue,
        );
      }
    });
  });
}
