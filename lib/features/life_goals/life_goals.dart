/// Round 28 v4: Lebensziele-Leiter — Langzeit-Endgame.
///
/// Wenn alle Inseln + Skills frei sind und viel Geld da ist, fehlten bis
/// Level 60 große Ziele. Lebensziele sind eine kuratierte Kette weit
/// gesteckter Meilensteine (Jahre durchhalten, finanziell frei werden,
/// breit gestreut bleiben). Jedes gibt viel XP + Cash + eine eigene
/// Trophäe und ist absichtlich langfristig — Geduld + Langfristigkeit sind
/// die didaktische Botschaft.
///
/// Persistenz + Idempotenz laufen über die generische
/// `AchievementsRepository` (id → Tag). Die IDs liegen NICHT in
/// `kAchievements` — Lebensziele haben eine eigene Seite, keine Trophäen-
/// wand-Kachel.
library;

/// Momentaufnahme des Spielstands für die Lebensziel-Auswertung.
class LifeGoalSnapshot {
  const LifeGoalSnapshot({
    required this.netWorthCents,
    required this.daysPlayed,
    required this.ageYears,
    required this.level,
    required this.assetClassCount,
    required this.streakDays,
  });

  final int netWorthCents;
  final int daysPlayed;
  final int ageYears;
  final int level;
  final int assetClassCount;
  final int streakDays;
}

class LifeGoal {
  const LifeGoal({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.cashCents,
    required this.met,
    required this.progressLabel,
    this.unreachableWhen,
  });

  final String id;
  final String emoji;
  final String title;
  final String description;
  final int xpReward;
  final int cashCents;

  /// Ist das Ziel mit diesem Snapshot erreicht?
  final bool Function(LifeGoalSnapshot) met;

  /// Kurzer Fortschritts-Text (z. B. „3/10 Jahre").
  final String Function(LifeGoalSnapshot) progressLabel;

  /// Optional: Ziel ist mit diesem Snapshot dauerhaft NICHT mehr erreichbar
  /// (z. B. ein Altersfenster ist vorbei). Nur für zeit-/altersgebundene
  /// Ziele gesetzt; cumulative Ziele lassen es null (immer erreichbar).
  final bool Function(LifeGoalSnapshot)? unreachableWhen;

  /// True wenn das Ziel verpasst ist (Fenster vorbei). met() hat Vorrang —
  /// ein bereits erreichtes Ziel gilt nie als unerreichbar.
  bool isUnreachable(LifeGoalSnapshot s) =>
      !met(s) && (unreachableWhen?.call(s) ?? false);
}

