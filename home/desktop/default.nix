{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./rofi.nix
    ./gtk.nix
    ./sway.nix
    ./waybar.nix
    #    ./hyprland.nix
  ];

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
    tidal-hifi
    spotify
    jellyfin-media-player

  ];

  services = {
    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;
  };
}
