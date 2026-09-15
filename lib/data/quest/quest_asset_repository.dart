import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/quest/quest.dart';
import 'quest_yaml_loader.dart';

part 'quest_asset_repository.g.dart';

/// Bundled YAML quest files. New quests = add file here + AssetBundle entry
/// in pubspec.yaml's existing `assets/quests/` glob.
// v29: neue Reihenfolge nach assets/quests/_REIHENFOLGE.md
// (User-Reorg). 45 Quests q00–q44 + 2 event-gated (Sprint C4).
const List<String> kQuestAssetPaths = [
  'assets/quests/q00_tutorial.yaml',
  'assets/quests/q01_sparschwein.yaml',
  'assets/quests/q02_wuensche.yaml',
  'assets/quests/q03_notgroschen.yaml',
  'assets/quests/q04_konto_basics.yaml',
  'assets/quests/q05_zinseszins.yaml',
  'assets/quests/q06_inflation_brot.yaml',
  'assets/quests/q07_versicherungen.yaml',
  'assets/quests/q08_notgroschen_drill.yaml',
  'assets/quests/q09_regel_dein_risiko.yaml',
  'assets/quests/q10_compound_magic.yaml',
  'assets/quests/q11_was_ist_aktie.yaml',
  'assets/quests/q12_gold_als_schutz.yaml',
  'assets/quests/q13_spar_vs_invest.yaml',
  'assets/quests/q14_geldwert_sachwert.yaml',
  'assets/quests/q15_einzelaktie_risiko.yaml',
  'assets/quests/q16_dividende.yaml',
  'assets/quests/q17_bausparer.yaml',
  'assets/quests/q18_edelmetalle_geschichte.yaml',
  'assets/quests/q19_marktkapitalisierung.yaml',
  'assets/quests/q20_geld_vs_glueck.yaml',
  'assets/quests/q21_diversifikation.yaml',
  'assets/quests/q22_immobilienkredit.yaml',
  'assets/quests/q23_dividenden_strategie.yaml',
  'assets/quests/q24_steuer_basics.yaml',
  'assets/quests/q25_was_ist_fonds.yaml',
  'assets/quests/q26_geldpolitik.yaml',
  // q27_lebensvers_falle (im Reorg nicht erstellt — entfernt)
  'assets/quests/q28_was_ist_etf.yaml',
  'assets/quests/q29_crash_was_tun.yaml',
  'assets/quests/q30_wie_kaufen.yaml',
  'assets/quests/q31_kostenfalle.yaml',
  'assets/quests/q32_sparplan_dca.yaml',
  'assets/quests/q33_etf_breite.yaml',
  'assets/quests/q34_panik_vermeiden.yaml',
  'assets/quests/q35_etf_ter_kosten.yaml',
  'assets/quests/q36_cost_average.yaml',
  'assets/quests/q37_volatilitaet.yaml',
  'assets/quests/q38_buy_and_hold.yaml',
  'assets/quests/q39_totes_pferd.yaml',
  'assets/quests/q40_antizyklisch.yaml',
  'assets/quests/q41_krypto_casino.yaml',
  'assets/quests/q42_wann_trennen.yaml',
  'assets/quests/q43_bitcoin_halving.yaml',
  'assets/quests/q44_gewinne_laufen.yaml',
  // Sprint C4: event-getriggerte Spezial-Quests.
  'assets/quests/q40_panic_sell_loss.yaml',
  'assets/quests/q41_held_through_crash.yaml',
  // Welle-8 Round 17: Mini-Story-Quests #4 (Story-Arcs für spätere Spielphasen).
  'assets/quests/q50_onkel_bernd_aktie.yaml',
  'assets/quests/q51_klassenkamerad_krypto.yaml',
  'assets/quests/q52_droptok_influencer.yaml',
  // Round 27 v5 BUGFIX: q53/q54 existierten als Datei, waren aber nie
  // registriert → nie geladen. Plus q55 Fake-Shop/Phishing (betrug).
  'assets/quests/q53_freistellungsauftrag.yaml',
  'assets/quests/q54_frei_verfuegbar.yaml',
  'assets/quests/q55_fake_shop_phishing.yaml',
  // Round 28 v4: Endgame-Story (Spenden/Stiftung-Richtung) — „genug haben"
  // + Geld, das Gutes tut. Spät gegated (prerequisites auf späte Quests).
  'assets/quests/q56_genug_haben.yaml',
  'assets/quests/q57_spenden_stiftung.yaml',
  // Verbesserungs-Runde: Real-Welt-Szenarien für Teenager — Handyvertrag-
  // Falle (Gesamtkosten/Bindung/Prepaid) + erster Mini-Job-Vertrag
  // (Vertrag lesen, Stundenlohn, Mini-Job-Grenze).
  'assets/quests/q58_handyvertrag_falle.yaml',
  'assets/quests/q59_erster_job_vertrag.yaml',
  // Optionen-Backlog #4: neue Alltags-Story-Quests.
  'assets/quests/q60_gebraucht_wiederverkauf.yaml',
  'assets/quests/q61_gruppenzwang.yaml',
  'assets/quests/q62_online_banking_tan.yaml',
];

/// Loads quests from the asset bundle once and caches in memory.
class QuestAssetRepository {
  QuestAssetRepository({
    required AssetBundle bundle,
    QuestYamlLoader? loader,
    List<String>? paths,
  })  : _bundle = bundle,
        _loader = loader ?? const QuestYamlLoader(),
        _paths = paths ?? kQuestAssetPaths;

  final AssetBundle _bundle;
  final QuestYamlLoader _loader;
  final List<String> _paths;

  List<Quest>? _cache;

  Future<List<Quest>> loadAll() async {
    if (_cache != null) return _cache!;
    final quests = <Quest>[];
    for (final path in _paths) {
      final text = await _bundle.loadString(path);
      quests.add(_loader.parse(text));
    }
    _cache = List.unmodifiable(quests);
    return _cache!;
  }
}

@Riverpod(keepAlive: true)
QuestAssetRepository questAssetRepository(Ref ref) =>
    QuestAssetRepository(bundle: rootBundle);

@riverpod
Future<List<Quest>> quests(Ref ref) =>
    ref.read(questAssetRepositoryProvider).loadAll();
