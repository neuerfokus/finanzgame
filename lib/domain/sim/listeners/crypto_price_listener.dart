import 'dart:math' as math;

import '../../crypto/crypto.dart';
import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../market_phase.dart';
import '../rng.dart';
import 'market_phase_listener.dart';

/// Adapter the listener uses to read + write crypto quotes. Implemented
/// by `CryptoRepository`.
abstract class CryptoPriceSource {
  CryptoQuote quoteFor(String assetId);
  void updateQuote(CryptoQuote quote);
}

/// Daily crypto price roll. Spec-22:
///
/// - Bitcoin-Gruppe: `nextPrice = prev * (1 + regime + noise)`, hart ins
///   [CryptoPriceBand] geclampt.
/// - Krypto-Casino: `nextPrice = basePrice * uniform(1-vola, 1+vola)` —
///   unabhängiger Tages-Draw um die FESTE Basis, kein Random-Walk (der hatte
///   negativen geometrischen Drift und kollabierte auf den Cent-Floor).
/// - Deterministic via `seed ^ id.hashCode ^ (dayIndex * 41)`.
/// - An einem [crashToday]-Tag kommt ein *zusätzlicher* uniformer
///   Multiplikator in `[0.20, 0.50]` obendrauf (also −50..−80 % über den
///   normalen Wurf hinaus) — „die Vulkan-Eruption nimmt Krypto noch härter
///   mit".
///
/// Pure (no Flutter / Drift imports).
class CryptoPriceListener implements DayEventListener {
  CryptoPriceListener({
    required this.source,
    required this.seed,
    this.crashToday = false,
    this.marketPhase = const MarketPhase.normal(),
  });

  final CryptoPriceSource source;
  final int seed;

  /// True, wenn die Klasse `crypto` heute einen Crash gestartet hat
  /// ([CrashStartedEvent] aus dem Phasen-System, früher der separate
  /// `CrashListener`). Dann nimmt jede Münze einen Extra-Schlag über den
  /// normalen Wurf hinaus.
  final bool crashToday;

  /// Sprint B (Spec-44): aktuelle Markt-Phase der `crypto`-Klasse,
  /// resolved durch `MarketPhaseListener`. Drawdown drückt täglich
  /// nach unten, Recovery zieht nach oben.
  final MarketPhase marketPhase;

  /// Bitcoin-Jahres-Regime (Round 27 v4 — User: „langfristig steigt
  /// Bitcoin", Korridor ~16k-250k über 5-10 J, aber 5-Jahres-Sprung war
  /// zu extrem). Entschärft:
  /// - 25 % Bären-Jahr: ×0,65 (−35 %)
  /// - 45 % Normal-Jahr: ×1,12 (+12 %)
  /// - 30 % Bullen-Jahr: ×1,65 (+65 %)
  ///
  /// Geometrischer Mittelwert ≈ +10 %/Jahr → klarer Aufwärtstrend,
  /// volatil aber nicht mehr absurd (vorher ×0,55/×1,90 ergab über 5 J
  /// teils <10k oder >1 Mio). Wird beim Jahres-Beginn ausgewürfelt und
  /// glatt über 365 Tage ausgegeben (drift/Tag = ln(factor)/365).
  /// Balance-Analyse 2026-08: wie beim ETF als Deck statt als Würfel — 20
  /// Karten für zwei Jahrzehnte, exakt 25 % Bär · 45 % normal · 30 % Bulle.
  /// Unabhängige Jahreswürfe treffen diese Anteile über die paar Jahrzehnte
  /// eines Durchlaufs nicht, und weil der Seed fest ist, verfehlt sie jeder
  /// Spieler auf dieselbe Weise.
  static const List<double> bitcoinYearDeck = [
    0.65, 0.65, 0.65, 0.65, 0.65, // 5 Bären-Jahre
    1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, 1.12, // 9 normale
    1.65, 1.65, 1.65, 1.65, 1.65, 1.65, // 6 Bullen-Jahre
  ];

  static double _bitcoinDailyDrift(int seed, int dayIndex) {
    final yearIndex = dayIndex ~/ 365;
    final factor = dealCard(seed ^ 0xB17C01, yearIndex, bitcoinYearDeck);
    return math.log(factor) / 365.0;
  }

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final events = <DayEvent>[];
    final crashing = crashToday;
    final phaseMod = MarketPhaseListener.dailyModifierFor(marketPhase);

    // Bug-fix v26: 1× Roll pro `groupId`, dann auf alle Mitglieder
    // anwenden. Stellt sicher, dass z.B. alle 5 Bitcoin-Stückelungen
    // den selben Tages-% machen und damit proportional bleiben.
    final groupReturn = <String, double>{};
    // Round 27 BUGFIX: neuer Leader-Preis 1× pro Gruppe cachen. Vorher
    // wurde der Tages-Return pro Stückelung NOCHMAL auf eine bereits
    // geupdatete Leader-Baseline multipliziert → Member liefen (1+r)
    // pro Tag schneller als der Leader → Stückelungen desyncten massiv
    // („1 BTC" ≠ mikro×10000). Jetzt: jede Stückelung EXAKT
    // Leader_neu × ratio. Self-healing für divergierte Saves.
    final groupLeaderNewCents = <String, int>{};

