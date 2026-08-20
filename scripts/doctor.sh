#!/bin/sh

set -u

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
dotfiles_root=$(CDPATH='' cd -- "$script_dir/.." && pwd)
profile=${1:-}
failures=0
warnings=0

PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH

if [ -z "$profile" ]; then
  if [ "$(uname -s)" = Darwin ]; then
    profile=mac
  else
    profile=remote
  fi
fi

case "$profile" in
  mac|remote) ;;
  *)
    printf 'Usage: %s [mac|remote]\n' "$0" >&2
    exit 2
    ;;
esac

pass() {
  printf 'PASS  %s\n' "$1"
}

fail() {
  printf 'FAIL  %s\n' "$1"
  failures=$((failures + 1))
}

warn() {
  printf 'WARN  %s\n' "$1"
  warnings=$((warnings + 1))
}

check_link() {
  source_path=$1
  target_path=$2

  if [ ! -L "$target_path" ]; then
    fail "$target_path is not a link"
    return
  fi

  current_source=$(readlink "$target_path")
  if [ "$current_source" = "$source_path" ] && [ -e "$target_path" ]; then
    pass "$target_path"
  else
    fail "$target_path points to $current_source"
  fi
}

check_mode() {
  target_path=$1
  expected_mode=$2

  if [ ! -e "$target_path" ]; then
    warn "$target_path is missing"
    return
  fi

  if mode=$(stat -f '%Lp' "$target_path" 2>/dev/null); then
    :
  else
    mode=$(stat -c '%a' "$target_path" 2>/dev/null) || {
      warn "cannot read the mode for $target_path"
      return
    }
  fi

  if [ "$mode" = "$expected_mode" ]; then
    pass "$target_path mode $expected_mode"
  else
    fail "$target_path mode is $mode; expected $expected_mode"
  fi
}

check_command() {
  command_name=$1
  if command -v "$command_name" >/dev/null 2>&1; then
    pass "$command_name is available"
  else
    warn "$command_name is not available"
  fi
}

check_common_links() {
  check_link "$dotfiles_root/shell/zsh/.zshrc" "$HOME/.zshrc"
  check_link "$dotfiles_root/git/.gitconfig" "$HOME/.gitconfig"
  check_link "$dotfiles_root/git/.gitignore_global" "$HOME/.gitignore_global"
  check_link "$dotfiles_root/terminal/.inputrc" "$HOME/.inputrc"
  check_link "$dotfiles_root/terminal/.tmux.conf" "$HOME/.tmux.conf"
  check_link "$dotfiles_root/terminal/.tigrc" "$HOME/.tigrc"
  check_link "$dotfiles_root/packages/.npmrc" "$HOME/.npmrc"
  check_link "$dotfiles_root/editors/vim/.vimrc" "$HOME/.vimrc"
  check_link "$dotfiles_root/editors/vim/colors" "$HOME/.vim/colors"
}

printf 'Dotfiles doctor: %s profile\n\n' "$profile"

check_common_links
if [ "$profile" = mac ]; then
  check_link "$dotfiles_root/shell/bash/.hushlogin" "$HOME/.hushlogin"
  check_link "$dotfiles_root/terminal/ghostty/config" "$HOME/.config/ghostty/config"
else
  check_link "$dotfiles_root/shell/bash/.bashrc" "$HOME/.bashrc"
  check_link "$dotfiles_root/shell/bash/.bash_profile" "$HOME/.bash_profile"
fi

printf '\nPrivate file modes\n'
check_mode "$HOME/.zshrc.local" 600
[ "$profile" = remote ] && check_mode "$HOME/.bashrc.local" 600
check_mode "$HOME/.gitconfig.local" 600
check_mode "$HOME/.local/state/zsh/history" 600
[ -d "$HOME/.aws" ] && check_mode "$HOME/.aws" 700

printf '\nSyntax\n'
if zsh -n \
  "$dotfiles_root/shell/zsh/.zshrc" \
  "$dotfiles_root/shell/zsh/environment" \
  "$dotfiles_root/shell/zsh/aliases" \
  "$dotfiles_root/shell/zsh/functions" \
  "$dotfiles_root/shell/zsh/prompt" \
  "$dotfiles_root/shell/zsh/work/environment" \
  "$dotfiles_root/shell/zsh/work/aliases" \
  "$dotfiles_root/shell/zsh/work/functions"; then
  pass 'zsh files'
else
  fail 'zsh files'
fi

if bash -n \
  "$dotfiles_root/shell/bash/.bash_profile" \
  "$dotfiles_root/shell/bash/.bashrc" \
  "$dotfiles_root/shell/bash/environment" \
  "$dotfiles_root/shell/bash/aliases" \
  "$dotfiles_root/shell/bash/prompt" \
  "$dotfiles_root/shell/bash/work/environment" \
  "$dotfiles_root/shell/bash/work/aliases" \
  "$dotfiles_root"/shell/bash/functions/*.sh \
  "$dotfiles_root"/shell/bash/third-party/*.sh; then
  pass 'Bash files'
else
  fail 'Bash files'
fi

if sh -n "$dotfiles_root"/jobs/*.sh "$dotfiles_root/macos/preferences.sh"; then
  pass 'job and macOS scripts'
else
  fail 'job and macOS scripts'
fi

printf '\nTools\n'
for command_name in git zsh bash fzf rg tmux uv; do
  check_command "$command_name"
done

if [ "$profile" = mac ]; then
  [ -d "$HOME/Documents/code/websites/rsrch.space/scripts" ] || warn 'rsrch job directory is missing'
  [ -d "$HOME/Documents/code/websites/engblogs.dev/scripts" ] || warn 'engblogs job directory is missing'

  if command -v rustc >/dev/null 2>&1; then
    if ! /bin/sh -c 'rustc --version >/dev/null 2>&1' >/dev/null 2>&1; then
      warn 'Rust is installed but cannot start'
    fi
  fi
fi

printf '\nResult: %d failure(s), %d warning(s)\n' "$failures" "$warnings"
[ "$failures" -eq 0 ]
