Set objFSO = CreateObject("Scripting.FileSystemObject")
Set WshShell = CreateObject("WScript.Shell")

strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
strEnginePath = objFSO.BuildPath(strScriptPath, "core\engine.ps1")

' Fallback: si no existe la carpeta core, busca el motor en la misma carpeta
If Not objFSO.FileExists(strEnginePath) Then
    strEnginePath = objFSO.BuildPath(strScriptPath, "engine.ps1")
End If

' Ejecuta el motor de forma invisible si se encontro el archivo
If objFSO.FileExists(strEnginePath) Then
    WshShell.Run "powershell -ExecutionPolicy Bypass -File """ & strEnginePath & """ -Silent -UseHiddenFolder", 0, True
Else
    MsgBox "No se encontro el motor del script (engine.ps1)", 16, "WiFi-SpecterGhost Error"
End If
