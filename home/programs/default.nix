{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    pavucontrol
    playerctl
    networkmanagerapplet

    # General
    brave
    firefox-wayland
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # Security
    authy
    bitwarden

    # Multimedia
    beets
    tidal-hifi
    spotify
    jellyfin-media-player

    
  ];

}
