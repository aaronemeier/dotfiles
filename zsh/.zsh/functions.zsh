#!/bin/zsh

mac-run-setup(){
    (cd "$HOME/.setup" && sh run.sh)
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
        brew cleanup --outdated
        brew cask cleanup --outdated
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
    if [ -x "$(command -v pip)" ]; then
        echo -e '==> \e[1m Updating pip packages \e[0m\n'
        gpip install --upgrade pip
        for pkg in $(gpip list --outdated --format=freeze | cut -d'=' -f1); do
            gpip install --user --upgrade $pkg;
        done
    else
        echo -e '==> \e[1m Error: pip not found\e[0m\n'
    fi
}

mac-save-setup(){
    if [ -x "$(command -v brew)" ] || [ -x "$(command -v code)" ] ||
        [ -x "$(command -v pip)" ] ||[ -x "$(command -v npm)" ]; then
        echo -e '==> \e[1m Saving setup \e[0m\n'        
        brew bundle dump --force --file="$HOME/.setup/Brewfile"
        code --list-extensions > "$HOME/.setup/Vscodefile"
        gpip list --user --not-required --format=freeze > "$HOME/.setup/Pipfile"
        npm list -g --depth=0 | sed -n 's/^├── \([a-zA-Z-]*\)@.*$/\1/p' > "$HOME/.setup/Npmfile"
    else
        echo -e '==> \e[1m Error: at least one package manager is not installed \e[0m\n'
    fi
}

mac-cleanup-folder() {
    find "$@" -iname '.ds_store|desktop.ini|thumbs.db' -type f -delete
}