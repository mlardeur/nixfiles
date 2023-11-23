{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.datagrip
    jetbrains.idea-community
    jetbrains.webstorm
    vscode
  ];

}
