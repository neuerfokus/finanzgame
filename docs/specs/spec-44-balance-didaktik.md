# Spec — Balance, Dynamik & Didaktik-Refactor

> **Für Claude Code.** Dieses Doc bündelt die nächsten sinnvollen Änderungen an Spiel-Logik, Schwierigkeit und Lehreffekt. Es ist bewusst länger als ein Sprint-Spec (≤100 Zeilen) — **bitte in einzelne `docs/specs/spec-NN-*.md` aufteilen**, je Abschnitt ein Sprint. Reihenfolge = Priorität.
>
> Konventionen wie gehabt: Money in Cents (int, nie Doubles), Riverpod 3, Freezed 3 sealed unions, Drift-Migration explizit, GameClock.advanceDay() ist die einzige Event-Quelle, kein Realtime-Tick.

---

## Leitprinzip (gilt für ALLE Änderungen)

Drei Sätze, an denen jede Mechanik gemessen wird:

1. **Passiv schlägt Aktiv.** Der lukrativste Loop im Lategame muss der sein, der *nichts tut* (investiert halten), nicht der, der täglich antippt. Sonst lehrt das Spiel „Reichtum = Grind".
2. **Die Lektion ist die Erholung, nicht der Crash.** Crash = Setup, Recovery = Punchline. Wer hält, gewinnt. UI darf nie nur den Schmerz zeigen.
3. **Anti-Konsum ohne Moralkeule.** Konsequenzen zeigen, nie predigen. Die *Zahl* spricht, nicht der Text.

Ein Gegen-Antipattern, das wir aktiv vermeiden: **Gold darf nicht zum Helden werden.** „Kauf Gold vorm Crash" = Market-Timing = falsche Lektion. Gold ist Volatilitäts-Dämpfer, kein Performer. Erholung + Streuung sind die Helden.

---

## Übersicht & Prioritäten

| # | Abschnitt | Lehrziel | Aufwand | Prio |
|---|---|---|---|---|
| A | Reward-Hierarchie: Passiv > Aktiv | „Geld arbeitet, während du schläfst" | M | **kritisch** |
| B | Marktzyklen statt Zufallsrauschen | Märkte erholen sich | M | hoch |
| C | Crash-UI & Panic-Sell-Flow | Panik kostet, Geduld zahlt | M–L | hoch |
| D | Schwierigkeits-Eskalation | Stakes wachsen mit „Alter" | M | hoch |
| E | Neue Lehr-Mechaniken | Opportunität / Streuung / Spar-Quote / Versicherung | M | mittel |
| F | Sachwerte & Immobilien (neue Asset-Familie) | Liquidität / Tragekosten / Hebel / Cashflow | L | mittel |
| G | Anpassung offene Items 11 & 14 | Quests = Startkapital, nicht Income | S | mittel |
| H | Datenmodell-Sammelmigration | — | S | (Begleit-PR) |

---

## A. Reward-Hierarchie: Passiv schlägt Aktiv  *(kritisch)*

**Warum.** Aktuell: Pflanzen 3–15 %/Tag, Metalle ~16 %/Jahr, ETF/Sparen darunter. Ein 14-Jähriger rechnet das in zwei Tagen aus und optimiert auf tägliches Pflanzen-Farmen. Mechanisch korrekt, pädagogisch invers: im echten Leben schlägt aktives Traden den Index fast nie. Der lukrativste Loop darf nicht der „tägliche-Antippen"-Loop sein.

**Was.**
- Pflanzen bleiben **Onboarding-Zucker**, werden aber im Lategame hart gedeckelt: Ertrag skaliert NUR über Plot-Anzahl (fix, teuer freischaltbar) + Saison-Ausfälle, **nicht** mit Kapital. Absoluter Pflanzen-Ertrag/Tag läuft gegen eine Decke.
- Passiver Pfad (ETF/Sparen/diversifiziert) skaliert **prozentual mit Kapital** und zieht ab einem Schwellen-Kapital mühelos an Pflanzen vorbei.
- **Zielmoment inszenieren:** Sobald in einem `advanceDay()` der passive Ertrag erstmals den Tages-Pflanzen-Ertrag übersteigt, ein einmaliges DaySummary-Highlight: *„Dein ETF hat heute mehr gemacht als deine ganze Ernte — im Schlaf."*

**Wo.**
- `lib/domain/plant/plant.dart` — `PlantKindSpec.yield` Doku-Kommentar: Ertrag ist Onboarding, nicht Lategame.
- `lib/features/plant/plant_repository.dart` — Tages-Ertrag gegen `GameBalance.plantDailyYieldCapCents` clampen.
- `lib/core/game_balance.dart` — neue Konstante `plantDailyYieldCapCents`; passiv-Raten so kalibrieren, dass Break-Even bei realistischem Lategame-Kapital liegt.
- Day-Pipeline (`advanceDay()`) — Flag/Event für den erstmaligen „Passiv > Aktiv"-Moment (siehe H: `firstPassiveBeatActive`).

