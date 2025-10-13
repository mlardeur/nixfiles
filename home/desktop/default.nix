{ pkgs, inputs, ... }:

{

  # Allow insecure packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-31.7.7"
  ];

  imports = [
    inputs.flatpaks.homeManagerModules.nix-flatpak
    ../cli/ncmpcpp.nix
    ./kitty.nix
    ./rofi.nix
    ./dunst.nix
    ./gtk.nix
    ./river
    ./sway.nix
    ./waybar.nix
    # ./hyprland.nix
  ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    packages = [
      { appId = "dev.aunetx.deezer"; origin = "flathub"; }
      { appId = "app.zen_browser.zen"; origin = "flathub"; }
      { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    ];
  };

  home.pointerCursor = {
    name = "Adwaita"; # or "Adwaita", "Capitaine Cursors", etc.
    package = pkgs.adwaita-icon-theme;  # replace with the correct package
    gtk.enable = true;              # apply to GTK applications too
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    libnotify
    pavucontrol
    playerctl
    qdirstat
    gparted
    mediawriter

    # General
    grim # Screenshot
    slurp # Screenshot
    kooha # Screen recorder
    brave
    firefox-wayland

    # Security
    bitwarden

    # Multimedia
    # jellyfin-media-player temporarily disabled due to build issues
    feishin
  ];

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

}
