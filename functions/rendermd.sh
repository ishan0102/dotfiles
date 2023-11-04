#!/bin/bash

# Refresh a Markdown file on a timer
function rendermd() {
    # Check if the input file has a .md extension
    if [[ "$1" != *.md ]]; then
        echo "Error: input file must have a .md extension."
        return 1
    fi

    # Keep calling the glow command to rerender the file until user is done
    while true; do
        clear && printf '\e[3J' # clear scrollback buffer
        sed 's/->/\&rarr;/g' "$1" > _rendering.md # add fancy arrows for rendering
        glow "_rendering.md"
        sleep 5
    done
    rm _rendering.md
}