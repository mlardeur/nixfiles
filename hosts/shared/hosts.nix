{ pkgs, ... }:

{
  networking.hosts = {
    "192.168.1.4" = [ "zion.local" ];
    "192.168.1.8" = [ "nebula.local" ];
  };
}
