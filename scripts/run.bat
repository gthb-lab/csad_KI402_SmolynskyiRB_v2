@echo off
setlocal
cd /d "%~dp0\.."

if not exist "build\hello.exe" (
    echo build\hello.exe not found. Run ci.bat first.
    exit /b 1
)

"build\hello.exe"
