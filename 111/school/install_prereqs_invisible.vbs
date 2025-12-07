' VBScript to launch install_prereqs.bat invisibly
"' Usage: cscript //nologo install_prereqs_invisible.vbs"
Option Explicit
Dim WshShell, fso, scriptPath, batchPath, cmd
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = fso.GetParentFolderName(WScript.ScriptFullName) & "\\"
batchPath = scriptPath & "install_prereqs.bat"

If Not fso.FileExists(batchPath) Then
    WshShell.Popup "Cannot find install_prereqs.bat in " & scriptPath, 5, "Installer launcher", 16
    WScript.Quit 1
End If

cmd = "cmd /c " & Chr(34) & batchPath & Chr(34)

' 0 = hidden window, False = don't wait

' Open a small status window (mshta) that displays install_status.html
Dim statusHtml
statusHtml = scriptPath & "install_status.html"
If fso.FileExists(statusHtml) Then
    Dim mshtaCmd
    mshtaCmd = "mshta.exe " & Chr(34) & statusHtml & Chr(34)
    ' 1 = normal window (so the user sees it); we don't wait for it
    WshShell.Run mshtaCmd, 1, False
End If

' Run the batch hidden
WshShell.Run cmd, 0, False

' Optional: notify the user briefly that installation started
WshShell.Popup "Installation started in background. A status window should be visible. If not, check the 'install_logs' folder next to this script.", 5, "Installation", 64

Set fso = Nothing
Set WshShell = Nothing
