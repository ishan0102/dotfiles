# Only run for interactive shells
[[ $- != *i* ]] && return

# fzf — ctrl+R fuzzy history, ctrl+T file picker, alt+C cd picker
eval "$(fzf --bash)"

# Disable terminal sounds
bind 'set bell-style none'