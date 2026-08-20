#!/bin/sh

set -eu

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
dotfiles_root=$(CDPATH='' cd -- "$script_dir/.." && pwd)
profile=${1:-}

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

check_target() {
  source_path=$1
  target_path=$2

  if [ -L "$target_path" ]; then
    current_source=$(readlink "$target_path")
    if [ "$current_source" != "$source_path" ]; then
      printf 'Conflict: %s points to %s\n' "$target_path" "$current_source" >&2
      return 1
    fi
  elif [ -e "$target_path" ]; then
    printf 'Conflict: %s already exists\n' "$target_path" >&2
    return 1
  fi
}

create_link() {
  source_path=$1
  target_path=$2

  if [ -L "$target_path" ]; then
    printf 'Keep: %s\n' "$target_path"
    return
  fi

  mkdir -p "$(dirname -- "$target_path")"
  ln -s "$source_path" "$target_path"
  printf 'Link: %s -> %s\n' "$target_path" "$source_path"
}

link_set() {
  action=$1

  "$action" "$dotfiles_root/shell/zsh/.zshrc" "$HOME/.zshrc"
  "$action" "$dotfiles_root/shell/bash/.bashrc" "$HOME/.bashrc"
  "$action" "$dotfiles_root/shell/bash/.bash_profile" "$HOME/.bash_profile"
  "$action" "$dotfiles_root/git/.gitconfig" "$HOME/.gitconfig"
  "$action" "$dotfiles_root/git/.gitignore_global" "$HOME/.gitignore_global"
  "$action" "$dotfiles_root/terminal/.inputrc" "$HOME/.inputrc"
  "$action" "$dotfiles_root/terminal/.tmux.conf" "$HOME/.tmux.conf"
  "$action" "$dotfiles_root/terminal/.tigrc" "$HOME/.tigrc"
  "$action" "$dotfiles_root/packages/.npmrc" "$HOME/.npmrc"
  "$action" "$dotfiles_root/editors/vim/.vimrc" "$HOME/.vimrc"
  "$action" "$dotfiles_root/editors/vim/colors" "$HOME/.vim/colors"

  if [ "$profile" = mac ]; then
    "$action" "$dotfiles_root/shell/bash/.hushlogin" "$HOME/.hushlogin"
    "$action" "$dotfiles_root/terminal/ghostty/config" "$HOME/.config/ghostty/config"
  fi
}

# Check every target before the script creates the first link.
link_set check_target
link_set create_link

mkdir -p "$HOME/.vim/backups" "$HOME/.vim/swaps" "$HOME/.vim/undo"

printf '\nCreate private local files from the examples only after review:\n'
printf '  %s\n' "$dotfiles_root/shell/zsh/.zshrc.local.example"
printf '  %s\n' "$dotfiles_root/shell/bash/.bashrc.local.example"
printf '  %s\n' "$dotfiles_root/git/.gitconfig.local.example"
