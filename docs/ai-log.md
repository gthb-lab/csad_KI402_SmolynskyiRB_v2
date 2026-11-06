# Журнал взаємодії з AI

Лабораторна робота №1 «Проєктування AI-агента для автоматизації розробки та CI/CD», варіант 2 (Python, venv + скрипт запуску, pytest).

## Загальні відомості

| Параметр | Значення |
|---|---|
| AI-інструмент | GitHub Copilot (Copilot Chat у VS Code, режим Agent) |
| Модель | Auto (автовибір моделі Copilot) |
| Період | 2026-10-30 13:41–14:01 UTC; 2026-11-03 11:14–13:17 UTC |
| Кількість запитів до Copilot | 21 (етап 1: 9, етап 2: 12) |
| Витрачено кредитів Copilot | 31.97 |
| Згенеровано токенів | 54287 |

Пояснення позначень: **E1–E10** це помилки та проблеми, описані в розділі «Помилки та їхнє виправлення».

## Етап 1. Створення агента (гілка `develop`)

Усі файли створено за допомогою Copilot окремими запитами. Кожен промпт забороняв створювати зайві файли та запускати команди в терміналі. Перегляд і зауваження викладено в таблицях нижче.

| № | Час (UTC) | Запит | Результат | Проблема |
|---|---|---|---|---|
| 1 | 13:41 | README.md та docs/architecture.md | Створено README.md, docs/architecture.md | — |
| 2 | 13:48 | Manifest агента build-engineer | Створено .github/agents/build-engineer.agent.md | — |
| 3 | 13:52 | Skill project-scaffold | Створено .github/skills/project-scaffold/SKILL.md | — |
| 4 | 13:55 | Skill build-and-test | Створено .github/skills/build-and-test/SKILL.md | — |
| 5 | 13:56 | Skill github-actions | Створено .github/skills/github-actions/SKILL.md | — |
| 6 | 13:58 | Commands git-init та create-project | Створено git-init.prompt.md, create-project.prompt.md | — |
| 7 | 13:59 | Commands create-build та create-actions | Створено create-build.prompt.md, create-actions.prompt.md | — |
| 8 | 14:00 | Command check | Створено check.prompt.md | — |
| 9 | 14:01 | Оркестратор init, docs/usage.md, docs/ai-log.md | Створено init.prompt.md, docs/usage.md, docs/ai-log.md | — |

## Етап 2. Запуск агента на гілці `feature/hello-python`

| № | Час (UTC) | Запит | Результат | Проблема |
|---|---|---|---|---|
| 10 | 11-03 11:14 | `/init` | Спрацювала вбудована команда Copilot: створено .github/copilot-instructions.md, команда агента не запускалась | Колізія імен із вбудованою командою (E1) |
| 11 | 11-03 11:17 | Перейменування шести commands із суфіксом `-local` | Файли перейменовано через git mv; оновлено посилання у manifest, prompts, skills, README, docs; таблиця старе→нове ім'я; пошук старих імен чистий | Усунення E1 |
| 12 | 11-03 11:22 | `/init-local` (перший запуск) | Створено src/, tests/, requirements*.txt, pytest.ini, scripts/, ci.sh, ci.bat, .github/workflows/ci.yml, .gitignore; ci.bat: 2 тести пройдено, створено build\hello.exe; CHECK PASSED | CRLF у ci.sh, bash/WSL, Python у cmd (E2–E4, E5) |
| 13 | 11-03 11:28 | `/check-local` | CHECK FAILED: пункт 3, у init-local немає розділу «Повідомлення про помилку»; решта PASS | FAIL перевірки №3 (E6) |
| 14 | 11-03 11:38 | Виправлення init-local | Додано розділ «## Повідомлення про помилку» з таблицею (6 ситуацій) до init-local.prompt.md | Усунення E6 |
| 15 | 11-03 11:44 | Виправлення .gitignore та інструкцій | Створено .gitignore із 7 правилами; посилено project-scaffold, git-init-local; у check-local додано перевірку untracked-кешів (п. 8a) | E7 |
| 16 | 11-03 11:57 | `/init-local` (повторний) | Нічого не створено, усе пропущено як наявне; 2 тести, hello.exe, git status без змін; CHECK PASSED | Ідемпотентність підтверджена; `ci.bat` не розпізнано в PowerShell (E9) |
| 17 | 11-03 12:03 | `/check-local` | CHECK PASSED (9/9 PASS) | Хибні FAIL через кодування PowerShell, хибне спрацювання пошуку секретів (E8) |
| 18 | 11-03 12:07 | `/init-local` (третій) | Завершився після кроку 1, підсумкового звіту немає | Запуск не завершено (E10) |
| 19 | 11-03 12:08 | `/init-local` (четвертий) | Усі 5 кроків PASS, нічого не створено (ідемпотентність), CHECK PASSED | — |
| 20 | 11-03 13:11 | `/check-local` | CHECK PASSED (9/9 PASS); git status до і після порожній | Хибні FAIL через кодування (E8) |
| 21 | 11-03 13:17 | Заповнення розділу «Результати CI» в README | Оновлено лише розділ 8 у README.md | — |

## Помилки та їхнє виправлення

