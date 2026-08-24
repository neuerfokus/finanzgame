import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'vorsorge.freezed.dart';
part 'vorsorge.g.dart';

/// spec-36: Vorsorge + Spar-Produkte. Lehrobjekte für gebundenes Sparen,
/// staatliche Förderung, Risiko-Versicherung.
enum VorsorgeType {
  bausparer,
  riester,
  hausrat,
  bu,
  lebensvers,
}

class VorsorgeSpec {
  const VorsorgeSpec({
    required this.type,
    required this.name,
    required this.emoji,
    required this.monthlyPremium,
    required this.minAgeYears,
    required this.lessonShort,
    required this.lesson,
    this.yearlyStateSubsidy = Money.zero,
    this.lockDays = 0,
    this.bonusOnMaturityPct = 0.0,
    this.maturityDays = 0,
    this.coversEventTitleKeywords = const [],
    this.requiredXp = 0,
    this.requiredTopic,
    this.ageFactorPerYear = 0.0,
  });

  final VorsorgeType type;
  final String name;
  final String emoji;
  final Money monthlyPremium;

  /// Mindestalter (Jahre) zum Abschluss. Gate respektiert startAgeYears.
  final int minAgeYears;

  /// Yearly subsidy paid into the contract by the state (Riester-Zulage).
  final Money yearlyStateSubsidy;

  /// Days the money is locked (no payout before that).
  final int lockDays;

  /// Bonus on total paid-in at maturity (Bausparer = 5 %).
  final double bonusOnMaturityPct;
  final int maturityDays;

  final String lessonShort;
  final String lesson;

  /// Spec-44 E4: wenn ein LuckyEvent-title eines dieser Keywords
  /// enthält UND der Vertrag aktiv ist, wird der Schaden ABGEFANGEN
  /// (kein Cash-Abzug). Beispiel: Hausrat coversEventTitleKeywords
  /// = ['Wasserschaden', 'Diebstahl'].
  final List<String> coversEventTitleKeywords;

  /// XP-Schwelle zum Abschluss. Zusätzlich zu [minAgeYears]. 0 = keine.
  /// Verhindert dass Verträge sofort zu Spielbeginn verfügbar sind —
  /// Spieler muss erst durch Quizze/Quests Wissen aufbauen.
  final int requiredXp;

  /// Erforderliches Quest-/Quiz-Topic (siehe QuizTopic). null = keins.
  /// Spieler muss eine Quest zu diesem Thema abgeschlossen ODER das
  /// Quiz-Topic richtig beantwortet haben (learnedTopics).
  final String? requiredTopic;

  /// Welle-8 Round 22 v3: Prämien-Aufschlag pro Lebensjahr über
  /// minAgeYears beim Abschluss. Realität: BU + Hausrat + Lebensvers
  /// werden teurer je später abgeschlossen (höheres Risiko, weniger
  /// Beitragsjahre). 0.0 = konstant (Sparprodukte wie Bausparer).
  final double ageFactorPerYear;

  /// Berechnet effektive Monatsprämie für Vertrag, der mit
  /// [signedAgeYears] abgeschlossen wurde. Bei 0-Faktor immer Basis.
  Money monthlyPremiumAt(int signedAgeYears) {
    if (ageFactorPerYear <= 0) return monthlyPremium;
    final yearsOver = signedAgeYears - minAgeYears;
    if (yearsOver <= 0) return monthlyPremium;
    final factor = 1.0 + ageFactorPerYear * yearsOver;
    return Money.cents((monthlyPremium.cents * factor).round());
  }
}

abstract final class VorsorgeCatalog {
  static const bausparer = VorsorgeSpec(
    type: VorsorgeType.bausparer,
    name: 'Bausparvertrag',
    emoji: '🏠',
    monthlyPremium: Money.cents(5000),
    minAgeYears: 14,
    lessonShort: 'Sparen + Recht auf günstigen Immobilien-Kredit',
    lesson:
        'Du sparst monatlich an. Nach ~7 Jahren bekommst du das Geld '
        'zurück plus 5 % Bonus, alternativ ein günstiges Bau-Darlehen. '
        'Klingt sicher — Rendite aber niedrig, Geld lange gebunden.',
    bonusOnMaturityPct: 0.05,
    maturityDays: 2520, // ~7y
    lockDays: 2520,
    // Welle-8: nicht mehr sofort zu Spielbeginn verfügbar. Erst nach
    // etwas Spielfortschritt + Spar-Quest (z.B. q17_bausparer).
    requiredXp: 250,
    requiredTopic: 'sparen', // == QuizTopic.sparen
  );

