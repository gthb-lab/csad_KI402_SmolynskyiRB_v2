# Архітектура проєкту

## Призначення та компоненти

Репозиторій поєднує простий Python-застосунок із набором Copilot-кастомізацій, що автоматизують його підготовку та перевірку. Маніфест `build-engineer` задає роль і обмеження агента; skills надають процедури й користувацькі workflow; GitHub Actions запускає ті самі CI-скрипти на трьох ОС. Код застосунку самодостатній: `src/hello.py` містить `add(a, b)` і точку входу, а `tests/test_basic.py` перевіряє додавання.

## Зв'язки agent ↔ skills ↔ commands ↔ orchestrator

| Файл/елемент | Роль | Використання |
|---|---|---|
| `.github/agents/build-engineer.agent.md` | Маніфест агента: роль, інструменти, правила та критерії завершення | Вибирається в Copilot Chat у режимі Agent |
| `project-scaffold` | Створює базову структуру Python-застосунку | Викликається workflow-командою `create-project` |
| `build-and-test` | Додає pytest, run-скрипти й CI-збірки PyInstaller | Викликається workflow-командою `create-build` |
| `github-actions` | Налаштовує workflow для трьох ОС | Викликається workflow-командою `create-actions` |
| `git-init`, `create-project`, `create-build`, `create-actions`, `check` | Користувацькі skills-workflows у `.github/skills/` | У Copilot harness запускаються однойменними slash-командами |
| `init` | Оркестратор у `.github/skills/init/SKILL.md` | У Copilot harness запускає workflow-команди послідовно: `git-init` → `create-project` → `create-build` → `create-actions` → `check` |
| `*.prompt.md` | Prompt-файли, у яких frontmatter `name` закінчується на `-local` | Для Local harness: `/git-init-local`, `/create-project-local`, `/create-build-local`, `/create-actions-local`, `/check-local`, `/init-local` |
| `.github/workflows/ci.yml` | GitHub Actions CI | На `push` і `pull_request` до `develop`/`master` викликає `ci.sh` або `ci.bat` у матриці ОС |

## Потік даних та перевірок `init`

| Етап | Вхід і результат, що передається далі |
|---|---|
| Передумова → `git-init` | Перевіряється поточна feature-гілка; створюється Git-репозиторій лише якщо він відсутній; забезпечуються правила `.gitignore` і `.gitattributes` без дублікатів. |
| `git-init` → `create-project` | Передаються робочий репозиторій і правила перенесення рядків/ігнорування артефактів. |
| `create-project` → `create-build` | Наявні `src/hello.py` з `add(a, b)`, каталоги `src/` і `tests/`; запуск друкує `Hello, World!`. README зберігається й доповнюється розділом «Проєкт», якщо його ще немає. |
| `create-build` → `create-actions` | Наявні `requirements.txt`, `tests/test_basic.py`, `run.sh`, `run.bat`, `ci.sh`, `ci.bat`; локальний CI поточної ОС проходить і створює `dist/hello` або `dist/hello.exe`. |
| `create-actions` → `check` | `.github/workflows/ci.yml` безпечно розбирається, містить `ubuntu-latest`, `windows-latest`, `macos-latest` і маршрутизує виконання до CI-скрипта ОС. |
| `check` → завершення | Повна таблиця перевірок `PASS`/`FAIL`; успіх оголошується лише без `FAIL`. Перевірка не виправляє файли. |

## Обробка помилок

Оркестратор перевіряє передумови й результат кожного етапу. Після першої помилки він зупиняється, не переходить далі, називає крок і причину та не оголошує успіх без фінального успішного `check`. CI-скрипти також мають завершуватися з помилкою при невдалому тесті, збірці або перевірці виконуваного файла.

## Відповідність файлів ролям

| Файл або шлях | Фактична роль |
|---|---|
| `.github/agents/*.agent.md` | Маніфести custom agents |
| `.github/skills/<name>/SKILL.md` | Skills: повторно використовувані процедури та slash-workflows |
| `.github/prompts/*.prompt.md` | Prompt-команди Local harness; назви мають суфікс `-local` |
| `.github/workflows/ci.yml` | CI-матриця GitHub Actions та завантаження `dist/` як артефакту |
| `src/hello.py` | Застосунок: `add(a, b)` та `main()` |
| `tests/test_basic.py` | Перевірка `test_BasicAddition` |
| `ci.sh`, `ci.bat` | Встановлення залежностей, тестування та PyInstaller-збірка для відповідної ОС |
| `run.sh`, `run.bat` | Підготовка `.venv` і запуск застосунку з вихідного коду |
| `docs/` і `README.md` | Документація архітектури, використання та журналу AI-взаємодії |

## Безпека та ідемпотентність

- Перед створенням файл перевіряється; наявний вміст зберігається й доповнюється мінімально.
- Повторні запуски не додають дублікати правил, залежностей, тестів або кроків workflow.
- `.venv/`, `build/`, `dist/`, `__pycache__/`, `.pytest_cache/`, `*.spec` і `.env` виключаються з Git.
- `*.sh` зберігаються з LF, `*.bat` — з CRLF; shell-скрипти запускаються через `bash`, а batch-команди перевіряють `errorlevel`.
- Секрети й токени не зберігаються та не виводяться. Коміти, push і merge не виконуються без прямого прохання користувача.
