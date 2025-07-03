{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.webstorm
    arduino-ide
    rpi-imager
    vscode
    zed-editor
    devbox
    bruno
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.kubectl ])
  ];

  home = {
    shellAliases = {
      # Go to fruition front folder and open webstorm from the local nix shell
      fruition-front = "direnv exec /data/workspace/fruition/fruition-front webstorm";
    };
  };
}
