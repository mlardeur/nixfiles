# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../shared/samba-mount.nix
      ../shared/hosts.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hera"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Configure keymap in X11
  services = {

    # Enable the X11 windowing system. Configure keymap in X11
    xserver = {
      xkb.layout = "us";
      xkb.options = "eurosign:e,caps:escape";
      videoDrivers = ["nvidia"];
    };

    # Enable CUPS to print documents.
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Enable sound.
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Greetd is a minimalistic login manager for Wayland and Linux virtual terminals.
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd river --sessions /home/maxime/.nix-profile/share/wayland-sessions";
          user = "maxime";
        };
      };
    };

    # List other services that must be enabled:
    # Mount, trash, and other functionalities
    gvfs.enable = true;
    # Thumbnail support for images
    tumbler.enable = true;
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    # Enable Flatpak
    flatpak.enable = true;
    # Tailscale VPN client
    tailscale.enable = true;

  };

  # NVIDIA GPU (moved out of hardware-configuration.nix, which is generated
  # by nixos-generate-config and must not be edited by hand).
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # S3 suspend/resume requires the driver to save/restore VRAM + display
    # state. With the open module on driver >= 595 this uses the kernel
    # suspend-notifier path (NVreg_UseKernelSuspendNotifiers=1), which replaces
    # the old nvidia-suspend/resume systemd units and their broken nvidia-sleep.sh
    # (nixpkgs #446671). This is the upstream fix for Blackwell/595 resume hangs.
    powerManagement = {
      enable = true;
      kernelSuspendNotifier = true; # default on open+>=595; explicit for clarity
      finegrained = false;          # RTD3/D3cold causes separate resume hangs
    };

    # Open module is REQUIRED for Blackwell (RTX 5060 Ti); do not set false.
    open = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # VRAM is dumped to TemporaryFilePath on suspend; the ~16G tmpfs at /tmp is
  # too small for this GPU's 16G VRAM and yields a blank screen on resume.
  # /var/tmp is on btrfs with ample free space.
  boot.kernelParams = [ "nvidia.NVreg_TemporaryFilePath=/var/tmp" ];

  # Enable NVIDIA container toolkit
  hardware.nvidia-container-toolkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  security.polkit.enable = true;
  # Disable the firewall
  networking.firewall.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxime = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" "wheel" "dialout" "podman" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      gh
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    openssl
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    cifs-utils # For mount.cifs
    exfatprogs # Format to exFat
    wireplumber # PipeWire session manager

    # Home Manager module
    home-manager
  ];

  # System programs
  programs.ssh.startAgent = true;
  programs.dconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-media-tags-plugin
      thunar-volman
      thunar-archive-plugin
    ];
  };

  # Enable QEMU and Virtual Machine Manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    # Create a `docker` alias for podman, to use it as a drop-in replacement
    dockerCompat = true;
    dockerSocket.enable = true;
    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;
  };
  # Enable IP forwarding for container networking
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = 1;

  mountSambaShares = {
    enable = true;
    uid = 1001;
    gid = 100;
  };

  # Home Manager installs the umbriel binary + wayland session in the user
  # profile; start-umbriel launches it through umbriel.service, so systemd
  # must know the package's user units (systemd.packages also feeds
  # /etc/systemd/user). restartIfChanged keeps rebuilds from killing a
  # running session. Everything else stays in home/desktop/umbriel.nix.
  systemd.packages = [ inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  systemd.user.services.umbriel = {
    restartIfChanged = false;
    enableDefaultPath = false;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

