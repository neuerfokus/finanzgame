# Spec 18 — Wetter sichtbar + Wetter→Pflanzen-Kopplung

## Goal

Wetter ist:
1. **Sichtbar** — UI zeigt aktuelles Wetter pro Tag.
2. **Wirksam** — beeinflusst nicht nur ETF, sondern auch Pflanzen-
   Wachstum + Ertrag auf der Spar-Insel.
3. **Erklärt** — Day-Summary zeigt Wetter-Effekt klar.

## Why

Test-Feedback: „wie wirkt sich das Wetter aus? Auch auf die Pflanzen?"
Aktuell: Wetter wird gerollt, modifiziert ETF-Preise, ist sonst
unsichtbar und beeinflusst Spar-Insel nicht.

## Non-Goals

- Per-Insel-Mikroklima (Wetter bleibt global)
- Wetter-Vorhersage (nur Heute)

## Mechanik

### Wetter-Sichtbarkeit

- **MoneyHeader / SpringboardPage**: kleines Wetter-Icon + Label
  („Sonne", „Sturm", „Wolken") rechts.
- **Day-Summary**: Eintrag „Wetter: Sonne — Pflanzen wachsen +20%
  schneller, ETF-Anteile +1.2%".

### Wetter-Effekt auf Pflanzen

Aktuell wächst eine Pflanze 1 Stage pro `advanceDay()`. Neu:

```dart
enum WeatherKind { sun, cloud, rain, storm }

double growthMultiplier(WeatherKind w) => switch (w) {
  WeatherKind.sun => 1.2,    // schneller reif
  WeatherKind.cloud => 1.0,
  WeatherKind.rain => 1.3,   // best fürs Wachstum
  WeatherKind.storm => 0.5,  // bremst
};

double yieldMultiplier(WeatherKind w) => switch (w) {
  WeatherKind.sun => 1.1,
  WeatherKind.cloud => 1.0,
  WeatherKind.rain => 1.05,
  WeatherKind.storm => 0.7, // schadet Ernte
};
```

Wachstum: pro `advanceDay()` wird `progress += growthMultiplier(weather)`
auf einem `double progress`-Feld in `Plant`. Stage wechselt bei
`progress >= stageDuration`. Domain-Model erweitern.

Ertrag: bei `harvest()` wird `yieldCents = baseYieldCents *
yieldMultiplier(weatherOnHarvestDay)`.

`PlantListener` (aktuell pro `advanceDay()` ein Stage-Schritt) liest
`WeatherEvent` aus dem gleichen Tag und nutzt Multiplier.

### Sturm-Risiko (Optional, separater Flag)

Bei `storm` und Wahrscheinlichkeit 10%: eine zufällige reife Pflanze
geht kaputt (status → `withered`, kein Ertrag). DaySummary listet das
explizit. Macht Wetter zur fühlbaren Mechanik.

### Day-Summary-Eintrag

`DaySummary.events` enthält künftig `WeatherEvent` mit
`describePlantImpact()` und `describeEtfImpact()`. UI rendert beides.

## Schema-Änderung

`Plant.currentStage` (int) → ergänzt um `growthProgress` (int = Tenths,
1.2× = 12, 1.0× = 10, akkumuliert). Stage = `progress ~/ 10`.

Migration: Pre-Release-Wipe oder transparent: bei Load default
`growthProgress = currentStage * 10`. Pre-Release-Wipe ist OK.

`PlantsTable`: + Spalte `growthProgress` Integer mit default 0.

## Tests

- Pure: `growthMultiplier` Tabellen-Test
- Pure: PlantListener mit injizierten Weather-Werten → Stage-Sprung
- Storm-Wither: deterministisch mit Seed
- DaySummary: Sun-Tag listet „+20% Wachstum"
- Round-trip: PlantsTable mit growthProgress reload

## Acceptance

- [ ] Wetter sichtbar in Springboard-Header + Day-Summary
- [ ] Plant.growthProgress + Multiplier wirken
- [ ] Ernte-Ertrag mit Wetter-Multiplier
- [ ] Sturm hat 10% Wither-Chance auf reife Pflanze
- [ ] Day-Summary erklärt Effekt verbal
- [ ] Bestehende Tests grün (PlantListener-Tests evtl. anpassen)
- [ ] Neue Wetter-Plant-Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(weather): plant growth + yield + storm risk`

## Done When

Testspieler pflanzt im Regen → ist schneller reif. Sturm-Tag → eine Pflanze
weg. Day-Summary erklärt es. Springboard zeigt Wetter sofort.
