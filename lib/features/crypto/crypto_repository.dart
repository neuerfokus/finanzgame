import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/crypto/crypto.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/listeners/crypto_price_listener.dart';
import '../../core/game_clock.dart';
import '../economy/cash_state.dart';
import '../xp/xp_repository.dart';

part 'crypto_repository.g.dart';

class CryptoError implements Exception {
  const CryptoError(this.message);
  final String message;
  @override
  String toString() => 'CryptoError: $message';
}

class CryptoPortfolio {
  const CryptoPortfolio({required this.holdings, required this.quotes});
  final List<CryptoHolding> holdings;
  final Map<String, CryptoQuote> quotes;

  CryptoPortfolio copyWith({
    List<CryptoHolding>? holdings,
    Map<String, CryptoQuote>? quotes,
  }) =>
      CryptoPortfolio(
        holdings: holdings ?? this.holdings,
        quotes: quotes ?? this.quotes,
      );
}

/// Persisted crypto portfolio + quotes. Seeds from [CryptoCatalog] when DB
/// is empty. Spec-22.
@Riverpod(keepAlive: true)
class CryptoRepository extends _$CryptoRepository
    implements CryptoPriceSource {
  @override
  CryptoPortfolio build() {
    final snap = ref.watch(dbSnapshotProvider);

    final quotes = <String, CryptoQuote>{
      for (final s in CryptoCatalog.all)
        s.id: CryptoQuote(
          assetId: s.id,
          pricePerShare: s.basePrice,
          onDayIndex: 0,
        ),
    };
    for (final row in snap.cryptoQuotes) {
      // Welle-8: Force-reseed nur bei extrem unplausiblen saved-Quotes
      // (Catalog-Korrektur). Round 27: Bitcoin-Gruppe bekommt ein WEITES
      // Band [0.25×, 4×], damit der realistische Lebenszeit-Korridor von
      // ~16.000 € bis ~250.000 € pro BTC (Year-Regime ¼ ×0,25 · ¼ ×2 ·
      // ½ flat über 5-10 Jahre) über App-Neustarts ERHALTEN bleibt. Ein
      // enges Band würde diesen Drift bei jedem Start zurücksetzen. Der
      // alte 90k-Ära-Müll wird stattdessen EINMALIG per Drift-Migration
      // v28 auf die 63k-Basis gesetzt. Andere Coins (Casino) behalten das
      // enge [0.4×, 1.4×].
      final spec = CryptoCatalog.byId(row.assetId);
      final base = spec.basePrice.cents;
      final saved = row.pricePerShareCents;
      // Band kommt aus CryptoPriceBand — dieselbe Quelle, gegen die der
      // Listener täglich clampt. Damit kann ein normal gedrifteter Kurs
      // hier NIE mehr aus dem Band fallen (das war der Reseed-Exploit:
      // Kurs unter lo → Reseed auf base → Cent-Käufe wurden Millionen).
      final band = CryptoPriceBand.forGroup(spec.groupId);
      final lo = band.loCentsFor(base);
      final hi = band.hiCentsFor(base);
      final useSaved = saved >= lo && saved <= hi;
      quotes[row.assetId] = CryptoQuote(
        assetId: row.assetId,
        pricePerShare: Money.cents(useSaved ? saved : base),
        onDayIndex: row.onDayIndex,
      );
    }

    // Rückwirkende Normalisierung des Cent-Krypto-Exploits (Muster wie im
    // EtfRepository): Der Casino-Coin fiel per Random-Walk auf den 1-¢-Floor;
    // wer dort für Centbeträge Zehntausende Anteile kaufte, wurde beim
    // nächsten App-Start durch das Reseed zum Millionär. Holdings mit einem
    // Ø-Kaufpreis unter 20 % der Basis (legitim nie erreichbar — das
    // Preisband endet bei 25-30 %) werden auf den TATSÄCHLICH ausgegebenen
    // Betrag zum echten heutigen Kurs zurückgerechnet: Windfall weg, reales
    // Investment bleibt, P&L neutral, idempotent.
    final holdings = <CryptoHolding>[];
    for (final r in snap.cryptoHoldings) {
      final avgCents = r.averageBuyPriceCents;
      final spec = CryptoCatalog.byId(r.assetId);
      final exploitFloor = (spec.basePrice.cents * 0.2).round();
      final currentCents =
          quotes[r.assetId]?.pricePerShare.cents ?? spec.basePrice.cents;
      if (avgCents < exploitFloor && r.shares > 0 && currentCents > 0) {
        final costBasisCents = r.shares * avgCents;
        final correctedShares =
            (costBasisCents / currentCents).round().clamp(0, 1 << 30);
        holdings.add(CryptoHolding(
          assetId: r.assetId,
          shares: correctedShares,
          averageBuyPrice: Money.cents(currentCents),
        ));
      } else {
        holdings.add(CryptoHolding(
          assetId: r.assetId,
          shares: r.shares,
          averageBuyPrice: Money.cents(avgCents),
        ));
      }
    }

    return CryptoPortfolio(holdings: holdings, quotes: quotes);
  }

  CryptoHolding? holdingFor(String assetId) {
    for (final h in state.holdings) {
      if (h.assetId == assetId) return h;
    }
    return null;
  }

  @override
  CryptoQuote quoteFor(String assetId) =>
      state.quotes[assetId] ??
      CryptoQuote(
        assetId: assetId,
        pricePerShare: CryptoCatalog.byId(assetId).basePrice,
        onDayIndex: 0,
      );

  Money currentPrice(String assetId) => quoteFor(assetId).pricePerShare;

  @override
  void updateQuote(CryptoQuote quote) {
    state = state.copyWith(quotes: {...state.quotes, quote.assetId: quote});
    _persistQuote(quote);
  }

  /// B6 Zeitsprung-Crisis: schockt alle gehaltenen Quotes um [dropPct].
  ///
  /// Boden = untere Schranke des [CryptoPriceBand] der Gruppe, NICHT 1 ¢.
  /// Analyse-Runde 2026-08: der Tages-Listener clampt längst ins Band (das
  /// war der Fix für den Casino-Cent-Exploit), der Krisen-Wurf des
  /// Zeitsprungs konnte den Kurs aber weiterhin darunter drücken — also
  /// genau in die Zone, aus der der Reseed beim nächsten App-Start auf die
  /// Basis zurückspringt.
  List<String> applyCrash(double dropPct) {
    final factor = 1.0 - dropPct;
    final newQuotes = <String, CryptoQuote>{};
    for (final entry in state.quotes.entries) {
      final q = entry.value;
      final spec = CryptoCatalog.byId(q.assetId);
      final floor = CryptoPriceBand.forGroup(spec.groupId)
          .loCentsFor(spec.basePrice.cents);
      newQuotes[entry.key] = CryptoQuote(
        assetId: q.assetId,
        pricePerShare: Money.cents(
          (q.pricePerShare.cents * factor).round().clamp(floor, 1 << 30),
        ),
        onDayIndex: q.onDayIndex,
      );
    }
    state = state.copyWith(quotes: newQuotes);
    _persistAllQuotes();
    return newQuotes.keys.toList();
  }

  void buy({required String assetId, required int shares}) {
    if (shares <= 0) throw const CryptoError('shares must be positive');
    final price = quoteFor(assetId).pricePerShare;
    final total = price * shares;
    final cashNotifier = ref.read(cashStateProvider.notifier);
    if (!cashNotifier.spend(total)) {
      throw const CryptoError('insufficient cash');
    }
    final existing = holdingFor(assetId);
    final CryptoHolding updated;
    if (existing == null) {
      updated = CryptoHolding(
        assetId: assetId,
        shares: shares,
        averageBuyPrice: price,
      );
    } else {
      final newShares = existing.shares + shares;
      // L14 (Analyse 2026-08): war `~/` (Abschneiden) — der Ø-Einstandskurs
      // fiel dadurch um bis zu 1 ¢ zu niedrig aus, die angezeigte Rendite also
      // zu hoch und die Panik-Verkauf-Warnung sprang minimal zu spät an. Kein
      // Cash-Effekt (verkauft wird zum Live-Kurs), aber in einer App, die
      // Rendite lesen lehrt, sollte die Zahl stimmen. Jetzt kaufmännisch
      // gerundet.
      final newAvgCents = (((existing.averageBuyPrice.cents * existing.shares) +
                  (price.cents * shares)) /
              newShares)
          .round();
      updated = existing.copyWith(
        shares: newShares,
        averageBuyPrice: Money.cents(newAvgCents),
      );
    }
    _putHolding(updated);
    // Spec-22: re-use stock-tier XP rewards (+5 / +1).
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.cryptoBought);
    ref.read(gameClockProvider.notifier).evaluateAchievementsNow();
  }

  void sell({required String assetId, required int shares}) {
    if (shares <= 0) throw const CryptoError('shares must be positive');
    final existing = holdingFor(assetId);
    if (existing == null || existing.shares < shares) {
      throw const CryptoError('not enough shares');
    }
    final price = quoteFor(assetId).pricePerShare;
    ref.read(cashStateProvider.notifier).earn(price * shares);

    final remaining = existing.shares - shares;
    if (remaining == 0) {
      state = state.copyWith(
        holdings: state.holdings.where((h) => h.assetId != assetId).toList(),
      );
      _deleteHolding(assetId);
    } else {
      _putHolding(existing.copyWith(shares: remaining));
    }
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.cryptoSold);
  }

  void _putHolding(CryptoHolding h) {
    final list = [
      for (final existing in state.holdings)
        if (existing.assetId != h.assetId) existing,
      h,
    ];
    state = state.copyWith(holdings: list);
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.cryptoDao
          .upsertHolding(CryptoHoldingRow(
            assetId: h.assetId,
            shares: h.shares,
            averageBuyPriceCents: h.averageBuyPrice.cents,
          ))
          .catchError((Object _) {}),
    );
  }

  void _deleteHolding(String assetId) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.cryptoDao.deleteHolding(assetId).catchError((Object _) {}));
  }

  /// Sammelt die Kurs-Schreibvorgaenge zu EINEM Batch.
  ///
  /// Vorher schrieb jede Kursaenderung sofort ihre eigene Zeile, also ein
  /// `insertOnConflictUpdate` pro Anlage und Spieltag. Ueber alle vier
  /// Klassen waren das gut zwei Dutzend Einzelschreibvorgaenge taeglich und
  /// rund 42.000 bei einem Fuenf-Jahres-Sprung — obwohl die Quote-Zeile
  /// ohnehin nur den AKTUELLEN Kurs haelt. Die Zwischenstaende der
  /// uebersprungenen Tage muss niemand speichern; die Kurshistorie liegt
  /// getrennt in `price_history`.
  ///
  /// Der Microtask laeuft am naechsten Await-Punkt. Im Zeitsprung ist das
  /// alle zehn Tage (der Fortschritts-Yield), im normalen Spiel sofort nach
  /// der Tages-Pipeline. `ref.mounted` schuetzt den Fall, dass der Container
  /// zwischen Planung und Ausfuehrung verworfen wurde.
  void _persistQuote(CryptoQuote _) {
    if (_flushGeplant) return;
    _flushGeplant = true;
    scheduleMicrotask(() {
      _flushGeplant = false;
      if (!ref.mounted) return;
      _persistAllQuotes();
    });
  }

  bool _flushGeplant = false;

  void _persistAllQuotes() {
    final db = ref.read(appDatabaseProvider);
    final rows = [
      for (final q in state.quotes.values)
        CryptoQuoteRow(
          assetId: q.assetId,
          pricePerShareCents: q.pricePerShare.cents,
          onDayIndex: q.onDayIndex,
        ),
    ];
    unawaited(db.cryptoDao.upsertQuotes(rows).catchError((Object _) {}));
  }
}
