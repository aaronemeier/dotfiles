#!/bin/zsh

mac-run-setup(){
    (cd "$HOME/.dotfiles" && sh setup.sh)
}

mac-update() {
    mac-update-system
    mac-update-npm
    mac-update-python
}

mac-update-system() {
    mac-update-mas
    mac-update-brew
}

mac-update-mas() {
    if [ -x "$(command -v mas)" ]; then
        echo -e '==>\e[1m Updating App Store apps \e[0m\n'
        mas upgrade
    else
        echo -e '==> \e[1m Error: brew not found\e[0m\n'
    fi
}

mac-update-brew() {
    if [ -x "$(command -v brew)" ]; then
        echo -e '==>\e[1m Updating Homebrew packages \e[0m\n'
        brew update
        brew upgrade
        brew cask upgrade
        brew cleanup -s
    else
        echo -e '==> \e[1m Error: brew not found\e[0m\n'
    fi        
}

mac-update-npm() {
    if [ -x "$(command -v npm)" ]; then
        echo -e '==>\e[1m Updating globally installed npm packages \e[0m\n'
        npm update -g
        npm install -g npm
    else
        echo -e '==> \e[1m Error: npm not found\e[0m\n'
    fi
}

mac-update-python() {
    if [ -x "$(command -v pip3)" ]; then
        echo -e '==> \e[1m Updating pip packages \e[0m\n'
        export PIP_REQUIRE_VIRTUALENV=""
        pip3 install --upgrade pip setuptools wheel
        for pkg in $(gpip list --outdated --format=freeze | cut -d'=' -f1); do
            pip3 install --user --upgrade $pkg;
        done
        unset PIP_REQUIRE_VIRTUALENV
    else
        echo -e '==> \e[1m Error: pip not found\e[0m\n'
    fi
}

mac-save-setup(){
    if [ -x "$(command -v brew)" ] && [ -x "$(command -v code)" ] &&
        [ -x "$(command -v pip3)" ] && [ -x "$(command -v npm)" ]; then
        echo -e '==> \e[1m Saving setup \e[0m\n'        
        brew bundle dump --force --file="$HOME/.dotfiles/packages/brew"
        code --list-extensions > "$HOME/.dotfiles/packages/vscode"
        export PIP_REQUIRE_VIRTUALENV=""
        pip3 list --user --not-required --format=freeze > "$HOME/.dotfiles/packages/pip"
        unset PIP_REQUIRE_VIRTUALENV
        npm list -g --depth=0 | sed -n 's/^├── \([a-zA-Z-]*\)@.*$/\1/p' > "$HOME/.dotfiles/packages/npm"
    else
        echo -e '==> \e[1m Error: at least one package manager is not installed \e[0m\n'
    fi
}

mac-cleanup-folder() {
    find "$@" -iname '.ds_store|desktop.ini|thumbs.db' -type f -delete
}