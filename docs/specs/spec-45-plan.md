# Spec-45 — Plan: offene Themen + laufende Bug-Welle

**Stand:** HEAD `85c6a6b` · APK 1.10.0+35 auf Mi A3 · 450 Tests grün

Plan ist Bucket-orientiert, nicht streng linear. Test-Bugs werden in
**Welle-7** (am Ende) aufgenommen und nach Schwere in P0/P1/P2 sortiert,
sobald sie kommen.

---

## Bucket A — Lucky-Events: Transparenz im DaySummary

Heute werden Lucky-Events nur im FastForward gelistet, im normalen
Schlaf-DaySummary nicht extra hervorgehoben. User-Wunsch: jeder
Cash-Zu-/Abfluss soll seinen Ursprung zeigen.

- ✅ A1 LuckyEvent im DaySummary mit ✨/⚠-Highlight + Tooltip
- ✅ A2 LuckyEvent-History-Tab in Bank-App (Drift v14 + Repository)
- ✅ A3 Schenkungsteuer-Hinweis in luckyEvent.description

## Bucket B — Age-based Audit für restliche Mechaniken

Geprüft + fixed: Vorsorge, Jobs, Allowance, Living, Insurance, Lucky-Opa.

Noch offen prüfen:

- 🔄 B1 Immobilienkauf Age-Gate raus (Welle-8 User: XP statt Alter)
- ✅ B2 maxDayIndexFor(startAge) — Spielende immer bei 80
- ❌ B3 Sparplan-Mindestalter raus (Welle-8: XP-Progression)
- 🔄 B4 Krypto Age-Gate raus, nur Info-Banner (Welle-8)
- ❌ B5 Einlage-Cap raus (Welle-8: XP-Progression)
- ✅ B6 (Welle-8 v3) MonetariaUnlocker Hybrid C: XP-Min + erforderliche
  Quest-Topic (außer Mischwald = nur XP).
  Schwellen 200/500/800/1200/2000/3500/5000 XP, Topic via kQuestTopics.

## Bucket C — Job + Steuer Erweiterung

Heute: 3 Stufen Vollzeit (Ferienjob/Ausbildung/Vollzeit) mit fixen
Brutto-Werten. Realistischer:

- ✅ C1 Gehaltssteigerung +2 %/Jahr im selben Level (Cap 10 J = +20 %)
- ✅ C2 Beförderung Senior (24) + Teamlead (29), eigenes Brutto/Living
- ✅ C3 Soli (5,5%) + KiSt (9%) separat im Lohn-Breakdown
- ✅ C4 Steuer-Klassen 1..6 wählbar (Settings-Dropdown, in-memory).
  Faktor: I/IV 1.0, II 0.85, III 0.65, V 1.35, VI 1.55
- ✅ C5 Job-Wechsel + Sabbatical via Job-Badge-Tap (in-memory, persist
  in H1-folge geplant). +5%/Wechsel stackbar bis 50%, 30 Tage Pause

## Bucket D — Pflanz-Mechanik Polish

- ✅ D1 Reife-Tooltip per Long-Press (Stufe %, Tage bis reif, Cost/Yield)
- ✅ D2 Withered-Tooltip mit Ursachen-Liste (Sturm/Saison/zu lange)
- ✅ D3 Saison-Indikator pro Pflanze (existiert in planting_menu)
- ✅ D4 Plot-Grid adaptiv (Welle-7)

## Bucket E — Quest-System Polish

- ✅ E1 Quest-Reihenfolge per _REIHENFOLGE.md user-kuratiert
- ✅ E2 Schwierigkeits-Badge 🟢🟡🔴 nach quest-ID-Range
- ✅ E3 Voraussetzung schon in _LockedQuestRow sichtbar
- ✅ E4 Wissens-Quiz nach Quest-Abschluss (Spaced-Rep +1/+3/+7, Topic-Match)
- ✅ E5 Quest-Cap 3/Bucket aktiv

## Bucket F — Sparen + Investieren Lern-Loops

- ✅ F1 Spar-Zins-Ghostlinie (1,8 %/J) in Zeitreise neben ETF/Gold/Mix
- ✅ F2 CAGR %/J pro Legend-Linie (ab 30 Tagen Periode)
- ✅ F3 Cost-Average via compound_chart existiert
- ✅ F4 Diversifikations-Card in Bank-App (X/6 + Dämpfungs-%)

## Bucket G — Ruhestand + Spielende

- ✅ G1 RuhestandPage zeigt Reflexion + Asset-Verteilung (spec-38)
- ✅ G2 Realwelt-Benchmark (Bundesbank PHF 2023): Perzentil + Median/
  Top10/Top1 Vergleichszeilen im Ruhestand-Recap
- ✅ G3 NewGame+ Reset-Flow mit Erbschaft (1% net worth, cap 1000 €)
  + Bonus-XP (10% xp, cap 500). RuhestandPage Button "Neues Leben",
  Onboarding consumed Pending. Springboard zeigt ♻N Run-Counter.
  In-memory KeepAlive — überlebt DB-Wipe ohne App-Kill.
