import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database.dart';
import '../../data/db/app_database_provider.dart';
import '../../domain/economy/money.dart';
import '../../domain/etf/etf.dart';
import '../../domain/sim/listeners/crash_listener.dart';
import '../../domain/sim/listeners/etf_price_listener.dart';
import '../../domain/sim/weather.dart';
import '../economy/cash_state.dart';
import '../market_phase/market_phase_repository.dart';
import '../market_phase/peak_tracker.dart';
import '../weather/weather_state.dart';
import '../xp/xp_repository.dart';
import '../../core/game_clock.dart';
import '../../domain/sim/market_phase.dart';

part 'etf_repository.g.dart';

class EtfError implements Exception {
  const EtfError(this.message);
  final String message;
  @override
  String toString() => 'EtfError: $message';
}

/// Schwelle für die Cent-ETF-Exploit-Erkennung: Holdings mit einem
/// Ø-Kaufpreis darunter stammen zwingend aus dem Cent-Kurs-Bug (die
/// Exploit-Käufe lagen im Cent-Bereich) und werden beim Laden normalisiert.
///
/// 2026-08-11 von 20 € auf 5 € gesenkt: 20 € konfiszierte auch LEGITIME
/// Alt-Gewinne — GrünPlanet hatte bis APK +132 eine Basis von 25 €, mit dem
/// 0.4×-Reseed-Floor waren ehrliche Käufe bei 10-18 € möglich. Die wurden als
/// Exploit behandelt und ihr echter Kursgewinn ausradiert. 5 € liegt unter
/// jedem je legitim erreichbaren ETF-Kurs (heute min. 0.4 × 55 € = 22 €).
const int kEtfExploitAvgPriceThresholdCents = 500; // 5 €

class EtfPortfolio {
  const EtfPortfolio({required this.holdings, required this.quotes});
  final List<EtfHolding> holdings;
  final Map<String, EtfQuote> quotes;

  EtfPortfolio copyWith({
    List<EtfHolding>? holdings,
    Map<String, EtfQuote>? quotes,
  }) =>
      EtfPortfolio(
        holdings: holdings ?? this.holdings,
        quotes: quotes ?? this.quotes,
      );
}

