# shellcheck shell=bash

# Only run for interactive shells.
[[ $- != *i* ]] && return

# Resolve this file through the ~/.bashrc link. Other Bash files can then load
# from the repository. No extra links such as ~/.aliases are necessary.
dotfiles_bash_source=${BASH_SOURCE[0]}
while [ -L "$dotfiles_bash_source" ]; do
    dotfiles_bash_dir=$(cd -P "$(dirname "$dotfiles_bash_source")" >/dev/null 2>&1 && pwd)
    dotfiles_bash_link=$(readlink "$dotfiles_bash_source")
    case "$dotfiles_bash_link" in
        /*) dotfiles_bash_source=$dotfiles_bash_link ;;
        *) dotfiles_bash_source=$dotfiles_bash_dir/$dotfiles_bash_link ;;
    esac
done
DOTFILES_BASH_ROOT=$(cd -P "$(dirname "$dotfiles_bash_source")" >/dev/null 2>&1 && pwd)
DOTFILES_ROOT=$(cd "$DOTFILES_BASH_ROOT/../.." >/dev/null 2>&1 && pwd)
export DOTFILES_ROOT
unset dotfiles_bash_dir dotfiles_bash_link dotfiles_bash_source

# Select safe defaults before the private local file loads.
case "${DOTFILES_PROFILE:-}" in
    mac|remote) ;;
    '')
        if [ "$(uname -s)" = Darwin ]; then
            DOTFILES_PROFILE=mac
        else
            DOTFILES_PROFILE=remote
        fi
        ;;
    *)
        printf 'dotfiles: unknown Bash profile: %s\n' "$DOTFILES_PROFILE" >&2
        DOTFILES_PROFILE=remote
        ;;
esac
DOTFILES_LOAD_WORK=${DOTFILES_LOAD_WORK:-0}
[ -r "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
export DOTFILES_PROFILE DOTFILES_LOAD_WORK

# Initialize Homebrew if it exists but is not on PATH.
if ! command -v brew >/dev/null 2>&1; then
    for dotfiles_brew_bin in \
        /opt/homebrew/bin/brew \
        /usr/local/bin/brew \
        /home/linuxbrew/.linuxbrew/bin/brew; do
        if [ -x "$dotfiles_brew_bin" ]; then
            eval "$("$dotfiles_brew_bin" shellenv)"
            break
        fi
    done
    unset dotfiles_brew_bin
fi

source "$DOTFILES_BASH_ROOT/environment"
source "$DOTFILES_BASH_ROOT/aliases"

for dotfiles_function in "$DOTFILES_BASH_ROOT"/functions/*.sh; do
    # shellcheck disable=SC1090
    [ -r "$dotfiles_function" ] && source "$dotfiles_function"
done
unset dotfiles_function

if [ "$DOTFILES_LOAD_WORK" = 1 ]; then
    source "$DOTFILES_BASH_ROOT/work/environment"
    [ -r "$HOME/.extras" ] && source "$HOME/.extras"
    source "$DOTFILES_BASH_ROOT/work/aliases"
    [ -r "$HOME/.bash_completions/hpn-agent.sh" ] && source "$HOME/.bash_completions/hpn-agent.sh"

    for dotfiles_function in "$DOTFILES_BASH_ROOT"/work/functions/*.sh; do
        # shellcheck disable=SC1090
        [ -r "$dotfiles_function" ] && source "$dotfiles_function"
    done
    unset dotfiles_function
fi

source "$DOTFILES_BASH_ROOT/prompt"
source "$DOTFILES_BASH_ROOT/third-party/git-completion.sh"

if type __git_complete >/dev/null 2>&1; then
    __git_complete g git
    __git_complete gb git_branch
    __git_complete gd git_diff
    __git_complete gk git_checkout
fi

# Append commands to history. Do not replace history from another shell.
shopt -s histappend

# Load z if it is installed.
for dotfiles_z_script in \
    /opt/homebrew/etc/profile.d/z.sh \
    /usr/local/etc/profile.d/z.sh \
    /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh; do
    if [ -r "$dotfiles_z_script" ]; then
        # shellcheck disable=SC1090
        source "$dotfiles_z_script"
        break
    fi
done
unset dotfiles_z_script

# fzf supplies Ctrl-R history search, Ctrl-T file search, and Alt-C directory search.
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"

bind 'set bell-style none'

# Load this file last. Its hooks must not change completion or startup scripts.
source "$DOTFILES_BASH_ROOT/third-party/bash-preexec.sh"
