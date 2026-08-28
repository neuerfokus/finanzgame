"""Tippt genau EIN Element, dessen Beschriftung exakt passt.

    python tools/adb_tap_label.py <beschriftung> [ausgabe.png]

Zieht IMMER einen frischen uiautomator-Dump — nachweislich frisch, siehe
`adb_common.frischer_dump`. Koordinaten aus einem frueheren Dump werden nie
wiederverwendet; genau das hat am 2026-08-14 den Spielstand eines Testers
beschaedigt. Findet die Suche kein oder mehr als ein Element, wird NICHT
getippt.

Geraet: die Serie kommt aus der Umgebungsvariable FINANZGAME_DEVICE_ID;
ohne sie nimmt adb das einzige verbundene Geraet. adb wird ueber
ADB_PATH / ANDROID_HOME / LOCALAPPDATA gesucht.
"""
import re
import sys
import time

from adb_common import (
    frischer_dump,
    im_vordergrund,
    pruefe_gesperrt,
    schiessen,
    sh,
)


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    gesucht = sys.argv[1]
    pruefe_gesperrt(gesucht)
    if not im_vordergrund():
        sys.exit("ABBRUCH: Finanzgame ist nicht im Vordergrund.")

    xml = frischer_dump()
    if not xml:
        sys.exit(
            "ABBRUCH: kein frischer uiautomator-Dump zu bekommen (drei "
            "Versuche). NICHT getippt — ein alter Dump waere genau der "
            "Fehler vom 2026-08-14."
        )

    knoten = []
    for n in re.findall(r"<node[^>]*>", xml):
        t = re.search(r'text="([^"]*)"', n)
        c = re.search(r'content-desc="([^"]*)"', n)
        b = re.search(r'bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"', n)
        lab = (t.group(1) if t else "") or (c.group(1) if c else "")
        if lab.strip() and b:
            knoten.append((lab, tuple(int(v) for v in b.groups())))

    treffer = [(l, bb) for l, bb in knoten if l.strip() == gesucht]
    if not treffer:
        print("KEIN TREFFER. Sichtbar sind:")
        for l, bb in knoten:
            print("  ", repr(l[:70]), bb)
        sys.exit(1)
    if len(treffer) > 1:
        sys.exit(f"ABBRUCH: {len(treffer)}x '{gesucht}', nicht eindeutig.")

    lab, (x1, y1, x2, y2) = treffer[0]
    cx, cy = (x1 + x2) // 2, (y1 + y2) // 2
    print(f"tippe '{lab}' bei ({cx},{cy}) aus [{x1},{y1}][{x2},{y2}]")
    sh("shell", "input", "tap", str(cx), str(cy))
    time.sleep(4)
    if len(sys.argv) > 2:
        schiessen(sys.argv[2])


main()
