<#
install_gschool.ps1

Bootstrap installer for Windows that attempts to install prerequisites needed to run `school\GSCHOOL.bat`:
- Python 3 (via winget or Chocolatey)
- Node.js (via winget or Chocolatey)
- pip packages from `requirements.txt` (Django, reportlab, mysqlclient)
- npm packages (runs `npm install` in the `school` folder)

Usage:
  Right-click -> Run with PowerShell (run as Admin), or run from an elevated PowerShell prompt.
  ./install_gschool.ps1 -ProjectPath C:\path\to\Genieschool2

Notes / caveats:
- Installing `mysqlclient` via pip on Windows often requires Visual C++ Build Tools and the MySQL client libraries (MySQL Connector/C or MySQL Server dev files). The script will attempt a pip install and, on failure, will show guidance.
- The script prefers `winget` if available, falls back to Chocolatey (and offers to install it if missing).
- This script tries to be helpful but cannot guarantee every Windows environment has required build toolchains.
#>

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [string]$ProjectPath = $(Split-Path -Parent $MyInvocation.MyCommand.Path),

    [switch]$SkipChocolateyInstall,

    [switch]$VerboseMode
)

if ($VerboseMode) { $VerbosePreference = 'Continue' }

function Write-Info($msg){ Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg){ Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg){ Write-Host "[ERROR] $msg" -ForegroundColor Red }

