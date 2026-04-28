Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -ExecutionPolicy Bypass -File ""core\engine.ps1"" -Silent -UseHiddenFolder", 0, True
