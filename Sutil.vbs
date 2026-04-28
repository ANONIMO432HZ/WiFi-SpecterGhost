Set WshShell = CreateObject("WScript.Shell")
' Ejecuta el motor de PowerShell de forma totalmente invisible (0)
WshShell.Run "powershell -ExecutionPolicy Bypass -File ""core\engine.ps1"" -Silent -UseHiddenFolder", 0, True
