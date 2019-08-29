#!/usr/bin/env bash

if [[ "$(xcode-select -p)" == "/Applications/Xcode.app/Contents/Developer" ]]; then
    echo "Using CLI from XCode.app"
    sudo xcodebuild -license accept
elif [[ "$(xcode-select -p)" != "/Library/Developer/CommandLineTools" ]]; then
    echo "Using CLI from system"
    sudo xcode-select --install
fi

if [ -z "$(command -v brew)" ]; then
    echo "Install homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Check ansible
if [ -z "$(command -v ansible)" ]; then
    brew install ansible
fi

sudo -v

# Run ansible
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export ANSIBLE_STRING_CONVERSION_ACTION=ignore
(cd setup && ansible-playbook  --inventory hosts.yml setup.yml)