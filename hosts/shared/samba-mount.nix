{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.mountSambaShares;
in
{
  options.mountSambaShares = {
    enable = mkEnableOption "Enable mounting Samba shares";

    uid = mkOption {
      type = types.int;
      default = 1000;
      description = "User ID for the mounted shares";
    };

    gid = mkOption {
      type = types.int;
      default = 1000;
      description = "Group ID for the mounted shares";
    };

  };

  # Mount NAS folders
  config = mkIf cfg.enable
    {

      fileSystems."/mnt/nebula/media" = {
        device = "//192.168.1.8/media";
        fsType = "cifs";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
          "uid=${toString cfg.uid}"
          "gid=${toString cfg.gid}"
          "credentials=/etc/nixos/smb-nebula-secrets"
        ];
      };
      fileSystems."/mnt/nebula/archive" = {
        device = "//192.168.1.8/archive";
        fsType = "cifs";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
          "uid=${toString cfg.uid}"
          "gid=${toString cfg.gid}"
          "credentials=/etc/nixos/smb-nebula-secrets"
        ];
      };
      fileSystems."/mnt/nebula/maxime" = {
        device = "//192.168.1.8/maxime";
        fsType = "cifs";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
          "uid=${toString cfg.uid}"
          "gid=${toString cfg.gid}"
          "credentials=/etc/nixos/smb-nebula-secrets"
        ];
      };
    };
}
