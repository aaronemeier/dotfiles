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
    if [ -x "$(command -v pipx)" ]; then
        log "Updating Python packages"
        pipx upgrade-all
    else
        log "Error: pip not found"
    fi
}

mac-update-ipm() {
    if [ -x "$(command -v ipm)" ]; then
        log "Updating Inkdrop packages"
        ipm update
    else
        log "Error: ipm not found"
    fi
}

mac-save() {
    mac-save-brew
    mac-save-npm
    mac-save-python
    mac-save-ipm
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
        npm ls --parseable -g --depth=0 2&>/dev/null | sed -E 's/^(\/opt\/homebrew\/lib)?(\/node_modules\/)?//g' > "$DOTFILES/packages/npm"
        sed '/^$/d' "$DOTFILES/packages/npm"
    else
        log "Error: npm not found"
    fi
}

mac-save-python() {
    if [ -x "$(command -v pipx)" ]; then
        log "Saving Python packages"
        pipx list --short | cut -d" " -f1 > "$DOTFILES/packages/pipx"
    else
        log "Error: pipx not found"
    fi
}

mac-save-ipm() {
    if [ -x "$(command -v ipm)" ]; then
        log "Saving Inkdrop packages"
        ipm list --bare --no-versions > "$DOTFILES/packages/ipm"
    else
        log "Error: ipm not found"
    fi  
}
