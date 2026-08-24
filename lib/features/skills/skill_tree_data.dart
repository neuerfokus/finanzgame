/// Round 28: Skill-Baum (Fähigkeitsbaum).
///
/// Pro Level erhält der Spieler 1 Skill-Punkt (verfügbar = Level − Anzahl
/// freigeschalteter Knoten). Knoten schalten **Mechaniken / Komfort** oder
/// **Lern-Botschaften** frei — NIEMALS einen Rendite-Boost (kein „Markt
/// besiegen"). Jeder Knoten trägt eine kindgerechte Lern-Botschaft.
///
/// 3 Zweige × 4 Stufen. Eine Stufe ist erst wählbar, wenn die vorherige
/// Stufe im selben Zweig freigeschaltet ist (Tier-Gate). Vier Knoten haben
/// einen echten Mechanik-Effekt (siehe [SkillEffects]); der Rest sind
/// Wissens-Knoten, die als Tier-Gate dienen + ein Konzept erklären.
library;

enum SkillBranch {
  spar('🌱', 'Sparen'),
  invest('📈', 'Investieren'),
  schutz('🛡️', 'Schützen');

  const SkillBranch(this.emoji, this.label);
  final String emoji;
  final String label;
}

class SkillNode {
  const SkillNode({
    required this.id,
    required this.branch,
    required this.tier,
    required this.emoji,
    required this.title,
    required this.lern,
    this.effect,
    this.cost = 1,
  });

  final String id;
  final SkillBranch branch;

  /// 1..4 für Kern-Knoten, 5 für Prestige/Meister-Knoten.
  final int tier;
  final String emoji;
  final String title;

  /// Kindgerechte Lern-Botschaft, gezeigt beim Freischalten.
  final String lern;

  /// Beschreibung des Mechanik-Effekts (null = reiner Wissens-Knoten).
  final String? effect;

  /// Anzahl Skill-Punkte, die das Freischalten kostet. Kern = 1,
  /// Prestige-Knoten = mehrere (Punkte-Senke fürs Endgame).
  final int cost;

  bool get hasEffect => effect != null;

  /// Tier 5 = Prestige/Meister-Knoten (separates Panel, höhere Kosten).
  bool get isPrestige => tier >= 5;
}

/// Skill-IDs mit echtem Mechanik-Effekt — an den jeweiligen Feature-Stellen
/// via `settings.hasSkill(SkillEffects.xxx)` geprüft. Reine Komfort-/Info-
/// Freischaltungen, kein Rendite-Vorteil.
abstract final class SkillEffects {
  /// Pay-yourself-first-Slider darf bis 75 % statt 50 %.
  static const String paySliderHighCap = 'spar_routine';

  /// Ein zusätzlicher Gratis-Plot auf der Sparinsel.
  static const String bonusPlot = 'invest_plot';

  /// Panik-Verkauf-Warnung greift immer (niedrigere Verlust-Schwelle).
  static const String panicGuardAlways = 'schutz_cool';

  /// Wochen-Report-Export-Button in den Einstellungen sichtbar.
  static const String weeklyReport = 'schutz_report';

  /// Prestige (Round 28 v4): noch ein zusätzliches Gratis-Beet auf der
  /// Sparinsel (stapelt mit [bonusPlot]).
  static const String bonusPlot2 = 'spar_grossmeister';
}

