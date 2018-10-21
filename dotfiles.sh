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

    
fi