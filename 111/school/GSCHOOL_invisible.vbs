Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the script directory
scriptPath = WScript.ScriptFullName
scriptDir = fso.GetParentFolderName(scriptPath)

' Change to project directory
WshShell.CurrentDirectory = scriptDir

' Build commands — use full commands so they run like in batch
pyCmd = "py manage.py runserver 0.0.0.0:8000  "
npmCmd = "npm run school"

' Start Python server hidden
On Error Resume Next
WshShell.Run pyCmd, 0, False
' Start npm script hidden
WshShell.Run npmCmd, 0, False

' Optional: don't exit immediately to keep lifetime (but here we exit)
' WScript.Sleep 1000

Set WshShell = Nothing
Set fso = Nothing
