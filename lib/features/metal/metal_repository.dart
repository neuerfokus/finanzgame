import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/metal/metal.dart';
import '../../domain/sim/listeners/metal_price_listener.dart';
import '../../core/game_clock.dart';
import '../economy/cash_state.dart';
import '../xp/xp_repository.dart';

part 'metal_repository.g.dart';

class MetalError implements Exception {
  const MetalError(this.message);
  final String message;
  @override
  String toString() => 'MetalError: $message';
}

class MetalPortfolio {
  const MetalPortfolio({required this.holdings, required this.quotes});
  final List<MetalHolding> holdings;
  final Map<String, MetalQuote> quotes;

  MetalPortfolio copyWith({
    List<MetalHolding>? holdings,
    Map<String, MetalQuote>? quotes,
  }) =>
      MetalPortfolio(
        holdings: holdings ?? this.holdings,
        quotes: quotes ?? this.quotes,
      );
}

/// Persisted metal portfolio + quotes. Seeds from [MetalCatalog] when DB
/// is empty. Spec-22.
@Riverpod(keepAlive: true)
class MetalRepository extends _$MetalRepository implements MetalPriceSource {
  @override
  MetalPortfolio build() {
    final snap = ref.watch(dbSnapshotProvider);

    final quotes = <String, MetalQuote>{
      for (final s in MetalCatalog.all)
        s.id: MetalQuote(
          assetId: s.id,
          pricePerShare: s.basePrice,
          onDayIndex: 0,
        ),
    };
    for (final row in snap.metalQuotes) {
      // Force-reseed wenn die gespeicherte Notierung völlig aus dem Rahmen
      // fällt (Katalog-Anpassung wie Round 22 v3: Gold 130→78 €/g, oder ein
      // Crash-/Exploit-Ausreißer).
      //
      // Analyse-Runde 2026-08: Referenz ist jetzt der ERWARTUNGSWERT für den
      // Spieltag, nicht mehr die starre Basis vom Tag 0 — sonst warf der
      // Reseed die legitime Inflationsschutz-Wertsteigerung weg (Gold lag
      // nach ~9,5 Spieljahren über der alten 1,4×-Grenze und sprang beim
      // nächsten App-Start auf die Basis zurück).
      final spec = MetalCatalog.byId(row.assetId);
      final day = snap.dayIndex ?? row.onDayIndex;
      final expected = MetalCatalog.expectedPriceCents(spec, day);
      final saved = row.pricePerShareCents;
      final useSaved =
          saved >= (expected * MetalCatalog.priceBandLo).round() &&
              saved <= (expected * MetalCatalog.priceBandHi).round();
      quotes[row.assetId] = MetalQuote(
        assetId: row.assetId,
        pricePerShare: Money.cents(useSaved ? saved : expected),
        onDayIndex: row.onDayIndex,
      );
    }

    // L13 (Analyse 2026-08): Metall war die EINZIGE Anlageklasse ohne
    // rückwirkende Cent-Exploit-Normalisierung — Aktien (+175), ETF (+171) und
    // Krypto (+173) haben sie längst. Heute ist das ungefährlich, weil kein
    // Metall-Kurs je in Cent-Nähe kam (Basispreise ab 85 ¢/g Silber, Floor bei
    // 40 % davon). Aber genau dieses „heute sicher" galt für die anderen drei
    // auch, bis eine Preis-Korrektur oder ein Crash-Pfad es aufhob. Als
    // einziger blinder Fleck bleibt es die Stelle, an der ein künftiger
    // Katalog- oder Crash-Umbau unbemerkt eine Exploit-Tür öffnet.
    //
    // Muster identisch zu den anderen: Bestände mit absurd niedrigem
    // Ø-Kaufpreis werden auf den tatsächlich ausgegebenen Betrag zum echten
    // heutigen Kurs zurückgerechnet — P&L-neutral und idempotent, weil der
    // korrigierte Ø-Preis danach über der Schwelle liegt.
    final holdings = <MetalHolding>[];
    for (final r in snap.metalHoldings) {
      final avgCents = r.averageBuyPriceCents;
      final spec = MetalCatalog.byId(r.assetId);
      final currentCents =
          quotes[r.assetId]?.pricePerShare.cents ?? spec.basePrice.cents;
      final threshold = MetalCatalog.exploitAvgPriceThresholdCentsFor(spec);
      if (avgCents < threshold && r.shares > 0 && currentCents > 0) {
        final costBasisCents = r.shares * avgCents;
        holdings.add(MetalHolding(
          assetId: r.assetId,
          shares: (costBasisCents / currentCents).round().clamp(0, 1 << 30),
          averageBuyPrice: Money.cents(currentCents),
        ));
      } else {
        holdings.add(MetalHolding(
          assetId: r.assetId,
          shares: r.shares,
          averageBuyPrice: Money.cents(avgCents),
        ));
      }
    }

    return MetalPortfolio(holdings: holdings, quotes: quotes);
  }

