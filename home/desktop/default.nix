{ pkgs, inputs, ... }:

{
  imports = [
    inputs.flatpaks.homeManagerModules.nix-flatpak
    ../cli/ncmpcpp.nix
    ./kitty.nix
    ./rofi.nix
    ./dunst.nix
    ./gtk.nix
    ./sway.nix
    ./waybar.nix
    # ./hyprland.nix
  ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    packages = [
      { appId = "dev.aunetx.deezer"; origin = "flathub"; }
    ];
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    libnotify
    pavucontrol
    playerctl
    qdirstat

    # General
    grim # Screenshot
    slurp # Screenshot
    brave
    firefox-wayland

    # Security
    bitwarden
    protonvpn-cli
    protonvpn-gui

    # Multimedia
    jellyfin-media-player
    feishin
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
          "wlr"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
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
