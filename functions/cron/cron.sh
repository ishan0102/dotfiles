#!/bin/bash
# Run cron jobs and log outputs to ~/Desktop/cronlogs

# Ensure logs folder exists
mkdir -p ~/cron

# Run rsrch.space job
cd ~/Documents/code/websites/rsrch.space/scripts
/opt/homebrew/bin/uv run --python .venv/bin/python main.py > ~/cron/rsrch.log 2>&1

# Run engblogs.dev job
cd ~/Documents/code/websites/engblogs.dev/scripts
/opt/homebrew/bin/uv run hourly.py > ~/cron/engblogs.log 2>&1