| № | Проблема | Причина | Виправлення | Результат |
|---|---|---|---|---|
| E1 | Запит `/init` створив лише `.github/copilot-instructions.md`, жодна команда агента не виконалась | Ім'я `/init` збігається з вбудованою командою Copilot Chat, яка має пріоритет над `init.prompt.md` | Запит №11: усі 6 commands перейменовано з суфіксом `-local` (`git mv`), оновлено посилання в manifest, prompts, skills, README, docs | `/init-local` запускає оркестратор агента |
| E2 | `bash ci.sh` завершився помилкою `scripts/build.sh\r: No such file or directory` | Інструмент редагування на Windows записав shell-скрипти з CRLF | Агент нормалізував `ci.sh`, `scripts/build.sh`, `scripts/run.sh` до LF (PowerShell) | Помилка зникла; рекомендація: `.gitattributes` з `*.sh text eol=lf` |
| E3 | `bash ci.sh` під WSL: `ensurepip is not available`, `.venv` створено неповним | `bash` у цьому середовищі запускає Linux Python без `python3-venv`, що змішується з Windows-репозиторієм | Агент перейшов на `ci.bat` для локальної перевірки Windows; неповний `.venv` видалено (`Remove-Item -Recurse -Force .venv`) | Збірка через `ci.bat` пройшла (див. E4) |
| E4 | `ci.bat` у `cmd.exe`: `Python 3 not found`, хоча `where python` знаходив Python у `WindowsApps` | Скрипт `scripts/build.bat` неправильно визначав інтерпретатор | Агент змінив `scripts/build.bat`; повторний `ci.bat`: 2 тести пройдено, створено `build\hello.exe` | `Hello, World!` |
| E5 | Підсумковий звіт першого `/init-local` показав лише PASS і не згадав E2–E4 | Оркестратор у підсумку не відображав проміжні невдалі спроби, хоча інструкція вимагає не приховувати помилки | Зафіксовано як обмеження агента; можливе покращення: вимагати в `init-local` включати у звіт усі невдалі спроби | Описано у висновках |
| E6 | `/check-local` повернув CHECK FAILED на перевірці №3: у `init-local.prompt.md` немає розділу «Повідомлення про помилку» | У промпті на створення `init` перелік розділів не містив цього розділу, а `check` вимагає його в усіх шести commands | Запит №14: додано розділ із таблицею (6 ситуацій) лише до `init-local.prompt.md` | Повторний `/check-local`: CHECK PASSED |
| E7 | Файли `__pycache__/*.pyc` відображалися як untracked; Copilot виявив, що `.gitignore` у робочому дереві відсутній | Причина відсутності `.gitignore` в експорті не вказана; `check-local` перевіряв лише `git ls-files`, а не untracked-файли | Запит №15: створено `.gitignore` із 7 правилами, посилено `project-scaffold` та `git-init-local`, у `check-local` додано перевірку 8a (untracked-кеші) | `/check-local`: Git-гігієна PASS, `git status --short` порожній |
| E8 | `/check-local` у PowerShell видав хибні FAIL для розділів manifest/skills/commands; пошук секретів позначив `check-local.prompt.md`; PyYAML дав `KeyError` для ключа `on` | `Get-Content` без `-Encoding UTF8` спотворює український текст; сам prompt містить шаблони `ghp_`, `password=`, `token=`; PyYAML (YAML 1.1) читає `on` як булевий `True` | Агент повторно перевірив через `rg` та `Select-String -Encoding UTF8` (PASS), визнав збіг із секретами хибним, а тригери читав як `y.get('on', y.get(True))` | CHECK PASSED; потрібно пам'ятати про `-Encoding UTF8` у PowerShell |
| E9 | `ci.bat` у PowerShell: `The term 'ci.bat' is not recognized` | PowerShell не запускає `.bat` із поточного каталогу без `.\` або `cmd.exe` | Агент повторив команду як `cmd.exe /d /c ci.bat` | Збірка пройшла |
| E10 | Третій запуск `/init-local` завершився після кроку 1/5 без підсумкового звіту | Запуск перервано (причина в експорті не вказана) | Запит №19: `/init-local` перезапущено повністю | Усі 5 кроків PASS |

### Події поза Copilot Chat (термінал і GitHub)

| Подія | Причина | Рішення |
|---|---|---|
| `git commit` не створив коміту: «no changes added to commit» | Файли не було додано до індексу (`git add`) | Додано файли поіменно, закомічено окремими комітами |
| `git merge develop`: `You have not concluded your merge (MERGE_HEAD exists)` | Попереднє злиття лишилося незавершеним після виходу з vim | `git commit --no-edit`, злиття завершено |
| Вкладка Actions порожня («Get started with GitHub Actions») | `ci.yml` був лише на `feature/hello-python`, workflow за вимогою спрацьовує на `develop`/`master` | Створено PR `lab1/finish` у `develop`, після чого CI запустився |
| У Annotations запуску CI 3 warnings і 2 notices (Node.js 20 deprecated для `actions/checkout`, `actions/setup-python`) | Попередження GitHub про застарілу версію Node.js у actions | Збірку не блокують; оновлення версій actions можливе окремо через skill `github-actions` |

## Перевірка ідемпотентності та результатів

- Повторні запуски `/init-local` (запити №16 та №19) нічого не створили та не змінили: у звіті «Створено: —», `git status --short` до і після порожній.
- `ci.bat`: 2 тести пройдено, створено `build\hello.exe`, який друкує `Hello, World!`.
- `/check-local`: CHECK PASSED, 9 із 9 перевірок (запити №17 та №20).
- GitHub Actions: workflow CI для PR `lab1/finish` (#1) завершився успішно на `ubuntu-latest`, `windows-latest`, `macos-latest`; створено 3 артефакти (запуск 41637297291).

## Прийняті рішення

1. Формат агента: стандарт GitHub Copilot для VS Code (`.github/agents`, `.github/prompts`, `.github/skills`).
2. Кожен файл або пара файлів створюється окремим запитом із забороною зайвих дій, щоб перегляд був можливим для кожного результату.
3. Commands отримали суфікс `-local`, щоб уникнути конфлікту з вбудованими командами Copilot Chat (E1).
4. Помилки виправляються в інструкціях агента (skills, commands), а не тільки в згенерованому результаті; зміни інструкцій комітяться на `develop` і зливаються у `feature/hello-python`.
5. Локальна перевірка на Windows виконується через `ci.bat`; Linux/macOS перевіряються в GitHub Actions.
6. Усі згенеровані зміни переглядаються вручну перед комітом; секрети й токени до AI не передаються (вимога методички).

## Обмеження агента (за результатами журналу)

- Агент залежить від Copilot і підтверджень виконання команд; вбудовані команди (`/init`) можуть перехоплювати виклики.
- У середовищі змішуються Windows і WSL (`bash`), тому `ci.sh` локально на Windows не перевірявся, його перевіряє CI на Linux/macOS.
- Під час першого запуску агент виконав видалення `.venv` (E3), хоча manifest забороняє видалення файлів; каталог ігнорується Git і відтворюється збіркою, але це відхилення від правила варто врахувати в інструкціях.
- Підсумковий звіт оркестратора не показав проміжні невдалі спроби (E5).



## Повні тексти промптів

### Запит 1 (2026-10-30 13:41 UTC): README.md та docs/architecture.md

- Тривалість: 28 с; кредити Copilot: 0.53

<details><summary>Текст промпта</summary>

```text
Ти працюєш у порожньому git-репозиторії для лабораторної роботи №1 «Проєктування
AI-агента для автоматизації розробки та CI/CD». Створи ДВА файли. Не створюй жодних
інших файлів і не запускай жодних команд.

