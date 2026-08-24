import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_phase.freezed.dart';
part 'market_phase.g.dart';

/// Sprint B: Markt-Zustand pro Asset-Klasse. Crash ist kein
/// Einzeltag-Random mehr, sondern eine Phase über mehrere Tage:
/// normal → drawdown → recovery → normal.
///
/// Deterministisch ableitbar aus (seed, asset-class, dayIndex); die
/// Phase wird zusätzlich persistiert/in-memory gehalten, damit Tests +
/// UI den aktuellen Zustand sehen können ohne den ganzen Verlauf neu
/// zu simulieren.
@freezed
sealed class MarketPhase with _$MarketPhase {
  const factory MarketPhase.normal() = NormalPhase;

  /// Aktiver Drawdown: `daysLeft` Tage bis zum Boden. `depthPct` ist die
  /// Gesamt-Drop-Tiefe als positive Zahl (0.30 = -30 %). Pro Tag wird
  /// `depthPct / drawdownDuration` als Tagesreturn appliziert.
  const factory MarketPhase.drawdown({
    required int daysLeft,
    required int totalDays,
    required double depthPct,
  }) = DrawdownPhase;

  /// Erholung läuft `daysLeft` Tage. `targetReturnPct` ist der
  /// Gesamt-Aufholbetrag (positiv); pro Tag wird `targetReturnPct /
  /// recoveryDuration` appliziert. Nach Ablauf → normal.
  const factory MarketPhase.recovery({
    required int daysLeft,
    required int totalDays,
    required double targetReturnPct,
  }) = RecoveryPhase;

  factory MarketPhase.fromJson(Map<String, dynamic> json) =>
      _$MarketPhaseFromJson(json);
}

/// Per Asset-Klasse: wie tief der Drawdown, wie schnell die Erholung.
/// Spec-balance-didaktik A.1 + B: ETF tief & voll erholt, Gold flach &
/// kaum Erholung.
class MarketPhaseProfile {
  const MarketPhaseProfile({
    required this.classId,
    required this.crashChancePerDay,
    required this.drawdownDuration,
    required this.crashDepthMin,
    required this.crashDepthMax,
    required this.recoveryDuration,
    required this.recoveryFraction,
  });

  /// Asset-Klassen-ID (z.B. `etf`, `stock`, `crypto`, `gold`).
  final String classId;

  /// Wahrscheinlichkeit pro Tag, einen Crash zu starten (während normal).
  final double crashChancePerDay;

  /// Wie viele Tage der Drawdown läuft.
  final int drawdownDuration;

  /// Minimaler/maximaler kumulierter Drop (positive Werte, z.B. 0.20…0.40).
  final double crashDepthMin;
  final double crashDepthMax;

  /// Wie viele Tage die Erholung läuft.
  final int recoveryDuration;

  /// Anteil des Drops, der zurückgeholt wird. 1.0 = volle Erholung,
  /// 0.3 = bleibt zum Großteil unter Wasser (Gold-Profil).
  final double recoveryFraction;
}

/// Default-Profile pro Klasse (Spec A.1 + B Tabellen).
/// **Balance-Analyse 2026-08 — `recoveryFraction` bitte mit Vorsicht senken.**
///
/// Der Anteil, mit dem ein Kurs nach dem Drawdown zurückkommt, ist kein
/// Stimmungsregler: alles unter 1,0 ist ein PERMANENTER Renditeabzug, der sich
/// mit jedem Crash-Zyklus wiederholt. Gemessen wurde vorher (Formel: pro
/// Zyklus `(1−tiefe/dauer)^dauer × (1+tiefe·anteil/erholdauer)^erholdauer`,
/// hochgerechnet auf die Zyklen pro Jahr):
///
///   Aktien −10,0 %/Jahr · Gold −3,4 % · Silber/Platin −4,4 % · Krypto −25,3 %
///
/// Damit war die geplante Rendite JEDER Klasse außer ETF vollständig
/// aufgefressen — Gold sollte mit +3,6 %/Jahr vor Inflation schützen und lag
/// bei null, Bitcoin sollte langfristig steigen und fiel. Die Anteile wurden
/// deshalb angehoben; ein spürbarer Malus gegenüber dem ETF bleibt gewollt,
/// aber er darf den Trend nicht umdrehen. Wer hier schraubt, rechnet den
/// Jahresabzug bitte neu durch.
abstract final class MarketProfiles {
  /// ETF: tiefer Drop, volle Erholung. Der Lategame-Held.
  static const etf = MarketPhaseProfile(
    classId: 'etf',
    crashChancePerDay: 0.004, // ~1× pro Jahr
    drawdownDuration: 12,
    crashDepthMin: 0.18,
    crashDepthMax: 0.34,
    recoveryDuration: 40,
    recoveryFraction: 1.0,
  );

