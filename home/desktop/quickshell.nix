{ pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
  ];

  home.file.".config/quickshell" = {
    source = ./quickshell;
    recursive = true;
  };
}
