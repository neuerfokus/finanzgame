"""Baut die Ebenen des adaptiven Launcher-Icons aus assets/branding/icon_master.png.

Aufruf aus dem Projektwurzelverzeichnis:

    python tools/make_adaptive_icon.py

Erzeugt je Dichte `ic_launcher_foreground.png` (der freigestellte Baum) und
`ic_launcher_monochrome.png` (seine Silhouette, fuer die eingefaerbten Icons
ab Android 13). Die Hintergrundebene ist ein Vektor und liegt fest in
`android/app/src/main/res/drawable/ic_launcher_background.xml`.

WARUM FREISTELLEN, statt das Master-PNG zu verkleinern: der Launcher legt
seine eigene Maske ueber das Icon — Kreis, Squircle, Tropfen — und animiert
Vorder- und Hintergrundebene gegeneinander. Ein Vordergrund, der den eigenen
abgerundeten Rahmen mitbringt, ergibt darin ein Icon im Icon. Genau das lag
vorher in `mipmap-xxxhdpi/`: das komplette Badge samt Rahmen, nur verkleinert.

WARUM FLUTFUELLUNG statt Farbschluessel: der Hintergrund des Masters ist
kein flacher Verlauf, sondern hat eine radiale Aufhellung hinter dem Baum.
Ein Zeilen- oder Spaltenmodell laesst davon einen Lichthof stehen. Die
Fuellung laeuft stattdessen vom Rand nach innen und darf pro Schritt nur
[STEP] Stufen springen — die schwarze Kontur des Baums ist ein harter Sprung
und stoppt sie, egal welche Form der Verlauf hat.
"""

import os
import sys
from collections import deque

from PIL import Image, ImageDraw

MASTER = "assets/branding/icon_master.png"
RES = "android/app/src/main/res"

#: Von jeder Seite abgeschnitten, um den schwarzen Rahmen loszuwerden.
INSET = 60

#: Maximaler Farbsprung je Fuellschritt. Gross genug fuer den Verlauf,
#: klein genug fuer die Kontur.
STEP = 14

#: Anteil der Leinwandkante, den der Baum belegen darf.
#:
#: Garantiert sichtbar ist beim adaptiven Icon nur die innere 72-dp-Flaeche
#: der 108-dp-Leinwand, also 16,7 % bis 83,3 %. Die aeusseren 18 dp je Seite
#: gehoeren Maske und Parallax. 0,64 laesst dort noch etwas Luft — bei 0,72
#: wurden Baumspitze und Stammfuss von runden Masken abgeschnitten.
FRAC = 0.64

DENSITIES = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}


def _is_purple(px):
    r, g, b, a = px
    return a > 0 and r > g + 20 and b > g + 20


def freistellen(src):
    """Gibt den Baum ohne Hintergrund und ohne Rahmen zurueck."""
    w, h = src.size
    inner = src.crop((INSET, INSET, w - INSET, h - INSET))
    iw, ih = inner.size
    px = inner.load()

    # Saat: nur die purpurnen Randpixel. Von den schwarzen Rahmenresten in
    # den Ecken aus kaeme die Fuellung nicht ueber den Farbsprung hinweg.
    bg = [[False] * iw for _ in range(ih)]
    q = deque()
    for x in range(iw):
        for y in (0, ih - 1):
            if _is_purple(px[x, y]) and not bg[y][x]:
                bg[y][x] = True
                q.append((x, y))
    for y in range(ih):
        for x in (0, iw - 1):
            if _is_purple(px[x, y]) and not bg[y][x]:
                bg[y][x] = True
                q.append((x, y))

    while q:
        x, y = q.popleft()
        c = px[x, y]
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < iw and 0 <= ny < ih and not bg[ny][nx]:
                n = px[nx, ny]
                if max(abs(n[i] - c[i]) for i in range(3)) <= STEP:
                    bg[ny][nx] = True
                    q.append((nx, ny))

    # Die abgerundeten Ecken des Rahmens bleiben als schwarze Splitter
    # uebrig — sie sind vom Verlauf durch einen harten Sprung getrennt, die
    # purpurne Fuellung kommt also nicht hinein. Nur die groesste
    # zusammenhaengende Flaeche behalten: das ist der Baum.
    seen = [[False] * iw for _ in range(ih)]
    best, best_size = [], 0
    for sy in range(ih):
        for sx in range(iw):
            if bg[sy][sx] or seen[sy][sx]:
                continue
            comp, stack = [], [(sx, sy)]
            seen[sy][sx] = True
            while stack:
                x, y = stack.pop()
                comp.append((x, y))
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if (0 <= nx < iw and 0 <= ny < ih
                            and not bg[ny][nx] and not seen[ny][nx]):
                        seen[ny][nx] = True
                        stack.append((nx, ny))
            if len(comp) > best_size:
                best, best_size = comp, len(comp)

    out = Image.new("RGBA", (iw, ih), (0, 0, 0, 0))
    po = out.load()
    for x, y in best:
        po[x, y] = px[x, y]
    return out.crop(out.getbbox())


def rendern(tree, size):
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    tw, th = tree.size
    scale = int(size * FRAC) / max(tw, th)
    nw, nh = max(1, round(tw * scale)), max(1, round(th * scale))
    # NEAREST haelt die Pixelkanten hart — es ist Pixel-Art.
    small = tree.resize((nw, nh), Image.NEAREST)
    canvas.alpha_composite(small, ((size - nw) // 2, (size - nh) // 2))
    return canvas


def silhouette(fg):
    mono = Image.new("RGBA", fg.size, (0, 0, 0, 0))
    mp, fp = mono.load(), fg.load()
    w, h = fg.size
    for y in range(h):
        for x in range(w):
            if fp[x, y][3] > 128:
                mp[x, y] = (0, 0, 0, 255)
    return mono


def main():
    if not os.path.exists(MASTER):
        sys.exit(f"{MASTER} nicht gefunden — aus dem Projektwurzelverzeichnis aufrufen.")

    tree = freistellen(Image.open(MASTER).convert("RGBA"))
    print(f"Baum freigestellt: {tree.size[0]}x{tree.size[1]}")

    safe_lo, safe_hi = (108 - 72) / 2 / 108, 1 - (108 - 72) / 2 / 108
    for name, size in DENSITIES.items():
        target = os.path.join(RES, f"mipmap-{name}")
        os.makedirs(target, exist_ok=True)
        fg = rendern(tree, size)
        fg.save(os.path.join(target, "ic_launcher_foreground.png"))
        silhouette(fg).save(os.path.join(target, "ic_launcher_monochrome.png"))

        bb = fg.getbbox()
        lo, hi = min(bb[0], bb[1]) / size, max(bb[2], bb[3]) / size
        status = "ok" if lo > safe_lo and hi < safe_hi else "RAGT AUS DER ZONE"
        print(f"  {name:<8} {size:>3} px   belegt {lo * 100:4.1f}..{hi * 100:4.1f} %   {status}")

    print(f"Sicherheitszone: {safe_lo * 100:.1f}..{safe_hi * 100:.1f} %")


if __name__ == "__main__":
    main()
