@ECHO off
REM Launch the invisible VBScript helper which starts the server and npm in hidden windows
REM The VBScript will run Python manage.py runserver and npm run school without visible terminals.
cscript //nologo "%~dp0\GSCHOOL_invisible.vbs"



