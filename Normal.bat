<# :
@echo off
:: WiFi-SpecterGhost [Normal Mode]
:: Este archivo es portable e independiente.
powershell -ExecutionPolicy Bypass -Command "iex (Get-Content '%~f0' -Raw)"
pause
exit /b
#>

# --- WiFi-SpecterGhost Engine [Embedded] ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$Silent = $false
$UseHiddenFolder = $false
$OutputName = "wpsd.txt"
$FolderName = "logs"

$scriptDirectory = $PSScriptRoot
if (-not $scriptDirectory) { $scriptDirectory = Get-Location }

# --- Configuracion de rutas y nombres ---
$targetFolder = $scriptDirectory

# Logica de incremento
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($OutputName)
$extension = [System.IO.Path]::GetExtension($OutputName)
$finalOutputName = $OutputName
$counter = 1

while (Test-Path (Join-Path -Path $targetFolder -ChildPath $finalOutputName)) {
    $finalOutputName = "$baseName.$counter$extension"
    $counter++
}

$outputFilePath = Join-Path -Path $targetFolder -ChildPath $finalOutputName

Write-Host "Iniciando escaneo de redes guardadas..." -ForegroundColor Cyan

# Obtener perfiles
$profilesOutput = (netsh wlan show profiles 2>$null)
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s*(?:Perfil de todos los usuarios|All User Profile)\s*:\s*(.+)$' }

if (-not $profileLines) {
    Write-Host "No se encontraron perfiles guardados." -ForegroundColor Yellow
} else {
    foreach ($line in $profileLines) {
        $profileName = ($line -split ':', 2)[1].Trim()
        $password = "[No encontrada]"

        try {
            $profileDetailOutput = (netsh wlan show profile name="$profileName" key=clear 2>$null)
            $keyLine = $profileDetailOutput | Where-Object { $_ -match '^\s*(?:Contenido de la clave|Key Content)\s*:\s*(.+)$' }

            if ($keyLine) {
                $password = ($keyLine -split ':', 2)[1].Trim()
            }
        } catch { continue }

        try {
            "SSID: $profileName" | Add-Content -Path $outputFilePath -Encoding UTF8
            "PWD: $password" | Add-Content -Path $outputFilePath -Encoding UTF8
            "-----------------------------------------" | Add-Content -Path $outputFilePath -Encoding UTF8
            Write-Host "SSID: $profileName | PWD: $password" -ForegroundColor Green
        } catch { }
    }
}

Write-Host "Archivo generado: $finalOutputName" -ForegroundColor Cyan
Write-Host "Ubicacion: $targetFolder" -ForegroundColor DarkCyan
Write-Host "Listo! El trabajo esta hecho." -ForegroundColor Cyan
