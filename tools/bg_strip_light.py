"""Hellen BG strippen via Flood-Fill von 4 Kanten.

Spiegel-Bild von bg_strip_dark.py — beide CLI-able.

Usage:
    python tools/bg_strip_light.py <src.png> [<dst.png>]
Wenn dst fehlt → in-place überschreiben.
"""

from __future__ import annotations

import sys
from collections import deque
from pathlib import Path

from PIL import Image

THRESHOLD = 220


def is_bg(px):
    r, g, b, a = px
    if a < 8:
        return True
    return min(r, g, b) >= THRESHOLD


def strip(src: Path, dst: Path) -> int:
    img = Image.open(src).convert("RGBA")
    w, h = img.size
    px = img.load()
    visited = bytearray(w * h)
    q = deque()

    def seed(x, y):
        if 0 <= x < w and 0 <= y < h:
            idx = y * w + x
            if not visited[idx] and is_bg(px[x, y]):
                visited[idx] = 1
                q.append((x, y))

    for x in range(w):
        seed(x, 0); seed(x, h - 1)
    for y in range(h):
        seed(0, y); seed(w - 1, y)

    n = 0
    while q:
        x, y = q.popleft()
        r, g, b, _ = px[x, y]
        px[x, y] = (r, g, b, 0)
        n += 1
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h:
                nidx = ny * w + nx
                if not visited[nidx] and is_bg(px[nx, ny]):
                    visited[nidx] = 1
                    q.append((nx, ny))

    img.save(dst, optimize=True)
    return n


def main():
    if len(sys.argv) < 2:
        print("usage: python tools/bg_strip_light.py <src.png> [<dst.png>]")
        return 1
    src = Path(sys.argv[1])
    dst = Path(sys.argv[2]) if len(sys.argv) >= 3 else src
    n = strip(src, dst)
    print(f"{src.name}: {n} px stripped -> {dst.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