- ✅ G4 Top-3-Lucky-Events im Ruhestand-Recap (Magnitude-sortiert)

## Bucket H — Tooling + Asset-Pipeline

- ✅ H1 Drift v14 (LuckyEventHistoryTable, mit A2+G4 ausgeliefert)
- ✅ H1b Drift v15 (NewGameStateTable + TreeHoldingsTable für G3+H3
  Persistenz). JobAction + QuestFailure bleiben in-memory (akzeptabel).
- 🟡 H2 Aurora-Schiff CustomPaint v2 mit Iso-Perspektive (Bug
  links-vorn schmal, Heck rechts-hinten höher, Backbord-Schatten,
  Wasser-Wellen, Bullaugen). Sprite-Loading auf nicht-existenten
  TODO-Pfad — erst bei echter 3D-Iso-PNG wieder einhängen.
- ✅ H3 Mischwald Wald-Wirtschaft: 3 Baum-Arten (Birke/Eiche/Pinie)
  mit langem Reife-Zyklus + täglichem Holz-Income. In-memory bis
  Drift-Sammelmigration. Sub-Section in CollectibleTradePage neben
  Sammler-Shop.
- ❌ H4 Sound-Bundle gestrichen (User-Entscheidung 2026-05-25: weglassen)
- ✅ H5 Asset-Lizenz-Check via `tools/license_check.py` — scant
  assets/ + matched gegen ASSETS.md (Bulk-Patterns + Exakt), Report
  in `tools/license_check_report.md`. Exit 1 wenn Unknown/Orphan.
  Aktuell: 0 Unknown, 0 Orphan (clean).

## Bucket I — Quiz-System (neu)

Aktuell: `kQuizPool[dayIndex % poolLength]`, eigener Pool 30+ Fragen,
keine Themen-/Schwierigkeits-Logik. User-Wunsch: thematisch
aufbauend wie Quests, mit Zeit schwieriger.

- ✅ I1 Topic-Tags konsistent (`quiz_topics.dart` + `kQuestTopics` Map)
- ✅ I2 Schwierigkeits-Tier `int tier` auf QuizQuestion (0/1/2 = easy/mid/hard)
- ✅ I3 Quiz-Pick filtert nach `learnedTopicsProvider` aus Quest-Progress
- ✅ I4 `tiersFor(dayIndex)` — <30 easy, <90 +mid, sonst all

## Bucket Welle-7 — Testlauf 2026-05-23 (laufend)

Bugs vom User aus dieser Sideload (Test-Session 2026-05-23):

- ✅ Taschengeld in Settings ändern → reaktiv auf Springboard
- ✅ Plot-Felder zu klein → adaptiv 2×2 bei 4 Plots
- ✅ Quiz-Antworten passen nicht in Boxen → Multi-line statt FittedBox
- ✅ Settings-Icon zeigt Quiz statt Settings → Hijack entfernt
- ✅ HarvestAll ohne Feedback → Snack mit Yield
- ✅ Daily-Goal „ETF kaufen" ohne ETF-Insel → Filter nach unlocked
- ✅ Quest-Umlaute → 64 Replacements in 18 YAMLs
- ✅ Hausrat mit 13 sinnlos → minAgeYears=18
- ✅ Opa 23k mit 60d → Gate + Rebalance
- ✅ Lucky-Events transparent → FastForward-Liste + Jahres-Feste
- ✅ Brutto/Netto-Modell + progressive Steuer
- ✅ Plant-Cap raus → spec.yield = Ernte (modulo Wetter)
- ✅ Plot-Emoji adaptiv (28-120 px)
- ✅ Plot-Grid horizontal scrollend, neue Plots nach rechts statt
  bestehende verkleinern (Flame → Flutter GridView)
- ✅ Furniture-Emojis 6 fixes + 42 Twemoji-PNGs (CC-BY)
- ✅ Lucky-Event Age-Gates (kein Bonus vom Chef mit 13)
- ✅ Vorsorge minAgeYears (Hausrat 18, BU/Bausparer/Riester 14-16)
- ✅ JobConfig.forAge(ageYears) statt forDay
- ✅ Brutto/Netto-Modell mit progressiver Steuer + Soli/KiSt
- ⏳ noch offen: weitere Bugs vom Testlauf (live)

---

## Vorgehen pro Session

1. Aktuelle Test-Bugs einsammeln → in Welle-7 priorisieren (P0/P1/P2)
2. Pro Session 1 Bucket primär + Welle-7-Hotfixes inline
3. Tests + Codegen + analyze --fatal-infos vor jedem Commit
4. Release via `tools/release.ps1` + `install_keep_data.ps1`
5. Memory + dieses Spec-File nach jedem Bucket-Closure updaten

## Out-of-Scope (permanent)

Cloud-Sync, Multiplayer, Voice-Acting, Ads, IAP, echte Marken,
echte Aktien, Glücksspiel/Lootbox-Mechaniken.
