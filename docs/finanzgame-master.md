# FINANZGAME — Integriertes Konzept-, Markt- und Technik-Dokument

## TL;DR
- **Konzeptionell:** Das aktuelle „fühlt sich Mist an" ist kein Bug, sondern ein klassisches Sim-Tickrate- und Game-Feel-Problem. Lösung: weg vom kontinuierlichen Echtzeit-Simulator, hin zu einem **deterministischen, spielerinitiierten Tageszyklus à la Stardew Valley** — ein „Schlafen"-Button beendet den Tag, alle Insel-Erträge, Pflanzen-Wachstumsschritte und Events werden gebatcht und mit Juiciness präsentiert. Das eliminiert das +20 €-Gefühl in einer einzigen Architektur-Entscheidung.
- **Markt/USP:** Die DACH-Konkurrenz (Bling, pockid, Sparkasse-Planspiel, Finstep) ist primär „Karte + Konto + Lerntools"; international (Greenlight, Zogo, Banzai) sind es Quiz-Apps mit Punkten. **Niemand baut eine ernsthafte Pixel-Art-Insel-Sim mit Investmentmetapher und Anti-Konsum-Haltung.** Genau diese Nische ist eure USP.
- **Technisch:** **Refactor statt Neustart.** Flutter 3.x + Riverpod 3 + Drift + Freezed ist die richtige Basis. Flame Engine zwischen-schieben für Monetaria-Inseln, Sim-Engine auf Tageszyklus umbauen, CLAUDE.md + Phasen-Specs für Claude Code anlegen. In 2–3 Wochen ist die App grundlegend besser, in 10–12 Wochen V1-fertig.

---

## A) Konkurrenzanalyse

### A.1 Teen-Finanz-Apps (DACH + international)

| App | Modell | Pädagogik | Spielspaß | Bemerkung |
|---|---|---|---|---|
| **Bling** (DE, Berlin, gegr. 2021; Treezor/Solarisbank) | Family-Fintech, Prepaid-Karte ab 2,99 €/Mon, Spartöpfe, „Sparbaum" (Evergreen GmbH), seit 2024 Mobilfunk + Nachhilfe (Ubimaster) | „Mit Pädagog:innen entwickelt" — flach | Keiner | Real-Money-Fokus; „Sparbaum" ist der Konkurrent, der eurer Inselmetapher am nächsten kommt — aber rein als Visualisierung eines ETF-Sparplans |
| **pockid** (DE, Hamburg) | Konto ab 7 J., Debit-Mastercard (auch Kirschholz), BE-IBAN | Minimal | Keiner | Banking-Tool |
| **KNAX** (Sparkassen) | Sparbuch + Maskottchen | Klassisch, sehr kindlich | Niedrig | Markenkommunikation |
| **Finstep** (DE, seit 2023) | Quiz-Gamification 12–18 J. | Strukturiert | Niedrig | Schul-Feeling |
| **Planspiel Börse** (Sparkassen seit 1983) | 11 Wochen, ab Klasse 8, 50 k€ Startkapital, 175 Wertpapiere | Realitätsnah | Wettbewerb statt Spiel | Friedrich-Verlag kritisiert: lehrt eher Spekulation als Investieren |
| **Tradity** (DE) | Schul-Börsenspiel | Real | Mittel | Schulisch |
| **Greenlight** (US, über 6,5 Mio. Eltern und Kinder laut Sacra Mai 2025, ~75 Bank-Partnerschaften inkl. JPMorgan Chase und U.S. Bank) | Debit + „Level Up"-Game, Eltern-Zinsen, Investing ab 1 $ | Solide Quiz-Reihe | Mittel | $5,99/Mon, US-only |
| **Acorns Early / GoHenry** (US/UK) | „Money Missions" (animiert + Quiz) | Stark didaktisch | Mittel | Kein Sim-Anteil |
| **Step** (US) | Konto + Credit-Building | Niedrig | Niedrig | Banking |
| **Zogo** (US, B2B2C, ab 13 J.) | Bite-sized Lektionen, Punkte → Gift Cards; laut zogo.com „over 1,200+ modules on a variety of financial topics, allowing users to earn points as they learn, which can then be exchanged for real-life rewards" | Stark | Niedrig (Quiz) | Reine extrinsische Belohnung (SDT-problematisch) |
| **Banzai** (US, von Banken/Credit Unions finanziert) | „Choose your adventure" mit 32 Szenarios; 20 Sprachen | Klassenzimmer-tauglich | Mittel | Web, kein Mobile-Sim |
| **Long Game / Stash** | Lotterie-/Mikroinvest | Schwach (operant conditioning) | Hoch (problematisch) | Negativbeispiel, Glücksspielnähe |

### A.2 Edutainment-Sims mit Wirtschafts-Subtext

