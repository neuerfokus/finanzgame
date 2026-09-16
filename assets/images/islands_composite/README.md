# Insel-Composite-Drop-In

Pro Insel hier ein PNG ablegen. Sobald die Datei existiert, lädt
`IslandMarker` sie als kompletten Insel-Sprite (ersetzt alle programmatischen
Sprite-Composites). Fehlt sie, fällt der Code auf die bestehende
Kenney-Tile-Komposition zurück — kein Crash.

## Erwartete Dateien

| IslandId         | Dateiname              | Inhalt (User-Vision)                       |
|------------------|------------------------|---------------------------------------------|
| heimathafen      | `heimathafen.png`      | Hafen mit Stegen, Containern, Frachtschiff  |
| spar_insel       | `spar_insel.png`       | Bankgebäude + Sparschwein + Münzen + Beete    |
| etf_insel        | `etf_insel.png`        | Glas-Hochhaus mit ETF-Logo + Bäume + Hafen  |
| vulkan           | `vulkan.png`           | Vulkan mit Rauch + kleine Hütten            |
| goldmine         | `goldmine.png`         | Berg + Förderturm + Loren + Goldhaufen      |
| aktien_archipel  | `aktien_archipel.png`  | Börsen-Tempel + Säulen + DAX-Display        |
| inflation_atoll  | `inflation_atoll.png`  | Brennende Stadt + Strudel + Inflations-Pfeil|
| mischwald        | `mischwald.png`        | Wald mit Mischbäumen + Pfad + Hütte         |
| wohnviertel      | `wohnviertel.png`      | Wohnhäuser-Block + Strand                   |

## Format

- 256×256 px PNG (alternativ 512×512 px, wird beim Rendern skaliert)
- Transparenter Hintergrund
- Iso-Perspektive 2:1
- CC0 / Eigenkreation / lizenzfrei — Quelle in `ASSETS.md` ergänzen

## Quellen-Optionen

1. **Eigenes Composite** aus Kenney-Sprites in Aseprite/GIMP zusammenbauen
2. **AI-Bild-Gen** (DALL·E/MidJourney) — Prompt aus `docs/specs/spec-39-insel-artwork-vision.md`,
   eigene Lizenz beachten
3. **Kenney 3D-Render** aus `Zusätze/kenney_isometric-*.zip` zusammen
   schneiden

## Live-Reload

Nach Drop-in:
```
flutter pub get
flutter run -d <device>
```

Hot-Reload reicht NICHT — neue Asset-Datei benötigt Pub-Refresh.
