{ pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  programs.bash.enable = true;
  programs.fish.enable = true;

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
    # Fish plugins
    fishPlugins.plugin-git

    #
    neofetch
    ranger
    zstd

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
