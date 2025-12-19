{ pkgs, inputs, ... }:

{

  imports = [
    inputs.flatpaks.homeManagerModules.nix-flatpak
  ];

  # Allow insecure packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-31.7.7"
  ];

  home.packages = with pkgs; [
    # System Tools
    qdirstat
    gparted
    mediawriter

    # Web browsers
    brave
    firefox

    # Security
    bitwarden-desktop

    # Multimedia
    # jellyfin-media-player temporarily disabled due to build issues
    feishin
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

}