    for (final spec in CryptoCatalog.all) {
      final groupKey = spec.groupId;
      // Leader = Spec mit kleinster basePrice in der Gruppe. Sein neuer
      // Preis wird 1× berechnet + gecacht; jede Stückelung leitet sich EXAKT
      // als Leader_neu × ratio ab. So bleiben alle Denominationen immer
      // saubere Vielfache (kein Drift-Doppel).
      final leader = CryptoCatalog.all
          .where((s) => s.groupId == groupKey)
          .reduce((a, b) => a.basePrice.cents < b.basePrice.cents ? a : b);
      final band = CryptoPriceBand.forGroup(groupKey);
      final loCents = band.loCentsFor(leader.basePrice.cents);
      final hiCents = band.hiCentsFor(leader.basePrice.cents);

      final leaderNewCents = groupLeaderNewCents.putIfAbsent(groupKey, () {
        // Seed gemischt (domain/sim/rng.dart) — benachbarte Tage lieferten
        // sonst korrelierte Erstausgaben und damit eine schiefe Ziehung.
        final rng = math.Random(
          mixSeed(seed ^ groupKey.hashCode, newDay.dayIndex),
        );
        final prevCents = source.quoteFor(leader.id).pricePerShare.cents;

        if (groupKey != 'bitcoin') {
          // Krypto-Casino: UNABHÄNGIGER Tages-Draw um die FESTE Basis —
          // „Basis 150 € × Zufallsfaktor [0,3..1,7]", wie dokumentiert.
          // Vorher war es ein multiplikativer Random-Walk auf den Vortag:
          // E[ln(1+U(−0,7;+0,7))] ≈ −9,7 %/Tag → der Kurs kollabierte in
          // ~100-150 Spieltagen auf den 1-¢-Floor und blieb dort.
          var factor = 1.0 + (rng.nextDouble() * 2 - 1) * spec.volatility;
          if (crashing) {
            // Crash beißt genauso hart wie vorher (−50..−80 %), landet durch
            // den Clamp aber am unteren Bandrand statt im Cent-Bereich.
            factor *= 1 - (0.50 + rng.nextDouble() * 0.30);
          }
          factor += phaseMod;
          return (leader.basePrice.cents * factor)
              .round()
              .clamp(loCents, hiCents);
        }

        // Bitcoin: Jahres-Regime + kleiner Noise auf den Vortag (der
        // langfristige Aufwärtstrend soll erhalten bleiben) — aber hart
        // ins Band geclampt, damit ein Crash-Lauf den Kurs nie unter die
        // Reseed-Untergrenze drückt (sonst Reseed-Exploit wie beim Casino).
        final drift = _bitcoinDailyDrift(seed, newDay.dayIndex);
        final noise = (rng.nextDouble() * 2 - 1) * 0.010; // ±1,0 %/Tag
        var ret = math.exp(drift + noise) - 1;
        // Balance-Analyse 2026-08: Bitcoin wurde bei jedem Crash ZWEIMAL
        // getroffen — hier einmal mit −50..80 % am Crash-Tag, und zusätzlich
        // über `phaseMod` mit dem Drawdown der Krypto-Marktphase (30..60 %,
        // linear über 10 Tage). Zusammen rund −80 % pro Crash bei 1,5 Crashes
        // im Jahr: der Kurs konnte gar nicht steigen, er klebte dauerhaft am
        // unteren Rand des Reseed-Bandes (gemessen 0,3× Basis nach 40 Jahren,
        // −3,4 %/Jahr) — das Gegenteil der Vorgabe „langfristig steigt
        // Bitcoin". Der Extraschlag stammt aus der Zeit vor dem Phasen-System
        // und ist jetzt Doppelbuchung. Die Marktphase allein modelliert den
        // Crash, und sie ist für Krypto ohnehin die aggressivste aller
        // Klassen. Der Casino-Coin oben behält seinen Extraschlag: der zieht
        // jeden Tag neu um eine FESTE Basis, kompoundiert also nicht.
        ret += phaseMod;
        return (prevCents * (1 + ret)).round().clamp(loCents, hiCents);
      });

      // Anzeige-Delta aus dem tatsächlichen Leader-Kursschritt ableiten —
      // so passt die gemeldete %-Änderung auch mit Clamp/Fixed-Base-Draw.
      final dailyReturn = groupReturn.putIfAbsent(groupKey, () {
        final prevCents = source.quoteFor(leader.id).pricePerShare.cents;
        if (prevCents <= 0) return 0.0;
        return leaderNewCents / prevCents - 1;
      });

      final ratio = spec.basePrice.cents / leader.basePrice.cents;
      final newCents = (leaderNewCents * ratio).round().clamp(1, 1 << 30);
      final newPrice = Money.cents(newCents);
      final newQuote = CryptoQuote(
        assetId: spec.id,
        pricePerShare: newPrice,
        onDayIndex: newDay.dayIndex,
      );
      source.updateQuote(newQuote);
      events.add(
        DayEvent.cryptoPriceUpdate(
          assetId: spec.id,
          newPrice: newPrice,
          deltaPct: dailyReturn,
        ),
      );
    }
    return events;
  }
}
