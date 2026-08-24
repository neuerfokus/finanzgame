# Mitmachen

Finanzgame ist ein Familienprojekt, das öffentlich weiterläuft. Beiträge sind
willkommen — bitte vorher kurz ein Issue aufmachen, damit wir nicht
aneinander vorbeiarbeiten.

## Was in dieses Projekt passt

Die Grundregeln stehen fest und sind nicht verhandelbar:

- Keine echten Marken, keine echten Wertpapiere — alles im Spiel ist erfunden.
- Keine Lootboxen, keine Käufe im Spiel, keine Glücksspiel-Mechaniken.
- Kein Tracking, kein Analytics, keine Cloud-Anbindung, keine
  personenbezogenen Daten.
- Geschlechtsneutral: die App fragt nie nach dem Geschlecht, Figuren stehen
  gleichwertig nebeneinander, Titel benennen die Fähigkeit statt die Person.
- Anti-Konsum als Haltung, aber ohne erhobenen Zeigefinger.

Dauerhaft außerhalb: Cloud-Sync, Bestenlisten über das Netz, Mehrspieler,
Werbung, In-App-Käufe.

## Technisch

- Flutter 3.41 / Dart 3.11, Riverpod 3 mit Codegen, Freezed 3, Drift.
- **Geld immer in Cent als `int`**, nie als Fließkommazahl.
- **Kein Echtzeit-Tick in der Simulation.** Nur `GameClock.advanceDay()` löst
  Ereignisse aus, in fester Reihenfolge.
- Vor jedem Push: `flutter test` grün und `flutter analyze --fatal-infos` ohne
  Befund.
- Codegen nach Änderungen an Modellen oder Providern:
  `dart run build_runner build --delete-conflicting-outputs`.
- Commit-Format: `feat(bereich):`, `fix(bereich):`, `test(...)`, `docs:`,
  `build(android):`.

## Assets

Jedes neue Asset kommt mit Quelle, Lizenz und Datum in `ASSETS.md`. Ist es
attributionspflichtig (etwa CC-BY), gehört die Namensnennung zusätzlich in
`lib/features/settings/about_page.dart` — der Test dort hält das fest.
Bevorzugt CC0 oder eine mit GPL-3.0 verträgliche freie Lizenz; alles andere
wird vorher geklärt.

## Lizenz deiner Beiträge

Mit einem Pull Request stellst du deinen Beitrag unter dieselben Lizenzen wie
das Projekt: GPL-3.0-or-later für Quelltext, CC-BY-SA-4.0 für Inhalte.
