@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ==================================================
echo            KREATORS AI - SETUP (Windows)
echo ==================================================
echo.
echo Installing everything needed. This takes 10-15 minutes.
echo Please keep this window open.
echo.

REM ---------- 1. Find Python 3.12 ----------
set "PYEXE="
set "PYARG="
py -3.12 --version >nul 2>nul
if %errorlevel%==0 ( set "PYEXE=py" & set "PYARG=-3.12" )
if not defined PYEXE if exist "%LocalAppData%\Programs\Python\Python312\python.exe" set "PYEXE=%LocalAppData%\Programs\Python\Python312\python.exe"

if defined PYEXE (
    echo [1/5] Python 3.12 found.
    goto :make_env
)

echo [1/5] Python 3.12 not found. Downloading it now...
echo       (If Windows asks for permission, click Yes.)
set "PYTHON_URL=https://www.python.org/ftp/python/3.12.10/python-3.12.10-amd64.exe"
set "PYTHON_INSTALLER=%TEMP%\kreators_python_installer.exe"
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%PYTHON_URL%' -OutFile '%PYTHON_INSTALLER%'"
if not exist "%PYTHON_INSTALLER%" (
    echo ERROR: Could not download Python. Check your internet connection.
    echo Or install Python 3.12 from https://www.python.org/downloads/ and run setup again.
    pause
    exit /b 1
)
"%PYTHON_INSTALLER%" /quiet InstallAllUsers=0 PrependPath=1 Include_launcher=1
del "%PYTHON_INSTALLER%" >nul 2>nul
if exist "%LocalAppData%\Programs\Python\Python312\python.exe" set "PYEXE=%LocalAppData%\Programs\Python\Python312\python.exe"
if not defined PYEXE (
    echo ERROR: Python 3.12 did not install. Please install it from https://www.python.org/downloads/
    echo then run setup again.
    pause
    exit /b 1
)

:make_env
REM ---------- 2. Create the private workspace (automatic, students never see it) ----------
echo [2/5] Creating workspace...
if exist .venv rmdir /s /q .venv
"%PYEXE%" %PYARG% -m venv .venv
if not exist .venv\Scripts\python.exe (
    echo ERROR: Could not create the workspace.
    pause
    exit /b 1
)

REM ---------- 3. Install the exact pinned versions ----------
echo [3/5] Installing AI tools (the slow part, please wait)...
.venv\Scripts\python.exe -m pip install --disable-pip-version-check --no-input --default-timeout 100 --retries 5 --upgrade pip
if %errorlevel% neq 0 ( echo ERROR: pip upgrade failed. Check your internet. & pause & exit /b 1 )
.venv\Scripts\python.exe -m pip install --disable-pip-version-check --no-input --default-timeout 100 --retries 5 --only-binary=:all: -r requirements-windows.txt
if %errorlevel% neq 0 ( echo ERROR: package install failed. See the message above. & pause & exit /b 1 )

REM ---------- 4. Download the base model ----------
echo [4/5] Downloading the Qwen3-0.6B base model (about 1.5 GB)...
.venv\Scripts\python.exe -c "from transformers import AutoTokenizer, AutoModelForCausalLM; AutoTokenizer.from_pretrained('Qwen/Qwen3-0.6B'); AutoModelForCausalLM.from_pretrained('Qwen/Qwen3-0.6B'); print('Qwen3 downloaded.')"
if %errorlevel% neq 0 ( echo ERROR: model download failed. Check your internet and run setup again. & pause & exit /b 1 )

REM ---------- 5. Verify everything ----------
echo [5/5] Checking the install...
.venv\Scripts\python.exe check_setup.py requirements-windows.txt
if %errorlevel% neq 0 ( pause & exit /b 1 )
echo ok> .venv\kreators_setup_v2.ok

echo.
echo ==================================================
echo   SETUP COMPLETE!  Run start.bat to begin.
echo ==================================================
pause
