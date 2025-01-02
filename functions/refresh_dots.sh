#!/bin/bash

# Refresh dotfiles repo
function refresh_dots() {
  # Go to root
  cd ~

  # Refresh Brewfile
  rm -f Brewfile
  HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump

  # Copy main dotfiles
  cp .bash_prompt .bash_profile .bashrc .aliases .exports .gitconfig .gitignore_global .git-completion.bash .bash-preexec.sh .hushlogin .inputrc .vimrc Brewfile .tmux.conf Documents/code/dotfiles

  # Copy the .functions directory
  cp -R .functions/ Documents/code/dotfiles/functions

  # VSCode
  cp ~/Library/Application\ Support/Code/User/{settings.json,keybindings.json} Documents/code/dotfiles/vscode
  cp -R ~/Library/Application\ Support/Code/User/snippets Documents/code/dotfiles/vscode
  cp ~/.vscode/extensions/extensions.json Documents/code/dotfiles/vscode

	# Ghostty
	cp .config/ghostty/config Documents/code/dotfiles/.config/ghostty

  # Go to dotfiles folder
  cd ~/Documents/code/dotfiles
}