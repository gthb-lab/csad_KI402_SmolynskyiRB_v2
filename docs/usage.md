# Інструкція з використання

## Передумови

- VS Code із GitHub Copilot та Copilot Chat.
- Git і Python 3 у `PATH` (`python` у Windows, `python3` у Linux/macOS).
- Bash для запуску `ci.sh` і `run.sh` у Linux/macOS.

## Запуск агента та перевірка

1. Відкрийте корінь репозиторію у VS Code та виберіть feature-гілку `feature/hello-python`. Оркестратор зупиняється на гілках `master` і `develop`.
2. У Copilot Chat виберіть режим **Agent** та агента `build-engineer`.
3. У Copilot harness введіть `/init`. Це запускає skills у порядку `git-init` → `create-project` → `create-build` → `create-actions` → `check`.
4. Щоб повторити лише фінальну перевірку, введіть `/check`.
5. У Local harness відповідні prompt-файли названі `/init-local` та `/check-local`; для окремих етапів використовуйте `/git-init-local`, `/create-project-local`, `/create-build-local`, `/create-actions-local`.

Якщо створюєте feature-гілку з термінала і її ще немає, команда: `git switch -c feature/hello-python`. Якщо гілка вже існує, перемкніться на неї через перемикач гілок VS Code або `git switch feature/hello-python`.

## Локальна перевірка CI

Виконуйте з кореня репозиторію у відповідній оболонці:

```bash
bash ci.sh
```

```bat
ci.bat
```

`ci.sh` використовує `python3` для створення `.venv`, а далі запускає встановлення залежностей, pytest і PyInstaller інтерпретатором із середовища. `ci.bat` аналогічно починає з `python`, а наступні команди використовують `.venv\Scripts`. Перевірка тесту `test_BasicAddition`, збірки та виводу зібраного застосунку завершується помилкою, якщо будь-який крок не пройшов.

## Запуск застосунку

Із вихідного коду:

```bash
bash run.sh
```

```bat
run.bat
```

Після успішного CI-збирання запускайте виконуваний файл із кореня репозиторію:

```bash
./dist/hello
```

```bat
dist\hello.exe
```

Очікуваний вивід: `Hello, World!`.

## Артефакти GitHub Actions

Workflow `.github/workflows/ci.yml` запускається для `push` і `pull_request` до гілок `develop` та `master`. Після завершення успішного CI відкрийте репозиторій на GitHub → **Actions** → потрібний запуск **CI** → секцію **Artifacts** унизу сторінки запуску. Завантажуються окремі артефакти `hello-ubuntu-latest`, `hello-windows-latest` і `hello-macos-latest`; кожен містить відповідний файл із каталогу `dist/`. Push лише до feature-гілки сам по собі не відповідає фільтру `push` цього workflow; для запуску перевірки з feature-гілки створіть pull request до `develop` або `master`.

## Типові помилки

| Помилка | Що перевірити |
|---|---|
| `/init` зупиняється через гілку | Виберіть feature-гілку; оркестратор забороняє `master` і `develop`. |
| `python` або `python3` не знайдено | Встановіть Python 3, додайте його до `PATH` і відкрийте новий термінал. |
| `bash ci.sh` не працює в Linux/macOS | Запускайте через Bash і перевірте LF-переноси рядків та правило `*.sh text eol=lf` у `.gitattributes`. |
| Windows CI завершується помилкою | Перегляньте першу помилку у виводі `ci.bat`; кожна команда повинна перевіряти `if errorlevel 1 exit /b 1`. |
| Workflow не запускається для feature-гілки | Workflow фільтрує `push` за `develop` і `master`; створіть PR до однієї з цих гілок. |
| Не видно артефактів у Actions | Переконайтеся, що workflow завершився і відкрийте сторінку саме цього запуску; артефакти з’являються в секції **Artifacts**. |
