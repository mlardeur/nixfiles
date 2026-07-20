{ pkgs, lib, ... }:
{
  services.flatpak.packages = [
    { appId = "org.shotcut.Shotcut"; origin = "flathub"; }
  ];
}