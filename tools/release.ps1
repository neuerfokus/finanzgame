# Spec-43 v5: ein-Befehl-Release-Pipeline.
#
# Erhöht versionCode, baut Release-APK, zeigt finalen Pfad.
# Optional: -Minor erhöht auch versionName-Minor.
#
# Usage:
#   .\tools\release.ps1
#   .\tools\release.ps1 -Minor
#
# Ergebnis: build\app\outputs\flutter-apk\Finanzgame-Version_1.10.0+184.apk
# → diese Datei per WhatsApp/E-Mail/Drive verschicken.
#
# Warum die Kopie: Flutter schreibt IMMER nach app-release.apk, jeder Build
# überschreibt den vorigen. Beim Verschicken sieht man der Datei dann nicht
# an, welcher Stand drin ist. Das Skript legt die Kopie mit Version im Namen
# gleich mit an (dieselbe Benennung, die vorher von Hand gemacht wurde).
#
# ACHTUNG: der Ordner liegt unter build\ — `flutter clean` loescht damit auch
# das APK-Archiv. Wer Staende dauerhaft aufheben will, kopiert sie woanders hin.

param([switch]$Minor)

Write-Host "==> Bump versionCode..."
& "$PSScriptRoot\bump_version.ps1" -Minor:$Minor

Write-Host ""
Write-Host "==> Build Release-APK..."
flutter build apk --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    exit 1
}

$apk = Resolve-Path "build\app\outputs\flutter-apk\app-release.apk"
$mb = [math]::Round((Get-Item $apk).Length / 1MB, 1)
$version = (Select-String -Path "pubspec.yaml" -Pattern "^version:").Line

# "version: 1.10.0+184" -> "1.10.0+184"
$raw = ($version -replace '^version:\s*', '').Trim()
$dir = Split-Path $apk -Parent
$target = Join-Path $dir "Finanzgame-Version_$raw.apk"
Copy-Item $apk $target -Force

Write-Host ""
Write-Host "===========================================" -ForegroundColor Green
Write-Host "DONE — $version ($mb MB)" -ForegroundColor Green
Write-Host "ZUM VERSCHICKEN: $target" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Nächste Schritte:"
Write-Host "  1. Diese Datei per WhatsApp/Drive verschicken"
Write-Host "     (Version steht im Dateinamen)"
Write-Host "  2. Aufs Geraet: .\tools\install_keep_data.ps1 -DeviceId <id>"
Write-Host "  3. git commit/push wenn gewollt"
Write-Host ""
Write-Host "Bisherige Staende:"
Get-ChildItem $dir -Filter "Finanzgame-Version_*.apk" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 5 |
    ForEach-Object {
        Write-Host ("  {0}  {1:dd.MM.yyyy HH:mm}" -f $_.Name, $_.LastWriteTime)
    }
