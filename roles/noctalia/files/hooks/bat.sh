#!/usr/bin/env bash
# Rebuild bat's theme cache after Noctalia renders the Noctalia tmTheme.
set -euo pipefail

if command -v bat >/dev/null 2>&1; then
    bat cache --build >/dev/null
elif command -v batcat >/dev/null 2>&1; then
    batcat cache --build >/dev/null
else
    echo "bat is not installed; skipping theme cache rebuild" >&2
fi
