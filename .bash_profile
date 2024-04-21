#!/bin/bash

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load the shell dotfiles
for file in ~/.{bash_prompt,exports,aliases,extras}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Now handle the .functions directory separately
if [ -d ~/.functions ]; then
    for func in ~/.functions/*; do
        if [ -r "$func" ] && [ -f "$func" ]; then
            source "$func"
        fi
    done
fi

unset file

# Disable mouse acceleration
defaults write .GlobalPreferences com.apple.mouse.scaling -1

# Node version manager
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

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

# GitHub Copilot CLI
eval "$(github-copilot-cli alias -- "$0")"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind 'set bell-style none'

# Created by `pipx` on 2024-03-16 22:56:40
export PATH="$PATH:/Users/ishanshah/.local/bin"
