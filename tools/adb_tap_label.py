"""Tippt genau EIN Element, dessen Beschriftung exakt passt.

    python tools/adb_tap_label.py <beschriftung> [ausgabe.png]

Zieht IMMER einen frischen uiautomator-Dump. Koordinaten aus einem
frueheren Dump werden nie wiederverwendet — genau das hat am
2026-08-14 den Spielstand eines Testers beschaedigt. Findet die Suche
kein oder mehr als ein Element, wird NICHT getippt.

Geraet: die Serie kommt aus der Umgebungsvariable FINANZGAME_DEVICE_ID;
ohne sie nimmt adb das einzige verbundene Geraet. adb wird ueber
ADB_PATH / ANDROID_HOME / LOCALAPPDATA gesucht.
"""
import os
import pathlib
import re
import subprocess
import sys
import time


def _adb_pfad() -> str:
    treffer = os.environ.get("ADB_PATH")
    if treffer:
        return treffer
    sdk = os.environ.get("ANDROID_HOME") or os.environ.get("ANDROID_SDK_ROOT")
    if not sdk:
        lokal = os.environ.get("LOCALAPPDATA", "")
        sdk = str(pathlib.Path(lokal) / "Android" / "Sdk")
    exe = pathlib.Path(sdk) / "platform-tools" / "adb"
    return str(exe.with_suffix(".exe") if os.name == "nt" else exe)


ADB = _adb_pfad()
SERIAL = os.environ.get("FINANZGAME_DEVICE_ID", "")
PKG = "com.finanzgame.finanzgame"
HERE = pathlib.Path(__file__).parent


def sh(*args) -> subprocess.CompletedProcess:
    ziel = ["-s", SERIAL] if SERIAL else []
    return subprocess.run([ADB, *ziel, *args], capture_output=True)


def beschriftungen(xml: str):
    """Flutter legt die Beschriftung mal in text, mal in content-desc."""
    return [m for m in re.findall(r'(?:text|content-desc)="([^"]*)"', xml)
            if m.strip()]


def frischer_dump() -> str:
    """Bis zu drei Versuche — uiautomator scheitert waehrend Animationen."""
    for _ in range(3):
        sh("shell", "uiautomator", "dump", "/sdcard/ui.xml")
        xml = sh("shell", "cat", "/sdcard/ui.xml").stdout.decode("utf-8", "replace")
        if beschriftungen(xml):
            return xml
        time.sleep(2)
    return ""


def im_vordergrund() -> bool:
    aus = sh("shell", "dumpsys", "activity", "activities").stdout.decode(
        "utf-8", "replace")
    zeile = next((z for z in aus.splitlines() if "topResumedActivity" in z), "")
    return PKG in zeile


def schiessen(name: str) -> None:
    png = sh("exec-out", "screencap", "-p").stdout
    (HERE / name).write_bytes(png)
    print(f"{name}: {len(png)} bytes")


# Alles Zustandsaendernde: nie antippen, egal was uebergeben wurde.
GESPERRT = ("schlafen", "zeitsprung", "vorspulen", "kaufen", "verkaufen",
            "pflanzen", "ernten", "faellen", "fällen", "reset", "loeschen",
            "löschen", "bestaetigen", "bestätigen", "antwort")


def main() -> None:
    gesucht = sys.argv[1]
    if any(w in gesucht.lower() for w in GESPERRT):
        sys.exit(f"ABBRUCH: '{gesucht}' steht auf der Sperrliste.")
    if not im_vordergrund():
        sys.exit("ABBRUCH: Finanzgame ist nicht im Vordergrund.")

    xml = frischer_dump()
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
