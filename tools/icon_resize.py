"""App-Icon-Resize-Pipeline.

Erwartet `assets/branding/icon_master.png` (1024×1024 RGBA, fertig).
Generiert alle Android-Mipmap-Auflösungen + Adaptive-Icon-Foreground.

Usage:
    python tools/icon_resize.py
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / "assets" / "branding" / "icon_master.png"
RES = ROOT / "android" / "app" / "src" / "main" / "res"

# Standard launcher icon sizes.
SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

# Adaptive-icon foreground (Android 8+).
# Total canvas 432×432, safezone 264×264 zentriert.
ADAPTIVE_SIZE = 432
ADAPTIVE_SAFEZONE = 264


def main() -> int:
    if not MASTER.exists():
        print(f"ERROR: master fehlt: {MASTER}")
        print("Generate 1024×1024 PNG with Gemini, put it there.")
        return 1

    master = Image.open(MASTER).convert("RGBA")
    print(f"master: {master.size}")

    # Standard launcher icons (square).
    for folder, sz in SIZES.items():
        out_dir = RES / folder
        out_dir.mkdir(exist_ok=True)
        resized = master.resize((sz, sz), Image.LANCZOS)
        target = out_dir / "ic_launcher.png"
        resized.save(target, optimize=True)
        print(f"  {folder}/ic_launcher.png ({sz}×{sz})")

    # Adaptive-icon foreground: master in 264×264 safezone, 432×432 canvas.
    fg_canvas = Image.new("RGBA", (ADAPTIVE_SIZE, ADAPTIVE_SIZE), (0, 0, 0, 0))
    fg_inner = master.resize((ADAPTIVE_SAFEZONE, ADAPTIVE_SAFEZONE),
                              Image.LANCZOS)
    offset = (ADAPTIVE_SIZE - ADAPTIVE_SAFEZONE) // 2
    fg_canvas.paste(fg_inner, (offset, offset), fg_inner)
    fg_dir = RES / "mipmap-xxxhdpi"
    fg_dir.mkdir(exist_ok=True)
    fg_canvas.save(fg_dir / "ic_launcher_foreground.png", optimize=True)
    print(f"  mipmap-xxxhdpi/ic_launcher_foreground.png ({ADAPTIVE_SIZE}²)")

    print("DONE")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