function Test-IsAdmin {
    $current = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Relaunch script as admin if required
if (-not (Test-IsAdmin)) {
    Write-Host "This script needs to run as Administrator. Attempting to relaunch elevated..."
    $argsEscaped = $MyInvocation.UnboundArguments | ForEach-Object { "`"$_`"" } | Join-String ' '
    Start-Process -FilePath pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $argsEscaped" -Verb RunAs
    exit
}

if (-not (Test-Path $ProjectPath)) {
    Write-Err "Project path '$ProjectPath' does not exist. Please provide the folder that contains the project."
    exit 1
}

$SchoolBat = Join-Path $ProjectPath "school\GSCHOOL.bat"
$Requirements = Join-Path $ProjectPath "requirements.txt"
$SchoolDir = Join-Path $ProjectPath "school"

if (-not (Test-Path $SchoolBat)) {
    Write-Err "Could not find 'school\\GSCHOOL.bat' under $ProjectPath. Aborting."
    exit 1
}

Write-Info "Using project path: $ProjectPath"

function Command-Exists([string]$cmd){
    return (Get-Command $cmd -ErrorAction SilentlyContinue) -ne $null
}

# Try winget first
$useWinget = $false
if (Command-Exists winget) { $useWinget = $true; Write-Info "winget found and will be used for installing system packages." }

function Install-WithWinget($id, $friendly){
    Write-Info "Installing $friendly via winget (id: $id)"
    & winget install --id $id -e --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { Write-Warn "winget failed to install $friendly (id: $id). ExitCode=$LASTEXITCODE"; return $false }
    return $true
}

function Ensure-Choco {
    if (Command-Exists choco) { Write-Info "Chocolatey already installed."; return $true }
    if ($SkipChocolateyInstall) { Write-Warn "Chocolatey not present and SkipChocolateyInstall specified. Cannot proceed with Chocolatey fallback."; return $false }
    Write-Info "Chocolatey not found. Installing Chocolatey (requires internet and administrative rights)."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    $chocoInstall = 'https://community.chocolatey.org/install.ps1'
    try {
        iex ((New-Object System.Net.WebClient).DownloadString($chocoInstall))
    } catch {
        Write-Err "Failed to download or run Chocolatey install script: $_"
        return $false
    }
    return (Command-Exists choco)
}

# Install Python
$pythonInstalled = Command-Exists py -or Command-Exists python
if (-not $pythonInstalled) {
    if ($useWinget) {
        if (-not (Install-WithWinget 'Python.Python.3' 'Python 3')) {
            Write-Warn "winget failed to install Python. Trying Chocolatey..."
            if (-not (Ensure-Choco)) { Write-Err "No package manager available to install Python."; exit 1 }
            choco install python -y
        }
    } else {
        if (-not (Ensure-Choco)) { Write-Err "No package manager available to install Python."; exit 1 }
        choco install python -y
    }
} else { Write-Info "Python appears to be installed." }

# Install Node.js
$nodeInstalled = Command-Exists node
if (-not $nodeInstalled) {
    if ($useWinget) {
        if (-not (Install-WithWinget 'OpenJS.NodeJS.LTS' 'Node.js LTS')) {
            Write-Warn "winget failed to install Node.js. Trying Chocolatey..."
            if (-not (Ensure-Choco)) { Write-Err "No package manager available to install Node.js."; exit 1 }
            choco install nodejs-lts -y
        }
    } else {
        if (-not (Ensure-Choco)) { Write-Err "No package manager available to install Node.js."; exit 1 }
        choco install nodejs-lts -y
    }
} else { Write-Info "Node.js appears to be installed." }

# Refresh environment variables for current session (node/python availability)
$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')

# Ensure pip is available
function Run-Python([string]$args){
    if (Command-Exists py) { & py -3 $args } else { & python $args }
}

Write-Info "Upgrading pip, setuptools and wheel..."
try {
    Run-Python "-m pip install --upgrade pip setuptools wheel"
} catch {
    Write-Warn "Could not upgrade pip: $_"
}

# Install pip requirements if requirements.txt exists
if (Test-Path $Requirements) {
    Write-Info "Installing Python packages from requirements.txt"
    try {
        Run-Python "-m pip install -r `"$Requirements`""
    } catch {
        Write-Warn "pip install -r requirements.txt failed: $_"
    }
} else {
    Write-Warn "No requirements.txt found at $Requirements. Skipping pip list install."
}

# Try installing mysqlclient specifically (often fragile on Windows)
Write-Info "Attempting to install mysqlclient (may require MSVC build tools and MySQL dev libs)."
try {
    # Ensure Visual C++ build tools are present on Windows to allow compilation
    if ($IsWindows) {
        function Install-VSBuildTools {
            Write-Info "Ensuring Visual C++ Build Tools are installed (required for compiling mysqlclient)..."
            if (Command-Exists winget) {
                Write-Info "Installing Visual Studio Build Tools via winget..."
                & winget install --id Microsoft.VisualStudio.2022.BuildTools -e --accept-package-agreements --accept-source-agreements
                if ($LASTEXITCODE -eq 0) { return $true }
                Write-Warn "winget failed to install Visual Studio Build Tools."
            }
            if (Command-Exists choco) {
                Write-Info "Installing Visual C++ Build Tools via Chocolatey..."
                choco install visualcpp-build-tools -y
                if ($LASTEXITCODE -eq 0) { return $true }
                Write-Warn "Chocolatey failed to install visualcpp-build-tools."
            }
            Write-Warn "Could not auto-install Visual C++ Build Tools. You may need to install them manually: https://aka.ms/vs/17/release/vs_BuildTools.exe"
            return $false
        }

        Install-VSBuildTools | Out-Null
    }

    Run-Python "-m pip install mysqlclient"
    if ($LASTEXITCODE -eq 0) { Write-Info "mysqlclient installed successfully." }
} catch {
    Write-Warn "mysqlclient install failed. See notes below for manual steps. Error: $_"
}

# Node dependencies
if (Test-Path $SchoolDir) {
    Write-Info "Running npm install in $SchoolDir"
    try {
        Push-Location $SchoolDir
        if (Test-Path package-lock.json) { npm ci } else { npm install }
        Pop-Location
    } catch {
        Pop-Location -ErrorAction SilentlyContinue
        Write-Warn "npm install failed: $_"
    }
} else {
    Write-Warn "School directory not found: $SchoolDir"
}

# Final step: launch GSCHOOL.bat minimized
Write-Info "Launching GSCHOOL.bat (minimized)."
try {
    Start-Process -FilePath cmd.exe -ArgumentList "/c start /min `"$SchoolBat`"" -WorkingDirectory $SchoolDir -WindowStyle Minimized
    Write-Info "GSCHOOL.bat launched. The app should start shortly."
} catch {
    Write-Err "Failed to start GSCHOOL.bat: $_"
    exit 1
}

# Helpful troubleshooting output
Write-Host "`n==== Troubleshooting / Next steps ====`n"
Write-Host "If mysqlclient failed to install, you may need to:"
Write-Host " - Install Visual C++ Build Tools: https://aka.ms/vs/17/release/vs_BuildTools.exe"
Write-Host " - Install MySQL Connector/C dev libraries or MySQL Server (make sure headers/libs are available for compilation)"
Write-Host " - Alternatively, consider using PyMySQL (pure-Python) and adjust Django settings to use it: add `import pymysql; pymysql.install_as_MySQLdb()` in your project startup."

Write-Host "If Node/Electron fails to start, check that npm installed dependencies in $SchoolDir\node_modules and that package.json contains 'electron' dependency."

Write-Host "If you want this process automated into a single EXE installer, consider wrapping this script with an Inno Setup or NSIS script that ships the project and runs this script post-install."

Write-Info "Done."
