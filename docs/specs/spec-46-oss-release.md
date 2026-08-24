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
- [ ] Tag `v1.10.0+185` als Build-Anker
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

Was noch fehlt, bevor gepusht werden kann:
- `kContactEmail` in `settings_page.dart` ist weiterhin leer → die
  Erstattungszusage im Unterstützen-Bereich erscheint nicht.
- GitHub-Benutzername + noreply-Adresse für `-AuthorEmail`.
- Mindestens zwei Screenshots unter
  `fastlane/metadata/android/de-DE/images/phoneScreenshots/`.
- Platzhalter `DEINNAME` in `docs/fdroid-metadata.yml` ersetzen.
