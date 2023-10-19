# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd"];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd"];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd"];
    };

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/59DA-76E0";
      fsType = "vfat";
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/32b89c33-9bc8-4ce2-966c-3157a3728720";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime"];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}