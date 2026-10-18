#!/usr/bin/env bash
set -euo pipefail
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m pytest
.venv/bin/pyinstaller --noconfirm --onefile --name hello --distpath dist --workpath build --specpath build src/hello.py
test -f dist/hello
output=$(dist/hello)
test "$output" = 'Hello, World!'
