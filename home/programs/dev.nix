{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    vscode
    devbox
    google-cloud-sdk
  ];

}