  static const riester = VorsorgeSpec(
    type: VorsorgeType.riester,
    name: 'Riester-Rente',
    emoji: '👴',
    monthlyPremium: Money.cents(10000),
    minAgeYears: 16,
    yearlyStateSubsidy: Money.cents(17500),
    lockDays: 19710, // Auszahlung ab 67 (Start 13 + 54y ≈ Tag 19710)
    lessonShort: 'Sparplan mit staatlicher Zulage, gebunden bis 67',
    lesson:
        'Staat schenkt dir 175 € pro Jahr dazu — klingt geschenkt. ABER: '
        'Geld ist bis zur Rente blockiert. Kosten oft hoch. Vergleich '
        'mit ETF-Sparplan lohnt sich vor Abschluss.',
  );

  static const hausrat = VorsorgeSpec(
    type: VorsorgeType.hausrat,
    name: 'Hausratversicherung',
    emoji: '🏠',
    monthlyPremium: Money.cents(1000),
    minAgeYears: 18,
    lessonShort: 'Schützt Möbel + Technik gegen Einbruch, Feuer, Wasser',
    lesson:
        'Ohne Hausrat: Wenn ein Sturm deine Wohnung flutet, ersetzt dir '
        'niemand die Möbel. Mit Hausrat: Versicherung zahlt. Sinnvoll '
        'erst wenn du eigene Wohnung hast und teure Sachen besitzt — '
        'vorher zahlt die Hausrat deiner Eltern.',
    // E4: fängt Wasserschaden + Handy-Reparatur + Fahrrad-Schaden ab.
    coversEventTitleKeywords: ['Wasserschaden', 'Handy-Reparatur', 'Fahrrad'],
    requiredXp: 400,
    requiredTopic: 'versicherung', // == QuizTopic.versicherung
    ageFactorPerYear: 0.02, // +2 %/J — leichte Risiko-Steigerung
  );

  static const bu = VorsorgeSpec(
    type: VorsorgeType.bu,
    name: 'Berufsunfähigkeits-Vers.',
    emoji: '🩺',
    monthlyPremium: Money.cents(3000),
    minAgeYears: 16,
    lessonShort: 'Ersetzt dein Gehalt wenn du nicht mehr arbeiten kannst',
    lesson:
        'Wenn du krank wirst und nicht mehr arbeiten kannst, zahlt die '
        'Versicherung statt deinem Arbeitgeber. Eine der wichtigsten '
        'Versicherungen überhaupt — günstig wenn jung + gesund.',
    // E4: fängt Krankenhaus + Zahnarzt-Events ab.
    coversEventTitleKeywords: ['Krankenhaus', 'Zahnarzt'],
    requiredXp: 500,
    requiredTopic: 'versicherung', // == QuizTopic.versicherung
    // Welle-8 Round 22 v3: BU teurer mit Alter — Realität.
    // 18 → 30 €, 30 → 44,40 €, 45 → 62,40 € (×2,08).
    ageFactorPerYear: 0.04,
  );

  static const lebensvers = VorsorgeSpec(
    type: VorsorgeType.lebensvers,
    name: 'Klassische Lebensvers.',
    emoji: '⚰',
    monthlyPremium: Money.cents(8000),
    minAgeYears: 16,
    lockDays: 10950,
    bonusOnMaturityPct: 0.10,
    maturityDays: 10950, // 30y
    lessonShort: 'Häufig schlecht — niedrige Rendite, hohe Kosten',
    lesson:
        'Klassische Police: nach 30 Jahren bekommst du Beträge + bisschen '
        'Zins zurück. Rendite typisch unter Inflation. ETF-Sparplan '
        'schlägt das fast immer.',
    ageFactorPerYear: 0.03,
  );

  // Spec-43 v4: Riester + klassische Lebensversicherung raus aus
  // Default-Liste. User-Feedback: beides aus Investorensicht
  // problematisch. Bleiben im Typ-Enum für Drift-Migration und alte
  // Verträge, aber nicht mehr abschließbar.
  static const all = <VorsorgeSpec>[
    hausrat,
    bu,
    bausparer,
  ];

  /// Welle-8 Round 19 v4: defensiv. Riester + lebensvers wurden aus
  /// `all` entfernt aber sind noch im Enum für alte Saves. Ohne orElse
  /// crasht firstWhere mit "Bad state: No element" — und damit jeder
  /// advanceDay-Call, der über Vorsorge-Verträge iteriert.
  /// Fallback auf hausrat damit alte Verträge keine Game-Breaker sind.
  static VorsorgeSpec byType(VorsorgeType t) =>
      all.firstWhere((s) => s.type == t, orElse: () => hausrat);
}

@freezed
abstract class VorsorgeContract with _$VorsorgeContract {
  const factory VorsorgeContract({
    required VorsorgeType type,
    required int startedOnDayIndex,
    @MoneyConverter() required Money totalContributed,
    @MoneyConverter() required Money totalSubsidy,
  }) = _VorsorgeContract;

  factory VorsorgeContract.fromJson(Map<String, dynamic> json) =>
      _$VorsorgeContractFromJson(json);
}
