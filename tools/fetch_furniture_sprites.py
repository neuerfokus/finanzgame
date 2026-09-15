"""Fetch Twemoji PNGs (CC-BY) for furniture catalog items.

Maps each FurnitureItem.id to its emoji, downloads the 72px Twemoji PNG
from jsDelivr, saves to assets/images/furniture/<id>.png.

Welle-8: alle Emojis sind unique (User: keine Doppelungen) + besser
zu Bezeichnung passend.
"""
import os
import sys
import urllib.parse
import urllib.request
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')

# (id, emoji) tuples — mirror lib/features/zimmer/furniture_catalog.dart
ITEMS = [
    # bed
    ('bed_basic', '🛏'),
    ('bed_premium', '🛌'),
    ('bed_loft', '🪜'),
    ('bed_water', '💦'),
    # desk
    ('desk_basic', '🖋'),
    ('desk_premium', '🖱'),
    ('desk_standing', '🧑‍💻'),
    ('desk_drafting', '📐'),
    # chair
    ('chair_basic', '🪑'),
    ('chair_gaming', '💺'),
    ('chair_office', '💼'),
    ('chair_beanbag', '🛋'),
    # tech
    ('tech_pc', '🖥'),
    ('tech_tv', '📺'),
    ('tech_console', '🎮'),
    ('tech_headphones', '🎧'),
    ('tech_handheld', '🕹'),
    ('tech_vr', '🥽'),
    ('tech_phone', '📱'),
    ('tech_tablet', '📲'),
    ('tech_speaker', '🔊'),
    ('tech_hifi', '📻'),
    ('tech_camera', '📷'),
    ('tech_drone', '📹'),
    ('tech_guitar', '🎸'),
    ('tech_drumset', '🥁'),
    ('tech_keyboard', '🎹'),
    ('tech_microscope', '🔬'),
    ('tech_telescope', '🔭'),
    # decor
    ('decor_plant', '🪴'),
    ('decor_picture', '🖼'),
    ('decor_poster', '🎶'),
    ('decor_aquarium', '🐠'),
    ('decor_basketball', '🏀'),
    ('decor_skateboard', '🛹'),
    ('decor_dartboard', '🎯'),
    ('decor_globe', '🌐'),
    # lamp
    ('lamp_basic', '💡'),
    ('lamp_neon', '🌈'),
    ('lamp_lava', '🕯'),
    ('lamp_disco', '🪩'),
    ('lamp_starlight', '✨'),
]

# Pinned, not @latest: this script writes files that ship inside the app, so
# an unpinned CDN tag would let a re-run silently change shipped assets.
# v14.0.2 is the final Twemoji release (repo archived) and is what @latest
# resolves to today — pinning changes no bytes now, only future surprises.
BASE = 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72'
ALLOWED_HOST = 'cdn.jsdelivr.net'


def emoji_to_codepoint(emoji: str) -> str:
    """Twemoji file naming: codepoints joined with '-', VS16 (fe0f) stripped
    when emoji has multiple codepoints. ZWJ (200d) kept."""
    cps = [hex(ord(c))[2:] for c in emoji]
    if len(cps) > 1:
        cps = [c for c in cps if c != 'fe0f']
    return '-'.join(cps)


def check_url(url: str) -> None:
    """Refuse anything that left the pinned CDN.

    urllib follows file:// and plain http:// without complaint. ITEMS is
    static today, but a mistyped BASE or a stray codepoint should abort the
    run rather than write whatever came back into assets/.
    """
    parsed = urllib.parse.urlparse(url)
    if parsed.scheme != 'https' or parsed.netloc != ALLOWED_HOST:
        raise ValueError(f'refusing non-allowlisted URL: {url}')


def main():
    out_dir = Path('assets/images/furniture')
    out_dir.mkdir(parents=True, exist_ok=True)
    force = '--force' in sys.argv
    failures = []
    # Uniqueness check
    seen_emojis = set()
    dupes = []
    for item_id, emoji in ITEMS:
        if emoji in seen_emojis:
            dupes.append((item_id, emoji))
        seen_emojis.add(emoji)
    if dupes:
        print('DOPPELUNGEN gefunden:')
        for d in dupes:
            print(f'  {d}')
        sys.exit(2)

    for item_id, emoji in ITEMS:
        cp = emoji_to_codepoint(emoji)
        url = f'{BASE}/{cp}.png'
        check_url(url)
        dst = out_dir / f'{item_id}.png'
        if dst.exists() and not force:
            print(f'  skip {item_id} (exists)')
            continue
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'fg-script'})
            with urllib.request.urlopen(req, timeout=15) as r:
                data = r.read()
            dst.write_bytes(data)
            print(f'  ok   {item_id}  {emoji}  ({len(data)} bytes)')
        except Exception as e:
            failures.append((item_id, emoji, cp, str(e)))
            print(f'  FAIL {item_id}  {emoji}  cp={cp}  err={e}')
    if failures:
        print(f'\n{len(failures)} failed:')
        for f in failures:
            print(f'  {f}')
        sys.exit(1)
    print(f'\n{len(ITEMS)} sprites in {out_dir}')


if __name__ == '__main__':
    main()
