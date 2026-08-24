"""Spec-43 follow-up: BG-Strip v4 fuer islands_composite + ships/aurora.

Flood-Fill von allen 4 Kanten. Pixel werden transparent gemacht wenn:
  - sie vom Rand erreichbar sind (4-Nachbar-Flood)
  - UND ihre Helligkeit > THRESHOLD

Erhalt interner weißer Flächen (Schnee, Lichter, Wand-Highlights).
Glättet Kante via 1 px alpha-erosion am Übergang.
"""

from __future__ import annotations

import sys
from collections import deque
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
TARGETS = [
    ROOT / "assets" / "images" / "islands_composite" / name
    for name in [
        "heimathafen.png",
        "spar_insel.png",
        "etf_insel.png",
        "vulkan.png",
        "goldmine.png",
        "aktien_archipel.png",
        "inflation_atoll.png",
        "mischwald.png",
        "wohnviertel.png",
    ]
] + [ROOT / "assets" / "images" / "ships" / "aurora.png"]

# Pixel gilt als "BG-weiß" wenn min(R,G,B) >= THRESHOLD.
THRESHOLD = 200


def is_bg(px: tuple[int, int, int, int]) -> bool:
    r, g, b, a = px
    if a < 8:
        return True
    return r >= THRESHOLD and g >= THRESHOLD and b >= THRESHOLD


def flood_strip(img: Image.Image) -> tuple[Image.Image, int]:
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()

    visited = bytearray(w * h)
    q: deque[tuple[int, int]] = deque()

    def seed(x: int, y: int) -> None:
        if 0 <= x < w and 0 <= y < h:
            idx = y * w + x
            if not visited[idx] and is_bg(px[x, y]):
                visited[idx] = 1
                q.append((x, y))

    for x in range(w):
        seed(x, 0)
        seed(x, h - 1)
    for y in range(h):
        seed(0, y)
        seed(w - 1, y)

    stripped = 0
    while q:
        x, y = q.popleft()
        r, g, b, _ = px[x, y]
        px[x, y] = (r, g, b, 0)
        stripped += 1
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h:
                nidx = ny * w + nx
                if not visited[nidx] and is_bg(px[nx, ny]):
                    visited[nidx] = 1
                    q.append((nx, ny))

    # Anti-Fringe: alle restlichen Pixel mit sehr hellem Halo am Rand
    # transparenter machen (1-px dilation of alpha=0).
    halo = 0
    px2 = img.load()
    soften = []
    for y in range(h):
        for x in range(w):
            r, g, b, a = px2[x, y]
            if a == 0 or a == 255:
                continue
            if r >= THRESHOLD and g >= THRESHOLD and b >= THRESHOLD:
                soften.append((x, y))
    for x, y in soften:
        r, g, b, a = px2[x, y]
        px2[x, y] = (r, g, b, max(0, a - 80))
        halo += 1

    return img, stripped + halo


def main() -> int:
    total = 0
    for path in TARGETS:
        if not path.exists():
            print(f"skip (missing): {path.name}")
            continue
        with Image.open(path) as im:
            out, n = flood_strip(im)
        out.save(path, optimize=True)
        print(f"{path.name}: stripped {n} px")
        total += n
    print(f"DONE — {total} px stripped across {len(TARGETS)} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
