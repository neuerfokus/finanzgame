# App-Icon: Münzbaum

## Konzept
Pixel-Iso-3D-Münzbaum als App-Launcher-Icon. Stamm + Krone + Münzen
als Früchte/Blätter. Lila-Gold-Farbpalette match FgColors (primary
gold `#FFC107`, secondary purple `#7B61FF`, success green `#4ED96A`).

## Prompts (Gemini / DALL-E / Midjourney)

### Variante A: Klassisch
```
A pixel-art isometric 3D money tree icon for a finance education
mobile game. Sturdy brown trunk, lush green canopy. Instead of
leaves, the canopy is filled with shiny gold coins (€-symbols on
some). Soft purple sky background gradient. Square 1024×1024 px
transparent or solid purple background. Style: detailed isometric
pixel art, vibrant saturated colors, slight glow on coins. Suitable
as an Android launcher icon. No text, no UI elements.
```

### Variante B: Stilisierter
```
Isometric pixel-art tree with golden coins growing as fruit on its
branches. Bold outlined cartoon style, juicy thick black outlines,
flat shading with subtle highlights. Tree sits on a tiny grass-tile
base (iso diamond shape). Background: bold purple-to-deep-purple
radial gradient. 1024×1024 square. Confident playful style, like a
Stardew Valley meets cozy finance app. No text.
```

### Variante C: Magic Style
```
A magical pixel-art coin tree with glowing golden coins replacing
leaves. Each coin has a euro symbol. Tree trunk is rich brown with
visible bark texture in pixel-art. Background: dark indigo with
sparkles. Subtle radial gold glow around the tree. 1024×1024
square. Iconic, recognizable at small sizes (down to 48px). Style:
detailed pixel art with iso-3D depth, like the islands in the game.
```

## Pipeline

1. Master generieren (Gemini 1024×1024 PNG)
2. Auf Transparenz prüfen / BG entfernen wenn nötig
   (`tools/bg_strip_v4.py` adaptiert)
3. Resize-Script `tools/icon_resize.py`:
   - mdpi 48×48
   - hdpi 72×72
   - xhdpi 96×96
   - xxhdpi 144×144
   - xxxhdpi 192×192
4. Adaptive Icon (Android 8+):
   - foreground: 432×432 mit Tree zentriert in 264×264 safezone
   - background: solid color XML (`#7B61FF` purple) ODER eigenes PNG
5. Files nach `android/app/src/main/res/mipmap-*` + `mipmap-anydpi-v26`
6. `AndroidManifest.xml` referenziert `@mipmap/ic_launcher`

## App-Name
Derzeit "finanzgame_neu". Auch ändern zu „Finanzgame" (label in
`AndroidManifest.xml`).
