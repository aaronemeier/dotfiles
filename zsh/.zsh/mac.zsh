# Helper functions for zsh on macOS
log(){
    printf "\n==>\e[1m $1 \e[0m\n"
}

mac-run-setup(){
    (cd "$DOTFILES" && sh macos.sh)
}

mac-update() {
    mac-update-system
    mac-update-npm
    mac-update-python
    mac-save
}

mac-update-system() {
    mac-update-mas
    mac-update-brew
}

mac-update-mas() {
    if [ -x "$(command -v mas)" ]; then
        log "Updating App Store apps"
        mas upgrade
    else
        log "Error: mas not found"
    fi
}

mac-update-brew() {
    if [ -x "$(command -v brew)" ]; then
        log "Updating Homebrew packages"
        brew upgrade && brew cleanup -s
    else
        log "Error: brew not found"
    fi        
}

mac-update-npm() {
    if [ -x "$(command -v npm)" ]; then
        log "Updating Node packages"
        npm update -g --force
    else
        log "Error: npm not found"
    fi
}

mac-update-python() {
    if [ -x "$(command -v pip3)" ]; then
        log "Updating Python packages"
        export PIP_REQUIRE_VIRTUALENV=""
        pip3 install --upgrade pip setuptools wheel
        for pkg in $(gpip list --outdated --format=freeze | cut -d'=' -f1); do
            pip3 install --user --upgrade $pkg;
        done
        unset PIP_REQUIRE_VIRTUALENV
    else
        log "Error: pip3 not found"
    fi
}

mac-save() {
    mac-save-brew
    mac-save-npm
    mac-save-python
}

mac-save-brew() {
    if [ -x "$(command -v brew)" ]; then
        log "Saving Homebrew packages"
        brew bundle dump --force --file="$DOTFILES/packages/brew"
        sed '/^$/d' "$DOTFILES/packages/brew"
    else
        log "Error: brew not found"
    fi
}

mac-save-npm() {
    if [ -x "$(command -v npm)" ]; then
        log "Saving Node packages"
        npm ls --parseable -g --depth=0 2&>/dev/null | sed -E 's/^(\/usr\/local\/lib)?(\/node_modules\/)?//g' > "$DOTFILES/packages/npm"
        sed '/^$/d' "$DOTFILES/packages/npm"
    else
        log "Error: npm not found"
    fi
}

mac-save-python() {
    if [ -x "$(command -v pip3)" ]; then
        log "Saving Python packages"
        export PIP_REQUIRE_VIRTUALENV=""
        pip3 list --user --not-required --format=freeze > "$DOTFILES/packages/pip"
        unset PIP_REQUIRE_VIRTUALENV
        sed '/^$/d' "$DOTFILES/packages/pip"
    else
        log "Error: pip3 not found"
    fi
}
