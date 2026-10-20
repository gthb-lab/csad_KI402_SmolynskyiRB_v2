# Hello, World! — автоматизація Python-проєкту

## Студент

- **ПІП:** `Смолинський Роман Богданович`
- **Група:** `КІ-402`
- **Варіант 2:** Python, `venv` + скрипт запуску, `pytest`

## Короткий опис

Проєкт поєднує кросплатформний Python-застосунок Hello World із робочими процесами GitHub Copilot у VS Code. Агент `build-engineer` координує skills для підготовки проєкту, тестів, PyInstaller-збірки та GitHub Actions CI.

## Як запустити агента

1. Відкрийте репозиторій у VS Code та виберіть feature-гілку `feature/hello-python` (оркестратор не запускається на `master` або `develop`).
2. У Copilot Chat виберіть режим **Agent** і агента `build-engineer`.
3. У Copilot harness виконайте `/init`, а після його успішного завершення — `/check`.
4. У Local harness використовуйте prompt-команди `/init-local` та `/check-local`.

## Як запустити проєкт

- Із вихідного коду: `bash run.sh` на Linux/macOS або `run.bat` у Windows.
- Локально запустити CI, тести та PyInstaller-збірку: `bash ci.sh` на Linux/macOS або `ci.bat` у Windows.
- Запустити готовий застосунок після збірки: `./dist/hello` на Linux/macOS або `dist\hello.exe` у Windows.

Workflow CI запускається для `push` і `pull_request` до `develop` та `master`. Артефакти `hello-ubuntu-latest`, `hello-windows-latest` і `hello-macos-latest` можна завантажити зі сторінки відповідного запуску в GitHub **Actions**, секція **Artifacts**.

## Структура репозиторію

```text
.github/
  agents/       Маніфести агентів
  prompts/      Prompt-команди для Local harness (імена закінчуються на -local)
  skills/       Workflow-команди та повторно використовувані процедури Copilot
  workflows/    GitHub Actions CI
src/            Вихідний код застосунку
tests/          Автоматизовані тести pytest
docs/           Архітектура, інструкції та журнал взаємодії з AI
```

## Проєкт

Базовий Python-застосунок міститься в `src/hello.py`. Він надає функцію `add(a, b)` і виводить `Hello, World!` під час запуску.

