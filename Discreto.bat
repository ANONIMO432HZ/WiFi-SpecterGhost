@echo off
powershell -ExecutionPolicy Bypass -File "core\engine.ps1" -UseHiddenFolder
echo Proceso completado. Los resultados estan en la carpeta 'invisible'.
pause
