{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.webstorm
    jetbrains.rust-rover
    jetbrains.pycharm
#    arduino-ide
#    rpi-imager
#    distrobox
#    distrobox-tui
    vscode
    devbox
    podman-tui # Podman TUI for managing containers
    podman-compose # Podman compose for managing container stacks
    nvidia-container-toolkit # to use nvidia gpu inside containers
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.kubectl ])
  ];

  services.flatpak.packages = [
    { appId = "com.usebruno.Bruno"; origin = "flathub"; }
  ];

  home = {
    shellAliases = {
      # Go to fruition front folder and open webstorm from the local nix shell
      fruition-front = "direnv exec /data/workspace/fruition/fruition-front webstorm";
      pi-shell = "nix develop ~/dev/pi-shell";
    };
  };

  home.file."dev/pi-shell".source = ./pi-shell;

}
