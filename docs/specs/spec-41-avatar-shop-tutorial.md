# Spec 41 — Avatar-Shop + Tutorial-Quest

## A: Avatar-Shop

Avatar-Glyphs als kostenpflichtiger XP-Einkauf. Default = 🧒 (free).
Weitere 11 Glyphs schaltbar:

| Emoji | XP-Kosten | Bedingung |
|---|---|---|
| 🦸 | 200 | — |
| 🧙 | 400 | — |
| 🥷 | 600 | — |
| 🤖 | 800 | — |
| 👾 | 1000 | Level ≥ 5 |
| 🐱 | 100 | — |
| 🦊 | 300 | — |
| 🐼 | 500 | — |
| 🐧 | 700 | — |
| 🐸 | 900 | Level ≥ 10 |
| 🐯 | 1200 | Level ≥ 15 |

UI: Zimmer-AvatarPicker bekommt Lock-Icon + XP-Preis bei nicht-
gekauften. Tap auf locked → Confirm-Dialog ("Für 200 XP freischalten?").
Bei Erfolg: XP wird abgezogen, Glyph wird available + auto-aktiviert.

Persistenz: `Set<String> unlockedAvatars` im SettingsTable als
JSON-string-column.

## B: Tutorial-Quest

Eine grosse mehrteilige Einsteiger-Quest, die nach Onboarding
automatisch startet. Führt durch alle 9 Inseln + erklärt Mechaniken.

10 Schritte:
1. Heimathafen — "Hi, willkommen in Monetaria!"
2. Spar-Insel — Pflanze deinen ersten Salat
3. Schlafen — Ein Tag vergeht, du erntest
4. Bank — Erstes Sparkonto + Zinsen erklären
5. ETF-Insel (unlock) — Was ist ein ETF?
6. Vulkan — Bitcoin als Casino-Investment
7. Goldmine — Edelmetalle als Inflationsschutz
8. Aktien-Archipel — Einzelaktien-Risiko
9. Inflations-Atoll — Wunschartikel teurer mit der Zeit
10. Sammlerinsel — Sachwerte für Reiche

Reward: 500¢ + 200 XP + Achievement `tutorial_complete`.

## Acceptance

- [ ] AvatarShop-Page erreichbar via Zimmer
- [ ] Lock + Preis + Confirm-Dialog
- [ ] Persistenz überlebt App-Neustart
- [ ] Tutorial-Quest YAML lädt + 10 Schritte spielbar
- [ ] Achievement bei Abschluss
