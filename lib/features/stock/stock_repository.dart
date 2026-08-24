import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/listeners/crash_listener.dart';
import '../../domain/sim/listeners/stock_price_listener.dart';
import '../../domain/sim/weather.dart';
import '../../domain/stock/stock.dart';
import '../economy/cash_state.dart';
import '../market_phase/market_phase_repository.dart';
import '../market_phase/peak_tracker.dart';
import '../weather/weather_state.dart';
import '../xp/xp_repository.dart';
import '../../core/game_clock.dart';
import '../../domain/sim/market_phase.dart';

part 'stock_repository.g.dart';

class StockError implements Exception {
  const StockError(this.message);
  final String message;
  @override
  String toString() => 'StockError: $message';
}

class StockPortfolio {
  const StockPortfolio({
    required this.holdings,
    required this.quotes,
    this.bankruptStockIds = const <String>{},
  });
  final List<StockHolding> holdings;
  final Map<String, StockQuote> quotes;

  /// Spec-44 A.1: dauerhaft pleite-gegangene Aktien-IDs (in-memory
  /// keepAlive — Persistenz folgt in Schema 14).
  final Set<String> bankruptStockIds;

  StockPortfolio copyWith({
    List<StockHolding>? holdings,
    Map<String, StockQuote>? quotes,
    Set<String>? bankruptStockIds,
  }) =>
      StockPortfolio(
        holdings: holdings ?? this.holdings,
        quotes: quotes ?? this.quotes,
        bankruptStockIds: bankruptStockIds ?? this.bankruptStockIds,
      );
}

