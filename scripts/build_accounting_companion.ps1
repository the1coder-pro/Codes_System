$ErrorActionPreference = "Stop"

$appDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw "Flutter SDK is required to build the companion."
}

Push-Location $appDir
try {
    flutter pub get
    flutter build windows --release
    $output = Join-Path $appDir "build/windows/x64/runner/Release/accounting_ui.exe"
    Write-Host "`nUnified companion built for Windows:"
    Write-Host $output
}
finally {
    Pop-Location
}
