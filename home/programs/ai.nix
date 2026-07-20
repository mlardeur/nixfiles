{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    opencode
    opencode-desktop
  ];

}
