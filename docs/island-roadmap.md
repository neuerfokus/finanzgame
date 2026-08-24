# Island-Roadmap — FINANZGAME

## Archipel Monetaria — Reihenfolge & Gating

| # | Insel | Lernkonzept | Pflanzen-/Mechanik | Boot | Freischaltung |
|---|---|---|---|---|---|
| 1 | Heimathafen | Geld, Wunschliste, Tageszyklus | — | Ruderboot | Start |
| 2 | **Spar-Insel** (Elefantenfuß) | Sicheres Sparen, einfache Zinsen | Elefantenfuß: sehr langsam, robust, geringe Ernte | Ruderboot | Nach 5 Spieltagen + Quest |
| 3 | **Mischwald-Insel** (ETF) | Diversifikation, Zinseszins | 5+ Baumarten; mehr Arten = stabilerer Ertrag; Schneeball-Effekt | Segelboot | Spar-Insel Lvl 3 |
| 4 | **Wiesen-Insel** (Anleihen) | Fester Zins, Laufzeit | Karnickel-Gehege: vorhersagbare Würfe | Segelboot | Quest „Opa zeigt Anleihe" |
| 5 | **Aktien-Archipel** | Einzelaktien, Pizza-Aktien | Einzelne Obstbäume mit variierendem Risiko/Ertrag | Kutter | ETF-Insel Lvl 3 |
| 6 | **Vulkan-Insel** (alt. Assets) | Hohes Risiko, FOMO-Lehre | Vulkan-Kaktus blüht selten, explosiv ODER Totalausfall | Kutter | Aktien Lvl 3 + Quest „Was Kumpel Max nicht erzählt" |
| 7 | **Inflations-Atoll** | Inflation, Realzins | Salzwasser-Pflanzen verlieren Ertrag, Wunschpreise steigen | — | Mid-Game-Event |
| 8 | **Zeitreise-Insel** | Zinseszins über Jahrzehnte | Skip-Modus 10/20 Jahre, zeigt Compounding | Zeitschiff | End-Game |

## Pflanzen-Sub-Mechanik

Jede Pflanze hat:
- **Pflanzkosten** (Investitionssumme)
- **Wachstumsdauer** in Tagen (Liquidität)
- **Erntemenge** (Rendite)
- **Wetteranfälligkeit** (Volatilität)
- **Reife-Mehrfachertrag** (Zinseszins wenn stehengelassen)

### Startwerte (iterativ verfeinern, Sohn als Testpilot)

| Pflanze | Kosten | Dauer | Ertrag | Wetter-Risk | Mehrfach |
|---|---|---|---|---|---|
| Elefantenfuß (Spar) | 50¢ | 3 Tage | 52¢ (~1,3 %/Tag) | 0% | nein |
| Mischwald-Plot (ETF) | 200¢ | 5 Tage | 220¢ | 5% Sturm | +20% bei Vollbestand |
| Karnickel-Käfig (Anleihe) | 100¢ | 7 Tage | 108¢ (fest) | 0% | nein |
| Obstbaum (Aktie) | 80¢ | 4 Tage | 60-130¢ (variabel) | 15% | nein |
| Vulkan-Kaktus | 100¢ | 7 Tage | 30¢ (50%) ODER 250¢ (50%) | 30% | nein |

## Wetter-System

Wetter = **Volatilitäts-Visualisierung.**

- **Sonne** = normales Wachstum, planmäßige Ernte
- **Regen** = Hausse, +10-20% Bonus-Ertrag
- **Sturm** = Bärenmarkt-Event, Ertrag fällt aus oder negativ

Per-Insel-Wahrscheinlichkeiten siehe `sim-engine.md` Pipeline Stage 5.

## Boots-Klassen (Liquiditäts-Metapher)

- **Kanu / Ruderboot** = Tagesgeld / Spar — sofort, kein Risiko, geringe Reichweite
- **Segelboot** = ETF / Bonds — flexibel, mittlere Reichweite, leichte Wetterabhängigkeit
- **Kutter** = Einzelaktien — stark wetterabhängig, gute Reichweite
- **Frachter** = Immobilien — sehr lange Reise, hoher Aufwand, stetiger Miet-Tick
- **Forschungs-U-Boot** = Bitcoin / alt. Assets — riskant, kann tief vorstoßen
- **Zeitschiff** = Pension/Compounding-Demo — End-Game-Mechanik

## Vergleichs-UI (Asset-Picker)

Spinnennetz/Radar-Chart pro Asset-Klasse mit 3 Achsen:

- **Laufzeit** (kurz ↔ sehr lang)
- **Rendite** (niedrig ↔ hoch)
- **Sicherheit** (riskant ↔ garantiert)

Spieler sieht visuell die Tradeoffs. Verwendet beim Insel-Tap im Hub.

## Sparziel-Anker

Onboarding-Frage „Was hast du für ein Sparziel?" gilt weiter. In Phase-2 erweitert:

- **Kurzfristig** (Sneaker, Konsole, 6 Monate) → empfohlen Spar-Insel + Mischwald light
- **Langfristig** (Auto, Studium, 5+ Jahre) → empfohlen Mischwald + Aktien + Anleihen-Mix

App schlägt vor, Spieler wählt. Niemals zwingen, niemals als „richtige Antwort" framen.

## Krisen-Events (Phase 3 — Schulden + Krisen)

- Job-Verlust → Allowance fällt aus für 4 Wochen
- Reparatur-Kosten → unplanmäßige Ausgabe 50-200€
- Inflations-Schock → Wunschpreise +15% in einer Nacht
- Marktcrash → -30% auf alle Aktien/ETF

Lehrt: Notgroschen, Diversifikation, Liquidität.

## Phase-Übergänge

- **MVP (Phase 1)**: Heimathafen + Spar-Insel + Tageszyklus + Sleep-Loop + 5 Quests
- **Phase 2**: ETF, Anleihen, Aktien-Archipel, Wetter, Vergleichs-UI
- **Phase 3**: Vulkan, Inflation-Atoll, Krisen-Events, Schulden, Notgroschen
- **Phase 4**: Zeitreise-Insel, Eltern-Modus, iOS, Polish, Privat-Release auf Sohn-Gerät
