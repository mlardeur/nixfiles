# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

  fileSystems."/data" =
    {
      device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/59DA-76E0";
      fsType = "vfat";
    };

  fileSystems."/swap" =
    {
      device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Mount Internal disks SSD + HDD
  #fileSystems."/mnt/games" =
  #  {
  #    device = "/dev/disk/by-uuid/105B-1B7D";
  #    fsType = "exfat";
  #  };

  #fileSystems."/mnt/games-fast" =
  #  {
  #    device = "/dev/disk/by-uuid/6662-C567";
  #    fsType = "exfat";
  #  };

  # For mount.cifs, required unless domain name resolution is not needed.
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/zion" = {
    device = "//192.168.1.4/media";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  
        in
        [ "${automount_opts},uid=1000,gid=100,credentials=/etc/nixos/smb-zion-secrets" ];
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
}
