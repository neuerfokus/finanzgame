"""Tippt auf Koordinaten — nur wenn der erwartete Bildschirm offen ist.

    python tools/adb_tap_xy.py <x> <y> <erwartete-Kopfzeile> <ausgabe.png>

Noetig fuer die Monetaria-Karte: die Insel-Marker sind Flame-Komponenten
auf einer Leinwand und tauchen im uiautomator-Dump gar nicht auf, es gibt
dort also keinen Elementtext zum Abgleichen. Ersatz-Absicherung:
Vordergrund-Paket pruefen, nachweislich frischen Dump ziehen, Kopfzeile
verlangen — sonst Abbruch ohne Tap.

EHRLICHE GRENZE: die Kopfzeile belegt, welcher BILDSCHIRM offen ist, nicht
was an (x,y) liegt. Ein Coach-Overlay, eine SnackBar oder ein Dialog kann
darueberliegen, waehrend die Kopfzeile weiter im Dump steht. Die Karte
selbst laesst sich nicht verschieben (`camera.viewfinder.visibleGameSize`
ist fest, kein Drag, kein Zoom), die Insel-Koordinaten wandern also nicht —
das Restrisiko sind wirklich nur Overlays. Deshalb: nur fuer Navigation
verwenden, nie fuer etwas Unumkehrbares.

Geraet: die Serie kommt aus der Umgebungsvariable FINANZGAME_DEVICE_ID;
ohne sie nimmt adb das einzige verbundene Geraet. adb wird ueber
ADB_PATH / ANDROID_HOME / LOCALAPPDATA gesucht.
"""
import sys
import time

from adb_common import (
    beschriftungen,
    frischer_dump,
    im_vordergrund,
    schiessen,
    sh,
)


def main() -> None:
    if len(sys.argv) < 5:
        sys.exit(__doc__)
    x, y = int(sys.argv[1]), int(sys.argv[2])
    kopfzeile, ausgabe = sys.argv[3], sys.argv[4]

    if not im_vordergrund():
        sys.exit("ABBRUCH: Finanzgame ist nicht im Vordergrund.")

    xml = frischer_dump()
    if not xml:
        sys.exit(
            "ABBRUCH: kein frischer uiautomator-Dump zu bekommen (drei "
            "Versuche). NICHT getippt — ein alter Dump waere genau der "
            "Fehler vom 2026-08-14."
        )

    labels = beschriftungen(xml)
    if kopfzeile not in labels:
        sys.exit(
            f"ABBRUCH: Kopfzeile '{kopfzeile}' nicht da. Sichtbar: {labels}"
        )

    print(f"'{kopfzeile}' bestaetigt -> tippe ({x},{y})")
    sh("shell", "input", "tap", str(x), str(y))
    time.sleep(5)
    schiessen(ausgabe)


main()
