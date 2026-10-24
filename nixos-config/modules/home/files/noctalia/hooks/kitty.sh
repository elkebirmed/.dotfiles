#!/usr/bin/env bash
# Reload running kitty windows after Noctalia renders kitty-colors.conf.
# SIGUSR1 is kitty's documented "reload config" signal; it re-reads kitty.conf
# and its includes (the rendered colors) without restarting the terminal or
# disturbing child processes. Safe and idempotent when no kitty is running.
set -euo pipefail

if command -v kitty >/dev/null 2>&1; then
    # -x matches the exact process name so only kitty instances are signalled.
    # || true: pkill exits non-zero when nothing matched (e.g. no kitty running).
    pkill -USR1 -x kitty 2>/dev/null || true
fi
