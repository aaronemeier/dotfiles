#!/bin/bash

cd ~/.dotfiles

stow shell
stow bash
stow zsh
stow bin
stow dircolors
stow tmux
stow vim

if [ "$(uname)" == 'Darwin' ]; then
    stow ansible
    stow beets
    stow cheat
    stow git
    stow gnupg
    stow postgres
    stow ssh
    stow vscode
    defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string "$HOME/.dotfiles/google/iterm"
    defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
fi