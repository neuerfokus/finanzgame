/// Spec-45 H3: Mischwald-Sub-Mechanik (Wald-Wirtschaft).
///
/// Bäume sind passive Income-Anlagen mit langem Reife-Zyklus.
/// Anders als Spar-Insel-Pflanzen:
/// - Reift in Wochen statt Tagen
/// - Liefert TÄGLICH Holz/Harz statt einmaliger Ernte
/// - Bleibt produktiv über Jahre (kein Re-Plant)
/// - Sturm-Risiko geringer (Bäume sind robuster)
///
/// Didaktik: Geduld-Lehre. Hohe Anfangskosten, lange Wartezeit, dann
/// stabiles passives Einkommen. Wie ein realer Obstbaum.
library;

import '../economy/money.dart';

enum TreeKind { birke, eiche, pinie }

class TreeSpec {
  const TreeSpec({
    required this.kind,
    required this.displayName,
    required this.emoji,
    required this.cost,
    required this.maturityDays,
    required this.dailyYield,
  });

  final TreeKind kind;
  final String displayName;
  final String emoji;
  /// Kaufpreis beim Pflanzen.
  final Money cost;
  /// Tage bis Baum erstmals Holz produziert.
  final int maturityDays;
  /// Cents pro Tag nach Reife (gedeckelt — Wetter modifiziert wie bei
  /// Pflanzen).
  final Money dailyYield;
}

abstract final class TreeCatalog {
  // Welle-8 Round 22 v5: Realistisch — Bäume wachsen lange (Real:
  // Birke 50J Umtrieb, Pinie 80J, Eiche 150J). ROI/Jahr ab Reife
  // ca. 5-7 %/J = Real-Wald. Maturity in Spieljahren ist
  // Time-Compression aber lang genug damit "Bäume = Geduld" rüberkommt.
  static const birke = TreeSpec(
    kind: TreeKind.birke,
    displayName: 'Birke',
    emoji: '🌳',
    cost: Money.cents(5000),        // 50 €
    maturityDays: 365,              // 1 Spieljahr (real ~50 J)
    dailyYield: Money.cents(1),     // 1 ¢/Tag → 3,65 €/J → 7,3 %/J ab Reife
  );

  static const eiche = TreeSpec(
    kind: TreeKind.eiche,
    displayName: 'Eiche',
    emoji: '🌲',
    cost: Money.cents(50000),       // 500 €
    maturityDays: 1825,             // 5 Spieljahre (real ~150 J)
    dailyYield: Money.cents(8),     // 8 ¢/Tag → 29,20 €/J → 5,8 %/J
  );

  static const pinie = TreeSpec(
    kind: TreeKind.pinie,
    displayName: 'Pinie',
    emoji: '🎄',
    cost: Money.cents(20000),       // 200 €
    maturityDays: 730,              // 2 Spieljahre (real ~80 J)
    dailyYield: Money.cents(3),     // 3 ¢/Tag → 10,95 €/J → 5,5 %/J
  );

  static const all = <TreeSpec>[birke, eiche, pinie];

  static TreeSpec spec(TreeKind k) => switch (k) {
        TreeKind.birke => birke,
        TreeKind.eiche => eiche,
        TreeKind.pinie => pinie,
      };
}

/// Ein gepflanzter Baum auf der Mischwald-Insel.
class PlantedTree {
  const PlantedTree({
    required this.id,
    required this.kind,
    required this.plantedOnDayIndex,
  });

  final String id;
  final TreeKind kind;
  final int plantedOnDayIndex;

  bool isMature(int currentDayIndex) {
    final spec = TreeCatalog.spec(kind);
    return (currentDayIndex - plantedOnDayIndex) >= spec.maturityDays;
  }

  int daysUntilMature(int currentDayIndex) {
    final spec = TreeCatalog.spec(kind);
    final left = spec.maturityDays - (currentDayIndex - plantedOnDayIndex);
    return left < 0 ? 0 : left;
  }

  /// Reifegrad 0..1 — wie weit der Baum gewachsen ist.
  double growthRatio(int currentDayIndex) {
    final spec = TreeCatalog.spec(kind);
    if (spec.maturityDays <= 0) return 1.0;
    final grown = (currentDayIndex - plantedOnDayIndex) / spec.maturityDays;
    return grown.clamp(0.0, 1.0);
  }

  /// Verkehrswert beim Fällen: der Anschaffungswert anteilig zum Reifegrad,
  /// plus ein Monatsertrag als Holzerlös.
  ///
  /// **Vorher zahlte das Fällen NUR `30 × Tagesertrag`** — eine Eiche für
  /// 500 € brachte 2,40 €, eine Birke für 50 € brachte 0,30 €. Das Kapital
  /// war damit unwiederbringlich weg, und weil Bäume im Vermögen zum
  /// Anschaffungswert zählen, sackte das Vermögen beim Fällen um fast den
  /// vollen Kaufpreis ab. Der Wald war eine Einbahnstraße: rein kam man, raus
  /// nicht.
  ///
  /// Ein Baum ist aber kein Verbrauchsgut — im Preis steckt das Grundstück,
  /// und das Holz wird mit den Jahren mehr wert, nicht weniger. Ein
  /// ausgewachsener Baum bringt jetzt also ungefähr sein Geld zurück, ein
  /// halb gewachsener die Hälfte. Wer zu früh fällt, verliert echtes Geld —
  /// das ist die Lektion, die bleiben soll (Geduld zahlt sich aus), nur eben
  /// nicht als Totalverlust.
  Money fellingValue(int currentDayIndex) {
    final spec = TreeCatalog.spec(kind);
    final land = (spec.cost.cents * growthRatio(currentDayIndex)).round();
    final wood = spec.dailyYield.cents * 30;
    return Money.cents(land + wood);
  }
}