- **Stardew Valley** (Eric Barone / ConcernedApe): 20 h Tag (6–2 Uhr), „Schlafen"-Button beendet Tag, 1 Spielminute = 0,7 Realsekunden, **Zeit pausiert in Menüs**; Pflanzen brauchen 6–12 Tage. Versteckte Wirtschaftslehre: Opportunitätskosten, Spezialisierung, Saisonalität.
- **Animal Crossing**: Echtzeit-Uhr, Schulden-Loop bei Tom Nook, „Stalk Market" (Rüben-Spekulation) — bewusste Investment-Metapher.
- **Roblox – Adopt Me / Royale High**: Junge Teens, aber Tausch-Ökonomie mit Scam-/FOMO-Risiken — als Negativbeispiel relevant.
- **Pixel-Art-Referenzen 2024–2026**: Sea of Stars (Sabotage Studio), Eastward, CrossCode, Octopath Traveler, Cassette Beasts, Owlboy.

### A.3 Marktlücken / USP

1. **Pixel-Art-Sim mit echter Investment-Didaktik** (weder reine Quiz-App noch reine Banking-App).
2. **Anti-Konsum-Haltung als Feature** — sonst überall „spend more"-Loops.
3. **Offline-first, ohne Tracking, ohne PII** — quasi einzigartig im Sektor.
4. **Deutschsprachig, kulturell verankert** — DACH-Apps pädagogisch dünn, US-Apps schlecht lokalisiert.
5. **Vater-Sohn-Produktion** ohne Monetarisierungs-Verzerrung — emotional ehrlich.

---

## B) Pädagogisch-didaktische Grundlagen

### B.1 Forschungslage (Deutschland)

**Wichtige Klarstellung:** Deutschland hat am PISA Financial Literacy Assessment **2022 nicht teilgenommen** — und auch in keinem früheren Zyklus (2012, 2015, 2018). Begründung der KMK laut verbraucherbildung.de: „Der daraus resultierende zusätzliche finanzielle und organisatorische Aufwand schien für eine nicht im allgemeinen Lehrplan vorhandene … Option 'Financial Literacy' nicht gerechtfertigt." Die Finanztip-Stiftung sammelte am 24.10.2025 binnen 24 Stunden über 45.000 Unterschriften für eine Teilnahme 2029. Es gibt **keinen offiziellen PISA-Score für deutsche 15-Jährige**.

Häufig damit verwechselt: **OECD/INFE Erwachsenenstudie 2023** — Deutschland Platz 1 von 39 mit 76/100 (OECD-Schnitt 63). Das ist Erwachsenenwissen, nicht Jugendwissen.

**Bankenverband Jugendstudie 2024** (Kantar, n=700, 14–24 J., Veröffentlichung 29.11.2024):
- **74 %** kennen den Begriff „Inflationsrate" (2021: 56 %), aber **nur 18 %** können die aktuelle Rate annähernd beziffern.
- **28 %** können nicht sagen, was eine Aktie ist.
- **35 %** wissen, dass die EZB für Preisstabilität zuständig ist.
- **80 %** geben an, in der Schule „wenig" oder „so gut wie nichts" zu Finanzen gelernt zu haben; **92 %** wünschen sich mehr Wirtschafts-/Finanzwissen.

**OECD PISA 2022 (international, Vergleichswert)**: 18 % der 15-Jährigen in OECD-Ländern unter Level 2 (Basisproficiency). Laut OECD-Bericht „PISA 2022 Results Volume IV": *„only one in four students reported that they had learnt about compound interest in school and still know what this means, and fewer than one in five about diversification, on average across OECD countries and economies."* Spitzenreiter: Österreich, Belgien-Flandern, Dänemark, Niederlande, Kanadische Provinzen, Tschechien, Polen.

**Deutsche Landesinitiativen (2025/26):**
- **Bayern „Alltagskompetenzen — Schule fürs Leben"** seit 2020/21 (NICHT hessisch!), Pflicht-Projektwochen Klassen 1–4 und 5–9.
- **Hessen „Finanzkompetenz Made in Hessen"**: SAFE-Hessenmonitor 2024/25, Zukunftstage, Handreichung „Verstehen, Entscheiden, Handeln" (Okt. 2025).
- **Sachsen-Anhalt:** ab 2026/27 Pflichtfach „Wirtschaft" Gymnasium Klassen 7+8 (1 h/Woche).
- **Hamburg:** „School Meets Finance" (FCH, 2025).
- **Bundesweites Pflichtfach:** existiert nicht; nationale Finanzbildungsstrategie nach Ampel-Aus „auf Eis" (Bankenverband).

### B.2 Lernreihenfolge für 14-Jährige

| Phase | Konzept | Spielmechanik | Metapher |
|---|---|---|---|
| 1 | Geld, Bedürfnis vs. Wunsch, Sparen | Allowance + Wunschliste + Sparziel | Schatzkiste |
| 2 | Einfache Zinsen, Geduld | Sparbuch-Insel | Pflanze, die langsam wächst |
| 3 | **Zinseszins** | Vergleichs-Plots, sichtbare Beschleunigung | Karnickel-Vermehrung / Schneeball |
| 4 | **Inflation** | Wunschlisten-Preise steigen | Eis schmilzt im Geldsack |
| 5 | Risiko vs. Rendite | Insel-Wahl, Wetter = Volatilität | Wetter über den Inseln |
| 6 | **Diversifikation** | Mehrere Inseln gleichzeitig | Mischwald / Spinnennetz |
| 7 | Liquidität | Wie schnell kommst du an dein Geld? | Boots-Klassen (Kanu ↔ Kreuzfahrtschiff) |
| 8 | Opportunitätskosten | Tageszeit-Budget | „Du kannst nicht alles" |
| 9 | Steuern-Basics | Spielwährungs-Abgabe auf Gewinne | Hafenmeister-Zoll |