  /// Einzelaktie: tief, höhere Crash-Chance, Erholung NICHT garantiert.
  /// (Pleite-Fall wird im Stock-Listener separat behandelt.)
  static const stock = MarketPhaseProfile(
    classId: 'stock',
    crashChancePerDay: 0.008,
    drawdownDuration: 14,
    crashDepthMin: 0.22,
    crashDepthMax: 0.48,
    recoveryDuration: 60,
    // War 0.85 (−10 %/Jahr), dann 0.95 (−4,1 %/Jahr). Auch das war zu viel:
    // die schwächste Aktie im Katalog trägt nur 6 %/Jahr Drift, also hätte
    // JEDE Einzelaktie dauerhaft unter dem ETF gelegen — die Aktien-Insel
    // wäre eine Falle ohne Gegenwert gewesen. Mit 0.98 bleiben −2,2 %/Jahr:
    // die schwächste Aktie landet unter dem ETF, die stärkste darüber. Genau
    // das ist die Lektion — eine Einzelaktie kann besser laufen als der Korb
    // oder schlechter, und sie kann pleitegehen (was der ETF nicht kann).
    recoveryFraction: 0.98,
  );

  /// Gold: flacher Drop, kaum Erholung. Ruhe-Anker, kein Performer.
  static const gold = MarketPhaseProfile(
    classId: 'gold',
    crashChancePerDay: 0.002,
    drawdownDuration: 8,
    crashDepthMin: 0.05,
    crashDepthMax: 0.12,
    recoveryDuration: 30,
    recoveryFraction: 0.9, // war 0.4 → hob den Inflationsschutz komplett auf
  );

  /// Silber: mittlerer Drop.
  static const silver = MarketPhaseProfile(
    classId: 'silver',
    crashChancePerDay: 0.003,
    drawdownDuration: 10,
    crashDepthMin: 0.10,
    crashDepthMax: 0.20,
    recoveryDuration: 35,
    recoveryFraction: 0.9, // war 0.7 → −4,4 %/Jahr Dauerabzug
  );

  /// Platin: mittlerer Drop.
  static const platin = MarketPhaseProfile(
    classId: 'platin',
    crashChancePerDay: 0.003,
    drawdownDuration: 10,
    crashDepthMin: 0.10,
    crashDepthMax: 0.20,
    recoveryDuration: 35,
    recoveryFraction: 0.9, // war 0.7 → −4,4 %/Jahr Dauerabzug
  );

  /// Krypto: hart und häufig, erholt sich nur teilweise (Spec-44 B).
  /// Crash-Profil bewusst aggressiver als ETF — Spieler soll das Risiko
  /// fühlen, ohne dass es wie Aktien wieder voll zurückkommt.
  static const crypto = MarketPhaseProfile(
    classId: 'crypto',
    // 0.005 waren ~1,5 Crashes pro Jahr. Bei 30–60 % Tiefe ist das mehr, als
    // ein Aufwärtstrend von +10 %/Jahr tragen kann, und weit mehr als das
    // reale Vorbild (ein großer Einbruch alle 2–3 Jahre). Jetzt ~0,7/Jahr —
    // seltener, dafür unverändert brutal.
    crashChancePerDay: 0.002,
    drawdownDuration: 10,
    crashDepthMin: 0.30,
    crashDepthMax: 0.60,
    recoveryDuration: 30,
    recoveryFraction: 0.85, // war 0.6 → −25 %/Jahr, drehte den Trend um
  );

  static const all = <MarketPhaseProfile>[
    etf,
    stock,
    gold,
    silver,
    platin,
    crypto,
  ];

  static MarketPhaseProfile? byId(String classId) {
    for (final p in all) {
      if (p.classId == classId) return p;
    }
    return null;
  }
}
