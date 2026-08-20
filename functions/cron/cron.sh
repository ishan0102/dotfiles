#!/bin/bash
# Run cron jobs and log outputs to ~/.cron

set -e

# Cron starts with a minimal PATH, so include user and Homebrew binaries.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Ensure logs folder exists
mkdir -p "$HOME/.cron"

# Run rsrch.space job
cd "$HOME/Documents/code/websites/rsrch.space/scripts"
uv run --python .venv/bin/python main.py > "$HOME/.cron/rsrch.log" 2>&1

# Run engblogs.dev job
cd "$HOME/Documents/code/websites/engblogs.dev/scripts"
uv run hourly.py > "$HOME/.cron/engblogs.log" 2>&1