/// Persisted ETF portfolio + price book.
///
/// Seed = quotes from [EtfCatalog] on first build (or empty DB). Loaded
/// from `EtfHoldingsTable` + `EtfQuotesTable` during pre-warm.
@Riverpod(keepAlive: true)
class EtfRepository extends _$EtfRepository
    implements EtfPriceSource, CrashTarget {
  @override
  EtfPortfolio build() {
    final snap = ref.watch(dbSnapshotProvider);

    final quotes = <String, EtfQuote>{
      for (final s in EtfCatalog.all)
        s.id: EtfQuote(
          etfId: s.id,
          pricePerShare: s.initialPrice,
          onDayIndex: 0,
        ),
    };
    for (final row in snap.etfQuotes) {
      // Welle-8 Round 23: Symmetrisches Force-Reseed wie bei
      // Crypto/Metal — saved muss in [0.4×base, 2.5×base] liegen.
      // Schützt vor stark veralteten Catalog-Korrekturen in beide
      // Richtungen.
      final base = EtfCatalog.byId(row.etfId).initialPrice.cents;
      final saved = row.pricePerShareCents;
      final useSaved =
          saved >= (base * 0.4).round() && saved <= (base * 2.5).round();
      quotes[row.etfId] = EtfQuote(
        etfId: row.etfId,
        pricePerShare: Money.cents(useSaved ? saved : base),
        onDayIndex: row.onDayIndex,
      );
    }

    // 2026-06-04: rückwirkende Normalisierung des „Cent-ETF-Exploits".
    // Holdings mit absurd niedrigem Ø-Kaufpreis (< 20 €, gab es nie legitim —
    // min. ETF-Preis war immer ≥ 25 €) wurden zu Centpreisen in Massen gekauft
    // und per Zeitsprung zu Fake-Millionen aufgebläht. Wir rechnen sie auf den
    // TATSÄCHLICH ausgegebenen Betrag (cost basis) zum echten heutigen Kurs
    // zurück → Windfall weg, reales Investment bleibt, P&L neutral. Idempotent
    // (jeder Load liefert dasselbe Ergebnis). Legitime Holdings (≥ 20 €) bleiben
    // unangetastet.
    final holdings = <EtfHolding>[];
    for (final r in snap.etfHoldings) {
      final avgCents = r.averageBuyPriceCents;
      final currentCents = quotes[r.etfId]?.pricePerShare.cents ??
          EtfCatalog.byId(r.etfId).initialPrice.cents;
      if (avgCents < kEtfExploitAvgPriceThresholdCents &&
          r.shares > 0 &&
          currentCents > 0) {
        final costBasisCents = r.shares * avgCents;
        final correctedShares =
            (costBasisCents / currentCents).round().clamp(1, 1 << 30);
        holdings.add(EtfHolding(
          etfId: r.etfId,
          shares: correctedShares,
          averageBuyPrice: Money.cents(currentCents),
        ));
      } else {
        holdings.add(EtfHolding(
          etfId: r.etfId,
          shares: r.shares,
          averageBuyPrice: Money.cents(avgCents),
        ));
      }
    }

    return EtfPortfolio(holdings: holdings, quotes: quotes);
  }

  EtfHolding? holdingFor(String etfId) {
    for (final h in state.holdings) {
      if (h.etfId == etfId) return h;
    }
    return null;
  }

  @override
  EtfQuote quoteFor(String etfId) =>
      state.quotes[etfId] ??
      EtfQuote(
        etfId: etfId,
        pricePerShare: EtfCatalog.byId(etfId).initialPrice,
        onDayIndex: 0,
      );

  @override
  Weather weatherForDay(int dayIndex) => rollWeather(dayIndex);

  @override
  void updateQuote(EtfQuote quote) {
    state = state.copyWith(quotes: {...state.quotes, quote.etfId: quote});
    _persistQuote(quote);
  }

  @override
  List<String> applyCrash(double dropPct) {
    final factor = 1.0 - dropPct;
    final newQuotes = <String, EtfQuote>{};
    for (final entry in state.quotes.entries) {
      final q = entry.value;
      // Gleicher Realismus-Floor wie im EtfPriceListener: ETF-Kurse fallen
      // auch im Crash nie auf Cent (40 % des Startpreises).
      final floorCents = (EtfCatalog.byId(entry.key).initialPrice.cents * 0.4)
          .round();
      newQuotes[entry.key] = q.copyWith(
        pricePerShare: Money.cents(
          (q.pricePerShare.cents * factor).round().clamp(floorCents, 1 << 30),
        ),
      );
    }
    state = state.copyWith(quotes: newQuotes);
    _persistAllQuotes();
    return newQuotes.keys.toList();
  }

  void buy({required String etfId, required int shares}) {
    if (shares <= 0) throw const EtfError('shares must be positive');
    final price = quoteFor(etfId).pricePerShare;
    final total = price * shares;
    final cashNotifier = ref.read(cashStateProvider.notifier);
    if (!cashNotifier.spend(total)) {
      throw const EtfError('insufficient cash');
    }

    final existing = holdingFor(etfId);
    final EtfHolding updated;
    if (existing == null) {
      updated = EtfHolding(
        etfId: etfId,
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
    // Spec-21: +3 XP per ETF buy.
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.etfBought);
    // Welle-8: Achievements real-time (first_etf etc).
    ref.read(gameClockProvider.notifier).evaluateAchievementsNow();
  }

  void sell({required String etfId, required int shares}) {
    if (shares <= 0) throw const EtfError('shares must be positive');
    final existing = holdingFor(etfId);
    if (existing == null || existing.shares < shares) {
      throw const EtfError('not enough shares');
    }
    final price = quoteFor(etfId).pricePerShare;
    ref.read(cashStateProvider.notifier).earn(price * shares);

    final remaining = existing.shares - shares;
    if (remaining == 0) {
      state = state.copyWith(
        holdings: state.holdings.where((h) => h.etfId != etfId).toList(),
      );
      _deleteHolding(etfId);
    } else {
      _putHolding(existing.copyWith(shares: remaining));
    }
    // Spec-21: +1 XP per ETF sell.
    ref.read(xpRepositoryProvider.notifier).add(XpRewards.etfSold);
    // Sprint C4: Panic-Sell-Check — wenn die ETF-Klasse aktuell in
    // einem Drawdown ist, Verkauf als Panic-Sell markieren.
    _maybeRecordPanicSell();
  }

  void _maybeRecordPanicSell() {
    final phase = ref
        .read(marketPhaseRepositoryProvider.notifier)
        .phaseFor('etf');
    if (phase is! DrawdownPhase) return;
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final currentValue = _classMarketValueCents();
    final peakTracker = ref.read(peakTrackerProvider.notifier);
    final peak = peakTracker.peakFor('etf');
    final ddPct = peak.drawdownFrom(currentValue);
    peakTracker.recordPanicSell(
      classId: 'etf',
      dayIndex: dayIndex,
      drawdownPct: ddPct,
      currentValueCents: currentValue,
    );
  }

  int _classMarketValueCents() {
    var total = 0;
    for (final h in state.holdings) {
      final q = state.quotes[h.etfId];
      if (q != null) total += q.pricePerShare.cents * h.shares;
    }
    return total;
  }

  void _putHolding(EtfHolding h) {
    final list = [
      for (final existing in state.holdings)
        if (existing.etfId != h.etfId) existing,
      h,
    ];
    state = state.copyWith(holdings: list);
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.etfDao
          .upsertHolding(EtfHoldingRow(
            etfId: h.etfId,
            shares: h.shares,
            averageBuyPriceCents: h.averageBuyPrice.cents,
          ))
          .catchError((Object _) {}),
    );
  }

  void _deleteHolding(String etfId) {
    final db = ref.read(appDatabaseProvider);
    unawaited(db.etfDao.deleteHolding(etfId).catchError((Object _) {}));
  }

  void _persistQuote(EtfQuote q) {
    final db = ref.read(appDatabaseProvider);
    unawaited(
      db.etfDao
          .upsertQuote(EtfQuoteRow(
            etfId: q.etfId,
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
        EtfQuoteRow(
          etfId: q.etfId,
          pricePerShareCents: q.pricePerShare.cents,
          onDayIndex: q.onDayIndex,
        ),
    ];
    unawaited(db.etfDao.upsertQuotes(rows).catchError((Object _) {}));
  }
}
