import '../domain/economy/money.dart';
import '../domain/plant/plant.dart';
import '../domain/stock/stock.dart';
import '../domain/wishlist/wish_item.dart';

/// Centralised game-balance constants.
///
/// **Single source of truth for tuning.** When testing with the player,
/// adjust here first and re-derive any per-asset specs that should follow.
/// Each value either matches the live default of a feature constant or
/// re-exports it (one indirection so the per-feature catalogs can stay as
/// "owner of the typed shape" while tuning happens in one file).
abstract final class GameBalance {
  // ── Allowance (spec-32: monthly cadence) ───────────────────────────────
  /// Monthly Taschengeld. 80 € — feels like a real-world amount for a
  /// 13-year-old.
  static const Money weeklyAllowance = Money.cents(8000);

  // ── Sleep cost (Spec-20) ──────────────────────────────────────────────
  /// Basis-Snackgeld pro Schlaf-Tag (Level 0). Spec-43 v9: 100 ¢ (= 1,00 €)
  /// realistic Schul-Snack. 1 €/Tag = 30 €/Monat passt zum Allowance-Cap
  /// 80 €/Monat.
  static const int sleepCostCents = 100;

  /// Round 28 v4 (User-Wunsch): Essen/Snacks werden mit steigendem Level
  /// teurer — der Spieler wird älter und isst mehr/besser. 1 € Basis +
  /// 0,15 € pro Level → ~10 € bei Level 60. Bei niedrigem Cash greift
  /// weiter der Hunger-Pfad (Konsequenz statt Game-Over).
  static const int sleepCostPerLevelCents = 15;
  static int sleepCostCentsFor(int level) =>
      sleepCostCents + (level < 0 ? 0 : level) * sleepCostPerLevelCents;

  // ── Plant-Daily-Cap (spec-balance-didaktik Sprint A) ────────────────
  /// Maximaler Pflanzen-Ertrag pro Spieltag in Cents, PRO BESITZ-PLOT.
  /// Skaliert mit Aufwand: mehr Plots gekauft = mehr Decke pro Tag.
  ///
  /// 50 ¢/plot/Tag — Beispiel:
  ///  4 plots →   200 ¢/Tag (2,00 €)
  ///  8 plots →   400 ¢/Tag (4,00 €)
  /// 12 plots →   600 ¢/Tag (6,00 €) ≈ 2.190 €/Jahr
  ///
  /// Crossover-Schwelle (ETF beats Pflanzen-Decke) bei ~27k € ETF-Kapital
  /// (8 %/J Drift, voller Plot-Ausbau). Lategame-Passiv-Investieren bleibt
  /// die stärkere Wachstumsquelle, aber Pflanzen lohnen sich jetzt
  /// proportional zum Investment in Plots.
  static const int plantDailyYieldCapPerPlotCents = 50;

  /// Backward-compat: Default-Cap bei 4 Plots (Onboarding-Stand).
  /// Real benutzt der PlantRepository den per-Plot-Cap × Plot-Count.
  static const int plantDailyYieldCapCents = 200;

  /// Crossover-Kapital-Schwelle (ETF-Wert, ab dem passiver Ertrag die
  /// Pflanzen-Decke übersteigt). 8 %/J × 6.900 € ≈ 552 € > Cap.
  static const int passiveBeatsActiveCapitalCents = 690000;

  // ── Plants (Elefantenfuß = Sprint-5 baseline) ─────────────────────────
  static Money get plantElephantsfootCost => PlantKinds.elephantsfoot.cost;
  static Money get plantElephantsfootYield => PlantKinds.elephantsfoot.yield_;
  static int get plantElephantsfootGrowDays =>
      PlantKinds.elephantsfoot.growDays;

  // Round 27 v8: ETF-Drift-Getter entfernt — EtfSpec.baseDriftPerDay war
  // toter Code (Listener nutzt Year-Regime). Stock-Drift wird weiter
  // genutzt (StockPriceListener nutzt baseDriftPerDay direkt).

  // ── Stocks (Sprint-9) ─────────────────────────────────────────────────
  static double get stockFluxonDrift => StockCatalog.fluxon.baseDriftPerDay;
  static double get stockSkyrailDrift => StockCatalog.skyrail.baseDriftPerDay;
  static double get stockNovabankDrift =>
      StockCatalog.novabank.baseDriftPerDay;

  // ── Crash ─────────────────────────────────────────────────────────────
  // Die Sprint-9-Konstanten (2 %/Tag, −20..50 %) sind mit der alten
  // Crash-Stage entfallen. Crash-Parameter stehen jetzt pro Anlageklasse in
  // `MarketProfiles` (domain/sim/market_phase.dart) — inkl. Erholungsphase.

  // ── Inflation (Sprint-8) ──────────────────────────────────────────────
  static double get inflationDailyRate => InflationConfig.dailyRate;

  // ── Lifetime cap (spec-26) ────────────────────────────────────────────
  static const int startAgeYears = 13;
  static const int maxAgeYears = 80;

  /// Days lived between default [startAgeYears] und [maxAgeYears].
  /// Achtung: User kann startAgeYears in Onboarding ändern. Verwende
  /// [maxDayIndexFor] wenn der echte startAge bekannt ist.
  static const int maxDayIndex = (maxAgeYears - startAgeYears) * 365;

  /// Liefert den maxDayIndex für einen abweichenden startAge.
  /// Hält das Spielende bei Alter 80 unabhängig vom Startalter.
  static int maxDayIndexFor(int startAge) =>
      (maxAgeYears - startAge) * 365;
}
