# Asset-Inventar

Pro Asset: Pfad + Quelle + Lizenz + Datum. Pflicht beim Add.

## images/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/images/islands_composite/spar_insel.png | Google Gemini; Markenbezug am 16.09.2026 entfernt (tools/remove_brand_spar_insel.py) (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/etf_insel.png | Google Gemini (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/vulkan.png | Google Gemini (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/goldmine.png | Google Gemini; trägt sichtbares Gemini-Wasserzeichen (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/heimathafen.png | Google Gemini (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/mischwald.png | Google Gemini (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/aktien_archipel.png | Google Gemini (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/wohnviertel.png | Google Gemini (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/islands_composite/inflation_atoll.png | Google Gemini; trägt sichtbares Gemini-Wasserzeichen (Prompts: docs/ai_prompts/insel_prompts.md) | KI-erzeugt, siehe Hinweis unten | 2026-09-16 |
| assets/images/ships/aurora.png | Kenney Pirate Pack 2D — ship (18), bbox-cropped, 256×192 | CC0 | 2026-05-20 |

### Hinweis zu den KI-erzeugten Inselbildern

Die neun Grafiken unter `assets/images/islands_composite/` wurden mit **Google
Gemini** erzeugt. Bis zum 16.09.2026 stand hier fälschlich „Composite: Kenney
Iso-Landscape …" — das beschrieb die programmatischen Fallback-Komposite, die
`IslandMarker` nur noch verwendet, wenn eine dieser Dateien fehlt.

Zur Lizenz: Google beansprucht kein Eigentum an den erzeugten Bildern. Ob an
rein maschinell erzeugten Bildern überhaupt ein Urheberrecht entsteht, ist in
Deutschland und der EU zweifelhaft, weil der menschliche Schöpfungsanteil
fehlt. Dieses Projekt stellt sie deshalb **nicht** unter eine eigene Lizenz und
behauptet keine Rechte daran — anders als bei den selbst geschriebenen Inhalten
(Quests, Glossar), die unter CC-BY-SA-4.0 stehen.

`goldmine.png` und `inflation_atoll.png` tragen sichtbar Googles
Gemini-Wasserzeichen. Es bleibt bewusst stehen.

`spar_insel.png` zeigte bis zum 16.09.2026 ein Bankgebäude mit dem Schriftzug
„SPARKASSE" und einem nachempfundenen S-Symbol — eine reale Marke, im
Widerspruch zur Projektregel „keine echten Marken". Schriftzug und Symbol sind
entfernt; das Banner ist jetzt leer. Nachvollziehbar über
`tools/remove_brand_spar_insel.py`.

## fonts/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/fonts/Kenney*.ttf (alle Kenney-Fonts) | Kenney Fonts Pack (kenney.nl/assets/kenney-fonts) | CC0 | 2026-05-19 |

## sfx/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/sfx/coin.ogg | Kenney Digital Audio — pepSound1.ogg | CC0 | 2026-05-19 |
| assets/sfx/harvest.ogg | Kenney Interface Sounds — confirmation_002.ogg | CC0 | 2026-05-19 |
| assets/sfx/sleep_chime.ogg | Kenney Interface Sounds — bong_001.ogg | CC0 | 2026-05-19 |
| assets/sfx/crash_rumble.ogg | Kenney Digital Audio — lowDown.ogg | CC0 | 2026-05-19 |
| assets/sfx/ui_tap.ogg | Kenney Interface Sounds — click_002.ogg | CC0 | 2026-05-19 |

## music/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/music/monetaria_loop.ogg | Kenney Music Jingles — jingles_NES13.ogg | CC0 | 2026-05-19 |

## maps/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| _leer_ | | | |

## images/furniture/

42 Twemoji-PNGs (CC-BY 4.0), 72×72 px, gefetcht via `tools/fetch_furniture_sprites.py` von jsDelivr-CDN. Pro FurnitureItem.id eine PNG. Das Skript ist auf `twemoji@14.0.2` gepinnt (letzter Release, Repo archiviert) — nie `@latest`, weil ausgeliefert wird, was es herunterlaedt.

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/images/furniture/*.png (alle 42) | Twemoji v14.0.2 via jsDelivr CDN | CC-BY 4.0 (Twitter) | 2026-05-24 |

## quests/ (eigene Inhalte)

Quest-YAMLs sind eigene didaktische Inhalte. Kein externes Asset, sondern
selbst geschriebener Content: Tutorial-Q00 und alle Quests + _REIHENFOLGE.md.
Seit dem Open-Source-Release unter **CC-BY-SA-4.0** (siehe
`LICENSES/CC-BY-SA-4.0.txt`).

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/quests/*.yaml (alle Quests) | eigene Inhalte | CC-BY-SA-4.0 | 2026-05-19+ |
| assets/quests/_REIHENFOLGE.md | eigene Reihenfolge-Kuration | CC-BY-SA-4.0 | 2026-05-22 |

## branding/

| Pfad | Quelle | Lizenz | Datum |
|---|---|---|---|
| assets/branding/icon_master.png | eigene App-Icon-Master (Münzbaum) | CC-BY-SA-4.0 | 2026-05-19 |

## Lizenz-Überblick

| Teil | Lizenz |
|---|---|
| Quellcode (`lib/`, `test/`, `tools/`, `android/`) | GPL-3.0-or-later |
| Eigene Inhalte (Quests, Glossar, Branding) | CC-BY-SA-4.0 |
| Kenney-Assets (Bilder, Fonts, SFX, Musik) | CC0 — keine Attributionspflicht |
| Twemoji-PNGs (`assets/images/furniture/`) | CC-BY-4.0 — **Attribution Pflicht** |

## In-App-Credits

Twemoji ist CC-BY 4.0 und verlangt Attribution. Umgesetzt: Einstellungen →
**„ℹ Über & Lizenzen"** (`lib/features/settings/about_page.dart`). Die Seite
nennt Twemoji, Kenney und die eigene Lizenzierung und führt über
`showLicensePage()` zu den Lizenzen aller Dart-Pakete.

Wer ein Asset ergänzt, trägt es hier ein UND — falls attributionspflichtig —
in `about_page.dart`. Der Test `test/features/settings/about_page_test.dart`
hält die Pflicht-Nennungen fest.

## Lizenz-Check

`tools/license_check.py` scant assets/ vs ASSETS.md. Report nach
`tools/license_check_report.md`. Exit-Code 1 wenn unbekannte Files.
