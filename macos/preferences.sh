#!/bin/sh

set -eu

# Keyboard
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string clmv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Dock
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 85
defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock show-process-indicators -bool false

# Trackpad tap-to-click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

printf '%s\n' 'Preferences written. Log out and in again to apply all changes.'
