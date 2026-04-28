@echo off
:: Ejecuta el motor en modo silencio y con la ventana minimizada
powershell -ExecutionPolicy Bypass -WindowStyle Minimized -File "core\engine.ps1" -Silent -UseHiddenFolder
