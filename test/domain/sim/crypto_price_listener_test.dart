import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/crypto/crypto.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/crypto_price_listener.dart';

class _FakeSource implements CryptoPriceSource {
  _FakeSource() {
    for (final spec in CryptoCatalog.all) {
      _quotes[spec.id] = CryptoQuote(
        assetId: spec.id,
        pricePerShare: spec.basePrice,
        onDayIndex: 0,
      );
    }
  }
  final Map<String, CryptoQuote> _quotes = {};

  @override
  CryptoQuote quoteFor(String assetId) => _quotes[assetId]!;

  @override
  void updateQuote(CryptoQuote quote) => _quotes[quote.assetId] = quote;
}

void main() {
  group('CryptoPriceListener', () {
    test('emits one cryptoPriceUpdate per coin per day', () async {
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 1,
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(1));
      expect(events.length, CryptoCatalog.all.length);
      expect(events.every((e) => e is CryptoPriceUpdateEvent), isTrue);
    });

    test('deterministic per (seed, assetId, dayIndex)', () async {
      final a = _FakeSource();
      final b = _FakeSource();
      final la = CryptoPriceListener(
        source: a,
        seed: 42,
      );
      final lb = CryptoPriceListener(
        source: b,
        seed: 42,
      );
      final ea = await la.onDayAdvance(GameDay.fromIndex(5));
      final eb = await lb.onDayAdvance(GameDay.fromIndex(5));
      expect(ea, eb);
    });

    test('swing stays within ±volatility on normal days', () async {
      // Run a bunch of days and check no single roll exceeds volatility.
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 7,
      );
      for (var d = 1; d <= 30; d++) {
        // Reset prices so we measure the raw roll, not compound drift.
        for (final spec in CryptoCatalog.all) {
          src._quotes[spec.id] = CryptoQuote(
            assetId: spec.id,
            pricePerShare: spec.basePrice,
            onDayIndex: d - 1,
          );
        }
        final events = await listener.onDayAdvance(GameDay.fromIndex(d));
        for (final raw in events) {
          final e = raw as CryptoPriceUpdateEvent;
          final spec = CryptoCatalog.byId(e.assetId);
          expect(
            e.deltaPct.abs() <= spec.volatility + 1e-9,
            isTrue,
            reason: '${e.assetId} day=$d delta=${e.deltaPct}',
          );
        }
      }
    });

    test('crash day stacks an extra 50–80% drop — nur bei Casino-Coins',
        () async {
      // Balance-Analyse 2026-08: Bitcoin bekam den Extraschlag ZUSÄTZLICH zum
      // Drawdown der Krypto-Marktphase (30–60 % über 10 Tage). Zusammen rund
      // −80 % pro Crash bei 1,5 Crashes im Jahr — der Kurs klebte dauerhaft am
      // unteren Rand des Reseed-Bandes statt langfristig zu steigen. Der
      // Extraschlag stammt aus der Zeit vor dem Phasen-System; für Bitcoin ist
      // er jetzt raus, die Marktphase allein modelliert den Crash.
      //
      // Der Casino-Coin behält ihn: er zieht jeden Tag neu um eine FESTE
      // Basis, kompoundiert also nicht und kann sich nicht „nie erholen".
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 99,
        crashToday: true,
      );
      final events = await listener.onDayAdvance(GameDay.fromIndex(5));
      var casinoSeen = 0;
      for (final raw in events) {
        final e = raw as CryptoPriceUpdateEvent;
        final spec = CryptoCatalog.byId(e.assetId);
        if (spec.groupId == 'bitcoin') {
          // Ohne Marktphase bleibt an einem Crash-Tag der normale Tageswurf.
          expect(
            e.deltaPct > -0.40,
            isTrue,
            reason: 'BTC darf den Extraschlag nicht mehr bekommen: '
                '${e.deltaPct}',
          );
          continue;
        }
        casinoSeen++;
        expect(
          e.deltaPct < -0.40,
          isTrue,
          reason: 'crash should hit ${e.assetId} hard; got ${e.deltaPct}',
        );
        // Floor: even at maximum negative swing + 0.80 drop:
        // (1 - 0.15) * 0.20 - 1 = -0.83.
        expect(
          e.deltaPct > -0.90,
          isTrue,
          reason: '${e.assetId} drop too extreme: ${e.deltaPct}',
        );
      }
      expect(casinoSeen, greaterThan(0));
    });

    test('Round 27: BTC-Stückelungen bleiben exakte Vielfache (kein Desync)',
        () async {
      // Regression: vorher bekamen Member-Stückelungen den Tages-Return
      // doppelt → 1 BTC ≠ mikro×10000 nach einigen Tagen.
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 123,
      );
      for (var d = 1; d <= 50; d++) {
        await listener.onDayAdvance(GameDay.fromIndex(d));
      }
      final mikro = src.quoteFor('crypto_bitcoin_mikro').pricePerShare.cents;
      expect(src.quoteFor('crypto_bitcoin').pricePerShare.cents, mikro * 10);
      expect(
          src.quoteFor('crypto_bitcoin_gross').pricePerShare.cents, mikro * 100);
      expect(src.quoteFor('crypto_bitcoin_zehntel').pricePerShare.cents,
          mikro * 1000);
      expect(src.quoteFor('crypto_bitcoin_ganz').pricePerShare.cents,
          mikro * 10000);
    });

    // Cent-Exploit-Regression: Der Casino-Coin lief als multiplikativer
    // Random-Walk auf den Vortag — E[ln(1+U(−0,7;+0,7))] ≈ −9,7 %/Tag → der
    // Kurs kollabierte in ~100-150 Tagen auf den 1-¢-Floor. Dort kaufte man
    // für Centbeträge Zehntausende Anteile, und der Reseed beim nächsten
    // App-Start (Kurs außerhalb des Bands → zurück auf 150 €) machte daraus
    // Millionen. Jetzt: unabhängiger Draw um die feste Basis, im Band.
    test('Casino-Kurs bleibt über 2 Jahre im Preisband (kein Cent-Kollaps)',
        () async {
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 4711,
      );
      const spec = CryptoCatalog.kryptoCasino;
      final lo = CryptoPriceBand.casino.loCentsFor(spec.basePrice.cents);
      final hi = CryptoPriceBand.casino.hiCentsFor(spec.basePrice.cents);
      for (var d = 1; d <= 730; d++) {
        await listener.onDayAdvance(GameDay.fromIndex(d));
        final cents = src.quoteFor(spec.id).pricePerShare.cents;
        expect(cents, inInclusiveRange(lo, hi),
            reason: 'Tag $d: $cents ¢ außerhalb [$lo, $hi]');
      }
    });

    test('BTC-Leader bleibt auch im Dauer-Crash im Band', () async {
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 7,
        crashToday: true,
      );
      const leader = CryptoCatalog.bitcoinMikro;
      final lo = CryptoPriceBand.bitcoin.loCentsFor(leader.basePrice.cents);
      for (var d = 1; d <= 200; d++) {
        await listener.onDayAdvance(GameDay.fromIndex(d));
      }
      // Ohne Clamp wäre der Kurs längst im Cent-Bereich (und damit unter der
      // Reseed-Untergrenze → beim nächsten Start Gratis-Vermögen).
      expect(src.quoteFor(leader.id).pricePerShare.cents,
          greaterThanOrEqualTo(lo));
    });

    test('Listener-Band liegt in JEDEM Reseed-Band (Exploit-Invariante)', () {
      // Der Reseed im CryptoRepository nutzt dieselben Konstanten — wären
      // Listener-Spanne und Reseed-Band verschieden, könnte ein normal
      // gedrifteter Kurs beim App-Start auf die Basis zurückgesetzt werden
      // und aus Cent-Käufen ein Vermögen machen.
      for (final spec in CryptoCatalog.all) {
        final band = CryptoPriceBand.forGroup(spec.groupId);
        expect(band.lo, greaterThan(0.0));
        expect(band.hi, greaterThan(band.lo));
        expect(band.loCentsFor(spec.basePrice.cents), greaterThan(1),
            reason: '${spec.id}: Untergrenze darf nie im Cent-Bereich liegen');
      }
    });

    test('price floors at 1¢ after long crash streak', () async {
      final src = _FakeSource();
      final listener = CryptoPriceListener(
        source: src,
        seed: 13,
        crashToday: true,
      );
      for (var d = 1; d <= 100; d++) {
        await listener.onDayAdvance(GameDay.fromIndex(d));
      }
      for (final spec in CryptoCatalog.all) {
        expect(
          src.quoteFor(spec.id).pricePerShare >= const Money.cents(1),
          isTrue,
        );
      }
    });
  });
}
