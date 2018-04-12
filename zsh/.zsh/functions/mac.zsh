#!/bin/zsh
# Functions for zsh on mac

if [[ "$(uname)" != 'Darwin' ]]; then
    echo "Not on a mac"
    return
fi

zsh-update-system() {
    zsh-update-mas
    zsh-update-brew
}

zsh-update() {
    zsh-update-system
    zsh-update-npm
    zsh-update-python
    zsh-update-vscode
}

zsh-update-vscode(){
    echo -e '\e[1mUpdating vscode extensions\e[0m\n'
    while read extension
    do
        code --install-extension "$extension"
    done < "$HOME/.setup/vscode-extensions"
}

zsh-sign-wm(){
    codesign -fs "chunkwm-khd-cert" /usr/local/opt/chunkwm/bin/chunkwm
    codesign -fs "chunkwm-khd-cert" /usr/local/opt/khd/bin/khd
}

zsh-update-mas() {
    echo -e '\e[1mUpdating App Store apps\e[0m\n'
    mas upgrade
}

zsh-update-brew() {
    echo -e '\e[1mUpdating Homebrew packages\e[0m\n'
    # Brew
    brew update
    brew upgrade
    brew cleanup --outdated

    # Casks
    brew cask upgrade
    brew cask cleanup --outdated
}

zsh-update-npm() {
    if [ -x "$(command -v npm)" ]; then
        echo -e '\e[1mUpdating globally installed npm packages\e[0m\n'
        npm update -g
    fi
}

zsh-update-python() {
    if [ -x "$(command -v pip2)" ]; then
        echo -e '\e[1mUpdating pip2 packages\e[0m\n'
        (for pkg in $(gpip2 list --outdated --format=legacy | cut -d' ' -f1); do
            gpip2 install --user --upgrade $pkg;
        done) &
        python_pid="$!"
    fi
    if [ -x "$(command -v pip3)" ]; then
        echo -e '\e[1mUpdating pip3 packages\e[0m\n'
        (for pkg in $(gpip list --outdated --format=legacy | cut -d' ' -f1); do
            gpip install --user --upgrade $pkg;
        done) &
        python3_pid="$!"
    fi
    wait "${python_pid}" &> /dev/null
    wait "${python3_pid}" &> /dev/null
}

zsh-cleanup-directory() {
    find "$@" -iname '.ds_store|desktop.ini|thumbs.db|' -type f -delete
}

zsh-setup-save(){
    brew bundle dump --force --file="$HOME/.setup/Brewfile"
    code --list-extensions > vscode-extensions > "$HOME/.setup/vscode-extensions"
}

zsh-setup-run(){
    (cd "$HOME/.setup" && sh run.sh)
}