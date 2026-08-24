# Schiff-Drop-In

Galleone "AURORA" laut User-Referenz 2026-05-20.

## Erwartete Datei

`aurora.png` — 256×192 px PNG, transparenter Hintergrund.

Inhalt (User-Vision): 3-Master-Galleone, weiße Hauptsegel, Achterdeck mit
Steuermann, "AURORA"-Schriftzug am Bug, rote Heckflagge, Anker, Crew an Deck.

## Fallbacks

Wenn `aurora.png` fehlt → `phone/boat.png` (alter Caravel-Sprite).
Wenn auch der fehlt → CustomPaint-Galleone (programmatisch).

## Quellen

- Aseprite-Composite aus `Zusätze/kenney_pirate-pack.zip` (Ship-Sprites
  + Crew-Sprites)
- AI-Bild-Gen mit Prompt aus `docs/specs/spec-39-insel-artwork-vision.md`

## Live-Reload

```
flutter pub get
flutter run -d <device>
```
