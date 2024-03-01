{ pkgs, ... }:

{
  imports = [
    ../cli/ncmpcpp.nix
    ./kitty.nix
    ./rofi.nix
    ./dunst.nix
    ./gtk.nix
    ./sway.nix
    ./waybar.nix
    # ./hyprland.nix
  ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    libnotify
    pavucontrol
    playerctl

    # General
    brave
    firefox-wayland

    # Security
    authy
    bitwarden
    protonvpn-gui

    # Multimedia
    # tidal-hifi
    spotify
    jellyfin-media-player

  ];

  # Music and media player 
  programs = {
    mpv.enable = true;
    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./eww;
    };
  };


  services = {
    mpd = {
      enable = true;
      network.listenAddress = "any";
    };
    mpd-mpris.enable = true;

    # Applets, shown in tray
    # Networking
    # network-manager-applet.enable = true;
  };
}
