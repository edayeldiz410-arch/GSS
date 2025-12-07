# GSCHOOL Windows Bootstrap Installer

This repository includes `install_gschool.ps1`, a PowerShell bootstrap script that installs the prerequisites needed to run `school\GSCHOOL.bat` on Windows and then launches the batch file.

What the script does

- Ensures it's running elevated (relaunches with admin rights if needed).
- Installs Python 3 (via `winget` or Chocolatey if `winget` isn't present).
- Installs Node.js LTS (via `winget` or Chocolatey).
- Upgrades `pip`, `setuptools`, and `wheel`.
- Installs Python packages listed in `requirements.txt` (Django, reportlab).
- Attempts to install `mysqlclient` via `pip` (may fail on Windows — see notes).
- Runs `npm install` (or `npm ci`) inside the `school/` folder to install Electron and other JS deps.
- Launches `school\GSCHOOL.bat` minimized.

Usage

1. Copy the whole project folder to the target Windows machine.
2. Open PowerShell as Administrator.
3. Run the script, pointing to the project folder if needed:

```powershell
# Example: run from project folder
cd 'C:\path\to\Genieschool2'
.\install_gschool.ps1 -ProjectPath 'C:\path\to\Genieschool2'
```

If you run the script from inside the project folder, you can omit `-ProjectPath`.

Caveats and troubleshooting

- mysqlclient on Windows
  - Building `mysqlclient` typically requires Visual C++ Build Tools and MySQL client development files. If `pip install mysqlclient` fails, install Visual Studio Build Tools and MySQL Connector/C.
  - The bootstrapper (`install_gschool.ps1`) now attempts to automatically install Visual C++ Build Tools (via `winget` or Chocolatey) before running `pip install mysqlclient` to reduce failures on Windows. If automatic install fails, you'll still need to install the build tools manually: https://aka.ms/vs/17/release/vs_BuildTools.exe
  - As an alternative, consider using `PyMySQL` (pure-Python) and add the following near the top of your Django `manage.py` or `wsgi.py` before Django loads:

```python
import pymysql
pymysql.install_as_MySQLdb()
```

Then add `PyMySQL` to your `requirements.txt` and re-run the installer.

- Node/Electron
  - The script installs Node.js and runs `npm install` in the `school/` folder. If Electron fails to start, verify that `school\package.json` includes the `electron` dependency and that `node_modules` exists.

- Installer packaging
  - This script is a bootstrapper. If you want a single EXE installer, wrap this script and the project files using Inno Setup or NSIS, and configure the installer to run this script after installation.

- Admin rights
  - Installing system packages requires admin rights. The script will attempt to relaunch elevated if needed.

Notes

- This script prefers `winget` (Windows Package Manager). If `winget` isn't available, it will try to install Chocolatey and use it as a fallback.
- The script cannot handle every Windows configuration or missing build tools. Use the troubleshooting steps above if some installs fail.

If you'd like, I can:
- Add an Inno Setup script to produce a single EXE that bundles the project and runs this PowerShell script post-install.
- Modify `GSCHOOL.bat` to better accept environment variables for database credentials.
- Replace `mysqlclient` with `PyMySQL` to avoid native compilation issues on Windows.
