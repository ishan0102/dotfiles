#!/bin/bash

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load shell dotfiles
for file in ~/.{bash_prompt,exports,extras,aliases}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Set up preexec
[ -f ~/.bash-preexec.sh ] && source ~/.bash-preexec.sh

# Set up completions
[ -f ~/.bash_completions/hpn-agent.sh ] && source ~/.bash_completions/hpn-agent.sh

# Load functions
if [ -d ~/.functions ]; then
    for func in ~/.functions/*; do
        [ -r "$func" ] && [ -f "$func" ] && source "$func"
    done
fi
unset file

# Enable git branch name completion
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

# Autocomplete git aliases
type __git_complete &>/dev/null && {
    __git_complete gk git_checkout
    __git_complete gb git_branch
    __git_complete gd git_diff
    __git_complete g git
}

# Append to the history file, don't overwrite it
shopt -s histappend

# z beats cd most of the time. `brew install z`
if command -v brew >/dev/null 2>&1; then
    zpath="$(brew --prefix)/etc/profile.d/z.sh"
    [ -s "$zpath" ] && source "$zpath"
fi

# Load interactive bash config
[ -f ~/.bashrc ] && source ~/.bashrc
export PATH="/Users/ishanshah/.revyl/bin:$PATH"
