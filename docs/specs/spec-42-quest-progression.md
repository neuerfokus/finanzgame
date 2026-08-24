# Spec 42 — Quest-Progression (Fonds vor ETF, Stufenleiter)

## Problem

Quest-Liste sprang von Sparschwein zu ETF ohne Brückenbegriffe.
Aktien wurden NACH ETF erklärt (q13 nach q04). Inflation hing
fälschlich an Risiko-Quests. 5 Dubletten-YAMLs (q26..q30 jeweils
zweite Datei) wurden vom Loader nie geladen.

## Lösung

- 2 neue Quests: `q32_konto_basics` (Bankkonto+Zinsen),
  `q33_was_ist_fond` (gemanagter Fond mit Manager+TER).
- Alle 5 Waisen-YAMLs in `kQuestAssetPaths` einreihen.
- IDs/Dateinamen bleiben → kein DB-Save-Bruch.
- Prerequisites neu verdrahtet → eine durchgehende Lernlinie.

## Lernlinie (Anzeigereihenfolge in kQuestAssetPaths)

GRUNDLAGEN
1. q00 Tutorial
2. q01 Sparschwein
3. q02 Wünsche
4. q09 Notgroschen
5. **q32 Konto-Basics (NEU)** — prereq q01
6. q03 Zinseszins — prereq q32
7. q10 Compound-Magic — prereq q03
8. q05 Inflation — prereq q32
9. q24 Notgroschen-Drill — prereq q09
10. q28_spar_vs_invest — prereq q24

AKTIEN (vor ETF)
11. q13 Was ist Aktie? — prereq q03
12. q30_marktkapitalisierung — prereq q13
13. q14 Dividende — prereq q13
14. q07 Einzelaktie-Risiko — prereq q13
15. q08 Diversifikation — prereq q07

FONDS → ETF
16. **q33 Was ist ein Fond? (NEU)** — prereq q08
17. q04 ETF-Korb — prereq q33
18. q15 ETF-Funktion — prereq q04
19. q19 Sparplan/DCA — prereq q15
20. q31 Cost-Average — prereq q19
21. q17 Kostenfalle — prereq q15
22. q29_etf_ter_kosten — prereq q17

CRASHES & STRATEGIE
23. q06 Crash — prereq q04
24. q18 Panik vermeiden — prereq q06
25. q25 Volatilität — prereq q18
26. q29_buy_and_hold — prereq q18
27. q28_dividenden_strategie — prereq q14

GOLD
28. q16 Gold-Schutz — prereq q05
29. q27_edelmetalle_geschichte — prereq q16

KRYPTO
30. q11 Krypto-Casino — prereq q25
31. q26_bitcoin_halving — prereq q11

MAKRO/STEUER/VORSORGE
32. q12 Steuer-Basics — prereq q08
33. q26_geldpolitik — prereq q12
34. q21 Riester — prereq q12
35. q27_lebensvers_falle — prereq q21
36. q22 Versicherungen — prereq q09

WOHNEN
37. q20 Bausparer — prereq q10
38. q23 Immobilien-Kredit — prereq q20

ABSCHLUSS
39. q30_geld_vs_glueck — prereq q28_spar_vs_invest

## Out-of-Scope

- Dialog-Inhalte bestehender Quests unverändert (nur prereq-Felder)
- Keine Belohnungs-Rebalance
- Keine ID-Umbenennung (DB-Save bleibt kompatibel)

## Akzeptanz

- `flutter analyze --fatal-infos` clean
- Erste 5 verfügbare Quests = leichteste Begriffe (Sparschwein → Konto)
- Keine Quest hat Fonds/ETF-Begriff bevor `q33` abgeschlossen
- Alle 39 YAMLs werden geladen (aktuell nur 32)
