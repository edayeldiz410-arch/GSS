@echo off
:: install_prereqs.bat
:: Installs Python and Node from local installers (if missing) and runs pip/npm installs.
:: Logs are written to %~dp0install_logs\

setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set LOG_DIR=%SCRIPT_DIR%install_logs
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set LOG=%LOG_DIR%\install_prereqs-%DATE:~-4,4%-%DATE:~3,2%-%DATE:~0,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%.log

set STATUS_FILE=%SCRIPT_DIR%install_status.txt
echo Initializing installer... > "%STATUS_FILE%"

REM Normalize log filename by removing illegal chars (replace : with -)
set LOG=%LOG::=-%

REM Normalize log filename by removing illegal chars (replace : with -)
set LOG=%LOG::=-%

echo Starting installer at %DATE% %TIME% > "%LOG%"
echo Starting installer at %DATE% %TIME% > "%STATUS_FILE%"

:: Require administrative privileges for system-wide installs
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges... >> "%LOG%"
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs" >> "%LOG%" 2>&1
    exit /b
)

echo Running as admin, continuing... >> "%LOG%"

:: Helper: log and echo
echo. >> "%LOG%"
echo ---------- ENV --------- >> "%LOG%"
set PATH >> "%LOG%"
echo ------------------------- >> "%LOG%"

:: 1) Install Python if not present
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found in PATH. Attempting to install from local installer... >> "%LOG%"
    echo Checking Python installer... >> "%STATUS_FILE%"
    if exist "%SCRIPT_DIR%python-3.13.7-amd64.exe" (
    echo Found python-3.13.7-amd64.exe, running silent install... >> "%LOG%"
    echo Installing Python... >> "%STATUS_FILE%"
    "%SCRIPT_DIR%python-3.13.7-amd64.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1 >> "%LOG%" 2>&1
        if %errorlevel% equ 0 (
            echo Python installer exited with code 0 >> "%LOG%"
        ) else (
            echo WARNING: Python installer returned error code %errorlevel% >> "%LOG%"
        )
    ) else (
        echo No local Python installer (python-3.13.7-amd64.exe) found in %SCRIPT_DIR% >> "%LOG%"
    )
) else (
    echo Python already in PATH, skipping installer. >> "%LOG%"
)

:: 2) Install Node.js if not present
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js not found in PATH. Attempting to install from local MSI... >> "%LOG%"
    echo Checking Node installer... >> "%STATUS_FILE%"
    if exist "%SCRIPT_DIR%node-v22.19.0-x64.msi" (
    echo Found node-v22.19.0-x64.msi, running msiexec silent install... >> "%LOG%"
    echo Installing Node.js... >> "%STATUS_FILE%"
    msiexec /i "%SCRIPT_DIR%node-v22.19.0-x64.msi" /qn /norestart >> "%LOG%" 2>&1
        if %errorlevel% equ 0 (
            echo Node MSI installer exited with code 0 >> "%LOG%"
        ) else (
            echo WARNING: Node MSI installer returned error code %errorlevel% >> "%LOG%"
        )
    ) else (
        echo No local Node installer (node-v22.19.0-x64.msi) found in %SCRIPT_DIR% >> "%LOG%"
    )
) else (
    echo Node.js already in PATH, skipping installer. >> "%LOG%"
)

:: Refresh environment for this script: try to use the Python launcher (py) first
echo Attempting to upgrade pip and install Python packages... >> "%LOG%"
echo Upgrading pip and installing Python packages... >> "%STATUS_FILE%"

set PY_CMD=
py -3 -V >nul 2>&1
if %errorlevel% equ 0 (
    set PY_CMD=py -3
) else (
    where python >nul 2>&1
    if %errorlevel% equ 0 (
        set PY_CMD=python
    ) else (
        set PY_CMD=
    )
)

if "%PY_CMD%"=="" (
    echo ERROR: No Python executable available after attempted install. Check the log at %LOG% >> "%LOG%"
    echo No Python found. Please install Python manually or check the installer log: %LOG% >> "%STATUS_FILE%"
    exit /b 1
) else (
    echo Using %PY_CMD% for pip operations >> "%LOG%"
    echo Using %PY_CMD% for pip operations >> "%STATUS_FILE%"
)

:: Upgrade pip
%PY_CMD% -m pip install --upgrade pip >> "%LOG%" 2>&1
if %errorlevel% neq 0 (
    echo WARNING: pip upgrade failed (code %errorlevel%). Continuing... >> "%LOG%"
)

:: Install Django and mysqlclient
echo Installing Django... >> "%STATUS_FILE%"
%PY_CMD% -m pip install django >> "%LOG%" 2>&1
if %errorlevel% equ 0 (
    echo django installed successfully >> "%LOG%"
    echo Django installed successfully. >> "%STATUS_FILE%"
) else (
    echo WARNING: Failed to install django (code %errorlevel%) >> "%LOG%"
    echo WARNING: Failed to install django. See log. >> "%STATUS_FILE%"
)

echo Installing mysqlclient... >> "%STATUS_FILE%"
%PY_CMD% -m pip install mysqlclient >> "%LOG%" 2>&1
if %errorlevel% equ 0 (
    echo mysqlclient installed successfully >> "%LOG%"
    echo mysqlclient installed successfully. >> "%STATUS_FILE%"
) else (
    echo WARNING: Failed to install mysqlclient (code %errorlevel%). On Windows this often requires the Visual C++ Build Tools. See https://pypi.org/project/mysqlclient/ >> "%LOG%"
    echo WARNING: Failed to install mysqlclient. See log for details. >> "%STATUS_FILE%"
)

:: 3) Install Electron via npm (global install)
echo Attempting npm-based installs... >> "%LOG%"
echo Attempting npm-based installs... >> "%STATUS_FILE%"
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo npm not found in PATH. Cannot install electron. >> "%LOG%"
) else (
    echo Running npm install -g electron >> "%LOG%"
    echo Installing electron (npm global)... >> "%STATUS_FILE%"
    npm install -g electron --no-progress >> "%LOG%" 2>&1
    if %errorlevel% equ 0 (
        echo electron (global) installed successfully >> "%LOG%"
        echo electron installed successfully. >> "%STATUS_FILE%"
    ) else (
        echo WARNING: npm install -g electron failed with code %errorlevel% >> "%LOG%"
        echo WARNING: npm install -g electron failed. See log. >> "%STATUS_FILE%"
    )
    
    REM Optionally run local npm install if an electron package.json exists
    if exist "%SCRIPT_DIR%..\electron\package.json" (
        echo Running local npm install in electron folder... >> "%LOG%"
        echo Running local npm install... >> "%STATUS_FILE%"
        pushd "%SCRIPT_DIR%..\electron" >nul 2>&1
        npm install --no-progress >> "%LOG%" 2>&1
        if %errorlevel% equ 0 (
            echo local npm install succeeded >> "%LOG%"
            echo Local npm install finished. >> "%STATUS_FILE%"
        ) else (
            echo WARNING: local npm install failed with code %errorlevel% >> "%LOG%"
            echo WARNING: local npm install failed. See log. >> "%STATUS_FILE%"
        )
        popd >nul 2>&1
    )
)

echo Installation finished at %DATE% %TIME% >> "%LOG%"
echo Installation finished at %DATE% %TIME% >> "%STATUS_FILE%"
echo Logs saved to %LOG% >> "%STATUS_FILE%"
echo.
echo Done. You can review the log at:
echo %LOG%

REM leave the final status visible for a while
echo Completed. >> "%STATUS_FILE%"

endlocal

pause
