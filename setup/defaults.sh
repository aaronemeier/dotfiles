#!/usr/bin/env bash
# Note: This script is on purpose externally and no more within setup.yml with Ansibles osx_default module.
#       It's easier to test for new macOS versions and deprecated settings

# Disable captitative portal assistant
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active state=present -bool false

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

# Disable saving new files to iCloud
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

# Set screenshot image type to png
defaults write com.apple.screencapture type -string "png"

#  Disable Apple Bonjour service
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Empty trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Set timemachine backup interval to 24h
sudo defaults write /System/Library/LaunchDaemons/com.apple.backupd-auto StartInterval -int 86400

# Disable time machine prompt for new disks as backup volume
sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable time machine backup while on battery
sudo defaults write /Library/Preferences/com.apple.TimeMachine RequiresACPower -bool true

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

# Wake on Network Access feature is disabled
sudo systemsetup -setwakeonnetworkaccess off

# Destroy the File Vault key when going to standby mode
sudo pmset -a destroyfvkeyonstandby 1

# Store a copy of memory to persistent storage
sudo pmset -a hibernatemode 3