/// Reihenfolge = Anzeige-Reihenfolge (leicht → schwer).
final List<LifeGoal> kLifeGoals = <LifeGoal>[
  LifeGoal(
    id: 'life_diversified',
    emoji: '🌍',
    title: 'Welt-Portfolio',
    description: 'Halte gleichzeitig 6 verschiedene Anlage-Klassen '
        '(z. B. Sparbuch, ETF, Aktie, Gold, Krypto, Immobilie). Breit '
        'gestreut = ruhig schlafen.',
    xpReward: 500,
    cashCents: 5000,
    met: (s) => s.assetClassCount >= 6,
    progressLabel: (s) => '${s.assetClassCount.clamp(0, 6)}/6 Anlage-Klassen',
  ),
  LifeGoal(
    id: 'life_decade',
    emoji: '🗓',
    title: 'Durchhalter',
    description: 'Spiele 10 Spieljahre durch. Vermögen baut man nicht in '
        'einer Woche auf — Dranbleiben ist die halbe Miete.',
    xpReward: 800,
    cashCents: 10000,
    met: (s) => s.daysPlayed >= 3650,
    progressLabel: (s) => '${(s.daysPlayed / 365).floor()}/10 Jahre',
  ),
  LifeGoal(
    id: 'life_two_decades',
    emoji: '🗿',
    title: 'Zwei Jahrzehnte',
    description: 'Spiele 20 Spieljahre durch. Echte Ausdauer — so entsteht '
        'mit Zinseszins über die Zeit ein Vermögen.',
    xpReward: 1200,
    cashCents: 15000,
    met: (s) => s.daysPlayed >= 7300,
    progressLabel: (s) => '${(s.daysPlayed / 365).floor()}/20 Jahre',
  ),
  LifeGoal(
    id: 'life_streak_100',
    emoji: '🔥',
    title: 'Eiserne Disziplin',
    description: 'Halte einen 100-Tage-Streak. Jeden Tag ein bisschen — '
        'so wird aus Gewohnheit Vermögen.',
    xpReward: 600,
    cashCents: 8000,
    met: (s) => s.streakDays >= 100,
    progressLabel: (s) => '${s.streakDays.clamp(0, 100)}/100 Tage Streak',
  ),
  LifeGoal(
    id: 'life_first_100k',
    emoji: '💰',
    title: 'Erste 100.000 €',
    description: 'Knacke die 100.000 € Vermögen. Die erste große Marke — '
        'ab hier arbeitet das Geld spürbar für dich mit.',
    xpReward: 700,
    cashCents: 8000,
    met: (s) => s.netWorthCents >= 10000000,
    progressLabel: (s) => '${(s.netWorthCents / 100).round()} € / 100.000 €',
  ),
  LifeGoal(
    id: 'life_fire',
    emoji: '🔥',
    title: 'Auf dem Weg zur Freiheit',
    description: 'Erreiche 500.000 € Vermögen. Bei rund 4 % Ertrag im Jahr '
        'wären das schon ~20.000 € — ein großer Schritt Richtung '
        'finanzieller Freiheit (= wenn die Erträge die Lebenskosten decken).',
    xpReward: 1000,
    cashCents: 15000,
    met: (s) => s.netWorthCents >= 50000000,
    progressLabel: (s) =>
        '${(s.netWorthCents / 100).round()} € / 500.000 €',
  ),
  LifeGoal(
    id: 'life_level60',
    emoji: '🎓',
    title: 'Finanz-Meisterschaft',
    description: 'Erreiche Level 60 — der höchste Rang. Zeigt: du hast '
        'viel gelernt, gespielt und durchgehalten.',
    xpReward: 1000,
    cashCents: 12000,
    met: (s) => s.level >= 60,
    progressLabel: (s) => 'Level ${s.level} / 60',
  ),
  LifeGoal(
    id: 'life_early_retire',
    emoji: '🏖',
    title: 'Früher Ruhestand',
    description: 'Erreiche 250.000 € Vermögen, solange du höchstens 40 bist. '
        'Früh anfangen schlägt spät viel sparen.',
    xpReward: 1200,
    cashCents: 20000,
    met: (s) => s.netWorthCents >= 25000000 && s.ageYears <= 40,
    progressLabel: (s) => s.ageYears > 40
        ? 'Zeitfenster (≤40 J.) vorbei'
        : '${(s.netWorthCents / 100).round()} € / 250.000 € · ${s.ageYears} J.',
    // Einziges zeitgebundenes Ziel: ab 41 dauerhaft verpasst.
    unreachableWhen: (s) => s.ageYears > 40,
  ),
  LifeGoal(
    id: 'life_million',
    emoji: '💎',
    title: 'Million für immer',
    description: 'Knacke die 1.000.000 € Vermögen. Der König-Meilenstein — '
        'mit Geduld, Streuung und Zeit erreichbar.',
    xpReward: 1500,
    cashCents: 25000,
    met: (s) => s.netWorthCents >= 100000000,
    progressLabel: (s) =>
        '${(s.netWorthCents / 100).round()} € / 1.000.000 €',
  ),
  LifeGoal(
    id: 'life_multimillion',
    emoji: '👑',
    title: 'Mehrfach-Million',
    description: 'Erreiche 5.000.000 € Vermögen. Der absolute Gipfel — nur '
        'mit Geduld, breiter Streuung und sehr langem Atem.',
    xpReward: 2500,
    cashCents: 40000,
    met: (s) => s.netWorthCents >= 500000000,
    progressLabel: (s) =>
        '${(s.netWorthCents / 100).round()} € / 5.000.000 €',
  ),
];

LifeGoal? lifeGoalById(String id) {
  for (final g in kLifeGoals) {
    if (g.id == id) return g;
  }
  return null;
}

/// Liefert die IDs aller mit [snap] erreichten Lebensziele.
Set<String> evaluateLifeGoals(LifeGoalSnapshot snap) {
  final out = <String>{};
  for (final g in kLifeGoals) {
    if (g.met(snap)) out.add(g.id);
  }
  return out;
}

/// Schaltet alle mit [snap] erreichten, noch nicht freigeschalteten
/// Lebensziele frei und schreibt XP + Cash gut — **idempotent** über
/// [unlock] (gibt true nur beim ersten Mal). Eine Quelle der Belohnungs-
/// Wahrheit für game_clock (beim Schlafen) UND die Lebensziele-Seite (beim
/// Öffnen → sofortige „saubere" Erkennung statt erst beim nächsten Schlafen).
///
/// [unlock] = `achievementsRepo.unlock(id, day)`. Liefert die Liste der
/// frisch freigeschalteten Ziele (für einen Toast).
List<LifeGoal> applyLifeGoals({
  required LifeGoalSnapshot snap,
  required int dayIndex,
  required bool Function(String id, int day) unlock,
  required void Function(int xp) addXp,
  required void Function(int cents) earnCents,
}) {
  final granted = <LifeGoal>[];
  for (final id in evaluateLifeGoals(snap)) {
    if (unlock(id, dayIndex)) {
      final g = lifeGoalById(id);
      if (g != null) {
        addXp(g.xpReward);
        earnCents(g.cashCents);
        granted.add(g);
      }
    }
  }
  return granted;
}
