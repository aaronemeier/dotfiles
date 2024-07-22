#!/bin/bash

cd ~/.dotfiles

install(){
    stow -v1 "$1"
}

install shell
install bash
install zsh
install bin
install tmux
install vim

if [ "$(uname)" == 'Darwin' ]; then
    mkdir -p ~/.gnupg && chmod 0700 ~/.gnupg && install gnupg
    mkdir -p ~/.ssh && chmod 0700 ~/.ssh && install ssh

    install ansible
    install beets
    install cheat
    install git
    install postgres
    install work
    install ideavim
    install starship
fi