const List<SkillNode> kSkillNodes = <SkillNode>[
  // ── Sparen 🌱 ────────────────────────────────────────────────────────
  SkillNode(
    id: 'spar_notgroschen',
    branch: SkillBranch.spar,
    tier: 1,
    emoji: '🐷',
    title: 'Notgroschen-Denker',
    lern: 'Bevor du investierst: leg dir einen Notgroschen zurück — '
        'genug Geld für ein paar Monate. Geht etwas kaputt, musst du '
        'dann nichts mit Verlust verkaufen.',
  ),
  SkillNode(
    id: SkillEffects.paySliderHighCap, // 'spar_routine'
    branch: SkillBranch.spar,
    tier: 2,
    emoji: '📅',
    title: 'Sparroutine',
    lern: 'Pay yourself first: spare ZUERST einen festen Teil, gib erst '
        'danach aus. Aus Gewohnheit wird Vermögen.',
    effect: 'Spar-zuerst-Schieberegler geht jetzt bis 75 % statt 50 %.',
  ),
  SkillNode(
    id: 'spar_zinseszins',
    branch: SkillBranch.spar,
    tier: 3,
    emoji: '🪙',
    title: 'Zinseszins-Versteher',
    lern: 'Zinsen bringen wieder Zinsen. Wer früh anfängt, gewinnt mehr '
        'durch Zeit als durch hohe Beträge. Geduld ist dein Turbo.',
  ),
  SkillNode(
    id: 'spar_kapitaen',
    branch: SkillBranch.spar,
    tier: 4,
    emoji: '⚓',
    title: 'Spar-Kapitän',
    lern: 'Du hältst Kurs, auch wenn andere ihr Geld sofort ausgeben. '
        'Ruhig sparen schlägt hektisch kaufen.',
  ),

  // ── Investieren 📈 ───────────────────────────────────────────────────
  SkillNode(
    id: 'invest_streuen',
    branch: SkillBranch.invest,
    tier: 1,
    emoji: '🧺',
    title: 'Streuer',
    lern: 'Nicht alle Eier in einen Korb! Wer breit streut (z. B. ein '
        'ETF mit vielen Firmen), verliert nicht alles, wenn eine Firma '
        'schwächelt.',
  ),
  SkillNode(
    id: 'invest_langfrist',
    branch: SkillBranch.invest,
    tier: 2,
    emoji: '🌅',
    title: 'Langfrist-Denker',
    lern: 'Kurse schwanken täglich — das ist normal. Über viele Jahre '
        'ging es bisher meist aufwärts. Drin bleiben schlägt nervös '
        'rein und raus.',
  ),
  SkillNode(
    id: SkillEffects.bonusPlot, // 'invest_plot'
    branch: SkillBranch.invest,
    tier: 3,
    emoji: '🌱',
    title: 'Grüner Daumen',
    lern: 'Gewinne wieder anlegen (reinvestieren) lässt dein Geld '
        'schneller wachsen. Du hast dir ein extra Beet verdient.',
    effect: '+1 Gratis-Beet auf der Sparinsel.',
  ),
  SkillNode(
    id: 'invest_meister',
    branch: SkillBranch.invest,
    tier: 4,
    emoji: '📈',
    title: 'Invest-Meister',
    lern: 'Du kennst den Unterschied zwischen Sparen und Investieren und '
        'weißt: Rendite gibt es nur mit etwas Risiko und viel Geduld.',
  ),

  // ── Schützen 🛡️ ──────────────────────────────────────────────────────
  SkillNode(
    id: 'schutz_versichern',
    branch: SkillBranch.schutz,
    tier: 1,
    emoji: '🧯',
    title: 'Absicherer',
    lern: 'Manche Risiken sind zu groß zum Selbsttragen. Eine '
        'Versicherung kostet wenig und schützt vor seltenen, teuren '
        'Schäden.',
  ),
  SkillNode(
    id: SkillEffects.panicGuardAlways, // 'schutz_cool'
    branch: SkillBranch.schutz,
    tier: 2,
    emoji: '🧊',
    title: 'Cooler Kopf',
    lern: 'Wenn Kurse fallen, wollen viele in Panik verkaufen — und '
        'machen Verluste echt. Wer ruhig bleibt, fährt meist besser.',
    effect: 'Die Panik-Verkauf-Warnung passt jetzt früher auf dich auf.',
  ),
  SkillNode(
    id: 'schutz_steuer',
    branch: SkillBranch.schutz,
    tier: 3,
    emoji: '🧾',
    title: 'Steuer-Checker',
    lern: 'Auf Gewinne zahlt man Steuern — aber bis 1.000 € im Jahr '
        'bleiben mit dem Freistellungsauftrag steuerfrei. Kleiner '
        'Handgriff, echtes Geld gespart.',
  ),
  SkillNode(
    id: SkillEffects.weeklyReport, // 'schutz_report'
    branch: SkillBranch.schutz,
    tier: 4,
    emoji: '📋',
    title: 'Überblicker',
    lern: 'Wer regelmäßig auf sein Geld schaut, behält die Kontrolle. '
        'Du kannst jetzt einen Wochen-Report teilen.',
    effect: 'Wochen-Report-Export in den Einstellungen freigeschaltet.',
  ),
];