ДАНІ СТУДЕНТА: ПІП: <ПІП>; група: <група>; варіант: 2 (мова Python, система запуску:
venv + скрипти запуску, тестування: pytest). Не вигадуй жодних інших даних.

ФАЙЛ 1: README.md (українською). Розділи:
1. Заголовок: «Лабораторна робота №1: AI-агент для автоматизації розробки та CI/CD».
2. Дані студента (ПІП, група, варіант 2).
3. Короткий опис проєкту: AI-агент build-engineer для GitHub Copilot генерує, збирає,
   тестує і перевіряє кросплатформний проєкт Hello World на Python (venv + скрипти,
   pytest, PyInstaller для виконуваного файлу hello), а також workflow GitHub Actions
   для ubuntu, windows і macos.
4. Структура репозиторію (дерево: .github/agents, .github/prompts, .github/skills,
   .github/workflows, src, tests, scripts, docs, ci.sh, ci.bat, requirements*.txt).
5. Як запустити агента: відкрити репозиторій у VS Code, Copilot Chat → режим Agent →
   вибрати агента build-engineer → виконати команду /init (повторний запуск безпечний).
   Окремі команди: /git-init, /create-project, /create-build, /create-actions, /check.
6. Як зібрати і запустити проєкт: Linux/macOS: ./ci.sh, потім ./build/hello;
   Windows: ci.bat, потім build\hello.exe. Тести: запускаються автоматично в ci-скриптах.
7. Посилання на docs/architecture.md, docs/usage.md, docs/ai-log.md.
8. Примітка: розділ про результати CI заповнюється після успішних запусків GitHub Actions.

ФАЙЛ 2: docs/architecture.md (українською). Розділи:
1. Які проблеми вирішує агент (ручне, неповторюване налаштування проєкту; відсутність
   єдиної перевірки; різна поведінка на ОС).
2. Таблиця Skills: назва, призначення, вхід, вихід.
   (project-scaffold, build-and-test, github-actions).
3. Таблиця Commands: назва, що викликає, що створює/перевіряє
   (git-init, create-project, create-build, create-actions, check, init).
4. Схема взаємодії (текстова діаграма або mermaid): manifest → commands → skills →
   файли; init викликає git-init → create-project → create-build → create-actions → check.
5. Які дані передаються між етапами (назва проєкту, мова, шляхи створених файлів,
   список пропущених як уже існуючих, результат перевірок).
6. Як оркестратор обробляє помилки: зупиняється на першій помилці, показує причину і
   рекомендацію, не приховує помилок, не повідомляє про успіх без успішного /check.
7. Ідемпотентність: що робить кожна команда, якщо файл уже існує (не перезаписує, не
   дублює, повідомляє про пропуск).
8. Таблиця відповідності файлів Copilot ролям: .github/agents/build-engineer.agent.md —
   manifest; .github/prompts/*.prompt.md — commands; .github/skills/*/SKILL.md — skills;
   .github/workflows/ci.yml — CI. Зазнач, що використано формат GitHub Copilot для VS Code.
9. Обмеження агента (потребує підтвердження дій у Copilot, залежить від Python 3 на
   машині, не публікує нічого сам, не змінює захист гілок).
```

</details>

### Запит 2 (2026-10-30 13:48 UTC): Manifest агента build-engineer

- Тривалість: 25 с; кредити Copilot: 0.36

<details><summary>Текст промпта</summary>

```text
Створи ОДИН файл: .github/agents/build-engineer.agent.md. Більше нічого не створюй і
не запускай команд.

Формат: Markdown з YAML frontmatter між рядками --- на початку файлу, поля:
- description: короткий опис (один рядок, українською);
- tools: стандартні інструменти VS Code Copilot для агента, що редагує файли,
  шукає по проєкту і запускає команди в терміналі.

Тіло (українською) має містити розділи з такими заголовками:

## Роль
Ти build-engineer: спеціалізований агент, що створює, збирає, тестує і перевіряє
кросплатформний проєкт Hello World на Python (мова Python, venv + скрипти запуску,
pytest, PyInstaller для виконуваного файлу hello) та налаштовує CI на GitHub Actions.

## Область відповідальності
Що входить: git-init, створення структури проєкту, система збірки і тести, скрипти
ci.sh/ci.bat, workflow .github/workflows/ci.yml, перевірка результату.
Що НЕ входить: публікація пакетів, деплой, налаштування захисту гілок, робота з секретами.

## Правила роботи з файлами
- Перед створенням файлу перевір, чи він існує. Якщо існує і збігається з очікуваним
  результатом, пропусти і повідом. Якщо існує і відрізняється, НЕ перезаписуй, а покажи
  різницю і запитай користувача.
