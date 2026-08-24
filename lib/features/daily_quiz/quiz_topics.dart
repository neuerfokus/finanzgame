/// Spec-45 Bucket I + E4: canonical topic vocabulary shared by quest YAMLs
/// and the daily-quiz pool. Drives:
/// - Topic-based filtering (Quiz nur über Themen die Quests bereits gelernt)
/// - Spaced-repetition queue (Quest-Complete reviewt sein Topic an Tag +1/+3/+7)
/// - Tier-Rotation (early=easy, mid=easy+mid, late=all)
library;

abstract final class QuizTopic {
  static const tutorial = 'tutorial';
  static const grundlagen = 'grundlagen';
  static const sparen = 'sparen';
  static const zinsen = 'zinsen';
  static const etf = 'etf';
  static const inflation = 'inflation';
  static const aktien = 'aktien';
  static const einzelaktie = 'einzelaktie';
  static const diversifikation = 'diversifikation';
  static const dividende = 'dividende';
  static const volatilitaet = 'volatilitaet';
  static const psychologie = 'psychologie';
  static const notgroschen = 'notgroschen';
  static const schulden = 'schulden';
  static const steuer = 'steuer';
  static const versicherung = 'versicherung';
  static const sparplan = 'sparplan';
  static const edelmetalle = 'edelmetalle';
  static const bitcoin = 'bitcoin';
  static const krypto = 'krypto';
  static const immobilie = 'immobilie';
  static const praxis = 'praxis';
  // Welle-8 Round 25: Alltags-Finanzen eines Teenagers.
  static const konto = 'konto';
  static const konsum = 'konsum';
  static const betrug = 'betrug';
}

/// Schwierigkeitstier — 0=easy, 1=mid, 2=hard.
abstract final class QuizTier {
  static const easy = 0;
  static const mid = 1;
  static const hard = 2;
}

/// Tier-Fenster nach Spielzeit (dayIndex).
/// - <30 Tage: nur easy
/// - <90 Tage: easy+mid
/// - sonst: alle
Set<int> tiersFor(int dayIndex) {
  if (dayIndex < 30) return const {QuizTier.easy};
  if (dayIndex < 90) return const {QuizTier.easy, QuizTier.mid};
  return const {QuizTier.easy, QuizTier.mid, QuizTier.hard};
}

