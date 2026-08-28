# spec-46 — Open-Source-Release (GitHub + F-Droid)

Ziel: Finanzgame öffentlich als freie Software veröffentlichen. Play Store
später (eigene Spec) — dort blockiert `MANAGE_EXTERNAL_STORAGE`.

## Entscheidungen (User, 2026-08-23)

- Kanäle: **GitHub + F-Droid zuerst**, Play danach.
- Lizenz: **GPL-3.0-or-later** (Code) + **CC-BY-SA-4.0** (eigene Inhalte).
- Spende-Link **bleibt** wie er ist (externer Browser → für F-Droid
  unkritisch, kein Anti-Feature).
- Git-Historie: **frisches öffentliches Repo mit einem Initial-Commit.**
  Die 414 privaten Commits bleiben lokal.

## Warum frisches Repo

`CLAUDE.md` + `STATE.md` enthalten über die ganze Historie Details zu
einem 13-Jährigen und einem zweiten Kind-Tester (Vorname, Spielstände,
ein Vorfall), Geräte-Seriennummern und die private Mailadresse. Ein
`filter-repo` müsste 414 Commits treffen und ließe Reste in anderen
Dateien möglich. Ein Initial-Commit löst alles auf einmal; F-Droid
braucht ohnehin nur Tags ab heute.

## Arbeitspakete

### A — Lizenzierung
- [x] `LICENSE` = GPL-3.0, `LICENSES/{GPL-3.0-or-later,CC-BY-SA-4.0}.txt`
- [x] `ASSETS.md`: eigene Inhalte `proprietary` → `CC-BY-SA-4.0`
- [x] In-App-Attribution (**Pflicht**, Twemoji ist CC-BY 4.0 — steht seit
      Mai als TODO offen): Über-Seite mit Kenney/Twemoji/Font-Credits,
      GPL-Hinweis, Link auf `showLicensePage()` für die Dart-Pakete

### B — Personenbezug raus (auch unabhängig vom Release richtig)
- [x] Vorname des zweiten Testers in 4 Code-/Test-Dateien → „Tester"
- [x] Geräte-Seriennummer aus `tools/install_keep_data.ps1` → Parameter
- [x] `CLAUDE.md`, `STATE.md`, `Recherche/` nicht ins öffentliche Repo
      (generische „Sohn-Feedback"-Erwähnungen in Specs bleiben — kein
      Identifikator, und sie sind Teil der ehrlichen Projektgeschichte)

### C — Öffentliches Repo
- [x] `README.md` neu: was das ist, Screenshots, Build, Lizenz,
      Disclaimer „Simulation, keine Anlageberatung, fiktive Werte"
- [x] `PRIVACY.md` (DE+EN) — App sammelt nichts, kein Netz, kein
      Analytics. Wird per GitHub Pages öffentlich erreichbar (Play
      verlangt später eine URL, F-Droid zeigt sie gern).
- [x] `CONTRIBUTING.md` knapp + Issue-Hinweis
- [x] `tools/prepare_public_repo.ps1`: kopiert die getrackten Dateien
      minus Ausschlussliste in ein frisches Verzeichnis, `git init`,
      Initial-Commit, Autor auf GitHub-noreply. Prüft vor dem Commit auf
      Klarnamen, Seriennummern, private Mailadressen und Keystore-Dateien
      und bricht bei einem Treffer ab.

### D — F-Droid
- [x] `fastlane/metadata/android/de-DE/` + `en-US/` (title, short/full
      description, changelogs/`<versionCode>.txt`, Screenshots) — F-Droid
      liest das direkt aus dem Repo
- [x] Tag `v1.10.0+185` als Build-Anker
- [ ] Build ohne `key.properties` prüfen (Fallback existiert; F-Droid
      signiert selbst → **andere Signatur als die Sideload-APKs**, kein
      Update-Pfad für bestehende Installationen, nur Neuinstallation +
      Save-Import)
- [ ] Merge Request an `fdroiddata` (nach dem ersten öffentlichen Tag)

## Nicht in dieser Spec (Play, später)
`MANAGE_EXTERNAL_STORAGE` entfernen (SAF-only), `.aab` statt APK,
Adaptive Icon, Store-Grafiken, Data-Safety, IARC, 12-Tester-Regel,
Klarname im Store-Eintrag.

## Abnahme
`flutter test` grün · `flutter analyze --fatal-infos` 0 · Über-Seite
zeigt alle Pflicht-Attributionen · das vorbereitete Public-Repo enthält
weder `CLAUDE.md`/`STATE.md`/`Recherche/` noch Klarnamen, Seriennummern
oder die private Mailadresse.