/// Round 28 v4: Prestige-/Meister-Knoten. Eigene Liste (Kern-Baum bleibt 12
/// Knoten). Jeder kostet [prestigeCost] Punkte → sinnvolle Senke fürs
/// Endgame statt verfallender Punkte. Wählbar erst, wenn der ganze Zweig
/// (alle 4 Kern-Stufen) gemeistert ist. Gibt beim Freischalten viel XP +
/// eine Prestige-Trophäe (siehe SkillTreePage).
const int prestigeCost = 4;

const List<SkillNode> kPrestigeNodes = <SkillNode>[
  SkillNode(
    id: SkillEffects.bonusPlot2, // 'spar_grossmeister'
    branch: SkillBranch.spar,
    tier: 5,
    emoji: '🏆',
    title: 'Spar-Großmeister',
    lern: 'Du hast das Sparen gemeistert: erst zur Seite legen, dann '
        'ausgeben, und die Zeit für dich arbeiten lassen. Als Belohnung '
        'wächst dein Garten weiter.',
    effect: 'Noch +1 Gratis-Beet auf der Sparinsel (zusätzlich).',
    cost: prestigeCost,
  ),
  SkillNode(
    id: 'invest_grossmeister',
    branch: SkillBranch.invest,
    tier: 5,
    emoji: '🦉',
    title: 'Invest-Großmeister',
    lern: 'Breit streuen, langfristig denken, Schwankungen aushalten — du '
        'investierst wie die Profis: ruhig, geduldig, regelmäßig. Kein '
        'Glücksspiel, sondern ein Plan.',
    cost: prestigeCost,
  ),
  SkillNode(
    id: 'schutz_grossmeister',
    branch: SkillBranch.schutz,
    tier: 5,
    emoji: '🛡️',
    title: 'Schutz-Großmeister',
    lern: 'Notgroschen, Versicherung gegen große Risiken, Steuern im Griff '
        'und ein kühler Kopf in der Krise. Du schützt, was du aufgebaut '
        'hast — das ist halbes Reichwerden.',
    cost: prestigeCost,
  ),
];

/// Kern- + Prestige-Knoten zusammen.
List<SkillNode> get allSkillNodes => [...kSkillNodes, ...kPrestigeNodes];

SkillNode? prestigeForBranch(SkillBranch branch) {
  for (final n in kPrestigeNodes) {
    if (n.branch == branch) return n;
  }
  return null;
}

/// Punkte-Kosten einer Knoten-ID. Kern = 1, Prestige = [prestigeCost],
/// eingelöste Punkte (`redeem_*`) = 1, Unbekanntes = 1.
int skillCost(String id) {
  for (final n in allSkillNodes) {
    if (n.id == id) return n.cost;
  }
  return 1;
}

/// Summe der ausgegebenen Punkte (Kosten je freigeschalteter Knoten +
/// eingelöste Punkte). Basis für `availableSkillPoints = Level − spent`.
int spentSkillPoints(Set<String> unlocked) {
  var spent = 0;
  for (final id in unlocked) {
    spent += skillCost(id);
  }
  return spent;
}

List<SkillNode> skillsForBranch(SkillBranch branch) =>
    kSkillNodes.where((n) => n.branch == branch).toList()
      ..sort((a, b) => a.tier.compareTo(b.tier));

/// Prestige-Knoten ist wählbar, wenn er noch nicht freigeschaltet ist UND
/// der ganze zugehörige Kern-Zweig gemeistert wurde.
bool isPrestigeUnlockable(SkillNode node, Set<String> unlocked) =>
    !unlocked.contains(node.id) && branchComplete(node.branch, unlocked);

/// True wenn alle 3 Prestige-Knoten freigeschaltet sind.
bool prestigeComplete(Set<String> unlocked) =>
    kPrestigeNodes.every((n) => unlocked.contains(n.id));

/// True wenn Kern-Baum UND Prestige komplett — dann gibt es wirklich nichts
/// mehr zu kaufen → Restpunkte einlösbar.
bool everythingComplete(Set<String> unlocked) =>
    treeComplete(unlocked) && prestigeComplete(unlocked);

