# Finanzgame

Ein Lernspiel über Geld für Jugendliche ab etwa 13 Jahren. Taschengeld
einteilen, sparen, anlegen, abwarten — und sehen, was daraus wird. Flutter +
Flame, Android, komplett offline.

Entstanden als Vater-Kind-Projekt und über viele Testrunden mit echten
Jugendlichen gewachsen.

> **Das ist eine Simulation, keine Anlageberatung.** Alle Kurse, Firmen,
> Renditen und Preise im Spiel sind erfunden. Echtes Geld verhält sich anders.

## Was es kann

- **Tageszyklus statt Echtzeit.** Es passiert nichts, während das Handy in der
  Tasche liegt. Ein Tag endet, wenn man auf „Schlafen" tippt — dann werden
  Erträge, Kosten und Ereignisse gesammelt und in einer Tageszusammenfassung
  gezeigt.
- **Elf Anlageklassen** mit unterschiedlichem Charakter: Sparkonto, ETFs,
  Einzelaktien, Krypto, Edelmetalle, Immobilien, Vorsorge, Sammlerobjekte,
  Bäume — jede auf einer eigenen Insel.
- **Lerninhalte im Spiel**, nicht daneben: über 60 Story-Quests (Abo-Falle,
  Phishing, Gruppenzwang, Ratenkauf, Freistellungsauftrag …), Tagesfrage,
  Wissens-Quiz, Glossar als Lern-Tagebuch.
- **Zeitreise**: Jahre vorspulen und den eigenen Vermögensverlauf über alle
  Anlageklassen ansehen.
- **Brücke ins echte Leben**: echte Sparziele eintragen, von einem Elternteil
  bestätigen lassen, dafür im Spiel belohnt werden.

## Haltung

- Keine echten Marken, keine echten Aktien — alles fiktiv.
- Keine Lootboxen, keine Mikrotransaktionen, keine Glücksspiel-Mechaniken.
- Kein Tracking, kein Analytics, keine Cloud. Die App sendet nichts.
- Anti-Konsum als Haltung, ohne Moralkeule: Konsumieren ist spielbar und zeigt
  seine Folgen.
- Geschlechtsneutral, ohne Abfrage. Weibliche und männliche Figuren stehen
  gleichwertig und zu denselben Kosten nebeneinander; Titel benennen die
  Fähigkeit, nicht die Person.

## Datenschutz

Alles bleibt auf dem Gerät. Kein Konto, keine Registrierung, keine
personenbezogenen Daten.

Und das ist nicht nur ein Versprechen: **das fertige APK fragt die
INTERNET-Berechtigung gar nicht erst an.** Android lässt die App damit keine
Netzwerkverbindung aufbauen, selbst wenn irgendwo Code das versuchen würde.
Nachprüfbar am gebauten Paket:

```bash
aapt dump permissions build/app/outputs/flutter-apk/app-release.apk
```

Details: [PRIVACY.md](PRIVACY.md).

## Bauen

Flutter 3.41 / Dart 3.11.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze --fatal-infos
flutter build apk --release
```

Ohne `android/key.properties` wird mit dem Debug-Keystore signiert — zum
Entwickeln genau richtig.

## Lizenz

- **Quelltext**: [GPL-3.0-or-later](LICENSE)
- **Eigene Inhalte** (Quests, Glossar, App-Icon): CC-BY-SA-4.0
- **Kenney-Assets** (Grafik, Fonts, Sound, Musik): CC0
- **Twemoji** (Möbel-Symbole): CC-BY-4.0, © Twitter, Inc. und Mitwirkende

Pro Datei nachgehalten in [ASSETS.md](ASSETS.md), Lizenztexte unter
`LICENSES/`. Die App zeigt die Namensnennungen unter *Einstellungen → Über &
Lizenzen*.

## Mitmachen

Siehe [CONTRIBUTING.md](CONTRIBUTING.md). Fehler und Ideen gern als Issue.

## Kontakt

sepp.github@gmail.com · [github.com/neuerfokus/finanzgame](https://github.com/neuerfokus/finanzgame)
