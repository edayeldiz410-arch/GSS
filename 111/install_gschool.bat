@ECHO OFF
REM Simple bootstrap installer (batch) for Windows
REM This script attempts to install Python and Node.js via winget if available,
REM then runs pip install django, pip install mysqlclient and npm install electron.

SETLOCAL ENABLEDELAYEDEXPANSION

n:: Helper to check command existence
where /Q winget
IF %ERRORLEVEL%==0 (
    SET HAVE_WINGET=1
) ELSE (
    SET HAVE_WINGET=0
)

necho HAVE_WINGET=%HAVE_WINGET%

nIF %HAVE_WINGET%==1 (
    echo Installing Python 3 via winget...
    winget install --id Python.Python.3 -e --accept-package-agreements --accept-source-agreements
    if %ERRORLEVEL% NEQ 0 echo WARNING: winget failed to install Python - please install it manually.

    echo Installing Node.js LTS via winget...
    winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements
    if %ERRORLEVEL% NEQ 0 echo WARNING: winget failed to install Node.js - please install it manually.
) ELSE (
    echo winget not found. Please install Python and Node.js manually or install winget.
    echo Download Python: https://www.python.org/downloads/
    echo Download Node.js LTS: https://nodejs.org/
)

necho Updating PATH for current session...
CALL SET "PATH=%PATH%"

n:: Ensure pip and npm exist
nwhere /Q py
IF %ERRORLEVEL%==0 (
    SET PYCMD=py -3
) ELSE (
    where /Q python
    IF %ERRORLEVEL%==0 (
        SET PYCMD=python
    ) ELSE (
        echo Python not found in PATH. Installer will continue but pip commands will fail.
        SET PYCMD=
    )
)

nwhere /Q npm
IF %ERRORLEVEL% NEQ 0 (
    echo npm not found in PATH. npm install will fail.
)

necho Installing Python packages...
IF DEFINED PYCMD (
    %PYCMD% -m pip install --upgrade pip setuptools wheel
    %PYCMD% -m pip install django
    echo Attempting to pip install mysqlclient (may require Visual C++ Build Tools)...
    %PYCMD% -m pip install mysqlclient
) ELSE (
    echo Skipping pip installs because Python was not found.
)

necho Running npm install for Electron (in school folder)...
IF EXIST "school\package.json" (
    pushd school
    IF EXIST package-lock.json (
        npm ci
    ) ELSE (
        npm install
    )
    popd
) ELSE (
    echo school\package.json not found. Skipping npm install.
)

necho Done. You can now run school\GSCHOOL.bat to start the app.
ENDLOCAL
PAUSE
