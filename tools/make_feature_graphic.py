"""Feature-Grafik 1024x500 für den Play-Store-Eintrag.

Farben und Schriften stammen aus der App selbst (design_tokens.dart,
assets/fonts), damit das Banner aussieht wie das Spiel und nicht wie ein
beliebiges Werbebild.

Aufruf aus dem Wurzelverzeichnis des Repos:

    python tools/make_feature_graphic.py de
    python tools/make_feature_graphic.py en

Schreibt nach `fastlane/metadata/android/<locale>/images/featureGraphic.png`.
Braucht Pillow: `pip install pillow`.
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

REPO = Path(__file__).resolve().parent.parent
SPRACHE = sys.argv[1] if len(sys.argv) > 1 else "de"
LOCALE = {"de": "de-DE", "en": "en-US"}[SPRACHE]
OUT = REPO / "fastlane" / "metadata" / "android" / LOCALE / "images" / "featureGraphic.png"

W, H = 1024, 500

BG_TOP = (26, 21, 48)        # backgroundPrimary #1A1530
BG_BOTTOM = (14, 11, 26)     # backgroundDeep    #0E0B1A
GOLD = (255, 193, 7)         # primary           #FFC107
VIOLET = (123, 97, 255)      # secondary         #7B61FF
GREEN = (78, 217, 106)       # success           #4ED96A
BLUE = (91, 192, 235)        # info              #5BC0EB
TEXT = (232, 232, 232)       # onSurface         #E8E8E8
MUTED = (180, 180, 180)      # onSurfaceMuted    #B4B4B4

img = Image.new("RGB", (W, H), BG_TOP)
d = ImageDraw.Draw(img)

# Verlauf von oben nach unten
for y in range(H):
    t = y / (H - 1)
    d.line(
        [(0, y), (W, y)],
        fill=tuple(round(a + (b - a) * t) for a, b in zip(BG_TOP, BG_BOTTOM)),
    )

# Pixelraster, sehr dezent — greift das Pixel-Art-Thema auf
for x in range(0, W, 32):
    for y in range(0, H, 32):
        d.point((x, y), fill=(42, 31, 74))

fonts = REPO / "assets" / "fonts"
f_title = ImageFont.truetype(str(fonts / "KenneyPixel.ttf"), 132)
f_sub = ImageFont.truetype(str(fonts / "KenneyFuture.ttf"), 34)
f_tag = ImageFont.truetype(str(fonts / "KenneyFutureNarrow.ttf"), 26)

# App-Icon links. Die Vorlage hat weiße Ecken — die werden mit einer
# abgerundeten Maske entfernt, sonst leuchten sie auf dem dunklen Grund.
icon = Image.open(
    REPO / "fastlane" / "metadata" / "android" / LOCALE / "images" / "icon.png"
).convert("RGBA")
SIZE, RADIUS = 240, 30
# Die Vorlage hat einen weißen Rand bis etwa 28 px; der wird weggeschnitten,
# statt ihn mit der Maske zu überdecken — sonst bleiben weiße Zwickel stehen.
icon = icon.crop((28, 28, 512 - 28, 512 - 28))
icon = icon.resize((SIZE, SIZE), Image.LANCZOS)
maske = Image.new("L", (SIZE, SIZE), 0)
ImageDraw.Draw(maske).rounded_rectangle([0, 0, SIZE - 1, SIZE - 1], RADIUS, fill=255)
icon.putalpha(maske)

ix, iy = 84, (H - SIZE) // 2
# Schlagschatten wie bei den Pixel-Kacheln im Spiel
schatten = Image.new("L", (SIZE + 12, SIZE + 12), 0)
ImageDraw.Draw(schatten).rounded_rectangle(
    [0, 0, SIZE + 11, SIZE + 11], RADIUS + 6, fill=90
)
img.paste((0, 0, 0), (ix - 2, iy + 2), schatten)
img.paste(icon, (ix, iy), icon)

# Textblock rechts daneben
tx = ix + 240 + 76

d.text((tx + 5, 140 + 5), "Finanzgame", font=f_title, fill=(0, 0, 0))
d.text((tx, 140), "Finanzgame", font=f_title, fill=GOLD)

if SPRACHE == "en":
    UNTERTITEL = "A game about money"
    MARKEN = ["Offline", "No ads", "No purchases"]
else:
    UNTERTITEL = "Ein Lernspiel über Geld"
    MARKEN = ["Offline", "Werbefrei", "Ohne Käufe"]

d.text((tx + 3, 268), UNTERTITEL, font=f_sub, fill=(0, 0, 0))
d.text((tx, 265), UNTERTITEL, font=f_sub, fill=TEXT)

# Merkmale als kleine Pixel-Marken
tags = list(zip(MARKEN, (GREEN, BLUE, VIOLET)))
x = tx
for label, colour in tags:
    w = d.textlength(label, font=f_tag)
    d.rectangle([x, 330, x + w + 28, 372], fill=(0, 0, 0))
    d.rectangle([x + 3, 333, x + w + 25, 369], outline=colour, width=3)
    d.text((x + 14, 341), label, font=f_tag, fill=colour)
    x += w + 44

# Goldene Kante unten, wie die Rahmen der Pixel-Knöpfe
d.rectangle([0, H - 6, W, H], fill=GOLD)

OUT.parent.mkdir(parents=True, exist_ok=True)
img.save(OUT, "PNG")
print("geschrieben:", OUT)
print("Groesse:", img.size, "|", OUT.stat().st_size, "Bytes")
