@echo off
setlocal
cd /d "%~dp0\.."

where python >nul 2>nul
if errorlevel 1 (
    where py >nul 2>nul
    if errorlevel 1 (
        echo Python 3 not found. Install Python 3 and add it to PATH.
        exit /b 1
    )
    set "PYTHON=py -3"
) else (
    set "PYTHON=python"
)

if not exist ".venv\Scripts\python.exe" (
    %PYTHON% -m venv .venv
    if errorlevel 1 exit /b %errorlevel%
)

".venv\Scripts\python.exe" -m pip install -r requirements.txt -r requirements-dev.txt
if errorlevel 1 exit /b %errorlevel%
".venv\Scripts\python.exe" -m pytest
if errorlevel 1 exit /b %errorlevel%

if exist "build" rmdir /s /q "build"
".venv\Scripts\python.exe" -m PyInstaller --onefile --name hello --paths src --distpath build --workpath build\pyinstaller\work --specpath build\pyinstaller src\hello\main.py
if errorlevel 1 exit /b %errorlevel%

if not exist "build\hello.exe" (
    echo Build failed: build\hello.exe was not created.
    exit /b 1
)

for /f "delims=" %%i in ('"build\hello.exe"') do set "OUTPUT=%%i"
if not "%OUTPUT%"=="Hello, World!" (
    echo Unexpected build\hello.exe output: %OUTPUT%
    exit /b 1
)
