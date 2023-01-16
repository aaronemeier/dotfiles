#!/usr/bin/env bash

# Config
HOSTNAME=Dumbledore
DOTFILES="$HOME/.dotfiles"
ENV_CONFIG="$DOTFILES/shell/.shell/exports"
VSCODE_EXTENSIONS="md cfg ini conf ini sh zsh bat cmd xml plist nfo tex jinja2 yml yaml json css"
IINA_EXTENSIONS="mp3 flac aac wma ogg m4a mpg mkv wmv mp4 m4v"

# Ask for the administrator password upfront
sudo -v

log(){
    printf "\n==>\e[1m $1 \e[0m\n"
}

if [[ "$(xcode-select -p)" == "/Applications/Xcode.app/Contents/Developer" ]]; then
    log "Using CLI from XCode.app"
    sudo xcodebuild -license accept
elif [[ "$(xcode-select -p)" != "/Library/Developer/CommandLineTools" ]]; then
    log "Using CLI from system"
    sudo xcode-select --install
fi

if [ -z "$(command -v brew)" ]; then
    log "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

log "Linking dotfiles"
brew install stow
sh "$DOTFILES/dotfiles.sh"

log "Loading environment config"
source "$ENV_CONFIG"

log "Installing and updating brew packages"
brew bundle install --file="$DOTFILES/packages/brew"
brew cleanup -s

log "Enabling brew PATH in GUI"
sudo launchctl config user path "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

log "Installing pip packages"
unset PIP_REQUIRE_VIRTUALENV
pip3 install --user -r "$DOTFILES/packages/pip"

log "Installing npm packages"
while read -r item; do
    [[ "$item" != "" ]] && npm install --global "$item"
done < "$DOTFILES/packages/npm"

log "Installing Inkdrop packages"
ipm install --packages-file "$DOTFILES/packages/ipm"

log "Installing custom keyboard layouts"
cp "$DOTFILES/keylayouts/ABC with Umlauts.icns" "$HOME/Library/Keyboard Layouts/"
cp "$DOTFILES/keylayouts/ABC with Umlauts.keylayout" "$HOME/Library/Keyboard Layouts/"

log "Checking Paragon NTFS install"
[ ! -x "/Applications/NTFS for Mac.app" ] && open "/usr/local/Caskroom/paragon-ntfs/15/FSInstaller.app"

log "Checking Paragon EXTFS install"
[ ! -x "/Applications/EXTFS for Mac.app" ] && open "/usr/local/Caskroom/paragon-extfs/latest/FSInstaller.app"

log "Fixing wireshark permissions"
sudo chmod 0644 /etc/manpaths.d/Wireshark
sudo chmod 0644 /etc/paths.d/Wireshark

log "Setting shell to zsh"
sudo chsh -s /usr/local/bin/zsh "$USER"

log "Setting hostname"
sudo systemsetup -setcomputername "$HOSTNAME"
sudo scutil --set ComputerName "$HOSTNAME"
sudo scutil --set HostName "$HOSTNAME"
sudo scutil --set LocalHostName "$HOSTNAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName "$HOSTNAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription ""

log "Setting vscode file associations"
for e in $VSCODE_EXTENSIONS; do
    duti -s com.microsoft.VSCode ".$e" all
done
duti -s com.microsoft.VSCode public.plain-text all

log "Setting IINA file associations"
for e in $IINA_EXTENSIONS; do
    duti -s "com.colliderli.iina" ".$e" all
done

# macOS Settings: We're only changing hidden settings
log "Updating macOS settings"

# Close any open System Preferences panes, to prevent any interference
osascript -e 'tell application "System Preferences" to quit'

# Screenshot location and format
defaults write com.apple.screencapture location -string "/tmp/" && killall SystemUIServer
defaults write com.apple.screencapture type -string png

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Securely empty the trash by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Hide desktop icons
defaults write com.apple.finder CreateDesktop -bool false

# Disable autogathering large files when submitting a feedback report
defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool false

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable crash reporting dialogs
defaults write com.apple.CrashReporter DialogType -string none

# Disable infrared controller
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false

# Disable creating .DS_STORE files on network
defaults write com.apple.desktopservices DSDontWriteNetworkStores -string true

# Disable creating .DS_STORE files on usb volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -string true

# Set faster key repetition speeds
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 25

# Expand all panes by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Increase window resize speed
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Clean dock
defaults write com.apple.dock persistent-apps -array {}
defaults write com.apple.dock persistent-others -array {}
defaults write com.apple.dock recent-apps -array {}
killall Dock

# Clean finder
defaults write com.apple.finder FavoriteTagNames -array ""
killall Finder

# Set iTerm2 preferences
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES/sync/iterm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Set Alfred preferences
killall Alfred &> /dev/null
defaults write com.runningwithcrayons.Alfred-Preferences syncfolder -string "$DOTFILES/sync/alfred"
[ -x "/Applications/Alfred 5.app" ] && open "/Applications/Alfred 5.app"
