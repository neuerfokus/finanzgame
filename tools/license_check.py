"""Spec-45 H5: Asset-Lizenz-Check vor Privat-Release.

Scant assets/ rekursiv, vergleicht mit ASSETS.md-Einträgen.

Findet:
- Assets ohne ASSETS.md-Coverage (unknown origin)
- ASSETS.md-Einträge ohne reale Files (verwaiste Doku)
- CC-BY-Assets ohne Attribution-Hinweis im In-App-Credits (TODO)

Output: tools/license_check_report.md mit ✅/⚠/❌ pro Bucket.
Exit-Code: 0 wenn sauber, 1 wenn Findings.
"""
import re
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).parent.parent
ASSETS_DIR = ROOT / 'assets'
ASSETS_MD = ROOT / 'ASSETS.md'
REPORT = ROOT / 'tools' / 'license_check_report.md'

# Patterns die Bulk-Einträge in ASSETS.md decken (Wildcard-Coverage).
BULK_PATTERNS = [
    # (regex_match_against_relpath, lizenz, beschreibung)
    (re.compile(r'^assets/images/iso/.*\.png$'), 'CC0', 'Kenney Iso'),
    (re.compile(r'^assets/images/islands/tile_0\d\.png$'), 'CC0',
     'Kenney Pirate Pack tiles'),
    (re.compile(r'^assets/images/islands_composite/.*\.png$'), 'CC0',
     'Kenney composite'),
    (re.compile(r'^assets/images/furniture/.*\.png$'), 'CC-BY 4.0',
     'Twemoji'),
    # Eigene Inhalte (eigene Inhalte): Quests, Branding-Icon, Reihenfolge.
    (re.compile(r'^assets/quests/.*\.(yaml|md)$'), 'proprietary',
     'eigene Quest-Inhalte'),
    (re.compile(r'^assets/branding/.*'), 'proprietary',
     'eigenes Branding'),
    # Kenney Fonts Pack — alle CC0.
    (re.compile(r'^assets/fonts/Kenney.*\.ttf$'), 'CC0', 'Kenney Fonts Pack'),
    # README-Dateien sind Doku, keine Assets.
    (re.compile(r'^assets/.*/README\.md$'), 'doc', 'Doku, kein Asset'),
]


def parse_assets_md() -> set[str]:
    """Liest exakte Pfade aus den Markdown-Tabellen."""
    paths: set[str] = set()
    text = ASSETS_MD.read_text(encoding='utf-8')
    for line in text.splitlines():
        line = line.strip()
        if not line.startswith('|'):
            continue
        cells = [c.strip() for c in line.split('|') if c.strip()]
        if not cells:
            continue
        # erste Spalte = Pfad
        cell = cells[0]
        if cell.startswith('assets/'):
            # "tile_01.png..tile_05.png" = Range-Notation, einfach den
            # ersten Eintrag merken (Bulk-Pattern deckt Rest).
            if '..' in cell:
                paths.add(cell.split('..')[0].strip())
            else:
                paths.add(cell)
    return paths


def is_covered_by_bulk(rel: str) -> tuple[bool, str]:
    for pat, lic, desc in BULK_PATTERNS:
        if pat.match(rel):
            return True, f'{desc} ({lic})'
    return False, ''


def scan_files() -> list[str]:
    out: list[str] = []
    for fp in ASSETS_DIR.rglob('*'):
        if not fp.is_file():
            continue
        rel = str(fp.relative_to(ROOT)).replace('\\', '/')
        out.append(rel)
    return sorted(out)


def main() -> int:
    md_paths = parse_assets_md()
    real_files = scan_files()

    uncovered: list[str] = []
    bulk_covered: list[tuple[str, str]] = []
    exact_covered: list[str] = []

    for rel in real_files:
        if rel in md_paths:
            exact_covered.append(rel)
            continue
        hit, desc = is_covered_by_bulk(rel)
        if hit:
            bulk_covered.append((rel, desc))
        else:
            uncovered.append(rel)

    # ASSETS.md-Einträge die kein File haben → verwaiste Doku
    orphaned: list[str] = []
    for md in md_paths:
        # Wildcard-Eintrag erlaubt (z.B. "tile_01..tile_05" oder ".../*.png")
        if '*' in md or '..' in md:
            continue
        if not (ROOT / md).exists():
            orphaned.append(md)

    lines = ['# Asset-Lizenz-Check Report', '',
             f'Generiert: {Path(__file__).name}', '',
             f'Files gescant: **{len(real_files)}**',
             f'ASSETS.md-Pfade: **{len(md_paths)}**', '']

    lines.append('## ✅ Exakt gedeckt')
    lines.append(f'{len(exact_covered)} Files mit explizitem '
                 'ASSETS.md-Eintrag.')
    lines.append('')

    lines.append('## ✅ Bulk-gedeckt (Wildcard/Pattern)')
    lines.append(f'{len(bulk_covered)} Files durch Pattern-Coverage:')
    for rel, desc in bulk_covered[:20]:
        lines.append(f'- {rel} — {desc}')
    if len(bulk_covered) > 20:
        lines.append(f'... +{len(bulk_covered) - 20} weitere')
    lines.append('')

    if uncovered:
        lines.append('## ❌ Unbekannte Herkunft (FIX)')
        for rel in uncovered:
            lines.append(f'- {rel}')
        lines.append('')
    else:
        lines.append('## ❌ Unbekannte Herkunft — keine ✓')
        lines.append('')

    if orphaned:
        lines.append('## ⚠ ASSETS.md-Einträge ohne File')
        for md in orphaned:
            lines.append(f'- {md}')
        lines.append('')
    else:
        lines.append('## ⚠ Verwaiste Doku — keine ✓')
        lines.append('')

    REPORT.write_text('\n'.join(lines), encoding='utf-8')
    print(f'Report: {REPORT}')
    print(f'  Exact:    {len(exact_covered)}')
    print(f'  Bulk:     {len(bulk_covered)}')
    print(f'  Unknown:  {len(uncovered)}')
    print(f'  Orphaned: {len(orphaned)}')
    return 1 if uncovered else 0


if __name__ == '__main__':
    sys.exit(main())
