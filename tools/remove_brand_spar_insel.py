"""Entfernt den Markenbezug von der Spar-Insel.

Der Schriftzug wird nicht wegretuschiert, sondern das Banner wird aus seinem
eigenen Farbverlauf neu aufgebaut: Für jede Höhenposition im Banner wird der
Median der unbeschrifteten Pixel bestimmt und über die ganze Länge gezogen.
Das goldene Giebelsymbol wird zeilenweise aus den Nachbarn interpoliert.
"""

import sys
from pathlib import Path
from statistics import median

from PIL import Image

QUELLE, ZIEL = Path(sys.argv[1]), Path(sys.argv[2])
im = Image.open(QUELLE).convert("RGBA")
px = im.load()
W, H = im.size

X0, X1 = 228, 306


def banner_y(x):
    return 166 + 0.351 * (x - 229)


def rot_artig(p):
    r, g, b, a = p
    return a > 200 and r > 95 and r - g > 30 and r - b > 30


def creme(p):
    r, g, b, a = p
    return a > 200 and r > 170 and g > 140 and b > 90


# 1. Banner-Lauf je Spalte bestimmen (rot ODER Schrift, max. 15 px hoch)
laeufe = {}
for x in range(X0, X1 + 1):
    ym = int(round(banner_y(x)))
    oben = unten = ym
    while oben - 1 >= 0 and ym - (oben - 1) <= 8 and (rot_artig(px[x, oben - 1]) or creme(px[x, oben - 1])):
        oben -= 1
    while unten + 1 < H and (unten + 1) - ym <= 8 and (rot_artig(px[x, unten + 1]) or creme(px[x, unten + 1])):
        unten += 1
    if unten - oben >= 4:
        laeufe[x] = (oben, unten)

# 2. Farbprofil über die relative Höhe sammeln, nur aus unbeschrifteten Pixeln
STUFEN = 12
proben = [[] for _ in range(STUFEN)]
for x, (oben, unten) in laeufe.items():
    hoehe = unten - oben
    for y in range(oben, unten + 1):
        p = px[x, y]
        if creme(p):
            continue
        stufe = min(STUFEN - 1, int((y - oben) / max(1, hoehe) * STUFEN))
        proben[stufe].append(p)

profil = []
for stufe, liste in enumerate(proben):
    if not liste:
        liste = [q for l in proben if l for q in l]
    profil.append(tuple(int(median(k[i] for k in liste)) for i in range(4)))

# 3. Banner neu zeichnen, Rand je eine Zeile unangetastet lassen
for x, (oben, unten) in laeufe.items():
    hoehe = unten - oben
    for y in range(oben + 1, unten):
        stufe = min(STUFEN - 1, int((y - oben) / max(1, hoehe) * STUFEN))
        px[x, y] = profil[stufe]

# 4. Goldenes Giebelsymbol: zeilenweise aus den Nachbarn ersetzen
def gold(p):
    r, g, b, a = p
    return a > 200 and r > 140 and g > 100 and b < 155 and r - b > 45


for y in range(150, 176):
    marken = [x for x in range(258, 282) if gold(px[x, y])]
    for x in marken:
        links = rechts = None
        for dx in range(1, 30):
            if links is None and not gold(px[x - dx, y]) and px[x - dx, y][3] > 200:
                links = px[x - dx, y]
            if rechts is None and x + dx < W and not gold(px[x + dx, y]) and px[x + dx, y][3] > 200:
                rechts = px[x + dx, y]
            if links and rechts:
                break
        if links and rechts:
            px[x, y] = tuple((a + b) // 2 for a, b in zip(links, rechts))
        elif links or rechts:
            px[x, y] = links or rechts

# 5. Nachlauf: verbliebene Reste des Symbols durch Giebelgrau ersetzen.
#    Kriterium ist die Buntheit — der Giebel ist grau, das Symbol war es nie.
def bunt(p):
    r, g, b, a = p
    return a > 200 and (max(r, g, b) - min(r, g, b)) > 22


for x in range(261, 280):
    grenze = laeufe.get(x, (176, 0))[0] - 2   # nie ins Banner hinein
    for y in range(152, grenze):
        if not bunt(px[x, y]):
            continue
        links = rechts = None
        for dx in range(1, 30):
            if links is None and x - dx >= 0 and not bunt(px[x - dx, y]) and px[x - dx, y][3] > 200:
                links = px[x - dx, y]
            if rechts is None and x + dx < W and not bunt(px[x + dx, y]) and px[x + dx, y][3] > 200:
                rechts = px[x + dx, y]
            if links and rechts:
                break
        if links and rechts:
            px[x, y] = tuple((a + b) // 2 for a, b in zip(links, rechts))
        elif links or rechts:
            px[x, y] = links or rechts

im.save(ZIEL)
print("Nachlauf fertig")