/// Quest-ID → Topic-Set (Quest kann mehrere Topics berühren).
/// Stand: 2026-05-24. Quellen: assets/quests/*.yaml `topic:` Feld plus
/// inhaltliche Zuordnung wo kein YAML-topic gesetzt ist.
const Map<String, Set<String>> kQuestTopics = {
  'q00_tutorial': {QuizTopic.tutorial, QuizTopic.sparen},
  'q01_sparschwein': {QuizTopic.sparen},
  'q02_wuensche': {QuizTopic.grundlagen, QuizTopic.sparen},
  'q03_notgroschen': {QuizTopic.notgroschen},
  'q04_konto_basics': {QuizTopic.grundlagen},
  'q05_zinseszins': {QuizTopic.zinsen},
  'q06_inflation_brot': {QuizTopic.inflation},
  'q07_versicherungen': {QuizTopic.versicherung},
  'q08_notgroschen_drill': {QuizTopic.notgroschen},
  'q09_regel_dein_risiko': {QuizTopic.grundlagen, QuizTopic.diversifikation},
  'q10_compound_magic': {QuizTopic.zinsen},
  'q11_was_ist_aktie': {QuizTopic.aktien},
  'q12_gold_als_schutz': {QuizTopic.edelmetalle},
  'q13_spar_vs_invest': {QuizTopic.sparen, QuizTopic.aktien},
  'q14_geldwert_sachwert': {QuizTopic.grundlagen, QuizTopic.inflation},
  'q15_einzelaktie_risiko': {QuizTopic.einzelaktie, QuizTopic.diversifikation},
  'q16_dividende': {QuizTopic.dividende},
  'q17_bausparer': {QuizTopic.sparen, QuizTopic.immobilie},
  'q18_edelmetalle_geschichte': {QuizTopic.edelmetalle},
  'q19_marktkapitalisierung': {QuizTopic.aktien},
  'q20_geld_vs_glueck': {QuizTopic.psychologie},
  'q21_diversifikation': {QuizTopic.diversifikation},
  'q22_immobilienkredit': {QuizTopic.immobilie, QuizTopic.schulden},
  'q23_dividenden_strategie': {QuizTopic.aktien, QuizTopic.dividende},
  'q24_steuer_basics': {QuizTopic.steuer},
  'q25_was_ist_fonds': {QuizTopic.etf},
  'q26_geldpolitik': {QuizTopic.inflation},
  'q28_was_ist_etf': {QuizTopic.etf},
  'q29_crash_was_tun': {QuizTopic.psychologie, QuizTopic.volatilitaet},
  'q30_wie_kaufen': {QuizTopic.praxis, QuizTopic.aktien},
  'q31_kostenfalle': {QuizTopic.etf},
  'q32_sparplan_dca': {QuizTopic.sparplan},
  'q33_etf_breite': {QuizTopic.etf, QuizTopic.diversifikation},
  'q34_panik_vermeiden': {QuizTopic.psychologie},
  'q35_etf_ter_kosten': {QuizTopic.etf},
  'q36_cost_average': {QuizTopic.sparplan},
  'q37_volatilitaet': {QuizTopic.volatilitaet},
  'q38_buy_and_hold': {QuizTopic.psychologie, QuizTopic.aktien},
  'q39_totes_pferd': {QuizTopic.psychologie},
  'q40_antizyklisch': {QuizTopic.psychologie},
  'q40_panic_sell_loss': {QuizTopic.psychologie},
  'q41_held_through_crash': {QuizTopic.psychologie},
  'q41_krypto_casino': {QuizTopic.krypto, QuizTopic.psychologie},
  'q42_wann_trennen': {QuizTopic.psychologie},
  'q43_bitcoin_halving': {QuizTopic.bitcoin, QuizTopic.krypto},
  'q44_gewinne_laufen': {QuizTopic.psychologie},
  // Welle-8 Round 17: Mini-Story-Quests.
  'q50_onkel_bernd_aktie': {QuizTopic.einzelaktie, QuizTopic.diversifikation},
  'q51_klassenkamerad_krypto': {QuizTopic.krypto, QuizTopic.volatilitaet, QuizTopic.psychologie},
  'q52_droptok_influencer': {QuizTopic.psychologie, QuizTopic.grundlagen},
  // Round 27 v5: q53/q54 nachregistriert + q55 Betrug.
  'q53_freistellungsauftrag': {QuizTopic.steuer},
  'q54_frei_verfuegbar': {QuizTopic.grundlagen, QuizTopic.praxis},
  'q55_fake_shop_phishing': {QuizTopic.betrug},
  // Round 28 v4: Endgame-Story (Spenden/Stiftung).
  'q56_genug_haben': {QuizTopic.psychologie, QuizTopic.grundlagen},
  'q57_spenden_stiftung': {QuizTopic.psychologie},
  // Verbesserungs-Runde: Real-Welt-Szenarien.
  'q58_handyvertrag_falle': {QuizTopic.konsum},
  'q59_erster_job_vertrag': {QuizTopic.praxis, QuizTopic.steuer},
  // Optionen-Backlog #4: neue Alltags-Story-Quests.
  'q60_gebraucht_wiederverkauf': {QuizTopic.konsum},
  'q61_gruppenzwang': {QuizTopic.psychologie, QuizTopic.konsum},
  'q62_online_banking_tan': {QuizTopic.betrug, QuizTopic.konto},
};

/// Spaced-Repetition Offsets (Tage) für Quiz-Review nach Quest-Complete.
/// Beim Abschluss von Quest X werden 3 Quiz-Picks zu X's Topics in die
/// Queue gelegt: aktueller Tag + 1, + 3, + 7.
const List<int> kReviewOffsets = [1, 3, 7];
