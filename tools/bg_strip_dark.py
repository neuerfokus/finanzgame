"""Dunklen BG strippen — Flood-Fill von 4 Kanten.

Usage:
    python tools/bg_strip_dark.py <path1.png> [<path2.png> ...]
"""

from __future__ import annotations

import sys
from collections import deque
from pathlib import Path

from PIL import Image

THRESHOLD = 35


def is_bg(px):
    r, g, b, a = px
    if a < 8:
        return True
    return max(r, g, b) <= THRESHOLD


def strip(path: Path) -> int:
    img = Image.open(path).convert("RGBA")
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

    img.save(path, optimize=True)
    return n


def main():
    if len(sys.argv) < 2:
        print("usage: python tools/bg_strip_dark.py <path.png> ...")
        return 1
    for arg in sys.argv[1:]:
        p = Path(arg)
        n = strip(p)
        print(f"{p.name}: {n} px stripped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
