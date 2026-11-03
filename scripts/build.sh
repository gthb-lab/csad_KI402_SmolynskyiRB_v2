#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if command -v python3 >/dev/null 2>&1; then
    PYTHON=python3
elif command -v python >/dev/null 2>&1; then
    PYTHON=python
else
    echo "Python 3 not found. Install Python 3 and add it to PATH." >&2
    exit 1
fi

if [ ! -x ".venv/bin/python" ]; then
    "$PYTHON" -m venv .venv
fi

.venv/bin/python -m pip install -r requirements.txt -r requirements-dev.txt
.venv/bin/python -m pytest

rm -rf build
.venv/bin/python -m PyInstaller \
    --onefile \
    --name hello \
    --paths src \
    --distpath build \
    --workpath build/pyinstaller/work \
    --specpath build/pyinstaller \
    src/hello/main.py

if [ ! -x "build/hello" ]; then
    echo "Build failed: build/hello was not created." >&2
    exit 1
fi

OUTPUT="$(./build/hello)"
if [ "$OUTPUT" != "Hello, World!" ]; then
    echo "Unexpected build/hello output: $OUTPUT" >&2
    exit 1
fi
