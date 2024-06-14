{ pkgs, ... }:
{

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    jetbrains-toolbox
    vscode
    devbox
    google-cloud-sdk
  ];

  services.flatpak = {
    packages = [
      { appId = "com.getpostman.Postman"; origin = "flathub"; }
    ];
  };
}
