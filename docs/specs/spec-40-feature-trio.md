# Spec 40 — Feature-Trio (AI-Drop-In + Vulkan-Smoke + Daily-Streak)

## A: AI-Bild-Gen Drop-In (Komplettierung)

Bereits aus spec-39 vorbereitete Drop-In-Slots scharf schalten:
- `assets/images/islands_composite/<id>.png` (9 Inseln)
- `assets/images/ships/aurora.png`

User generiert mit DALL·E/MidJourney die Insel-Bilder nach Prompts aus
spec-39, legt PNGs ab, App lädt sie. Wir liefern:
- DALL·E-Prompts pro Insel in `docs/ai_prompts/insel_prompts.md`
- Loader bevorzugt User-Drops (schon erledigt in spec-39)
- ASSETS.md-Doku für nachträglichen Lizenz-Eintrag

## B: Vulkan-Rauchsäule

Flame-ParticleSystem über der Vulkan-Insel-Marker-Position:
- Grauer Rauch (Color 0xFF4A4A4A) + dunklerer Kern
- Lifespan 2s, Velocity nach oben, leichter Wind nach rechts
- Permanente Emission (1 Partikel pro 200ms), kein Stop-Event
- Component priorityt = höher als Insel-Marker damit Rauch sichtbar bleibt

## C: Daily-Streak-Kalender

Persistente Streak-Erkennung:
- Jeden Schlaf-Tag: wenn vorheriger Tag = heute-1 → streak++, sonst streak=1
- Persistiert in SettingsTable: `streakCount` + `lastSleepRealDate`
- Reset wenn echter Real-Date-Gap > 1 Tag (Spieler war länger offline)
- Reward-Schwellen: 3 Tage = +50¢ Bonus, 7 Tage = +200¢ + Achievement
  streak_7, 30 Tage = +1000¢ + Achievement streak_30

UI:
- Springboard zeigt 🔥-Indikator mit aktueller Streak-Zahl
- Tap auf Streak öffnet StreakCalendarPage: 7-Tage-Strip + Reward-Liste
- Bei Streak-Break: Snack "🔥 Streak verloren — neuer Anfang heute"

## Acceptance

- [ ] AI-Prompts dokumentiert pro Insel
- [ ] Smoke-Particles am Vulkan-Marker animiert + sichtbar im Map-View
- [ ] Streak-Count persistiert in Settings + überlebt App-Neustart
- [ ] Streak-Indikator auf Springboard + Tap-Page
- [ ] Reward-Auszahlung bei 3/7/30 verifizierbar via Test

## Out-of-Scope

- Echte AI-Generierung (User selbst, lizenzlich)
- Multi-Insel-Animations-System (nur Vulkan diesen Sprint)
- Streak-Push-Notifications
