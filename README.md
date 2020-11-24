# dotfiles
[![Build Status](https://gitlab.com/aaronemeier/dotfiles/badges/master/pipeline.svg)](https://gitlab.com/aaronemeier/dotfiles/-/commits/master)

Dotfiles and Ansible setup script

## Preparation
### Requirements
- Disable SIP in Recovery with `csrutil disable`
- Log into App Store
- Install Xcode via App Store and accept license `sudo xcodebuild -license accept`

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