/// Persisted stock portfolio + quotes. Seeds from [StockCatalog] when DB
/// is empty.
@Riverpod(keepAlive: true)
class StockRepository extends _$StockRepository
    implements StockPriceSource, CrashTarget {
  @override
  StockPortfolio build() {
    final snap = ref.watch(dbSnapshotProvider);

    final quotes = <String, StockQuote>{
      for (final s in StockCatalog.all)
        s.id: StockQuote(
          stockId: s.id,
          pricePerShare: s.initialPrice,
          onDayIndex: 0,
        ),
    };
    // Pleite-IDs werden NICHT persistiert (bankruptStockIds ist in-memory,
    // Spec-44 H „Schema 14 holt das nach" kam nie). Sie sind aber am Kurs
    // eindeutig ablesbar: 1 ¢ liegt weit unter dem Floor lebender Aktien
    // (40 % der Basis), kann also nur aus `markBankrupt` stammen. Damit
    // überlebt die Pleite den App-Neustart ohne Schema-Änderung — vorher
    // hob der Reseed sie auf die Katalog-Basis zurück, was (a) die Lektion
    // „Einzelaktie kann alles verlieren" jedes Mal zurücknahm und (b) den
    // Cent-Exploit erst scharf machte.
    final bankrupt = <String>{};
    for (final row in snap.stockQuotes) {
      final spec = StockCatalog.byId(row.stockId);
      final saved = row.pricePerShareCents;
      if (saved <= StockCatalog.bankruptPriceCents) {
        bankrupt.add(row.stockId);
        quotes[row.stockId] = StockQuote(
          stockId: row.stockId,
          pricePerShare:
              const Money.cents(StockCatalog.bankruptPriceCents),
          onDayIndex: row.onDayIndex,
        );
        continue;
      }
      // Force-Reseed wie ETF/Crypto/Metal: saved muss im Preisband liegen,
      // sonst Catalog-Default. Schützt bei Preis-Korrekturen.
      final useSaved = saved >= StockCatalog.priceFloorCentsFor(spec) &&
          saved <= StockCatalog.priceCeilCentsFor(spec);
      quotes[row.stockId] = StockQuote(
        stockId: row.stockId,
        pricePerShare: Money.cents(useSaved ? saved : spec.initialPrice.cents),
        onDayIndex: row.onDayIndex,
      );
    }

    // Rückwirkende Normalisierung des Cent-Aktien-Exploits (Muster wie
    // EtfRepository/CryptoRepository): Bestände mit einem Ø-Kaufpreis unter
    // 20 % der Basis sind zwingend zu Cent-/Euro-Kursen entstanden — legitim
    // war nie etwas unter 40 % erreichbar. Sie werden auf den TATSÄCHLICH
    // ausgegebenen Betrag zum echten heutigen Kurs zurückgerechnet: der
    // Windfall verschwindet, das reale Investment bleibt, P&L neutral,
    // idempotent. Pleite-Bestände bleiben unangetastet (dort IST der
    // Totalverlust die Lektion).
    final holdings = <StockHolding>[];
    final corrected = <StockHolding>[];
    for (final r in snap.stockHoldings) {
      final spec = StockCatalog.byId(r.stockId);
      final avgCents = r.averageBuyPriceCents;
      final currentCents =
          quotes[r.stockId]?.pricePerShare.cents ?? spec.initialPrice.cents;
      final isBankrupt = bankrupt.contains(r.stockId);
      if (!isBankrupt &&
          avgCents < StockCatalog.exploitAvgPriceThresholdCents(spec) &&
          r.shares > 0 &&
          currentCents > 0) {
        final costBasisCents = r.shares * avgCents;
        final fixed = StockHolding(
          stockId: r.stockId,
          shares: (costBasisCents / currentCents).round().clamp(0, 1 << 30),
          averageBuyPrice: Money.cents(currentCents),
        );
        holdings.add(fixed);
        corrected.add(fixed);
      } else {
        holdings.add(StockHolding(
          stockId: r.stockId,
          shares: r.shares,
          averageBuyPrice: Money.cents(avgCents),
          bankrupt: isBankrupt,
        ));
      }
    }

    // Korrektur EINMALIG festschreiben. Ohne das rechnet jeder App-Start sie
    // gegen den dann aktuellen Kurs neu — der Wert bliebe konstant, aber die
    // angezeigte Stückzahl wanderte von Session zu Session, was für den
    // Spieler wie ein Bug aussieht. Idempotent: nach dem Schreiben liegt der
    // Ø-Kaufpreis über der Schwelle, die Bedingung greift nie wieder.
    if (corrected.isNotEmpty) {
      final db = ref.read(appDatabaseProvider);
      for (final h in corrected) {
        unawaited(
          db.stockDao
              .upsertHolding(StockHoldingRow(
                stockId: h.stockId,
                shares: h.shares,
                averageBuyPriceCents: h.averageBuyPrice.cents,
              ))
              .catchError((Object _) {}),
        );
      }
    }

    return StockPortfolio(
      holdings: holdings,
      quotes: quotes,
      bankruptStockIds: bankrupt,
    );
  }

  StockHolding? holdingFor(String stockId) {
    for (final h in state.holdings) {
      if (h.stockId == stockId) return h;
    }
    return null;
  }

  @override
  StockQuote quoteFor(String stockId) =>
      state.quotes[stockId] ??
      StockQuote(
        stockId: stockId,
        pricePerShare: StockCatalog.byId(stockId).initialPrice,
        onDayIndex: 0,
      );

  @override
  Weather weatherForDay(int dayIndex) => rollWeather(dayIndex);

  @override
  void updateQuote(StockQuote quote) {
    state = state.copyWith(quotes: {...state.quotes, quote.stockId: quote});
    _persistQuote(quote);
  }

  @override
  bool isBankrupt(String stockId) => state.bankruptStockIds.contains(stockId);

  @override
  void markBankrupt(String stockId) {
    if (state.bankruptStockIds.contains(stockId)) return;
    // Holdings flaggen (sichtbar im UI als "Pleite"), keepen aber den
    // Holding-Eintrag damit der Spieler die Lektion sieht.
    final updatedHoldings = [
      for (final h in state.holdings)
        if (h.stockId == stockId) h.copyWith(bankrupt: true) else h,
    ];
    state = state.copyWith(
      bankruptStockIds: {...state.bankruptStockIds, stockId},
      holdings: updatedHoldings,
    );
    // Drift persistiert nur shares + avgPrice, bankrupt-Flag bleibt
    // in-memory (Spec-44 H: Schema 14 holt das nach).
  }

  @override
  List<String> applyCrash(double dropPct) {
    final factor = 1.0 - dropPct;
    final newQuotes = <String, StockQuote>{};
    for (final entry in state.quotes.entries) {
      final q = entry.value;
      // Pleite-Aktien bleiben bei 1 ¢ — kein Crash-Roll, keine Erholung.
      if (state.bankruptStockIds.contains(entry.key)) {
        newQuotes[entry.key] = q;
        continue;
      }
      // Floor = 40 % des Startpreises, identisch zu Listener + Reseed-Band
      // (vorher pauschal 100 ¢ → machte den Cent-Exploit möglich).
      final floor =
          StockCatalog.priceFloorCentsFor(StockCatalog.byId(entry.key));
      newQuotes[entry.key] = q.copyWith(
        pricePerShare: Money.cents(
          (q.pricePerShare.cents * factor).round().clamp(floor, 1 << 30),
        ),
      );
    }
    state = state.copyWith(quotes: newQuotes);
    _persistAllQuotes();
    return newQuotes.keys.toList();
  }

  void buy({required String stockId, required int shares}) {
    if (shares <= 0) throw const StockError('shares must be positive');
    final price = quoteFor(stockId).pricePerShare;
    final total = price * shares;
    final cashNotifier = ref.read(cashStateProvider.notifier);
    if (!cashNotifier.spend(total)) {
      throw const StockError('insufficient cash');
    }
    final existing = holdingFor(stockId);
    final StockHolding updated;
    if (existing == null) {
      updated = StockHolding(
        stockId: stockId,
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
    // Spec-21: +5 XP per Stock buy.
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.stockBought);
    ref.read(gameClockProvider.notifier).evaluateAchievementsNow();
  }

  void sell({required String stockId, required int shares}) {
    if (shares <= 0) throw const StockError('shares must be positive');
    final existing = holdingFor(stockId);
    if (existing == null || existing.shares < shares) {
      throw const StockError('not enough shares');
    }
    final price = quoteFor(stockId).pricePerShare;
    ref.read(cashStateProvider.notifier).earn(price * shares);

    final remaining = existing.shares - shares;
    if (remaining == 0) {
      state = state.copyWith(
        holdings: state.holdings.where((h) => h.stockId != stockId).toList(),
      );
      _deleteHolding(stockId);
    } else {
      _putHolding(existing.copyWith(shares: remaining));
    }
    // Sprint C4: Panic-Sell-Check.
    _maybeRecordPanicSell();
  }

  void _maybeRecordPanicSell() {
    final phase = ref
        .read(marketPhaseRepositoryProvider.notifier)
        .phaseFor('stock');
    if (phase is! DrawdownPhase) return;
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    var total = 0;
    for (final h in state.holdings) {
      final q = state.quotes[h.stockId];
      if (q != null) total += q.pricePerShare.cents * h.shares;
    }
    final peakTracker = ref.read(peakTrackerProvider.notifier);
    final peak = peakTracker.peakFor('stock');
    peakTracker.recordPanicSell(
      classId: 'stock',
      dayIndex: dayIndex,
      drawdownPct: peak.drawdownFrom(total),
      currentValueCents: total,
    );
  }

  void _putHolding(StockHolding h) {
    final list = [
      for (final existing in state.holdings)
        if (existing.stockId != h.stockId) existing,
      h,
    ];
    state = state.copyWith(holdings: list);
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.stockDao
          .upsertHolding(StockHoldingRow(
            stockId: h.stockId,
            shares: h.shares,
            averageBuyPriceCents: h.averageBuyPrice.cents,
          ))
          .catchError((Object _) {}),
    );
  }

  void _deleteHolding(String stockId) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.stockDao.deleteHolding(stockId).catchError((Object _) {}));
  }

  void _persistQuote(StockQuote q) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.stockDao
          .upsertQuote(StockQuoteRow(
            stockId: q.stockId,
            pricePerShareCents: q.pricePerShare.cents,
            onDayIndex: q.onDayIndex,
          ))
          .catchError((Object _) {}),
    );
  }

  void _persistAllQuotes() {
    final db = ref.read(appDatabaseProvider);
    final rows = [
      for (final q in state.quotes.values)
        StockQuoteRow(
          stockId: q.stockId,
          pricePerShareCents: q.pricePerShare.cents,
          onDayIndex: q.onDayIndex,
        ),
    ];
    unawaited(db.stockDao.upsertQuotes(rows).catchError((Object _) {}));
  }
}
