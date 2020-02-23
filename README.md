# dotfiles
[![Build Status](https://travis-ci.org/aaronemeier/dotfiles.svg?branch=master)](https://travis-ci.org/aaronemeier/dotfiles)

Dotfiles and Ansible setup script

## Preparation
### Requirements
- Log into App Store
- Install Xcode via App Store

### Security
- Enable Filevault
- Enable Firewall
- Enable Firmware password

### Customization
- Adjust setup configuration
    - Edit setup/config.yml
    - Edit setup/hosts.yml
    - Edit setup/defaults.sh
- Setup Windows VM
    - Set network adapter to Shared (NAT)
    - Enable remote access via WinRM
```cmd
# Download latest setup script
Invoke-WebRequest https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile $env:temp/ConfigureRemotingForAnsible.ps1

# Enable remote access via WinRM
powershell.exe  -ExecutionPolicy Bypass -File $env:temp/ConfigureRemotingForAnsible.ps1 -CertValidityDays 3650
```

## Setup
```bash
git clone https://github.com/aaronemeier/dotfiles.git ~/.dotfiles
```

## Install
```bash
(cd ~/.dotfiles && sh setup.sh)
```