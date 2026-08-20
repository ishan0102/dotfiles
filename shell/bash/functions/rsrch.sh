# shellcheck shell=bash

rsrch() {
    local project_dir="$HOME/Documents/code/websites/rsrch.space/scripts"
    if [ ! -d "$project_dir" ]; then
        printf 'rsrch: directory not found: %s\n' "$project_dir" >&2
        return 1
    fi

    cd "$project_dir" || return
    uv run --python .venv/bin/python main.py "$@"
}
