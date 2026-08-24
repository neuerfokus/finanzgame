# Spec-43 v2: Install ohne Daten-Verlust.
#
# `flutter install` macht "Uninstalling old version..." → App-Daten weg.
# Diese Skript installiert via `adb install -r` (Replace) — wenn die
# vorherige Installation mit demselben Keystore signiert war, bleiben
# Drift-DB + Settings + Quests erhalten.
#
# Voraussetzung: android/key.properties + Keystore vorhanden.
# Sonst läuft flutter mit debug-Keystore (consistent pro Maschine).

# Geraete-ID: per -DeviceId setzen, per FINANZGAME_DEVICE_ID vorbelegen,
# sonst nimmt das Skript das einzige verbundene Geraet.
param(
    [string]$DeviceId = $env:FINANZGAME_DEVICE_ID
)

# Bevorzugt die versionierte Kopie — so landet garantiert derselbe Stand auf
# dem Geraet, der auch verschickt wird. Fallback auf app-release.apk, falls
# nur `flutter build apk` gelaufen ist.
$version = ((Select-String -Path "pubspec.yaml" -Pattern "^version:").Line `
        -replace '^version:\s*', '').Trim()
$dir = "build/app/outputs/flutter-apk"
$Apk = "$dir/Finanzgame-Version_$version.apk"
if (-not (Test-Path $Apk)) { $Apk = "$dir/app-release.apk" }

if (-not (Test-Path $Apk)) {
    Write-Host "ERROR: keine APK gefunden. Erst bauen: .\tools\release.ps1"
    exit 1
}
Write-Host "APK: $Apk"

# Find adb via ANDROID_HOME / SDK fallback.
$adb = $null
if ($env:ANDROID_HOME) {
    $candidate = Join-Path $env:ANDROID_HOME "platform-tools/adb.exe"
    if (Test-Path $candidate) { $adb = $candidate }
}
if (-not $adb) {
    $sdk = Join-Path $env:LOCALAPPDATA "Android/Sdk/platform-tools/adb.exe"
    if (Test-Path $sdk) { $adb = $sdk }
}
if (-not $adb) {
    Write-Host "ERROR: adb not found. Set ANDROID_HOME or install Android SDK."
    exit 1
}

if (-not $DeviceId) {
    $devices = @(& $adb devices | Select-String -Pattern '	device$' |
        ForEach-Object { ($_.Line -split '	')[0] })
    if ($devices.Count -eq 1) {
        $DeviceId = $devices[0]
    }
    elseif ($devices.Count -eq 0) {
        Write-Host "ERROR: kein Geraet verbunden. adb devices pruefen."
        exit 1
    }
    else {
        Write-Host "ERROR: mehrere Geraete verbunden ($($devices -join ', '))."
        Write-Host "       Mit -DeviceId <id> waehlen."
        exit 1
    }
}

Write-Host "Installing $Apk on $DeviceId via $adb install -r ..."
& $adb -s $DeviceId install -r $Apk