- Усі команди ідемпотентні: повторний запуск не руйнує і не дублює файли чи рядки
  конфігурацій (особливо .gitignore).
- Створюй лише файли з очікуваного переліку (див. skills).
- Шляхи завжди відносні до кореня репозиторію.
- Не додавай у Git каталоги build/, .venv/, dist/, кеші, секрети.

## Заборонені дії
Видалення файлів або каталогів; git push --force та будь-яке переписування історії;
git reset --hard; зміна захисту гілок; публікація, читання чи запис секретів, токенів,
паролів, приватних ключів; встановлення залежностей поза .venv; автоматичний push без
явного запиту; коміт build/, .venv/, кешів.

## Доступні skills
Перелік із короткими описами: project-scaffold, build-and-test, github-actions
(шляхи .github/skills/<назва>/SKILL.md).

## Доступні commands
git-init, create-project, create-build, create-actions, check, init з однорядковими
описами та вказівкою, що init є оркестратором (оркестратор init може конфліктувати із вбудованим у VSCode /init).

## Порядок роботи
1) Прочитай запит і визнач command. 2) Перевір передумови. 3) Виконай дії відповідного
skill. 4) Виконай перевірки. 5) Склади звіт: що створено, що пропущено, результат
перевірок. 6) При помилці зупинись і поясни причину та наступний крок.

## Критерії успішного завершення
- Існують manifest, 3 skills, 6 commands.
- Створено src/hello/main.py із add() і main(), tests/test_basic.py із тестом
  test_basic_addition, requirements.txt, requirements-dev.txt, pytest.ini,
  scripts/build.sh, scripts/build.bat, scripts/run.sh, scripts/run.bat, ci.sh, ci.bat.
- ci.sh/ci.bat запускають збірку і тести, і створюють build/hello (build/hello.exe на Windows).
- Тест test_basic_addition проходить.
- ci.yml містить matrix ubuntu-latest, windows-latest, macos-latest, запускає лише
  ci.sh / ci.bat і тригериться на push та pull_request до develop і master.
- У git ls-files немає build/, .venv/, секретів.
- Команда check завершується без FAIL.
- Повторний запуск init не змінює вже створені файли.

## Звіт після виконання
Формат: таблиця «крок / результат / файли».
```

</details>

### Запит 3 (2026-10-30 13:52 UTC): Skill project-scaffold

- Тривалість: 17 с; кредити Copilot: 0.59

<details><summary>Текст промпта</summary>

```text
Створи ОДИН файл: .github/skills/project-scaffold/SKILL.md. Більше нічого не створюй
і не запускай команд.

Формат: Markdown із YAML frontmatter: name: project-scaffold; description: одне речення,
коли застосовувати (коли треба створити початковий Hello World-проєкт на Python).
Українською. Розділи в такому порядку:

## Призначення
Створює мінімальний Hello World-проєкт на Python: структуру каталогів, початковий код,
README (якщо немає) і .gitignore (доповнює).

## Коли застосовувати
Коли в репозиторії ще немає src/hello/main.py або треба перевірити/відновити
початкову структуру. Викликається командою create-project.

## Вхідні дані
- language: Python (єдине значення для цього варіанта; інше значення = помилка).
- project_name: за замовчуванням hello.
Приклад входу: language=Python, project_name=hello.

## Вихідні файли
- src/hello/__init__.py (порожній або з __version__ = "0.1.0")
- src/hello/main.py: функція add(a, b) повертає суму; функція main() друкує рівно
  рядок "Hello, World!"; блок if __name__ == "__main__": main(). Весь код у цьому
  файлі, без відносних імпортів (потрібно для PyInstaller).
- tests/ (каталог, наповнює skill build-and-test)
- docs/ (каталог)
- README.md (лише якщо відсутній)
- .gitignore: має містити рядки .venv/, build/, dist/, __pycache__/, .pytest_cache/,
  *.spec, *.pyc; відсутні рядки додаються, наявні не дублюються.

## Кроки
Пронумерований список: перевірити Python 3; перевірити наявність кожного файлу;
створити відсутні; для наявних порівняти і не перезаписувати; доповнити .gitignore;
виконати перевірки.

## Перевірки
- Існує src/hello/main.py.
- Команда запуску працює: python src/hello/main.py друкує Hello, World!
  (на Windows py -3 src\hello\main.py або python).
- .gitignore містить усі обов'язкові рядки рівно по одному разу.

## Типовий сценарій помилки
Опиши щонайменше два: (1) Python 3 не знайдено → зупинитись і повідомити, як
встановити; (2) src/hello/main.py існує, але відрізняється → не перезаписувати,
показати різницю, запитати користувача. Для кожного: симптом, причина, дія.

## Ідемпотентність
Що робить skill при повторному запуску.
```

</details>

### Запит 4 (2026-10-30 13:55 UTC): Skill build-and-test

- Тривалість: 24 с; кредити Copilot: 0.38

<details><summary>Текст промпта</summary>

```text
Створи ОДИН файл: .github/skills/build-and-test/SKILL.md. Більше нічого не створюй
і не запускай команд. Формат: Markdown із YAML frontmatter (name: build-and-test,
description: одне речення). Українською. Розділи в порядку: Призначення, Коли
застосовувати, Вхідні дані (з прикладом), Вихідні файли, Кроки, Перевірки, Типовий
сценарій помилки, Ідемпотентність.

Зміст:

ПРИЗНАЧЕННЯ: створює систему збірки і тестування для Python-проєкту: залежності,
конфігурацію pytest, юніт-тест, скрипти збірки/запуску для Linux/macOS і Windows та
CI-скрипти ci.sh / ci.bat. Підкоманди (можна виконувати окремо): dependencies, tests,
scripts.

