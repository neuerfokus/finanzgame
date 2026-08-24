"""Fix transliterated umlauts in quest YAMLs.

Whole-word replacements only. Case-aware (capitalizes if source was cap).
"""
import re
import sys
from pathlib import Path

# Whole-word lowercase mappings. Capitalization handled automatically.
REPL = {
    "fuer": "für",
    "ueber": "über",
    "ueberall": "überall",
    "ueblich": "üblich",
    "uebliche": "übliche",
    "ueblicherweise": "üblicherweise",
    "koennen": "können",
    "koennte": "könnte",
    "koennten": "könnten",
    "kuenftig": "künftig",
    "moeglich": "möglich",
    "moeglichkeit": "möglichkeit",
    "moechte": "möchte",
    "muessen": "müssen",
    "muss": "muss",
    "gehoert": "gehört",
    "gehoeren": "gehören",
    "hoeher": "höher",
    "hoehere": "höhere",
    "hoeherer": "höherer",
    "hoeheres": "höheres",
    "hoeheren": "höheren",
    "hoeren": "hören",
    "schoen": "schön",
    "schoene": "schöne",
    "schoener": "schöner",
    "loesen": "lösen",
    "loesung": "lösung",
    "loesungen": "lösungen",
    "naechst": "nächst",
    "naechste": "nächste",
    "naechster": "nächster",
    "naechsten": "nächsten",
    "naechstes": "nächstes",
    "spaeter": "später",
    "jaehrlich": "jährlich",
    "jaehrliche": "jährliche",
    "jaehrlichen": "jährlichen",
    "jaehriger": "jähriger",
    "jaehrigen": "jährigen",
    "jaehrige": "jährige",
    "aehnlich": "ähnlich",
    "aehnliche": "ähnliche",
    "aehnlicher": "ähnlicher",
    "aehnliches": "ähnliches",
    "aendern": "ändern",
    "aenderung": "änderung",
    "europaeisch": "europäisch",
    "europaeische": "europäische",
    "europaeischen": "europäischen",
    "europaeischer": "europäischer",
    "aktionaer": "aktionär",
    "aktionaere": "aktionäre",
    "aktionaeren": "aktionären",
    "gebuehr": "gebühr",
    "gebuehren": "gebühren",
    "staendig": "ständig",
    "staendige": "ständige",
    "staendigen": "ständigen",
    "staendiges": "ständiges",
    "betraege": "beträge",
    "betraegen": "beträgen",
    "maerkte": "märkte",
    "bullenmaerkte": "bullenmärkte",
    "tueren": "türen",
    "fluess": "flüss",
    "fluessig": "flüssig",
    "qualitaet": "qualität",
    "aktivitaet": "aktivität",
    "tatsaechlich": "tatsächlich",
    "tatsaechliche": "tatsächliche",
    "waehrung": "währung",
    "waehrungen": "währungen",
    "froehlich": "fröhlich",
    "groesse": "größe",
    "grosse": "große",
    "grosser": "großer",
    "grosses": "großes",
    "grossen": "großen",
    "gross": "groß",
    "heisst": "heißt",
    "weiss": "weiß",
    "foerder": "förder",
    "foerderung": "förderung",
    "garantietraeger": "garantieträger",
    "traeger": "träger",
    "traegt": "trägt",
    "haeufig": "häufig",
    "haeufige": "häufige",
    "haeufiger": "häufiger",
    "guete": "güte",
    "wuensche": "wünsche",
    "wuenscht": "wünscht",
    "noetig": "nötig",
    "noetige": "nötige",
    "verfuegbar": "verfügbar",
    "verfuegbare": "verfügbare",
    "verfuegung": "verfügung",
    "vermoegen": "vermögen",
    "froh": "froh",
    "bevoelkerung": "bevölkerung",
    "selbststaendig": "selbstständig",
    "vergueten": "vergüten",
    "verguetung": "vergütung",
    "ruecklage": "rücklage",
    "ruecklagen": "rücklagen",
    "ruecksicht": "rücksicht",
    "vergleichsweise": "vergleichsweise",  # noop
    "abgekuerzt": "abgekürzt",
    "kuerzlich": "kürzlich",
    "kuerzen": "kürzen",
    "spruenge": "sprünge",
    "anlaesslich": "anlässlich",
    "stueck": "stück",
    "stuecke": "stücke",
    "anteilsstueck": "anteilsstück",
    "gluck": "gluck",  # noop
    "glueck": "glück",
    "ausgleich": "ausgleich",  # noop
    "uebrig": "übrig",
    "ueblich": "üblich",
    "uebung": "übung",
    "duenger": "dünger",
    "duenn": "dünn",
    "haerter": "härter",
    "haert": "härt",
    "rueckgang": "rückgang",
    "rueck": "rück",
    "kuendigen": "kündigen",
    "kuendigung": "kündigung",
    "ueberzeugt": "überzeugt",
    "ueberzeugung": "überzeugung",
    "stuermisch": "stürmisch",
    "sturm": "sturm",  # noop
    "wuerde": "würde",
    "wuerden": "würden",
    "buero": "büro",
}


def smart_case(orig: str, new: str) -> str:
    if orig[0].isupper():
        return new[0].upper() + new[1:]
    return new


def fix_text(text: str) -> tuple[str, int]:
    count = 0
    for old, new in REPL.items():
        if old == new:
            continue
        # word-boundary case-insensitive
        pattern = re.compile(r"\b" + re.escape(old) + r"\b", re.IGNORECASE)

        def sub(m):
            nonlocal count
            count += 1
            return smart_case(m.group(0), new)

        text = pattern.sub(sub, text)
    return text, count


def main():
    root = Path(sys.argv[1] if len(sys.argv) > 1 else "assets/quests")
    files = sorted(root.glob("*.yaml"))
    total = 0
    for f in files:
        original = f.read_text(encoding="utf-8")
        fixed, n = fix_text(original)
        if n > 0:
            f.write_text(fixed, encoding="utf-8")
            print(f"  {f.name}: {n} fixes")
            total += n
    print(f"\nTotal: {total} replacements in {len(files)} files")


if __name__ == "__main__":
    main()
