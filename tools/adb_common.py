"""Gemeinsame Grundlage der adb-Werkzeuge.

Vorher standen diese rund 55 Zeilen doppelt in `adb_tap_label.py` und
`adb_tap_xy.py`. Praktische Folge: ein Fix musste an zwei Stellen landen,
und wenn er nur an einer landete, war das von aussen nicht zu sehen.

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

# Die Oberflaeche ist voller Emoji ("🌱 Alle reifen ernten"). Die
# Windows-Konsole steht per Vorgabe auf cp1252 und wirft beim Ausgeben
# einen UnicodeEncodeError — das Werkzeug stirbt dann ausgerechnet beim
# Auflisten dessen, was es gefunden hat.
for _strom in (sys.stdout, sys.stderr):
    if hasattr(_strom, "reconfigure"):
        _strom.reconfigure(encoding="utf-8", errors="replace")

PKG = "com.finanzgame.finanzgame"

#: Auf dem Geraet. Wird vor JEDEM Dump geloescht, siehe frischer_dump.
DUMP_PFAD = "/sdcard/finanzgame_ui.xml"


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


def sh(*args) -> subprocess.CompletedProcess:
    """adb-Aufruf. Wirft NICHT — Aufrufer pruefen `returncode` selbst."""
    if not pathlib.Path(ADB).exists():
        sys.exit(
            f"ABBRUCH: adb nicht gefunden unter {ADB}.\n"
            "Setze ADB_PATH oder ANDROID_HOME."
        )
    ziel = ["-s", SERIAL] if SERIAL else []
    return subprocess.run([ADB, *ziel, *args], capture_output=True)


def _text(p: subprocess.CompletedProcess) -> str:
    return p.stdout.decode("utf-8", "replace")


def beschriftungen(xml: str):
    """Flutter legt die Beschriftung mal in text, mal in content-desc."""
    return [
        m
        for m in re.findall(r'(?:text|content-desc)="([^"]*)"', xml)
        if m.strip()
    ]


def frischer_dump() -> str:
    """Zieht einen nachweislich frischen uiautomator-Dump.

    WARUM SO UMSTAENDLICH: die alte Fassung verwarf den Rueckgabewert von
    `uiautomator dump` komplett und loeschte die Datei vorher nicht. Schlug
    der Dump fehl — genau der Fall, fuer den die Wiederholung gebaut ist,
    etwa waehrend einer laufenden Animation —, lag die Datei vom
    VORHERIGEN Lauf noch auf dem Geraet. `cat` lieferte sie aus, sie enthielt
    Beschriftungen, die Pruefung war erfuellt, und das Werkzeug tippte auf
    Koordinaten eines Bildschirms, der laengst zu war.

    Das ist woertlich der Vorfall vom 2026-08-14, und es ist die eine
    Zusage, die diese Werkzeuge machen. Deshalb jetzt: vorher loeschen,
    Rueckgabewert UND die `dumped to`-Bestaetigung pruefen, und bei
    Misserfolg leer zurueckgeben statt irgendetwas zu liefern.
    """
    for _ in range(3):
        sh("shell", "rm", "-f", DUMP_PFAD)
        # Gegenprobe: die Datei ist wirklich weg. Sonst koennte ein
        # fehlgeschlagenes rm den alten Stand stehen lassen.
        if _text(sh("shell", "ls", DUMP_PFAD)).strip().endswith(DUMP_PFAD):
            time.sleep(1)
            continue

        p = sh("shell", "uiautomator", "dump", DUMP_PFAD)
        if p.returncode != 0 or "dumped to" not in _text(p).lower():
            time.sleep(2)
            continue

        c = sh("shell", "cat", DUMP_PFAD)
        if c.returncode != 0:
            time.sleep(2)
            continue
        xml = _text(c)
        if beschriftungen(xml):
            return xml
        time.sleep(2)
    return ""


def im_vordergrund() -> bool:
    p = sh("shell", "dumpsys", "activity", "activities")
    if p.returncode != 0:
        sys.exit(
            "ABBRUCH: adb erreicht das Geraet nicht "
            "(Serie falsch, Geraet offline, USB-Debugging aus?).\n"
            + _text(p)[:300]
        )
    zeile = next(
        (z for z in _text(p).splitlines() if "topResumedActivity" in z), ""
    )
    return PKG in zeile


def schiessen(ziel: str) -> None:
    """Screenshot speichern.

    Landet unter `tools/out/`, NICHT neben den Skripten: dort wuerde jeder
    Aufruf ein PNG in den Repo-Baum legen, das beim naechsten `git add -A`
    mitgeht — und Geraete-Screenshots sind genau die Kategorie Datei, die
    hier aus Personenbezugsgruenden nicht unkontrolliert entstehen soll.
    `tools/out/` ist in `.gitignore`.
    """
    p = sh("exec-out", "screencap", "-p")
    if p.returncode != 0 or not p.stdout:
        sys.exit("ABBRUCH: screencap lieferte nichts.")
    pfad = pathlib.Path(ziel)
    if not pfad.is_absolute():
        pfad = pathlib.Path(__file__).parent / "out" / pfad.name
    pfad.parent.mkdir(parents=True, exist_ok=True)
    pfad.write_bytes(p.stdout)
    print(f"{pfad}: {len(p.stdout)} bytes")


#: Alles Zustandsaendernde: nie antippen, egal was uebergeben wurde.
#:
#: Ergaenzt 2026-08-24 um Auszahlen/Kuendigen (Vertrag und Geld weg),
#: Wiederherstellen/Importieren (ueberschreibt die Produktions-DB),
#: Einloesen/Freischalten/Aufraeumen. Die alte Liste liess `python
#: tools/adb_tap_label.py "Auszahlen"` widerspruchslos durchlaufen und
#: beendete damit einen Vertrag im Spielstand des Testers.
GESPERRT = (
    "schlafen", "zeitsprung", "vorspulen", "kaufen", "verkaufen",
    "pflanzen", "ernten", "faellen", "fällen", "reset", "loeschen",
    "löschen", "bestaetigen", "bestätigen", "antwort",
    "auszahlen", "kuendigen", "kündigen", "verwerfen", "entnehmen",
    "wiederherstellen", "importieren", "exportieren", "laden",
    "einloesen", "einlösen", "freischalten", "aufraeumen", "aufräumen",
    "starten", "schliessen", "schließen", "ja,",
)


def pruefe_gesperrt(gesucht: str) -> None:
    treffer = [w for w in GESPERRT if w in gesucht.lower()]
    if treffer:
        sys.exit(
            f"ABBRUCH: '{gesucht}' enthaelt {treffer!r} und steht damit auf "
            "der Sperrliste. Zustandsaendernde Aktionen werden nie "
            "automatisch getippt."
        )