ВХІД: project_name (за замовчуванням hello). Приклад: project_name=hello.

ВИХІДНІ ФАЙЛИ (з точним змістом вимог):
- requirements.txt: порожній або з коментарем (у застосунку немає зовнішніх залежностей).
- requirements-dev.txt: pytest, pyinstaller, pyyaml (з розумними мінімальними версіями).
- pytest.ini: testpaths = tests, pythonpath = src.
- tests/test_basic.py: імпортує add з hello.main; клас TestBasicAddition з методом
  test_basic_addition, який перевіряє add(2, 3) == 5; додатково перевірка main()
  через capsys: виведено "Hello, World!".
- scripts/build.sh (bash, #!/usr/bin/env bash, set -euo pipefail): перейти в корінь
  репозиторію; знайти python3 або python; створити .venv, якщо його немає; встановити
  requirements-dev.txt (і requirements.txt) через .venv/bin/python -m pip; запустити
  .venv/bin/python -m pytest; зібрати виконуваний файл через PyInstaller:
  --onefile --name hello --paths src --distpath build --workpath build/pyinstaller/work
  --specpath build/pyinstaller src/hello/main.py; перевірити, що build/hello існує і
  його запуск друкує Hello, World!; при будь-якій помилці вийти з ненульовим кодом.
- scripts/build.bat: те саме для Windows (cmd): шукає py -3 або python, .venv\Scripts\python.exe,
  перевіряє errorlevel після кожного кроку, результат build\hello.exe, перевірка виводу.
- scripts/run.sh і scripts/run.bat: запускають build/hello (build\hello.exe), а якщо
  файлу немає, пишуть підказку запустити ci.sh / ci.bat.
- ci.sh (корінь): викликає scripts/build.sh і повертає його код виходу.
- ci.bat (корінь): call scripts\build.bat, exit /b %errorlevel%.

ПЕРЕВІРКИ: pytest проходить (тест test_basic_addition); існує build/hello або
build/hello.exe; build/ у .gitignore; скрипти повертають ненульовий код при падінні
тесту (як це перевірити: тимчасово змінити очікуване значення в тесті, і ця зміна
НЕ комітиться).

ТИПОВІ ПОМИЛКИ: pip не може встановити пакети (немає мережі); PyInstaller не знайдений
(не активовано .venv); на Windows ::ExecutionPolicy або шляхи з пробілами; у ci.sh немає
права на виконання (рекомендація: bash ci.sh). Для кожної: симптом, причина, дія.

ІДЕМПОТЕНТНІСТЬ: існуючі файли не перезаписуються, .venv не перестворюється, якщо
уже є.
```

</details>

### Запит 5 (2026-10-30 13:56 UTC): Skill github-actions

- Тривалість: 23 с; кредити Copilot: 0.36

<details><summary>Текст промпта</summary>

```text
Створи ОДИН файл: .github/skills/github-actions/SKILL.md. Більше нічого не створюй
і не запускай команд. Формат: Markdown із YAML frontmatter (name: github-actions,
description: одне речення). Українською. Розділи: Призначення, Коли застосовувати,
Вхідні дані (з прикладом), Вихідні файли, Кроки, Перевірки, Типовий сценарій помилки,
Ідемпотентність.

Зміст:
ПРИЗНАЧЕННЯ: створює .github/workflows/ci.yml.
ВХІД: назви гілок для тригерів (за замовчуванням develop і master); версія Python
(за замовчуванням 3.12). Приклад: branches=[develop, master], python=3.12.

ВИМОГИ ДО ci.yml, які skill має гарантувати:
- name: CI; on: push і pull_request для гілок develop і master;
- permissions: contents: read;
- одна job (build) із strategy.matrix.os: ubuntu-latest, windows-latest, macos-latest,
  fail-fast: false, runs-on: ${{ matrix.os }};
- кроки: actions/checkout@v4; actions/setup-python@v5 із python-version;
  крок для Linux/macOS: if: runner.os != 'Windows' і run: bash ci.sh;
  крок для Windows: if: runner.os == 'Windows', shell: cmd, run: ci.bat;
  actions/upload-artifact@v4 з name: hello-${{ matrix.os }}, path: build/hello* та
  if-no-files-found: error. Результат кожної job зрозумілий із назв кроків;
- УСЯ логіка збирання і тестування ТІЛЬКИ в ci.sh / ci.bat; у yml не має бути
  pip, pytest, pyinstaller чи інших команд збірки;
- жодних секретів, токенів чи змінних із секретами.

ПЕРЕВІРКИ: файл є валідним YAML (перевірка через python -c "import yaml; yaml.safe_load(open(...))"
в .venv); у matrix рівно три ОС; у файлі немає слів pytest, pyinstaller, pip install;
ci.sh і ci.bat існують у корені.

ТИПОВІ ПОМИЛКИ: ci.sh без прав виконання (рішення: виклик через bash); неправильний
відступ у YAML; відсутній ci.bat; артефакт не знайдено на Windows (hello.exe).
ІДЕМПОТЕНТНІСТЬ: якщо ci.yml існує і відповідає вимогам, пропустити; якщо відрізняється,
показати різницю і запитати.
```

</details>

### Запит 6 (2026-10-30 13:58 UTC): Commands git-init та create-project

- Тривалість: 22 с; кредити Copilot: 0.34

<details><summary>Текст промпта</summary>

```text
Створи ДВА файли в .github/prompts/: git-init.prompt.md і create-project.prompt.md.
Більше нічого не створюй і не запускай команд. Кожен файл: Markdown із YAML frontmatter
(description: одне речення; agent: build-engineer). Українською. Розділи в обох
файлах: ## Призначення, ## Передумови, ## Дії (пронумеровано), ## Очікувані файли,
## Команди перевірки, ## Повідомлення про помилку (таблиця «ситуація → текст
повідомлення → що робити»), ## Ідемпотентність.

