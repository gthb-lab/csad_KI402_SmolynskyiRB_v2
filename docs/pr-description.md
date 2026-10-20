# lab1/finish

**Вихідна гілка:** `feature/hello-python`  
**Цільова гілка:** `develop`

## Що зроблено

За допомогою AI-агента `build-engineer` (GitHub Copilot, VS Code) у гілці `feature/hello-python` згенеровано кросплатформний Python-проєкт Hello World (варіант 2: Python, venv + скрипт запуску, pytest):

- застосунок `src/hello.py` і тест `test_BasicAddition` у `tests/test_basic.py`;
- скрипти `run.sh`/`run.bat` (запуск у venv) і `ci.sh`/`ci.bat` (встановлення залежностей, pytest, збірка виконуваного файлу `hello` через PyInstaller);
- `.gitignore` і `.gitattributes` (каталоги `.venv`, `build`, `dist`, `__pycache__` не відстежуються Git);
- CI workflow `.github/workflows/ci.yml`: одна job з matrix на ubuntu-latest, windows-latest, macos-latest, яка лише викликає `ci.sh`/`ci.bat` і завантажує `dist/` як артефакт;
- документація: `README.md`, `docs/usage.md`, `docs/architecture.md`.

Агент (manifest, skills, commands) лежить у `develop`. Проєкт згенеровано його оркестратором `init` (у чаті команда називається `/init-local`, бо `/init` збігається з вбудованою командою Copilot).

## Як перевірити (команди)

Linux/macOS:

```bash
bash ci.sh
```

Windows:

```bat
ci.bat
```

## Документація

- [Архітектура](architecture.md)
- [Журнал взаємодії з AI](ai-log.md)

## Результати локальних перевірок

Windows 11, Python 3.13.14, `ci.bat`:

```text
============================= test session starts =============================
platform win32 -- Python 3.13.14, pytest-9.1.1, pluggy-1.7.0
rootdir: C:\Users\lthp\OneDrive\Documents\LPNU\7sem\APKS\lab1
collected 1 item

tests\test_basic.py .                                                    [100%]

============================== 1 passed in 0.09s ==============================
...
2202 INFO: Build complete! The results are available in: C:\Users\lthp\OneDrive\Documents\LPNU\7sem\APKS\lab1\dist
```

Запуск зібраного застосунку:

```text
C:\Users\lthp\OneDrive\Documents\LPNU\7sem\APKS\lab1>dist\hello.exe
Hello, World!
```

Результат `/check-local`:

| Перевірка | Статус | Деталі |
|---|---|---|
| Маніфест агента та skills | PASS | Потрібні секції є в маніфесті й усіх 9 skills. |
| Prompt-файли та порядок init | PASS | Усі 6 prompts містять потрібні секції; кроки перелічені в заданому порядку. |
| Структура проєкту | PASS | Усі обов'язкові каталоги та файли наявні. |
| Windows CI | PASS | `ci.bat` завершився успішно, `test_BasicAddition` пройшов. |
| Зібраний застосунок | PASS | `dist\hello.exe` існує та друкує `Hello, World!`. |
| Workflow | PASS | YAML безпечно розібрано; перевірені три ОС та виклики CI-скриптів. |
| Git, секрети й ідемпотентність | PASS | Заборонених артефактів і секретних шаблонів не виявлено; Git-статус до та після CI однаковий. |

## Результати GitHub Actions

- Ubuntu (`ubuntu-latest`): [job](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/39159914007/job/117770851366), [артефакт hello-ubuntu-latest](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/39159914007/artifacts/12147964552)
- Windows (`windows-latest`): [job](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/39159914007/job/117770851591), [артефакт hello-windows-latest](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/39159914007/artifacts/12148735646)
- macOS (`macos-latest`): [job](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/39159914007/job/117770851665), [артефакт hello-macos-latest](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/39159914007/artifacts/12147658838)