#!/usr/bin/env bash
# Note: This script is on purpose externally and no more within setup.yml with Ansibles osx_default module.
#       It's easier to test for new macOS versions and deprecated settings

# Close any open System Preferences panes, to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Disable captitative portal assistant
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

# Disable hyperlink auditing beacon
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2HyperlinkAuditingEnabled -bool false

# Set language to for Microsoft Office Excel
defaults write com.microsoft.Excel AppleLanguages -array "de-CH"

#  Remove all tags in Finder
defaults write com.apple.finder FavoriteTagNames -array ""

# Remove all Dock items
defaults delete com.apple.dock persistent-apps

# Disable desktop icons
defaults write com.apple.finder CreateDesktop -bool false

# Save to disk (not to iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

# Disable creating .DS_STORE files on network
defaults write com.apple.desktopservices DSDontWriteNetworkStores -string true

# Disable creating .DS_STORE files on usb volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -string true

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable Airdrop
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

# Disable crash reporting
defaults write com.apple.CrashReporter DialogType -string none

# Set screenshot location to temp
defaults write com.apple.screencapture location -string "/tmp/"

# Empty trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Set faster key repetition speeds
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 25

# Force password on wake up
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -bool true
defaults write ~/Library/Preferences/com.apple.screensaver askForPassword -bool true

# Disable delay between starting the screen saver and locking the machine
sudo defaults -currentHost write /Library/Preferences/com.apple.screensaver askForPasswordDelay -bool false
defaults -currentHost write ~/Library/Preferences/com.apple.screensaver askForPasswordDelay -bool false

# Enable stealth mode
defaults write ~/Library/Preferences/com.apple.alf stealthenabled -bool true

# Disable infrared receiver
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false

# Disable power chime
sudo defaults write com.apple.PowerChime ChimeOnAllHardware -bool false
defaults write com.apple.PowerChime ChimeOnAllHardware -bool false

sudo defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true

# Disable system sounds
sudo nvram SystemAudioVolume=" "
sudo nvram SystemAudioVolumeDB=" "

# Expand all panes by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Increase window resize speed
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Use scroll gesture with the ctrl modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
