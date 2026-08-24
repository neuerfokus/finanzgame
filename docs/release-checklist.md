# Release-Checklist

Zwei Wege, die sich nicht mischen lassen:

1. **Signiertes APK zum Sideload** (der bisherige Weg, unten beschrieben) —
   signiert mit dem eigenen Keystore, Updates behalten die Spielstände.
2. **Öffentliche Veröffentlichung** über GitHub und F-Droid — siehe
   `docs/specs/spec-46-oss-release.md` und `docs/fdroid-metadata.yml`.

**Achtung, die beiden Signaturen sind unvereinbar.** F-Droid signiert mit
seinem eigenen Schlüssel. Eine F-Droid-Installation lässt sich nicht über
eine bestehende Sideload-Installation drüberinstallieren und umgekehrt — wer
wechselt, exportiert vorher den Spielstand und importiert ihn danach.

Der Play Store ist bewusst noch nicht vorbereitet: `MANAGE_EXTERNAL_STORAGE`
ist dort für ein Lernspiel policy-widrig, Privatkonten brauchen zwölf Tester
über vierzehn Tage, und der Klarname stünde im Eintrag. Das braucht eine
eigene Spec.

## Vor einer öffentlichen Veröffentlichung

- [ ] `python tools/license_check.py` ohne Unknown/Orphaned
- [ ] Attributionspflichtige Assets stehen in `about_page.dart`
      (`test/features/settings/about_page_test.dart` prüft das)
- [ ] `fastlane/metadata/android/*/changelogs/<versionCode>.txt` angelegt —
      Dateiname ist der versionCode, nicht der Versionsname
- [ ] `.\tools\prepare_public_repo.ps1` läuft ohne Fund durch

## Private signierte APK

## Pre-flight

- [ ] `flutter test` grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] `flutter pub get` läuft ohne neue Warnings
- [ ] m6x11.ttf in `assets/fonts/`, font-Block in `pubspec.yaml`
      ent-kommentiert
- [ ] Audio-Assets liegen vollständig:
  - [ ] `assets/sfx/coin.wav`
  - [ ] `assets/sfx/harvest.wav`
  - [ ] `assets/sfx/sleep_chime.wav`
  - [ ] `assets/sfx/crash_rumble.wav`
  - [ ] `assets/sfx/ui_tap.wav`
  - [ ] `assets/music/monetaria_loop.ogg`
- [ ] App-Icon-Generierung (falls `flutter_launcher_icons` genutzt) lief

## Keystore (einmalig)

Generiere lokal — niemals committen:

```
keytool -genkey -v ^
  -keystore C:/Pfad/zu/deinem/finanzgame-keystore.jks ^
  -keyalg RSA -keysize 2048 -validity 36500 ^
  -alias finanzgame ^
  -storepass <pw> -keypass <pw>
```

Dann `android/key.properties.template` → `android/key.properties`
kopieren und mit echten Werten füllen. `.gitignore` schützt vor
versehentlichem Commit.

**Keystore-Verlust = App nie wieder updatebar.** Backup ans Drive
kopieren.

## Version-Bump

Vor jedem neuen Sideload `pubspec.yaml` `version:`-Zeile inkrementieren:

- `1.0.0+1` → `1.0.0+2` (Build-Nummer einzig nötig für Update)
- `1.0.0+5` → `1.0.1+6` (Bugfix-Release)
- `1.0.x+y` → `1.1.0+z` (Feature-Release)

Android lehnt „Install older version" sonst ab.

## Build

```
flutter build apk --release --split-per-abi
```

Erzeugt unter `build/app/outputs/flutter-apk/`:
- `app-armeabi-v7a-release.apk` — alte 32-bit-Phones
- `app-arm64-v8a-release.apk` — moderne 64-bit-Phones (üblicher Fall)
- `app-x86_64-release.apk` — Emulator

Üblich: `arm64-v8a` Datei.

## Sideload aufs Sohn-Handy

1. APK via USB / OneDrive / Mail aufs Gerät
2. Auf Gerät antippen → „Unbekannte Quellen" zulassen
3. Installieren

## Post-install Smoke

Siehe `docs/manual-smoke.md` (10-Min-Pfad).

## Rollback

Bei kaputtem Release:
- Vorherige APK reinstallieren (in `build/`-Output behalten)
- ODER: previous build-tag in git auschecken + neu bauen mit höherem
  build-counter

## Wichtige Hardregeln (vor Versand prüfen)

- Keine echten Marken im Spiel-Content
- Kein Internet-Permission im Release-Manifest (verifizieren mit
  `aapt dump permissions build/.../app-*.apk`)
- Keine Crashlytics / Analytics / PII
- App startet offline
