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

  services.flatpak.packages = [
    { appId = "dev.aunetx.deezer"; origin = "flathub";  }
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
    bitwarden
    protonvpn-cli
    protonvpn-gui

    # Multimedia
    tidal-hifi
    jellyfin-media-player
  ];

  # Music and media player 
  programs = {
    mpv.enable = true;
    eww = {
      enable = true;
      configDir = ./eww;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      sway = {
        default = [
          "wlr"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gtk"
        ];
      };
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