git-init.prompt.md:
- Передумови: встановлено git; поточний каталог — корінь репозиторію або порожня папка.
- Дії: перевірити git rev-parse --is-inside-work-tree; якщо не репозиторій — виконати
  git init (і лише тоді); створити .gitignore або ДОПОВНИТИ його рядками .venv/, build/,
  dist/, __pycache__/, .pytest_cache/, *.spec, *.pyc, не дублюючи вже наявні; показати
  git status і git branch --show-current. Не виконувати commit, push, reset, clean.
- Очікувані файли: .gitignore.
- Команди перевірки: git status --short; перевірити, що кожен із обов'язкових рядків
  у .gitignore присутній рівно один раз.
- Помилки: git не встановлено; каталог не вдалося ініціалізувати.

create-project.prompt.md:
- Передумови: git-init виконано; Python 3 доступний (python3 --version або py -3 --version).
- Дії: викликати skill project-scaffold (.github/skills/project-scaffold/SKILL.md) із
  входом language=Python, project_name=hello; вивести перелік створених і пропущених
  файлів.
- Очікувані файли: src/hello/__init__.py, src/hello/main.py, README.md (якщо немає),
  tests/, docs/.
- Перевірка: запуск python src/hello/main.py друкує Hello, World!
- Помилки: Python не знайдено; main.py існує і відрізняється (не перезаписувати).
```

</details>

### Запит 7 (2026-10-30 13:59 UTC): Commands create-build та create-actions

- Тривалість: 23 с; кредити Copilot: 0.39

<details><summary>Текст промпта</summary>

```text
Створи ДВА файли в .github/prompts/: create-build.prompt.md і create-actions.prompt.md.
Більше нічого не створюй і не запускай команд. Формат кожного: Markdown із YAML
frontmatter (description; agent: build-engineer). Українською. Розділи: ## Призначення,
## Передумови, ## Дії (пронумеровано), ## Очікувані файли, ## Команди перевірки,
## Повідомлення про помилку (таблиця), ## Ідемпотентність.

create-build.prompt.md:
- Передумови: існує src/hello/main.py (інакше повідомити «спочатку виконайте /create-project»
  і зупинитись).
- Дії: викликати skill build-and-test (.github/skills/build-and-test/SKILL.md) і створити
  відсутні файли.
- Очікувані файли: requirements.txt, requirements-dev.txt, pytest.ini,
  tests/test_basic.py, scripts/build.sh, scripts/build.bat, scripts/run.sh,
  scripts/run.bat, ci.sh, ci.bat.
- Команди перевірки: bash ci.sh на Linux/macOS або ci.bat на Windows; перевірити, що
  pytest пройшов, тест test_basic_addition passed, існує build/hello (build/hello.exe).
- Помилки: немає main.py; pip не встановлює пакети; PyInstaller падає; тест падає
  (показати вивід і зупинитись, нічого не «виправляти» тихо).

create-actions.prompt.md:
- Передумови: існують ci.sh і ci.bat (інакше «спочатку /create-build»).
- Дії: викликати skill github-actions (.github/skills/github-actions/SKILL.md) і
  створити .github/workflows/ci.yml.
- Очікувані файли: .github/workflows/ci.yml.
- Команди перевірки: завантажити YAML через yaml.safe_load у .venv; переконатися, що
  matrix містить ubuntu-latest, windows-latest, macos-latest; у файлі немає pytest,
  pyinstaller, pip install, secrets.
- Помилки: відсутні ci-скрипти; YAML невалідний; ci.yml існує і відрізняється
  (не перезаписувати, показати різницю).
```

</details>

### Запит 8 (2026-10-30 14:00 UTC): Command check

- Тривалість: 24 с; кредити Copilot: 0.41

<details><summary>Текст промпта</summary>

```text
Створи ОДИН файл: .github/prompts/check.prompt.md. Більше нічого не створюй і не
запускай команд. Формат: Markdown із YAML frontmatter (description; agent: build-engineer).
Українською. Розділи: ## Призначення, ## Передумови, ## Дії, ## Очікувані файли,
## Команди перевірки, ## Повідомлення про помилку, ## Ідемпотентність.

КЛЮЧОВА ВИМОГА: команда check НЕ ЗМІНЮЄ відстежувані файли проєкту. Вона лише читає
файли і запускає перевірки. Перед початком зафіксуй git status --short, а після
завершення порівняй: вони мають збігатися. Дозволені побічні ефекти лише в
ігнорованих каталогах (.venv/, build/, .pytest_cache/).

Перевірки (кожна дає PASS або FAIL з коротким поясненням):
1. Manifest .github/agents/build-engineer.agent.md існує і містить розділи «Роль»,
   «Заборонені дії» і «Критерії успішного завершення».
2. Кожен із трьох skills (.github/skills/<name>/SKILL.md) існує і містить розділи про
   призначення, вхідні дані, вихідні файли, перевірки і сценарій помилки.
3. Усі 6 commands (git-init, create-project, create-build, create-actions, check, init)
   існують у .github/prompts/ і мають розділ «Повідомлення про помилку».
4. init.prompt.md викликає команди в порядку git-init → create-project → create-build →
   create-actions → check.
5. Структура проєкту: src/hello/main.py, tests/test_basic.py, requirements.txt,
   requirements-dev.txt, pytest.ini, scripts/build.sh, scripts/build.bat,
   scripts/run.sh, scripts/run.bat, ci.sh, ci.bat, .gitignore, README.md,
   docs/architecture.md, docs/usage.md.
6. Збірка і тести: запустити bash ci.sh (Linux/macOS) або ci.bat (Windows); очікується
   код виходу 0, тест test_basic_addition passed, існує build/hello (build/hello.exe).