Bewährte Metaphern (laut Federal Reserve Education, GoHenry, Powwow): Compound interest als wachsender Baum, Pizza-Aktie für Aktienbesitz, Schneeball für Zinseszins. **Karnickel-Zinseszins** ist seltener, aber didaktisch potent (multiplikatives Wachstum visualisierbar). **Mischwald für Diversifikation** ist eine originelle, starke Metapher.

### B.3 Session-Länge

Laut peer-reviewed microlearning-Studie im International Journal of Educational Practice: *„Session duration emerges as a critical variable, with optimal learning outcomes observed for sessions lasting 8–12 minutes. This duration appears to maximize content delivery while respecting cognitive load limitations."* — Daraus für FINANZGAME: 1 Spieltag ≈ 3–7 Min Realzeit aktive Zeit, dazu Schlaf-Cutscene → eine typische Session 8–12 Min mit 2–3 Spieltagen.

### B.4 Schul-Feeling vermeiden

- **Kein Quiz-Frontalfeuer.** Lernen aus Konsequenzen: Inflation merkt man am steigenden Wunschlisten-Preis.
- **Story > Erklärtext.** Quest „Opa Walter hat einen alten Schatz auf der Spar-Insel" lehrt mehr als ein Compound-Interest-Modal.
- **Optionale Wiki-Seiten in der In-Game-Bank-App** für Kinder, die tiefer eintauchen wollen — niemals zwingen.
- **Anti-Moralkeule:** Konsumismus ist eine spielbare Option, aber zeigt seine Konsequenzen (kein Geld am Monatsende = keine Investments).

---

## C) Game-Design / Game-Feel

### C.1 Juice & Feedback

