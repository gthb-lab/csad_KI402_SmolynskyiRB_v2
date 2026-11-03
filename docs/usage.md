# Використання build-engineer

## Запуск агента

1. Відкрийте репозиторій у VS Code.
2. Відкрийте Copilot Chat.
3. Перейдіть у Agent mode.
4. Виберіть агента `build-engineer`.
5. Виконайте `/init-local`.

## Окремі команди

- `/git-init-local` — ініціалізує Git і доповнює `.gitignore`.
- `/create-project-local` — створює початкову структуру проєкту Hello World.
- `/create-build-local` — створює залежності, тестування та скрипти збірки.
- `/create-actions-local` — створює `.github/workflows/ci.yml`.
- `/check-local` — перевіряє проєкт без виправлення відстежуваних файлів.

## Локальна збірка й перевірка

### Linux/macOS

```bash
bash ci.sh
```

### Windows

```bat
ci.bat
```

Скрипти збірки створюють `.venv`, встановлюють залежності, запускають pytest, збирають PyInstaller виконуваний файл і перевіряють його запуск.

## Запуск результату

### Linux/macOS

```bash
./build/hello
```

Очікуваний вивід:

```text
Hello, World!
```

### Windows

```bat
build\hello.exe
```

Очікуваний вивід:

```text
Hello, World!
```

## Окремий запуск тестів

### Linux/macOS

```bash
.venv/bin/python -m pytest
```

### Windows

```bat
.venv\Scripts\python.exe -m pytest
```

## Відтворення результату в гілці feature

1. Створіть і переключіться на feature-гілку, наприклад `feature/hello-agent`.
2. Відкрийте репозиторій у VS Code.
3. Запустіть build-engineer у Copilot Chat у режимі Agent.
4. Виконайте `/init-local`; якщо артефакти вже створені, повторний запуск має пропустити відповідні файли.
5. На Linux/macOS виконайте `bash ci.sh`; на Windows — `ci.bat`.
6. Перевірте, що збірка успішна й створено `build/hello` або `build/hello.exe`.
7. Перегляньте зміни командами `git status` і `git diff`.
8. Додайте потрібні файли вручну через `git add`, створіть коміт через `git commit` і за потреби опублікуйте зміни окремою явно підтвердженою дією.
