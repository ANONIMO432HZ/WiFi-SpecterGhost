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

exit