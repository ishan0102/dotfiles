#!/bin/bash

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load the shell dotfiles
for file in ~/.{bash_prompt,exports,extras,aliases}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Set up preexec
source ~/.bash-preexec.sh

# Now handle the .functions directory separately
if [ -d ~/.functions ]; then
    for func in ~/.functions/*; do
        if [ -r "$func" ] && [ -f "$func" ]; then
            source "$func"
        fi
    done
fi
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

# z beats cd most of the time. `brew install z`
if which brew > /dev/null; then
    zpath="$(brew --prefix)/etc/profile.d/z.sh"
    [ -s $zpath ] && source $zpath
fi;

# Disable terminal sounds
bind 'set bell-style none'

# Created by `pipx` on 2024-11-04 03:03:00
export PATH="$PATH:/Users/ishanshah/.local/bin"
