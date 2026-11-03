# Лабораторна робота №1: AI-агент для автоматизації розробки та CI/CD

## 2. Дані студента

- ПІП: `Смолинський Роман Богданович`
- Група: `КІ-402`
- Варіант: `2 - (мова Python, система запуску: venv + скрипти запуску, тестування: pytest)`

## 3. Короткий опис проєкту

AI-агент build-engineer для GitHub Copilot генерує, збирає, тестує та перевіряє кросплатформний проєкт Hello World на Python. Середовище проєкту використовує venv, скрипти запуску та pytest. Для створення виконуваного файлу `hello` застосовується PyInstaller. Також агент формує workflow GitHub Actions для `ubuntu`, `windows` і `macos`.

## 4. Структура репозиторію

```text
.
├── .github
│   ├── agents
│   ├── prompts
│   ├── skills
│   └── workflows
├── src
├── tests
├── scripts
├── docs
├── ci.sh
├── ci.bat
└── requirements*.txt
```

## 5. Як запустити агента

1. Відкрийте репозиторій у VS Code.
2. Відкрийте Copilot Chat і перейдіть у режим Agent.
3. Виберіть агента `build-engineer`.
4. Виконайте команду `/init-local`.

Повторний запуск `/init-local` є безпечним.

Окремі команди:

- `/git-init-local`
- `/create-project-local`
- `/create-build-local`
- `/create-actions-local`
- `/check-local`

## 6. Як зібрати і запустити проєкт

### Linux/macOS

```text
./ci.sh
./build/hello
```

### Windows

```text
ci.bat
build\hello.exe
```

Тести запускаються автоматично в CI-скриптах за допомогою pytest.

## 7. Документація

- [docs/architecture.md](docs/architecture.md)
- [docs/usage.md](docs/usage.md)
- [docs/ai-log.md](docs/ai-log.md)

## 8. Результати CI

Workflow `CI` (`.github/workflows/ci.yml`) успішно пройшов збірку для pull request lab1/finish (`#1`) у гілці `feature/hello-python`. Тригерами workflow є `push` і `pull_request` до гілок `develop` та `master`. Загальна тривалість запуску: 44 секунди.

Посилання на [запуск GitHub Actions](https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/41637297291).

| ОС | Статус | Тривалість | Артефакт |
|---|---|---:|---|
| ubuntu-latest | Успішно | 30 с | hello-ubuntu-latest |
| windows-latest | Успішно | 40 с | hello-windows-latest |
| macos-latest | Успішно | 25 с | hello-macos-latest |

На кожній ОС `ci.sh` або `ci.bat` виконали збірку та тестування pytest: 2 тести пройдено. Створено виконуваний файл `build/hello` або `build\hello.exe` на Windows.
