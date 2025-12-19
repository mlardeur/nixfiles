{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./ssh.nix
  ];

  programs.bash.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "git"; src = pkgs.fishPlugins.plugin-git.src; }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.autojump = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };

  fonts.fontconfig.enable = true;

  home = {
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  home.packages = with pkgs; [
    # cli tools
    grc # Console output colors
    htop # Monitoring
    fd # Find alternative
    eza # ls alternative
    neofetch
    ranger # File Browser
    zstd # Archive tool
    unzip
    lm_sensors

    # Fonts
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.hack
  ];
}
