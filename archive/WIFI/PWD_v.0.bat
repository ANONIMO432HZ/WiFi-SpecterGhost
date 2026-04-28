@echo off
echo Recopilando contraseñas WiFi guardadas...
netsh wlan show profiles | findstr /C:"Perfil de todos los usuarios" > wifi_profiles.txt

echo Procesando perfiles y extrayendo contraseñas...
echo ----------------------------------------- > wifi_passwords.txt
for /F "tokens=2 delims=:" %%a in (wifi_profiles.txt) do (
    set "profile=%%a"
    setlocal enabledelayedexpansion
    echo SSID: !profile:~1! >> wifi_passwords.txt
    netsh wlan show profile name="!profile:~1!" key=clear | findstr /C:"Contenido de la clave" >> temp_password.txt
    for /F "tokens=2 delims=:" %%b in (temp_password.txt) do (
        echo Contraseña: %%b >> wifi_passwords.txt
    )
    del temp_password.txt
    echo ----------------------------------------- >> wifi_passwords.txt
    endlocal
)

del wifi_profiles.txt

echo Contraseñas WiFi guardadas en el archivo "wifi_passwords.txt" en esta misma carpeta.
pause