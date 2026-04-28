Option Explicit

Dim objShell, strScriptPath, strBatchFilePath, objFSO

' Crear los objetos Shell y FileSystemObject
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject") ' Crear el objeto FileSystemObject

' Obtener la ruta del script VBS actual
strScriptPath = WScript.ScriptFullName

' Obtener la ruta de la carpeta del script VBS
strScriptPath = Left(strScriptPath, InStrRev(strScriptPath, "\") - 1)

' Construir la ruta completa al archivo .bat (ahora se busca "WIFIV3.0.bat")
strBatchFilePath = strScriptPath & "\WIFIV3.0.bat"  ' ¡Nombre del archivo .bat actualizado!

' Verificar si el archivo .bat existe
If objFSO.FileExists(strBatchFilePath) Then ' Usar el método FileExists del objeto FileSystemObject
    ' Ejecutar el archivo .bat, ocultando la ventana
    objShell.Run """" & strBatchFilePath & """", 0, True ' El 0 oculta la ventana, 1 la minimiza, 2 la maximiza
Else
    ' Mostrar un mensaje de error si no se encuentra el archivo .bat
    MsgBox "No se encontró el archivo: " & strBatchFilePath, vbCritical, "Error"
End If

' Limpiar los objetos
Set objShell = Nothing
Set objFSO = Nothing ' Liberar el objeto FileSystemObject
