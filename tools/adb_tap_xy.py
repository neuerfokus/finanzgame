"""Tippt auf Koordinaten — nur wenn der erwartete Bildschirm offen ist.

    python tools/adb_tap_xy.py <x> <y> <erwartete-Kopfzeile> <ausgabe.png>

Noetig fuer die Monetaria-Karte: die Insel-Marker sind Flame-
Komponenten auf einer Leinwand und tauchen im uiautomator-Dump gar
nicht auf, es gibt dort also keinen Elementtext zum Abgleichen.
Ersatz-Absicherung: Vordergrund-Paket pruefen, frischen Dump ziehen,
Kopfzeile verlangen — sonst Abbruch ohne Tap.

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


def main() -> None:
    x, y = int(sys.argv[1]), int(sys.argv[2])
    kopfzeile, ausgabe = sys.argv[3], sys.argv[4]

    if not im_vordergrund():
        sys.exit("ABBRUCH: Finanzgame ist nicht im Vordergrund.")

    labels = beschriftungen(frischer_dump())
    if kopfzeile not in labels:
        sys.exit(f"ABBRUCH: Kopfzeile '{kopfzeile}' nicht da. Sichtbar: {labels}")

    print(f"'{kopfzeile}' bestaetigt -> tippe ({x},{y})")
    sh("shell", "input", "tap", str(x), str(y))
    time.sleep(5)
    schiessen(ausgabe)


main()
