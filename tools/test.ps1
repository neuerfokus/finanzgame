<#
.SYNOPSIS
  Stabiler Test-Runner. Deckelt die Test-Concurrency, damit `flutter test`
  unter Speicher-/Thread-Druck nicht mit „Could not start thread
  DartWorker: 22" (Windows-Thread-Exhaustion) oder einem JIT-CFG-Dump
  abbricht.

.DESCRIPTION
  Default-`flutter test` startet ein Test-Isolate pro CPU-Kern. Auf dieser
  Maschine überlastet das den Thread-Pool und der VM-Worker-Spawn schlägt
  fehl (der eigentliche Test-Code ist in Ordnung — Subsets laufen grün).
  Eine feste, moderate Concurrency vermeidet das zuverlässig.

.PARAMETER Jobs
  Anzahl paralleler Test-Isolates. Default 4 (stabil auf dieser Maschine).

.PARAMETER Args
  Alles Weitere wird an `flutter test` durchgereicht (z.B. ein Pfad,
  --update-goldens, --name ...).

.EXAMPLE
  .\tools\test.ps1
  .\tools\test.ps1 -Jobs 2
  .\tools\test.ps1 test/features/newgame
  .\tools\test.ps1 --update-goldens test/ui/widgets/pixel_widgets_golden_test.dart
#>
param(
  [int]$Jobs = 4,
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$ErrorActionPreference = 'Stop'
Write-Host "==> flutter test --concurrency=$Jobs $($Args -join ' ')" -ForegroundColor Cyan
& flutter test --concurrency=$Jobs @Args
exit $LASTEXITCODE
