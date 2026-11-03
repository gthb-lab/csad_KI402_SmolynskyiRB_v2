#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -x "build/hello" ]; then
    echo "build/hello not found. Run bash ci.sh first." >&2
    exit 1
fi

./build/hello
