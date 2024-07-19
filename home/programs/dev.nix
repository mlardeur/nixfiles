{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    vscode
    devbox
    bruno
    google-cloud-sdk
  ];

  home = {
    shellAliases = {
      # Go to fruition front folder and open webstorm from the local nix shell
      fruition-front = "direnv exec /data/DevProjects/fruition/fruition-front webstorm";
    };
  };
}
