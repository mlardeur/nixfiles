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
    neofetch
    ranger
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
