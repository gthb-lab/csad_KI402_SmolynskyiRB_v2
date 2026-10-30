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
4. Виконайте команду `/init`.

Повторний запуск `/init` є безпечним.

Окремі команди:

- `/git-init`
- `/create-project`
- `/create-build`
- `/create-actions`
- `/check`

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

Розділ про результати CI заповнюється після успішних запусків GitHub Actions.
