# nixfiles

These are my Nixfiles that uses Flake and Home Manager for different systems 

## Setup
"""
git clone git@github.com:mlardeur/nixfiles.git
cd  nixfiles
""" 

### Nixos setup (Flake)
"""
sudo nixos-rebuild switch --flake .
"""

### Other Distro (Nix + Flake + HomeManager)
First init
If need git Init .config/home-manager 
"""
cd  ~/.config/home-manager
git init 

nix run home-manager/master -- init --switch
or 
nix run home-manager/release-23.05 -- init --switch

rm -rf ~/.config/home-manager
"""


Then to update after modification
"""
home-manager switch --flake .#username@hostname
"""

## Components by hosts 