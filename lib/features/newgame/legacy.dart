import '../xp/level_titles.dart';

/// Welle B: Vermächtnis-Prestige.
///
/// Jeder abgeschlossene Run (Lebens-Ende → neuer Run) bringt permanente
/// **Legacy-Punkte (LP)**, die über alle Generationen erhalten bleiben.
/// LP kaufen permanente **Vermächtnis-Upgrades** — reine QoL-/Start-Boni,
/// KEIN Markt-Cheat (keine +%-Rendite). Sie geben jedem neuen Run einen
/// Vorsprung, ohne das eigentliche Anlage-Ergebnis zu manipulieren.
class LegacyUpgrade {
  const LegacyUpgrade({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.cost,
  });

  final String id;
  final String emoji;
  final String title;

  /// Kindgerechte Erklärung, was das Upgrade dauerhaft bringt.
  final String description;

  /// LP-Kosten (einmalig).
  final int cost;
}

/// IDs als Konstanten, damit Effekt-Abfragen typsicher bleiben.
class LegacyEffects {
  const LegacyEffects._();

  /// Erbschafts-Cap pro Run heben (1.000 € → 3.000 €).
  static const inheritance = 'legacy_inheritance';

  /// +100 € Start-Cash bei JEDEM neuen Run.
  static const startCash = 'legacy_startcash';

  /// +250 Start-XP bei JEDEM neuen Run (schnelleres Unlocken).
  static const startXp = 'legacy_startxp';

  /// +1 dauerhaftes Start-Beet auf der Spar-Insel.
  static const plot = 'legacy_plot';
}

/// Vermächtnis-Shop-Katalog. Bewusst klein + bedeutungsvoll.
const kLegacyUpgrades = <LegacyUpgrade>[
  LegacyUpgrade(
    id: LegacyEffects.startXp,
    emoji: '⚡',
    title: 'Früher Funke',
    description: 'Jedes neue Leben startet mit +250 XP. Du schaltest '
        'Inseln und Skills schneller frei.',
    cost: 1,
  ),
  LegacyUpgrade(
    id: LegacyEffects.startCash,
    emoji: '💶',
    title: 'Startkapital',
    description: 'Jedes neue Leben startet mit +100 € auf dem Konto. '
        'Mehr Anlauf zum Investieren.',
    cost: 2,
  ),
  LegacyUpgrade(
    id: LegacyEffects.inheritance,
    emoji: '🎁',
    title: 'Großes Erbe',
    description: 'Die Erbschaft am Lebens-Ende kann jetzt bis 3.000 € '
        'betragen (statt 1.000 €). Erfolg zahlt sich über Generationen aus.',
    cost: 2,
  ),
  LegacyUpgrade(
    id: LegacyEffects.plot,
    emoji: '🌱',
    title: 'Familienbeet',
    description: 'Ein zusätzliches Beet auf der Spar-Insel — dauerhaft, '
        'in jedem Leben.',
    cost: 3,
  ),
];

LegacyUpgrade? legacyUpgradeById(String id) {
  for (final u in kLegacyUpgrades) {
    if (u.id == id) return u;
  }
  return null;
}

/// Erbschafts-Cap in Cent — 1.000 € normal, 3.000 € mit „Großes Erbe".
int legacyInheritanceCapCents(Set<String> owned) =>
    owned.contains(LegacyEffects.inheritance) ? 300000 : 100000;

/// Flat Start-Cash in Cent aus gekauften Upgrades.
int legacyStartCashCents(Set<String> owned) =>
    owned.contains(LegacyEffects.startCash) ? 10000 : 0;

/// Flat Start-XP aus gekauften Upgrades.
int legacyStartXp(Set<String> owned) =>
    owned.contains(LegacyEffects.startXp) ? 250 : 0;

/// Dauerhafte Bonus-Beete aus gekauften Upgrades.
int legacyStartPlots(Set<String> owned) =>
    owned.contains(LegacyEffects.plot) ? 1 : 0;

/// Summe der LP-Kosten der gekauften Upgrades (= ausgegebene Punkte).
int legacySpentPoints(Set<String> owned) {
  var sum = 0;
  for (final id in owned) {
    sum += legacyUpgradeById(id)?.cost ?? 0;
  }
  return sum;
}

/// LP-Ausbeute eines abgeschlossenen Runs.
///
/// 1 LP je 100.000 € Netto-Vermögen + 2 LP Millionärs-Bonus + 1 LP je
/// 10 erreichte Level. Mindestens 1 (Run-Abschluss lohnt immer),
/// maximal 20 (kein Run-Stacking ins Absurde).
int legacyPointsForRun({required int netWorthCents, required int finalXp}) {
  var lp = netWorthCents ~/ 10000000; // 1 LP / 100.000 €
  if (netWorthCents >= 100000000) lp += 2; // Millionär
  lp += LevelSystem.levelFor(finalXp) ~/ 10; // 1 LP / 10 Level
  if (lp < 1) return 1;
  if (lp > 20) return 20;
  return lp;
}
