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
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Check ansible
if [ -z "$(command -v ansible)" ]; then
    brew install ansible
fi

# Run ansible
ansible-playbook -c local --ask-pass setup.yml