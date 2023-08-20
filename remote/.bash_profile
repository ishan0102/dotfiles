#!/bin/bash

# Load the shell dotfiles
for file in ~/.{bash_prompt,exports,aliases,functions,extras}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Enable git branch name completion.
# curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
# Autocomplete git aliases
__git_complete gk git_checkout
__git_complete gb git_branch
__git_complete gd git_diff
__git_complete g git

# Append to the history file, don't overwrite it
shopt -s histappend

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