**Umsetzung-Hinweis.** Konkrete Startwerte stehen im **[Anhang — Balancing-Referenztabelle](#anhang--balancing-referenztabelle-startwerte)** unten. Diese Tabelle als Kommentar-Block 1:1 in `game_balance.dart` / `metal.dart` ablegen, damit Balancing nachvollziehbar bleibt. Ziel ist dort durchgerechnet: ETF schlägt die Pflanzen-Decke ab ~6.900 € Kapital, Edelmetalle liegen bewusst **unter** dem ETF.

**UI-Normalisierung (gehört hierher).** Gemischte Horizonte (%/Tag vs. %/Jahr) verzerren Spieler- *und* Balancing-Wahrnehmung. **Investierbare Assets einheitlich als „% p. a."** anzeigen (Spar/ETF/Gold/Silber/Platin/Diversifiziert). **Pflanzen NICHT als % p. a.** anzeigen — sonst sähe „3 %/Tag" hochgerechnet absurd hoch aus und würde in die andere Richtung lügen. Pflanzen sind ein gedeckelter, aktiver Mechanismus → Anzeige als **absolute „max €/Tag"** bzw. „€ pro Ernte". Lektion dahinter: *Pflanzen = Job mit Lohndecke, Investieren = % das mit deinem Geld mitwächst.* Anzeige-Formel zentral, nicht pro Widget.

---

## B. Marktzyklen statt Zufallsrauschen  *(hoch)*

**Warum.** Reine Volatilität als Zufallsrauschen lehrt nichts. Was lehrt: **Zyklen mit Erholung** — ein sichtbarer Crash, der sich über mehrere Spieltage zurückholt, aber nur für die, die nicht in Panik verkauft haben.

**Was.**
- Crash ist kein Einzel-Tages-Random, sondern ein **Zustand über mehrere Tage**: Drawdown → Boden → Erholung. Erholung deterministisch über die Pipeline, nicht zufällig.
- Pro Asset-Klasse unterschiedliche Crash-Reaktion: ETF tief & erholt sich, Gold flacht durch (kleiner Drop, kaum Erholung — bewusst *nicht* als „Retter" framen, nur als ruhiger).
- **Krypto-Spektrum:** Bitcoin (Leit-Krypto) hochvolatil, erholt sich historisch — Altcoins als „Casino" mit bewusst verlockendem erstem Gewinn (FOMO muss man *fühlen*), damit der spätere Absturz als Lehre sitzt. Beides Risiko-Lehre, kein Income-Pfad.

**Wo.**
- `lib/domain/sim/` — neuer Markt-Zustand (z. B. `MarketPhase` sealed: `normal / drawdown / recovery`), pro Klasse parametrisiert.
- `advanceDay()`-Pipeline — feste Reihenfolge beibehalten (Allowance → Insel-Erträge → Pflanzen → Inflation → Wetter); Markt-Phase **vor** Insel-Erträgen auflösen.
- `lib/domain/metal/metal.dart` / Asset-Specs — pro Klasse `crashDepth` + `recoverySpeed`.

**Umsetzung-Hinweis.** Determinismus zwingend (Sim-Tests ≥90 % Coverage). Crash-Trigger über seeded RNG, aber Verlauf danach deterministisch ableitbar, damit Tests reproduzierbar sind.

---

## C. Crash-UI & Panic-Sell-Flow  *(hoch)*

Das didaktische Konzept ist schon drin (Crash-Marker im Zeitreise-Chart). Es fehlt die **zweite Hälfte: die Erholung** und die **personalisierte** Aufbereitung.

### C1 — DaySummary-Breakdown (neutral, nicht wertend)
- Beitrag **pro Klasse** zeigen: `ETF −X € · Gold ±0 € · Cash 0 €`. **Keine** „Gold hat dich gerettet"-Wertung.
- Zusatzzeile **„vs. letztem Höchststand"**, und explizit als **Buchverlust** kennzeichnen: *„noch nicht real — erst beim Verkaufen"*. (Begriff realisiert vs. unrealisiert ist die Kern-Unterscheidung im ganzen Thema.)
- Wo: `lib/domain/sim/day_summary.dart` (Felder), DaySummary-Screen-Widget.

### C2 — Crash-Marker-Tooltip
- Marker zeigt Drop-% statt nur Linie. **Am Marker** Tages-% , für die große Erzählung **Peak-to-Trough** („−34 % vom Höchststand").
- Reiner UX-Gewinn, niedrige Kosten — zuerst machen.
- Wo: Zeitreise-Chart-Widget.

### C3 — Geisterlinie (die eigentliche Lektion)
Drei-Wege-Vergleich im Zeitreise-Chart nach einem Crash:
- **alles ETF** / **alles Gold** / **gestreut**.
- Kurzfristig: Gold flachste Kurve. Langfristig: gestreut zieht an Gold vorbei, nah an All-ETF, bei ruhigerer Fahrt. → zeigt „warum streuen", statt es zu behaupten.
- Wo: Zeitreise-Chart, neue Overlay-Serien (gerechnet, nicht gespeichert).

### C4 — Panic-Sell-getriggerter Quest-Flow (Kern)
Quest feuert **nur**, wenn der Junge **während** eines Crashes verkauft hat — nicht generisch.

State, das getrackt werden muss:
- `peakValueCents` pro Asset-Klasse (gleitendes Allzeit-/Fenster-Hoch).
- `soldDuringDrawdown` Flag + `soldAtDrawdownPct` + `soldOnDay` (gesetzt, wenn Verkauf bei `MarketPhase.drawdown`).
- `recoveryThresholdPct` (z. B. Markt wieder > Verkaufs-Niveau).

Logik in `advanceDay()`:
```
wenn soldDuringDrawdown == true
   und Markt erreicht recoveryThreshold:
       -> DayEvent.panicSellRealized(verlustCents, verkauftBeiPct, jetztPct)
       -> Post-Crash-Quest: "Du hast vor N Tagen bei −28 % verkauft.
          Markt steht wieder +4 %. Das war −Y €."
wenn KEIN Verkauf im Drawdown (gehalten):
       -> DayEvent.heldThroughCrash(...)
       -> Lob-Quest: "Durchgehalten — das machen die wenigsten."
```
Wichtig: **richtiges Verhalten belohnen**, nicht nur falsches bestrafen.

- Wo: DayEvent sealed union (`lib/domain/sim/day_event.dart`), `advanceDay()`-Pipeline, Quest-Trigger, neue State-Felder (siehe H).

---

## D. Schwierigkeits-Eskalation  *(hoch)*

**Warum.** „ETF in 2 Wochen" → danach fehlt Eskalation, der Druck verpufft. Ein 80-Jahre-Lebens-Arc verlangt steigende Stakes.

**Was.**
- **Logarithmisch gestaffelte Ziele:** 100 € → 1.000 € → 10.000 € → … Jede Stufe schaltet Insel/Mechanik frei. So bleibt der Druck konstant.
- **Mitwachsende Lebenskosten** mit „Alter": eigenes Zimmer → Wohnung → größere Anschaffungen. Das Sparziel wächst mit, statt nach dem ersten Win zu kollabieren.
- `sleepCostCents` (=10) bleibt als Mikro-Kosten; die *großen* wiederkehrenden Kosten kommen über die Lebenskosten-Staffel.

**Wo.**
- `lib/core/game_balance.dart` — Ziel-Staffel + Lebenskosten-Tabelle (an Spieltag/„Alter" gekoppelt).
- Insel-/Unlock-Logik — Freischaltung an Ziel-Stufe binden statt an Einzel-Trigger.
- `docs/island-roadmap.md` — Staffel dokumentieren.

---

## E. Neue Lehr-Mechaniken  *(mittel)*

### E1 — Opportunitätskosten sichtbar
Gibt der Junge z. B. 150 € für SnipeShot-Sneaker aus, später **optionale** Geisterlinie im Zeitreise-Chart: *„diese 150 € wären heute X €."* Subtil, kein Text-Vorwurf. Anti-Konsum ohne Predigt.
- Wo: Konsum-Ausgaben mit Zeitstempel + Betrag protokollieren; Zeitreise-Chart rechnet hypothetische Rendite.

### E2 — Diversifikation belohnen
Portfolio-Bonus bei Streuung: spürbar **geringere Gesamt-Volatilität**, wenn über **≥3 Klassen** verteilt. Macht „nicht alle Eier in einen Korb" erfahrbar statt zum Glossar-Eintrag.
- Wo: Markt-/Ertrags-Auflösung in `advanceDay()`; Volatilitäts-Dämpfung als Funktion der Klassen-Anzahl.

### E3 — Spar-Quote als Entscheidung (Pay-yourself-first)
Statt Monatsgeld automatisch ins Wünsch-Geld: einstellbarer Slider, der einen Teil **zuerst** in den Spar-Topf schiebt, bevor das Wünsch-Geld sichtbar wird.
- Wo: Allowance-Schritt der Pipeline (erster Schritt!), Settings/Bank-UI, neues State-Feld `savingsRatePct`.

### E4 — Versicherungen (Risiko-Transfer, kein Investment)
**Warum.** Versicherung ist kein Asset, sondern das Gegenteil von Anlegen: man zahlt eine **kleine sichere Kosten**, um einen **großen unsicheren Verlust** abzufedern. Erwartungswert ist leicht negativ (sonst gäbe es keine Versicherer) — trotzdem sinnvoll, wenn der Schaden einen sonst ruinieren würde. Das ist eine der nützlichsten und am meisten missverstandenen Finanz-Lektionen.

**Was.** Koppelt direkt an die Random-Events (Item 14, Abschnitt G). Pro Versicherung: monatliche Prämie (Allowance-Schritt) → deckt einen bestimmten Schadens-Eventtyp ab.
- **Hausrat/Sachwert-Versicherung:** schützt Sammlerwerte/Immobilie gegen „Diebstahl/Schaden"-Event (passt zu F).
- **Haftpflicht:** schützt gegen seltenes, großes „du musst Schaden zahlen"-Event.
- **Bewusst sinnlose Option** (Lehrfalle): z. B. „Handy-Vollkasko fürs alte Handy" — Prämie höher als der mögliche Schaden. Wer sie abschließt, lernt: *Kleinkram nicht versichern.*

**Die Doppel-Lektion (Kern):** *Versichere, was du dir nicht leisten kannst zu verlieren (Haus, Haftung) — nicht den Kleinkram.* Über-Versicherung ist genauso ein Fehler wie Unter-Versicherung. Kein Moralfinger: die Bilanz nach ein paar Jahren zeigt es selbst.

- **Wo:** `lib/domain/insurance/` (Policy mit `premiumCentsPerMonth`, `coversEventType`, `payoutCents`); Prämie im Allowance-Schritt; bei passendem Random-Event in `advanceDay()` Auszahlung statt voller Schaden; DaySummary zeigt „Versicherung hat X € Schaden abgefangen" bzw. „Prämie gezahlt, kein Schaden".

---

## F. Sachwerte & Immobilien — eigene Asset-Familie  *(mittel)*

**Warum.** Diese Klasse bricht bewusst die Annahmen der liquiden Assets: man kann **nicht jederzeit zum Marktpreis verkaufen**, das Halten **kostet Geld**, der Kauf hat einen **Spread** (man ist sofort im Minus), und Cashflow gibt es nur teilweise. Genau diese Reibungen sind der Lehrwert — sie lassen den langweiligen, liquiden, breit gestreuten ETF im Vergleich gut aussehen. Anti-Konsum ohne Moralkeule: ein Oldtimer oder ein Gemälde *darf* Spaß machen, das Spiel zeigt nur ehrlich die Kosten.

> **Leitprinzip-Asterisk (ehrlich bleiben):** Es gibt **eine** legitime Ausnahme von „passiv schlägt aktiv" — **gehebeltes Mietobjekt** (Mehrfamilienhaus). Das *kann* den ETF schlagen. Aber zum Preis von Aufwand, Illiquidität, Klumpenrisiko und Hebel-Risiko. Dieser Asterisk ist selbst die Lektion (Hebel wirkt in beide Richtungen). Der Default-Gewinner für einen hands-off-Teenager bleibt der gestreute ETF.

### F1 — Sammlerwerte (Oldtimer, Diamant 1 Karat, Gemälde klassisch/modern, Briefmarken)

Geteilte Mechaniken (alle Sammlerwerte):
- **Spread:** Kauf zu `preis × (1 + aufschlag)`, Verkauf zu `preis × (1 − abschlag)` → man steht **sofort im Minus**.
- **Verkaufs-Verzögerung:** Verkauf ist kein Sofort-Klick. „Zum Verkauf anbieten" → wird über `advanceDay()` nach **N Tagen** abgewickelt (passt zum Tageszyklus). Sofortverkauf nur mit Extra-Abschlag. → Lektion **Liquidität**.
- **Tragekosten:** pro `advanceDay()` abgezogen (Versicherung/Lagerung/Wartung). Oldtimer hoch, Briefmarken ~0.
- **Kein laufender Cashflow** — reine Preisspekulation.
- **Echtheits-/Moderisiko** bei Gemälde modern + Diamant.

Pro Item die konkrete Lektion:

| Item | Rendite-Profil | Kern-Lektion |
|---|---|---|
| **Diamant 1 Karat** | Retail-Aufschlag ~30 % → beim Kauf **sofort tief im Minus**, jahrelang unter Wasser | „Du verlierst Geld in der Sekunde, in der du es im Laden kaufst." Der Klassiker. |
| **Oldtimer** | kleine Wertsteigerung, aber **hohe Tragekosten** fressen sie auf | „Spaß ≠ Investment" + Tragekosten |
| **Gemälde klassisch** | langsam, stabil, extrem illiquide, Experten-/Echtheitsrisiko | nur Top-Stücke halten Wert; Wissen nötig; Illiquidität |
| **Gemälde modern** | spekulativ, hohe Varianz, kann gegen ~0 gehen | Moderisiko, „heißer heute = wertlos morgen" |
| **Briefmarken** | ~0–2 %, **schrumpfender** Sammlermarkt | Sammlermärkte können *kleiner* werden (immer weniger Sammler) |

- **Wo:** neues Domain-Model `lib/domain/collectible/collectible.dart` (Freezed) mit `spreadBps`, `carryCostCentsPerDay`, `sellDelayDays`, `volatility`; Repository `lib/features/collectible/`; Verkaufs-Listing-State über `advanceDay()`; Tragekosten im Tages-Pipeline-Schritt (nach Insel-Erträgen, vor Inflation).

### F2 — Immobilien-Leiter (Lebenszyklus + Hebel + Cashflow)

Die Leiter **ist gleichzeitig die Lebenskosten-Eskalation aus Abschnitt D** — beides zusammen denken. Wert-Reihenfolge (aufsteigend):

```
WG-Zimmer (Miete, kein Besitz)
  → Eigentumswohnung
  → Reihenhaus
  → Doppelhaushälfte        ← FEHLT aktuell, hier einfügen (zwischen Reihenhaus und freistehendem Haus)
  → freistehendes Haus
  → Mehrfamilienhaus (Vermietung → echter Cashflow)
```

Neue Mechaniken (das ist der eigentliche Brocken, daher Aufwand **L**):
- **Hebel/Hypothek:** Kauf mit Anzahlung + monatlicher Rate (im **Allowance-Schritt** der Pipeline abgezogen, zusammen mit E3-Spar-Quote). Hebel verstärkt Gewinn **und** Verlust — vorsichtig einführen, am besten mit einer einmaligen Erklär-Cutscene.
- **Kaufnebenkosten ~10–12 % einmalig** (Grunderwerbsteuer + Notar + Makler) → „10 % sind beim Kauf sofort weg". Parallele zum Diamant-Spread.
- **Instandhaltung:** laufende Kosten für **selbstgenutzte** Immobilien → wirft **keinen** Cashflow ab. Lektion: *Das Eigenheim ist Konsum + Zwangssparen + Hebel, kein reines Investment.*
- **Mieteinnahmen:** nur **Mehrfamilienhaus** zahlt monatliche Miete (echter Cashflow) — abzüglich Instandhaltung + **Leerstandsrisiko**. → erst hier wird Immobilie zum *Investment*.
- **Spekulationssteuer:** Verkauf **< 10 Jahre** & nicht selbstgenutzt → Steuer auf den Gewinn. Bildungs-Aha, parallel zur Schenkungssteuer aus Item 14 (siehe Abschnitt G).
- **Klumpenrisiko:** ein riesiges Einzel-Asset, undiversifiziert → in der E2-Diversifikations-Logik **negativ** gewichten, wenn fast alles in einer Immobilie steckt.

- **Wo:** `lib/domain/realestate/property.dart` (Freezed; `purchasePriceCents`, `kaufnebenkostenBps`, `mortgageState`, `monthlyRentCents?`, `maintenanceCentsPerDay`, `purchaseDay` für Spekulationsfrist, `isSelfOccupied`); Repository `lib/features/realestate/`; Hypotheken-Rate im Allowance-Schritt; Miete/Instandhaltung/Wertänderung in `advanceDay()`; Leiter-Freischaltung an D-Ziel-Stufen koppeln.

**Balancing-Startwerte:** siehe Anhang **A.7** (Sammlerwerte) und **A.8** (Immobilien).

---

## G. Anpassung offene Items 11 & 14  *(mittel)*

**Item 11 — Quest-Belohnungen ×2: vorsichtig dosieren.** Quests sollen **Startkapital + Wissen** sein, nicht der Haupt-Income. Wenn Quest-Cash mit dem Investieren konkurriert, untergräbt es Abschnitt A. → Multiplikator moderat, eher Wissens-/Unlock-Belohnung als Cash-Flut.

**Item 14 — Random-Events: gut fürs Game-Feel, aber kein „Reichtum = Zufall".** Lucky-Events selten halten; die Schenkungssteuer-Lektion (Freibetrag Geschwister/Fremde 20.000 €, darüber 7 %) ist ein guter Aha. Achten: Events dürfen nicht den Eindruck erwecken, Vermögen sei vor allem Glück.

---

## H. Datenmodell-Sammelmigration  *(Begleit-PR, Drift)*

Neue/zusätzliche persistente Felder über alle Abschnitte gesammelt → **eine** Schema-Migration `schemaVersion 13 → 14`, explizit:

- `peakValueCents` pro Asset-Klasse (C4)
- `soldDuringDrawdown` / `soldAtDrawdownPct` / `soldOnDay` (C4)
- `savingsRatePct` (E3)
- Konsum-Ausgaben-Log: Betrag + Tag (E1)
- ggf. `marketPhase`-Persistenz, falls Phase über Tage gehalten wird (B)
- Flag `firstPassiveBeatActiveShown` (A, Einmal-Highlight)
- **Sammlerwerte (F1):** Bestände mit `purchasePriceCents`, `boughtOnDay`, Verkaufs-Listing-State (`listedOnDay`, `listingResolvesOnDay`)
- **Immobilien (F2):** `purchasePriceCents`, `purchaseDay` (Spekulationsfrist), `mortgageRemainingCents`, `monthlyPaymentCents`, `isSelfOccupied`, `monthlyRentCents?`, `vacancy`-State
- **Versicherungen (E4):** aktive Policies mit `premiumCentsPerMonth`, `coversEventType`, `payoutCents`
- **Einzelaktien (A.1):** pro Holding `tickerId` (fiktiv), `bankrupt`-Flag (für „erholt sich nie")
- **Krypto (A.9):** `cryptoRegime` (Euphorie/Seitwärts/Winter), `daysInRegime`, Altcoin-`dead`-Flag

Neue DayEvent-Varianten (Freezed sealed, `day_event.dart`):
`panicSellRealized` · `heldThroughCrash` · `firstPassiveBeatActive` · `crashStarted` · `recoveryComplete` · `collectibleSold` (nach Listing-Ablauf) · `rentCollected` · `spekulationssteuerCharged` · `insurancePaidOut` / `premiumCharged` (E4) · `stockBankrupt` (A.1).

---

## Anhang — Balancing-Referenztabelle (Startwerte)

> **Alle Werte sind Startwerte zum Spieltesten mit dem Sohn**, keine finalen Konstanten. Sie sind so gewählt, dass die drei Leitprinzipien aufgehen: Passiv schlägt Aktiv im Lategame, Edelmetalle liegen unter dem breiten Index, Pflanzen plateauen. Diesen ganzen Anhang als Kommentar-Block in `game_balance.dart` spiegeln.

### A.1 — Ziel-Renditen pro Asset-Klasse

| Asset | Ziel-Rendite **p. a.** | Volatilität | Crash-Verhalten | Anzeige-Einheit | Rolle im Spiel |
|---|---|---|---|---|---|
| Sparkonto | **2,5 %** | keine | unberührt | % p. a. | sichere Basis, Liquidität |
| ETF (Welt) | **8 %** | mittel | tiefer Drop, **volle Erholung** | % p. a. | **Lategame-Held**, passiver Kern |
| Aktiv gem. Fonds | **~6 %** (nach Gebühren, **unter** ETF) | mittel | wie ETF, nur teurer | % p. a. | **Gebühren-Lehre**: „die Bank verkauft dir das" |
| Einzelaktie (fiktiv) | **~8 % erwartet**, aber breit streuend | **hoch** | tiefer Drop, **Erholung NICHT garantiert** (Firma kann pleitegehen → dauerhaft 0) | % p. a. | **Kontrast zum ETF**: Klumpenrisiko |
| Gold | **4 %** | niedrig | kleiner Drop, kaum Erholung | % p. a. | Ruhe-Anker, **kein** Performer |
| Silber | **5 %** | hoch | mittlerer Drop | % p. a. | volatiles Edelmetall |
| Platin | **5 %** | mittel | mittlerer Drop | % p. a. | volatiles Edelmetall |
| Bitcoin (Leit-Krypto) | spekulativ, hist. gewachsen, **hohe Unsicherheit** | **sehr hoch** | brutaler Drop (−50…−80 %), hist. Erholung | Spannweite ±% | „wenn überhaupt Krypto, **dann das**" |
| Altcoins (Krypto-Casino) | **~0 / negativ erwartet**, viele →0 | extrem | Drop oft **ohne** Erholung, Totalverlust möglich | Spannweite ±% | reines **Casino** / Pump-&-Dump |
| Diversifiziert (≥3 Klassen) | gewichteter Schnitt | **gedämpft** (siehe A.4) | gedämpfter Drop | % p. a. | **belohntes Verhalten** |
| Pflanzen | gedeckelt (kein %) | Saison-Ausfall | unberührt | **max €/Tag** | Onboarding-„Job", plateaut früh |

**Einzelaktie vs. ETF — die Kernlektion.** Der erwartete Ertrag einer Einzelaktie ist *nicht* höher als der Markt — nur die **Streuung** ist viel größer, und sie kann **dauerhaft auf 0** gehen (Insolvenz). Der ETF erholt sich nach einem Crash (er hält hunderte Firmen), die Einzelaktie u. U. **nie**. Das ist der schärfste Beweis für „nicht alle Eier in einen Korb". Spieltechnisch: pro Crash kleine Chance, dass eine Einzelaktie *nicht* in die Erholung geht. Fiktive Ticker only (CLAUDE.md-Hardregel) — z. B. `SnipeShot AG`, `DropTok`. Phase-8-Aktien-Archipel ist der Ort dafür.

**Aktiv gemanagter Fonds — die Gebühren-Lehre.** Ein ETF *ist* technisch ein Fonds (börsengehandelter Indexfonds). Der aktiv gemanagte Fonds versucht, den Markt zu schlagen, kostet aber Ausgabeaufschlag (bis ~5 %) + laufende Gebühr (~1,5–2 %/Jahr) — und schlägt den Index nach Kosten meist **nicht**. Rolle im Spiel: derselbe Markt wie der ETF, nur ~2 % Rendite weniger durch Gebühren → verliert systematisch. Optional als „Bankberater-Angebot" inszenieren. Lektion: *Gebühren fressen Rendite, aktiv schlägt passiv selten.*

**Krypto getrennt: Bitcoin ≠ Altcoins.** Bewusst zwei Assets. Bitcoin = das etablierte Leit-Asset („digitales Gold"-Framing), historisch gewachsen, aber mit brutalen Drawdowns; erholt sich historisch. Altcoins = Casino: die meisten Projekte sterben, Drop oft ohne Wiederkehr. Lektion: *selbst innerhalb Krypto gibt es ein Spektrum von „hochspekulativ aber etabliert" bis „reines Glücksspiel".* **Wichtig:** Bitcoin trotzdem nicht als „sicher" verkaufen — es bleibt hochvolatil und ohne Cashflow.

**Naming-Frage (deine Hardregel).** Bitcoin ist streng genommen **keine Marke** (kein Unternehmen dahinter, ähnlich wie „Gold" — und Gold heißt im Spiel ja auch Gold). Es ohne Marken-Verstoß **„Bitcoin" zu nennen ist vertretbar.** Deine Entscheidung: entweder echt „Bitcoin", oder generisch „die größte Kryptowährung". Die **Altcoins** in jedem Fall generisch/Fantasie halten (z. B. Fantasie-Coins „MoonDoge"), nie echte Coin-Namen.

### A.2 — ⚠️ Bewusster Rebalance der Edelmetalle (Abweichung von aktuell!)

| Asset | aktuell (STATE.md) | **neu (Ziel)** | Warum |
|---|---|---|---|
| Gold | ~16 %/J | **4 %/J** | Solange Gold den ETF schlägt **und** ruhiger ist, lehrt das Spiel „kauf Gold vorm Crash" = Market-Timing-Falle. Muss klar unter den ETF. |
| Silber | ~8,8 %/J | **5 %/J** | dito, bleibt aber volatiler als Gold |
| Platin | ~9,9 %/J | **5 %/J** | dito |

Begründung in einem Satz für den Commit: *Edelmetalle müssen unter dem breiten Aktienindex liegen, sonst trägt die Kernlektion „diversifiziertes Aktien-Investieren gewinnt langfristig" nicht.* Gold bleibt attraktiv über sein **niedriges Crash-Verhalten** (C3-Geisterlinie zeigt das), nicht über Rendite.

### A.3 — Engine-Mapping (Tages-Rate aus Jahres-Rendite)

Die Sim rechnet pro `advanceDay()`. Tages-Rate aus Ziel-Jahresrendite:

```
tagesRate = (1 + jahresRendite)^(1/365) − 1
```

| Asset | Ziel p. a. | → Tages-Rate (Anzeige bleibt p. a.!) |
|---|---|---|
| Sparkonto | 2,5 % | ≈ 0,00676 %/Tag |
| ETF | 8 % | ≈ 0,02110 %/Tag |
| Gold | 4 % | ≈ 0,01075 %/Tag |
| Silber/Platin | 5 % | ≈ 0,01338 %/Tag |

Claude Code: die Engine-Konstanten in `metal.dart` / Asset-Specs so **zurückrechnen**, dass diese Jahres-Ziele rauskommen; die aktuellen Werte sind der Ausgangspunkt zum Anpassen. Determinismus beachten (Sim-Tests).

### A.4 — Diversifikations-Bonus (Abschnitt E2, konkret)

Kein Renditebonus — nur Volatilitäts-Dämpfung („einziges Free Lunch ist Streuung"):

```
effektiveVol = basisVol × max(0.5, 1 − 0.15 × (anzahlKlassen − 1))
diversifizierteRendite = gewichteter Schnitt der Einzel-Renditen   // KEIN Aufschlag
```

| Klassen im Depot | Vol-Faktor |
|---|---|
| 1 | 1,00 (volle Schwankung) |
| 2 | 0,85 |
| 3 | 0,70 |
| 4 | 0,55 |
| 5+ | 0,50 (Boden) |

### A.5 — Pflanzen-Decke & Crossover (das Herzstück von Abschnitt A)

Pflanzen-Einkommen ist **linear & gedeckelt**, passives Einkommen ist **exponentiell** (% vom Kapital). Startwerte:

- `plantDailyYieldCapCents = 150` → **max 1,50 €/Tag** Pflanzen-Ertrag, hart geclamped.
- Decke entsteht aus fixer Plot-Zahl (z. B. max 10 Plots, teuer freischaltbar) × fixem Ertrag/Zyklus — **skaliert NICHT mit Kapital**.
- Jahres-Decke Pflanzen ≈ **550 €** (≈ 1,50 €/Tag).

**Crossover-Punkt** (passiver Jahresertrag = Pflanzen-Decke 550 €):

| Kapital im Asset | ETF-Ertrag/J (8 %) | Pflanzen-Decke/J | Gewinner |
|---|---|---|---|
| 1.000 € | 80 € | 550 € | Pflanzen |
| 5.000 € | 400 € | 550 € | Pflanzen (knapp) |
| **~6.900 €** | **552 €** | 550 € | **≈ Break-even** ← Zielmoment |
| 10.000 € | 800 € | 550 € | ETF |
| 25.000 € | 2.000 € | 550 € | ETF deutlich |
| 50.000 € | 4.000 € | 550 € | ETF dominiert |

Crossover je Asset = `550 € / jahresRendite`: **ETF ~6.900 €**, Gold ~13.750 €, Sparkonto ~22.000 €. → **Der ETF ist das erste Asset, das die Pflanzen schlägt** — und das landet sauber rund um die 10.000-€-Ziel-Stufe (Abschnitt D). Genau hier das einmalige Highlight `firstPassiveBeatActive` (Abschnitt A / H) feuern.

### A.6 — Was Claude Code damit tun soll

1. Werte aus A.1–A.5 als Kommentar-Block in `game_balance.dart` spiegeln (Single Source of Truth fürs Balancing).
2. Edelmetall-Renditen in `metal.dart` auf A.2 absenken.
3. `plantDailyYieldCapCents = 150` einführen + Clamp in `plant_repository.dart`.
4. Crossover-Schwelle (~6.900 €) als Trigger-Konstante für `firstPassiveBeatActive`.
5. Diversifikations-Vol-Dämpfung (A.4) in der Ertrags-/Markt-Auflösung.
6. **Nach dem Spieltest mit dem Sohn nachjustieren** — diese Tabelle ist der Startpunkt, nicht das Ziel.

### A.7 — Sammlerwerte (Sektion F1, Startwerte)

Alle deutlich **unter** dem ETF — die Reibung ist Absicht. Spread = Differenz Kauf/Verkauf in Prozent (man steht sofort um diesen Betrag im Minus).

| Asset | Rendite p. a. | Vol | Spread (Kauf/Verkauf) | Tragekosten/Jahr | Verkaufs-Verzögerung | Cashflow |
|---|---|---|---|---|---|---|
| Diamant 1 Karat | ~1 % | niedrig | **~30 %** (Retail-Aufschlag) | 0 | 3 Tage | nein |
| Oldtimer | ~3 % | mittel | ~15 % | **~8 %** (Garage/Versich./Wartung) | 5 Tage | nein |
| Gemälde klassisch | ~3 % | niedrig–mittel | ~20 % | ~2 % (Versicherung) | 7 Tage | nein |
| Gemälde modern | ~2 % (hohe Varianz, kann →0) | **hoch** | ~25 % | ~2 % | 7 Tage | nein |
| Briefmarken | ~0–1 % (schrumpfender Markt) | niedrig | ~20 % | ~0 % | 7 Tage | nein |

> **Hinweis Diamant-Spread:** 30 % ist die spielfreundliche Variante. In der Realität ist der Wiederverkauf oft nur **25–50 % des Kaufpreises** (Verlust also 40–60 %). Falls die Lektion härter sitzen soll: hochdrehen. Für eine optionale Info-Karte: *„Diamanten verlieren beim Kauf sofort massiv an Wert — das ist im echten Leben so."*

Engine-Felder: `spreadBps`, `carryCostBpsPerYear` (→ pro Tag /365 abziehen), `sellDelayDays`, `volatility`, `appreciationPerYear`. Sofortverkauf = zusätzlicher Abschlag statt Verzögerung.

### A.8 — Immobilien-Leiter (Sektion F2, Startwerte)

Preise als grobe Orientierung (in €, fürs Spiel skalierbar). **Wertsteigerung ~3,5 % p. a.** für alle (unter ETF!) — der Reiz kommt aus **Hebel** + (beim Mehrfamilienhaus) **Mietrendite**, nicht aus der Wertsteigerung.

| Stufe | Richtpreis | Hypothek möglich? | Mietrendite (brutto) | Instandhaltung/Jahr | Rolle |
|---|---|---|---|---|---|
| WG-Zimmer | — (nur Miete) | nein | — | — | Lebenskosten, kein Besitz |
| Eigentumswohnung | ~120.000 | ja | — (selbstgenutzt) | ~1,2 % | erstes Eigentum |
| Reihenhaus | ~280.000 | ja | — | ~1,2 % | Familien-Eigenheim |
| **Doppelhaushälfte** | ~340.000 | ja | — | ~1,2 % | **NEU einfügen**, zwischen Reihenhaus & freistehendem Haus |
| freistehendes Haus | ~480.000 | ja | — | ~1,5 % | gehobenes Eigenheim |
| Mehrfamilienhaus | ~750.000 | ja | **~4 %** | ~1,5 % | **echtes Mietobjekt = Cashflow** |

Gemeinsame Konstanten:
- **Kaufnebenkosten** einmalig: **~11 %** vom Kaufpreis (Grunderwerbsteuer + Notar + Makler) → sofort weg.
- **Hypothek:** Anzahlung z. B. 20 %, Rest als monatliche Rate im Allowance-Schritt; einfacher Tilgungs-/Zins-Mix genügt fürs Spiel.
- **Spekulationssteuer:** Verkauf < **10 Jahre** & nicht selbstgenutzt → Steuer auf Gewinn (Satz wie Einkommensteuer-Platzhalter, z. B. 25 %).
- **Leerstandsrisiko** Mehrfamilienhaus: kleine Chance pro Monat, dass Miete ausfällt.
- **Klumpenrisiko:** in der E2-Diversifikations-Logik **negativ** zählen, wenn >60 % des Vermögens in einer Immobilie steckt.

**Ehrlicher Asterisk (für den Commit-Text):** gehebeltes Mehrfamilienhaus *kann* den ETF schlagen — Hebel + Mietrendite. Genau deshalb ist es das einzige Asset, das die „passiv > aktiv"-Regel legitim bricht; der Preis ist Aufwand, Illiquidität, Klumpen- und Hebel-Risiko. Das ist die Lektion, kein Bug.

### A.9 — Bitcoin & Altcoins: Vola-/Drift-Parametrisierung (kein Renditeversprechen)

**Grundidee.** Krypto wird **nicht** über eine feste Jahresrendite modelliert (das wäre ein Versprechen), sondern über **Zufallspfad mit Regimes**. Der erwartete Langfrist-Drift liegt **≈ 0** — der Reiz kommt aus der **Volatilität**, nicht aus garantiertem Wachstum. Lektion: *Wer mit Krypto reich wurde, hatte beim Timing meist Glück; man kauft genauso leicht das Top.*

**Modell** (Geometric Brownian Motion + Sprünge + Regimes), pro `advanceDay()`, seeded RNG:

```text
Z         = gaussian(rng)                    // N(0,1)
regime    = currentCryptoRegime              // s. Tabelle
logReturn = regime.driftPerDay + regime.volPerDay * Z

if rng.next() < regime.jumpProb:             // Fat Tails / Spikes
    mag  = uniform(regime.jumpMin, regime.jumpMax)
    sign = (rng.next() < 0.5) ? +1 : -1      // WICHTIG: 50/50, mittelwertneutral!
    logReturn += sign * mag                  // Sprung erzeugt Spikes, KEINEN Drift

price = max(price * exp(logReturn), floorPrice)   // sehr tief möglich, nie exakt 0

daysInRegime++
if daysInRegime >= regime.minDays and rng.next() < (1 / regime.life):
    regime = pickNext(rng, transitionMatrix); daysInRegime = 0
```

> **⚠️ Wichtigste Erkenntnis aus der Simulation (`krypto_sim.py`):** Sprünge **müssen mittelwertneutral** sein (50/50 +/−). Ein erster Versuch mit richtungsabhängigen Sprüngen („meist −" im Winter) erzeugte heimlich einen riesigen negativen Drift → Median fiel auf ~0, 95 % Verlust. **Richtung gehört in den Regime-Drift, nicht in die Sprünge.** Zweitens: die Übergangsmatrix muss verhindern, dass der Winter die Zeit dominiert (sonst kippt der Median wieder). Die Werte unten sind **gegen die Simulation validiert**.

**Bitcoin — Regime-Parameter (validierte Startwerte):** Sprung-Range = Betrag, Vorzeichen 50/50.

| Regime | drift/Tag | vol/Tag | jumpProb | jump-Betrag | minDauer | mittl. Lebensdauer |
|---|---|---|---|---|---|---|
| Euphorie (Bull) | **+0,45 %** | 4,0 % | 3 % | 8…35 % | 30 T | 70 T |
| Seitwärts (Chop) | **0,00 %** | 3,0 % | 2 % | 6…20 % | 30 T | 90 T |
| Krypto-Winter (Bear) | **−0,24 %** | 4,5 % | 3 % | 10…40 % | 60 T | 110 T |

**Übergangsmatrix** (nach Mindestdauer, Wechsel-Rate 1/Lebensdauer pro Tag):

| von \ nach | Euphorie | Seitwärts | Winter |
|---|---|---|---|
| Euphorie | — | 0,40 | 0,60 (Blase platzt) |
| Seitwärts | 0,55 | — | 0,45 |
| Winter | 0,45 (Erholung) | 0,55 | — |

**Simulationsergebnis (8000 Pfade, je Horizont):** Genau das gewünschte „bitcoinige" Profil — Münzwurf ohne Versprechen, fetter Aufwärts-Schwanz:

| Horizont | Bitcoin Median | P(Verlust) | p5 / p95 | ETF zum Vergleich |
|---|---|---|---|---|
| 2 Jahre | 1,13x | **47 %** | 0,07x / 16x | Median 1,17x, **27 %** Verlust |
| 5 Jahre | 1,21x | **47 %** | 0,01x / 80x | Median 1,47x, **17 %** Verlust |
| 10 Jahre | 1,26x | **48 %** | 0,003x / 540x | Median 2,15x, **9 %** Verlust |
| 30 Jahre | 1,72x | **46 %** | ~0 / 63000x | Median 10,2x, **1 %** Verlust |

**Die Kernlektion in einer Zeile:** Bei Bitcoin bleibt die Verlustwahrscheinlichkeit über **jeden** Horizont bei ~47 % — **Zeit heilt das Risiko nicht**. Beim ETF sinkt sie 27 % → 1 %, der Median wächst stetig. *„Zeit im Markt" belohnt den ETF-Halter, den Krypto-Halter nicht.* Bitcoins Reiz ist allein der Schwanz (9–39 % Chance auf >10x) — das ist das FOMO, mechanisch ehrlich abgebildet, ohne es zu versprechen.

**Stell-Schraube „Langfrist-Tendenz" (wichtig — Werte-Entscheidung, keine Berechnung):** `cryptoLongRunDriftPerYear` addiert einen Drift auf alle Regimes. Wirkung (validiert):

| Drift | 5 J: Median / P(Verlust) | 10 J: Median / P(Verlust) |
|---|---|---|
| **0 %** (rein flach) | 1,19x / 47 % | 1,20x / 48 % |
| **+10 %/J** (empfohlen-Bereich) | 1,79x / 41 % | 3,51x / 37 % |
| +20 %/J | 3,17x / 33 % | 7,68x / 29 % |
| +30 %/J | 4,27x / 29 % | 19,6x / 22 % |
| *ETF 8 %* | *~1,5x / 17 %* | *~2,2x / 9 %* |

**Schlüssel-Beobachtung:** Egal wie hoch der Drift — die **Verlustquote fällt nie unter ~22 %** (ETF: 9 %), weil die Vola das Risiko dominiert. Das Risiko ist irreduzibel. **Empfehlung fürs Lernziel:** Drift **nicht** auf 0 (wirkt manipuliert, der Junge merkt's und schaltet ab). **+5…+10 %/Jahr** ist glaubwürdig: Bitcoin lohnt sich *können*, ist manchmal überlegen, bleibt aber risikoadjustiert klar unter dem ETF — Lektion kommt aus Verlustquote + Drawdowns, nicht aus erzwungenem Verlust. Median nie verlässlich über den ETF heben.

**EMPFOHLEN: tapernder Drift (`krypto_sim` → `taper_sim.py`).** Statt eines festen Drifts fällt der Aufschlag exponentiell — früh hoch, mit der Reife abflachend. Bildet die Realität ab: Bitcoin ist seit 2016 ~+15.000 % gestiegen, aber die frühen Wachstumsraten **können sich nicht wiederholen** (von 1,3 Bio. $ Marktkap. nochmal 150x wäre größer als alle Aktienmärkte). Die Log-Kurve knickt oben ab — genau das modelliert der Taper.

```text
driftOffsetProJahr(t) = END + (START − END) · exp(−t / TAU)
START = +12 %/Jahr   END = +3 %/Jahr   TAU = 6 Jahre
→ J0: 12 % · J5: 6,4 % · J10: 4,8 % · J20: 3,3 % · J30: 3,0 %
```

**Validiertes Ergebnis (8000 Pfade) — das ist die ganze Lektion in einer Tabelle:**

| Jahr | Bitcoin (taper 12→3) | ETF 8 % | Wer führt im Median? |
|---|---|---|---|
| 2 | 1,34x · **43 %** Verlust | 1,17x · 28 % | Bitcoin (früh verlockend) |
| 5 | 1,88x · **41 %** Verlust | 1,47x · 17 % | Bitcoin |
| 10 | 2,74x · **39 %** Verlust | 2,18x · 9 % | Bitcoin knapp |
| 20 | 4,63x · **39 %** Verlust | 4,64x · 3 % | **Gleichstand — ETF holt auf** |
| 30 | 8,27x · **36 %** Verlust | 10,0x · **1 %** | **ETF zieht vorbei** |

**Warum das die beste Variante ist:** Bitcoin darf früh glänzen (respektiert „es ist ja gestiegen") und ist verlockend — aber sein Drift komprimiert, der ETF holt um Jahr ~20 auf und zieht im Median vorbei, **und die Verlustquote bleibt die ganze Zeit bei ~36–43 %** (ETF: 1–28 %). Lektion ohne Moralkeule: *Spekulation kann früh blenden, aber der geduldige Index-Anleger gewinnt am Ende — fast ohne Verlustrisiko.* Zugleich transportiert der Taper die Meta-Lektion **„Wachstumsraten flachen mit der Reife ab"** mechanisch.

**Altcoins — gleiches Modell, schlechtere Werte + Tod:**
- Drift in allen Regimes negativer (Euphorie +0,35 %, Seitwärts −0,12 %, Winter −0,28 %), vol **4,5–6 %/Tag**.
- **Coin-Tod:** ~0,03 %/`advanceDay()`, dass ein Altcoin dauerhaft auf ~0 fällt (Rug-Pull/Projekt stirbt) — analog `stockBankrupt`. Bitcoin hat **kein** Tod-Flag. Das ist der mechanische Kern von „Bitcoin ≠ Casino".
- **Sim-Ergebnis:** P(Verlust) 72 % (2 J) → 86 % (5 J) → 95 % (10 J). Altcoins **sterben mit der Zeit** — das exakte Gegenteil des ETF. Casino bestätigt.

**Crash-Kopplung (Abschnitt B):** Bei marktweitem Crash → Krypto zwangsweise in `Krypto-Winter` + einmaliger zusätzlicher Down-Sprung (Krypto fällt härter als ETF). Erholung bei Bitcoin über spätere Euphorie möglich, bei Altcoins ungewiss.

**Determinismus:** `cryptoRegime` + `daysInRegime` persistieren (siehe H), RNG seeded → Tests reproduzierbar. Test: gleicher Seed ⇒ gleicher Pfad.

**Caveat (aus der Sim):** der mittlere max. Drawdown liegt über 30 J bei ~99 % — über so lange Horizonte touchiert fast jeder Pfad mal ein sehr tiefes Tief. Über realistische Spiel-Horizonte (Monate bis wenige Jahre) sind Drawdowns von 60–85 % typisch, was „echter" wirkt. Falls die Tiefs zu brutal wirken: vol leicht senken.

**Validierungs-Werkzeug:** `krypto_sim.py` (im Output) rechnet diese Parameter über 8000 Pfade × 30 Jahre durch und plottet die Verteilung. Vor jeder Parameter-Änderung dort gegenchecken, bevor es in `game_balance.dart` wandert.

**Display & Lehr-Hook:** nie „% p. a.", sondern 30-Tage-Veränderung + deutliche Vola-Warnung. Nach einem großen Swing optionaler Aha: Geisterlinie „hättest du am Top gekauft: −X €" bzw. „am Boden: +Y €" — zeigt, dass es Timing/Glück war, nicht Können.

---

## Test-Anforderungen (über alle Abschnitte)

- Sim-Engine **deterministisch**, ≥90 % Coverage — Crash→Recovery-Verlauf reproduzierbar.
- Pipeline-Reihenfolge unverändert testen: Allowance → Insel-Erträge → Pflanzen → Inflation → Wetter (Markt-Phase davor auflösen).
- Panic-Sell-Flow: Tests für *verkauft* vs. *gehalten* (beide Quest-Pfade).
- Sachwerte: Spread (sofort im Minus), Verkaufs-Verzögerung über Tage, Tragekosten-Abzug pro Tag.
- Immobilien: Hebel in **beide** Richtungen (Gewinn & Verlust), Spekulationssteuer < 10 Jahre, Mieteinnahme abzgl. Leerstand/Instandhaltung.
- Versicherung (E4): Prämie wird gezogen; bei passendem Event Auszahlung statt vollem Schaden; „sinnlose" Police kostet netto.
- Einzelaktie (A.1): Pleite-Fall — Holding geht auf 0 und erholt sich **nicht** (Kontrast zum ETF testen).
- Krypto (A.9): gleicher Seed ⇒ gleicher Pfad (Determinismus); Netto-Drift über vollen Zyklus ≈ 0; Altcoin-Tod-Flag bleibt dauerhaft 0, Bitcoin hat keins.
- Golden-Tests für DaySummary-Breakdown + Zeitreise-Geisterlinien.
- `flutter analyze --fatal-infos` clean.

## Empfohlene Sprint-Aufteilung

1. **A** (Reward-Hierarchie + UI-Normalisierung) — Fundament, zuerst.
2. **B** (Marktzyklen) — Voraussetzung für C.
3. **C** (Crash-UI + Panic-Sell-Flow) — größter Lehreffekt.
4. **D** (Eskalation) — parallel möglich; **mit F2 (Immobilien-Leiter) zusammen denken**, da dieselbe Lebenszyklus-Mechanik.
5. **E** (4 Mechaniken: Opportunität / Streuung / Spar-Quote / Versicherung) — je eigener kleiner Sprint.
6. **F** (Sachwerte & Immobilien) — größter Einzelbrocken (L); F1 Sammlerwerte und F2 Immobilien als zwei Teil-Sprints.
7. **G** (Item-Anpassung) — Cleanup.

`H` als Begleit-Migration im jeweils ersten Sprint, der das Feld braucht.
