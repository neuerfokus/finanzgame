# Spec 16 — Insel-Identität (Schwerpunkt sichtbar + visuelle Gestaltung)

## Goal

Jede Insel zeigt klar: **Finanz-Schwerpunkt** + **Asset-Klasse** + eigene
visuelle Identität. Auch Boot bekommt Gestalt.

## Why

Test-Feedback: „man sieht nicht bei jeder Insel welcher Schwerpunkt und
Asset hier vorherrscht, außerdem sind die Inseln und das Boot nicht
gestaltet." Aktuell sind alle Inseln gleichfarbige Kreise mit Label.

## Non-Goals

- Externe Pixel-Sprites (Kenney/eigene PNGs) — separater Asset-Track
- Tiled-Map-Integration

## Insel-Identitäten

| ID | Schwerpunkt | Asset | Farbe | Form | Glyph |
|---|---|---|---|---|---|
| heimathafen | Tutorial / Hilfe | — | warm-braun | Haus-Form | 🏠 |
| spar_insel | Sparen + Geduld | Pflanzen | grün | Hügel mit Bäumchen | 🌱 |
| etf_insel | Diversifikation + Volatilität | ETFs | blau | Welle | 📈 |
| inflation_atoll | Inflation + Kaufkraft | Wunschartikel | sandgelb | flach mit Palme-Strich | 💰 |
| aktien_archipel | Einzelaktien-Risiko | Aktien | rot | Spitzberg | 📊 |
| vulkan | Crash-Lehre / Bear-Market | — | dunkelrot | Vulkan-Spitze | 🌋 |
| mischwald | (deferred, locked) | — | grau | Baum | 🌲 |

Renderer in `lib/game/monetaria/components/island_marker.dart`:
- Aktuell: Circle + Label.
- Neu: Custom-painted Polygon nach Form-Spalte + Farbe + 24px Emoji-Glyph
  overlay als TextComponent.

## Boot-Gestaltung

`lib/game/monetaria/components/boat.dart`:
- Aktuell: Rechteck oder Circle (TODO checken).
- Neu: kleine custom-painted Karavelle — Rumpf (Trapez) + Mast + Segel
  (Dreieck). Pure Flame `PositionComponent` mit `render()` override.

## Insel-Header in IslandPage

Beim Betreten einer Insel zeigt der PhoneFrame oberhalb des Body einen
**Insel-Header-Panel**:

```
🌱  Spar-Insel
Schwerpunkt: Sparen
Asset: Pflanzen
[Erklärung in 1 Satz]
```

Konfig in neuer Datei `lib/features/monetaria/island_identity.dart`:

```dart
final class IslandIdentity {
  const IslandIdentity({...});
  final String label;
  final String focus;
  final String assetClass;
  final String oneLiner;
  final String glyph;
  final Color color;
}

const Map<String, IslandIdentity> kIslandIdentities = { ... };
```

`island_page.dart` zeigt diesen Header vor Content. `heimathafen_page.dart`
nutzt ihn auch.

## Locked-Insel-Marker

Spec-13: locked = grau + 🔒. Behält Form, Glyph rendert nur als 🔒 statt
Themen-Glyph. Hover-Tooltip („Erst X tun") wäre nice-to-have, deferred.

## Tests

- Pure: `kIslandIdentities` enthält alle 7 IDs, keine leeren Felder
- Widget: IslandPage zeigt Header mit Focus + AssetClass
- Flame: `IslandMarker` für jeden ID rendert ohne Crash, korrekte Farbe

## Acceptance

- [ ] `island_identity.dart` mit 7 Einträgen
- [ ] `IslandMarker` rendert Form + Farbe + Glyph
- [ ] `Boat` als Karavelle gezeichnet
- [ ] Insel-Header in `IslandPage` + `HeimathafenPage`
- [ ] Locked-Marker: 🔒 statt Themen-Glyph, grau
- [ ] Bestehende 280 Tests grün
- [ ] Neue Identity- + Widget-Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(monetaria): island identity + boat shape`

## Done When

Spieler sieht in der Karte sofort welche Insel was bedeutet. Beim
Betreten der Insel steht oben Schwerpunkt + Asset-Klasse + 1-Satz-
Erklärung. Boot ist erkennbar als Schiff.
