# Spec 11 — Privat-Release (signierte APK, Sideload)

## Goal

Versende der Vater-Sohn-App als **signierte Android-APK** zum manuellen
Installieren aufs Handy des Sohns. Kein Play-Store, keine Distribution
außerhalb der Familie.

## Why

App ist Feature-fertig. Sohn soll sie endlich aufm eigenen Gerät spielen
können, ohne Dev-Setup. Signed Release-APK + sideload reicht.

## Non-Goals

- Play-Store-Upload (Hardregel: privat)
- iOS-Build (Android-only Projekt)
- Auto-Update-Mechanismus
- Crashlytics / Analytics (Hardregel)
- Code-Obfuscation (kein wertvolles IP)

## Tasks

### 1. App-Identität

- `applicationId`: `com.adevelopd.finanzgame` (oder ähnlich, einmal
  setzen + nie ändern wegen sideload-Update)
- App-Name (Launcher): „Finanzgame"
- App-Icon: einfaches Pixel-Münzen-Icon (1024×1024 PNG, automatisch von
  Flutter zu mipmaps generiert via `flutter_launcher_icons` Dev-Dep)
- Splash: dunkler Hintergrund + Pixel-Münz-Logo, ebenfalls via
  `flutter_native_splash`

### 2. Versioning

`pubspec.yaml`:
```yaml
version: 1.0.0+1   # MAJOR.MINOR.PATCH+BUILD
```

Bei jedem neuen sideload: build-number hochzählen (sonst lehnt Android
„Install older version" ab).

### 3. Signing

Generiere lokalen Keystore (NICHT committen):
```bash
keytool -genkey -v -keystore ~/.finanzgame-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 36500 \
  -alias finanzgame -storepass <pw> -keypass <pw>
```

`android/key.properties` (gitignored):
```
storePassword=<pw>
keyPassword=<pw>
keyAlias=finanzgame
storeFile=/pfad/zu/deinem/finanzgame-keystore.jks
```

`android/app/build.gradle.kts`:
```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### 4. Manifest sanity

`android/app/src/main/AndroidManifest.xml`:
- App-Label = `@string/app_name` → strings.xml: „Finanzgame"
- Keine unnötigen Permissions. **Internet darf entfallen** (offline-
  first Hardregel). Check + remove `<uses-permission INTERNET>`.

### 5. Build

```bash
flutter build apk --release --split-per-abi
```

Generiert APKs unter `build/app/outputs/flutter-apk/`. Sideload-Pfad:
APK auf Sohn-Handy kopieren, antippen, „Unbekannte Quellen" zulassen.

### 6. Release-Checkliste (`docs/release-checklist.md`)

Markdown-Doc mit Schritten:
- [ ] `flutter test` grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Audio-Assets liegen in `assets/sfx/` + `assets/music/`
- [ ] m6x11.ttf in `assets/fonts/`, pubspec font-block ent-kommentiert
- [ ] Version + build hochgezählt in pubspec.yaml
- [ ] `flutter build apk --release --split-per-abi` läuft durch
- [ ] APK installiert + Tag-1-Loop spielbar (Schlafen → Day-Summary)

### 7. Smoke-Test-Doku

`docs/manual-smoke.md` — 10-Min-Pfad durch die App:
1. App starten → Springboard
2. Plant pflanzen (Monetaria → Spar-Insel)
3. Schlafen ×3 → Plant ready
4. Plant ernten → Cash steigt
5. ETF kaufen → Schlafen ×30 → verkaufen
6. Quest spielen → Reward erhalten
7. Wishlist Item kaufen → Cash sinkt
8. Aktie kaufen → Schlafen bis Crash → DaySummary mit Red-Flash + Drop
9. Zeitreise → Asset-Verlauf sichtbar
10. App killen → wieder öffnen → State weg (in-memory bis DB-Foundation)

## Acceptance

- [ ] applicationId final gesetzt
- [ ] App-Icon + Splash generiert
- [ ] Keystore-Doku + key.properties.template (Template committed,
       reale Werte gitignored)
- [ ] signingConfigs in build.gradle.kts
- [ ] INTERNET-Permission entfernt
- [ ] release-APK lokal gebaut (manuell — kein CI)
- [ ] release-checklist.md + manual-smoke.md committed
- [ ] Commit: `feat(release): private signed-APK release setup`

## Done When

`flutter build apk --release` produziert eine signierte APK. Sideload
auf Sohn-Handy installiert. Manueller Smoke-Test läuft durch ohne
Crash. App ist offline + ohne PII.
