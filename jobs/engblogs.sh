#!/bin/sh

set -eu

PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH

mkdir -p "$HOME/.cron"
exec > "$HOME/.cron/engblogs.log" 2>&1

printf 'Started: %s\n' "$(date)"
cd "$HOME/Documents/code/websites/engblogs.dev/scripts"
exec uv run hourly.py
