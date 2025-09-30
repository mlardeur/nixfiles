{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.webstorm
    jetbrains.rust-rover
    arduino-ide
    rpi-imager
    vscode
    zed-editor
    devbox
    podman-tui # Podman TUI for managing containers
    podman-compose # Podman compose for managing container stacks
    bruno
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.kubectl ])
  ];

  # Using Flatpaks
  services.flatpak.packages = [
    { appId = "io.podman_desktop.PodmanDesktop"; origin = "flathub"; }
  ];

  home = {
    shellAliases = {
      # Go to fruition front folder and open webstorm from the local nix shell
      fruition-front = "direnv exec /data/workspace/fruition/fruition-front webstorm";
    };
  };
}
