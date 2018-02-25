# dotfiles
My dotfiles

## Install dependencies
```bash
# Mac
brew install git stow

# Debian
apt-get install git stow
```

## Setup
Clone latest dotfiles
```bash
git clone https://gitlab.com/cynja/dotfiles.git ~/.dotfiles
```

## Activate configs
```bash
cd ~/.dotfiles
./init.sh

# Enable iterm config
# Note: ~/.dotfiles/google gets synced with Google Drive
defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "$HOME/.dotfiles/google/iterm"
defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
```