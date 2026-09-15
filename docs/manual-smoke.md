# Manual Smoke Test — Finanzgame (10 Min)

Vor Versand der APK an den Testspieler diesen Pfad einmal durchspielen. Crash
oder unerwartetes Verhalten = Release stoppen.

## Voraussetzung

- APK frisch installiert (oder `flutter run --release`)
- Gerät hat Audio an (zum Hören der SFX, falls Assets vorhanden)

## Pfad

1. **App start → Springboard**
   - Erwartet: Status-Bar oben, „Tag 1" im Header, 6 AppIcons,
     Schlafen-Button unten
   - Cash-Anzeige: 25,00 € (Default-Startwert)

2. **Plant pflanzen**
   - Tap „Monetaria"-Icon
   - Tap Spar-Insel (grüner Kreis)
   - Boot fährt → IslandPage(spar) öffnet
   - Tap leeres Plot → PlantingMenu öffnet → „Pflanzen" tap
   - Cash sinkt um 0,50 €

3. **Schlafen ×3**
   - Zurück zum Springboard (`◀` button bottom)
   - Schlafen-Button tap → Cutscene (fade black → DaySummary)
   - „Weiter →" → Springboard
   - 2x wiederholen
   - Plant ist „ready" (gelber Pulse-Effekt)

4. **Plant ernten**
   - Spar-Insel öffnen → ready-Plot tap
   - Particles + Shake + Coin-Sound
   - Cash steigt um 0,52 €

5. **ETF kaufen**
   - Monetaria → ETF-Insel (gelber Kreis oben)
   - Tap „welt_korb" Kaufen → 1 Anteil → Bestätigen
   - Cash sinkt um 10,00 €

6. **30x Schlafen**
   - Zurück zum Springboard
   - Schlafen ×30 (jeden Day-Summary durchklicken)
   - Kurs des welt_korb hat sich verändert (sichtbar im Day-Summary)
   - Wahrscheinlichkeit: ~50% mindestens 1 Crash-Tag mit rotem Flash

7. **Quest spielen**
   - Springboard → Quests-Icon
   - „Das Sparschwein erwacht" tap
   - Dialog durchklicken → Quiz richtig → Choice
   - Confetti-Burst bei Quest-Ende
   - Cash steigt um 2,00 €

8. **Wishlist kaufen**
   - Monetaria → Inflations-Atoll
   - „SnipeShot Pulse" Kaufen → Bestätigen
   - Cash sinkt um 45,00 € (oder höher nach Inflation)
   - Item erscheint in „Deine Sachen"-Sektion

9. **Zeitreise**
   - Springboard → Zeitreise-Icon (Sanduhr)
   - Asset-Dropdown → welt_korb wählen
   - Liniendiagramm zeigt 30+ Tage Verlauf
   - Veränderung %-Anzeige (grün oder rot)

10. **Vulkan-Insel**
    - Monetaria → Vulkan-Insel
    - Eruption-History zeigt frühere Crash-Tage (wenn welche stattfanden)

## Erfolg

- Kein Crash, keine Exception
- Audio hörbar (wenn Assets da)
- DaySummary funktioniert auch bei vielen Events
- Zeitreise-Chart rendert ohne Lücken

## Bekannte Limitationen (kein Blocker)

- App-Restart = State weg (in-memory, DB-Foundation steht aus)
- Mischwald-Insel: leerer Placeholder
- Quest-Progress wird nicht persistiert (jedes Mal spielbar)
- Audio-no-op wenn Files fehlen — Spiel läuft trotzdem
