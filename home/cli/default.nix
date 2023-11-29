{ pkgs, ... }:

{
  imports = [
    ./git.nix
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

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    keys = [
      "id_ed25519"
    ];
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

  programs.starship = {
    enable = false;
    enableFishIntegration = false;
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline ];
    settings = { ignorecase = true; };
    extraConfig = ''
      set mouse=a
    '';
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # cli tools
    gitui
    git-town
    grc       # Console output colors
    htop      # Monitoring
    neofetch  
    grim      # Screenshot
    slurp     # Screenshot
    ranger    # File Browser
    zstd      # Archive tool

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
  ];
}
