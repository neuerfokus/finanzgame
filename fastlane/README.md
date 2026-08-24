# Store-Metadaten

Struktur nach dem Fastlane-Supply-Schema. **F-Droid liest diesen Ordner
direkt aus dem Git-Repository** — Titel, Beschreibungen, Änderungsprotokolle
und Screenshots landen so ohne Umweg im F-Droid-Client.

```
fastlane/metadata/android/<locale>/
  title.txt                  max. 30 Zeichen
  short_description.txt      max. 80 Zeichen
  full_description.txt       max. 4000 Zeichen
  changelogs/<versionCode>.txt   max. 500 Zeichen
  images/phoneScreenshots/   1.png, 2.png, … (mind. 2)
  images/icon.png            512×512
  images/featureGraphic.png  1024×500 (nur Play)
```

Der Dateiname eines Änderungsprotokolls ist der **versionCode**, nicht der
Versionsname: `pubspec.yaml` `1.10.0+185` → `changelogs/185.txt`.

Noch offen: Screenshots und `icon.png` ablegen. Ohne mindestens zwei
Screenshots wirkt der F-Droid-Eintrag leer, und Play verlangt sie ohnehin.
