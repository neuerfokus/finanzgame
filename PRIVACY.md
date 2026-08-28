# Datenschutzerklärung — Finanzgame

Stand: 23. August 2026

## Kurzfassung

Finanzgame sammelt nichts. Die App hat keine Nutzerkonten, keine
Registrierung, keine Werbung, kein Analytics und keinen Cloud-Dienst. Sie
sendet keine Daten an den Entwickler oder an Dritte. Alles, was du im Spiel
tust, bleibt auf deinem Gerät.

## Welche Daten die App auf dem Gerät speichert

In einer lokalen Datenbank auf dem Gerät:

- **Spielstand**: Spielername (frei wählbar, gern ein Spitzname),
  Spielfortschritt, Vermögen im Spiel, gelöste Quests, Trophäen, Einstellungen.
- **Geburtsjahr**, falls du es angibst — nur die vierstellige Jahreszahl, kein
  vollständiges Datum. Sie steuert allein, ob der freiwillige Unterstützen-
  Bereich sichtbar ist. Die Frage lässt sich überspringen.
- **Eltern-PIN**, falls gesetzt — gespeichert als SHA-256-Prüfsumme, nicht im
  Klartext.
- **Eigene Fotos**, falls du zu einem Wunsch auf deiner Wunschliste ein Bild
  aussuchst. Die Datei wird in den privaten Ordner der App kopiert und
  ausschließlich dort angezeigt.
- **Echte Sparziele und Erfolge**, falls du welche einträgst — der Text, den
  du selbst schreibst.

Nichts davon verlässt das Gerät, außer du gibst es selbst weiter (siehe unten).

## Was du selbst weitergeben kannst

- **Spielstand sichern**: Die App legt auf Wunsch eine Sicherungsdatei
  (`.fgsave`) in einem Ordner an, den du auswählst. Diese Datei enthält deinen
  kompletten Spielstand samt der oben genannten Angaben. Wo du sie hinlegst
  oder wem du sie schickst, entscheidest du.
- **Bericht teilen**: Du kannst deinen Spielstand als Text über das
  Teilen-Menü deines Handys verschicken.
- **Diagnosedateien teilen**: Wenn ein Spielstand beschädigt ist, kannst du
  die betroffenen Dateien über das Teilen-Menü an jemanden schicken, der beim
  Reparieren hilft. Auch das passiert nur, wenn du es aktiv auslöst.

## Berechtigungen

- **Speicherzugriff**: um deine Sicherungsdatei in den von dir gewählten Ordner
  zu schreiben und wieder zu lesen.

  Die App fordert dafür „**Zugriff auf alle Dateien**"
  (`MANAGE_EXTERNAL_STORAGE`) an. Das ist eine weitreichende Berechtigung, und
  du sollst wissen, warum sie dasteht: sie ist der **Rückfallweg** für ältere
  Installationen. Der reguläre Weg ist seit Version 1.10.0+172 der
  System-Ordnerwähler — du suchst einmal einen Ordner aus, und die App darf
  genau dort schreiben, sonst nirgends. Wer diesen Weg nutzt, für den bleibt
  die Berechtigung ungenutzt; du kannst sie in den Android-Einstellungen
  verweigern, ohne dass die Sicherung aufhört zu funktionieren.

  Sie soll verschwinden, sobald der Rückfallweg nicht mehr gebraucht wird.
- **Deine Sicherungsdatei ist nicht verschlüsselt.** Nutzt du den alten Weg,
  landet sie in `Download/Finanzgame/` — dort kann jede App mit
  Datei-Zugriff sie lesen. Darin stehen dein Spielername, dein Geburtsjahr
  (falls eingegeben) und die Bilder, die du für deine Wunschliste ausgesucht
  hast. Wähle einen eigenen Ordner, wenn dir das wichtig ist.
- **Fotos**: nur, wenn du ein Bild für deine Wunschliste aussuchst.
- **Internet**: Die App fordert die Internet-Berechtigung **gar nicht erst
  an**. Android verhindert damit auf Systemebene, dass sie überhaupt eine
  Verbindung aufbauen kann. Der einzige Weg nach draußen ist ein Link, den du
  bewusst antippst — dann öffnet sich der Browser deines Handys, und ab dort
  gilt dessen Datenschutzerklärung.

## Kinder und Jugendliche

Die App richtet sich an Jugendliche. Genau deshalb sammelt sie keine
personenbezogenen Daten, hat keine Werbung, keine Käufe im Spiel und keine
Verbindung zu sozialen Netzwerken. Sie fragt nie nach Geschlecht, Adresse,
Telefonnummer oder E-Mail-Adresse. Der Spielername darf ein Spitzname sein.

## Löschen

Die App zu deinstallieren löscht alle Daten auf dem Gerät. Eine
Sicherungsdatei, die du selbst angelegt hast, bleibt liegen — die löschst du
wie jede andere Datei. In den Einstellungen gibt es außerdem einen Reset.

## Änderungen

Änderungen an dieser Erklärung stehen in der Versionsgeschichte des
öffentlichen Quelltext-Repositories.

## Kontakt

sepp.github@gmail.com — auch für die Erstattung einer versehentlichen
Zahlung, unbürokratisch und ohne Nachfragen.

---

# Privacy Policy — Finanzgame (English)

Last updated: 23 August 2026

**Short version: Finanzgame collects nothing.** No accounts, no sign-up, no
ads, no analytics, no cloud service. The app sends no data to the developer or
to third parties. Everything stays on your device.

Stored locally on the device: your game save (player name — a nickname is
fine — progress, in-game wealth, completed quests, trophies, settings); your
birth **year** only, if you choose to enter it (it may be skipped, and it only
controls whether the voluntary support section is shown); a parent PIN as a
SHA-256 hash if you set one; photos you pick for your wish list, copied into
the app's private folder; and any real-life savings goals you type in.

You can export a save file, a text report, or diagnostic files through your
phone's share menu — that only happens when you actively trigger it, and you
decide where it goes.

Permissions: storage to write and read your backup file in a folder you pick;
photos only when you choose a wish-list image. **The app does not request the
INTERNET permission at all**, so Android prevents it from opening any network
connection; the only way out is a link you deliberately tap, which opens your
browser.

The app does declare "**All files access**" (`MANAGE_EXTERNAL_STORAGE`). That
is a broad permission and you should know why it is there: it is the
**fallback path** for older installations. Since version 1.10.0+172 the
regular path is the system folder picker — you pick a folder once, and the app
may write there and nowhere else. If you use that path the permission stays
unused, and you can deny it in Android's settings without breaking backups. It
is meant to go away once the fallback is no longer needed.

**Your backup file is not encrypted.** On the old path it lands in
`Download/Finanzgame/`, where any app with file access can read it. It
contains your player name, your birth year (if you entered one) and the images
you picked for your wish list. Pick your own folder if that matters to you.

The app targets teenagers, which is exactly why it collects no personal data,
carries no ads or in-app purchases, and has no social features. It never asks
for gender, address, phone number, or email.

Uninstalling deletes all on-device data. A backup file you created yourself
stays where you put it and can be deleted like any other file.
