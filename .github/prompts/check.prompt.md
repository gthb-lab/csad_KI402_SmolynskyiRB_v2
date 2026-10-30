---
description: Перевіряє manifest, skills, commands, структуру, збірку, CI та Git-гигиєну без змін відстежуваних файлів.
agent: build-engineer
---

## Призначення

Виконує повну перевірку агента та проєкту без виправлення виявлених проблем. Команда `check` лише читає файли й запускає перевірки; вона не змінює відстежувані файли проєкту.

## Передумови

- Репозиторій доступний і поточний каталог є коренем проєкту.
- Для перевірки збірки доступні Python 3 і система запуску поточної ОС.
- Git доступний у PATH.

## Дії

1. Зафіксувати стан відстежуваних і неігнорованих змін до перевірки через `git status --short`.
2. Перевірити manifest, skills, commands і init-orchestrator.
3. Перевірити структуру проєкту та наявність обов'язкових файлів.
4. Запустити збірку й тести: `bash ci.sh` на Linux/macOS або `ci.bat` на Windows.
5. Перевірити YAML workflow, Git-гігієну, секрети в tracked-файлах і `docs/ai-log.md`.
6. Порівняти стан `git status --short` до і після перевірки; він має збігатися.
7. Дозволити побічні ефекти лише в `.venv/`, `build/` та `.pytest_cache/`.
8. Для кожної перевірки вивести рядок таблиці `PASS` або `FAIL` із коротким поясненням.
9. Не виправляти проблеми автоматично; якщо є хоча б один `FAIL`, завершити повідомленням `CHECK FAILED` із проблемами та рекомендаціями, інакше завершити `CHECK PASSED`.

## Очікувані файли

- `.github/agents/build-engineer.agent.md`
- Три skills у `.github/skills/*/SKILL.md`
- Шість commands у `.github/prompts/*.prompt.md`
- Структура застосунку, тестів, скриптів і документації, описана нижче
- `.github/workflows/ci.yml`
- `docs/ai-log.md`

## Команди перевірки

1. **Manifest:** перевірити існування `.github/agents/build-engineer.agent.md` і розділи `Роль`, `Заборонені дії`, `Критерії успішного завершення`.
2. **Skills:** перевірити `.github/skills/project-scaffold/SKILL.md`, `.github/skills/build-and-test/SKILL.md`, `.github/skills/github-actions/SKILL.md`; кожен має містити призначення, вхідні дані, вихідні файли, перевірки й сценарій помилки.
3. **Commands:** перевірити `.github/prompts/git-init.prompt.md`, `create-project.prompt.md`, `create-build.prompt.md`, `create-actions.prompt.md`, `check.prompt.md`, `init.prompt.md`; кожен має містити `Повідомлення про помилку`.
4. **Оркестратор init:** перевірити, що `init.prompt.md` викликає команди саме в порядку `git-init → create-project → create-build → create-actions → check`.
5. **Структура проєкту:** перевірити наявність `src/hello/main.py`, `tests/test_basic.py`, `requirements.txt`, `requirements-dev.txt`, `pytest.ini`, `scripts/build.sh`, `scripts/build.bat`, `scripts/run.sh`, `scripts/run.bat`, `ci.sh`, `ci.bat`, `.gitignore`, `README.md`, `docs/architecture.md`, `docs/usage.md`.
6. **Збірка й тести:** виконати `bash ci.sh` на Linux/macOS або `ci.bat` на Windows; очікується код виходу `0`, повідомлення `test_basic_addition passed` та наявність `build/hello` або `build/hello.exe`.
7. **GitHub Actions:** у `.venv` завантажити YAML через `python -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml', encoding='utf-8'))"`; перевірити матрицю `ubuntu-latest`, `windows-latest`, `macos-latest`, тригери `push` і `pull_request` для `develop` і `master` та відсутність `pytest`, `pyinstaller`, `pip install`.
8. **Git-гігієна:** виконати `git ls-files`; переконатися, що відсутні відстежувані шляхи `build/`, `.venv/`, `dist/`, `__pycache__`, `.pytest_cache`; пошукати у tracked-файлах шаблони `ghp_`, `password=`, `token=`.
9. **Журнал AI:** перевірити, що `docs/ai-log.md` існує й не порожній.

Формат звіту:

| № | Перевірка | PASS/FAIL | Пояснення |
|---|---|---|---|

Якщо є хоча б один `FAIL`, завершити:

```text
CHECK FAILED
Проблеми та рекомендації: <перелік проблем і наступних кроків>
```

Інакше завершити:

```text
CHECK PASSED
```

## Повідомлення про помилку

| Ситуація | Текст повідомлення | Що робити |
|---|---|---|
| Змінився git status | `FAIL: команда check змінила стан відстежуваних файлів.` | Порівняти стан до й після перевірки, знайти причину побічного ефекту й усунути автоматичну зміну файлів. |
| Відсутній обов'язковий файл | `FAIL: очікуваний файл або каталог відсутній.` | Створити або відновити відповідний артефакт через передбачену command/skill. |
| Збірка або тест падає | `FAIL: збірка чи тестування завершилося ненульовим кодом.` | Показати повний вивід, не приховувати помилку і не виправляти проєкт автоматично. |
| YAML невалідний | `FAIL: workflow .github/workflows/ci.yml не є валідним YAML.` | Показати помилку парсера, перевірити відступи й структуру workflow. |
| Знайдено секрет або tracked build-каталог | `FAIL: порушено Git-гігієну.` | Видалити секрет або tracked-файл у явному окремому запиті користувача; не комітити і не публікувати артефакт. |

## Ідемпотентність

Повторний запуск `check` має давати той самий список перевірок та не змінювати відстежувані файли. Побічні зміни дозволені лише в `.venv/`, `build/` і `.pytest_cache/`, а результат порівняння `git status --short` до й після перевірки має бути однаковим.