  MetalHolding? holdingFor(String assetId) {
    for (final h in state.holdings) {
      if (h.assetId == assetId) return h;
    }
    return null;
  }

  @override
  MetalQuote quoteFor(String assetId) =>
      state.quotes[assetId] ??
      MetalQuote(
        assetId: assetId,
        pricePerShare: MetalCatalog.byId(assetId).basePrice,
        onDayIndex: 0,
      );

  Money currentPrice(String assetId) => quoteFor(assetId).pricePerShare;

  @override
  void updateQuote(MetalQuote quote) {
    state = state.copyWith(quotes: {...state.quotes, quote.assetId: quote});
    _persistQuote(quote);
  }

  /// B6 Zeitsprung-Crisis: schockt alle gehaltenen Quotes um [dropPct]
  /// (z.B. 0.30 = -30%). Mutiert + persistiert.
  ///
  /// Boden = 40 % des Erwartungswerts (identisch mit der unteren
  /// Reseed-Schranke), NICHT mehr 1 ¢. Analyse-Runde 2026-08: Aktien und ETF
  /// haben genau diesen Boden bekommen, weil ein tief genug gedrückter Kurs
  /// unter das Reseed-Band rutscht — dort für Centbeträge kaufen und beim
  /// nächsten App-Start auf den Reseed-Wert springen, war die Cent-Exploit-
  /// Masche. Bei Metall war der 1-¢-Clamp als einziger übrig.
  List<String> applyCrash(double dropPct) {
    final factor = 1.0 - dropPct;
    final newQuotes = <String, MetalQuote>{};
    for (final entry in state.quotes.entries) {
      final q = entry.value;
      final floor = MetalCatalog.priceFloorCentsFor(
        MetalCatalog.byId(q.assetId),
        q.onDayIndex,
      );
      newQuotes[entry.key] = MetalQuote(
        assetId: q.assetId,
        pricePerShare: Money.cents(
          (q.pricePerShare.cents * factor).round().clamp(floor, 1 << 30),
        ),
        onDayIndex: q.onDayIndex,
      );
    }
    state = state.copyWith(quotes: newQuotes);
    for (final q in newQuotes.values) {
      _persistQuote(q);
    }
    return newQuotes.keys.toList();
  }

  void buy({required String assetId, required int shares}) {
    if (shares <= 0) throw const MetalError('shares must be positive');
    final price = quoteFor(assetId).pricePerShare;
    final total = price * shares;
    final cashNotifier = ref.read(cashStateProvider.notifier);
    if (!cashNotifier.spend(total)) {
      throw const MetalError('insufficient cash');
    }
    final existing = holdingFor(assetId);
    final MetalHolding updated;
    if (existing == null) {
      updated = MetalHolding(
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
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.metalBought);
    ref.read(gameClockProvider.notifier).evaluateAchievementsNow();
  }

  void sell({required String assetId, required int shares}) {
    if (shares <= 0) throw const MetalError('shares must be positive');
    final existing = holdingFor(assetId);
    if (existing == null || existing.shares < shares) {
      throw const MetalError('not enough shares');
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
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.metalSold);
  }

  void _putHolding(MetalHolding h) {
    final list = [
      for (final existing in state.holdings)
        if (existing.assetId != h.assetId) existing,
      h,
    ];
    state = state.copyWith(holdings: list);
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.metalDao
          .upsertHolding(MetalHoldingRow(
            assetId: h.assetId,
            shares: h.shares,
            averageBuyPriceCents: h.averageBuyPrice.cents,
          ))
          .catchError((Object _) {}),
    );
  }

  void _deleteHolding(String assetId) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.metalDao.deleteHolding(assetId).catchError((Object _) {}));
  }

  void _persistQuote(MetalQuote q) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.metalDao
          .upsertQuote(MetalQuoteRow(
            assetId: q.assetId,
            pricePerShareCents: q.pricePerShare.cents,
            onDayIndex: q.onDayIndex,
          ))
          .catchError((Object _) {}),
    );
  }
}
