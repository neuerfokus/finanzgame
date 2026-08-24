# Game-Design — FINANZGAME

## Core Loop

```
Wachzeit (3-7 Min aktiv):
  Springboard checken
  → Bank-Stand, Wunschliste, Quests
  → Monetaria betreten (ab P3)
  → Insel-Aktion (einzahlen / pflanzen / ernten)
  → zurück zum Phone
  → optional Daily-Quiz (LockScreen-Overlay)
  → Wunsch-Entscheidungen (kaufen vs sparen)
Schlafen-Button (1x pro Session):
  → 3s Cutscene
  → Day-Summary (alle Events des Tages gebatcht)
  → Springboard mit Day+1
Session-Länge target: 8-12 Min mit 2-3 Spieltagen
```

**Niemals** Realtime-Tick. Niemals stille Hintergrund-Belohnung. Jedes Geld-Event braucht Anticipation + Reveal.

## Juice & Game-Feel

Quellen: Vlambeer "Juice It Or Lose It", Mark Brown "Secrets of Game Feel".

- **Screen-Shake** bei Geld-Events (subtle, 2-4px, 150ms)
- **Tweens** (Squash & Stretch) für Buttons und Münzen — `easeOutBack` für „pop"
- **Particles** bei Ernte, Verkauf, Insel-Bonus
- **Hit-Pause** (Freeze-Frame 50-100ms) bei wichtigen Events
- **Sound zu jedem Tap** (auch leise — Stille = tot)
- **Staggered Reveal** in Listen (60ms zwischen Items)

Tooling: `flutter_animate` für UI-Tweens, Flame für In-Game-Particles ab P3.

## Onboarding

Apple HIG + UX-Collective best practices:

- Kein Splash-Wall. Direkt ins Spiel.
- One mechanic at a time: Zimmer → Wunsch → Quest „Opa schenkt 10€" → erstes Sparen → Sparbuch-Insel
- Quick Win in <60s
- „Wow-Moment" am Ende von Tutorial-Quest

Vorbilder: Stardew (Brief + Quest), Genshin (NPC-Begleiter), Clash Royale (mehrere kurze, aufbauend).

## Belohnungen (SDT — Ryan/Deci)

Self-Determination Theory: **Autonomie, Kompetenz, Verbundenheit.**

- **XP & Badges OK** wenn an echte Kompetenz gekoppelt: „Du hast die Krise überstanden ohne Notgroschen anzutasten"
- **NIE** variable Geld-Belohnungen (Zogo-Gift-Card-Modell = Operant Conditioning bei Minderjährigen)
- **NIE** Streaks-mit-Bestrafung (Duolingo-Falle, introjizierte Motivation)
- **Player Agency** stark betonen — mehrere Wege zum Ziel, keine „One-True-Strategy"
- **Verbundenheit:** NPC-Beziehungen (Opa Walter, Banker, Inselbewohner) als Story-Anker

## Pixel-Art-Stil 2026

Look: **Sea of Stars / Eastward-Schule.** Pixel-Art mit modernem dynamischen Licht, höherer Auflösung als reines SNES.

- Tile-Auflösung: **32×32**
- Charaktere: **48×64 oder 32×48**
- Palette: max. **32 Farben** (Lospec als Referenz)
- Custom-Pixel-Font: **m6x11** (Daniel Linssen, frei kommerziell) ODER **PixelOperator** (CC0)
- Vorbilder: Sea of Stars, Eastward, Owlboy, Stardew, CrossCode, Octopath Traveler

**Nicht** strenges 8-bit (wirkt kindisch).

## Sound

- **SFX:** Bfxr / jsfxr (Browser, free, Output CC0). Mindest-Set: tap, coin, harvest, sleep-stinger, quest-complete
- **Musik:** BeepBox (free), LMMS (GPL), Kevin MacLeod (CC-BY), OpenGameArt (Lizenz prüfen)
- **Track-Set:** Daytime-Loop, Schlaf-Stinger, Monetaria-Theme, Insel-Spezial pro Insel (Spar-Insel ruhig, Vulkan dramatisch)

## Anti-Schul-Feeling

Forschung: Bankenverband-Studie 2024 — 80% der 14-24j sagen „in Schule wenig zu Finanzen gelernt". Lösung:

- **Kein Quiz-Frontalfeuer** — Lernen aus Konsequenzen
- **Story > Erklärtext** — Quest „Opa Walter hat alten Schatz auf Spar-Insel" lehrt mehr als Compound-Interest-Modal
- **Optionale Wiki-Seiten in Bank-App** für Vertiefung — niemals zwingen
- **Anti-Moralkeule** — Konsumismus ist spielbar, aber zeigt Konsequenzen (kein Geld = keine Investments)

## Lern-Reihenfolge für 14-Jährige

| Phase | Konzept | Mechanik | Metapher |
|---|---|---|---|
| 1 | Geld, Bedürfnis vs Wunsch | Allowance + Wunschliste | Schatzkiste |
| 2 | Einfache Zinsen, Geduld | Spar-Insel | Elefantenfuß-Pflanze |
| 3 | Zinseszins | Vergleichs-Plots | Karnickel / Schneeball |
| 4 | Inflation | Wunsch-Preise steigen | Eis schmilzt im Geldsack |
| 5 | Risiko vs Rendite | Insel-Wahl, Wetter | Wetter über Inseln |
| 6 | Diversifikation | Mehrere Inseln | Mischwald / Spinnennetz |
| 7 | Liquidität | Boots-Klassen | Kanu ↔ Kreuzfahrtschiff |
| 8 | Opportunitätskosten | Tageszeit-Budget | „Du kannst nicht alles" |
| 9 | Steuern-Basics | Spielwährungs-Abgabe | Hafenmeister-Zoll |

## Metaphern-Katalog (kanonisch)

- **Aktie** = Stück Pizza-Firma — du kaufst Stück, Firma wächst, Stück wertvoller
- **Zinseszins** = Karnickel-Familie (2→4→8→16) ODER Schneeball bergab
- **Sparbuch** = Elefantenfuß-Pflanze — sehr langsam, wetter-immun
- **Zinsen** = Bank zahlt Miete fürs Geld
- **Inflation** = Eis in Sonne / Comic jedes Jahr teurer / Mama bekam für 5€ vor 30 Jahren 5 Comics, heute nur 2
- **Schulden** (Phase 3) = Schatten der wächst
- **Diversifikation** = Mischwald statt Monokultur, Eier nicht in einen Korb
- **Risiko** = Wetter über der Insel
- **Liquidität** = Bootsklasse
- **ETF** = Mischwald (viele Bäume, stabiler Ertrag)
- **Bitcoin / alternative Assets** = Vulkan-Insel mit Eruption
- **Anleihen** = Karnickel-Gehege (vorhersagbare Würfe)
- **Immobilien** = bewohnte Insel mit Miet-Tick
