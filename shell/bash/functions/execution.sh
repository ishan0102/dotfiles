#!/bin/bash

# These functions work with bash-preexec. GNU date gives precise results on
# this Mac. Other systems can use whole seconds without extra software.
dotfiles_bash_timestamp() {
  if command -v gdate >/dev/null 2>&1; then
    gdate +%s.%N
  else
    date +%s
  fi
}

preexec() {
  dotfiles_command_started=$(dotfiles_bash_timestamp)
}

precmd() {
  [ -n "${dotfiles_command_started:-}" ] || return

  dotfiles_command_finished=$(dotfiles_bash_timestamp)
  awk -v start="$dotfiles_command_started" -v finish="$dotfiles_command_finished" \
    'BEGIN { printf "Execution time: %.2fs\n", finish - start }'
  unset dotfiles_command_finished dotfiles_command_started
}
