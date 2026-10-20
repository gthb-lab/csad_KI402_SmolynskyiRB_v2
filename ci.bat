@echo off
python -m venv .venv
if errorlevel 1 exit /b 1
.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 exit /b 1
.venv\Scripts\python.exe -m pytest
if errorlevel 1 exit /b 1
.venv\Scripts\pyinstaller.exe --noconfirm --onefile --name hello --distpath dist --workpath build --specpath build src\hello.py
if errorlevel 1 exit /b 1
if not exist dist\hello.exe exit /b 1
if errorlevel 1 exit /b 1
dist\hello.exe > build\hello-output.txt
if errorlevel 1 exit /b 1
set "HELLO_OUTPUT="
if errorlevel 1 exit /b 1
set /p HELLO_OUTPUT=<build\hello-output.txt
if errorlevel 1 exit /b 1
if not "%HELLO_OUTPUT%"=="Hello, World!" exit /b 1
if errorlevel 1 exit /b 1