7. .github/workflows/ci.yml: валідний YAML (python -c "import yaml...") у .venv;
   у matrix є ubuntu-latest, windows-latest і macos-latest; тригери push і pull_request
   для develop та master; у файлі немає pytest, pyinstaller і pip install.
8. Git-гігієна: git ls-files не містить build/, .venv/, dist/, __pycache__, .pytest_cache;
   у tracked-файлах немає токенів і паролів (пошук за шаблонами ghp_, password=, token=).
9. docs/ai-log.md існує і не порожній.

Вивід: таблиця «№ | Перевірка | PASS/FAIL | Пояснення». Якщо є хоча б один FAIL,
check завершується з повідомленням «CHECK FAILED» і переліком проблем та рекомендацій.
Інакше «CHECK PASSED». Команда ніколи не виправляє проблеми сама.
```

</details>

### Запит 9 (2026-10-30 14:01 UTC): Оркестратор init, docs/usage.md, docs/ai-log.md

- Тривалість: 26 с; кредити Copilot: 0.46

<details><summary>Текст промпта</summary>

```text
Створи ОДИН файл: .github/prompts/init.prompt.md. Більше нічого не створюй і не
запускай команд. Формат: Markdown із YAML frontmatter (description; agent: build-engineer).
Українською. Розділи: ## Призначення, ## Передумови, ## Порядок виконання,
## Обробка помилок, ## Підсумковий звіт, ## Ідемпотентність.

Це оркестратор. Він послідовно виконує такі commands за їхніми файлами:
1) .github/prompts/git-init.prompt.md
2) .github/prompts/create-project.prompt.md
3) .github/prompts/create-build.prompt.md
4) .github/prompts/create-actions.prompt.md
5) .github/prompts/check.prompt.md

Передумови: репозиторій відкрито в VS Code; Python 3 і git доступні.
Порядок: перед кожним кроком оголошуй «Крок N/5: <назва>»; передавай наступному кроку
результат попереднього (список створених і пропущених файлів, назву проєкту hello).
Обробка помилок: на першій помилці ЗУПИНИТИСЬ; вивести, який крок упав, причину, вивід
команди і рекомендацію; не продовжувати наступні кроки; не приховувати помилку, не
виправляти її тихо і не вважати роботу успішною без успішного check.
Підсумковий звіт: таблиця «крок | статус | створено | пропущено (вже існує)» та
результат check (CHECK PASSED/CHECK FAILED), та перелік команд, які користувач має
виконати вручну (перегляд змін, git add, git commit). Orchestrator сам НІКОЛИ не
робить commit, push, reset, force-push і не видаляє файли.
Ідемпотентність: повторний запуск init дає ті самі результати і не змінює файли,
що вже відповідають вимогам.

Далі створи ще ДВА файли (більше нічого):
1) docs/usage.md: точні кроки: відкрити репозиторій у VS Code → Copilot Chat → Agent mode
   → вибрати агента build-engineer → /init; як запускати окремі команди; як локально
   зібрати і перевірити (Linux/macOS: bash ci.sh; Windows: ci.bat); як запустити
   результат (./build/hello або build\hello.exe, очікуваний вивід Hello, World!);
   як запускати тести окремо (.venv/bin/python -m pytest; на Windows
   .venv\Scripts\python.exe -m pytest); як відтворити результат у гілці feature.
2) docs/ai-log.md: заголовок; таблиця з колонками «№ | Дата | Промпт (коротко) |
   Відповідь/результат | Проблема | Рішення»; порожні рядки для заповнення (не вигадуй
   записів); розділ «Помилки та їхнє виправлення» із шаблоном.
```

</details>

### Запит 10 (2026-11-03 11:14 UTC): `/init`

- Тривалість: 43 с; кредити Copilot: 1.44

<details><summary>Текст промпта</summary>

```text
/init
```

</details>

### Запит 11 (2026-11-03 11:17 UTC): Перейменування шести commands із суфіксом `-local`

- Тривалість: 121 с; кредити Copilot: 3.86

<details><summary>Текст промпта</summary>

```text
Команда /init конфліктує з вбудованою командою Copilot Chat (/init генерує
.github/copilot-instructions.md і перехоплює виклик). Потрібно перейменувати всі
шість команд агента, додавши суфікс -local.

Мапінг файлів у .github/prompts/ (перейменуй через git mv, інших команд у терміналі
не виконуй):
- git-init.prompt.md → git-init-local.prompt.md
- create-project.prompt.md → create-project-local.prompt.md
- create-build.prompt.md → create-build-local.prompt.md
- create-actions.prompt.md → create-actions-local.prompt.md
- check.prompt.md → check-local.prompt.md
- init.prompt.md → init-local.prompt.md

Після перейменування оновити ВСІ посилання на старі імена команд і файлів (і у формі
/init, і у формі init.prompt.md) у:
- .github/agents/build-engineer.agent.md (розділ «Доступні commands», порядок роботи);
- усіх шести файлах .github/prompts/ (зокрема init-local.prompt.md: шляхи до п'яти
  викликаних команд; check-local.prompt.md: перевірка існування шести команд за НОВИМИ
  іменами та перевірка порядку викликів в init-local);