/// Round 28 v2: Abschluss-Belohnungen + Punkte-Senke.
///
/// Ein voller Zweig bzw. der ganze Baum gibt einmalig XP + Cash + eine
/// Trophäe. Übrige Skill-Punkte (sobald nichts mehr zu lernen ist) lassen
/// sich in Taschengeld einlösen, damit kein Punkt verfällt.
abstract final class SkillRewards {
  static const int branchCompleteXp = 200;
  static const int branchCompleteCents = 1500; // 15 €
  static const int treeCompleteXp = 500;
  static const int treeCompleteCents = 5000; // 50 €

  /// Round 28 v4: Prestige-Knoten freischalten → viel XP + Cash.
  static const int prestigeNodeXp = 400;
  static const int prestigeNodeCents = 3000; // 30 €

  /// Mindest-Einlöse-Wert je übrigem Skill-Punkt (Floor).
  static const int redeemCentsPerPoint = 500; // 5 €

  /// Obergrenze je Punkt (Round 28 v4 Review): ohne Deckel ergäbe der
  /// Vermögens-Term bei einem Millionär ~1.000 €/Punkt, bei extremem Horten
  /// noch mehr → würde die späte Ökonomie trivialisieren. 1.000 €/Punkt ist
  /// großzügig, aber gedeckelt.
  static const int redeemCentsPerPointCap = 100000; // 1.000 €

  /// Round 28 v4: Einlöse-Wert je Punkt skaliert mit Level UND Vermögen —
  /// im Endgame bringt ein Punkt deutlich mehr als die alten fixen 5 €.
  /// 2 € pro Level + 0,1 % des Netto-Vermögens, gedeckelt auf
  /// [[redeemCentsPerPoint], [redeemCentsPerPointCap]]. Zusätzlich durch die
  /// wenigen Restpunkte begrenzt (max ≈ Level − Knotenkosten) → kein
  /// Dauer-Geldhahn.
  static int redeemPointValueCents({
    required int level,
    required int netWorthCents,
  }) {
    final scaled = level * 200 + (netWorthCents ~/ 1000);
    return scaled.clamp(redeemCentsPerPoint, redeemCentsPerPointCap);
  }
}

/// Trophäen-ID pro Zweig (`skilltree_spar` …) bzw. Gesamt-Baum.
String branchTrophyId(SkillBranch b) => 'skilltree_${b.name}';
const String treeTrophyId = 'skilltree_master';

/// Round 28 v4: Trophäe wenn alle 3 Prestige-Knoten gemeistert sind.
const String prestigeTrophyId = 'skilltree_prestige';

/// True wenn ALLE Knoten eines Zweigs freigeschaltet sind.
bool branchComplete(SkillBranch b, Set<String> unlocked) =>
    skillsForBranch(b).every((n) => unlocked.contains(n.id));

/// True wenn ALLE 12 Knoten freigeschaltet sind.
bool treeComplete(Set<String> unlocked) =>
    kSkillNodes.every((n) => unlocked.contains(n.id));

/// Präfix der synthetischen „eingelöste Punkte"-IDs. Diese liegen in der
/// gleichen CSV wie echte Skills und zählen so automatisch gegen die
/// verfügbaren Punkte — keine extra Drift-Spalte nötig.
const String kRedeemPrefix = 'redeem_';

/// Anzahl bereits eingelöster Restpunkte.
int redeemedCount(Set<String> unlocked) =>
    unlocked.where((s) => s.startsWith(kRedeemPrefix)).length;

/// Vorgänger-Knoten (eine Stufe tiefer im selben Zweig) oder null bei Tier 1.
SkillNode? predecessorOf(SkillNode node) {
  if (node.tier <= 1) return null;
  for (final n in kSkillNodes) {
    if (n.branch == node.branch && n.tier == node.tier - 1) return n;
  }
  return null;
}

/// Wählbar, wenn nicht schon freigeschaltet UND (Tier 1 ODER Vorgänger
/// freigeschaltet). Die Punkte-Prüfung passiert separat im Repository.
bool isNodeUnlockable(SkillNode node, Set<String> unlocked) {
  if (unlocked.contains(node.id)) return false;
  final pred = predecessorOf(node);
  if (pred == null) return true;
  return unlocked.contains(pred.id);
}
