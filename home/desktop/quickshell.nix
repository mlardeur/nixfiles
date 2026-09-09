{ pkgs, ... }:

let
  river-status = pkgs.callPackage ./river-status { };
in
{
  home.packages = with pkgs; [
    quickshell
    river-status
  ];

  home.file.".config/quickshell" = {
    source = ./quickshell;
    recursive = true;
  };
}
