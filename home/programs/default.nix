{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    gvfs

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
    spotify
    jellyfin-media-player

    # Music

  ];

}
