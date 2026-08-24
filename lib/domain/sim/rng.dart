import 'dart:math' as math;

/// Seed-Mixer für die deterministischen Tages-Würfe der Preis-Listener.
///
/// **Warum das nötig war** (Balance-Analyse 2026-08): alle Listener bauten
/// ihren Tages-Seed als `seed ^ id.hashCode ^ (dayIndex * 2654435761)` und
/// zogen daraus die ersten ein bis zwei `nextDouble()`. Aufeinanderfolgende
/// Tage liefern damit aufeinanderfolgende Seeds, und die ERSTEN Ausgaben
/// eines frisch geseedeten `math.Random` sind über benachbarte Seeds nicht
/// unabhängig. Beim ETF hatte der so erzeugte Standardnormal-Rausch über
/// 40 Spieljahre ein Mittel von −0,0101 statt 0. Klingt winzig, kostet aber
/// `0,0101 × 0,009 × 365 ≈ 3,3 %` Rendite pro Jahr — und weil der Seed fest
/// ist, trifft exakt dieser Gegenwind JEDEN Spieler in JEDEM Durchlauf.
/// Dasselbe Muster verzerrte die Wetter-Verteilung.
///
/// [mixSeed] jagt die beiden Eingaben durch den splitmix64-Finalizer, sodass
/// benachbarte `dayIndex` weit auseinanderliegende, unkorrelierte Seeds
/// ergeben. Determinismus bleibt vollständig erhalten: gleiche Eingabe →
/// gleicher Seed, Lauf für Lauf.
int mixSeed(int a, int b) {
  var x = (a * 0x9E3779B97F4A7C15) ^ (b + 0x9E3779B97F4A7C15);
  x ^= x >>> 30;
  x *= 0xBF58476D1CE4E5B9;
  x ^= x >>> 27;
  x *= 0x94D049BB133111EB;
  x ^= x >>> 31;
  // math.Random will einen nicht-negativen Seed sinnvoller Größe.
  return x & 0x3FFFFFFFFFFFFFFF;
}

/// Standardnormal-verteilter Wert (Box-Muller) aus einem gemischten Seed.
double standardNormal(int seed) {
  final rng = math.Random(mixSeed(seed, 0x5DEECE66D));
  final u1 = rng.nextDouble().clamp(1e-12, 1.0);
  final u2 = rng.nextDouble();
  return math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
}

/// Tages-Rausch mit garantiertem Mittelwert 0 über jeden Jahresblock.
///
/// **Warum nicht einfach [standardNormal] pro Tag** (Balance-Analyse 2026-08):
/// 365 unabhängige Ziehungen haben einen Stichproben-Mittelwert von etwa
/// ±1/√365. Multipliziert mit der Tages-Vola und 365 Tagen sind das bei einem
/// ETF rund ±3 % Jahresrendite, bei einer Aktie (σ = 0,022) rund ±6 %. In
/// einem echten Markt ist das schlicht Zufall und mittelt sich über viele
/// Marktteilnehmer und Jahrzehnte weg. Hier ist der Seed aber FEST: dieselbe
/// Verzerrung trifft jeden Spieler in jedem Durchlauf identisch, über die
/// gesamte Spielzeit. Die geplante Rendite („60 % der Jahre ×1,10") wurde so
/// von einer unsichtbaren Seed-Lotterie überschrieben — vor dem Fix zog der
/// Welt-ETF eine −3,3 %/Jahr-Niete.
///
/// Deshalb wird der Rausch pro Jahresblock zentriert: die 365 Tageswerte
/// eines Jahres werden gezogen und um ihren eigenen Mittelwert verschoben.
/// Das Tages-Auf-und-Ab bleibt vollständig erhalten (Form und Streuung sind
/// unverändert), aber die Richtung des Jahres kommt aus dem Jahres-Regime,
/// wo sie hingehört, und nicht aus Rundungsglück im Zufallsgenerator.
double centeredNormal(int assetSeed, int dayIndex, {int block = 365}) {
  final blockIndex = dayIndex ~/ block;
  final key = mixSeed(assetSeed, blockIndex);
  final values = _centeredBlocks[key] ??= _buildCenteredBlock(key, block);
  return values[dayIndex % block];
}

/// Zieht aus einem **Deck statt mit einem Würfel**.
///
/// Balance-Analyse 2026-08: `etfDailyDrift` würfelte pro Jahr unabhängig
/// 60 % / 30 % / 10 %. Über die 40 Spieljahre, die ein Durchlauf real
/// erreicht, weicht die gezogene Mischung deutlich von diesen Anteilen ab —
/// gemessen kamen statt der geplanten +3,8 %/Jahr nur +2,5 %/Jahr heraus, und
/// zwar für jeden Spieler gleich, weil der Seed fest ist. [dealCard] mischt
/// stattdessen ein Deck aus [deckCards] (6 gute, 3 ruhige, 1 Crash-Jahr) und
/// teilt es der Reihe nach aus: welches Jahr welches wird, bleibt
/// überraschend, die Verteilung ist garantiert. Die Blockgröße ist die
/// Kartenzahl — danach wird neu gemischt.
///
/// Dasselbe Verfahren zieht das Wetter (Deck über ein Spieljahr), damit auch
/// dort die geplanten Anteile exakt eintreffen statt nur im Erwartungswert.
T dealCard<T>(int seed, int index, List<T> deckCards) {
  final block = deckCards.length;
  final blockIndex = index ~/ block;
  final key = mixSeed(seed, blockIndex ^ 0xDECC);
  final deck = _decks[key] ??= _shuffledDeck(key, deckCards);
  return deck[index % block] as T;
}

List<Object?> _shuffledDeck(int key, List<Object?> deckCards) {
  if (_decks.length > 1024) _decks.clear();
  final cards = [...deckCards];
  // Fisher-Yates mit gemischtem, deterministischem Seed.
  final rng = math.Random(mixSeed(key, 0xF15E));
  for (var i = cards.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final tmp = cards[i];
    cards[i] = cards[j];
    cards[j] = tmp;
  }
  return cards;
}

final Map<int, List<Object?>> _decks = {};

/// Ein Eintrag pro (Anlage, Jahr). Bei 8 Kursen und 60 Spieljahren sind das
/// keine 500 Listen — die Schranke fängt nur pathologische Fälle ab.
final Map<int, List<double>> _centeredBlocks = {};

List<double> _centerAll(List<double> raw) {
  var sum = 0.0;
  for (final v in raw) {
    sum += v;
  }
  final mean = sum / raw.length;
  return [for (final v in raw) v - mean];
}

List<double> _buildCenteredBlock(int key, int block) {
  if (_centeredBlocks.length > 1024) _centeredBlocks.clear();
  return _centerAll(
    List<double>.generate(block, (i) => standardNormal(mixSeed(key, i))),
  );
}

/// Varianz-Drag-Korrektur für multiplikative Tages-Returns.
///
/// Ein Kurs, der täglich mit `(1 + drift + z·σ)` multipliziert wird, wächst
/// langfristig nicht mit `drift`, sondern mit `drift − σ²/2` — der klassische
/// Unterschied zwischen arithmetischer und geometrischer Rendite. Beim
/// ETF-Jahres-Regime ist die geometrische Rendite gemeint („60 % der Jahre
/// ×1,10"), also muss `σ²/2` zurückgegeben werden, sonst liefert das Modell
/// systematisch weniger als es verspricht (bei σ = 0,009/Tag rund 1,5 %/Jahr,
/// bei σ = 0,016 rund 4,7 %/Jahr).
double varianceDragCorrection(double sigma) => 0.5 * sigma * sigma;