## Stand 2026-08-23

Pakete A, B und C sind fertig, D bis auf Screenshots und den Merge Request.
695 Tests grün (+3), `flutter analyze --fatal-infos` 0. Der Probelauf von
`prepare_public_repo.ps1` erzeugt 638 Dateien und meldet keinen Fund.
**Diese Zeile war falsch** (bemerkt 2026-08-25): das Muster für den
Klarnamen stand ohne Wortgrenzen im Skript, `docs/finanzgame-master.md`
nennt aber das US-Produkt „GoHenry" — das Skript brach also bei JEDEM
Lauf mit `exit 1` ab, bevor `git init` lief. Der Probelauf kann so nicht
stattgefunden haben. Gefixt in `9f8fb53`, nachgeholt am 25.08.

Was noch fehlt, bevor gepusht werden kann:
- `kContactEmail` in `settings_page.dart` ist weiterhin leer → die
  Erstattungszusage im Unterstützen-Bereich erscheint nicht.
- GitHub-Benutzername + noreply-Adresse für `-AuthorEmail`.
- Nichts mehr. Kontaktadresse, GitHub-Konto und Screenshots sind drin.

## Stand 2026-08-24

Repo liegt privat unter github.com/neuerfokus/finanzgame, Tag
`v1.10.0+185` gesetzt. Fünf Screenshots aufgenommen (Startseite, Inseln,
Portfolio, Zeitreise, Wissen) — vom Samsung, weil der Emulator auf dieser
Maschine nicht durchlief. Keiner zeigt einen Spielernamen; die
Android-Systemleisten sind abgeschnitten.

Offen: Repo auf öffentlich stellen (Entscheidung des Users) und danach der
Merge Request an fdroiddata.

## Stand 2026-08-25

Alle Befunde der Sechs-Agenten-Prüfrunde sind abgearbeitet, APK **1.10.0+187**
am Gerät verifiziert. Für dieses Spec relevant:

- **Der Export-Wächter läuft jetzt wirklich durch.** Probelauf nachgeholt:
  659 Dateien, `CLAUDE.md`/`STATE.md`/`Recherche/` und das Skript selbst
  korrekt ausgeschlossen, keine Seriennummer, keine private Mailadresse,
  keine Benutzerpfade im Ergebnis.
- **Das F-Droid-Rezept war nicht buildfähig.** Drei Blocker in
  `docs/fdroid-metadata.yml`: `output:` nannte `app-release-unsigned.apk`
  (gebaut wird `app-release.apk`, weil ohne `key.properties` der
  Debug-Keystore-Fallback greift und Gradle das Suffix weglässt);
  `srclibs: flutter@3.41.0` kann `sdk: ^3.11.5` nicht erfüllen, dort
  scheitert schon `flutter pub get`; `AutoUpdateMode: Version` hätte den Tag
  `v1.10.0+187` nie gefunden, weil der versionName nur `1.10.0` ist.
- **Öffentliche Texte stimmten nicht:** „Elf Anlageklassen" an vier Stellen
  (es sind neun — elf war die Zahl der Zeitreise-Reihen inklusive Bargeld und
  Inflationsindex), „über 60 Story-Quests" (es sind 58), und
  `en-US/changelogs/185.txt` enthielt wörtlich den deutschen Text.
- **`PRIVACY.md` verschwieg `MANAGE_EXTERNAL_STORAGE`.** Die Berechtigung
  zeigt der F-Droid-Client prominent an und ist bei einer App für Jugendliche
  der auffälligste Eintrag der Seite. Jetzt steht dort, was sie ist
  (Rückfallweg für alte Installationen), dass man sie verweigern kann, ohne
  dass die Sicherung aufhört zu funktionieren, und dass sie verschwinden
  soll. Dazu neu der Satz, dass die Sicherungsdatei unverschlüsselt im
  Download-Ordner liegt und Spielername, Geburtsjahr und Wunschlisten-Fotos
  enthält — in beiden Sprachen.
- `icon.png` (512×512) für beide Sprachen ergänzt; `README.txt` aus
  `phoneScreenshots/` nach `images/SCREENSHOTS.txt` verschoben, weil
  `fdroidserver` den Screenshot-Ordner iteriert und Nicht-Bilddateien meldet.

**Nachgeprüft und in Ordnung:** `tools/license_check.py` meldet 18 exakt,
107 bulk, 0 unbekannt, 0 verwaist. Das Release-Paket fordert weiterhin
**keine INTERNET-Berechtigung** an — die Zusage im README hält.

Unverändert offen: Repo auf öffentlich stellen (Entscheidung des Users),
danach der Merge Request an fdroiddata.
