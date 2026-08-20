# Load the zsh modules from this repository.

# Resolve the repository through the ~/.zshrc link.
typeset -g DOTFILES_ZSH_ROOT="${${(%):-%N}:A:h}"
typeset -g DOTFILES_ROOT="${DOTFILES_ZSH_ROOT:h:h}"

# Select a safe profile before private machine settings load.
if [[ -z "${DOTFILES_PROFILE:-}" ]]; then
  if [[ "$OSTYPE" == darwin* ]]; then
    DOTFILES_PROFILE=mac
  else
    DOTFILES_PROFILE=remote
  fi
fi
DOTFILES_LOAD_WORK="${DOTFILES_LOAD_WORK:-0}"

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

case "$DOTFILES_PROFILE" in
  mac|remote) ;;
  *)
    print -u2 "dotfiles: unknown zsh profile: $DOTFILES_PROFILE"
    DOTFILES_PROFILE=remote
    ;;
esac

case "$DOTFILES_LOAD_WORK" in
  0|1) ;;
  *)
    print -u2 'dotfiles: DOTFILES_LOAD_WORK must be 0 or 1'
    DOTFILES_LOAD_WORK=0
    ;;
esac
export DOTFILES_PROFILE DOTFILES_LOAD_WORK DOTFILES_ROOT

zsh_modules=(environment)
[[ "$DOTFILES_LOAD_WORK" == 1 ]] && zsh_modules+=(work/environment)
zsh_modules+=(aliases)
[[ "$DOTFILES_LOAD_WORK" == 1 ]] && zsh_modules+=(work/aliases)
zsh_modules+=(functions)
[[ "$DOTFILES_LOAD_WORK" == 1 ]] && zsh_modules+=(work/functions)
zsh_modules+=(prompt)
for zsh_module in "${zsh_modules[@]}"; do
  source "$DOTFILES_ZSH_ROOT/$zsh_module"
done
unset zsh_module zsh_modules

# fzf provides Ctrl-R history search plus file and directory widgets.
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
fi
