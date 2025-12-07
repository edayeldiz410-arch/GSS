@echo off
echo Installation de Python...
start /wait "" "%~dp0python-3.13.7-amd64.exe" /quiet InstallAllUsers=1 PrependPath=1

echo Installation de Node.js...
start /wait "" msiexec /i "%~dp0node-v22.19.0-x64.msi" /quiet /norestart

echo Installation terminée.
pause
