import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'stock.freezed.dart';
part 'stock.g.dart';

/// Static config for one fictive stock. Hardregel: keine echten Tickers.
class StockSpec {
  const StockSpec({
    required this.id,
    required this.name,
    required this.baseDriftPerDay,
    required this.volatility,
    required this.initialPrice,
    this.correlationGroup,
    this.bankruptcyChancePerYear = 0.01,
  });

  final String id;
  final String name;
  final double baseDriftPerDay;
  final double volatility;
  final Money initialPrice;
  final String? correlationGroup;

  /// Spec-44 A.1: jährliche Wahrscheinlichkeit, dass das Unternehmen
  /// pleitegeht. Ein pleitegegangenes Unternehmen erholt sich NIE —
  /// die Aktie bleibt dauerhaft bei ~1¢. Default 1 %/Jahr — der
  /// Kontrast zum diversifizierten ETF.
  final double bankruptcyChancePerYear;
}

abstract final class StockCatalog {
  // v29 round-2: realistisch — DAX-Range. WeltTec ≈ Tech-Riese SAP/MSFT,
  // MotoBawer ≈ BMW, NordOel ≈ Shell/Allianz.
  static const fluxon = StockSpec(
    id: 'aktie_fluxon',
    name: 'WeltTec AG',
    // Round 27 v4: baseDriftPerDay wird im StockPriceListener DIREKT
    // genutzt → 0.0025/Tag war +149 %/Jahr (über 5 J = ~90×!). Jetzt
    // 0.00026 ≈ +10 %/J (Wachstums-Tech). Vola 0.035 → 0.022 (~42 %/J).
    baseDriftPerDay: 0.00026,
    volatility: 0.022,
    initialPrice: Money.cents(35000), // 350 €
    correlationGroup: 'tech',
  );

  static const skyrail = StockSpec(
    id: 'aktie_skyrail',
    name: 'MotoBawer',
    // Round 27 v4: 0.0010/Tag (+44 %/J) → 0.00016 ≈ +6 %/J (Value/Auto).
    baseDriftPerDay: 0.00016,
    volatility: 0.015, // war 0.020
    initialPrice: Money.cents(9000), // 90 €
    correlationGroup: 'industrial',
  );

  static const novabank = StockSpec(
    id: 'aktie_novabank',
    name: 'NordOel & Gas',
    // Round 27 v4: 0.0015/Tag (+73 %/J) → 0.00019 ≈ +7 %/J (zyklisch).
    baseDriftPerDay: 0.00019,
    volatility: 0.020, // war 0.025
    initialPrice: Money.cents(45000), // 450 €
  );

  static const all = <StockSpec>[fluxon, skyrail, novabank];

  static StockSpec byId(String id) =>
      all.firstWhere((s) => s.id == id, orElse: () => fluxon);

  /// Untergrenze für den Tageskurs einer NICHT pleitegegangenen Aktie:
  /// 40 % des Startpreises — deckungsgleich mit der Untergrenze des
  /// Reseed-Bands im `StockRepository`.
  ///
  /// Vorher war der Floor pauschal 100 ¢. Ein langer Bären-/Crash-Lauf
  /// innerhalb EINES Zeitsprungs (der Reseed greift nur beim App-Start)
  /// konnte eine 350-€-Aktie auf 1 € drücken; dort kaufte man Zehntausende
  /// Stück für kleines Geld, und der Reseed beim nächsten Start hob den Kurs
  /// auf den Katalogwert → Millionen aus dem Nichts. Genau der Exploit, der
  /// bei ETF (+171) und Krypto (+173) schon geschlossen wurde.
  static int priceFloorCentsFor(StockSpec spec) =>
      (spec.initialPrice.cents * 0.4).round().clamp(1, 1 << 30);

  /// Obergrenze des Reseed-Bands (siehe `StockRepository.build`).
  static int priceCeilCentsFor(StockSpec spec) =>
      (spec.initialPrice.cents * 2.5).round().clamp(1, 1 << 30);

  /// Kurs einer pleitegegangenen Aktie. Da der Floor für lebende Aktien bei
  /// 40 % der Basis liegt, ist dieser Wert eindeutig — daran erkennt der
  /// Reseed eine Pleite, ohne dass ein Flag persistiert werden muss.
  static const int bankruptPriceCents = 1;

  /// Ø-Kaufpreis, unter dem ein Bestand zwingend aus dem Cent-Exploit
  /// stammt: 20 % des Startpreises liegt unter dem Preisband (40 %), war
  /// also nie legitim erreichbar.
  static int exploitAvgPriceThresholdCents(StockSpec spec) =>
      (spec.initialPrice.cents * 0.2).round();
}

@freezed
abstract class StockHolding with _$StockHolding {
  const factory StockHolding({
    required String stockId,
    required int shares,
    @MoneyConverter() required Money averageBuyPrice,

    /// Spec-44 A.1: ist das zugrundeliegende Unternehmen pleite?
    /// Holding bleibt sichtbar (für die Lehrwirkung), aber wertlos.
    /// Bankrupt-Holdings können nur noch für ~1¢/Aktie verkauft
    /// werden ("Notverkauf").
    @Default(false) bool bankrupt,
  }) = _StockHolding;

  factory StockHolding.fromJson(Map<String, dynamic> json) =>
      _$StockHoldingFromJson(json);
}

@freezed
abstract class StockQuote with _$StockQuote {
  const factory StockQuote({
    required String stockId,
    @MoneyConverter() required Money pricePerShare,
    required int onDayIndex,
  }) = _StockQuote;

  factory StockQuote.fromJson(Map<String, dynamic> json) =>
      _$StockQuoteFromJson(json);
}
