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
        log "Fixing brew link overwrites"
        brew link --overwrite node pnpm
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

mac-set-display-drums() {
    log "Setting display up for playing drums"
    #  displayplacer list | grep -B1  "MacBook
    # id:s4251086178 - mode 54: res:1728x1117 hz:120 color_depth:8 scaling:on
    displayplacer "id:s4251086178 res:1728x1117 hz:120 color_depth:8 scaling:on"
    caffeinate -disu
}

mac-set-display-mobile() {
    log "Setting display up for mobile use"
    # s4251086178 - mode 72: res:2056x1329 hz:120 color_depth:8 scaling:on
    displayplacer "id:s4251086178 res:2056x1329 hz:120 color_depth:8 scaling:on"
}

mac-set-display-home() {
    log "Setting display up for home"
    displayplacer "id:0EF82C14-A4F0-4AE5-8086-731D0A4E6682 res:3008x1692 hz:60 color_depth:7 enabled:true scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 enabled:true scaling:on origin:(-1728,0) degree:0"
}
