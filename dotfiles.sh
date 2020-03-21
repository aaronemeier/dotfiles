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
    install ansible
    install beets
    install cheat
    install git
    install gnupg
    install postgres
    install ssh
    install vscode
fi