Das **Kernproblem** ist nicht die Logik, sondern die Polish-Schicht. Nach Vlambeer/Jan Willem Nijman (The Art of Screenshake) und Mark Brown (Game Maker's Toolkit „Secrets of Game Feel and Juice"):

- **Screen shake** bei Geld-Events
- **Tweens** (Squash & Stretch) für Buttons, Münzen, Pflanzen — `easeOutBack` für „pop"
- **Particles** beim Ernten/Verkaufen
- **Hit-Pause** (Freeze-Frame 50–100 ms) bei wichtigen Events
- **Sound zu jedem Tap** (auch leise — Stille = tot)

Vlambeer-Quote: „Juicing relies mainly on 2 domains: animation and audio." Mit Flame + `flutter_animate` in Flutter sauber erreichbar.

### C.2 Sim-Zeit vs. Echtzeit — die +20 €-Lösung

**Diagnose:** Aktuell läuft ein Echtzeit-Tick → Allowance/Events feuern entkoppelt von Spieleraktion → kein Belohnungs-Kausalität, kein Game-Feel.

**Architektur (Stardew-inspiriert):**
- **Spielerinitiierter Tageszyklus.** Kein Realtime-Tick mehr in der Sim.
- 1 Spieltag = beliebig komprimierbar (3–7 Min aktive Zeit + Schlaf-Cutscene).
- Allowance, Insel-Erträge, Pflanzenwachstum, Inflation, Volatilität-Wetter: **alle in `advanceDay()` gebatcht**.
- **Wochen-Event** (Sa): Markttag mit Bonus-Verkauf.
- **Monats-Event**: Zinszahlung, Steuerabrechnung, neue Quest.
- **Beschleunigungs-Option** „Lange Reise" = 7 Tage skippen (mit Cooldown gegen Binge-Skip).

Dies löst gleichzeitig Game-Feel (Anticipation + Reveal), Lerndidaktik (sichtbare Kausalität) und Tech-Komplexität (deterministischer Code, keine Race-Conditions).

### C.3 Onboarding

Apple Developer Guidelines + UX-Collective-Best-Practices:
- **Start direkt im Spiel**, kein Splash-Screen-Wall.
- **One mechanic at a time**: Zimmer betreten → Wunsch auf Wunschliste → Quest „Opa schenkt 10 €" → erstes Sparen → Sparbuch-Insel öffnet sich.
- **Quick Win in <60 s**, „Wow-Moment" am Ende.
- Vorbilder: Genshin Impact (NPC-Begleiter erklärt im Vorbeigehen), Stardew (Brief + Quest), Clash Royale (mehrere kurze Tutorials, jedes baut auf).

### C.4 Belohnungen ethisch (Self-Determination Theory)

Ryan/Deci SDT: **Autonomie, Kompetenz, Verbundenheit**. Für eine Vater-Sohn-App besonders wichtig:
- **Variable Money-Rewards (Zogo-Gift-Cards-Modell) sind tabu** — Operant Conditioning bei Minderjährigen.
- **XP & Badges OK**, wenn an echte Kompetenz gekoppelt („Du hast die Krise überstanden, ohne Notgroschen anzutasten").
- **Streaks-mit-Bestrafung vermeiden** (Duolingo-Falle: introjizierte Motivation, nicht intrinsisch).
- **Player Agency stark betonen**: mehrere Wege zum Ziel; keine „One-True-Strategy".

### C.5 Pixel-Art-Stil 2026

**Empfohlener Look: Sea of Stars / Eastward-Schule** — Pixel Art mit modernem dynamischen Licht, höherer Auflösung als reines SNES, satte Farben, animierte Umweltsprites. Nicht streng 8-bit (wirkt kindisch).

- Tile-Auflösung 32×32, Charaktere 48×64 oder 32×48.
- Palette max. 32 Farben (Lospec-Paletten als Referenz).
- Vorbilder: Sea of Stars, Eastward, Owlboy, Stardew, CrossCode, Octopath Traveler (HD-2D als End-Game-Ziel).
- **Custom-Pixel-Font Pflicht** (m6x11 von Daniel Linssen oder PixelOperator von Jayvee Enaguas — beide kommerziell frei).

### C.6 Sound

- **SFX:** Bfxr / jsfxr (browser, free, Output CC0).
- **Musik:** BeepBox, LMMS, Kevin MacLeod (CC-BY) oder OpenGameArt-Tracks (Lizenz prüfen).
- **Mindest-Set:** Daytime-Loop, Schlaf-Stinger, Monetaria-Theme, Insel-Spezial pro Insel.

---

## D) Konzept-Integration: Insel-Hub mit Pflanzen-Sub-Mechanik

### D.1 Map & Navigation

**Karte „Archipel Monetaria":** Zentrales Heimathafen-Eiland (UI-Hub) mit Boot. Inseln am Horizont werden mit Progression sichtbar / freigeschaltet.

Navigation: Tap auf Insel → Boot-Animation → Inselansicht (isometrisch oder Top-Down-Mini-Welt) → auf Insel: Pflanzen-Plot, Erklär-NPC, Insel-Aktion (Einzahlung/Ernte/Verkauf/Risiko-Event) → zurück per Boot-Button.

**Wetter (Volatilitäts-Visualisierung):** Sonne = normales Wachstum; Regen = Hausse; Sturm = Bärenmarkt-Event. Insel-spezifische Wetterhärte: Spar-Insel fast immer sonnig, Vulkan oft Sturm.

### D.2 Insel-Roadmap (Progression-Gating)

| # | Insel | Lernkonzept | Pflanzen-/Lebewesen-Mechanik | Boot | Freischaltung |
|---|---|---|---|---|---|
| 1 | Heimathafen | Geld, Wunschliste, Tageszyklus | — | Ruderboot | Start |
| 2 | **Spar-Insel** (Elefantenfuß) | Sicheres Sparen, einfache Zinsen | Elefantenfuß-Pflanze: sehr langsam, robust, geringe Ernte | Ruderboot | Nach 5 Spieltagen + Quest |
| 3 | **Mischwald-Insel** (ETF) | Diversifikation, Zinseszins | 5+ Baumarten; mehr Arten = stabilerer Ertrag; Schneeball-Effekt | Segelboot | Spar-Insel Lvl 3 |
| 4 | **Wiesen-Insel** (Anleihen) | Fester Zins, Laufzeit | Karnickel-Gehege: vorhersagbare Würfe | Segelboot | Quest „Opa zeigt 'Anleihe'" |
| 5 | **Aktien-Archipel** | Einzelaktien, Pizza-Aktien | Einzelne Obstbäume mit variierendem Risiko/Ertrag | Kutter | ETF-Insel Lvl 3 |
| 6 | **Vulkan-Insel** (alternative Assets) | Hohes Risiko, FOMO-Lehre | Vulkan-Kaktus blüht selten, explosiv (oder Totalausfall) | Kutter | Aktien Lvl 3 + Quest „Was Kumpel Max nicht erzählt" |
| 7 | **Inflations-Atoll** | Inflation, Realzins | Salzwasser-Pflanzen verlieren Ertrag; Wunschlisten-Preise steigen | — | Mid-Game-Event |
| 8 | **Zeitreise-Insel** | Zinseszins über Jahrzehnte | Skip-Modus 10/20 Jahre, zeigt Compounding-Effekt | Zeitschiff | End-Game |

Diese Reihenfolge spiegelt die Lernreihenfolge aus B.2 und integriert die bestehenden Konzepte (Boots-Klassen, Wetter, Spinnennetz, Zeitreise) systematisch.

### D.3 Pflanzen-Sub-Mechanik (Harvest-Moon-artig, aber Finanzlogik)

Jede Pflanze hat: Pflanzkosten (Investitionssumme), Wachstumsdauer in Tagen (Liquidität), Erntemenge (Rendite), Wetteranfälligkeit (Volatilität), Reife-Mehrfachertrag (Zinseszins, wenn stehen gelassen).

**Beispiel-Balancing-Startwerte (iterativ verfeinern):**
- Elefantenfuß: 50 Kosten, 3 Tage, 52 Ertrag (~1,3 %/Tag), 0 Wetterrisiko.
- Mischwald-Plot: 200 Kosten, 5 Tage, 220 Ertrag Standard, +20 % wenn alle stehen blieben.
- Vulkan-Kaktus: 100 Kosten, 7 Tage, 50 % Chance auf 30 Ertrag / 50 % Chance auf 250.

### D.4 Das +20 €-Problem — die Lösung in 3 Schritten

1. **Game Loop umstellen** auf spielerinitiiertes „Tag beenden". Keine Echtzeit-Ticks mehr in der Sim-Engine; eine `advanceDay()`-Methode batched alles.
2. **Schlaf-Cutscene mit Reveal**: Black fade → 3-sec Pixel-Animation (Mond, Wecker, Sonnenaufgang) → **Day Summary Screen** mit Liste „+10 € Taschengeld, +1,30 € Spar-Insel-Zinsen, Elefantenfuß ist 1 Stufe gewachsen, Wetterprognose: Sturm über Vulkan-Insel". Jede Zeile mit Sound, Pop-Animation und 60 ms gestaffeltem Reveal.
3. **Sichtbarer Day-Counter** dauerhaft in der UI.

Effekt: Belohnung wird wahrnehmbar, Lernen wird kausal, Game-Feel ist da.

---

## E) Technische Roadmap für „Claude Code Vibe Coding"

### E.1 Bewertung der bestehenden Architektur

| Komponente | Bewertung | Empfehlung |
|---|---|---|
| Flutter 3.41 | Top, stabil | Beibehalten; auf 3.4x-aktuell heben |
| Clean Architecture | Solide, aber Overhead-Risiko bei Hobby-Scope | Beibehalten, pragmatisch |
| Riverpod 3 | Best Practice | Beibehalten, riverpod_generator nutzen |
| Drift | Beste SQLite-Lib für Flutter | Beibehalten; saubere Migrationen |
| Freezed 3 | Standard | Beibehalten |
| **Sim-Engine (Tick-basiert)** | **Problemquelle** | **Umbauen** → spielerinitiierter Tag |
| **Quest-Runner (unvollständig)** | Schwachstelle | **Refactor**: deklarativ YAML + Riverpod |
| **UI (Placeholder)** | Aktuelle Lücke | **Ersetzen**: Flame Engine für Spielinhalte, Flutter-Widgets für UI-Chrome |

**Verdikt:** Refactor — kein Neustart. Begründung in G.4.

### E.2 Flame Engine integrieren

Flame ist 2025/26 production-ready (live-coded Beispiele auf flutter.dev/games). Vorgehen:
- **Phone-UI-Springboard:** bleibt reines Flutter (schneller iterativ).
- **Monetaria-Map + Inselansichten:** Flame `FlameGame` als eingebettetes Widget.
- Sprite-Animation, Wetter-Particles, Pflanzen-Wachstum: Flame Components.
- Audio: `flame_audio` oder `audioplayers`.
- Tiled-Maps via `flame_tiled`.

### E.3 CLAUDE.md (max. 200 Zeilen, „WHY/WHAT/HOW", progressive disclosure)

```markdown
# FINANZGAME — CLAUDE.md

## WHY
Finanzbildungs-App für Jugendliche.
Hardregeln: keine echten Marken, keine echten Aktien, keine
Lootboxen/Mikrotransaktionen, offline-first, keine PII, kein Tracking,
anti-Konsum ohne Moralkeule.

## WHAT
Flutter-Android-App mit zwei Welten:
- Phone-UI-Springboard (Flutter Widgets)
- Monetaria Insel-Hub (Flame Engine)

## Commands
- flutter run -d android
- flutter test
- dart run build_runner build --delete-conflicting-outputs
- flutter analyze

## Project Structure
lib/
  core/      # Domain, deterministische Sim-Engine, GameClock
  data/      # Drift-DB, Repositories
  features/  # Feature-Module (phone_ui, monetaria, quests)
  game/      # Flame-Spielkomponenten
  ui/        # Flutter-Widgets, Theme, Animationen

## Conventions
- Riverpod 3 mit code generation (riverpod_generator)
- Freezed für alle Domain-Modelle
- Drift mit Type Converters
- Spec-driven: jeder Sprint hat eine specs/spec-XX-name.md
- Game Loop: spielerinitiierter Tageszyklus, NIEMALS Echtzeit-Tick
- Testing: unit (Sim), golden (UI), widget (Riverpod-States)
- Assets: jedes Asset in ASSETS.md mit Quelle + Lizenz + Datum

## Reference Documents (progressive disclosure)
- Game-Design-Bibel: @docs/game-design.md
- Sim-Engine-Architektur: @docs/sim-engine.md
- Insel-Roadmap: @docs/island-roadmap.md
- Pixel-Art-Pipeline: @docs/asset-pipeline.md
```

Best-Practice-Hintergrund: HumanLayer empfiehlt <300 Zeilen, gerne <60 (HumanLayer-Root-CLAUDE.md). Anthropic-Doku „Best practices for Claude Code" betont „progressive disclosure" — keine Stuffing-Datei.

### E.4 Werkzeugkette

| Zweck | Tool | Lizenz |
|---|---|---|
| Code-Gen | build_runner, freezed, drift_dev, riverpod_generator | OSS |
| Linting | flutter_lints, very_good_analysis | OSS |
| Testing | flutter_test, riverpod_test, golden_toolkit | OSS |
| **Pixel Art** | **Aseprite ($19,99 auf Steam, einmalig)** oder **Pixelorama** (free, OSS) oder **LibreSprite** (free, OSS) | siehe E.5 |
| **AI-Pixel-Art** | Retro Diffusion ($20 Aseprite-Extension; **Lizenzwarnung**, siehe E.5) | proprietary |
| **SFX** | Bfxr / jsfxr (browser, free) | Output CC0 |
| **Musik** | BeepBox (free), LMMS (GPL), Kevin MacLeod (CC-BY) | gemischt |
| Tilemaps | Tiled + flame_tiled | OSS |
| Asset-Packs | Kenney (CC0), OpenGameArt (gemischt) | siehe E.5 |

### E.5 Asset-Lizenzen — auch fürs Hobby wichtig

- **Kenney.nl**: **CC0 / Public Domain**. Selbst kommerziell ohne Attribution. Erste Wahl für Tiles/UI/SFX. Offiziell auf kenney.nl/support: „Yes, all game assets on the asset pages are public domain licensed (CC0). You're free to use them, even in commercial projects."
- **OpenGameArt.org**: Gemischt (CC0, CC-BY, CC-BY-SA, GPL). **Pro Asset prüfen.** CC-BY-SA hat Copyleft — beim privaten Projekt OK, bei späterer Veröffentlichung beachten.
- **itch.io Asset-Packs**: Pro Pack Lizenz lesen, meist „commercial OK, no redistribution".
- **Retro Diffusion EULA**: enthält explizit „You are not permitted to … reproduce, copy, distribute, resell or otherwise use the **Model** for any commercial purpose". Bezieht sich auf das **Modell**, nicht zwingend auf generierte Bilder — aber ambig. Für privates Vater-Sohn-Projekt unkritisch; bei Store-Release vorher mit Astropulse klären oder selbst pixeln.
- **Pixel-Fonts**: m6x11 (Daniel Linssen, free for commercial), PixelOperator (Jayvee Enaguas, CC0).
- **Faustregel:** `ASSETS.md` mit Quelle + Lizenz + Datum pro Asset. Claude Code pflegt das mit, wenn im CLAUDE.md verlinkt.

### E.6 Phasen-Roadmap

**P0 — Aufräumen (Woche 1):** Sim-Engine-Tick deaktivieren, alte Allowance-Logik aus Hot-Path. CLAUDE.md + Specs-Ordner. Drift-Schema-Review.

**P1 — Deterministischer Tageszyklus (Woche 1–2):** `GameClock`-Riverpod-Service mit `currentDay: int`, `advanceDay()`. `DaySummary`-Freezed-Modell. „Schlafen"-Button + Cutscene. Day-Counter in UI.

**P2 — Phone-UI-Polish (Woche 2–3):** m6x11-Font global, flutter_animate-Tweens, Kenney-UI als Basis. Bank-App, Wunschliste, Daily-Quiz-Module.

**P3 — Monetaria-Hub mit Flame (Woche 3–4):** `FlameGame` `MonetariaWorld` als Vollbild-Widget. Tiled-Map mit Heimathafen + 3 Inseln (2 gelocked). Boot-Übergang.

**P4 — Spar-Insel + Pflanzen-Mechanik (Woche 4–5):** `Plant`-Entity (Drift + Freezed). Elefantenfuß-Sprite, Wachstums-Stages, Ernte-Juice. Insel-Erträge in `advanceDay()`. Quest „Opa schenkt 10 €" verkabeln.

**P5 — Quest-Runner Refactor (Woche 5–6):** Quests deklarativ in `assets/quests/*.yaml`. Quest-Engine als Riverpod-Provider mit Triggern (onDayEnd, onPlantHarvest, …). Onboarding-Quest.

**P6 — ETF-Insel, Wetter, Volatilität (Woche 6–7).**

**P7 — Inflations-Atoll, steigende Wunschlisten-Preise (Woche 7–8).**

**P8 — Aktien-Archipel, Vulkan-Insel, Zeitreise (Woche 8–10).**

**P9 — Sound, Game-Feel-Polish, Balancing (Woche 10–11).**

**P10 — Privat-Release (Woche 11–12):** APK signieren, sideloaden auf Sohn-Phone, kein Store.

### E.7 Erste 5 Claude-Code-Sprints — konkrete Beispiel-Prompts

**Sprint 1 — Tag-beenden-Mechanik**
> „Lies @specs/spec-01-day-cycle.md. Implementiere einen `GameClock`-Riverpod-Provider mit `currentDay: int` und `advanceDay()`-Methode. Schreibe Unit-Tests, die zeigen, dass `advanceDay()` deterministisch ist und alle Day-Listener in fester Reihenfolge aufruft (Allowance → Insel-Erträge → Pflanzen → Inflation). Entferne den alten Tick-Loop in `lib/core/sim_engine.dart`. Lass alle bestehenden Tests laufen, commit mit konventionellem Commit-Message-Format."

**Sprint 2 — Schlaf-Cutscene + Day Summary**
> „Lies @specs/spec-02-sleep-cutscene.md. Baue `SleepCutsceneWidget`: 3-Sek-Fade-Black mit Mondrotation, dann `DaySummary`-Screen mit Liste aller Tagesereignisse (jede Zeile pop-in animiert via flutter_animate, 60 ms gestaffelt). Sound-Stub: `assets/sfx/sleep.wav`, `assets/sfx/coin_pop.wav` (Platzhalter aus Kenney UI-Audio). Golden-Tests für Light/Dark."

**Sprint 3 — Pixel-UI-Pass Phone-Springboard**
> „Lies @specs/spec-03-pixel-ui.md. Ersetze Placeholder-Pixel-Art im Phone-Springboard durch Kenney-Tile-UI (Pfade in @docs/asset-pipeline.md). m6x11-Font global. Buttons: 100 ms easeOutBack-Skalierung beim Press. Golden-Tests."

**Sprint 4 — Flame-Insel-Hub**
> „Lies @specs/spec-04-monetaria-hub.md. Embeddiere `FlameGame` `MonetariaWorld` als Vollbild-Widget in `monetaria_screen.dart`. Lade `assets/maps/monetaria.tmx` (Stub: 1 Heimathafen + 3 Inseln, davon 2 gelocked). Tap auf Insel → Bootsanimation → Inselansicht-Placeholder. Test für Freischaltlogik."

**Sprint 5 — Erste Pflanze auf Spar-Insel**
> „Lies @specs/spec-05-plant-mechanic.md. `Plant`-Entity: Drift-Tabelle + Freezed-Modell. Spar-Insel-Plot mit 4 Slots. Pflanzen-Stage als unterschiedliche Sprites. `advanceDay()` ruft `Plant.grow()` auf. Ernte-Button mit Juice (Particle + Sound + Coin-Pop). Test: `advanceDay()` 5×, Pflanze reift, Ernte gibt Coins."

---

## F) Markt / Rahmenbedingungen

### F.1 DSGVO bei Apps für Minderjährige

- **Art. 8 DSGVO**: Eigene Einwilligung in „Diensten der Informationsgesellschaft" wirksam erst ab 16 Jahren in Deutschland (DE hat die EU-Öffnungsklausel auf 13 nicht genutzt). Darunter Eltern.
- **Für FINANZGAME konkret:** Solange offline-first, keine Account-Anlage, keine Telemetrie, keine Cloud-Sync und keine PII gespeichert/übertragen werden, ist Art. 8 DSGVO praktisch irrelevant — DSGVO regelt nur die *Verarbeitung* personenbezogener Daten.
- **Risiko-Trigger für später:** Multiplayer, Cloud-Save, Push-Notifications mit IDs, Firebase Analytics, Crashlytics — sobald eines davon eingebaut wird, kommt die DSGVO voll zum Tragen.

### F.2 KJM, USK, Jugendschutz

- **USK-Einstufung**: Pflicht bei physischen Datenträgern; bei Play Store läuft Alterseinstufung über IARC (Wizard im Play Console).
- **KJM** unproblematisch für eine Finanzbildungs-App ohne Gewalt/Sex/Glücksspiel-Mechaniken.
- **Glücksspiel-Grenze:** Vulkan-Insel mit Zufallsernte ist **kein** Glücksspiel im Rechtssinn, da kein echter Geldeinsatz und keine Auszahlung. Trotzdem in der UI klar als Lehrbeispiel rahmen.

### F.3 Aktien-Simulationen für Minderjährige in DE

- Rechtlich unproblematisch, solange kein echtes Geld eingesetzt wird, keine echten Marken/Ticker verwendet werden und keine Werbung für reale Finanzprodukte in der App ist. Eure Hardregeln decken das ab.
- Vorbild: Sparkassen-Planspiel Börse seit 1983 für Klassen 8–12 (Alter ~13–17, genau eure Zielgruppe).
- Kritische Stimme aus der Wirtschaftsdidaktik (Friedrich-Verlag): Planspiel Börse lehrt eher Spekulation als Investieren — Bestätigung, dass eure Anti-Spekulations-/Anti-Konsum-Linie der richtige Differenzierer ist.

### F.4 Google Play Family Policy (falls Store-Release)

- **Target Audience and Content** im Play Console deklarieren: bei Zielgruppe „13–15" oder „13–17 primary" gelten Families-Policies.
- Wichtigste Pflichten: keine personalisierte Werbung an Kinder/Unknown; bei Werbung nur Families-Self-Certified Ads SDKs; keine simulierten Glücksspiel-Inhalte; kindgerechte Datenschutzerklärung; Child-Safety-Point-of-Contact.
- **Eure App ohne Ads und ohne IAP** → Compliance sehr einfach.
- **„Teacher Approved"-Badge** wäre langfristig erreichbar — gutes PR-Ziel, falls je veröffentlicht.

---

## G) Abschluss

### G.1 Was ich an deiner Stelle tun würde

**Refactor, nicht Neustart. Fokus auf den deterministischen Tageszyklus als Game-Loop-Fundament. Dann Insel-Hub mit Flame. Dann Polish.**

Begründung: Die bestehende Architektur (Flutter, Riverpod, Drift, Freezed, Clean Architecture) ist 2026 State-of-the-Art für Mobile-Sim-Spiele. Alle Probleme sitzen in **einer Schicht** (Sim-Engine + UI-Polish), nicht in der Gesamtstruktur. Neustart = 4–6 Wochen verlorene Zeit; Refactor = 1–2 Wochen für die kritischen Pain Points und du behältst Tests, Datenmodelle, Riverpod-Provider als Sicherheitsnetz.

### G.2 Top-3-Empfehlungen für die nächsten 4 Wochen

1. **Diese Woche:** Reiß die Echtzeit-Sim-Engine raus. Bau `GameClock` + „Schlafen"-Button + Day-Summary-Screen. Das eliminiert das +20 €-Gefühl sofort und schafft Game-Feel.
2. **Woche 2–3:** Schreib eine knappe CLAUDE.md (max. 200 Zeilen) + `specs/`-Ordner mit den ersten 5 Sprint-Specs (jede ≤100 Zeilen). Vibe Coding wird damit deutlich ruhiger und produktiver.
3. **Woche 3–4:** Erste echte Insel (Spar-Insel mit Elefantenfuß) mit Flame und Kenney-Assets. Sonntag deinem Sohn zeigen, direktes Feedback holen.

### G.3 Top-3-Risiken

1. **Scope Creep**: 8 Inseln + Zeitreise + Boote + Wetter ist *viel*. Risiko: nach 6 Monaten halbfertig. **Gegenmaßnahme:** V1 = 2 Inseln + Tageszyklus + Quest-Runner. Veröffentlichung an den Sohn = MVP.
2. **Art-Bottleneck**: Du bist kein Pixel-Artist. **Gegenmaßnahme:** Kenney CC0 als Fundament, eigenes Pixeln nur für Schlüssel-Inseln, Retro Diffusion nur als Inspiration nicht als End-Asset.
3. **Pädagogische Übertreibung**: „Lehre" zu sehr im Vordergrund → Sohn merkt Schule → spielt nicht mehr. **Gegenmaßnahme:** Story und Quest als Haupttreiber, „Wiki-Seiten" als optionale Tiefe.

### G.4 Refactor vs. Neustart — Pro/Contra

| Kriterium | Refactor (empfohlen) | Neustart |
|---|---|---|
| Zeit bis spielbar | 2–3 Wochen | 6–8 Wochen |
| Lerneffekt für dich | Hoch (Refactoring-Skills) | Niedriger (Basics nochmal) |
| Tech-Debt-Risiko | Mittel (alte Annahmen leben mit) | Niedrig (Greenfield) |
| Bestehende Tests | Bleiben als Anker | Verloren |
| Claude-Code-Effizienz | Etwas schwieriger (mehr Kontext) | Einfacher (kleines Repo) |
| Sohn sieht Fortschritt | Schnell | Spät |
| Motivation für dich | Hoch (sichtbare Verbesserung) | Risiko Frust („noch nicht spielbar") |
| Architektur-Sauberkeit | 80 % erreichbar | 100 % möglich |

**Verdikt:** Bei Hobby-Projekten ist sichtbarer wöchentlicher Fortschritt das wichtigste Asset. Refactor.

---

## Caveats

- **PISA-Datenlage Deutschland:** Es gibt offiziell keinen PISA-Financial-Literacy-Wert für deutsche 15-Jährige; alle Vergleichswerte sind international (OECD-Durchschnitt). Falls die Petition / 2029-Teilnahme klappt, gibt es in 4 Jahren bessere Daten.
- **Bling-/pockid-Funktionsumfang** ändert sich häufig; obige Tabelle ist Stand Mai 2026.
- **Flame Engine** ist 2D-only und hat keinen visuellen Scene-Editor. Für 2D-Pixel-Sim ideal; falls je 3D nötig, wäre Wechsel auf Unity/Godot nötig.
- **Retro Diffusion EULA** ist ambig formuliert; bei Store-Release vorher mit Astropulse klären.
- **Sound-Lizenzen:** Bei Musik besonders aufmerksam — viele YouTube-Music-Libraries sind NICHT für App-Embedding lizenziert.
- **Sim-Balancing:** Pflanzenwerte oben sind Startpunkte, keine finalen Zahlen — iterieren mit dem Sohn als Testpilot.
- **Bankenverband-Studie** ist methodisch valide (Kantar, n=700), aber interessengeleitet interpretiert — als Anhaltspunkt für Wissenslücken nutzen, nicht als Beleg für eine spezifische Lösungspolitik.

---

## Completion-Check

| Auftragsabschnitt | Abgedeckt? |
|---|---|
| A) Konkurrenzanalyse (DACH + intl., Edutainment, Insel-Metaphern, USP) | ✓ |
| B) Pädagogik (Forschung, Lernreihenfolge, Metaphern, Session-Länge, Anti-Schul-Gefühl) | ✓ |
| C) Game-Design (Juice, Tickrate, Onboarding, SDT, Pixel-Stil, Sound) | ✓ |
| D) Insel-Hub mit Pflanzen-Sub-Mechanik + +20 €-Lösung | ✓ |
| E) Technische Roadmap (Architektur-Bewertung, CLAUDE.md, Tools, 5 Sprints, Assets) | ✓ |
| F) DSGVO / KJM / Play Family / Aktien-Sim-Recht | ✓ |
| Abschluss: „Was würde ich tun" + Top-3 (4 Wochen, Risiken) + Refactor-vs-Neustart-Tabelle | ✓ |