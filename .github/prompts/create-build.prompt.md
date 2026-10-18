---
name: create-build-local
agent: build-engineer
description: Додай кросплатформні скрипти запуску, тести та PyInstaller CI через skill build-and-test.
---

# Передумови

- У корені проєкту існує `src/hello.py` із функцією `add(a, b)`.
- Не перезаписуй наявні файли; доповнюй їх мінімально та без дублікатів.

# Дії

1. Перевір передумову та наявність цільових файлів.
2. Застосуй skill `build-and-test`.
3. Переконайся, що скрипти використовують інтерпретатор із `.venv` після її створення, а `ci.bat` перевіряє `if errorlevel 1 exit /b 1` після кожної команди.
4. Запусти CI-скрипт для поточної ОС: `bash ci.sh` на Linux/macOS або `ci.bat` на Windows. Не покладайся на біт виконання `ci.sh`.

# Очікувані файли

- `requirements.txt`
- `tests/test_basic.py`
- `run.sh` і `run.bat`
- `ci.sh` і `ci.bat`
- Артефакт перевірки: `dist/hello` на Linux/macOS або `dist\hello.exe` на Windows.

# Команди перевірки

- Linux/macOS: `bash ci.sh`
- Windows: `ci.bat`
- Перевір успішний код завершення, проходження `test_BasicAddition` і вивід `Hello, World!` від виконуваного файла.

# Повідомлення про помилку

Якщо `src/hello.py` не існує або в ньому немає `add(a, b)`, зупинись і повідом про відсутню передумову. Якщо CI-команда завершується помилкою, вкажи ОС, команду й причину; не оголошуй успіх і не приховуй помилку, особливо падіння pytest у Windows.
