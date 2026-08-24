# Spec-43 v5: erhöht versionCode + optional versionName in pubspec.yaml.
#
# Usage:
#   .\tools\bump_version.ps1            → +1 auf versionCode
#   .\tools\bump_version.ps1 -Minor     → versionName 1.10.0 → 1.11.0

param([switch]$Minor)

$file = "pubspec.yaml"
$lines = Get-Content $file
$out = @()
foreach ($l in $lines) {
    if ($l -match "^version:\s+(\d+)\.(\d+)\.(\d+)\+(\d+)") {
        $maj = [int]$Matches[1]
        $min = [int]$Matches[2]
        $pat = [int]$Matches[3]
        $code = [int]$Matches[4] + 1
        if ($Minor) { $min++; $pat = 0 }
        $new = "version: $maj.$min.$pat+$code"
        Write-Host "Old: $l"
        Write-Host "New: $new"
        $out += $new
    } else {
        $out += $l
    }
}
$out | Set-Content $file -Encoding UTF8
Write-Host "Done — commit + build + WhatsApp-Versand."
