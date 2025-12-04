; Inno Setup script to package the Genieschool2 project and run the PowerShell bootstrapper after installation
; Save this as install_gschool.iss and compile with Inno Setup (ISCC.exe)

#define MyAppName "GSCHOOL"
#define MyAppVersion "1.0"
#define MyAppPublisher "GenieSchool"
#define MyAppExeName "GSCHOOL.bat"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
Compression=lzma2
SolidCompression=yes
OutputBaseFilename=install_gschool
DisableStartupPrompt=yes
PrivilegesRequired=admin

; Files: include the whole project directory contents. When compiling, run ISCC from the repository root
[Files]
; Copy everything recursively from the current working directory into the install dir
Source: "{#src}\*"; Flags: recursesubdirs createallsubdirs ignoreversion; DestDir: "{app}"; 

; Ensure the PowerShell bootstrapper is executable and will be placed in the install dir
; The script is expected to be at the project root (install_gschool.ps1)
; No special flags needed since it's a text file; it will be installed together with the project

[Icons]
; Start Menu shortcut to launch the bundled GSCHOOL.bat (uses cmd to start minimized)
Name: "{group}\{#MyAppName}"; Filename: "{cmd}"; Parameters: "/c start /min \"%PROGRAMFILES%\{#MyAppName}\school\{#MyAppExeName}\""; WorkingDir: "{app}\school"; IconFilename: "{app}\school\favicon.ico"; 

[Run]
; After install, run the PowerShell bootstrapper to set up Python/Node and start the app
Filename: "{win}\system32\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File \"{app}\install_gschool.ps1\" -ProjectPath \"{app}\""; StatusMsg: "Running bootstrap installer to configure prerequisites..."; Flags: runascurrentuser waituntilterminated

[UninstallRun]
; Optionally run an uninstall script or cleanup
; Filename: "{app}\uninstall_cleanup.bat"; Parameters: ""; Flags: runhidden

; Define the src path at compilation time; recommend compiling with:
; ISCC.exe /Dsrc="C:\path\to\Genieschool2" install_gschool.iss
; or run from the project root and use /Dsrc="." to pick up the current folder

; If you prefer to compile on the machine where the source is located, run:
; ISCC.exe install_gschool.iss

; Notes:
; - Inno Setup's installer will request elevation to copy files to Program Files and to run the post-install PowerShell script.
; - The post-install call runs PowerShell as the current (elevated) user so the bootstrapper can install system packages.
; - If you want the post-install script to run without elevation, remove 'runascurrentuser' flag and use 'runasoriginaluser'.