- .github/skills/*/SKILL.md (де згадано, якою командою викликається skill);
- README.md, docs/architecture.md, docs/usage.md.

НЕ змінюй: docs/ai-log.md (це історичний журнал), логіку команд, структуру розділів,
імена skills та manifest-файлу. Не створюй нових файлів. Наприкінці покажи таблицю
«старе ім'я → нове ім'я» і перелік файлів, у яких змінено посилання, а також
виконай пошук по репозиторію і підтверди, що не лишилось жодного посилання на старі
імена (/init без -local, git-init.prompt.md тощо).
```

</details>

### Запит 12 (2026-11-03 11:22 UTC): `/init-local` (перший запуск)

- Тривалість: 256 с; кредити Copilot: 4.26

<details><summary>Текст промпта</summary>

```text
/init-local
```

</details>

### Запит 13 (2026-11-03 11:28 UTC): `/check-local`

- Тривалість: 65 с; кредити Copilot: 2.29

<details><summary>Текст промпта</summary>

```text
/check-local
```

</details>

### Запит 14 (2026-11-03 11:38 UTC): Виправлення init-local

- Тривалість: 26 с; кредити Copilot: 2.38

<details><summary>Текст промпта</summary>

```text
Команда /check-local повернула FAIL на перевірці №3 (Commands): у
.github/prompts/init-local.prompt.md немає розділу «## Повідомлення про помилку»,
який вимагається для всіх шести commands. Причина: при створенні init-local цей
розділ не був вказаний у переліку обов'язкових.

Зміни ЛИШЕ файл .github/prompts/init-local.prompt.md: додай розділ
«## Повідомлення про помилку» після розділу «## Обробка помилок».
Формат такий самий, як в інших commands: таблиця «ситуація → текст повідомлення →
що робити». Рядки таблиці:
- Передумови не виконано (немає git або Python 3): текст і яку дію виконати;
- Крок git-init-local завершився помилкою;
- Крок create-project-local завершився помилкою;
- Крок create-build-local завершився помилкою (зокрема падіння тестів або збірки);
- Крок create-actions-local завершився помилкою;
- check-local повернув CHECK FAILED (перелічити проблеми, не виправляти їх автоматично).
Для кожного рядка вкажи, який крок упав, і що наступні кроки не виконуються.

Не змінюй інші розділи, інші файли, логіку оркестратора і порядок викликів.
Не створюй нових файлів, не запускай команд у терміналі. Наприкінці покажи
diff змін.
```

</details>

### Запит 15 (2026-11-03 11:44 UTC): Виправлення .gitignore та інструкцій

- Тривалість: 60 с; кредити Copilot: 4.00

<details><summary>Текст промпта</summary>

```text
У репозиторії файли __pycache__/*.pyc (src/hello/__pycache__, tests/__pycache__)
відображаються як untracked і не ігноруються Git, хоча інструкції агента вимагають,
щоб .gitignore містив __pycache__/ і *.pyc.

1. Прочитай поточний .gitignore і поясни, яких обов'язкових рядків бракує
   (.venv/, build/, dist/, __pycache__/, .pytest_cache/, *.spec, *.pyc).
2. Додай лише відсутні рядки, не дублюючи наявні і не видаляючи нічого.
3. Перевір у .github/skills/project-scaffold/SKILL.md та
   .github/prompts/git-init-local.prompt.md, чому ці рядки не потрапили у .gitignore
   при генерації, і виправ інструкції так, щоб це не повторилось.
4. У .github/prompts/check-local.prompt.md розшир перевірку «Git-гігієна»: окрім
   git ls-files, перевіряти, що git status --short не містить untracked-файлів
   __pycache__, *.pyc, .venv, build, .pytest_cache (тобто вони ігноруються).
Покажи diff. Інших файлів не чіпай, команд у терміналі не виконуй.
```

</details>

### Запит 16 (2026-11-03 11:57 UTC): `/init-local` (повторний)

- Тривалість: 129 с; кредити Copilot: 1.65

<details><summary>Текст промпта</summary>

```text
/init-local
```

</details>

### Запит 17 (2026-11-03 12:03 UTC): `/check-local`

- Тривалість: 157 с; кредити Copilot: 1.82

<details><summary>Текст промпта</summary>

```text
/check-local
```

</details>

### Запит 18 (2026-11-03 12:07 UTC): `/init-local` (третій)

- Тривалість: 21 с; кредити Copilot: 0.56

<details><summary>Текст промпта</summary>

```text
/init-local
```

</details>

### Запит 19 (2026-11-03 12:08 UTC): `/init-local` (четвертий)

- Тривалість: 240 с; кредити Copilot: 1.81

<details><summary>Текст промпта</summary>

```text
/init-local
```

</details>

### Запит 20 (2026-11-03 13:11 UTC): `/check-local`

- Тривалість: 81 с; кредити Copilot: 2.34

<details><summary>Текст промпта</summary>

```text
/check-local
```

</details>

### Запит 21 (2026-11-03 13:17 UTC): Заповнення розділу «Результати CI» в README

- Тривалість: 17 с; кредити Copilot: 1.73

<details><summary>Текст промпта</summary>

```text
У README.md розділ «## 8. Результати CI» містить лише заглушку «Розділ про результати
CI заповнюється після успішних запусків GitHub Actions». Заміни вміст цього розділу
(заголовок залиш) на фактичні результати. Використовуй ТІЛЬКИ наведені нижче дані,
нічого не вигадуй і не змінюй інші розділи README та інші файли.

Дані:
- Workflow: CI (.github/workflows/ci.yml), тригери: push і pull_request до develop та master.
- Успішний запуск для PR lab1/finish (#1), гілка feature/hello-python:
  https://github.com/gthb-lab/csad_KI402_SmolynskyiRB_v2/actions/runs/41637297291
- Job (matrix): ubuntu-latest: успішно, 30 с; windows-latest: успішно, 40 с;
  macos-latest: успішно, 25 с. Загальна тривалість запуску 44 с.
- Артефакти (виконуваний файл hello): hello-ubuntu-latest, hello-windows-latest,
  hello-macos-latest.
- На кожній ОС ci.sh / ci.bat виконують збірку, тести pytest (2 тести пройдено) і
  створюють build/hello (build\hello.exe на Windows).

Оформи українською у вигляді короткого опису та таблиці «ОС | Статус | Тривалість |
Артефакт». Додай посилання на запуск. Команд у терміналі не виконуй.
```

</details>
