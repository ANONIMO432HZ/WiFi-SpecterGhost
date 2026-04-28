@echo off
title WiFi-SpecterGhost - Limpiador
setlocal enabledelayedexpansion

echo =========================================
echo    WiFi-SpecterGhost - LIMPIEZA
echo =========================================
echo.

set /p confirm="Estas seguro de que quieres borrar todos los logs? (S/N): "
if /i "%confirm%" neq "S" (
    echo.
    echo Operacion cancelada.
    pause
    exit /b
)

echo.
echo Limpiando archivos...

:: Borrar logs en la raiz
if exist wpsd.txt del /f /q wpsd.txt
if exist wpsd.*.txt del /f /q wpsd.*.txt

:: Borrar carpeta de logs
if exist logs (
    rd /s /q logs
    echo [+] Carpeta 'logs' eliminada.
)

echo.
echo [+] Limpieza completada con exito.
echo.
pause
