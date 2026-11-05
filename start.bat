@echo off

<<<<<<< HEAD
if not exist .venv\Scripts\python.exe (
    echo Setup has not been completed yet.
    echo Please run setup.bat first.
=======
if not exist .venv\kreators_setup_v2.ok (
    echo Setup has not been completed, or it is from an older version.
    echo Please run setup.bat first and wait for SETUP COMPLETE.
>>>>>>> d2aae20 (fixed the issues)
    pause
    exit /b 1
)

:menu
cls
echo ==================================================
echo                  KREATORS AI
echo ==================================================
echo.
echo   [1] Train My AI
<<<<<<< HEAD
echo   [2] Test My AI
echo   [3] Exit
=======
echo   [2] Test My Trained AI (after training)
echo   [3] Test Untrained Brain (base model - compare!)
echo   [4] Exit
>>>>>>> d2aae20 (fixed the issues)
echo.
set /p choice="Choose an option: "

if "%choice%"=="1" (
    echo.
    echo Starting training...
    echo.
    .venv\Scripts\python.exe train.py
    echo.
    pause
    goto menu
)
if "%choice%"=="2" (
    .venv\Scripts\python.exe test.py
    goto menu
)
if "%choice%"=="3" (
<<<<<<< HEAD
=======
    .venv\Scripts\python.exe test_base.py
    goto menu
)
if "%choice%"=="4" (
>>>>>>> d2aae20 (fixed the issues)
    exit
)
goto menu
