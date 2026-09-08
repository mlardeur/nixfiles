{ pkgs, lib, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.rust-rover
    jetbrains.pycharm
    host-spawn
    vscode
    devbox
    podman-tui # Podman TUI for managing containers
    podman-compose # Podman compose for managing container stacks
    nvidia-container-toolkit # to use nvidia gpu inside containers
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.kubectl ])
  ];

  services.flatpak.packages = [
    { appId = "com.usebruno.Bruno"; origin = "flathub"; }
    { appId = "com.jetbrains.WebStorm"; origin = "flathub"; }
  ];

  programs.fish.functions = {
    webstorm = {
      description = "Lance WebStorm Flatpak avec le PATH devbox courant";
      body = ''
        set -l sandbox_path /app/bin:/usr/bin
        flatpak run --env=PATH=(string join ':' $PATH)":$sandbox_path" com.jetbrains.WebStorm $argv
      '';
    };
  };

  home = {
    shellAliases = {
    };
  };

}
